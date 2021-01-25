Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1DE302278
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbhAYHgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:36:43 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33742 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727243AbhAYHWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:22:03 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 6C3637A51;
        Sun, 24 Jan 2021 23:08:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 6C3637A51
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558502;
        bh=rLB4tGyOrnDJIrcxPjan3TVZfTPm4xTW0I3JrAtphE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0EpNd4SMwus8z+hqrKg0u9OorWrldQJ2vxwpv5x/YpNLIRaZuhOre6w2cjq6r8Mh
         /3JH+2dWGij2fcY7aydY3oJ3ypwV+6s0P2GSvG7Sg//35EC5XIj43VtDgB2Wv7Qc3z
         J/+AghA7OAq6n9x6ayLQZDfz+0JmjlPtOkseMrYk=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 02/15] bnxt_en: Define macros for the various health register states.
Date:   Mon, 25 Jan 2021 02:08:08 -0500
Message-Id: <1611558501-11022-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define macros to check for the various states in the lower 16 bits of
the health register.  Replace the C code that checks for these values
with the newly defined macros.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 10 ++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  7 +++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d68065367cf2..a1dd80a0fcf6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1534,9 +1534,19 @@ struct bnxt_fw_reporter_ctx {
 #define BNXT_FW_HEALTH_WIN_OFF(reg)	(BNXT_FW_HEALTH_WIN_BASE +	\
 					 ((reg) & BNXT_GRC_OFFSET_MASK))
 
+#define BNXT_FW_STATUS_HEALTH_MSK	0xffff
 #define BNXT_FW_STATUS_HEALTHY		0x8000
 #define BNXT_FW_STATUS_SHUTDOWN		0x100000
 
+#define BNXT_FW_IS_HEALTHY(sts)		(((sts) & BNXT_FW_STATUS_HEALTH_MSK) ==\
+					 BNXT_FW_STATUS_HEALTHY)
+
+#define BNXT_FW_IS_BOOTING(sts)		(((sts) & BNXT_FW_STATUS_HEALTH_MSK) < \
+					 BNXT_FW_STATUS_HEALTHY)
+
+#define BNXT_FW_IS_ERR(sts)		(((sts) & BNXT_FW_STATUS_HEALTH_MSK) > \
+					 BNXT_FW_STATUS_HEALTHY)
+
 struct bnxt {
 	void __iomem		*bar0;
 	void __iomem		*bar1;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 6b7b69ed62db..90a31b4a3020 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -44,21 +44,20 @@ static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
 				     struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
-	u32 val, health_status;
+	u32 val;
 	int rc;
 
 	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return 0;
 
 	val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
-	health_status = val & 0xffff;
 
-	if (health_status < BNXT_FW_STATUS_HEALTHY) {
+	if (BNXT_FW_IS_BOOTING(val)) {
 		rc = devlink_fmsg_string_pair_put(fmsg, "Description",
 						  "Not yet completed initialization");
 		if (rc)
 			return rc;
-	} else if (health_status > BNXT_FW_STATUS_HEALTHY) {
+	} else if (BNXT_FW_IS_ERR(val)) {
 		rc = devlink_fmsg_string_pair_put(fmsg, "Description",
 						  "Encountered fatal error and cannot recover");
 		if (rc)
-- 
2.18.1

