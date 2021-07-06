Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF283BD5DB
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241992AbhGFMZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237022AbhGFLfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B06261CA6;
        Tue,  6 Jul 2021 11:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570711;
        bh=UJwtZjaojH+hV5vfWdus5lhvq0jNF90HqyCnvdJBqG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NthMGFCQ8ZMfcddgN+bOZDHVCDXpbKG4clwG/zX1V8gEzup/VNzVZiZUGKk5WwfVk
         9uJm8DY8sNGX9jzV1/XLmcwkc+bMrTXkLsAQygvM7NLlrMnEutjgaT27aqOVDZ5+/T
         iWRFmzT5qmjnMIiKQfRyeYZI5NeF4SbhpevDGxuKJM5dMSIPmKe6TF29ITc4xtdCdL
         9rFTi+QjAvbOBpdl1aC/d4UECY4LHI/uVC7bXxLJkBqsbpJEC5Qz2mDmexCXUm1MhW
         kvI+RgQhPiz37mVgIwg7FC63MHl4z+oU7VWQPrDxnua6haEnhvZ+LrbqcDYHRcM5S3
         gSj731bXcQlWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        kernel test robot <lkp@intel.com>,
        Flavio Suligoi <f.suligoi@asem.it>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/74] net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()
Date:   Tue,  6 Jul 2021 07:23:54 -0400
Message-Id: <20210706112502.2064236-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 443ef39b499cc9c6635f83238101f1bb923e9326 ]

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

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Flavio Suligoi <f.suligoi@asem.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 18e6d87c607b..d7cfbc400091 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -107,7 +107,7 @@ static int pch_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
 {
 	u8 *data = skb->data;
 	unsigned int offset;
-	u16 *hi, *id;
+	u16 hi, id;
 	u32 lo;
 
 	if (ptp_classify_raw(skb) == PTP_CLASS_NONE)
@@ -118,14 +118,11 @@ static int pch_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
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
@@ -135,7 +132,6 @@ pch_rx_timestamp(struct pch_gbe_adapter *adapter, struct sk_buff *skb)
 	struct pci_dev *pdev;
 	u64 ns;
 	u32 hi, lo, val;
-	u16 uid, seq;
 
 	if (!adapter->hwts_rx_en)
 		return;
@@ -151,10 +147,7 @@ pch_rx_timestamp(struct pch_gbe_adapter *adapter, struct sk_buff *skb)
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

