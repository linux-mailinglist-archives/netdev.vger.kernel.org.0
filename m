Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79154501EC
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhKOKEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 05:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbhKOKDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 05:03:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2A8C061746
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 02:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UqHGX3rcGMffyRRaX51NWoaTflJ0JYhvbnOwkerVOX8=; b=xsLphsG7FPYBgKUrNPvJMrzoUJ
        OSFilcZs+7lRusw7IWdvAuW7NVvfRTcqPUn9t25orQNWGy8VCCL5X6LcaqM4tvCYudqVSBt5Dl/Jo
        64CVoOpIEYEK4XNg88F6emh5Ne/1UAHfIBp+vaQfr7joUc88I5FoWeTDP6t6D604V139Hi8S5H196
        Baph8gl3sFiee0V2KflukpfY+h7gd9rOJsvdS/QDVbYt4i7Rn77/AVxE/2u4O5vGr6YDzLLXXG+FF
        tDo14qiV0WfUwaAiAvJKM+H2xuiuO//zMMymoPDyp00lK3ENTHRTD2Hsh5UqOLG8jU2TpkcOnIjQF
        8CjMiMTQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55630)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mmYmQ-0007Ry-4s; Mon, 15 Nov 2021 10:00:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mmYmL-0000vz-V9; Mon, 15 Nov 2021 09:59:57 +0000
Date:   Mon, 15 Nov 2021 09:59:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next 0/3] introduce generic phylink validation
Message-ID: <YZIvnerLwnMkxx3p@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The various validate method implementations we have in phylink users
have been quite repetitive but also prone to bugs. These patches
introduce a generic implementation which relies solely on the
supported_interfaces bitmap introduced during last cycle, and in the
first patch, a bit array of MAC capabilities.

MAC drivers are free to continue to do their own thing if they have
special requirements - such as mvneta and mvpp2 which do not support
1000base-X without AN enabled. Most implementations currently in the
kernel can be converted to call phylink_generic_validate() directly
from the phylink MAC operations structure once they fill in the
supported_interfaces and mac_capabilities members of phylink_config.

This series introduces the generic implementation, and converts mvneta
and mvpp2 to use it.

 drivers/net/ethernet/marvell/mvneta.c           |  34 +---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |  58 +-----
 drivers/net/phy/phylink.c                       | 252 ++++++++++++++++++++++++
 include/linux/phylink.h                         |  31 +++
 4 files changed, 296 insertions(+), 79 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
