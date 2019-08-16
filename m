Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A3E90B08
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfHPWd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:33:56 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32920 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbfHPWdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:33:55 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so3848451pfq.0
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RWSLKFQZrYHm4ue/uN2QXx3VFRWIdCKuHzOhS/FQL5I=;
        b=BiGfPY4iT3sZGGWR0f+P/bgEsj0Fhhp+eHD5i/PN9ZTsG1CCFWR85RLUZ8vuA6qCCh
         8tUZepGFx5AmKM+NpEmuTltqzxtWPkP9W/IQu06m6TDllLTAaTCGriVZg5tYgD8etGXJ
         99WL9u5QAek6TsqaORkYRxX+CRD6EA539xdws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RWSLKFQZrYHm4ue/uN2QXx3VFRWIdCKuHzOhS/FQL5I=;
        b=J6AevBPK1aPtgkc6nkSvMTZaI+aOzo7eoD8ApFIjbAL8/SwqijgzomumVXaFiuwMvY
         Biwprg1Pk8ctT1wrNBZiBWSQgSVd4acOKFs3FfrZyb1PLj7pqSJZyqhmbOSV31aFv5v+
         2/maJNeIw6FL58g2lnHBTRKXQAnQCHtPvHf+v6Y2FCv2QPcx1usCanLR7ALSAb5RpRSv
         r6QmCaosEtIyIPaeIMuI96IklI5tntPkiawaXaXu8/kbAuXg3t9tykfcX8RZXOD2CZUj
         Dx1c98B3i0EDwaRIKvn+CqOjrCDhq1439W+dr8JwlVbnQfO7aJ3irS6yYVNjxCarwrnN
         TFzg==
X-Gm-Message-State: APjAAAX8TOBGiI1YpCaoVULKmQkyS/heKs5rTv2nWYb9K7J7KaxuTXrb
        mC73gOREw6gt4kXqiZiCDNfpeOu0N5g=
X-Google-Smtp-Source: APXvYqzB5GB7mPY/ODUdEHo05Ti18MtjZZ+qfSHG94p8xb+LtKEWKpo3WLvhTlMkEBN5fmuw6fli3A==
X-Received: by 2002:a17:90a:bf01:: with SMTP id c1mr8532970pjs.30.1565994834677;
        Fri, 16 Aug 2019 15:33:54 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o35sm5728404pgm.29.2019.08.16.15.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:33:53 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>
Subject: [PATCH net 6/6] bnxt_en: Fix to include flow direction in L2 key
Date:   Fri, 16 Aug 2019 18:33:37 -0400
Message-Id: <1565994817-6328-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
References: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Somnath Kotur <somnath.kotur@broadcom.com>

FW expects the driver to provide unique flow reference handles
for Tx or Rx flows. When a Tx flow and an Rx flow end up sharing
a reference handle, flow offload does not seem to work.
This could happen in the case of 2 flows having their L2 fields
wildcarded but in different direction.
Fix to incorporate the flow direction as part of the L2 key

Fixes: abd43a13525d ("bnxt_en: Support for 64-bit flow handle.")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 6224c30..dd621f6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1236,7 +1236,7 @@ static int __bnxt_tc_del_flow(struct bnxt *bp,
 static void bnxt_tc_set_flow_dir(struct bnxt *bp, struct bnxt_tc_flow *flow,
 				 u16 src_fid)
 {
-	flow->dir = (bp->pf.fw_fid == src_fid) ? BNXT_DIR_RX : BNXT_DIR_TX;
+	flow->l2_key.dir = (bp->pf.fw_fid == src_fid) ? BNXT_DIR_RX : BNXT_DIR_TX;
 }
 
 static void bnxt_tc_set_src_fid(struct bnxt *bp, struct bnxt_tc_flow *flow,
@@ -1405,7 +1405,7 @@ static void bnxt_fill_cfa_stats_req(struct bnxt *bp,
 		 * 2. 15th bit of flow_handle must specify the flow
 		 *    direction (TX/RX).
 		 */
-		if (flow_node->flow.dir == BNXT_DIR_RX)
+		if (flow_node->flow.l2_key.dir == BNXT_DIR_RX)
 			handle = CFA_FLOW_INFO_REQ_FLOW_HANDLE_DIR_RX |
 				 CFA_FLOW_INFO_REQ_FLOW_HANDLE_MAX_MASK;
 		else
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
index ffec57d..e6373b3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
@@ -17,6 +17,7 @@
 /* Structs used for storing the filter/actions of the TC cmd.
  */
 struct bnxt_tc_l2_key {
+	u8		dir;
 	u8		dmac[ETH_ALEN];
 	u8		smac[ETH_ALEN];
 	__be16		inner_vlan_tpid;
@@ -98,7 +99,6 @@ struct bnxt_tc_flow {
 
 	/* flow applicable to pkts ingressing on this fid */
 	u16				src_fid;
-	u8				dir;
 #define BNXT_DIR_RX	1
 #define BNXT_DIR_TX	0
 	struct bnxt_tc_l2_key		l2_key;
-- 
2.5.1

