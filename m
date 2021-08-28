Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1BC3FA7C5
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 23:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhH1WAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 18:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbhH1V75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 17:59:57 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1170AC0617AD
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:59:03 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id q3so15430425edt.5
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1jlr3QwvWfWQVTl11CbQZ4JpmbmxsNtCxTNRTi+EVAI=;
        b=X8GgcrndxeKxdPBq0JqHq2GrSxgDotLIKuBAi0vvvq/dvjMUdDW5cXsTT65T2pFCb6
         8fo8xvgoqbUJUp1xa7bY5rFEuzFA7UvsANUqn/AXkNrW8el65ZP5nNMVSAhvlxDGqFAm
         s/U2p3nzMivJmPP3hgccECFk+51hEdxYBmfM8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1jlr3QwvWfWQVTl11CbQZ4JpmbmxsNtCxTNRTi+EVAI=;
        b=MBqCqhTVE82NEWM2k8usjz5CFkFPi384Tw1dVgUgx4cl+Lmxk709WgUYGwHPEKozHC
         mVTMxvEhzRW4uZakNMlzijNg2hJ+EvowQ6MulZQkCI7LNlXCZJKPknLnK1tCXO0VDylW
         SgAFm6eus6nSuAJowILwM6Q3P24OY54z1gaXSrYFnFleNhv96oScIQMJAB2dUpHUWGhO
         naEn/tBmpB0wVd3u5raqwCeliQ06AzSXxSl7uqWA7EVFEeQ6R2xaNMEyrhEO6pYc9TH2
         pm6Jp1AX+8l+FoeXEyznTq4qD/Jq5w5Shtp8BY4grroozTm4O70GMOFkiA64rcQ1cbj0
         jG9w==
X-Gm-Message-State: AOAM5335Yw3o/ODeSk2WbE5yYQKassFyXWk2dY8Ru/k9DRkkBWPjg+S6
        KDcTzBp//RoT41SruU01YDbjqQ==
X-Google-Smtp-Source: ABdhPJy9OBRjjikESTT4B5tprk1tqXAxSmi7Hoq0L5BzifAffXqolyf/g/ck88pJFr3hhqJe5ucajA==
X-Received: by 2002:aa7:db82:: with SMTP id u2mr17067188edt.299.1630187941064;
        Sat, 28 Aug 2021 14:59:01 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cf11sm5361239edb.65.2021.08.28.14.58.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Aug 2021 14:59:00 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next 07/11] bnxt_en: add support for HWRM request slices
Date:   Sat, 28 Aug 2021 17:58:26 -0400
Message-Id: <1630187910-22252-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
References: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000030980505caa5b52c"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000030980505caa5b52c

From: Edwin Peer <edwin.peer@broadcom.com>

Slices are a mechanism for suballocating DMA mapped regions from the
request buffer. Such regions can be used for indirect command data
instead of creating new mappings with dma_alloc_coherent().

The advantage of using a slice is that the lifetime of the slice is
bound to the request and will be automatically unmapped when the
request is consumed.

A single external region is also supported. This allows for regions
that will not fit inside the spare request buffer space such that
the same API can be used consistently even for larger mappings.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    | 115 +++++++++++++++++-
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.h    |   7 ++
 2 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 7d3cee8bdf7a..b246a0dd3011 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -91,6 +91,9 @@ int __hwrm_req_init(struct bnxt *bp, void **req, u16 req_type, u32 req_len)
 	ctx->dma_handle = dma_handle;
 	ctx->flags = 0; /* __GFP_ZERO, but be explicit regarding ownership */
 	ctx->timeout = bp->hwrm_cmd_timeout ?: DFLT_HWRM_CMD_TIMEOUT;
+	ctx->allocated = BNXT_HWRM_DMA_SIZE - BNXT_HWRM_CTX_OFFSET;
+	ctx->gfp = GFP_KERNEL;
+	ctx->slice_addr = NULL;
 
 	/* initialize common request fields */
 	ctx->req->req_type = cpu_to_le16(req_type);
@@ -147,6 +150,29 @@ void hwrm_req_timeout(struct bnxt *bp, void *req, unsigned int timeout)
 		ctx->timeout = timeout;
 }
 
