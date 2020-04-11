Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0711A514F
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 14:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgDKMQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 08:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727051AbgDKMQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 08:16:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80A8721744;
        Sat, 11 Apr 2020 12:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607412;
        bh=rsMivg6zxnUZe5+q19pH3VNg+un8uCnbdFiR+2ak1+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsGAoHzejQYUx8wyGlKMadxQFBVxi7zRcqCw7iRoj6DgNKRC90uN8D7BWMARu49/+
         KVIt6pw34kpgFb4+XXnf7WIXh6DPZl3Jy8y45nFy3QclDXGCj5pZa09f1FPFNV9G4G
         eyfGIB7EaAaaxJHUSSuCd6VDtDTfhzjpdABhbbTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5.4 01/41] net: phy: realtek: fix handling of RTL8105e-integrated PHY
Date:   Sat, 11 Apr 2020 14:09:10 +0200
Message-Id: <20200411115504.231402605@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ No applicable upstream commit ]

After the referenced fix it turned out that one particular RTL8168
chip version (RTL8105e) does not work on 5.4 because no dedicated PHY
driver exists. Adding this PHY driver was done for fixing a different
issue for versions from 5.5 already. I re-send the same change for 5.4
because the commit message differs.

Fixes: 2e8c339b4946 ("r8169: fix PHY driver check on platforms w/o module softdeps")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -457,6 +457,15 @@ static struct phy_driver realtek_drvs[]
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 	}, {
+		PHY_ID_MATCH_MODEL(0x001cc880),
+		.name		= "RTL8208 Fast Ethernet",
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.read_page	= rtl821x_read_page,
+		.write_page	= rtl821x_write_page,
+	}, {
 		PHY_ID_MATCH_EXACT(0x001cc910),
 		.name		= "RTL8211 Gigabit Ethernet",
 		.config_aneg	= rtl8211_config_aneg,


