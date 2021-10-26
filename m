Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3412C43AFB2
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbhJZKIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbhJZKIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:08:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CE7C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 03:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c6JDbWbQymoOWkyJXac6cZGWom9VtrVgtJ5igr9f5jA=; b=WuysxWyJlMQpn/Sr2AsuuHV5C3
        bxDRrZZBUCjH78+6Yc/U4O8d1APrmUGy8ULyJm51UwHxEJ9MbT5ACm/KWaXxMateLTKWtBkz+Emzc
        CR9xXxrPEKZJtQFuD9/nS3LOaLiZ+0F3S6+w4MPST5vbPoy1z3Ly1UtWpVP/jJkWZBBmCYKhJsHKJ
        FVC4euhq1kl8PvSTljvfhqaY5S3BnikQUYDgt4ynTn/VxJH7SFZlEEsIehojSUZzZ0E9GggaXzAme
        Q0B06+zPaSCuQS3NGM6iou4AuERyZClVTUWX3pQIssKHucXdAJiXZuN6mWVPeeett4SxT4wS4HcOC
        dI1rO4JQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55304)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mfJKs-0005Cf-Hg; Tue, 26 Oct 2021 11:05:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mfJKq-0006ei-1M; Tue, 26 Oct 2021 11:05:36 +0100
Date:   Tue, 26 Oct 2021 11:05:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] Introduce supported interfaces bitmap
Message-ID: <YXfS8K/7c14UFIyq@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces a new bitmap to allow us to indicate which
phy_interface_t modes are supported.

Currently, phylink will call ->validate with PHY_INTERFACE_MODE_NA to
request all link mode capabilities from the MAC driver before choosing
an interface to use. This leads in some cases to some rather hairly
code. This can be simplified if phylink is aware of the interface modes
that  the MAC supports, and it can instead walk those modes, calling
->validate for each one, and combining the results.

This series merely introduces the support; there is no change of
behaviour until MAC drivers populate their supported_interfaces bitmap.

 drivers/net/phy/phylink.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h       | 34 ++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   | 13 +++++++++++--
 3 files changed, 81 insertions(+), 2 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
