Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE599137643
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgAJSm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:42:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44065 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbgAJSm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:42:27 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so2751125wrm.11
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 10:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=holDRIVtFGxVWNx61cnrWDFKGYqE1oHimk0403wiTkY=;
        b=IdHHYl3Jt9HpfvtCXQ4LHpQNjgn70TKTVvITx9cDpWabw6ti9fR6lEh6Ndet1LigZG
         uqsC2u2EYwc/aAfJNSa2i1SUDEn7REa9QRU4NQxWbSL/nDkij9XhmGi1xurHvFlTLnVK
         ve5IrdPz8cCn39CiPbcHNne7yfh4BaKnoOqBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=holDRIVtFGxVWNx61cnrWDFKGYqE1oHimk0403wiTkY=;
        b=rDc28xeiH28cRdtIbRasgO2puuBl0y0Mkdny2iUtC5IKwevoVogxvNEfPy7PykGN4C
         x1uIUkjlkh8CeSD4W53sLhQBzApopU49/irv+b3MJqfjQFBPd9r8MaKDEBQQQSG0JGsL
         YeyUD4NQMs/MuQL23R88xnsGvvOaoHhKz7tlPYUKY+CPmInAFhQs0CzyXnv0xEvn5r3O
         +3d+Fzk9mS1fdbizcshEL2d3FvTvbnCV3MPyQWcsc9AzdwYuIsLTWSqflAZmHb6AfdlM
         b6b73oVxBNdrZeQTW+g5+Xi0nmpvyRCJZ/+o7+hX9mXDhI3OabaR9xP/ux4VKfmwEpwi
         u3UA==
X-Gm-Message-State: APjAAAXUA5i79k/MPgyGgFQwoaMTClW+LlzVEnCXaIl5YeCtw09RWBMf
        kBm5ats5+7EPwybOswZ3xxJFSQ==
X-Google-Smtp-Source: APXvYqw89L7nd9nCarj+4SmN5kkTIr0PP21ips/MyZeE1Ni2DOAKgzDr4XPSHqEgTpytmg6nVKKDhA==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr4872849wrw.289.1578681745799;
        Fri, 10 Jan 2020 10:42:25 -0800 (PST)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id j12sm3196608wrt.55.2020.01.10.10.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 10:42:25 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Fri, 10 Jan 2020 13:42:14 -0500
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        netdev@vger.kernel.org, michael.chan@broadcom.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next] bnxt: Detach page from page pool before sending
 up the stack
Message-ID: <20200110184214.GA75497@C02YVCJELVCG.dhcp.broadcom.net>
References: <20200109193542.4171646-1-jonathan.lemon@gmail.com>
 <20200110021915.GA13304@C02YVCJELVCG>
 <402D3501-9EED-49F3-A5C8-003F78DD0D59@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <402D3501-9EED-49F3-A5C8-003F78DD0D59@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 09:14:42AM -0800, Jonathan Lemon wrote:
> Sure, on our FB systems, the reproduction is simple:
> 
> - Start an XDP program (which uses the page pool).
>   In our case, it's droplet.
> - Send normal traffic, so pages are released to the system.
> - Restart droplet (or do something which causes the
>   driver to re-initialize)  This frees and reallocates the
>   rings and page pool.
> 
> After a bit, observe incessant warnings about being unable
> to release the page pool due to pages inflight:
> 
> Jan  4 03:19:17 twtraffic0235.06.atn5.facebook.com kernel: [1941287.997351]
> page_pool_release_retry() stalled pool shutdown -1783494730 inflight 1451031
> sec
> Jan  4 03:19:24 twtraffic0235.06.atn5.facebook.com kernel: [1941295.031546]
> page_pool_release_retry() stalled pool shutdown -1962791719 inflight 1451040
> sec
> Jan  4 03:19:38 twtraffic0235.06.atn5.facebook.com kernel: [1941308.131831]
> page_pool_release_retry() stalled pool shutdown -1978246510 inflight 1451052
> sec
> Jan  4 03:19:57 twtraffic0235.06.atn5.facebook.com kernel: [1941327.842882]
> page_pool_release_retry() stalled pool shutdown -1893208809 inflight 1451072
> sec
> Jan  4 03:19:58 twtraffic0235.06.atn5.facebook.com kernel: [1941328.332587]
> page_pool_release_retry() stalled pool shutdown -1822809109 inflight 1451070
> sec
> Jan  4 03:20:10 twtraffic0235.06.atn5.facebook.com kernel: [1941340.994990]
> page_pool_release_retry() stalled pool shutdown -2064970262 inflight 1451087
> sec
> 
> Also note that if the count is negative, this triggers a
> kernel stack trace, which has a deleterious affect on the
> performance of the system.

Thanks.  I actually tried something similar this morning before you sent
this and was unable to reproduce at first.

I thought about it more and realized that I needed to send packets
larger than BNXT_RX_COPY_THRESH.  I see it now and will have more
feedback in a few mins.

> 
> 
> On 9 Jan 2020, at 18:19, Andy Gospodarek wrote:
> 
> > On Thu, Jan 09, 2020 at 11:35:42AM -0800, Jonathan Lemon wrote:
> > > When running in XDP mode, pages come from the page pool, and should
> > > be freed back to the same pool or specifically detached.  Currently,
> > > when the driver re-initializes, the page pool destruction is delayed
> > > forever since it thinks there are oustanding pages.
> > 
> > If you can please share a reproduction script/steps that would be
> > helpful for me.
> > 
> > Since this is an XDP_PASS case I can easily create a program that does
> > that, so no need to share that program -- just the sequence to remove
> > the program, shutdown the driver, whatever is done and the error you
> > see.
> > 
> > Thanks!
> > 
> > > 
> > > Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > ---
> > >  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > index 39d4309b17fb..33eb8cd6551e 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > @@ -944,6 +944,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct
> > > bnxt *bp,
> > >  	dma_addr -= bp->rx_dma_offset;
> > >  	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE,
> > > bp->rx_dir,
> > >  			     DMA_ATTR_WEAK_ORDERING);
> > > +	page_pool_release_page(rxr->page_pool, page);
> > > 
> > >  	if (unlikely(!payload))
> > >  		payload = eth_get_headlen(bp->dev, data_ptr, len);
> > > -- 
> > > 2.17.1
> > > 
