Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E06D15F369
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404247AbgBNSLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:11:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731156AbgBNPxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CB8424686;
        Fri, 14 Feb 2020 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695611;
        bh=k3VHynw8rDv6gnu2039yCPRNdfOZ1y2P1trvZkmC6Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLsyAW1MJeP2d7DNmkao5PNRtxj+L8v4aIou9LipGmloCeYYI91T8X4RcXtvcHXP2
         cc8cruWCuxKG9FbNaFUWofeuWtZZsJkoRQeOKyre5MMrvq0LCGvBWfV73Krq3mduvB
         VDCXQntF2MFd8rZjBSy4uE+1aDmQeph8Rl/g1tGo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 213/542] r8169: check that Realtek PHY driver module is loaded
Date:   Fri, 14 Feb 2020 10:43:25 -0500
Message-Id: <20200214154854.6746-213-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 92a590154bb9f..2d2d22f86dc6f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6831,6 +6831,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int chipset, region;
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

