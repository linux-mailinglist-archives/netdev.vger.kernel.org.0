Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F312967E3
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 02:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373737AbgJWAP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 20:15:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38577 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373727AbgJWAP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 20:15:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id j7so2069256pgk.5;
        Thu, 22 Oct 2020 17:15:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nJuvv8IL2p3H3QZp8m2iSM8qkccByy2xhG+R9HNdsCs=;
        b=SF8WLgxrdQ21PFMbugp4WbrMXswElufb2YP2VOo+IgsGfr4aAUYNI9ObI38l89vpTL
         8tOpdyhv4XhF/0ObZMS3CiQIPAp80o0ix20uAnFTTVvjJqAmYMJkb2ZtNOu/uRXmLdBK
         mfdGgj66sKsA5Z9/VSIaFXix+AcMxBxwcn0BKff5sGkKmSWKwl0FeTr2HhBRcOhGo+KA
         CHx+U3oXf8D1nvjGusM0GM1Eylsa38p7AbyIacXjB21KG/u0Kye80wpOyVaA4wYI6dtL
         qSjEPH6cbcD3N/KI2Fb2eY1mMkDkFtV7SUnVba+nsUnIc0VpPzxP9NEWbKFBx2/1XnzF
         T5fA==
X-Gm-Message-State: AOAM530U12Q45Wy0ArwbEvN4U8juJFQHjAqWx6i3ZFjaybksZz87pyWD
        jFvxjH7lEOwGALZdbTelTh8=
X-Google-Smtp-Source: ABdhPJzlSCn1Jx4Lbr89cvlqse38aVOniqNXgGBir7jh1wf05/RXLm/4UMRiic8qg0fAMCNa7xvFdg==
X-Received: by 2002:a17:90a:7f93:: with SMTP id m19mr5102760pjl.67.1603412125534;
        Thu, 22 Oct 2020 17:15:25 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1161:a4cc:eef9:fbc0:2781])
        by smtp.gmail.com with ESMTPSA id f21sm3503438pfn.173.2020.10.22.17.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 17:15:24 -0700 (PDT)
Date:   Thu, 22 Oct 2020 17:15:23 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Moritz Fischer <mdf@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lucyyan@google.com
Subject: Re: [PATCH/RFC net] net: dec: tulip: de2104x: Add shutdown handler
 to stop NIC
Message-ID: <20201023001523.GA620527@epycbox.lan>
References: <20201022220636.609956-1-mdf@kernel.org>
 <f1ff32ec2970f1ee808e2da946e6514e71694e71.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1ff32ec2970f1ee808e2da946e6514e71694e71.camel@HansenPartnership.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 04:04:16PM -0700, James Bottomley wrote:
> On Thu, 2020-10-22 at 15:06 -0700, Moritz Fischer wrote:
> > The driver does not implement a shutdown handler which leads to
> > issues
> > when using kexec in certain scenarios. The NIC keeps on fetching
> > descriptors which gets flagged by the IOMMU with errors like this:
> > 
> > DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> > DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> > DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> > DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> > DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
> > 
> > Signed-off-by: Moritz Fischer <mdf@kernel.org>
> > ---
> > 
> > Hi all,
> > 
> > I'm not sure if this is the proper way for a shutdown handler,
> > I've tried to look at a bunch of examples and couldn't find a
> > specific
> > solution, in my tests on hardware this works, though.
> > 
> > Open to suggestions.
> > 
> > Thanks,
> > Moritz
> > 
> > ---
> >  drivers/net/ethernet/dec/tulip/de2104x.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c
> > b/drivers/net/ethernet/dec/tulip/de2104x.c
> > index f1a2da15dd0a..372c62c7e60f 100644
> > --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> > +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> > @@ -2185,6 +2185,7 @@ static struct pci_driver de_driver = {
> >  	.id_table	= de_pci_tbl,
> >  	.probe		= de_init_one,
> >  	.remove		= de_remove_one,
> > +	.shutdown	= de_remove_one,
> 
> This doesn't look right: shutdown is supposed to turn off the device
> without disturbing the tree or causing any knock on effects (I think
> that rule is mostly because you don't want anything in userspace
> triggering since it's likely to be nearly dead).  Remove removes the
> device from the tree and cleans up everything.  I think the function
> you want that's closest to what shutdown needs is de_close().  That
> basically just turns off the chip and frees the interrupt ... you'll
> have to wrapper it to call it from the pci_driver, though.

Thanks for the suggestion, I like that better. I'll send a v2 after
testing.
I think anything that hits on de_stop_hw() will keep the NIC from
fetching further descriptors.

Cheers,
Moritz
