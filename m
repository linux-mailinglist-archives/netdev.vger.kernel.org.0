Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1CD3FA9F7
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 09:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhH2HgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 03:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbhH2HgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 03:36:22 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817FBC0617AD
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id s25so16665900edw.0
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 00:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=4Eh7IyaZ7I2mqmP+5gPGP+Ly3TDYEj24Ry4cUFTmhJQ=;
        b=ZCTuOoTUXUd8nDG2D0jwGFdHpm6lTCw0/ME1gG1ANeM5uzZRTRfve5+Cex/GZzKy/6
         PU4MLanTfW3VFPs1j6ysOURUoZWtEMS4ZPg5iCISrYr0eRxfAGQBJAY+Nr4pQzYwQ7t0
         M5iZb7pwsn7mrb/10LSpyhr6BiVL3b2k22RTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=4Eh7IyaZ7I2mqmP+5gPGP+Ly3TDYEj24Ry4cUFTmhJQ=;
        b=QXjVqRzJ/xKQ8OSJyb+GsUWacHdU0xN8dUiovBoRT6egz423G8MTJlfpg/H99EsTN0
         p3vjLiYNz4Yn393sLUTJm4tqc13mfZvOIyzfOafNIB08/zqn9WI+Bg/MM2DSHRtKwlL9
         WgVWFoZYJG2LbFOvitYCcCtx2DdRfSioR6SDrxCDnhAZ8yVsouwnhcVLbnn6kA/O5UId
         W/7W5Kv+/kt+l0YS97isSyvihA41gnQlFt7RrZDD82DO0tb5dkYWy3GlwNZ2RY8mawY7
         0n18cePzIQ4GuLUnN50xYzZ4+TorsGnyP5yNYdA61peEDCcbMdKdEVU84zc+EKFCEhWD
         TLgA==
X-Gm-Message-State: AOAM531vM8ffRGKV0jdfkmrRUQCYGwNjEAdym/G9JfzDUWF3/6Np3UY3
        wy2Z25By3kKhwSlFXVhnFApMdA==
X-Google-Smtp-Source: ABdhPJzINZwEf7l1AyONLcXmMJkRwhzRdk6CIEp2BeQHoKM3PitR9bN1yjEM+CHpV7MvUMYo0PoZmg==
X-Received: by 2002:a05:6402:4d:: with SMTP id f13mr18215305edu.275.1630222527558;
        Sun, 29 Aug 2021 00:35:27 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id dy7sm984007edb.38.2021.08.29.00.35.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Aug 2021 00:35:27 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next v2 04/11] bnxt_en: introduce new firmware message API based on DMA pools
Date:   Sun, 29 Aug 2021 03:34:59 -0400
Message-Id: <1630222506-19532-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
References: <1630222506-19532-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b4225205caadc214"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b4225205caadc214
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Edwin Peer <edwin.peer@broadcom.com>

This change constitutes a major step towards supporting multiple
firmware commands in flight by maintaining a separate response buffer
for the duration of each request. These firmware commands are also
known as Hardware Resource Manager (HWRM) commands.  Using separate
response buffers requires an API change in order for callers to be
able to free the buffer when done.

It is impossible to keep the existing APIs unchanged.  The existing
usage for a simple HWRM message request such as the following:

        struct input req = {0};
        bnxt_hwrm_cmd_hdr_init(bp, &req, REQ_TYPE, -1, -1);
        rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
        if (rc)
                /* error */

changes to:

         struct input *req;
         rc = hwrm_req_init(bp, req, REQ_TYPE);
         if (rc)
                 /* error */
         rc = hwrm_req_send(bp, req); /* consumes req */
         if (rc)
                 /* error */

The key changes are:

1. The req is no longer allocated on the stack.
2. The caller must call hwrm_req_init() to allocate a req buffer and
   check for a valid buffer.
3. The req buffer is automatically released when hwrm_req_send() returns.
4. If the caller wants to check the firmware response, the caller must
   call hwrm_req_hold() to take ownership of the response buffer and
   release it afterwards using hwrm_req_drop().  The caller is no longer
   required to explicitly hold the hwrm_cmd_lock mutex to read the
   response.
5. Because the firmware commands and responses all have different sizes,
   some safeguards are added to the code.

This patch maintains legacy API compatibiltiy, implementing the old
API in terms of the new.  The follow-on patches will convert all
callers to use the new APIs.

v2: Fix redefined writeq with parisc .config
    Fix "cast from pointer to integer of different size" warning in
hwrm_calc_sentinel()

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  42 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   7 +-
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 460 +++++++++++++++---
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.h    |  54 +-
 4 files changed, 442 insertions(+), 121 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 10c39801ad5f..23486f382b91 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3963,6 +3963,9 @@ static void bnxt_free_hwrm_resources(struct bnxt *bp)
 				  bp->hwrm_cmd_resp_dma_addr);
 		bp->hwrm_cmd_resp_addr = NULL;
 	}
+
+	dma_pool_destroy(bp->hwrm_dma_pool);
+	bp->hwrm_dma_pool = NULL;
 }
 
 static int bnxt_alloc_hwrm_resources(struct bnxt *bp)
