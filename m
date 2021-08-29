Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A183FA9FF
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 09:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhH2Hgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 03:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbhH2Hgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 03:36:37 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE9AC0613A3
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id t19so23720427ejr.8
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1XgNrfLc8IqWQHmDa6s0en4QhN3PmaVxY4iBe4/v1qc=;
        b=DFyrBMdKapuruPcn09geLW8al/DqJO0oxYDlwN4earF/LkdzkDC/F7VD5WOhG+RCBj
         M6u2FalvcxFr1TNHMNdGDDkdTg4Ww6HU+Sw0RYKBvuOen4mQuVL2lw+o6FTHBkpj9eI2
         uzEsCkAfIeTkS5oibi57IJaBZfdVkEAiSDM80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1XgNrfLc8IqWQHmDa6s0en4QhN3PmaVxY4iBe4/v1qc=;
        b=mZYNbGfpx1sucWLbnhPWpsNlSEXjhTSt54op+H+fyCsSn+KN/KcQM6+HAUmxRHHHLW
         zuYX01ubqPENHYKFnAI386vFUwASQhaF0h1OVsL90bMseZAIuS2eD7jSKkWjOlp4qOdW
         DdbQfZUJWxsLk0qPySQhgpT6QIOn9bWOW0nqQP9tfJK2lKzeVrl+6qbKKJ6KLynas9eL
         FlEU5kt/t1lLTdyM85Wu/+KDDxzr50tZfXyyX1Pot7X6H0pDBaHsACHsC5jVqzqZT3UG
         lknMsrwibuYTQiMbtEKg4v12IuFJedcAfK4p/QCy1tTsl5opMTDspBefHmQ7XaEVvXcM
         Zehg==
X-Gm-Message-State: AOAM530Vo6vxagSsB04OF9J1B2YGVxPdU9jlzz0ikUJMzloINm8+/n9P
        U7S62t3OwkEiVmOxenxe5NNbFarL7t9crw==
X-Google-Smtp-Source: ABdhPJxeK5w7RPDOiL7UoHCpapCMInPo1zacsNiSsnbcX/lbK2NxQvVVNLxaSxCzPIfhOVTSNWGtMA==
X-Received: by 2002:a17:906:9742:: with SMTP id o2mr19244753ejy.532.1630222542989;
        Sun, 29 Aug 2021 00:35:42 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id dy7sm984007edb.38.2021.08.29.00.35.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Aug 2021 00:35:42 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next v2 11/11] bnxt_en: support multiple HWRM commands in flight
Date:   Sun, 29 Aug 2021 03:35:06 -0400
Message-Id: <1630222506-19532-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
References: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009d93e205caadc332"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000009d93e205caadc332

From: Edwin Peer <edwin.peer@broadcom.com>

Add infrastructure to maintain a pending list of HWRM commands awaiting
completion and reduce the scope of the hwrm_cmd_lock mutex so that it
protects only the request mailbox. The mailbox is free to use for one
or more concurrent commands after receiving deferred response events.

For uniformity and completeness, use the same pending list for
collecting completions for commands that respond via a completion ring.
These commands are only used for freeing rings and for IRQ test and
we only support one such command in flight.

Note deferred responses are also only supported on the main channel.
The secondary channel (KONG) does not support deferred responses.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 21 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 +-
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 96 +++++++++++++++----
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.h    | 33 ++++---
 4 files changed, 113 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ddec1163748d..627f85ee3922 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -277,6 +277,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY,
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
 	ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION,
+	ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE,
 	ASYNC_EVENT_CMPL_EVENT_ID_RING_MONITOR_MSG,
 	ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST,
 	ASYNC_EVENT_CMPL_EVENT_ID_PPS_TIMESTAMP,
@@ -2269,6 +2270,12 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		bnxt_event_error_report(bp, data1, data2);
 		goto async_event_process_exit;
 	}
+	case ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE: {
+		u16 seq_id = le32_to_cpu(cmpl->event_data2) & 0xffff;
+
+		hwrm_update_token(bp, seq_id, BNXT_HWRM_DEFERRED);
+		goto async_event_process_exit;
+	}
 	default:
 		goto async_event_process_exit;
 	}
