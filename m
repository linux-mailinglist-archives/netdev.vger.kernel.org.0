Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5D849148E
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245146AbiARCXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245010AbiARCW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:22:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0CFC06173F;
        Mon, 17 Jan 2022 18:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED3E8604EF;
        Tue, 18 Jan 2022 02:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E18C36AE3;
        Tue, 18 Jan 2022 02:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472546;
        bh=A6mPTM9vcIfG+G/12YG4GMV7Lxx2UDvOqt7qvH2QNTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/+LuQThtogVrqwUcMAripjOH0F7aORnM/gowMSSAfJR44gjF0ZpDPesyMxT4efY9
         Eq7PB/UxYC9XbLvQiSLsX+xBZ8+Vcn0xvwY0c3YYcHwUlHjCj9Ewjii3hBMVvii2CF
         Dr3iV6V8lITcy49CGeAPQO87p0IhJy17v3L4C+3lDFsLWL4oxEdxh5isu1v0luGRAS
         L0JYHvSDyLhMMabqr+Q7+ih4CWmQekXqKMK4troDl5PZjwUkMsuqQGJ9oUxvunpYyD
         QeHTM6TAoONmaz6ENDs/mXzMMw8JYVIRssnN/fZSgHQXokzF6RlMx4ksRKMZY756Pz
         ZtO6U1A3V01OQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 047/217] cirrus: mac89x0: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:50 -0500
Message-Id: <20220118021940.1942199-47-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 9a962aedd30f7fceb828d3161a80e0526e358eb5 ]

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cirrus/mac89x0.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/mac89x0.c b/drivers/net/ethernet/cirrus/mac89x0.c
index 84251b85fc931..21a70b1f0ac50 100644
--- a/drivers/net/ethernet/cirrus/mac89x0.c
+++ b/drivers/net/ethernet/cirrus/mac89x0.c
@@ -242,12 +242,15 @@ static int mac89x0_device_probe(struct platform_device *pdev)
 		pr_info("No EEPROM, giving up now.\n");
 		goto out1;
         } else {
+		u8 addr[ETH_ALEN];
+
                 for (i = 0; i < ETH_ALEN; i += 2) {
 			/* Big-endian (why??!) */
 			unsigned short s = readreg(dev, PP_IA + i);
-                        dev->dev_addr[i] = s >> 8;
-                        dev->dev_addr[i+1] = s & 0xff;
+			addr[i] = s >> 8;
+			addr[i+1] = s & 0xff;
                 }
+		eth_hw_addr_set(dev, addr);
         }
 
 	dev->irq = SLOT2IRQ(slot);
-- 
2.34.1