@@ -3975,33 +3978,10 @@ static int bnxt_alloc_hwrm_resources(struct bnxt *bp)
 	if (!bp->hwrm_cmd_resp_addr)
 		return -ENOMEM;
 
-	return 0;
-}
-
-static void bnxt_free_hwrm_short_cmd_req(struct bnxt *bp)
-{
-	if (bp->hwrm_short_cmd_req_addr) {
-		struct pci_dev *pdev = bp->pdev;
-
-		dma_free_coherent(&pdev->dev, bp->hwrm_max_ext_req_len,
-				  bp->hwrm_short_cmd_req_addr,
-				  bp->hwrm_short_cmd_req_dma_addr);
-		bp->hwrm_short_cmd_req_addr = NULL;
-	}
-}
-
-static int bnxt_alloc_hwrm_short_cmd_req(struct bnxt *bp)
-{
-	struct pci_dev *pdev = bp->pdev;
-
-	if (bp->hwrm_short_cmd_req_addr)
-		return 0;
-
-	bp->hwrm_short_cmd_req_addr =
-		dma_alloc_coherent(&pdev->dev, bp->hwrm_max_ext_req_len,
-				   &bp->hwrm_short_cmd_req_dma_addr,
-				   GFP_KERNEL);
-	if (!bp->hwrm_short_cmd_req_addr)
+	bp->hwrm_dma_pool = dma_pool_create("bnxt_hwrm", &pdev->dev,
+					    BNXT_HWRM_DMA_SIZE,
+					    BNXT_HWRM_DMA_ALIGN, 0);
+	if (!bp->hwrm_dma_pool)
 		return -ENOMEM;
 
 	return 0;
@@ -11654,12 +11634,6 @@ static int bnxt_fw_init_one_p1(struct bnxt *bp)
 			return rc;
 	}
 
-	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
-	    bp->hwrm_max_ext_req_len > BNXT_HWRM_MAX_REQ_LEN) {
-		rc = bnxt_alloc_hwrm_short_cmd_req(bp);
-		if (rc)
-			return rc;
-	}
 	bnxt_nvm_cfg_ver_get(bp);
 
 	rc = bnxt_hwrm_func_reset(bp);
@@ -12588,7 +12562,6 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_clear_int_mode(bp);
 	bnxt_hwrm_func_drv_unrgtr(bp);
 	bnxt_free_hwrm_resources(bp);
-	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_ethtool_free(bp);
 	bnxt_dcb_free(bp);
 	kfree(bp->edev);
@@ -13188,7 +13161,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 init_err_pci_clean:
 	bnxt_hwrm_func_drv_unrgtr(bp);
