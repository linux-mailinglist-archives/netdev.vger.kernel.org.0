Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357AA29D9D1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390064AbgJ1XDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:03:01 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46224 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731811AbgJ1XDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:03:01 -0400
Received: by mail-pl1-f195.google.com with SMTP id p17so351766pli.13;
        Wed, 28 Oct 2020 16:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CNA7UvO0rC3OicpN5FLfXwig0Y0tAaVI6smQ5o7BPyY=;
        b=oevzLVOKkBM5WNY8SpRE2a6oFmGTJfC+7iR9r+5iXJcSzAC9jJ+P6WGhEwZbxXvoWN
         2eZXZFqjYzjpMrg1K37Lm0ciiUTi3jN473pnJ6IStCaoKL2YgOUut6rBkjOEIxhpob7o
         C402cN+dmWeNzmdjNKy8v7S/jjsMSgVHX2iLxUST5n3d987IvbUOKZQ8kW8iWslXKwUL
         SQq/TrYi+JisR6ccHir01rsnQJT3LacavDDNnyeaZWF24+cshjPNzuIvha9jeAmFP6LW
         IG93cgeR/bOzG3O3r9fPX0dnNGMYQbm4CzxxJDd2aE4irebuBAKU6MeelrdDl3VBJCYp
         w8GA==
X-Gm-Message-State: AOAM533imzRdTB9Pyntj7jBk1Ya/Li6ba7rBt+p2HTNCwLZKqvtMorer
        bz54eJlDlPz6uF6C2qYI3fR4SOUu2Ks=
X-Google-Smtp-Source: ABdhPJzQI5DMqt/ij1UO69AkLiPauhiT4KID2J0Ph8ydetjDXOGy1vJYyhcj5KdzUHGF6RRU3q86vg==
X-Received: by 2002:a17:902:d896:b029:d2:288e:bafc with SMTP id b22-20020a170902d896b02900d2288ebafcmr5063573plz.43.1603850351126;
        Tue, 27 Oct 2020 18:59:11 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1161:a4cc:eef9:fbc0:2781])
        by smtp.gmail.com with ESMTPSA id z13sm3213153pgc.44.2020.10.27.18.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 18:59:10 -0700 (PDT)
Date:   Tue, 27 Oct 2020 18:59:09 -0700
From:   Moritz Fischer <mdf@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moritz Fischer <mdf@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lucyyan@google.com,
        moritzf@google.com, James.Bottomley@hansenpartnership.com
Subject: Re: [PATCH/RFC net-next v3] net: dec: tulip: de2104x: Add shutdown
 handler to stop NIC
Message-ID: <20201028015909.GA52884@epycbox.lan>
References: <20201023202834.660091-1-mdf@kernel.org>
 <20201027161606.477a445e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027161606.477a445e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Oct 27, 2020 at 04:16:06PM -0700, Jakub Kicinski wrote:
> On Fri, 23 Oct 2020 13:28:34 -0700 Moritz Fischer wrote:
> > diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
> > index d9f6c19940ef..ea7442cc8e75 100644
> > --- a/drivers/net/ethernet/dec/tulip/de2104x.c
> > +++ b/drivers/net/ethernet/dec/tulip/de2104x.c
> > @@ -2175,11 +2175,19 @@ static int __maybe_unused de_resume(struct device *dev_d)
> >  
> >  static SIMPLE_DEV_PM_OPS(de_pm_ops, de_suspend, de_resume);
> >  
> > +static void de_shutdown(struct pci_dev *pdev)
> > +{
> > +	struct net_device *dev = pci_get_drvdata(pdev);
> > +
> > +	de_close(dev);
> 
> Apparently I get all the best ideas when I'm about to apply something..

Better now than after =)

> I don't think you can just call de_close() like that, because 
> (a) it may expect rtnl_lock() to be held, and (b) it may not be open.

how about:

rtnl_lock();
if (netif_running(dev))
	dev_close(dev);
rtnl_unlock();

> 
> Perhaps call unregister_netdev(dev) - that'll close the device.
> Or rtnl_lock(); dev_close(dev); rtnl_unlock();
> 
> > +}
> > +
> >  static struct pci_driver de_driver = {
> >  	.name		= DRV_NAME,
> >  	.id_table	= de_pci_tbl,
> >  	.probe		= de_init_one,
> >  	.remove		= de_remove_one,
> > +	.shutdown	= de_shutdown,
> >  	.driver.pm	= &de_pm_ops,
> >  };
> >  
> 

Cheers,
Moritz
