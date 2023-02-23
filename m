Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D186A0577
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbjBWJ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbjBWJ40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:56:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFF451FB9;
        Thu, 23 Feb 2023 01:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GZs3uEYQVZAyBY+fpLqMnKLYV7E3if9o6bH8AEyri8I=; b=uFKbontWlJ+OPRfTP5AUembHFb
        O2bKUWEkxzSd/s1XdudvHE5hlosp8gKMaS99bH18czrKkUPONaz0VKTO4Gexnhike0RbDqsgCgZ+V
        gYGjB7JPQqkD6XlzQjTN3RKs+QAtidfgG5ONGXEOtCa27xSYhaCa80EkwR359Skr5/rHeVD6vdDHX
        IE7YWf+c5XOhe7CcXr3r8oozOXUSSTNiYa0Keukm6PbazzaVsBglufhftVaM6CEtttxFlHem+XI6J
        0QNI0l2bZlg4w/ECGuHFXqmwgyFsNW+IOc4x8HSi0XsI9O2q3pScQbEZAm2Efcho79ybKHVQTNZio
        VwlBbBXQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58028)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pV8KY-0007r8-J6; Thu, 23 Feb 2023 09:56:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pV8KX-00044v-V9; Thu, 23 Feb 2023 09:56:01 +0000
Date:   Thu, 23 Feb 2023 09:56:01 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v333 0/4] net: phy: EEE fixes
Message-ID: <Y/c4MYzaf1xtlBCZ@shell.armlinux.org.uk>
References: <20230222055043.113711-1-o.rempel@pengutronix.de>
 <4e85db8c0dd2ac32e404aa3a2ca24dfb503fbc64.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e85db8c0dd2ac32e404aa3a2ca24dfb503fbc64.camel@redhat.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 10:23:20AM +0100, Paolo Abeni wrote:
> Hi,
> 
> On Wed, 2023-02-22 at 06:50 +0100, Oleksij Rempel wrote:
> > changes v3:
> > - add kernel test robot tags to commit log
> > - reword comment for genphy_c45_an_config_eee_aneg() function
> > 
> > changes v2:
> > - restore previous ethtool set logic for the case where advertisements
> >   are not provided by user space.
> > - use ethtool_convert_legacy_u32_to_link_mode() where possible
> > - genphy_c45_an_config_eee_aneg(): move adv initialization in to the if
> >   scope.
> > 
> > Different EEE related fixes.
> > 
> > Oleksij Rempel (4):
> >   net: phy: c45: use "supported_eee" instead of supported for access
> >     validation
> >   net: phy: c45: add genphy_c45_an_config_eee_aneg() function
> >   net: phy: do not force EEE support
> >   net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
> > 
> >  drivers/net/phy/phy-c45.c    | 54 ++++++++++++++++++++++++++++--------
> >  drivers/net/phy/phy_device.c | 21 +++++++++++++-
> >  include/linux/phy.h          |  6 ++++
> >  3 files changed, 68 insertions(+), 13 deletions(-)
> > 
> @Russel: I read your last reply to the v2 series as an ack here, am I
> correct?

Yes - I've just given two r-b's as well for the last two patches.
Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