-	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
 	bnxt_ethtool_free(bp);
 	bnxt_ptp_clear(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5ff71eeffdd8..79a78a7468f3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1881,10 +1881,9 @@ struct bnxt {
 	u16			hwrm_cmd_seq;
 	u16                     hwrm_cmd_kong_seq;
 	u16			hwrm_intr_seq_id;
-	void			*hwrm_short_cmd_req_addr;
-	dma_addr_t		hwrm_short_cmd_req_dma_addr;
 	void			*hwrm_cmd_resp_addr;
 	dma_addr_t		hwrm_cmd_resp_dma_addr;
+	struct dma_pool		*hwrm_dma_pool;
 
 	struct rtnl_link_stats64	net_stats_prev;
 	struct bnxt_stats_mem	port_stats;
@@ -1984,7 +1983,7 @@ struct bnxt {
 	struct mutex		sriov_lock;
 #endif
 
-#if BITS_PER_LONG == 32
+#ifndef writeq
 	/* ensure atomic 64-bit doorbell writes on 32-bit systems. */
 	spinlock_t		db_lock;
 #endif
@@ -2113,7 +2112,7 @@ static inline u32 bnxt_tx_avail(struct bnxt *bp, struct bnxt_tx_ring_info *txr)
 		((txr->tx_prod - txr->tx_cons) & bp->tx_ring_mask);
 }
 
-#if BITS_PER_LONG == 32
+#ifndef writeq
 #define writeq(val64, db)			\
 do {						\
 	spin_lock(&bp->db_lock);		\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index b2a211b6cdd0..a45f2a619086 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -35,7 +35,220 @@ void bnxt_hwrm_cmd_hdr_init(struct bnxt *bp, void *request, u16 req_type,
 	req->resp_addr = cpu_to_le64(bp->hwrm_cmd_resp_dma_addr);
 }
 
-static int bnxt_hwrm_to_stderr(u32 hwrm_err)
+static u64 hwrm_calc_sentinel(struct bnxt_hwrm_ctx *ctx, u16 req_type)
+{
+	return (((uintptr_t)ctx) + req_type) ^ BNXT_HWRM_SENTINEL;
+}
+
+/**
+ * __hwrm_req_init() - Initialize an HWRM request.
+ * @bp: The driver context.
+ * @req: A pointer to the request pointer to initialize.
+ * @req_type: The request type. This will be converted to the little endian
+ *	before being written to the req_type field of the returned request.
+ * @req_len: The length of the request to be allocated.
+ *
+ * Allocate DMA resources and initialize a new HWRM request object of the
+ * given type. The response address field in the request is configured with
+ * the DMA bus address that has been mapped for the response and the passed
+ * request is pointed to kernel virtual memory mapped for the request (such
+ * that short_input indirection can be accomplished without copying). The
+ * request’s target and completion ring are initialized to default values and
+ * can be overridden by writing to the returned request object directly.
+ *
+ * The initialized request can be further customized by writing to its fields
+ * directly, taking care to covert such fields to little endian. The request
+ * object will be consumed (and all its associated resources release) upon
+ * passing it to hwrm_req_send() unless ownership of the request has been
+ * claimed by the caller via a call to hwrm_req_hold(). If the request is not
+ * consumed, either because it is never sent or because ownership has been
+ * claimed, then it must be released by a call to hwrm_req_drop().
+ *
+ * Return: zero on success, negative error code otherwise:
+ *	E2BIG: the type of request pointer is too large to fit.
+ *	ENOMEM: an allocation failure occurred.
+ */
+int __hwrm_req_init(struct bnxt *bp, void **req, u16 req_type, u32 req_len)
+{
+	struct bnxt_hwrm_ctx *ctx;
+	dma_addr_t dma_handle;
+	u8 *req_addr;
+
+	if (req_len > BNXT_HWRM_CTX_OFFSET)
+		return -E2BIG;
+
+	req_addr = dma_pool_alloc(bp->hwrm_dma_pool, GFP_KERNEL | __GFP_ZERO,
+				  &dma_handle);
+	if (!req_addr)
+		return -ENOMEM;
+
+	ctx = (struct bnxt_hwrm_ctx *)(req_addr + BNXT_HWRM_CTX_OFFSET);
+	/* safety first, sentinel used to check for invalid requests */
+	ctx->sentinel = hwrm_calc_sentinel(ctx, req_type);
+	ctx->req_len = req_len;
+	ctx->req = (struct input *)req_addr;
+	ctx->resp = (struct output *)(req_addr + BNXT_HWRM_RESP_OFFSET);
+	ctx->dma_handle = dma_handle;
+	ctx->flags = 0; /* __GFP_ZERO, but be explicit regarding ownership */
+	ctx->timeout = bp->hwrm_cmd_timeout ?: DFLT_HWRM_CMD_TIMEOUT;
+
+	/* initialize common request fields */
+	ctx->req->req_type = cpu_to_le16(req_type);
+	ctx->req->resp_addr = cpu_to_le64(dma_handle + BNXT_HWRM_RESP_OFFSET);
+	ctx->req->cmpl_ring = cpu_to_le16(BNXT_HWRM_NO_CMPL_RING);
+	ctx->req->target_id = cpu_to_le16(BNXT_HWRM_TARGET);
+	*req = ctx->req;
+
+	return 0;
+}
+
+static struct bnxt_hwrm_ctx *__hwrm_ctx(struct bnxt *bp, u8 *req_addr)
+{
+	void *ctx_addr = req_addr + BNXT_HWRM_CTX_OFFSET;
+	struct input *req = (struct input *)req_addr;
+	struct bnxt_hwrm_ctx *ctx = ctx_addr;
+	u64 sentinel;
+
+	if (!req) {
+		/* can only be due to software bug, be loud */
+		netdev_err(bp->dev, "null HWRM request");
+		dump_stack();
+		return NULL;
+	}
+
+	/* HWRM API has no type safety, verify sentinel to validate address */
+	sentinel = hwrm_calc_sentinel(ctx, le16_to_cpu(req->req_type));
+	if (ctx->sentinel != sentinel) {
+		/* can only be due to software bug, be loud */
+		netdev_err(bp->dev, "HWRM sentinel mismatch, req_type = %u\n",
+			   (u32)le16_to_cpu(req->req_type));
+		dump_stack();
+		return NULL;
+	}
+
+	return ctx;
+}
+
+/**
+ * hwrm_req_timeout() - Set the completion timeout for the request.
+ * @bp: The driver context.
+ * @req: The request to set the timeout.
+ * @timeout: The timeout in milliseconds.
+ *
+ * Set the timeout associated with the request for subsequent calls to
+ * hwrm_req_send(). Some requests are long running and require a different
+ * timeout than the default.
+ */
+void hwrm_req_timeout(struct bnxt *bp, void *req, unsigned int timeout)
+{
+	struct bnxt_hwrm_ctx *ctx = __hwrm_ctx(bp, req);
+
+	if (ctx)
+		ctx->timeout = timeout;
+}
+
+/**
+ * hwrm_req_flags() - Set non internal flags of the ctx
+ * @bp: The driver context.
+ * @req: The request containing the HWRM command
+ * @flags: ctx flags that don't have BNXT_HWRM_INTERNAL_FLAG set
+ *
+ * ctx flags can be used by the callers to instruct how the subsequent
+ * hwrm_req_send() should behave. Example: callers can use hwrm_req_flags
+ * with BNXT_HWRM_CTX_SILENT to omit kernel prints of errors of hwrm_req_send()
+ * or with BNXT_HWRM_FULL_WAIT enforce hwrm_req_send() to wait for full timeout
+ * even if FW is not responding.
+ * This generic function can be used to set any flag that is not an internal flag
+ * of the HWRM module.
+ */
+void hwrm_req_flags(struct bnxt *bp, void *req, enum bnxt_hwrm_ctx_flags flags)
+{
+	struct bnxt_hwrm_ctx *ctx = __hwrm_ctx(bp, req);
+
+	if (ctx)
+		ctx->flags |= (flags & HWRM_API_FLAGS);
+}
+
+/**
+ * hwrm_req_hold() - Claim ownership of the request's resources.
+ * @bp: The driver context.
+ * @req: A pointer to the request to own. The request will no longer be
+ *	consumed by calls to hwrm_req_send().
+ *
+ * Take ownership of the request. Ownership places responsibility on the
+ * caller to free the resources associated with the request via a call to
+ * hwrm_req_drop(). The caller taking ownership implies that a subsequent
+ * call to hwrm_req_send() will not consume the request (ie. sending will
+ * not free the associated resources if the request is owned by the caller).
+ * Taking ownership returns a reference to the response. Retaining and
+ * accessing the response data is the most common reason to take ownership
+ * of the request. Ownership can also be acquired in order to reuse the same
+ * request object across multiple invocations of hwrm_req_send().
+ *
+ * Return: A pointer to the response object.
+ *
+ * The resources associated with the response will remain available to the
+ * caller until ownership of the request is relinquished via a call to
+ * hwrm_req_drop(). It is not possible for hwrm_req_hold() to return NULL if
+ * a valid request is provided. A returned NULL value would imply a driver
+ * bug and the implementation will complain loudly in the logs to aid in
+ * detection. It should not be necessary to check the result for NULL.
+ */
+void *hwrm_req_hold(struct bnxt *bp, void *req)
+{
+	struct bnxt_hwrm_ctx *ctx = __hwrm_ctx(bp, req);
+	struct input *input = (struct input *)req;
+
+	if (!ctx)
+		return NULL;
+
+	if (ctx->flags & BNXT_HWRM_INTERNAL_CTX_OWNED) {
+		/* can only be due to software bug, be loud */
+		netdev_err(bp->dev, "HWRM context already owned, req_type = %u\n",
+			   (u32)le16_to_cpu(input->req_type));
+		dump_stack();
+		return NULL;
+	}
+
+	ctx->flags |= BNXT_HWRM_INTERNAL_CTX_OWNED;
+	return ((u8 *)req) + BNXT_HWRM_RESP_OFFSET;
+}
+
+static void __hwrm_ctx_drop(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
+{
+	void *addr = ((u8 *)ctx) - BNXT_HWRM_CTX_OFFSET;
+	dma_addr_t dma_handle = ctx->dma_handle; /* save before invalidate */
+
+	/* invalidate, ensure ownership, sentinel and dma_handle are cleared */
+	memset(ctx, 0, sizeof(struct bnxt_hwrm_ctx));
+
+	/* return the buffer to the DMA pool */
+	if (dma_handle)
+		dma_pool_free(bp->hwrm_dma_pool, addr, dma_handle);
+}
+
+/**
+ * hwrm_req_drop() - Release all resources associated with the request.
+ * @bp: The driver context.
+ * @req: The request to consume, releasing the associated resources. The
+ *	request object and its associated response are no longer valid.
+ *
+ * It is legal to call hwrm_req_drop() on an unowned request, provided it
+ * has not already been consumed by hwrm_req_send() (for example, to release
+ * an aborted request). A given request should not be dropped more than once,
+ * nor should it be dropped after having been consumed by hwrm_req_send(). To
+ * do so is an error (the context will not be found and a stack trace will be
+ * rendered in the kernel log).
+ */
+void hwrm_req_drop(struct bnxt *bp, void *req)
+{
+	struct bnxt_hwrm_ctx *ctx = __hwrm_ctx(bp, req);
+
+	if (ctx)
+		__hwrm_ctx_drop(bp, ctx);
+}
+
+static int __hwrm_to_stderr(u32 hwrm_err)
 {
 	switch (hwrm_err) {
 	case HWRM_ERR_CODE_SUCCESS:
@@ -64,78 +277,71 @@ static int bnxt_hwrm_to_stderr(u32 hwrm_err)
 	}
 }
 
-static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
-				 int timeout, bool silent)
+static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 {
-	int i, intr_process, rc, tmo_count;
-	struct input *req = msg;
-	u32 *data = msg;
-	u8 *valid;
-	u16 cp_ring_id, len = 0;
-	struct hwrm_err_output *resp = bp->hwrm_cmd_resp_addr;
-	u16 max_req_len = BNXT_HWRM_MAX_REQ_LEN;
-	struct hwrm_short_input short_input = {0};
 	u32 doorbell_offset = BNXT_GRCPF_REG_CHIMP_COMM_TRIGGER;
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
+	struct hwrm_short_input short_input = {0};
+	u16 max_req_len = BNXT_HWRM_MAX_REQ_LEN;
+	unsigned int i, timeout, tmo_count;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
+	int intr_process, rc = -EBUSY;
+	u32 *data = (u32 *)ctx->req;
+	u32 msg_len = ctx->req_len;
+	u16 cp_ring_id, len = 0;
+	u32 req_type;
+	u8 *valid;
 
-	if (BNXT_NO_FW_ACCESS(bp) &&
-	    le16_to_cpu(req->req_type) != HWRM_FUNC_RESET)
-		return -EBUSY;
+	if (ctx->flags & BNXT_HWRM_INTERNAL_RESP_DIRTY)
+		memset(ctx->resp, 0, PAGE_SIZE);
 
-	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {
-		if (msg_len > bp->hwrm_max_ext_req_len ||
-		    !bp->hwrm_short_cmd_req_addr)
-			return -EINVAL;
+	req_type = le16_to_cpu(ctx->req->req_type);
+	if (BNXT_NO_FW_ACCESS(bp) && req_type != HWRM_FUNC_RESET)
+		goto exit;
+
+	if (msg_len > BNXT_HWRM_MAX_REQ_LEN &&
+	    msg_len > bp->hwrm_max_ext_req_len) {
+		rc = -E2BIG;
+		goto exit;
 	}
 
-	if (bnxt_kong_hwrm_message(bp, req)) {
+	if (bnxt_kong_hwrm_message(bp, ctx->req)) {
 		dst = BNXT_HWRM_CHNL_KONG;
 		bar_offset = BNXT_GRCPF_REG_KONG_COMM;
 		doorbell_offset = BNXT_GRCPF_REG_KONG_COMM_TRIGGER;
+		if (le16_to_cpu(ctx->req->cmpl_ring) != INVALID_HW_RING_ID) {
+			netdev_err(bp->dev, "Ring completions not supported for KONG commands, req_type = %d\n",
+				   req_type);
+			rc = -EINVAL;
+			goto exit;
+		}
 	}
 
-	memset(resp, 0, PAGE_SIZE);
-	cp_ring_id = le16_to_cpu(req->cmpl_ring);
+	cp_ring_id = le16_to_cpu(ctx->req->cmpl_ring);
 	intr_process = (cp_ring_id == INVALID_HW_RING_ID) ? 0 : 1;
 
-	req->seq_id = cpu_to_le16(bnxt_get_hwrm_seq_id(bp, dst));
+	ctx->req->seq_id = cpu_to_le16(bnxt_get_hwrm_seq_id(bp, dst));
 	/* currently supports only one outstanding message */
 	if (intr_process)
-		bp->hwrm_intr_seq_id = le16_to_cpu(req->seq_id);
+		bp->hwrm_intr_seq_id = le16_to_cpu(ctx->req->seq_id);
 
 	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
 	    msg_len > BNXT_HWRM_MAX_REQ_LEN) {
-		void *short_cmd_req = bp->hwrm_short_cmd_req_addr;
-		u16 max_msg_len;
-
-		/* Set boundary for maximum extended request length for short
-		 * cmd format. If passed up from device use the max supported
-		 * internal req length.
-		 */
-		max_msg_len = bp->hwrm_max_ext_req_len;
-
-		memcpy(short_cmd_req, req, msg_len);
-		if (msg_len < max_msg_len)
-			memset(short_cmd_req + msg_len, 0,
-			       max_msg_len - msg_len);
-
-		short_input.req_type = req->req_type;
+		short_input.req_type = ctx->req->req_type;
 		short_input.signature =
 				cpu_to_le16(SHORT_REQ_SIGNATURE_SHORT_CMD);
 		short_input.size = cpu_to_le16(msg_len);
-		short_input.req_addr =
-			cpu_to_le64(bp->hwrm_short_cmd_req_dma_addr);
+		short_input.req_addr = cpu_to_le64(ctx->dma_handle);
 
 		data = (u32 *)&short_input;
 		msg_len = sizeof(short_input);
 
-		/* Sync memory write before updating doorbell */
-		wmb();
-
 		max_req_len = BNXT_HWRM_SHORT_REQ_LEN;
 	}
 
+	/* Ensure any associated DMA buffers are written before doorbell */
+	wmb();
+
 	/* Write request msg to hwrm channel */
 	__iowrite32_copy(bp->bar0 + bar_offset, data, msg_len / 4);
 
@@ -145,13 +351,13 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	/* Ring channel doorbell */
 	writel(1, bp->bar0 + doorbell_offset);
 
-	if (!pci_is_enabled(bp->pdev))
-		return -ENODEV;
+	if (!pci_is_enabled(bp->pdev)) {
+		rc = -ENODEV;
+		goto exit;
+	}
 
-	if (!timeout)
-		timeout = DFLT_HWRM_CMD_TIMEOUT;
 	/* Limit timeout to an upper limit */
-	timeout = min(timeout, HWRM_CMD_MAX_TIMEOUT);
+	timeout = min_t(uint, ctx->timeout, HWRM_CMD_MAX_TIMEOUT);
 	/* convert timeout to usec */
 	timeout *= 1000;
 
@@ -174,13 +380,13 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 			 * check has failed.
 			 */
 			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
-				return -EBUSY;
+				goto exit;
 			/* on first few passes, just barely sleep */
 			if (i < HWRM_SHORT_TIMEOUT_COUNTER) {
 				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
 					     HWRM_SHORT_MAX_TIMEOUT);
 			} else {
-				if (HWRM_WAIT_MUST_ABORT(bp, req))
+				if (HWRM_WAIT_MUST_ABORT(bp, ctx))
 					break;
 				usleep_range(HWRM_MIN_TIMEOUT,
 					     HWRM_MAX_TIMEOUT);
@@ -188,13 +394,13 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		}
 
 		if (bp->hwrm_intr_seq_id != (u16)~seq_id) {
-			if (!silent)
+			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
 				netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
-					   le16_to_cpu(req->req_type));
-			return -EBUSY;
+					   le16_to_cpu(ctx->req->req_type));
+			goto exit;
 		}
-		len = le16_to_cpu(resp->resp_len);
-		valid = ((u8 *)resp) + len - 1;
+		len = le16_to_cpu(ctx->resp->resp_len);
+		valid = ((u8 *)ctx->resp) + len - 1;
 	} else {
 		int j;
 
@@ -204,8 +410,8 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 			 * check has failed.
 			 */
 			if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
-				return -EBUSY;
-			len = le16_to_cpu(resp->resp_len);
+				goto exit;
+			len = le16_to_cpu(ctx->resp->resp_len);
 			if (len)
 				break;
 			/* on first few passes, just barely sleep */
@@ -213,7 +419,7 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 				usleep_range(HWRM_SHORT_MIN_TIMEOUT,
 					     HWRM_SHORT_MAX_TIMEOUT);
 			} else {
-				if (HWRM_WAIT_MUST_ABORT(bp, req))
+				if (HWRM_WAIT_MUST_ABORT(bp, ctx))
 					goto timeout_abort;
 				usleep_range(HWRM_MIN_TIMEOUT,
 					     HWRM_MAX_TIMEOUT);
@@ -222,16 +428,16 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 
 		if (i >= tmo_count) {
 timeout_abort:
-			if (!silent)
-				netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d\n",
-					   HWRM_TOTAL_TIMEOUT(i),
-					   le16_to_cpu(req->req_type),
-					   le16_to_cpu(req->seq_id), len);
-			return -EBUSY;
+			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
+				netdev_err(bp->dev, "Error (timeout: %u) msg {0x%x 0x%x} len:%d\n",
+					   hwrm_total_timeout(i),
+					   le16_to_cpu(ctx->req->req_type),
+					   le16_to_cpu(ctx->req->seq_id), len);
+			goto exit;
 		}
 
 		/* Last byte of resp contains valid bit */
-		valid = ((u8 *)resp) + len - 1;
+		valid = ((u8 *)ctx->resp) + len - 1;
 		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; j++) {
 			/* make sure we read from updated DMA memory */
 			dma_rmb();
@@ -241,13 +447,13 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		}
 
 		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
