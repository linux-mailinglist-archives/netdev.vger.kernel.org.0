Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB57D1E1740
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgEYVls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgEYVlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 17:41:46 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C7EC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:41:46 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id n15so368812pjt.4
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 14:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MRbeyga+U0Mdj/Shh2KODfRgtkt0O/H+93auPQBZEdc=;
        b=U5bCfts8MAhPy8pJ5FpD6sPumch+9pT3v4snB+y0WloRPG1CM8Zmu/4oMG8JfU4yZk
         hbDO94eLMvottMCuzuxOBvRIf/3mzyC6nI06DXZlWrNRHpgmZT7Ayc5LK0Ory+cd7ybl
         J9vJjjwuPsM6JonLbmAzQZr+PpU46tnemSDgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MRbeyga+U0Mdj/Shh2KODfRgtkt0O/H+93auPQBZEdc=;
        b=KYyGRAqAC0PS8YfCXDvA60XU/SirxnJpsw6cv7KwTWbSQPiiyzxj8LUv3JhREVm24w
         YdtxNv0+mbMPzwPkPNtw7iH1ouEzmf1FhK5Tmbv8rwIJ9ynZ/4LeH04IYUXZ88mtbUkp
         AI+By+RqQy2Fk4045Qnh9Un2gfO54wthZUGqZ3Kq1cQdXNqmumgmHFvfQdAcFozT+R7F
         kSXmpdP++klDH4K9qs0iqwVSuhA0wsWksNgPZeGAQ8nU4kzdffFGk7G5FtVx1DhURL/N
         aFdhmiDRXe8UWbztM2sZtFCZ4VotkruGP9YkACYcDAX0bq+kl51CDxE5e04fFoJtWS41
         H0Lw==
X-Gm-Message-State: AOAM531YDw+SyIhk1jZGyMarMRpH+hj8KOyedQfgNBwRLJNJVxLCYphO
        t/GKvwVdAbMlxcQOI7E0XuHPOYKyDlA=
X-Google-Smtp-Source: ABdhPJyQnr7dqYTf1Sk0+dSFWOPgpZ2Vc843pmMc2Hl/IzEHCY0W4kHSpgt4DGzrqsvOY3AZeSNuHg==
X-Received: by 2002:a17:902:7402:: with SMTP id g2mr30385405pll.241.1590442906284;
        Mon, 25 May 2020 14:41:46 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g1sm13309401pfo.142.2020.05.25.14.41.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 May 2020 14:41:45 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 3/3] bnxt_en: fix firmware message length endianness
Date:   Mon, 25 May 2020 17:41:19 -0400
Message-Id: <1590442879-18961-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
References: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

The explicit mask and shift is not the appropriate way to parse fields
out of a little endian struct. The length field is internally __le16
and the strategy employed only happens to work on little endian machines
because the offset used is actually incorrect (length is at offset 6).

Also remove the related and no longer used definitions from bnxt.h.

Fixes: 845adfe40c2a ("bnxt_en: Improve valid bit checking in firmware response message.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 ++++----------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  5 -----
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index abb203c..58e0d9a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4176,14 +4176,12 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	int i, intr_process, rc, tmo_count;
 	struct input *req = msg;
 	u32 *data = msg;
-	__le32 *resp_len;
 	u8 *valid;
 	u16 cp_ring_id, len = 0;
 	struct hwrm_err_output *resp = bp->hwrm_cmd_resp_addr;
 	u16 max_req_len = BNXT_HWRM_MAX_REQ_LEN;
 	struct hwrm_short_input short_input = {0};
 	u32 doorbell_offset = BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER;
-	u8 *resp_addr = (u8 *)bp->hwrm_cmd_resp_addr;
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
 
@@ -4201,7 +4199,6 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		bar_offset = BNXT_GRCPF_REG_KONG_COMM;
 		doorbell_offset = BNXT_GRCPF_REG_KONG_COMM_TRIGGER;
 		resp = bp->hwrm_cmd_kong_resp_addr;
-		resp_addr = (u8 *)bp->hwrm_cmd_kong_resp_addr;
 	}
 
 	memset(resp, 0, PAGE_SIZE);
@@ -4270,7 +4267,6 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	tmo_count = HWRM_SHORT_TIMEOUT_COUNTER;
 	timeout = timeout - HWRM_SHORT_MIN_TIMEOUT * HWRM_SHORT_TIMEOUT_COUNTER;
 	tmo_count += DIV_ROUND_UP(timeout, HWRM_MIN_TIMEOUT);
-	resp_len = (__le32 *)(resp_addr + HWRM_RESP_LEN_OFFSET);
 
 	if (intr_process) {
 		u16 seq_id = bp->hwrm_intr_seq_id;
@@ -4298,9 +4294,8 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 					   le16_to_cpu(req->req_type));
 			return -EBUSY;
 		}
-		len = (le32_to_cpu(*resp_len) & HWRM_RESP_LEN_MASK) >>
-		      HWRM_RESP_LEN_SFT;
-		valid = resp_addr + len - 1;
+		len = le16_to_cpu(resp->resp_len);
+		valid = ((u8 *)resp) + len - 1;
 	} else {
 		int j;
 
@@ -4311,8 +4306,7 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 			 */
 			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
 				return -EBUSY;
-			len = (le32_to_cpu(*resp_len) & HWRM_RESP_LEN_MASK) >>
-			      HWRM_RESP_LEN_SFT;
+			len = le16_to_cpu(resp->resp_len);
 			if (len)
 				break;
 			/* on first few passes, just barely sleep */
@@ -4334,7 +4328,7 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		}
 
 		/* Last byte of resp contains valid bit */
-		valid = resp_addr + len - 1;
+		valid = ((u8 *)resp) + len - 1;
 		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; j++) {
 			/* make sure we read from updated DMA memory */
 			dma_rmb();
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f6a3250..3d39638 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -656,11 +656,6 @@ struct nqe_cn {
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
 #define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
-#define HWRM_RESP_ERR_CODE_MASK		0xffff
-#define HWRM_RESP_LEN_OFFSET		4
-#define HWRM_RESP_LEN_MASK		0xffff0000
-#define HWRM_RESP_LEN_SFT		16
-#define HWRM_RESP_VALID_MASK		0xff000000
 #define BNXT_HWRM_REQ_MAX_SIZE		128
 #define BNXT_HWRM_REQS_PER_PAGE		(BNXT_PAGE_SIZE /	\
 					 BNXT_HWRM_REQ_MAX_SIZE)
-- 
2.5.1

