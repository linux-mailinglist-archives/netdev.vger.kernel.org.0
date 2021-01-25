Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C222130226E
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbhAYHbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:31:32 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33760 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727248AbhAYHWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:22:35 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id C083280F1;
        Sun, 24 Jan 2021 23:08:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com C083280F1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558503;
        bh=ElocyARdvFBM3y0xyz8B6lfvZALUbYxHCcaWqeLZSRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmBV8/bBXnwZ0TlzMMCIqUqqbF6FBTCeflsCqugDlB1mxZlNjxKyWSbyIptHk+rOk
         Qh6b1Ngiaq0RSNR7lnBJsbn9KstotIoq+NOLJsbZCYzLM3HM4qjPNw7M1rhlsU7ROl
         3sPU932jZ5xaLI4srbd7QY+wAVf+evNq0J+dINS8=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 11/15] bnxt_en: Add a new BNXT_STATE_NAPI_DISABLED flag to keep track of NAPI state.
Date:   Mon, 25 Jan 2021 02:08:17 -0500
Message-Id: <1611558501-11022-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up until now, we don't need to keep track of this state because NAPI
is always enabled once and disabled once during bring up and shutdown.
For better error recovery in subsequent patches, we want to quiesce
the device earlier during fatal error conditions.  The normal shutdown
sequence will disable NAPI again and the flag will prevent disabling
NAPI twice.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 98caac9fbdee..83846b50042a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8836,7 +8836,8 @@ static void bnxt_disable_napi(struct bnxt *bp)
 {
 	int i;
 
-	if (!bp->bnapi)
+	if (!bp->bnapi ||
+	    test_and_set_bit(BNXT_STATE_NAPI_DISABLED, &bp->state))
 		return;
 
 	for (i = 0; i < bp->cp_nr_rings; i++) {
@@ -8853,6 +8854,7 @@ static void bnxt_enable_napi(struct bnxt *bp)
 {
 	int i;
 
+	clear_bit(BNXT_STATE_NAPI_DISABLED, &bp->state);
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 		struct bnxt_cp_ring_info *cpr;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index bd36f00ef28c..4ef6888acdc6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1809,6 +1809,7 @@ struct bnxt {
 #define BNXT_STATE_FW_FATAL_COND	6
 #define BNXT_STATE_DRV_REGISTERED	7
 #define BNXT_STATE_PCI_CHANNEL_IO_FROZEN	8
+#define BNXT_STATE_NAPI_DISABLED	9
 
 #define BNXT_NO_FW_ACCESS(bp)					\
 	(test_bit(BNXT_STATE_FW_FATAL_COND, &(bp)->state) ||	\
-- 
2.18.1