-			if (!silent)
-				netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d v:%d\n",
-					   HWRM_TOTAL_TIMEOUT(i),
-					   le16_to_cpu(req->req_type),
-					   le16_to_cpu(req->seq_id), len,
+			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
+				netdev_err(bp->dev, "Error (timeout: %u) msg {0x%x 0x%x} len:%d v:%d\n",
+					   hwrm_total_timeout(i),
+					   le16_to_cpu(ctx->req->req_type),
+					   le16_to_cpu(ctx->req->seq_id), len,
 					   *valid);
-			return -EBUSY;
+			goto exit;
 		}
 	}
 
@@ -256,12 +462,53 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	 * a new field not implemented by old spec will read zero.
 	 */
 	*valid = 0;
-	rc = le16_to_cpu(resp->error_code);
-	if (rc && !silent)
+	rc = le16_to_cpu(ctx->resp->error_code);
+	if (rc && !(ctx->flags & BNXT_HWRM_CTX_SILENT)) {
 		netdev_err(bp->dev, "hwrm req_type 0x%x seq id 0x%x error 0x%x\n",
-			   le16_to_cpu(resp->req_type),
-			   le16_to_cpu(resp->seq_id), rc);
-	return bnxt_hwrm_to_stderr(rc);
+			   le16_to_cpu(ctx->resp->req_type),
+			   le16_to_cpu(ctx->resp->seq_id), rc);
+	}
+	rc = __hwrm_to_stderr(rc);
+exit:
+	if (ctx->flags & BNXT_HWRM_INTERNAL_CTX_OWNED)
+		ctx->flags |= BNXT_HWRM_INTERNAL_RESP_DIRTY;
+	else
+		__hwrm_ctx_drop(bp, ctx);
+	return rc;
+}
+
+static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
+				 int timeout, bool silent)
+{
+	struct bnxt_hwrm_ctx default_ctx = {0};
+	struct bnxt_hwrm_ctx *ctx = &default_ctx;
+	struct input *req = msg;
+	int rc;
+
+	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) ||
+	    msg_len > BNXT_HWRM_MAX_REQ_LEN) {
+		rc = __hwrm_req_init(bp, (void **)&req,
+				     le16_to_cpu(req->req_type), msg_len);
+		if (rc)
+			return rc;
+		memcpy(req, msg, msg_len); /* also copies resp_addr */
+		ctx = __hwrm_ctx(bp, (u8 *)req);
+		/* belts and brances, NULL ctx shouldn't be possible here */
+		if (!ctx)
+			return -ENOMEM;
+	}
+
+	ctx->req = req;
+	ctx->req_len = msg_len;
+	ctx->resp = bp->hwrm_cmd_resp_addr;
+	/* global response is not reallocated __GFP_ZERO between requests */
+	ctx->flags = BNXT_HWRM_INTERNAL_RESP_DIRTY;
+	ctx->timeout = timeout ?: DFLT_HWRM_CMD_TIMEOUT;
+	if (silent)
+		ctx->flags |= BNXT_HWRM_CTX_SILENT;
+
+	/* will consume req if allocated with __hwrm_req_init() */
+	return __hwrm_send(bp, ctx);
 }
 
 int _hwrm_send_message(struct bnxt *bp, void *msg, u32 msg_len, int timeout)
