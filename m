Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91C160526
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 13:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfGELOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 07:14:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfGELOH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 07:14:07 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5538F34CF;
        Fri,  5 Jul 2019 11:14:06 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F6ED7F76E;
        Fri,  5 Jul 2019 11:13:56 +0000 (UTC)
Date:   Fri, 5 Jul 2019 13:13:54 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v7 net-next 5/5] net: ethernet: ti: cpsw: add XDP
 support
Message-ID: <20190705131354.15a9313c@carbon>
In-Reply-To: <20190704231406.27083-6-ivan.khoronzhuk@linaro.org>
References: <20190704231406.27083-1-ivan.khoronzhuk@linaro.org>
        <20190704231406.27083-6-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 05 Jul 2019 11:14:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 02:14:06 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> +static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
> +			     struct page *page)
> +{
> +	struct cpsw_common *cpsw = priv->cpsw;
> +	struct cpsw_meta_xdp *xmeta;
> +	struct cpdma_chan *txch;
> +	dma_addr_t dma;
> +	int ret, port;
> +
> +	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
> +	xmeta->ndev = priv->ndev;
> +	xmeta->ch = 0;
> +	txch = cpsw->txv[0].ch;
> +
> +	port = priv->emac_port + cpsw->data.dual_emac;
> +	if (page) {
> +		dma = page_pool_get_dma_addr(page);
> +		dma += xdpf->data - (void *)xdpf;

This code is only okay because this only happens for XDP_TX, where you
know this head-room calculation will be true.  The "correct"
calculation of the head-room would be:

  dma += xdpf->headroom + sizeof(struct xdp_frame);

The reason behind not using xdpf pointer itself as "data_hard_start",
is to allow struct xdp_frame to be located in another memory area.
This will be useful for e.g. AF_XDP transmit, or other zero-copy
transmit to go through ndo_xdp_xmit() (as we don't want userspace to
be-able to e.g. "race" change xdpf->len during transmit/DMA-completion).


> +		ret = cpdma_chan_submit_mapped(txch, cpsw_xdpf_to_handle(xdpf),
> +					       dma, xdpf->len, port);
> +	} else {
> +		if (sizeof(*xmeta) > xdpf->headroom) {
> +			xdp_return_frame_rx_napi(xdpf);
> +			return -EINVAL;
> +		}
> +
> +		ret = cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf),
> +					xdpf->data, xdpf->len, port);
> +	}



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