@@ -2288,10 +2295,7 @@ static int bnxt_hwrm_handler(struct bnxt *bp, struct tx_cmp *txcmp)
 	switch (cmpl_type) {
 	case CMPL_BASE_TYPE_HWRM_DONE:
 		seq_id = le16_to_cpu(h_cmpl->sequence_id);
-		if (seq_id == bp->hwrm_intr_seq_id)
-			bp->hwrm_intr_seq_id = (u16)~bp->hwrm_intr_seq_id;
-		else
-			netdev_err(bp->dev, "Invalid hwrm seq id %d\n", seq_id);
+		hwrm_update_token(bp, seq_id, BNXT_HWRM_COMPLETE);
 		break;
 
 	case CMPL_BASE_TYPE_HWRM_FWD_REQ:
@@ -3956,8 +3960,15 @@ static int bnxt_alloc_vnic_attributes(struct bnxt *bp)
 
 static void bnxt_free_hwrm_resources(struct bnxt *bp)
 {
+	struct bnxt_hwrm_wait_token *token;
+
 	dma_pool_destroy(bp->hwrm_dma_pool);
 	bp->hwrm_dma_pool = NULL;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(token, &bp->hwrm_pending_list, node)
+		WRITE_ONCE(token->state, BNXT_HWRM_CANCELLED);
+	rcu_read_unlock();
 }
 
 static int bnxt_alloc_hwrm_resources(struct bnxt *bp)
@@ -3968,6 +3979,8 @@ static int bnxt_alloc_hwrm_resources(struct bnxt *bp)
 	if (!bp->hwrm_dma_pool)
 		return -ENOMEM;
 
+	INIT_HLIST_HEAD(&bp->hwrm_pending_list);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f343e87bef0b..a8212dcdad5f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1880,8 +1880,8 @@ struct bnxt {
 	u32			hwrm_spec_code;
 	u16			hwrm_cmd_seq;
 	u16                     hwrm_cmd_kong_seq;
-	u16			hwrm_intr_seq_id;
 	struct dma_pool		*hwrm_dma_pool;
+	struct hlist_head	hwrm_pending_list;
 
 	struct rtnl_link_stats64	net_stats_prev;
 	struct bnxt_stats_mem	port_stats;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 60ec0caa5c56..acef61abe35d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/skbuff.h>
@@ -363,19 +364,72 @@ static int __hwrm_to_stderr(u32 hwrm_err)
 	}
 }
 
+static struct bnxt_hwrm_wait_token *
+__hwrm_acquire_token(struct bnxt *bp, enum bnxt_hwrm_chnl dst)
+{
+	struct bnxt_hwrm_wait_token *token;
+
+	token = kzalloc(sizeof(*token), GFP_KERNEL);
+	if (!token)
+		return NULL;
+
+	mutex_lock(&bp->hwrm_cmd_lock);
+
+	token->dst = dst;
+	token->state = BNXT_HWRM_PENDING;
+	if (dst == BNXT_HWRM_CHNL_CHIMP) {
+		token->seq_id = bp->hwrm_cmd_seq++;
+		hlist_add_head_rcu(&token->node, &bp->hwrm_pending_list);
+	} else {
+		token->seq_id = bp->hwrm_cmd_kong_seq++;
+	}
+
+	return token;
+}
+
+static void
+__hwrm_release_token(struct bnxt *bp, struct bnxt_hwrm_wait_token *token)
+{
+	if (token->dst == BNXT_HWRM_CHNL_CHIMP) {
+		hlist_del_rcu(&token->node);
+		kfree_rcu(token, rcu);
+	} else {
+		kfree(token);
+	}
+	mutex_unlock(&bp->hwrm_cmd_lock);
+}
+
+void
+hwrm_update_token(struct bnxt *bp, u16 seq_id, enum bnxt_hwrm_wait_state state)
+{
+	struct bnxt_hwrm_wait_token *token;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(token, &bp->hwrm_pending_list, node) {
+		if (token->seq_id == seq_id) {
+			WRITE_ONCE(token->state, state);
+			rcu_read_unlock();
+			return;
+		}
+	}
+	rcu_read_unlock();
+	netdev_err(bp->dev, "Invalid hwrm seq id %d\n", seq_id);
+}
+
 static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 {
 	u32 doorbell_offset = BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER;
+	enum bnxt_hwrm_chnl dst = BNXT_HWRM_CHNL_CHIMP;
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
+	struct bnxt_hwrm_wait_token *token = NULL;
 	struct hwrm_short_input short_input = {0};
 	u16 max_req_len = BNXT_HWRM_MAX_REQ_LEN;
 	unsigned int i, timeout, tmo_count;
-	u16 dst = BNXT_HWRM_CHNL_CHIMP;
-	int intr_process, rc = -EBUSY;
 	u32 *data = (u32 *)ctx->req;
 	u32 msg_len = ctx->req_len;
-	u16 cp_ring_id, len = 0;
+	int rc = -EBUSY;
 	u32 req_type;
+	u16 len = 0;
 	u8 *valid;
 
 	if (ctx->flags & BNXT_HWRM_INTERNAL_RESP_DIRTY)
@@ -403,13 +457,12 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 		}
 	}
 