@@ -295,3 +542,64 @@ int hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 msg_len,
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
+
+/**
+ * hwrm_req_send() - Execute an HWRM command.
+ * @bp: The driver context.
+ * @req: A pointer to the request to send. The DMA resources associated with
+ *	the request will be released (ie. the request will be consumed) unless
+ *	ownership of the request has been assumed by the caller via a call to
+ *	hwrm_req_hold().
+ *
+ * Send an HWRM request to the device and wait for a response. The request is
+ * consumed if it is not owned by the caller. This function will block until
+ * the request has either completed or times out due to an error.
+ *
+ * Return: A result code.
+ *
+ * The result is zero on success, otherwise the negative error code indicates
+ * one of the following errors:
+ *	E2BIG: The request was too large.
+ *	EBUSY: The firmware is in a fatal state or the request timed out
+ *	EACCESS: HWRM access denied.
+ *	ENOSPC: HWRM resource allocation error.
+ *	EINVAL: Request parameters are invalid.
+ *	ENOMEM: HWRM has no buffers.
+ *	EAGAIN: HWRM busy or reset in progress.
+ *	EOPNOTSUPP: Invalid request type.
+ *	EIO: Any other error.
+ * Error handling is orthogonal to request ownership. An unowned request will
+ * still be consumed on error. If the caller owns the request, then the caller
+ * is responsible for releasing the resources. Otherwise, hwrm_req_send() will
+ * always consume the request.
+ */
+int hwrm_req_send(struct bnxt *bp, void *req)
+{
+	struct bnxt_hwrm_ctx *ctx = __hwrm_ctx(bp, req);
+	int rc;
+
+	if (!ctx)
+		return -EINVAL;
+
+	mutex_lock(&bp->hwrm_cmd_lock);
+	rc = __hwrm_send(bp, ctx);
+	mutex_unlock(&bp->hwrm_cmd_lock);
+	return rc;
+}
+
+/**
+ * hwrm_req_send_silent() - A silent version of hwrm_req_send().
+ * @bp: The driver context.
+ * @req: The request to send without logging.
+ *
+ * The same as hwrm_req_send(), except that the request is silenced using
+ * hwrm_req_silence() prior the call. This version of the function is
+ * provided solely to preserve the legacy API’s flavor for this functionality.
+ *
+ * Return: A result code, see hwrm_req_send().
+ */
+int hwrm_req_send_silent(struct bnxt *bp, void *req)
+{
+	hwrm_req_flags(bp, req, BNXT_HWRM_CTX_SILENT);
+	return hwrm_req_send(bp, req);
+}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index 940c792b54c7..199c646f5e71 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -12,6 +12,26 @@
 
 #include "bnxt_hsi.h"
 
