Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2155C100
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbfGAQTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:19:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38878 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbfGAQTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 12:19:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A2F885546;
        Mon,  1 Jul 2019 16:19:10 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9855C2D34F;
        Mon,  1 Jul 2019 16:19:03 +0000 (UTC)
Date:   Mon, 1 Jul 2019 18:19:01 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v5 net-next 6/6] net: ethernet: ti: cpsw: add XDP
 support
Message-ID: <20190701181901.150c0b71@carbon>
In-Reply-To: <20190630172348.5692-7-ivan.khoronzhuk@linaro.org>
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
        <20190630172348.5692-7-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 01 Jul 2019 16:19:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 Jun 2019 20:23:48 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> +static int cpsw_ndev_create_xdp_rxq(struct cpsw_priv *priv, int ch)
> +{
> +	struct cpsw_common *cpsw = priv->cpsw;
> +	int ret, new_pool = false;
> +	struct xdp_rxq_info *rxq;
> +
> +	rxq = &priv->xdp_rxq[ch];
> +
> +	ret = xdp_rxq_info_reg(rxq, priv->ndev, ch);
> +	if (ret)
> +		return ret;
> +
> +	if (!cpsw->page_pool[ch]) {
> +		ret =  cpsw_create_rx_pool(cpsw, ch);
> +		if (ret)
> +			goto err_rxq;
> +
> +		new_pool = true;
> +	}
> +
> +	ret = xdp_rxq_info_reg_mem_model(rxq, MEM_TYPE_PAGE_POOL,
> +					 cpsw->page_pool[ch]);
> +	if (!ret)
> +		return 0;
> +
> +	if (new_pool) {
> +		page_pool_free(cpsw->page_pool[ch]);
> +		cpsw->page_pool[ch] = NULL;
> +	}
> +
> +err_rxq:
> +	xdp_rxq_info_unreg(rxq);
> +	return ret;
> +}

Looking at this, and Ilias'es XDP-netsec error handling path, it might
be a mistake that I removed page_pool_destroy() and instead put the
responsibility on xdp_rxq_info_unreg().

As here, we have to detect if page_pool_create() was a success, and then
if xdp_rxq_info_reg_mem_model() was a failure, explicitly call
page_pool_free() because the xdp_rxq_info_unreg() call cannot "free"
the page_pool object given it was not registered.  

Ivan's patch in[1], might be a better approach, which forced all
drivers to explicitly call page_pool_free(), even-though it just
dec-refcnt and the real call to page_pool_free() happened via
xdp_rxq_info_unreg().

To better handle error path, I would re-introduce page_pool_destroy(),
as a driver API, that would gracefully handle NULL-pointer case, and
then call page_pool_free() with the atomic_dec_and_test().  (It should
hopefully simplify the error handling code a bit)

[1] https://lore.kernel.org/netdev/20190625175948.24771-2-ivan.khoronzhuk@linaro.org/


> +void cpsw_ndev_destroy_xdp_rxqs(struct cpsw_priv *priv)
> +{
> +	struct cpsw_common *cpsw = priv->cpsw;
> +	struct xdp_rxq_info *rxq;
> +	int i;
> +
> +	for (i = 0; i < cpsw->rx_ch_num; i++) {
> +		rxq = &priv->xdp_rxq[i];
> +		if (xdp_rxq_info_is_reg(rxq))
> +			xdp_rxq_info_unreg(rxq);
> +	}
> +}

Are you sure you need to test xdp_rxq_info_is_reg() here?

You should just call xdp_rxq_info_unreg(rxq), if you know that this rxq
should be registered.  If your assumption failed, you will get a
WARNing, and discover your driver level bug.  This is one of the ways
the API is designed to "detect" misuse of the API.  (I found this
rather useful, when I converted the approx 12 drivers using this
xdp_rxq_info API).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
