Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65A8F15E9BD
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403953AbgBNQNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:13:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392226AbgBNQNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 145AB246D4;
        Fri, 14 Feb 2020 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696831;
        bh=m9ywS9W5sFzIk8yj1UQGFY10lpinxn5x/nVWAjNi0g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHdp8z+A4XT2NjB+e5rmjreaUT7IqVSpJnPG7fmjgzRaDUZgzrHFWMcOb3SqbrH/5
         uwTyBiG/Krv7CXCuFbElzKwsndemO+0PEdeniPCafSlvVGCHPgIZru3kmwxYEoQ+qR
         weF8fuA5eA/2mAl7KV6hJWuNNi5atjzQ89jq16eQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 097/252] r8169: check that Realtek PHY driver module is loaded
Date:   Fri, 14 Feb 2020 11:09:12 -0500
Message-Id: <20200214161147.15842-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit f325937735498afb054a0195291bbf68d0b60be5 ]

Some users complained about problems with r8169 and it turned out that
the generic PHY driver was used instead instead of the dedicated one.
In all cases reason was that r8169.ko was in initramfs, but realtek.ko
not. Manually adding realtek.ko to initramfs fixed the issues.
Root cause seems to be that tools like dracut and genkernel don't
consider softdeps. Add a check for loaded Realtek PHY driver module
and provide the user with a hint if it's not loaded.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 4ab87fe845427..6ea43e48d5f97 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -7433,6 +7433,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int chipset, region, i;
 	int jumbo_max, rc;
 
+	/* Some tools for creating an initramfs don't consider softdeps, then
+	 * r8169.ko may be in initramfs, but realtek.ko not. Then the generic
+	 * PHY driver is used that doesn't work with most chip versions.
+	 */
+	if (!driver_find("RTL8201CP Ethernet", &mdio_bus_type)) {
+		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
+		return -ENOENT;
+	}
+
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
 	if (!dev)
 		return -ENOMEM;
-- 
2.20.1