+enum bnxt_hwrm_ctx_flags {
+	/* Update the HWRM_API_FLAGS right below for any new non-internal bit added here */
+	BNXT_HWRM_INTERNAL_CTX_OWNED	= BIT(0), /* caller owns the context */
+	BNXT_HWRM_INTERNAL_RESP_DIRTY	= BIT(1), /* response contains data */
+	BNXT_HWRM_CTX_SILENT		= BIT(2), /* squelch firmware errors */
+	BNXT_HWRM_FULL_WAIT		= BIT(3), /* wait for full timeout of HWRM command */
+};
+
+#define HWRM_API_FLAGS (BNXT_HWRM_CTX_SILENT | BNXT_HWRM_FULL_WAIT)
+
+struct bnxt_hwrm_ctx {
+	u64 sentinel;
+	dma_addr_t dma_handle;
+	struct output *resp;
+	struct input *req;
+	u32 req_len;
+	enum bnxt_hwrm_ctx_flags flags;
+	unsigned int timeout;
+};
+
 #define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
 #define BNXT_HWRM_SHORT_REQ_LEN		sizeof(struct hwrm_short_input)
 #define HWRM_CMD_MAX_TIMEOUT		40000
@@ -19,7 +39,17 @@
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
 #define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
+#define BNXT_HWRM_TARGET		0xffff
+#define BNXT_HWRM_NO_CMPL_RING		-1
 #define BNXT_HWRM_REQ_MAX_SIZE		128
