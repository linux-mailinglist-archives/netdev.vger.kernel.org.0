Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B895F55E
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 11:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfGDJTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 05:19:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42448 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727147AbfGDJTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 05:19:50 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9AFED3082129;
        Thu,  4 Jul 2019 09:19:49 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AF2D1001B1B;
        Thu,  4 Jul 2019 09:19:41 +0000 (UTC)
Date:   Thu, 4 Jul 2019 11:19:39 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v6 net-next 5/5] net: ethernet: ti: cpsw: add XDP
 support
Message-ID: <20190704111939.5d845071@carbon>
In-Reply-To: <20190703101903.8411-6-ivan.khoronzhuk@linaro.org>
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
        <20190703101903.8411-6-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 04 Jul 2019 09:19:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Jul 2019 13:19:03 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> Add XDP support based on rx page_pool allocator, one frame per page.
> Page pool allocator is used with assumption that only one rx_handler
> is running simultaneously. DMA map/unmap is reused from page pool
> despite there is no need to map whole page.
> 
> Due to specific of cpsw, the same TX/RX handler can be used by 2
> network devices, so special fields in buffer are added to identify
> an interface the frame is destined to. Thus XDP works for both
> interfaces, that allows to test xdp redirect between two interfaces
> easily. Aslo, each rx queue have own page pools, but common for both
> netdevs.
> 
> XDP prog is common for all channels till appropriate changes are added
> in XDP infrastructure. Also, once page_pool recycling becomes part of
> skb netstack some simplifications can be added, like removing
> page_pool_release_page() before skb receive.
> 
> In order to keep rx_dev while redirect, that can be somehow used in
> future, do flush in rx_handler, that allows to keep rx dev the same
> while reidrect. It allows to conform with tracing rx_dev pointed
> by Jesper.

So, you simply call xdp_do_flush_map() after each xdp_do_redirect().
It will kill RX-bulk and performance, but I guess it will work.

I guess, we can optimized it later, by e.g. in function calling
cpsw_run_xdp() have a variable that detect if net_device changed
(priv->ndev) and then call xdp_do_flush_map() when needed.


> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  drivers/net/ethernet/ti/Kconfig        |   1 +
>  drivers/net/ethernet/ti/cpsw.c         | 485 ++++++++++++++++++++++---
>  drivers/net/ethernet/ti/cpsw_ethtool.c |  66 +++-
>  drivers/net/ethernet/ti/cpsw_priv.h    |   7 +
>  4 files changed, 502 insertions(+), 57 deletions(-)
> 
[...]
> +static int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
> +			struct page *page)
> +{
> +	struct cpsw_common *cpsw = priv->cpsw;
> +	struct net_device *ndev = priv->ndev;
> +	int ret = CPSW_XDP_CONSUMED;
> +	struct xdp_frame *xdpf;
> +	struct bpf_prog *prog;
> +	u32 act;
> +
> +	rcu_read_lock();
> +
> +	prog = READ_ONCE(priv->xdp_prog);
> +	if (!prog) {
> +		ret = CPSW_XDP_PASS;
> +		goto out;
> +	}
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_PASS:
> +		ret = CPSW_XDP_PASS;
> +		break;
> +	case XDP_TX:
> +		xdpf = convert_to_xdp_frame(xdp);
> +		if (unlikely(!xdpf))
> +			goto drop;
> +
> +		cpsw_xdp_tx_frame(priv, xdpf, page);
> +		break;
> +	case XDP_REDIRECT:
> +		if (xdp_do_redirect(ndev, xdp, prog))
> +			goto drop;
> +
> +		/* as flush requires rx_dev to be per NAPI handle and there
> +		 * is can be two devices putting packets on bulk queue,
> +		 * do flush here avoid this just for sure.
> +		 */
> +		xdp_do_flush_map();

> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +		/* fall through */
> +	case XDP_ABORTED:
> +		trace_xdp_exception(ndev, prog, act);
> +		/* fall through -- handle aborts by dropping packet */
> +	case XDP_DROP:
> +		goto drop;
> +	}
> +out:
> +	rcu_read_unlock();
> +	return ret;
> +drop:
> +	rcu_read_unlock();
> +	page_pool_recycle_direct(cpsw->page_pool[ch], page);
> +	return ret;
> +}

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
