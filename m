Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D579435B7B9
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhDLASi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:18:38 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:60292 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235916AbhDLASf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:18:35 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id E33B1828A;
        Sun, 11 Apr 2021 17:18:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com E33B1828A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618186698;
        bh=7s8cPZ6ZNSJpEE4BLay8/TSpe3pH9CepvY7GWQP1dIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIH70wBvkSu7Dh7nEbmCgSh5Bm3sooQkhZDYkJfSia0C3FVhklciF+oNCy3SBOGSg
         kHAjBQVLp4W5FEcQRVZtq4nmW19BSCoUP50ONh9i6OXSjRftM3Dw5WuNb0CdDlsKXs
         4iUBmDpo7LTMdcLvlq7BHs29kfzBxt50ttzoj4PM=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 3/5] bnxt_en: Refactor bnxt_vf_reps_create().
Date:   Sun, 11 Apr 2021 20:18:13 -0400
Message-Id: <1618186695-18823-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

Add a new function bnxt_alloc_vf_rep() to allocate a VF representor.
This function will be needed in subsequent patches to recreate the
VF reps after error recovery.

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 40 ++++++++++---------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 4b5c8fd76a51..b5d6cd63bea7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -350,6 +350,26 @@ void bnxt_vf_reps_destroy(struct bnxt *bp)
 	__bnxt_vf_reps_destroy(bp);
 }
 
+static int bnxt_alloc_vf_rep(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
+			     u16 *cfa_code_map)
+{
+	/* get cfa handles from FW */
+	if (hwrm_cfa_vfr_alloc(bp, vf_rep->vf_idx, &vf_rep->tx_cfa_action,
+			       &vf_rep->rx_cfa_code))
+		return -ENOLINK;
+
+	cfa_code_map[vf_rep->rx_cfa_code] = vf_rep->vf_idx;
+	vf_rep->dst = metadata_dst_alloc(0, METADATA_HW_PORT_MUX, GFP_KERNEL);
+	if (!vf_rep->dst)
+		return -ENOMEM;
+
+	/* only cfa_action is needed to mux a packet while TXing */
+	vf_rep->dst->u.port_info.port_id = vf_rep->tx_cfa_action;
+	vf_rep->dst->u.port_info.lower_dev = bp->dev;
+
+	return 0;
+}
+
 /* Use the OUI of the PF's perm addr and report the same mac addr
  * for the same VF-rep each time
  */
@@ -428,25 +448,9 @@ static int bnxt_vf_reps_create(struct bnxt *bp)
 		vf_rep->vf_idx = i;
 		vf_rep->tx_cfa_action = CFA_HANDLE_INVALID;
 
-		/* get cfa handles from FW */
-		rc = hwrm_cfa_vfr_alloc(bp, vf_rep->vf_idx,
-					&vf_rep->tx_cfa_action,
-					&vf_rep->rx_cfa_code);
-		if (rc) {
-			rc = -ENOLINK;
-			goto err;
-		}
-		cfa_code_map[vf_rep->rx_cfa_code] = vf_rep->vf_idx;
-
-		vf_rep->dst = metadata_dst_alloc(0, METADATA_HW_PORT_MUX,
-						 GFP_KERNEL);
-		if (!vf_rep->dst) {
-			rc = -ENOMEM;
+		rc = bnxt_alloc_vf_rep(bp, vf_rep, cfa_code_map);
+		if (rc)
 			goto err;
-		}
-		/* only cfa_action is needed to mux a packet while TXing */
-		vf_rep->dst->u.port_info.port_id = vf_rep->tx_cfa_action;
-		vf_rep->dst->u.port_info.lower_dev = bp->dev;
 
 		bnxt_vf_rep_netdev_init(bp, vf_rep, dev);
 		rc = register_netdev(dev);
-- 
2.18.1

