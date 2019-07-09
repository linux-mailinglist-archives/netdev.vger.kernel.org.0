Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C78996396A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 18:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfGIQcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 12:32:02 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33518 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfGIQcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 12:32:02 -0400
Received: by mail-pg1-f195.google.com with SMTP id m4so9731202pgk.0
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 09:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PHFAe8ip9pTwKVX+DJZoM1vwJIpXR+28V8WGYvacyHo=;
        b=Bu2/wyo8zEGohyH2x2mc3rHLuGpsUFJSc0r0OwmEejbPhLaA4QuV1Qrw5pLKrWhOEJ
         fmGp0zqjv8z0BBZH/g+UymiSllCvxgTsZfTzkjb1fBsonduj5VIrSVS9hqcaQ+VPvG8J
         mvxEBW+nfy58SignwNmd5y+kgV8D9LNouHVsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PHFAe8ip9pTwKVX+DJZoM1vwJIpXR+28V8WGYvacyHo=;
        b=j8mgoMbA6q2fsqF6ih1wmzux1wuUGMs60Zads5+I7abYBPIvEIrT4OnicqT5sA3DzU
         6bs81GmKBmB25YYbIu+FPQWa1H8QzlwNzXuhBdolrkgfXj/dcLLJEZSqk6LbZ5xuGXAl
         VUJQF+iEUllckkdxeW4WiwriBr2bMKZLfZgV0pMYNdB2dWT8VMmhT3QfwDHOWWC5zwXG
         mpSY8+TjvcA7NZHn5+shZj4JUenou5NvYpJUTYg9C9eOg66APtvDq9dhCZoOWuVVeDf2
         cGC1Zy2YuZcaBCXa/B6YkUFq77hDV7vxptCLCtE+fYBJRneTT1Jpr8Sxp84BjzgMR/+D
         UERw==
X-Gm-Message-State: APjAAAUOjmH684Vi5Kr1NdBdO04XbqBOZCD2vKgoaGASBZZT7daQjJzx
        ntRQjBPdYnhhz7mtQDE/iJRt9Q==
X-Google-Smtp-Source: APXvYqxbxMScrOrIPTNfi09euUY/TogSKBipilbnWTFSD4ZdP0gPb8iEXJqrvBV9QA0f0iGV5mxg0g==
X-Received: by 2002:a63:60c8:: with SMTP id u191mr29709906pgb.401.1562689921125;
        Tue, 09 Jul 2019 09:32:01 -0700 (PDT)
Received: from C02RW35GFVH8.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id q4sm3024368pjq.27.2019.07.09.09.31.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 09:32:00 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Tue, 9 Jul 2019 12:31:54 -0400
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bnxt_en: Add page_pool_destroy() during RX ring
 cleanup.
Message-ID: <20190709163154.GO87269@C02RW35GFVH8.dhcp.broadcom.net>
References: <1562658607-30048-1-git-send-email-michael.chan@broadcom.com>
 <20190709131842.GJ87269@C02RW35GFVH8.dhcp.broadcom.net>
 <20190709152057.GA4452@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709152057.GA4452@apalos>
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 06:20:57PM +0300, Ilias Apalodimas wrote:
> Hi,
> 
> > > Add page_pool_destroy() in bnxt_free_rx_rings() during normal RX ring
> > > cleanup, as Ilias has informed us that the following commit has been
> > > merged:
> > > 
> > > 1da4bbeffe41 ("net: core: page_pool: add user refcnt and reintroduce page_pool_destroy")
> > > 
> > > The special error handling code to call page_pool_free() can now be
> > > removed.  bnxt_free_rx_rings() will always be called during normal
> > > shutdown or any error paths.
> > > 
> > > Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
> > > Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > > Cc: Andy Gospodarek <gospo@broadcom.com>
> > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > > ---
> > >  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++------
> > >  1 file changed, 2 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > index e9d3bd8..2b5b0ab 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > @@ -2500,6 +2500,7 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
> > >  		if (xdp_rxq_info_is_reg(&rxr->xdp_rxq))
> > >  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> > >  
> > > +		page_pool_destroy(rxr->page_pool);
> > >  		rxr->page_pool = NULL;
> > >  
> > >  		kfree(rxr->rx_tpa);
> > > @@ -2560,19 +2561,14 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
> > >  			return rc;
> > >  
> > >  		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
> > > -		if (rc < 0) {
> > > -			page_pool_free(rxr->page_pool);
> > > -			rxr->page_pool = NULL;
> > > +		if (rc < 0)
> > >  			return rc;
> > > -		}
> > >  
> > >  		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
> > >  						MEM_TYPE_PAGE_POOL,
> > >  						rxr->page_pool);
> > >  		if (rc) {
> > >  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> > > -			page_pool_free(rxr->page_pool);
> > > -			rxr->page_pool = NULL;
> > 
> > Rather than deleting these lines it would also be acceptable to do:
> > 
> >                 if (rc) {
> >                         xdp_rxq_info_unreg(&rxr->xdp_rxq);
> > -                       page_pool_free(rxr->page_pool);
> > +                       page_pool_destroy(rxr->page_pool);
> >                         rxr->page_pool = NULL;
> >                         return rc;
> >                 }
> > 
> > but anytime there is a failure to bnxt_alloc_rx_rings the driver will
> > immediately follow it up with a call to bnxt_free_rx_rings, so
> > page_pool_destroy will be called.
> > 
> > Thanks for pushing this out so quickly!
> > 
> 
> I also can't find page_pool_release_page() or page_pool_put_page() called when
> destroying the pool. Can you try to insmod -> do some traffic -> rmmod ?
> If there's stale buffers that haven't been unmapped properly you'll get a
> WARN_ON for them.

I did that test a few times with a few different bpf progs but I do not
see any WARN messages.  Of course this does not mean that the code we
have is 100% correct.

Presumably you are talking about one of these messages, right?

215         /* The distance should not be able to become negative */
216         WARN(inflight < 0, "Negative(%d) inflight packet-pages", inflight);

or

356         /* Drivers should fix this, but only problematic when DMA is used */
357         WARN(1, "Still in-flight pages:%d hold:%u released:%u",
358              distance, hold_cnt, release_cnt);


> This part was added later on in the API when Jesper fixed in-flight packet
> handling
