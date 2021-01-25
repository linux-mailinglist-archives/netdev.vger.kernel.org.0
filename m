Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7221430226A
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbhAYHaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:30:01 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33756 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727234AbhAYHWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:22:35 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 5359080E2;
        Sun, 24 Jan 2021 23:08:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 5359080E2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558503;
        bh=hX1ehjN/bcERG+Clw4VFk1IdjWQOc/g+BIBciaBagjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfS6W2vuk+AWAVZxC1LQUfPFZhP3/964BqPEeMV5GwQ8lgT7UPJvWQxo5ZK4ChwQ2
         zqMgsLGeGTdwn5u8eVeUb14JAQvHBTI+ranq/0yU8XQ5ebVTbhQ44zvWfIB1oMLsUZ
         hrlK5BKjKINXiggXW5eIT3Ky3d2CKWQAXjiLkFB0=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 08/15] bnxt_en: attempt to reinitialize after aborted reset
Date:   Mon, 25 Jan 2021 02:08:14 -0500
Message-Id: <1611558501-11022-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

Drawing a hard line on aborted resets prevents a NIC open in
some scenarios that may otherwise be recoverable. For example,
if a firmware recovery happened while a PF was down and an
attempt was made to bring up an associated VF in this state,
then it was impossible to ever bring up this VF without a
rebind or reload of its driver.

Attempt to reinitialize the firmware when an aborted reset (or
failed init after a reset) is discovered during open - it may
succeed. Also take care to allow the user to retry opening the
NIC even after an aborted reset.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 29 +++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c8c25f7644ae..7f30a9fee0c8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9768,6 +9768,25 @@ static void bnxt_preset_reg_win(struct bnxt *bp)
 
 static int bnxt_init_dflt_ring_mode(struct bnxt *bp);
 
+static int bnxt_reinit_after_abort(struct bnxt *bp)
+{
+	int rc;
+
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+		return -EBUSY;
+
+	rc = bnxt_fw_init_one(bp);
+	if (!rc) {
+		bnxt_clear_int_mode(bp);
+		rc = bnxt_init_int_mode(bp);
+		if (!rc) {
+			clear_bit(BNXT_STATE_ABORT_ERR, &bp->state);
+			set_bit(BNXT_STATE_FW_RESET_DET, &bp->state);
+		}
+	}
+	return rc;
+}
+
 static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 {
 	int rc = 0;
@@ -9926,8 +9945,14 @@ static int bnxt_open(struct net_device *dev)
 	int rc;
 
 	if (test_bit(BNXT_STATE_ABORT_ERR, &bp->state)) {
-		netdev_err(bp->dev, "A previous firmware reset did not complete, aborting\n");
-		return -ENODEV;
+		rc = bnxt_reinit_after_abort(bp);
+		if (rc) {
+			if (rc == -EBUSY)
+				netdev_err(bp->dev, "A previous firmware reset has not completed, aborting\n");
+			else
+				netdev_err(bp->dev, "Failed to reinitialize after aborted firmware reset\n");
+			return -ENODEV;
+		}
 	}
 
 	rc = bnxt_hwrm_if_change(bp, true);
-- 
2.18.1