+/**
+ * hwrm_req_alloc_flags() - Sets GFP allocation flags for slices.
+ * @bp: The driver context.
+ * @req: The request for which calls to hwrm_req_dma_slice() will have altered
+ *	allocation flags.
+ * @flags: A bitmask of GFP flags. These flags are passed to
+ *	dma_alloc_coherent() whenever it is used to allocate backing memory
+ *	for slices. Note that calls to hwrm_req_dma_slice() will not always
+ *	result in new allocations, however, memory suballocated from the
+ *	request buffer is already __GFP_ZERO.
+ *
+ * Sets the GFP allocation flags associated with the request for subsequent
+ * calls to hwrm_req_dma_slice(). This can be useful for specifying __GFP_ZERO
+ * for slice allocations.
+ */
+void hwrm_req_alloc_flags(struct bnxt *bp, void *req, gfp_t gfp)
+{
+	struct bnxt_hwrm_ctx *ctx = __hwrm_ctx(bp, req);
+
+	if (ctx)
+		ctx->gfp = gfp;
+}
+
 /**
  * hwrm_req_replace() - Replace request data.
  * @bp: The driver context.
@@ -166,7 +192,8 @@ void hwrm_req_timeout(struct bnxt *bp, void *req, unsigned int timeout)
  * reference the new request and use it in lieu of req during subsequent
  * calls to hwrm_req_send(). The resource management is associated with
  * req and is independent of and does not apply to new_req. The caller must
- * ensure that the lifetime of new_req is least as long as req.
+ * ensure that the lifetime of new_req is least as long as req. Any slices
+ * that may have been associated with the original request are released.
  *
  * Return: zero on success, negative error code otherwise:
  *     E2BIG: Request is too large.
@@ -184,6 +211,15 @@ int hwrm_req_replace(struct bnxt *bp, void *req, void *new_req, u32 len)
 	if (len > BNXT_HWRM_CTX_OFFSET)
 		return -E2BIG;
 
+	/* free any existing slices */
+	ctx->allocated = BNXT_HWRM_DMA_SIZE - BNXT_HWRM_CTX_OFFSET;
+	if (ctx->slice_addr) {
+		dma_free_coherent(&bp->pdev->dev, ctx->slice_size,
+				  ctx->slice_addr, ctx->slice_handle);
+		ctx->slice_addr = NULL;
+	}
+	ctx->gfp = GFP_KERNEL;
+
 	if ((bp->fw_cap & BNXT_FW_CAP_SHORT_CMD) || len > BNXT_HWRM_MAX_REQ_LEN) {
 		memcpy(internal_req, new_req, len);
 	} else {
@@ -274,6 +310,11 @@ static void __hwrm_ctx_drop(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	void *addr = ((u8 *)ctx) - BNXT_HWRM_CTX_OFFSET;
 	dma_addr_t dma_handle = ctx->dma_handle; /* save before invalidate */
 
+	/* unmap any auxiliary DMA slice */
+	if (ctx->slice_addr)
+		dma_free_coherent(&bp->pdev->dev, ctx->slice_size,
+				  ctx->slice_addr, ctx->slice_handle);
+
 	/* invalidate, ensure ownership, sentinel and dma_handle are cleared */
 	memset(ctx, 0, sizeof(struct bnxt_hwrm_ctx));
 
@@ -286,7 +327,8 @@ static void __hwrm_ctx_drop(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
  * hwrm_req_drop() - Release all resources associated with the request.
  * @bp: The driver context.
  * @req: The request to consume, releasing the associated resources. The
- *	request object and its associated response are no longer valid.
+ *	request object, any slices, and its associated response are no
+ *	longer valid.
  *
  * It is legal to call hwrm_req_drop() on an unowned request, provided it
  * has not already been consumed by hwrm_req_send() (for example, to release
@@ -671,3 +713,72 @@ int hwrm_req_send_silent(struct bnxt *bp, void *req)
 	hwrm_req_flags(bp, req, BNXT_HWRM_CTX_SILENT);
 	return hwrm_req_send(bp, req);
 }
+
+/**
+ * hwrm_req_dma_slice() - Allocate a slice of DMA mapped memory.
+ * @bp: The driver context.
+ * @req: The request for which indirect data will be associated.
+ * @size: The size of the allocation.
+ * @dma: The bus address associated with the allocation. The HWRM API has no
+ *	knowledge about the type of the request and so cannot infer how the
+ *	caller intends to use the indirect data. Thus, the caller is
+ *	responsible for configuring the request object appropriately to
+ *	point to the associated indirect memory. Note, DMA handle has the
+ *	same definition as it does in dma_alloc_coherent(), the caller is
+ *	responsible for endian conversions via cpu_to_le64() before assigning
+ *	this address.
+ *
+ * Allocates DMA mapped memory for indirect data related to a request. The
+ * lifetime of the DMA resources will be bound to that of the request (ie.
+ * they will be automatically released when the request is either consumed by
+ * hwrm_req_send() or dropped by hwrm_req_drop()). Small allocations are
+ * efficiently suballocated out of the request buffer space, hence the name
+ * slice, while larger requests are satisfied via an underlying call to
+ * dma_alloc_coherent(). Multiple suballocations are supported, however, only
+ * one externally mapped region is.
+ *
+ * Return: The kernel virtual address of the DMA mapping.
+ */
+void *
+hwrm_req_dma_slice(struct bnxt *bp, void *req, u32 size, dma_addr_t *dma_handle)
+{
+	struct bnxt_hwrm_ctx *ctx = __hwrm_ctx(bp, req);
+	u8 *end = ((u8 *)req) + BNXT_HWRM_DMA_SIZE;
+	struct input *input = req;
+	u8 *addr, *req_addr = req;
+	u32 max_offset, offset;
+
+	if (!ctx)
+		return NULL;
+
+	max_offset = BNXT_HWRM_DMA_SIZE - ctx->allocated;
+	offset = max_offset - size;
+	offset = ALIGN_DOWN(offset, BNXT_HWRM_DMA_ALIGN);
+	addr = req_addr + offset;
+
+	if (addr < req_addr + max_offset && req_addr + ctx->req_len <= addr) {
+		ctx->allocated = end - addr;
+		*dma_handle = ctx->dma_handle + offset;
+		return addr;
+	}
+
+	/* could not suballocate from ctx buffer, try create a new mapping */
+	if (ctx->slice_addr) {
+		/* if one exists, can only be due to software bug, be loud */
+		netdev_err(bp->dev, "HWRM refusing to reallocate DMA slice, req_type = %u\n",
+			   (u32)le16_to_cpu(input->req_type));
+		dump_stack();
+		return NULL;
+	}
+
+	addr = dma_alloc_coherent(&bp->pdev->dev, size, dma_handle, ctx->gfp);
+
+	if (!addr)
+		return NULL;
+
+	ctx->slice_addr = addr;
+	ctx->slice_size = size;
+	ctx->slice_handle = *dma_handle;
+
+	return addr;
+}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index c58d84cc692a..b3af7a88e2c7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -27,9 +27,14 @@ struct bnxt_hwrm_ctx {
 	dma_addr_t dma_handle;
 	struct output *resp;
 	struct input *req;
+	dma_addr_t slice_handle;
+	void *slice_addr;
+	u32 slice_size;
 	u32 req_len;
 	enum bnxt_hwrm_ctx_flags flags;
 	unsigned int timeout;
+	u32 allocated;
+	gfp_t gfp;
 };
 
 #define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
@@ -140,4 +145,6 @@ void hwrm_req_timeout(struct bnxt *bp, void *req, unsigned int timeout);
 int hwrm_req_send(struct bnxt *bp, void *req);
 int hwrm_req_send_silent(struct bnxt *bp, void *req);
 int hwrm_req_replace(struct bnxt *bp, void *req, void *new_req, u32 len);
+void hwrm_req_alloc_flags(struct bnxt *bp, void *req, gfp_t flags);
+void *hwrm_req_dma_slice(struct bnxt *bp, void *req, u32 size, dma_addr_t *dma);
 #endif
-- 
2.18.1


--00000000000030980505caa5b52c
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIATYQY2hOaJeYoWHd2SKqLh9Q/TOCsCn
ujOBFIKpOtL5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
ODIxNTkwMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAaDxe1cX634v1aa+uJRg1PCUHUf1r/bKowerYrDYmX95R06q09
/DN+bSLfOiLYnJKd8gVRz3qhYYmpaZ+FXKl279y+5XfuZ7fTBipulkvOoo+UmSM/ssQsF32JJFud
eQj5im4tlIdVhhm5AaUFxNSHUmOdesMDXW7kD1JIjh4R4Vt5jumsEbrG5wk59zgxM5kht5y/Nd7H
Fu8t9hcfk1S1z7pfKL6BHJ1J5dsPPN5hPaH7dyiITKUChEZM8Lyc4dO/qjfrUZMRh5B+93LhsRP/
TcQNOdSgp67kr8CZ5DeqlCw1Q7WfnCk0i6iJmUrPrpEcLz4rXl7+y7CW9RcHfD/g
--00000000000030980505caa5b52c--