+#define BNXT_HWRM_DMA_SIZE		(2 * PAGE_SIZE) /* space for req+resp */
+#define BNXT_HWRM_RESP_RESERVED		PAGE_SIZE
+#define BNXT_HWRM_RESP_OFFSET		(BNXT_HWRM_DMA_SIZE -		\
+					 BNXT_HWRM_RESP_RESERVED)
+#define BNXT_HWRM_CTX_OFFSET		(BNXT_HWRM_RESP_OFFSET -	\
+					 sizeof(struct bnxt_hwrm_ctx))
+#define BNXT_HWRM_DMA_ALIGN		16
+#define BNXT_HWRM_SENTINEL		0xb6e1f68a12e9a7eb /* arbitrary value */
 #define BNXT_HWRM_REQS_PER_PAGE		(BNXT_PAGE_SIZE /	\
 					 BNXT_HWRM_REQ_MAX_SIZE)
 #define HWRM_SHORT_MIN_TIMEOUT		3
@@ -29,14 +59,17 @@
 #define HWRM_MIN_TIMEOUT		25
 #define HWRM_MAX_TIMEOUT		40
 
-#define HWRM_WAIT_MUST_ABORT(bp, req)					\
-	(le16_to_cpu((req)->req_type) != HWRM_VER_GET &&		\
+#define HWRM_WAIT_MUST_ABORT(bp, ctx)					\
+	(le16_to_cpu((ctx)->req->req_type) != HWRM_VER_GET &&		\
 	 !bnxt_is_fw_healthy(bp))
 
-#define HWRM_TOTAL_TIMEOUT(n)	(((n) <= HWRM_SHORT_TIMEOUT_COUNTER) ?	\
-	((n) * HWRM_SHORT_MIN_TIMEOUT) :				\
-	(HWRM_SHORT_TIMEOUT_COUNTER * HWRM_SHORT_MIN_TIMEOUT +		\
-	 ((n) - HWRM_SHORT_TIMEOUT_COUNTER) * HWRM_MIN_TIMEOUT))
+static inline unsigned int hwrm_total_timeout(unsigned int n)
+{
+	return n <= HWRM_SHORT_TIMEOUT_COUNTER ? n * HWRM_SHORT_MIN_TIMEOUT :
+		HWRM_SHORT_TIMEOUT_COUNTER * HWRM_SHORT_MIN_TIMEOUT +
+		(n - HWRM_SHORT_TIMEOUT_COUNTER) * HWRM_MIN_TIMEOUT;
+}
+
 
 #define HWRM_VALID_BIT_DELAY_USEC	150
 
