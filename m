Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D188C2F5F2A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbhANKpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbhANKpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:45:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E75AC061573;
        Thu, 14 Jan 2021 02:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=F68eulvXFZnAl5pZI2tB8ZalnqWIEVZQNyoa3f/vSfs=; b=1+PsGp7gsUMf+LHqCtJKBArVm
        WP/UXkNP7vLIkUGBLCgPKqMEHpthoqKRhWwXZUxFme8DiLG8PZVGHCxLFYHAKJOJZq9ZY93lzRQGh
        TJwrKZNBikaMgWa9oZhQbYW8yikg4L/TiBmPn6BecganzP2ma01+TVcHrQpijLzAF3Hwyofgymb98
        S+KV0SLhIWqsgcK3aqePesTczUli33vxnU2yKNauiQTB4BKCJSdVJPhXSnfNL2BVwEdPFj8HhQugj
        aYDXg8elEfsPoUg4Y4H9nH9Zimbk6OhIKGMzogcDJM8mFXTX/Ise313+SrOYnaPODiXbqgdv+3ZPI
        mKt3vcBkQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47830)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l007c-0002KB-SN; Thu, 14 Jan 2021 10:44:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l007c-0008H6-4K; Thu, 14 Jan 2021 10:44:56 +0000
Date:   Thu, 14 Jan 2021 10:44:56 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Jon Nettleton <jon@solid-run.com>
Subject: [PATCH net-next 0/2] Add further DT configuration for AT803x PHYs
Message-ID: <20210114104455.GP1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series adds the ability to configure the SmartEEE feature
in AT803x PHYs. SmartEEE defaults to enabled on these PHYs, and has
a history of causing random sporadic link drops at Gigabit speeds.

There appears to be two solutions to this. There is the approach that
Freescale adopted early on, which is to disable the SmartEEE feature.
However, this loses the power saving provided by EEE. Another solution
was found by Jon Nettleton is to increase the Tw parameter for Gigabit
links.

This patch series adds support for both approaches, by adding a boolean:

	qca,disable-smarteee

if one wishes to disable SmartEEE, and two properties to configure the
SmartEEE Tw parameters:

	qca,smarteee-tw-us-100m
	qca,smarteee-tw-us-1g

Sadly, the PHY quirk I merged a while back for AT8035 on iMX6 is broken 
- rather than disabling SmartEEE mode, it enables it.

The addition of these properties will be sent to the appropriate
platform maintainers - although for SolidRun platforms, we only make use
of "qca,smarteee-tw-us-1g".

 .../devicetree/bindings/net/qca,ar803x.yaml        | 16 ++++++
 drivers/net/phy/at803x.c                           | 65 +++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletion(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
