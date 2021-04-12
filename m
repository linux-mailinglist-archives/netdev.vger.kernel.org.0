Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBBE35B7BA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhDLASl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:18:41 -0400
Received: from saphodev.broadcom.com ([192.19.232.172]:60284 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235941AbhDLASg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:18:36 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 8DE0B3CED1;
        Sun, 11 Apr 2021 17:18:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 8DE0B3CED1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618186699;
        bh=i9uPe1nOVpLMGUWlcrDZSY7bGEbFEWjRlKYUMmfzsX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghXCVmUzZyvMN4UKK487MVsa2oa9Jtetf4Vw3fxxdCu/Odt8k03kGwF/a8PvCgCoi
         +zr5Zdsf+OhMKWcbNHNccWnezSBCR4IOEZf0dbsZjeumEW+IU70lNyJ6ZXtv4VPpEJ
         Dfr7zUFZzWq9zKDKS6GHREEF99zDiRJlWnGKQan8=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 4/5] bnxt_en: Refactor __bnxt_vf_reps_destroy().
Date:   Sun, 11 Apr 2021 20:18:14 -0400
Message-Id: <1618186695-18823-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new helper function __bnxt_free_one_vf_rep() to free one VF rep.
We also reintialize the VF rep fields to proper initial values so that
the function can be used without freeing the VF rep data structure.  This
will be used in subsequent patches to free and recreate VF reps after
error recovery.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index b5d6cd63bea7..a4ac11f5b0e5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -288,6 +288,21 @@ void bnxt_vf_reps_open(struct bnxt *bp)
 		bnxt_vf_rep_open(bp->vf_reps[i]->dev);
 }
 
+static void __bnxt_free_one_vf_rep(struct bnxt *bp, struct bnxt_vf_rep *vf_rep)
+{
+	if (!vf_rep)
+		return;
+
+	if (vf_rep->dst) {
+		dst_release((struct dst_entry *)vf_rep->dst);
+		vf_rep->dst = NULL;
+	}
+	if (vf_rep->tx_cfa_action != CFA_HANDLE_INVALID) {
+		hwrm_cfa_vfr_free(bp, vf_rep->vf_idx);
+		vf_rep->tx_cfa_action = CFA_HANDLE_INVALID;
+	}
+}
+
 static void __bnxt_vf_reps_destroy(struct bnxt *bp)
 {
 	u16 num_vfs = pci_num_vf(bp->pdev);
@@ -297,11 +312,7 @@ static void __bnxt_vf_reps_destroy(struct bnxt *bp)
 	for (i = 0; i < num_vfs; i++) {
 		vf_rep = bp->vf_reps[i];
 		if (vf_rep) {
-			dst_release((struct dst_entry *)vf_rep->dst);
-
-			if (vf_rep->tx_cfa_action != CFA_HANDLE_INVALID)
-				hwrm_cfa_vfr_free(bp, vf_rep->vf_idx);
-
+			__bnxt_free_one_vf_rep(bp, vf_rep);
 			if (vf_rep->dev) {
 				/* if register_netdev failed, then netdev_ops
 				 * would have been set to NULL
-- 
2.18.1