@@ -97,4 +130,13 @@ int _hwrm_send_message(struct bnxt *bp, void *msg, u32 len, int timeout);
 int _hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 len, int timeout);
 int hwrm_send_message(struct bnxt *bp, void *msg, u32 len, int timeout);
 int hwrm_send_message_silent(struct bnxt *bp, void *msg, u32 len, int timeout);
+int __hwrm_req_init(struct bnxt *bp, void **req, u16 req_type, u32 req_len);
+#define hwrm_req_init(bp, req, req_type) \
+	__hwrm_req_init((bp), (void **)&(req), (req_type), sizeof(*(req)))
+void *hwrm_req_hold(struct bnxt *bp, void *req);
+void hwrm_req_drop(struct bnxt *bp, void *req);
+void hwrm_req_flags(struct bnxt *bp, void *req, enum bnxt_hwrm_ctx_flags flags);
+void hwrm_req_timeout(struct bnxt *bp, void *req, unsigned int timeout);
+int hwrm_req_send(struct bnxt *bp, void *req);
+int hwrm_req_send_silent(struct bnxt *bp, void *req);
 #endif
-- 
2.18.1


--000000000000b4225205caadc214
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINLIDZku/8QM+duDinzwtU/62Km7rHrT
/R4qipdSUQg0MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
OTA3MzUyOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBXyCx5yBfnluc2AoNFIzql2qf1xqoRPZdE8su+tuJYAx2HL+YK
XVTIYV4kclH8rjFNjR5IuGMaMGjp1kaqm+84usUHxNEDRIjA+/QZmw20yB4muwH0RbOMLyf0haIR
my0ba4Z8JoLsYSwJMr60taR6Ywdmng2djJvZ9s/NftbysSlD2ZctoW59n6Oaeq+QccDzvVhX5AHB
Yc5wQP/URp4ynv3oop8KCgrxEkdk1YLVPnO8RLQ+4G+9yNjwrnfoVoVQohTIZi2qZuCy1rytmvji
KdTiwOnjSTWU/qUbwlH+40ssEDseQCimLgs/3aw+7+cnScQllpqFnJlbOW017Iks
--000000000000b4225205caadc214--