-	cp_ring_id = le16_to_cpu(ctx->req->cmpl_ring);
-	intr_process = (cp_ring_id == INVALID_HW_RING_ID) ? 0 : 1;
-
-	ctx->req->seq_id = cpu_to_le16(bnxt_get_hwrm_seq_id(bp, dst));
-	/* currently supports only one outstanding message */
-	if (intr_process)
-		bp->hwrm_intr_seq_id = le16_to_cpu(ctx->req->seq_id);
+	token = __hwrm_acquire_token(bp, dst);
+	if (!token) {
+		rc = -ENOMEM;
+		goto exit;
+	}
+	ctx->req->seq_id = cpu_to_le16(token->seq_id);
 
 	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
 	    msg_len > BNXT_HWRM_MAX_REQ_LEN) {
@@ -456,11 +509,9 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	timeout = timeout - HWRM_SHORT_MIN_TIMEOUT * HWRM_SHORT_TIMEOUT_COUNTER;
 	tmo_count += DIV_ROUND_UP(timeout, HWRM_MIN_TIMEOUT);
 
-	if (intr_process) {
-		u16 seq_id = bp->hwrm_intr_seq_id;
-
+	if (le16_to_cpu(ctx->req->cmpl_ring) != INVALID_HW_RING_ID) {
 		/* Wait until hwrm response cmpl interrupt is processed */
-		while (bp->hwrm_intr_seq_id != (u16)~seq_id &&
+		while (READ_ONCE(token->state) < BNXT_HWRM_COMPLETE &&
 		       i++ < tmo_count) {
 			/* Abort the wait for completion if the FW health
 			 * check has failed.
@@ -479,7 +530,7 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 			}
 		}
 
-		if (bp->hwrm_intr_seq_id != (u16)~seq_id) {
+		if (READ_ONCE(token->state) != BNXT_HWRM_COMPLETE) {
 			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
 				netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
 					   le16_to_cpu(ctx->req->req_type));
@@ -498,6 +549,13 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 			 */
 			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
 				goto exit;
+
+			if (token &&
+			    READ_ONCE(token->state) == BNXT_HWRM_DEFERRED) {
+				__hwrm_release_token(bp, token);
+				token = NULL;
+			}
+
 			len = le16_to_cpu(READ_ONCE(ctx->resp->resp_len));
 			if (len) {
 				__le16 resp_seq = READ_ONCE(ctx->resp->seq_id);
@@ -569,6 +627,8 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	}
 	rc = __hwrm_to_stderr(rc);
 exit:
+	if (token)
+		__hwrm_release_token(bp, token);
 	if (ctx->flags & BNXT_HWRM_INTERNAL_CTX_OWNED)
 		ctx->flags |= BNXT_HWRM_INTERNAL_RESP_DIRTY;
 	else
@@ -609,15 +669,11 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 int hwrm_req_send(struct bnxt *bp, void *req)
 {
 	struct bnxt_hwrm_ctx *ctx = __hwrm_ctx(bp, req);
-	int rc;
 
 	if (!ctx)
 		return -EINVAL;
 
-	mutex_lock(&bp->hwrm_cmd_lock);
-	rc = __hwrm_send(bp, ctx);
-	mutex_unlock(&bp->hwrm_cmd_lock);
-	return rc;
+	return __hwrm_send(bp, ctx);
 }
 
 /**
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index 39032cf66258..4d17f0d5363b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -37,6 +37,25 @@ struct bnxt_hwrm_ctx {
 	gfp_t gfp;
 };
 
+enum bnxt_hwrm_wait_state {
+	BNXT_HWRM_PENDING,
+	BNXT_HWRM_DEFERRED,
+	BNXT_HWRM_COMPLETE,
+	BNXT_HWRM_CANCELLED,
+};
+
+enum bnxt_hwrm_chnl { BNXT_HWRM_CHNL_CHIMP, BNXT_HWRM_CHNL_KONG };
+
+struct bnxt_hwrm_wait_token {
+	struct rcu_head rcu;
+	struct hlist_node node;
+	enum bnxt_hwrm_wait_state state;
+	enum bnxt_hwrm_chnl dst;
+	u16 seq_id;
+};
+
+void hwrm_update_token(struct bnxt *bp, u16 seq, enum bnxt_hwrm_wait_state s);
+
 #define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
 #define BNXT_HWRM_SHORT_REQ_LEN		sizeof(struct hwrm_short_input)
 #define HWRM_CMD_MAX_TIMEOUT		40000
@@ -78,9 +97,6 @@ static inline unsigned int hwrm_total_timeout(unsigned int n)
 
 #define HWRM_VALID_BIT_DELAY_USEC	150
 
-#define BNXT_HWRM_CHNL_CHIMP	0
-#define BNXT_HWRM_CHNL_KONG	1
-
 static inline bool bnxt_cfa_hwrm_message(u16 req_type)
 {
 	switch (req_type) {
@@ -114,17 +130,6 @@ static inline bool bnxt_kong_hwrm_message(struct bnxt *bp, struct input *req)
 		 le16_to_cpu(req->target_id) == HWRM_TARGET_ID_KONG));
 }
 
-static inline u16 bnxt_get_hwrm_seq_id(struct bnxt *bp, u16 dst)
-{
-	u16 seq_id;
-
-	if (dst == BNXT_HWRM_CHNL_CHIMP)
-		seq_id = bp->hwrm_cmd_seq++;
-	else
-		seq_id = bp->hwrm_cmd_kong_seq++;
-	return seq_id;
-}
-
 int __hwrm_req_init(struct bnxt *bp, void **req, u16 req_type, u32 req_len);
 #define hwrm_req_init(bp, req, req_type) \
 	__hwrm_req_init((bp), (void **)&(req), (req_type), sizeof(*(req)))
-- 
2.18.1


--0000000000009d93e205caadc332
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAB+MYprfSERkEFV2QCySeiKGYYT2ZXA
TtkhD/4luw5LMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
OTA3MzU0M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQB/qQ4RA2jiUbikVovFuRBf66EG+Hk/+afqH0lpJpWM0nugse7r
saZo0nG36l+tGlqP+HZhUvrjik7PLPisaoO6aCTUiR6M4bwih01l1risw4Wy1Mpc+wOSDhe4CEls
sM6VcP5GK5GKKV99wb8jEaFoQbKxrxR6zGfSGGLB08Hk3kDHTUY8zAsy+tdlG5dYfVjppViE0oPU
29Wr5UwSf3hSt0oOY/xg3X7IYr0rOXNOad+Qv1YknlCNDXb2AuhpNwUfIxUP1ffSN508C69x2+y+
tPhWbAwxkqHpR2PhYvqaLK+XHdpFi354leWciJr0jDPC63EcTyDDMXJ+MkVt54Yu
--0000000000009d93e205caadc332--
