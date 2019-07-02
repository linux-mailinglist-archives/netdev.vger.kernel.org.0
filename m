Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643DA5D0C8
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfGBNjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfGBNjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 09:39:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1F5F3082A27;
        Tue,  2 Jul 2019 13:39:11 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B38AE7DF53;
        Tue,  2 Jul 2019 13:39:03 +0000 (UTC)
Date:   Tue, 2 Jul 2019 15:39:02 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v5 net-next 6/6] net: ethernet: ti: cpsw: add XDP
 support
Message-ID: <20190702153902.0e42b0b2@carbon>
In-Reply-To: <20190702113738.GB4510@khorivan>
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
        <20190630172348.5692-7-ivan.khoronzhuk@linaro.org>
        <20190701181901.150c0b71@carbon>
        <20190702113738.GB4510@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 02 Jul 2019 13:39:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jul 2019 14:37:39 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> On Mon, Jul 01, 2019 at 06:19:01PM +0200, Jesper Dangaard Brouer wrote:
> >On Sun, 30 Jun 2019 20:23:48 +0300
> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
> >  
> >> +static int cpsw_ndev_create_xdp_rxq(struct cpsw_priv *priv, int ch)
> >> +{
> >> +	struct cpsw_common *cpsw = priv->cpsw;
> >> +	int ret, new_pool = false;
> >> +	struct xdp_rxq_info *rxq;
> >> +
> >> +	rxq = &priv->xdp_rxq[ch];
> >> +
> >> +	ret = xdp_rxq_info_reg(rxq, priv->ndev, ch);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	if (!cpsw->page_pool[ch]) {
> >> +		ret =  cpsw_create_rx_pool(cpsw, ch);
> >> +		if (ret)
> >> +			goto err_rxq;
> >> +
> >> +		new_pool = true;
> >> +	}
> >> +
> >> +	ret = xdp_rxq_info_reg_mem_model(rxq, MEM_TYPE_PAGE_POOL,
> >> +					 cpsw->page_pool[ch]);
> >> +	if (!ret)
> >> +		return 0;
> >> +
> >> +	if (new_pool) {
> >> +		page_pool_free(cpsw->page_pool[ch]);
> >> +		cpsw->page_pool[ch] = NULL;
> >> +	}
> >> +
> >> +err_rxq:
> >> +	xdp_rxq_info_unreg(rxq);
> >> +	return ret;
> >> +}  
> >
> >Looking at this, and Ilias'es XDP-netsec error handling path, it might
> >be a mistake that I removed page_pool_destroy() and instead put the
> >responsibility on xdp_rxq_info_unreg().  
>
> As for me this is started not from page_pool_free, but rather from calling
> unreg_mem_model from rxq_info_unreg. Then, if page_pool_free is hidden
> it looks more a while normal to move all chain to be self destroyed.
> 
> >
> >As here, we have to detect if page_pool_create() was a success, and then
> >if xdp_rxq_info_reg_mem_model() was a failure, explicitly call
> >page_pool_free() because the xdp_rxq_info_unreg() call cannot "free"
> >the page_pool object given it was not registered.  
>
> Yes, it looked a little bit ugly from the beginning, but, frankly,
> I have got used to this already.
> 
> >
> >Ivan's patch in[1], might be a better approach, which forced all
> >drivers to explicitly call page_pool_free(), even-though it just
> >dec-refcnt and the real call to page_pool_free() happened via
> >xdp_rxq_info_unreg().
> >
> >To better handle error path, I would re-introduce page_pool_destroy(),
>
> So, you might to do it later as I understand, and not for my special
> case but becouse it makes error path to look a little bit more pretty.
> I'm perfectly fine with this, and better you add this, for now my
> implementation requires only "xdp: allow same allocator usage" patch,
> but if you insist I can resend also patch in question afterwards my
> series is applied (with modification to cpsw & netsec & mlx5 & page_pool).
> 
> What's your choice? I can add to your series patch needed for cpsw to
> avoid some misuse.

I will try to create a cleaned-up version of your patch[1] and
re-introduce page_pool_destroy() for drivers to use, then we can build
your driver on top of that.


> >as a driver API, that would gracefully handle NULL-pointer case, and
> >then call page_pool_free() with the atomic_dec_and_test().  (It should
> >hopefully simplify the error handling code a bit)
> >
> >[1] https://lore.kernel.org/netdev/20190625175948.24771-2-ivan.khoronzhuk@linaro.org/
[...]

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
