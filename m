Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A801359CB0
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhDILJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:09:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40825 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhDILJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:09:16 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lUp0T-0003aW-Fc; Fri, 09 Apr 2021 11:08:57 +0000
From:   Colin King <colin.king@canonical.com>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Kumar Sanghvi <kumaras@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cxgb4: Fix unintentional sign extension issues
Date:   Fri,  9 Apr 2021 12:08:57 +0100
Message-Id: <20210409110857.637409-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The shifting of the u8 integers f->fs.nat_lip[] by 24 bits to
the left will be promoted to a 32 bit signed int and then
sign-extended to a u64. In the event that the top bit of the u8
is set then all then all the upper 32 bits of the u64 end up as
also being set because of the sign-extension. Fix this by
casting the u8 values to a u64 before the 24 bit left shift.

Addresses-Coverity: ("Unintended sign extension")
Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index b1cae5a19839..2f70f02207b2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -174,31 +174,31 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
 				      WORD_MASK, f->fs.nat_lip[15] |
 				      f->fs.nat_lip[14] << 8 |
 				      f->fs.nat_lip[13] << 16 |
-				      f->fs.nat_lip[12] << 24, 1);
+				      (u64)f->fs.nat_lip[12] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_SND_UNA_RAW_W + 1,
 				      WORD_MASK, f->fs.nat_lip[11] |
 				      f->fs.nat_lip[10] << 8 |
 				      f->fs.nat_lip[9] << 16 |
-				      f->fs.nat_lip[8] << 24, 1);
+				      (u64)f->fs.nat_lip[8] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_SND_UNA_RAW_W + 2,
 				      WORD_MASK, f->fs.nat_lip[7] |
 				      f->fs.nat_lip[6] << 8 |
 				      f->fs.nat_lip[5] << 16 |
-				      f->fs.nat_lip[4] << 24, 1);
+				      (u64)f->fs.nat_lip[4] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_SND_UNA_RAW_W + 3,
 				      WORD_MASK, f->fs.nat_lip[3] |
 				      f->fs.nat_lip[2] << 8 |
 				      f->fs.nat_lip[1] << 16 |
-				      f->fs.nat_lip[0] << 24, 1);
+				      (u64)f->fs.nat_lip[0] << 24, 1);
 		} else {
 			set_tcb_field(adap, f, tid, TCB_RX_FRAG3_LEN_RAW_W,
 				      WORD_MASK, f->fs.nat_lip[3] |
 				      f->fs.nat_lip[2] << 8 |
 				      f->fs.nat_lip[1] << 16 |
-				      f->fs.nat_lip[0] << 24, 1);
+				      (u64)f->fs.nat_lip[0] << 25, 1);
 		}
 	}
 
@@ -208,25 +208,25 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
 				      WORD_MASK, f->fs.nat_fip[15] |
 				      f->fs.nat_fip[14] << 8 |
 				      f->fs.nat_fip[13] << 16 |
-				      f->fs.nat_fip[12] << 24, 1);
+				      (u64)f->fs.nat_fip[12] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_RX_FRAG2_PTR_RAW_W + 1,
 				      WORD_MASK, f->fs.nat_fip[11] |
 				      f->fs.nat_fip[10] << 8 |
 				      f->fs.nat_fip[9] << 16 |
-				      f->fs.nat_fip[8] << 24, 1);
+				      (u64)f->fs.nat_fip[8] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_RX_FRAG2_PTR_RAW_W + 2,
 				      WORD_MASK, f->fs.nat_fip[7] |
 				      f->fs.nat_fip[6] << 8 |
 				      f->fs.nat_fip[5] << 16 |
-				      f->fs.nat_fip[4] << 24, 1);
+				      (u64)f->fs.nat_fip[4] << 24, 1);
 
 			set_tcb_field(adap, f, tid, TCB_RX_FRAG2_PTR_RAW_W + 3,
 				      WORD_MASK, f->fs.nat_fip[3] |
 				      f->fs.nat_fip[2] << 8 |
 				      f->fs.nat_fip[1] << 16 |
-				      f->fs.nat_fip[0] << 24, 1);
+				      (u64)f->fs.nat_fip[0] << 24, 1);
 
 		} else {
 			set_tcb_field(adap, f, tid,
@@ -234,13 +234,13 @@ static void set_nat_params(struct adapter *adap, struct filter_entry *f,
 				      WORD_MASK, f->fs.nat_fip[3] |
 				      f->fs.nat_fip[2] << 8 |
 				      f->fs.nat_fip[1] << 16 |
-				      f->fs.nat_fip[0] << 24, 1);
+				      (u64)f->fs.nat_fip[0] << 24, 1);
 		}
 	}
 
 	set_tcb_field(adap, f, tid, TCB_PDU_HDR_LEN_W, WORD_MASK,
 		      (dp ? (nat_lp[1] | nat_lp[0] << 8) : 0) |
-		      (sp ? (nat_fp[1] << 16 | nat_fp[0] << 24) : 0),
+		      (sp ? (nat_fp[1] << 16 | (u64)nat_fp[0] << 24) : 0),
 		      1);
 }
 
-- 
2.30.2

