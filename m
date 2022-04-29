Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DC051509B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378976AbiD2QV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378565AbiD2QV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:21:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862BBD76D8
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 09:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EoYyipmLkLzjC3Nq0KiHeolQGzPkCYAo00j3yAsVu9o=; b=d3cMpFCRwwb0SURIpM0O9dPF/y
        FhGW0VLoB2RjDFGQZ6AG5Pp50JBskOuEdTx346sUCR69ARlx5onYb753N7DMX0/j1GijSD+YvOz+I
        M7r3g55sqS6JTCc6vjntRo0rMuyEC0RmgmsTOfcAca/Li8pAGVcrotuFv57KoATOosMWi4lsjOg6H
        wOCdhUgcMzehGBn6vVG77+lQP+UsxfrNmbd5F3k2hGaG45mlzzkm/cryt7JX7KXa1wdbqSCPbnjKw
        bcu/3VEKIskTkqEVbKYIbKYgIuodsrzx+2o2g4GH/0ECcwGynvm0rZw8uia9qcARtYaOsCz2DlxVb
        KJODK4xg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58446)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nkTJj-0004G0-U1; Fri, 29 Apr 2022 17:18:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nkTJd-00025M-Eq; Fri, 29 Apr 2022 17:17:57 +0100
Date:   Fri, 29 Apr 2022 17:17:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] net: phy: marvell: update abilities and
 advertising when switching to SGMII
Message-ID: <YmwPtZ4akTgPRYlq@shell.armlinux.org.uk>
References: <20220427193928.2155805-1-robert.hancock@calian.com>
 <YmtA7/OjKIQD/vuD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmtA7/OjKIQD/vuD@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 03:35:43AM +0200, Andrew Lunn wrote:
> On Wed, Apr 27, 2022 at 01:39:28PM -0600, Robert Hancock wrote:
> > With some SFP modules, such as Finisar FCLF8522P2BTL, the PHY hardware
> > strapping defaults to 1000BaseX mode, but the kernel prefers to set them
> > for SGMII mode.
> 
> Is this the SFP code determining this? Its copper == use SGMII?
> 
> > When this happens and the PHY is soft reset, the BMSR
> > status register is updated, but this happens after the kernel has already
> > read the PHY abilities during probing. This results in support not being
> > detected for, and the PHY not advertising support for, 10 and 100 Mbps
> > modes, preventing the link from working with a non-gigabit link partner.
> > 
> > When the PHY is being configured for SGMII mode, call genphy_read_abilities
> > again in order to re-read the capabilities, and update the advertising
> > field accordingly.
> 
> Is this actually a generic problem? There are other PHYs used in SFP
> modules, and i assume they also could have their mode changed. So
> should the re-reading of the abilities be in the core, not each
> driver?

The most common PHY in SFPs is the 88E1111, because that offers both
MDIO and I2C hookup. Some other modules use the AR8035, but that
doesn't support I2C, and consequently doesn't tend to be accessible.

Re-reading the capabilities when the PHY changes host interface mode
between 1000baseX and SGMII makes sense because of the fixed-speed vs
10/100/1000 capability of the other.

One of the problems is the core code doesn't know how the PHY is
initially configured, so we can't actually detect mode changes. We
would need all PHY drivers to read the MAC mode at probe time, save
it away as the current mode, and only then can we detect changes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
