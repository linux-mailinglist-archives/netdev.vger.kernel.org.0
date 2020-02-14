Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DBC15EDAA
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbgBNRfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:35:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390255AbgBNQFy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:05:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D0CD2469A;
        Fri, 14 Feb 2020 16:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696354;
        bh=eZh0i0gIregeCPldQnezjgGWqhzibJDxeHddPP7JMnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeepUZ7qVXRztmlWxBBoetcMcVuECUUGwvE6QkLN3rYgNz6LHQIO7SGADCUMLyZGW
         BwTkc0NhWhR9raNv2QYnsraADUMb2R4ih+ZRhkJ3MGw4kKeZUfBJoSGb7VNvP8jHQ6
         jHPwDhYmH/XC+vR6lUzqTiaAxAcewQERy+sIMjq8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 187/459] r8169: check that Realtek PHY driver module is loaded
Date:   Fri, 14 Feb 2020 10:57:17 -0500
Message-Id: <20200214160149.11681-187-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
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
index 5ae0b5663d540..a2cef6a004e73 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -7064,6 +7064,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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

