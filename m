Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2893C146B47
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAWO1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:27:32 -0500
Received: from mga18.intel.com ([134.134.136.126]:5925 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgAWO1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 09:27:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 06:27:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="221527134"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jan 2020 06:27:30 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B36FA17E; Thu, 23 Jan 2020 16:27:29 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] net: fddi: skfp: Use print_hex_dump() helper
Date:   Thu, 23 Jan 2020 16:27:29 +0200
Message-Id: <20200123142729.56449-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the print_hex_dump() helper, instead of open-coding the same operations.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/fddi/skfp/skfddi.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
index 15754451cb87..69c29a2ef95d 100644
--- a/drivers/net/fddi/skfp/skfddi.c
+++ b/drivers/net/fddi/skfp/skfddi.c
@@ -1520,22 +1520,8 @@ void mac_drv_tx_complete(struct s_smc *smc, volatile struct s_smt_fp_txd *txd)
 #ifdef DUMPPACKETS
 void dump_data(unsigned char *Data, int length)
 {
-	int i, j;
-	unsigned char s[255], sh[10];
-	if (length > 64) {
-		length = 64;
-	}
 	printk(KERN_INFO "---Packet start---\n");
-	for (i = 0, j = 0; i < length / 8; i++, j += 8)
-		printk(KERN_INFO "%02x %02x %02x %02x %02x %02x %02x %02x\n",
-		       Data[j + 0], Data[j + 1], Data[j + 2], Data[j + 3],
-		       Data[j + 4], Data[j + 5], Data[j + 6], Data[j + 7]);
-	strcpy(s, "");
-	for (i = 0; i < length % 8; i++) {
-		sprintf(sh, "%02x ", Data[j + i]);
-		strcat(s, sh);
-	}
-	printk(KERN_INFO "%s\n", s);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, Data, min_t(size_t, length, 64), false);
 	printk(KERN_INFO "------------------\n");
 }				// dump_data
 #else
-- 
2.24.1

