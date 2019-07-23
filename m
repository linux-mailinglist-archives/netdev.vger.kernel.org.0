Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A849971B40
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbfGWPPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:15:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:35182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727391AbfGWPPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 11:15:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80F00AF81;
        Tue, 23 Jul 2019 15:15:31 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Marcus Seyfarth <m.seyfarth@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] sky2: Disable MSI on ASUS P6T
Date:   Tue, 23 Jul 2019 17:15:25 +0200
Message-Id: <20190723151525.6526-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The onboard sky2 NIC on ASUS P6T WS PRO doesn't work after PM resume
due to the infamous IRQ problem.  Disabling MSI works around it, so
let's add it to the blacklist.

Unfortunately the BIOS on the machine doesn't fill the standard
DMI_SYS_* entry, so we pick up DMI_BOARD_* entries instead.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1142496
Reported-and-tested-by: Marcus Seyfarth <m.seyfarth@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/ethernet/marvell/sky2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index f518312ffe69..a01c75ede871 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4924,6 +4924,13 @@ static const struct dmi_system_id msi_blacklist[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "P5W DH Deluxe"),
 		},
 	},
+	{
+		.ident = "ASUS P6T",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P6T"),
+		},
+	},
 	{}
 };
 
-- 
2.16.4

