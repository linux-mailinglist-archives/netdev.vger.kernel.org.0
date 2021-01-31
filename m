Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E47309C1A
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhAaMtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhAaKhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 05:37:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35176C061573
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 02:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tquS6jwJ1/pufjGi/6cuMGDu4tWPMxCchiKMz/QP7ig=; b=09xq91Hfb4HBWUw5iyTsz0jlM
        QJTvPCURuOJO4Z42c76FslyMF1q+bmO2OaTPfXG4BWUFUapkyjbspfnYpajqUcgX5+oBiyqeVNN7I
        MbjdgwG9Bb0pRXjlb18pkwEmY7R0vJwaT9HyyXYqAdBivgzkT0M+2kanP7Y1pYiOrLExXNRXRhWlJ
        zOs0U0YNwG8c2uVM/zD1NF/Sm4lUwH1OQ9fK7gJQKOc6LQ0yitSReBDpd3NIlvR6OepmMtbpjtmt4
        h2gVKqdVGg1+c6qo5hxwQ8JuCz2Btr/nm9GqgG5zcIwFWBXPk7W1uqdIpeWnfkwqS7Gaf6M+4jQUu
        bfpgcL/rQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37286)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l6A59-0002Ki-C9; Sun, 31 Jan 2021 10:35:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l6A57-0000vu-Dr; Sun, 31 Jan 2021 10:35:49 +0000
Date:   Sun, 31 Jan 2021 10:35:49 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Marcin Wojtas (mw@semihalf.com)" <mw@semihalf.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>
Subject: Re: Phylink flow control support on ports with  MLO_AN_FIXED auto
 negotiation
Message-ID: <20210131103549.GA1463@shell.armlinux.org.uk>
References: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB38732F56EF08FA2C949326F9B0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 10:12:25AM +0000, Stefan Chulski wrote:
> Hi,
> 
> Armada has options for 1G/10G ports without PHY's(for example community board Macchiato single shot).
> This port doesn't have PHY's and cannot negotiate Flow Control support, but we can for example connect two ports without PHY's and manually(by ethtool) configure FC.

On the Macchiatobin single shot, you use the existing SFP support
rather than forcing them to fixed link.

> Current phylink return error if I do this on ports with MLO_AN_FIXED(callback phylink_ethtool_set_pauseparam):
> if (pl->cur_link_an_mode == MLO_AN_FIXED)
>                 return -EOPNOTSUPP;
> 
> How can we enable FC configurations for these ports? Do you have any suggestions or should I post my proposal as an RFC patch?

If you really must use fixed-link, you specify the pause modes via
firmware, just as you specify the speed and duplex - you specify
the link partner's flow control abilities.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
