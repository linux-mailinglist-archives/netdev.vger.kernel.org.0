Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406F2646C88
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 11:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiLHKQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 05:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLHKQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 05:16:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A57BD0;
        Thu,  8 Dec 2022 02:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cZJlvK29yhTG37sbW6N+t9rA+CdyXKbUNP4rSo2MEs0=; b=Sd9U/8wCa0tIufAay9GKknyw3C
        ts4rH3Hy5xnLfHFwtp+lNLAxJ6pr8k7eDKjD348S+XJ5Y5ahEODCpNCkd3BwPkeMFH4sSF71H+3i6
        xeO3RlYUhMdpoW7w/OEh/Kb+pvsSzqGqUBBaeFIjpWPedmcwvjoHq+HlAlBpklthLZEj7hWhEoBmU
        YtOubiqYfY3DsXQ68xct68HE/77o93qkoj/CAs7Z6p+NxClBwPXCIQPDjO8hoR8Mc9mIzLgCk8n2D
        DbBhw579AhuCYoiQLj2e3sI7sLE+8x39ftCwogb245Hrep5gR+5OihRqb8m8a1rndphIO1lCMNbha
        BA0IzL2g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35628)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p3Dwo-0001Za-0S; Thu, 08 Dec 2022 10:16:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p3Dwl-0001cC-Gb; Thu, 08 Dec 2022 10:16:07 +0000
Date:   Thu, 8 Dec 2022 10:16:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>
Subject: Re: [PATCH RFC 1/2] i2c: add fwnode APIs
Message-ID: <Y5G5ZyO1XRgjfN90@shell.armlinux.org.uk>
References: <Y5B3S6KZTrYlIH8g@shell.armlinux.org.uk>
 <E1p2sVM-009tqA-Vq@rmk-PC.armlinux.org.uk>
 <Y5G2kkGC69FVWaiK@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5G2kkGC69FVWaiK@black.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mika,

On Thu, Dec 08, 2022 at 12:04:02PM +0200, Mika Westerberg wrote:
> Hi,
> 
> On Wed, Dec 07, 2022 at 11:22:24AM +0000, Russell King (Oracle) wrote:
> > +struct i2c_client *i2c_find_device_by_fwnode(struct fwnode_handle *fwnode)
> > +{
> > +	struct i2c_client *client;
> > +	struct device *dev;
> > +
> > +	if (!fwnode)
> > +		return NULL;
> > +
> > +	dev = bus_find_device_by_fwnode(&i2c_bus_type, fwnode);
> > +	if (!dev)
> > +		return NULL;
> > +
> > +	client = i2c_verify_client(dev);
> > +	if (!client)
> > +		put_device(dev);
> > +
> > +	return client;
> > +}
> > +EXPORT_SYMBOL(i2c_find_device_by_fwnode);
> > +
> 
> Drop this empty line.

The additional empty line was there before, and I guess is something the
I2C maintainer wants to logically separate the i2c device stuff from
the rest of the file.

> > +/* must call put_device() when done with returned i2c_client device */
> > +struct i2c_client *i2c_find_device_by_fwnode(struct fwnode_handle *fwnode);
> 
> With the kernel-docs in place you probably can drop these comments.

It's what is there against the other prototypes - and is very easy to
get wrong, as I've recently noticed in the sfp.c code as a result of
creating this series.

I find the whole _find_ vs _get_ thing a tad confusing, and there
probably should be just one interface with one way of putting
afterwards to avoid subtle long-standing bugs like this.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
