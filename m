Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5941F379443
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 18:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhEJQko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 12:40:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:22532 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231651AbhEJQkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 12:40:32 -0400
IronPort-SDR: 7OYs8G8xArhbUDZX7zp+ODoSh9bkTmSB7GY7s/4AOsY9PRf/qBNSFy9jqPHbteEl886BOoZFT9
 zb7uLWBLvfkg==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="179500301"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="179500301"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 09:39:27 -0700
IronPort-SDR: p65HzWgv4Te22j5Xj7Jcc2LG18DRXYEzucKZGsaR4X1xNTa/p6FWDepGuCa5LMYfgtOSrKjqkq
 aIWL2WY0I/pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="536481102"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 10 May 2021 09:39:24 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 555991D2; Mon, 10 May 2021 19:39:45 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Flavio Suligoi <f.suligoi@asem.it>,
        Lee Jones <lee.jones@linaro.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v3 4/5] net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()
Date:   Mon, 10 May 2021 19:39:30 +0300
Message-Id: <20210510163931.42417-5-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
References: <20210510163931.42417-1-andriy.shevchenko@linux.intel.com>
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

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Flavio Suligoi <f.suligoi@asem.it>
---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 7b224745bf3e..5e8acf76410d 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -110,7 +110,7 @@ static int pch_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
 {
 	u8 *data = skb->data;
 	unsigned int offset;
-	u16 *hi, *id;
+	u16 hi, id;
 	u32 lo;
 
 	if (ptp_classify_raw(skb) == PTP_CLASS_NONE)
@@ -121,14 +121,11 @@ static int pch_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
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
@@ -138,7 +135,6 @@ pch_rx_timestamp(struct pch_gbe_adapter *adapter, struct sk_buff *skb)
 	struct pci_dev *pdev;
 	u64 ns;
 	u32 hi, lo, val;
-	u16 uid, seq;
 
 	if (!adapter->hwts_rx_en)
 		return;
@@ -154,10 +150,7 @@ pch_rx_timestamp(struct pch_gbe_adapter *adapter, struct sk_buff *skb)
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

