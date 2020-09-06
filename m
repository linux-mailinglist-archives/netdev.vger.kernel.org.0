Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD2B25EC36
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 04:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgIFCz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 22:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbgIFCzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 22:55:51 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68589C061573
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 19:55:51 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s10so2915305plp.1
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 19:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zFbvft9lBMSz2gGZ6CsDgcHMULuuJfQk4PukonXGLvo=;
        b=T0hKDJjTRrMRXZPTb5MXAi8IzQ2chN4UmqBumhDi72d3CI83AbSDZFgKz224oHfv9Q
         QVhE+Oa33d8OVRox16A5PNyTLNwpv1gVraIXGadDZ3X209wpVQkHM3tH+YMe/GAM0R9K
         JjOqofec1ouDZXr0iIHA9kdGEzazKvPOPoQ6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zFbvft9lBMSz2gGZ6CsDgcHMULuuJfQk4PukonXGLvo=;
        b=nqE7NMZtUkdj4FQ+WYvMMkS9IvAI40aonK86cAvskwgm2U0B+sMUWaYUDukAIJFr99
         QZPNjZ7x9VMEWBIQJuZvtsMbvZQHw/HunrJLF9DLwio2DUzgbLFZPC3m/rpCPJz7DWSZ
         KeUQ9F7Dklt2uZ1mTXyj2rCdjaqDW6FQm/94dl79Na9yM9DZfzH8HUIp+yClEDlmTSwN
         bnwq3nD7AZ40HH5r9exFk5Jn4WSicmM44xM7A9xpHjImrKvoLZFpV2KazxEt0b4LHzOf
         H47D3voT0TosqQpf+mi44k7SRqKO57yLaVo2ibidxe1Ygxvv1QghqqcebuWb+Jl9l0zt
         u0sg==
X-Gm-Message-State: AOAM530TxPRDbJ3SO3JFd2+jAc85BdozlRWOwISR+SSp23U1i5z0A4iY
        yFGZ2IRd7RX9w3gR0/W5qTg25cNUCAyXGw==
X-Google-Smtp-Source: ABdhPJxDeRWRtuomi+z6TeFR1oOR9jvk7NpuIuctpdDm4nBfGUo+e0yTyfogZgroIxhJ3OD0ekYV7A==
X-Received: by 2002:a17:90a:9285:: with SMTP id n5mr15630875pjo.64.1599360949588;
        Sat, 05 Sep 2020 19:55:49 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm1346959pgn.75.2020.09.05.19.55.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2020 19:55:49 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 1/2] bnxt_en: Avoid sending firmware messages when AER error is detected.
Date:   Sat,  5 Sep 2020 22:55:36 -0400
Message-Id: <1599360937-26197-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
References: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

When the driver goes through PCIe AER reset in error state, all
firmware messages will timeout because the PCIe bus is no longer
accessible.  This can lead to AER reset taking many minutes to
complete as each firmware command takes time to timeout.

Define a new macro BNXT_NO_FW_ACCESS() to skip these firmware messages
when either firmware is in fatal error state or when
pci_channel_offline() is true.  It now takes a more reasonable 20 to
30 seconds to complete AER recovery.

Fixes: b4fff2079d10 ("bnxt_en: Do not send firmware messages if firmware is in error state.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b167066..619eb55 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4305,7 +4305,7 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
 
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	if (BNXT_NO_FW_ACCESS(bp))
 		return -EBUSY;
 
 	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {
@@ -5723,7 +5723,7 @@ static int hwrm_ring_free_send_msg(struct bnxt *bp,
 	struct hwrm_ring_free_output *resp = bp->hwrm_cmd_resp_addr;
 	u16 error_code;
 
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	if (BNXT_NO_FW_ACCESS(bp))
 		return 0;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_RING_FREE, cmpl_ring_id, -1);
@@ -7817,7 +7817,7 @@ static int bnxt_set_tpa(struct bnxt *bp, bool set_tpa)
 
 	if (set_tpa)
 		tpa_flags = bp->flags & BNXT_FLAG_TPA;
-	else if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	else if (BNXT_NO_FW_ACCESS(bp))
 		return 0;
 	for (i = 0; i < bp->nr_vnics; i++) {
 		rc = bnxt_hwrm_vnic_set_tpa(bp, i, tpa_flags);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5a13eb6..0ef89da 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1737,6 +1737,10 @@ struct bnxt {
 #define BNXT_STATE_FW_FATAL_COND	6
 #define BNXT_STATE_DRV_REGISTERED	7
 
+#define BNXT_NO_FW_ACCESS(bp)					\
+	(test_bit(BNXT_STATE_FW_FATAL_COND, &(bp)->state) ||	\
+	 pci_channel_offline((bp)->pdev))
+
 	struct bnxt_irq	*irq_tbl;
 	int			total_irqs;
 	u8			mac_addr[ETH_ALEN];
-- 
1.8.3.1

