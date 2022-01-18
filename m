Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC020491BB6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352593AbiARDIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352215AbiARC7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:59:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A001C0619C9;
        Mon, 17 Jan 2022 18:34:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0970B81258;
        Tue, 18 Jan 2022 02:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D955FC36AE3;
        Tue, 18 Jan 2022 02:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473253;
        bh=MPgyCk3gHvl6pAmB++S7vawcL6tEWEZbnPonpzfws4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJ9x5CBqVEP/3CTWQ8OMsUGPYmSFJ/CEF4wWsD9q8SWEVE6saXx8NPNt4oyXYxm01
         JIlArq1H7UiUPbL0Vvq2+iPzkMeh5OVbW8pjDnxcUzcTXclVCuEahPE7JTfed0Lj1q
         c9qxOr+126SHF1KS8UZW+E/M9p7aU7rNTFHvI8UYVidK4HgOncCVH42bupl6/2Cwkw
         mdcQbEEt7B+0GrnTO19nM2Oc9Abin3r05bLadjpyRI6an/QpcmFCLGLI0hCCzqHDdl
         FabRBIP+5EksmzkODM+Wl9JUzg64pipNYox3zzocRq9ReL/YGmXzPnRQFBLvjhNmsM
         lS0AIVySLX3HA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 041/188] cirrus: mac89x0: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:29:25 -0500
Message-Id: <20220118023152.1948105-41-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index 6324e80960c3e..4a959a74b1cea 100644
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

