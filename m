Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C0A182AC
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 01:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbfEHXWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 19:22:02 -0400
Received: from alln-iport-2.cisco.com ([173.37.142.89]:8895 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfEHXWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 19:22:02 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2019 19:22:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1960; q=dns/txt; s=iport;
  t=1557357721; x=1558567321;
  h=from:to:cc:subject:date:message-id;
  bh=xFoLKN7z00P1NlIEUkNeHdy5RdIl62U+exCN+0sxos0=;
  b=IAhDrj6TSwPopSgNc3bSk+x5oJu4HqMnAIEuAUrDzCTxZ8RFtRF4UrmJ
   DhBUa0BMTVuUcLMZRpI6SGpe+kNa2HqXHVylmLYQxn13SclImM/A0Jzbl
   AuvMwISWZ+vkZeOqjckzabNRrqc0FFhOuYQGeOTx5RiGtrjeS1Mbz52dc
   A=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AnAACFYtNc/5pdJa1kHAEBAQQBAQc?=
 =?us-ascii?q?EAQGBUQcBAQsBghCBOgEyKIwtpVSBewkJL4Q/ggojNAkOAQMBAQQBAQIBBG0?=
 =?us-ascii?q?ohXhSgT4TgyKCC655M4hmgUYUgR4BhneEVheBQD+EYYomBJJDlH8JgguSTwI?=
 =?us-ascii?q?ZlVYBoUKBTziBVjMaCBsVgyeQUT8DMI14K4IlAQE?=
X-IronPort-AV: E=Sophos;i="5.60,447,1549929600"; 
   d="scan'208";a="271168730"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 May 2019 23:14:30 +0000
Received: from sjc-ads-4850.cisco.com (sjc-ads-4850.cisco.com [10.28.39.114])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTP id x48NEUx3009602;
        Wed, 8 May 2019 23:14:30 GMT
From:   Nikunj Kela <nkela@cisco.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] igb: add parameter to ignore nvm checksum validation
Date:   Wed,  8 May 2019 23:14:29 +0000
Message-Id: <1557357269-9498-1-git-send-email-nkela@cisco.com>
X-Mailer: git-send-email 2.5.0
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.28.39.114, sjc-ads-4850.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the broken NICs don't have EEPROM programmed correctly. It results
in probe to fail. This change adds a module parameter that can be used to
ignore nvm checksum validation.

Cc: xe-linux-external@cisco.com
Signed-off-by: Nikunj Kela <nkela@cisco.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 39f33af..0ae1324 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -247,6 +247,11 @@ static int debug = -1;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
+static bool ignore_nvm_checksum;
+module_param(ignore_nvm_checksum, bool, 0);
+MODULE_PARM_DESC(ignore_nvm_checksum,
+		"Set to ignore nvm checksum validation (defaults N)");
+
 struct igb_reg_info {
 	u32 ofs;
 	char *name;
@@ -3191,18 +3196,29 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	case e1000_i211:
 		if (igb_get_flash_presence_i210(hw)) {
 			if (hw->nvm.ops.validate(hw) < 0) {
-				dev_err(&pdev->dev,
+				if (ignore_nvm_checksum) {
+					dev_warn(&pdev->dev,
 					"The NVM Checksum Is Not Valid\n");
-				err = -EIO;
-				goto err_eeprom;
+				} else {
+					dev_err(&pdev->dev,
+					"The NVM Checksum Is Not Valid\n");
+					err = -EIO;
+					goto err_eeprom;
+				}
 			}
 		}
 		break;
 	default:
 		if (hw->nvm.ops.validate(hw) < 0) {
-			dev_err(&pdev->dev, "The NVM Checksum Is Not Valid\n");
-			err = -EIO;
-			goto err_eeprom;
+			if (ignore_nvm_checksum) {
+				dev_warn(&pdev->dev,
+					"The NVM Checksum Is Not Valid\n");
+			} else {
+				dev_err(&pdev->dev,
+					"The NVM Checksum Is Not Valid\n");
+				err = -EIO;
+				goto err_eeprom;
+			}
 		}
 		break;
 	}
-- 
2.5.0

