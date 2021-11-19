Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9CB456AB7
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhKSHNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:13:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233489AbhKSHNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:13:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9367861B44;
        Fri, 19 Nov 2021 07:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637305844;
        bh=7VDyA5TUX0+lJOb/6GvLAJr3JDD5aVg9/P6F7egnPdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcnzjLO4XxhST/Pd6F1GN68vNDfWd44vs3Yzyls17UbJTmNeaiHwJUnS5klE/M4V0
         npUkPXNp0eN6u+Bp1IdHEMSLGRofk0SFY5asqzJhkNl17ZzE+xaw0lprAklmJv3G28
         /4aVfhAXJDVYrUyzDCfqqEiueVHB4yJGvcMLG2HBg+2guWvcQLEZ+Y8FRoVRgBIJKM
         JEL0w+Mg6MECJ9GknGOAx9GmsAv9B+pzQxfwoo5/J3GcTH7t5/xOGgwgIk2katSSsZ
         ydVy1vZPfPKJk5bptWJablVloUTCC2cdGl9vK21SBKe3Eaul3xgVuHgdzUoa13ckJU
         m4BKOo7IGQpkw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 14/15] cirrus: mac89x0: use eth_hw_addr_set()
Date:   Thu, 18 Nov 2021 23:10:32 -0800
Message-Id: <20211119071033.3756560-15-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119071033.3756560-1-kuba@kernel.org>
References: <20211119071033.3756560-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/cirrus/mac89x0.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/mac89x0.c b/drivers/net/ethernet/cirrus/mac89x0.c
index 84251b85fc93..21a70b1f0ac5 100644
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
2.31.1

