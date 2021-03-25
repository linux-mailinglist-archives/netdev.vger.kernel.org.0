Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC281349825
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhCYRee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:34:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:22784 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230042AbhCYReR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:34:17 -0400
IronPort-SDR: Ppg1JrDQNPFTKUUpIB1naUTuS3/IpmFLAv+zM6nsRIOpYOLmmId+y1JcZnLZH89j919hab/QS0
 Cwu6KxwNil8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191079466"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="191079466"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 10:34:15 -0700
IronPort-SDR: vFgee6Zny4lNpw1i77hdpCG7uQI7Ob7LaBBTFSGaXVEDz3H4RQ9M5fPWRHtvWLe5oDbzRskOyf
 3/m436fW4T2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="525731290"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2021 10:34:09 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 5F0124E1; Thu, 25 Mar 2021 19:34:23 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Flavio Suligoi <f.suligoi@asem.it>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 4/5] net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()
Date:   Thu, 25 Mar 2021 19:34:11 +0200
Message-Id: <20210325173412.82911-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
References: <20210325173412.82911-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse is not happy about handling of strict types in pch_ptp_match():

  .../pch_gbe_main.c:158:33: warning: incorrect type in argument 2 (different base types)
  .../pch_gbe_main.c:158:33:    expected unsigned short [usertype] uid_hi
  .../pch_gbe_main.c:158:33:    got restricted __be16 [usertype]
  .../pch_gbe_main.c:158:45: warning: incorrect type in argument 3 (different base types)
  .../pch_gbe_main.c:158:45:    expected unsigned int [usertype] uid_lo
  .../pch_gbe_main.c:158:45:    got restricted __be32 [usertype]
  .../pch_gbe_main.c:158:56: warning: incorrect type in argument 4 (different base types)
  .../pch_gbe_main.c:158:56:    expected unsigned short [usertype] seqid
  .../pch_gbe_main.c:158:56:    got restricted __be16 [usertype]

Fix that by switching to use proper accessors to BE data.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 91de7faa6dfe..b54e73c57d65 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -108,7 +108,7 @@ static int pch_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
 {
 	u8 *data = skb->data;
 	unsigned int offset;
-	u16 *hi, *id;
+	u16 hi, id;
 	u32 lo;
 
 	if (ptp_classify_raw(skb) == PTP_CLASS_NONE)
@@ -119,14 +119,11 @@ static int pch_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
 	if (skb->len < offset + OFF_PTP_SEQUENCE_ID + sizeof(seqid))
 		return 0;
 
-	hi = (u16 *)(data + offset + OFF_PTP_SOURCE_UUID);
-	id = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
+	hi = get_unaligned_be16(data + offset + OFF_PTP_SOURCE_UUID + 0);
+	lo = get_unaligned_be32(data + offset + OFF_PTP_SOURCE_UUID + 2);
+	id = get_unaligned_be16(data + offset + OFF_PTP_SEQUENCE_ID);
 
-	memcpy(&lo, &hi[1], sizeof(lo));
-
-	return (uid_hi == *hi &&
-		uid_lo == lo &&
-		seqid  == *id);
+	return (uid_hi == hi && uid_lo == lo && seqid == id);
 }
 
 static void
@@ -136,7 +133,6 @@ pch_rx_timestamp(struct pch_gbe_adapter *adapter, struct sk_buff *skb)
 	struct pci_dev *pdev;
 	u64 ns;
 	u32 hi, lo, val;
-	u16 uid, seq;
 
 	if (!adapter->hwts_rx_en)
 		return;
@@ -152,10 +148,7 @@ pch_rx_timestamp(struct pch_gbe_adapter *adapter, struct sk_buff *skb)
 	lo = pch_src_uuid_lo_read(pdev);
 	hi = pch_src_uuid_hi_read(pdev);
 
-	uid = hi & 0xffff;
-	seq = (hi >> 16) & 0xffff;
-
-	if (!pch_ptp_match(skb, htons(uid), htonl(lo), htons(seq)))
+	if (!pch_ptp_match(skb, hi, lo, hi >> 16))
 		goto out;
 
 	ns = pch_rx_snap_read(pdev);
-- 
2.30.2

