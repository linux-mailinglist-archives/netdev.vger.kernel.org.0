Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAFB912F1
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfHQVFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:05:39 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43489 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfHQVFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:05:38 -0400
Received: by mail-pl1-f196.google.com with SMTP id 4so3895179pld.10
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 14:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8FLCheCGFH43zwO48CXL3zwzgYS298RJST523279m94=;
        b=aA9rSYS6TOnBIzSvxdiqZIfd99kSo1thPe+riy9AEX9ppidSvXgKmpsdCLcHLG0mt/
         hmRhGhbgG6uZqYaHt0JpyS97G1B1pSAczSdfEIgKf4i4Od7wPwK5Rve+Axtip7+HlccH
         pFA+kiYk877d/ne5WZsLW4A1j/Yz0o19xPnNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8FLCheCGFH43zwO48CXL3zwzgYS298RJST523279m94=;
        b=ArFaTmQWPyFeHz9qKS6203KHs4icCxk0dlWiYOeMAiftwvZ4I6as53RD50OgVO8kDj
         U1CyteU8Mkt7i3+Zz7H3YSKaedW+p3wiAfj3OHpw2wZWz3m9+ewnp2fBwKvNE8+eEOAn
         CrfresV7RSKbyqBF4zAqEhabhUA6Q9cb6Ca6lv6QkY4+dk8vDZsaERlHKZ8tEjt7F8yq
         AocFpOQG8IZ15ZLjwk4CWA2TmEoBPelxJuzUltw1IsuybDY4OWiTX1s2ZG1sr/j/r9Pn
         xiad88JvTscts8Gn33HpGk4uuOdw7VWdOL7pRkmwxRHNKmv5wXP3sGztfqTbytSFnGK5
         ntTw==
X-Gm-Message-State: APjAAAWPcvdzpHHlH9TuUnJ0lkJ/Fs6D8M+vp1ACiAzCh9vRx73XL8wZ
        j5ZfooPmduBvp/tYcVWCrfgVjgFu1go=
X-Google-Smtp-Source: APXvYqyoi0kgYTtih1sRurXx28pyrzJMv1tnd3Nf7oF0eKiXme86gkCBy9Rr9Ulr0VOJFUDNTm+mlA==
X-Received: by 2002:a17:902:900a:: with SMTP id a10mr15840202plp.281.1566075937881;
        Sat, 17 Aug 2019 14:05:37 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e189sm9099295pgc.15.2019.08.17.14.05.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 14:05:37 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Somnath Kotur <somnath.kotur@broadcom.com>
Subject: [PATCH net v2 6/6] bnxt_en: Fix to include flow direction in L2 key
Date:   Sat, 17 Aug 2019 17:04:52 -0400
Message-Id: <1566075892-30064-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
References: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
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

v2: Move the dir field to the end of the bnxt_tc_l2_key struct to
fix the warning reported by kbuild test robot <lkp@intel.com>.
There is existing code that initializes the structure using
nested initializer and will warn with the new u8 field added to
the beginning.  The structure also packs nicer when this new u8 is
added to the end of the structure [MChan].

Fixes: abd43a13525d ("bnxt_en: Support for 64-bit flow handle.")
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

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
index ffec57d..4f05305 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.h
@@ -23,6 +23,9 @@ struct bnxt_tc_l2_key {
 	__be16		inner_vlan_tci;
 	__be16		ether_type;
 	u8		num_vlans;
+	u8		dir;
+#define BNXT_DIR_RX	1
+#define BNXT_DIR_TX	0
 };
 
 struct bnxt_tc_l3_key {
@@ -98,9 +101,6 @@ struct bnxt_tc_flow {
 
 	/* flow applicable to pkts ingressing on this fid */
 	u16				src_fid;
-	u8				dir;
-#define BNXT_DIR_RX	1
-#define BNXT_DIR_TX	0
 	struct bnxt_tc_l2_key		l2_key;
 	struct bnxt_tc_l2_key		l2_mask;
 	struct bnxt_tc_l3_key		l3_key;
-- 
2.5.1

