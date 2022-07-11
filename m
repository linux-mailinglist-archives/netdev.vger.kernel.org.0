Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B7A570C45
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 22:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiGKU7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 16:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiGKU7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 16:59:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D292D5F6E;
        Mon, 11 Jul 2022 13:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2pS0dMuYYgeHNJqIl/bhPdJtlCRa5yVxxQQ48oLzz2A=; b=Waum5YhtqoS3xBHTC07cw9nhpR
        Qk61iCzjsqffRwb4prDOOhd4ziN64ZzfEPEXbi+aRZG20qr2v1OOcMbkiV388ZeIpQXBYqfUA79ZS
        aahz3fRfUzHVMwjFWVvrhtnfHNo116v/P0lw3kMDWOEMWC2IcbE475H+MMgseQbbuh/b6SGgTzv58
        310H6CLYhKMl/4s9w68+igJ25NcXYkgkoMgchr1PT45aG8uv5Q5LbEqfIX+/hDgTPT/Wp2pcrPxZR
        Wux7J+wt1SMSWOhoRPzzQIZsz7QK5vwy+/PxB6ox8anZPoHrD/TwjGWtpHedihfX4SdFNV7FStlz6
        jEuzCh+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33294)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oB0Ul-0001fu-TV; Mon, 11 Jul 2022 21:59:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oB0Ui-00043W-L9; Mon, 11 Jul 2022 21:59:04 +0100
Date:   Mon, 11 Jul 2022 21:59:04 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH net-next 3/9] net: pcs: Add helpers for registering
 and finding PCSs
Message-ID: <YsyPGMOiIGktUlqD@shell.armlinux.org.uk>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-4-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711160519.741990-4-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

It's a good attempt and may be nice to have, but I'm afraid the
implementation has a flaw to do with the lifetime of data structures
which always becomes a problem when we have multiple devices being
used in aggregate.

On Mon, Jul 11, 2022 at 12:05:13PM -0400, Sean Anderson wrote:
> +/**
> + * pcs_get_tail() - Finish getting a PCS
> + * @pcs: The PCS to get, or %NULL if one could not be found
> + *
> + * This performs common operations necessary when getting a PCS (chiefly
> + * incrementing reference counts)
> + *
> + * Return: @pcs, or an error pointer on failure
> + */
> +static struct phylink_pcs *pcs_get_tail(struct phylink_pcs *pcs)
> +{
> +	if (!pcs)
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	if (!try_module_get(pcs->ops->owner))
> +		return ERR_PTR(-ENODEV);

What you're trying to prevent here is the PCS going away - but holding a
reference to the module doesn't prevent that with the driver model. The
driver model design is such that a device can be unbound from its driver
at any moment. Taking a reference to the module doesn't prevent that,
all it does is ensure that the user can't remove the module. It doesn't
mean that the "pcs" structure will remain allocated.

The second issue that this creates is if a MAC driver creates the PCS
and then "gets" it through this interface, then the MAC driver module
ends up being locked in until the MAC driver devices are all unbound,
which isn't friendly at all.

So, anything that proposes to create a new subsystem where we have
multiple devices that make up an aggregate device needs to nicely cope
with any of those devices going away. For that to happen in this
instance, phylink would need to know that its in-use PCS for a
particular MAC is going away, then it could force the link down before
removing all references to the PCS device.

Another solution would be devlinks, but I am really not a fan of that
when there may be a single struct device backing multiple network
interfaces, where some of them may require PCS and others do not. One
wouldn't want the network interface with nfs-root to suddenly go away
because a PCS was unbound from its driver!

> +	get_device(pcs->dev);

This helps, but not enough. All it means is the struct device won't
go away, the "pcs" can still go away if the device is unbound from the
driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
