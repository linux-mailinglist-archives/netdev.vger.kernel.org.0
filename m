Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CD51C8BFC
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEGNVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:21:42 -0400
Received: from lists.nic.cz ([217.31.204.67]:54160 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgEGNVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 09:21:41 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id D1DB913FCBB;
        Thu,  7 May 2020 15:21:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1588857699; bh=uxBNcZBbRuH+qPvMfuJsJ0ww9wtqtQT1uPZxkB7gJlg=;
        h=From:To:Date;
        b=xnU5IP0zFUv+p686YgG8NYk2XillMEQl14+9fGQ6ZDaacmUcWlFlLBhvL9dju+ygX
         HOpC3OO9y5fRRc5y7jdhXfIF5r24mU8QtE86uet/2/ZtjYPIHcEzbhnXHNHneYpqSs
         hNfkaWuhj7ZWYgcp1REFjfbHRF3B/OPx9IzaUbkU=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next] net: sfp: add some quirks for FreeTel direct attach modules
Date:   Thu,  7 May 2020 15:21:35 +0200
Message-Id: <20200507132135.316-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FreeTel P.C30.2 and P.C30.3 may fail to report anything useful from
their EEPROM. They report correct nominal bitrate of 10300 MBd, but do
not report sfp_ct_passive nor sfp_ct_active in their ERPROM.

These modules can also operate at 1000baseX and 2500baseX.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 6900c68260e0..f021709bedcc 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -44,6 +44,14 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 	phylink_set(modes, 2500baseX_Full);
 }
 
+static void sfp_quirk_direct_attach_10g(const struct sfp_eeprom_id *id,
+					unsigned long *modes)
+{
+	phylink_set(modes, 10000baseCR_Full);
+	phylink_set(modes, 2500baseX_Full);
+	phylink_set(modes, 1000baseX_Full);
+}
+
 static const struct sfp_quirk sfp_quirks[] = {
 	{
 		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
@@ -63,6 +71,18 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "HUAWEI",
 		.part = "MA5671A",
 		.modes = sfp_quirk_2500basex,
+	}, {
+		// FreeTel P.C30.2 is a SFP+ direct attach that can operate at
+		// at 1000baseX, 2500baseX and 10000baseCR, but may report none
+		// of these in their EEPROM
+		.vendor = "FreeTel",
+		.part = "P.C30.2",
+		.modes = sfp_quirk_direct_attach_10g,
+	}, {
+		// same as previous
+		.vendor = "FreeTel",
+		.part = "P.C30.3",
+		.modes = sfp_quirk_direct_attach_10g,
 	},
 };
 
-- 
2.24.1

