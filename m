Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEAE0288CE8
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389428AbgJIPga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:36:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389257AbgJIPg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:36:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FUNXU019449;
        Fri, 9 Oct 2020 08:36:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=QyDaJSXmnoIW8oLQ7m9G06SgsKd2RazohkjAIiusBPE=;
 b=K8UYnlRZ35uUZi5T3deA3HkYB26TKDXiTZ3kDdLR+NZI24gZZ/8bDr0HMP3vbMJ68ecf
 eqV2qHEblpOoPjwniIl/LYVwOAIC+5dAnFzkua+P/rEUyWVK9a8gEfXcY/e72Ec+42tr
 T60jUBN1zxRXUw0ugSn95VzhabzfNN+0ow3vFrBAP9PR3kxIPxgAbiMSmiZmv0DVblUv
 eU0TMJ0uLJ6OYwSZ0svw+bJZUhxFetXTDQufx1HBHZ7uQmmkC3Pdh+QTt+65HnOcovtZ
 r3rr6QRzZhvbGrK8q5aJ+RaWIetNTSbQzBUuawsopup+QuRFiGo1Hbw0+xWbdRZpErPZ Jg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3429h8bbya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:36:22 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:36:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:36:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:36:21 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 2557B3F704D;
        Fri,  9 Oct 2020 08:36:16 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,13/13] crypto: octeontx2: register with linux crypto framework
Date:   Fri, 9 Oct 2020 21:04:21 +0530
Message-ID: <20201009153421.30562-14-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009153421.30562-1-schalla@marvell.com>
References: <20201009153421.30562-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPT offload module utilises the linux crypto framework to offload
crypto processing. This patch registers supported algorithms by
calling registration functions provided by the kernel crypto API.

The module currently supports:
- AES block cipher in CBC,ECB,XTS and CFB mode.
- 3DES block cipher in CBC and ECB mode.
- AEAD algorithms.
  authenc(hmac(sha1),cbc(aes)),
  authenc(hmac(sha256),cbc(aes)),
  authenc(hmac(sha384),cbc(aes)),
  authenc(hmac(sha512),cbc(aes)),
  authenc(hmac(sha1),ecb(cipher_null)),
  authenc(hmac(sha256),ecb(cipher_null)),
  authenc(hmac(sha384),ecb(cipher_null)),
  authenc(hmac(sha512),ecb(cipher_null)),
  rfc4106(gcm(aes)).

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/Kconfig                |    4 +
 drivers/crypto/marvell/octeontx2/Makefile     |    3 +-
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       |    1 +
 .../marvell/octeontx2/otx2_cptvf_algs.c       | 1665 +++++++++++++++++
 .../marvell/octeontx2/otx2_cptvf_algs.h       |  170 ++
 .../marvell/octeontx2/otx2_cptvf_main.c       |   13 +-
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |    7 +
 7 files changed, 1861 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 1440ec9e1fb4..2efbd79180ce 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -40,8 +40,12 @@ config CRYPTO_DEV_OCTEONTX2_CPT
 	tristate "Marvell OcteonTX2 CPT driver"
 	depends on ARM64 || COMPILE_TEST
 	depends on PCI_MSI && 64BIT
+	depends on CRYPTO_LIB_AES
 	select OCTEONTX2_MBOX
 	select CRYPTO_DEV_MARVELL
+	select CRYPTO_SKCIPHER
+	select CRYPTO_HASH
+	select CRYPTO_AEAD
 	help
 		This driver allows you to utilize the Marvell Cryptographic
 		Accelerator Unit(CPT) found in OcteonTX2 series of processors.
diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index 41c0a5832b3f..b9c6201019e0 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o octeontx2-cptvf.o
 octeontx2-cpt-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
 		      otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o
 octeontx2-cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf.o \
-			otx2_cpt_mbox_common.o otx2_cptvf_reqmgr.o
+			otx2_cpt_mbox_common.o otx2_cptvf_reqmgr.o \
+			otx2_cptvf_algs.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index 5e191434ab98..60e57a13166f 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -192,5 +192,6 @@ struct otx2_cptlf_wqe;
 int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 			int cpu_num);
 void otx2_cpt_post_process(struct otx2_cptlf_wqe *wqe);
+int otx2_cpt_get_kcrypto_eng_grp_num(struct pci_dev *pdev);
 
 #endif /* __OTX2_CPT_REQMGR_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
new file mode 100644
index 000000000000..765e61bcf96c
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
@@ -0,0 +1,1665 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include <crypto/aes.h>
+#include <crypto/authenc.h>
+#include <crypto/cryptd.h>
+#include <crypto/des.h>
+#include <crypto/internal/aead.h>
+#include <crypto/sha.h>
+#include <crypto/xts.h>
+#include <crypto/gcm.h>
+#include <crypto/scatterwalk.h>
+#include <linux/rtnetlink.h>
+#include <linux/sort.h>
+#include <linux/module.h>
+#include "otx2_cptvf.h"
+#include "otx2_cptvf_algs.h"
+#include "otx2_cpt_reqmgr.h"
+
+/* Size of salt in AES GCM mode */
+#define AES_GCM_SALT_SIZE 4
+/* Size of IV in AES GCM mode */
+#define AES_GCM_IV_SIZE 8
+/* Size of ICV (Integrity Check Value) in AES GCM mode */
+#define AES_GCM_ICV_SIZE 16
+/* Offset of IV in AES GCM mode */
+#define AES_GCM_IV_OFFSET 8
+#define CONTROL_WORD_LEN 8
+#define KEY2_OFFSET 48
+#define DMA_MODE_FLAG(dma_mode) \
+	(((dma_mode) == OTX2_CPT_DMA_MODE_SG) ? (1 << 7) : 0)
+
+/* Truncated SHA digest size */
+#define SHA1_TRUNC_DIGEST_SIZE 12
+#define SHA256_TRUNC_DIGEST_SIZE 16
+#define SHA384_TRUNC_DIGEST_SIZE 24
+#define SHA512_TRUNC_DIGEST_SIZE 32
+
+static DEFINE_MUTEX(mutex);
+static int is_crypto_registered;
+
+struct cpt_device_desc {
+	struct pci_dev *dev;
+	int num_queues;
+};
+
+struct cpt_device_table {
+	atomic_t count;
+	struct cpt_device_desc desc[OTX2_CPT_MAX_LFS_NUM];
+};
+
+static struct cpt_device_table se_devices = {
+	.count = ATOMIC_INIT(0)
+};
+
+static inline int get_se_device(struct pci_dev **pdev, int *cpu_num)
+{
+	int count;
+
+	count = atomic_read(&se_devices.count);
+	if (count < 1)
+		return -ENODEV;
+
+	*cpu_num = get_cpu();
+	/*
+	 * On OcteonTX2 platform CPT instruction queue is bound to each
+	 * local function LF, in turn LFs can be attached to PF
+	 * or VF therefore we always use first device. We get maximum
+	 * performance if one CPT queue is available for each cpu
+	 * otherwise CPT queues need to be shared between cpus.
+	 */
+	if (*cpu_num >= se_devices.desc[0].num_queues)
+		*cpu_num %= se_devices.desc[0].num_queues;
+	*pdev = se_devices.desc[0].dev;
+
+	put_cpu();
+
+	return 0;
+}
+
+static inline int validate_hmac_cipher_null(struct otx2_cpt_req_info *cpt_req)
+{
+	struct otx2_cpt_req_ctx *rctx;
+	struct aead_request *req;
+	struct crypto_aead *tfm;
+
+	req = container_of(cpt_req->areq, struct aead_request, base);
+	tfm = crypto_aead_reqtfm(req);
+	rctx = aead_request_ctx(req);
+	if (memcmp(rctx->fctx.hmac.s.hmac_calc,
+		   rctx->fctx.hmac.s.hmac_recv,
+		   crypto_aead_authsize(tfm)) != 0)
+		return -EBADMSG;
+
+	return 0;
+}
+
+static void otx2_cpt_aead_callback(int status, void *arg1, void *arg2)
+{
+	struct otx2_cpt_inst_info *inst_info = arg2;
+	struct crypto_async_request *areq = arg1;
+	struct otx2_cpt_req_info *cpt_req;
+	struct pci_dev *pdev;
+
+	if (inst_info) {
+		cpt_req = inst_info->req;
+		if (!status) {
+			/*
+			 * When selected cipher is NULL we need to manually
+			 * verify whether calculated hmac value matches
+			 * received hmac value
+			 */
+			if (cpt_req->req_type ==
+			    OTX2_CPT_AEAD_ENC_DEC_NULL_REQ &&
+			    !cpt_req->is_enc)
+				status = validate_hmac_cipher_null(cpt_req);
+		}
+		pdev = inst_info->pdev;
+		otx2_cpt_info_destroy(pdev, inst_info);
+	}
+	if (areq)
+		areq->complete(areq, status);
+}
+
+static void output_iv_copyback(struct crypto_async_request *areq)
+{
+	struct otx2_cpt_req_info *req_info;
+	struct otx2_cpt_req_ctx *rctx;
+	struct skcipher_request *sreq;
+	struct crypto_skcipher *stfm;
+	struct otx2_cpt_enc_ctx *ctx;
+	u32 start, ivsize;
+
+	sreq = container_of(areq, struct skcipher_request, base);
+	stfm = crypto_skcipher_reqtfm(sreq);
+	ctx = crypto_skcipher_ctx(stfm);
+	if (ctx->cipher_type == OTX2_CPT_AES_CBC ||
+	    ctx->cipher_type == OTX2_CPT_DES3_CBC) {
+		rctx = skcipher_request_ctx(sreq);
+		req_info = &rctx->cpt_req;
+		ivsize = crypto_skcipher_ivsize(stfm);
+		start = sreq->cryptlen - ivsize;
+
+		if (req_info->is_enc) {
+			scatterwalk_map_and_copy(sreq->iv, sreq->dst, start,
+						 ivsize, 0);
+		} else {
+			if (sreq->src != sreq->dst) {
+				scatterwalk_map_and_copy(sreq->iv, sreq->src,
+							 start, ivsize, 0);
+			} else {
+				memcpy(sreq->iv, req_info->iv_out, ivsize);
+				kfree(req_info->iv_out);
+			}
+		}
+	}
+}
+
+static void otx2_cpt_skcipher_callback(int status, void *arg1, void *arg2)
+{
+	struct otx2_cpt_inst_info *inst_info = arg2;
+	struct crypto_async_request *areq = arg1;
+	struct pci_dev *pdev;
+
+	if (areq) {
+		if (!status)
+			output_iv_copyback(areq);
+		if (inst_info) {
+			pdev = inst_info->pdev;
+			otx2_cpt_info_destroy(pdev, inst_info);
+		}
+		areq->complete(areq, status);
+	}
+}
+
+static inline void update_input_data(struct otx2_cpt_req_info *req_info,
+				     struct scatterlist *inp_sg,
+				     u32 nbytes, u32 *argcnt)
+{
+	req_info->req.dlen += nbytes;
+
+	while (nbytes) {
+		u32 len = (nbytes < inp_sg->length) ? nbytes : inp_sg->length;
+		u8 *ptr = sg_virt(inp_sg);
+
+		req_info->in[*argcnt].vptr = (void *)ptr;
+		req_info->in[*argcnt].size = len;
+		nbytes -= len;
+		++(*argcnt);
+		inp_sg = sg_next(inp_sg);
+	}
+}
+
+static inline void update_output_data(struct otx2_cpt_req_info *req_info,
+				      struct scatterlist *outp_sg,
+				      u32 offset, u32 nbytes, u32 *argcnt)
+{
+	u32 len, sg_len;
+	u8 *ptr;
+
+	req_info->rlen += nbytes;
+
+	while (nbytes) {
+		sg_len = outp_sg->length - offset;
+		len = (nbytes < sg_len) ? nbytes : sg_len;
+		ptr = sg_virt(outp_sg);
+
+		req_info->out[*argcnt].vptr = (void *) (ptr + offset);
+		req_info->out[*argcnt].size = len;
+		nbytes -= len;
+		++(*argcnt);
+		offset = 0;
+		outp_sg = sg_next(outp_sg);
+	}
+}
+
+static inline int create_ctx_hdr(struct skcipher_request *req, u32 enc,
+				 u32 *argcnt)
+{
+	struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
+	struct otx2_cpt_req_ctx *rctx = skcipher_request_ctx(req);
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(stfm);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	struct otx2_cpt_fc_ctx *fctx = &rctx->fctx;
+	int ivsize = crypto_skcipher_ivsize(stfm);
+	u32 start = req->cryptlen - ivsize;
+	gfp_t flags;
+
+	flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+			GFP_KERNEL : GFP_ATOMIC;
+	req_info->ctrl.s.dma_mode = OTX2_CPT_DMA_MODE_SG;
+	req_info->ctrl.s.se_req = 1;
+
+	req_info->req.opcode.s.major = OTX2_CPT_MAJOR_OP_FC |
+				DMA_MODE_FLAG(OTX2_CPT_DMA_MODE_SG);
+	if (enc) {
+		req_info->req.opcode.s.minor = 2;
+	} else {
+		req_info->req.opcode.s.minor = 3;
+		if ((ctx->cipher_type == OTX2_CPT_AES_CBC ||
+		    ctx->cipher_type == OTX2_CPT_DES3_CBC) &&
+		    req->src == req->dst) {
+			req_info->iv_out = kmalloc(ivsize, flags);
+			if (!req_info->iv_out)
+				return -ENOMEM;
+
+			scatterwalk_map_and_copy(req_info->iv_out, req->src,
+						 start, ivsize, 0);
+		}
+	}
+	/* Encryption data length */
+	req_info->req.param1 = req->cryptlen;
+	/* Authentication data length */
+	req_info->req.param2 = 0;
+
+	fctx->enc.enc_ctrl.e.enc_cipher = ctx->cipher_type;
+	fctx->enc.enc_ctrl.e.aes_key = ctx->key_type;
+	fctx->enc.enc_ctrl.e.iv_source = OTX2_CPT_FROM_CPTR;
+
+	if (ctx->cipher_type == OTX2_CPT_AES_XTS)
+		memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len * 2);
+	else
+		memcpy(fctx->enc.encr_key, ctx->enc_key, ctx->key_len);
+
+	memcpy(fctx->enc.encr_iv, req->iv, crypto_skcipher_ivsize(stfm));
+
+	cpu_to_be64s(&fctx->enc.enc_ctrl.u);
+
+	/*
+	 * Storing  Packet Data Information in offset
+	 * Control Word First 8 bytes
+	 */
+	req_info->in[*argcnt].vptr = (u8 *)&rctx->ctrl_word;
+	req_info->in[*argcnt].size = CONTROL_WORD_LEN;
+	req_info->req.dlen += CONTROL_WORD_LEN;
+	++(*argcnt);
+
+	req_info->in[*argcnt].vptr = (u8 *)fctx;
+	req_info->in[*argcnt].size = sizeof(struct otx2_cpt_fc_ctx);
+	req_info->req.dlen += sizeof(struct otx2_cpt_fc_ctx);
+
+	++(*argcnt);
+
+	return 0;
+}
+
+static inline int create_input_list(struct skcipher_request *req, u32 enc,
+				    u32 enc_iv_len)
+{
+	struct otx2_cpt_req_ctx *rctx = skcipher_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 argcnt =  0;
+	int ret;
+
+	ret = create_ctx_hdr(req, enc, &argcnt);
+	if (ret)
+		return ret;
+
+	update_input_data(req_info, req->src, req->cryptlen, &argcnt);
+	req_info->in_cnt = argcnt;
+
+	return 0;
+}
+
+static inline void create_output_list(struct skcipher_request *req,
+				      u32 enc_iv_len)
+{
+	struct otx2_cpt_req_ctx *rctx = skcipher_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 argcnt = 0;
+
+	/*
+	 * OUTPUT Buffer Processing
+	 * AES encryption/decryption output would be
+	 * received in the following format
+	 *
+	 * ------IV--------|------ENCRYPTED/DECRYPTED DATA-----|
+	 * [ 16 Bytes/     [   Request Enc/Dec/ DATA Len AES CBC ]
+	 */
+	update_output_data(req_info, req->dst, 0, req->cryptlen, &argcnt);
+	req_info->out_cnt = argcnt;
+}
+
+static inline int cpt_enc_dec(struct skcipher_request *req, u32 enc)
+{
+	struct crypto_skcipher *stfm = crypto_skcipher_reqtfm(req);
+	struct otx2_cpt_req_ctx *rctx = skcipher_request_ctx(req);
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(stfm);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 enc_iv_len = crypto_skcipher_ivsize(stfm);
+	struct pci_dev *pdev;
+	int status, cpu_num;
+
+	if (!req->cryptlen)
+		return 0;
+
+	if (req->cryptlen > OTX2_CPT_MAX_REQ_SIZE ||
+	    !IS_ALIGNED(req->cryptlen, ctx->enc_align_len))
+		return -EINVAL;
+
+	/* Clear control words */
+	rctx->ctrl_word.flags = 0;
+	rctx->fctx.enc.enc_ctrl.u = 0;
+
+	status = create_input_list(req, enc, enc_iv_len);
+	if (status)
+		return status;
+	create_output_list(req, enc_iv_len);
+
+	status = get_se_device(&pdev, &cpu_num);
+	if (status)
+		return status;
+
+	req_info->callback = otx2_cpt_skcipher_callback;
+	req_info->areq = &req->base;
+	req_info->req_type = OTX2_CPT_ENC_DEC_REQ;
+	req_info->is_enc = enc;
+	req_info->is_trunc_hmac = false;
+	req_info->ctrl.s.grp = otx2_cpt_get_kcrypto_eng_grp_num(pdev);
+
+	/*
+	 * We perform an asynchronous send and once
+	 * the request is completed the driver would
+	 * intimate through registered call back functions
+	 */
+	status = otx2_cpt_do_request(pdev, req_info, cpu_num);
+
+	return status;
+}
+
+static int otx2_cpt_skcipher_encrypt(struct skcipher_request *req)
+{
+	return cpt_enc_dec(req, true);
+}
+
+static int otx2_cpt_skcipher_decrypt(struct skcipher_request *req)
+{
+	return cpt_enc_dec(req, false);
+}
+
+static int otx2_cpt_skcipher_xts_setkey(struct crypto_skcipher *tfm,
+				       const u8 *key, u32 keylen)
+{
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	const u8 *key2 = key + (keylen / 2);
+	const u8 *key1 = key;
+	int ret;
+
+	ret = xts_check_key(crypto_skcipher_tfm(tfm), key, keylen);
+	if (ret)
+		return ret;
+	ctx->key_len = keylen;
+	ctx->enc_align_len = 1;
+	memcpy(ctx->enc_key, key1, keylen / 2);
+	memcpy(ctx->enc_key + KEY2_OFFSET, key2, keylen / 2);
+	ctx->cipher_type = OTX2_CPT_AES_XTS;
+	switch (ctx->key_len) {
+	case 2 * AES_KEYSIZE_128:
+		ctx->key_type = OTX2_CPT_AES_128_BIT;
+		break;
+	case 2 * AES_KEYSIZE_256:
+		ctx->key_type = OTX2_CPT_AES_256_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int cpt_des_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			  u32 keylen, u8 cipher_type)
+{
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	if (keylen != DES3_EDE_KEY_SIZE)
+		return -EINVAL;
+
+	ctx->key_len = keylen;
+	ctx->cipher_type = cipher_type;
+	ctx->enc_align_len = 8;
+
+	memcpy(ctx->enc_key, key, keylen);
+
+	return 0;
+}
+
+static int cpt_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			  u32 keylen, u8 cipher_type)
+{
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	switch (keylen) {
+	case AES_KEYSIZE_128:
+		ctx->key_type = OTX2_CPT_AES_128_BIT;
+		break;
+	case AES_KEYSIZE_192:
+		ctx->key_type = OTX2_CPT_AES_192_BIT;
+		break;
+	case AES_KEYSIZE_256:
+		ctx->key_type = OTX2_CPT_AES_256_BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (cipher_type == OTX2_CPT_AES_CBC || cipher_type == OTX2_CPT_AES_ECB)
+		ctx->enc_align_len = 16;
+	else
+		ctx->enc_align_len = 1;
+
+	ctx->key_len = keylen;
+	ctx->cipher_type = cipher_type;
+
+	memcpy(ctx->enc_key, key, keylen);
+
+	return 0;
+}
+
+static int otx2_cpt_skcipher_cbc_aes_setkey(struct crypto_skcipher *tfm,
+					    const u8 *key, u32 keylen)
+{
+	return cpt_aes_setkey(tfm, key, keylen, OTX2_CPT_AES_CBC);
+}
+
+static int otx2_cpt_skcipher_ecb_aes_setkey(struct crypto_skcipher *tfm,
+					    const u8 *key, u32 keylen)
+{
+	return cpt_aes_setkey(tfm, key, keylen, OTX2_CPT_AES_ECB);
+}
+
+static int otx2_cpt_skcipher_cfb_aes_setkey(struct crypto_skcipher *tfm,
+					    const u8 *key, u32 keylen)
+{
+	return cpt_aes_setkey(tfm, key, keylen, OTX2_CPT_AES_CFB);
+}
+
+static int otx2_cpt_skcipher_cbc_des3_setkey(struct crypto_skcipher *tfm,
+					     const u8 *key, u32 keylen)
+{
+	return cpt_des_setkey(tfm, key, keylen, OTX2_CPT_DES3_CBC);
+}
+
+static int otx2_cpt_skcipher_ecb_des3_setkey(struct crypto_skcipher *tfm,
+					     const u8 *key, u32 keylen)
+{
+	return cpt_des_setkey(tfm, key, keylen, OTX2_CPT_DES3_ECB);
+}
+
+static int otx2_cpt_enc_dec_init(struct crypto_skcipher *tfm)
+{
+	struct otx2_cpt_enc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	/*
+	 * Additional memory for ablkcipher_request is
+	 * allocated since the cryptd daemon uses
+	 * this memory for request_ctx information
+	 */
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct otx2_cpt_req_ctx) +
+					sizeof(struct skcipher_request));
+
+	return 0;
+}
+
+static int cpt_aead_init(struct crypto_aead *tfm, u8 cipher_type, u8 mac_type)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->cipher_type = cipher_type;
+	ctx->mac_type = mac_type;
+
+	/*
+	 * When selected cipher is NULL we use HMAC opcode instead of
+	 * FLEXICRYPTO opcode therefore we don't need to use HASH algorithms
+	 * for calculating ipad and opad
+	 */
+	if (ctx->cipher_type != OTX2_CPT_CIPHER_NULL) {
+		switch (ctx->mac_type) {
+		case OTX2_CPT_SHA1:
+			ctx->hashalg = crypto_alloc_shash("sha1", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(ctx->hashalg))
+				return PTR_ERR(ctx->hashalg);
+			break;
+
+		case OTX2_CPT_SHA256:
+			ctx->hashalg = crypto_alloc_shash("sha256", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(ctx->hashalg))
+				return PTR_ERR(ctx->hashalg);
+			break;
+
+		case OTX2_CPT_SHA384:
+			ctx->hashalg = crypto_alloc_shash("sha384", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(ctx->hashalg))
+				return PTR_ERR(ctx->hashalg);
+			break;
+
+		case OTX2_CPT_SHA512:
+			ctx->hashalg = crypto_alloc_shash("sha512", 0,
+							  CRYPTO_ALG_ASYNC);
+			if (IS_ERR(ctx->hashalg))
+				return PTR_ERR(ctx->hashalg);
+			break;
+		}
+	}
+	switch (ctx->cipher_type) {
+	case OTX2_CPT_AES_CBC:
+	case OTX2_CPT_AES_ECB:
+		ctx->enc_align_len = 16;
+		break;
+	case OTX2_CPT_DES3_CBC:
+	case OTX2_CPT_DES3_ECB:
+		ctx->enc_align_len = 8;
+		break;
+	case OTX2_CPT_AES_GCM:
+	case OTX2_CPT_CIPHER_NULL:
+		ctx->enc_align_len = 1;
+		break;
+	}
+	crypto_aead_set_reqsize(tfm, sizeof(struct otx2_cpt_req_ctx));
+
+	return 0;
+}
+
+static int otx2_cpt_aead_cbc_aes_sha1_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_CBC, OTX2_CPT_SHA1);
+}
+
+static int otx2_cpt_aead_cbc_aes_sha256_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_CBC, OTX2_CPT_SHA256);
+}
+
+static int otx2_cpt_aead_cbc_aes_sha384_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_CBC, OTX2_CPT_SHA384);
+}
+
+static int otx2_cpt_aead_cbc_aes_sha512_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_CBC, OTX2_CPT_SHA512);
+}
+
+static int otx2_cpt_aead_ecb_null_sha1_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_CIPHER_NULL, OTX2_CPT_SHA1);
+}
+
+static int otx2_cpt_aead_ecb_null_sha256_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_CIPHER_NULL, OTX2_CPT_SHA256);
+}
+
+static int otx2_cpt_aead_ecb_null_sha384_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_CIPHER_NULL, OTX2_CPT_SHA384);
+}
+
+static int otx2_cpt_aead_ecb_null_sha512_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_CIPHER_NULL, OTX2_CPT_SHA512);
+}
+
+static int otx2_cpt_aead_gcm_aes_init(struct crypto_aead *tfm)
+{
+	return cpt_aead_init(tfm, OTX2_CPT_AES_GCM, OTX2_CPT_MAC_NULL);
+}
+
+static void otx2_cpt_aead_exit(struct crypto_aead *tfm)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	kfree(ctx->ipad);
+	kfree(ctx->opad);
+	if (ctx->hashalg)
+		crypto_free_shash(ctx->hashalg);
+	kfree(ctx->sdesc);
+}
+
+static int otx2_cpt_aead_gcm_set_authsize(struct crypto_aead *tfm,
+					  unsigned int authsize)
+{
+	if (crypto_rfc4106_check_authsize(authsize))
+		return -EINVAL;
+
+	tfm->authsize = authsize;
+	return 0;
+}
+
+static int otx2_cpt_aead_set_authsize(struct crypto_aead *tfm,
+				      unsigned int authsize)
+{
+	tfm->authsize = authsize;
+
+	return 0;
+}
+
+static int otx2_cpt_aead_null_set_authsize(struct crypto_aead *tfm,
+					   unsigned int authsize)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	ctx->is_trunc_hmac = true;
+	tfm->authsize = authsize;
+
+	return 0;
+}
+
+static struct otx2_cpt_sdesc *alloc_sdesc(struct crypto_shash *alg)
+{
+	struct otx2_cpt_sdesc *sdesc;
+	int size;
+
+	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
+	sdesc = kmalloc(size, GFP_KERNEL);
+	if (!sdesc)
+		return NULL;
+
+	sdesc->shash.tfm = alg;
+
+	return sdesc;
+}
+
+static inline void swap_data32(void *buf, u32 len)
+{
+	cpu_to_be32_array(buf, buf, len / 4);
+}
+
+static inline void swap_data64(void *buf, u32 len)
+{
+	u64 *src = buf;
+	int i = 0;
+
+	for (i = 0 ; i < len / 8; i++, src++)
+		cpu_to_be64s(src);
+}
+
+static int copy_pad(u8 mac_type, u8 *out_pad, u8 *in_pad)
+{
+	struct sha512_state *sha512;
+	struct sha256_state *sha256;
+	struct sha1_state *sha1;
+
+	switch (mac_type) {
+	case OTX2_CPT_SHA1:
+		sha1 = (struct sha1_state *) in_pad;
+		swap_data32(sha1->state, SHA1_DIGEST_SIZE);
+		memcpy(out_pad, &sha1->state, SHA1_DIGEST_SIZE);
+		break;
+
+	case OTX2_CPT_SHA256:
+		sha256 = (struct sha256_state *) in_pad;
+		swap_data32(sha256->state, SHA256_DIGEST_SIZE);
+		memcpy(out_pad, &sha256->state, SHA256_DIGEST_SIZE);
+		break;
+
+	case OTX2_CPT_SHA384:
+	case OTX2_CPT_SHA512:
+		sha512 = (struct sha512_state *) in_pad;
+		swap_data64(sha512->state, SHA512_DIGEST_SIZE);
+		memcpy(out_pad, &sha512->state, SHA512_DIGEST_SIZE);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int aead_hmac_init(struct crypto_aead *cipher)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(cipher);
+	int state_size = crypto_shash_statesize(ctx->hashalg);
+	int ds = crypto_shash_digestsize(ctx->hashalg);
+	int bs = crypto_shash_blocksize(ctx->hashalg);
+	int authkeylen = ctx->auth_key_len;
+	u8 *ipad = NULL, *opad = NULL;
+	int ret = 0, icount = 0;
+
+	ctx->sdesc = alloc_sdesc(ctx->hashalg);
+	if (!ctx->sdesc)
+		return -ENOMEM;
+
+	ctx->ipad = kzalloc(bs, GFP_KERNEL);
+	if (!ctx->ipad) {
+		ret = -ENOMEM;
+		goto calc_fail;
+	}
+
+	ctx->opad = kzalloc(bs, GFP_KERNEL);
+	if (!ctx->opad) {
+		ret = -ENOMEM;
+		goto calc_fail;
+	}
+
+	ipad = kzalloc(state_size, GFP_KERNEL);
+	if (!ipad) {
+		ret = -ENOMEM;
+		goto calc_fail;
+	}
+
+	opad = kzalloc(state_size, GFP_KERNEL);
+	if (!opad) {
+		ret = -ENOMEM;
+		goto calc_fail;
+	}
+
+	if (authkeylen > bs) {
+		ret = crypto_shash_digest(&ctx->sdesc->shash, ctx->key,
+					  authkeylen, ipad);
+		if (ret)
+			goto calc_fail;
+
+		authkeylen = ds;
+	} else {
+		memcpy(ipad, ctx->key, authkeylen);
+	}
+
+	memset(ipad + authkeylen, 0, bs - authkeylen);
+	memcpy(opad, ipad, bs);
+
+	for (icount = 0; icount < bs; icount++) {
+		ipad[icount] ^= 0x36;
+		opad[icount] ^= 0x5c;
+	}
+
+	/*
+	 * Partial Hash calculated from the software
+	 * algorithm is retrieved for IPAD & OPAD
+	 */
+
+	/* IPAD Calculation */
+	crypto_shash_init(&ctx->sdesc->shash);
+	crypto_shash_update(&ctx->sdesc->shash, ipad, bs);
+	crypto_shash_export(&ctx->sdesc->shash, ipad);
+	ret = copy_pad(ctx->mac_type, ctx->ipad, ipad);
+	if (ret)
+		goto calc_fail;
+
+	/* OPAD Calculation */
+	crypto_shash_init(&ctx->sdesc->shash);
+	crypto_shash_update(&ctx->sdesc->shash, opad, bs);
+	crypto_shash_export(&ctx->sdesc->shash, opad);
+	ret = copy_pad(ctx->mac_type, ctx->opad, opad);
+	if (ret)
+		goto calc_fail;
+
+	kfree(ipad);
+	kfree(opad);
+
+	return 0;
+
+calc_fail:
+	kfree(ctx->ipad);
+	ctx->ipad = NULL;
+	kfree(ctx->opad);
+	ctx->opad = NULL;
+	kfree(ipad);
+	kfree(opad);
+	kfree(ctx->sdesc);
+	ctx->sdesc = NULL;
+
+	return ret;
+}
+
+static int otx2_cpt_aead_cbc_aes_sha_setkey(struct crypto_aead *cipher,
+					    const unsigned char *key,
+					    unsigned int keylen)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(cipher);
+	struct crypto_authenc_key_param *param;
+	int enckeylen = 0, authkeylen = 0;
+	struct rtattr *rta = (void *)key;
+	int status;
+
+	if (!RTA_OK(rta, keylen))
+		return -EINVAL;
+
+	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+		return -EINVAL;
+
+	if (RTA_PAYLOAD(rta) < sizeof(*param))
+		return -EINVAL;
+
+	param = RTA_DATA(rta);
+	enckeylen = be32_to_cpu(param->enckeylen);
+	key += RTA_ALIGN(rta->rta_len);
+	keylen -= RTA_ALIGN(rta->rta_len);
+	if (keylen < enckeylen)
+		return -EINVAL;
+
+	if (keylen > OTX2_CPT_MAX_KEY_SIZE)
+		return -EINVAL;
+
+	authkeylen = keylen - enckeylen;
+	memcpy(ctx->key, key, keylen);
+
+	switch (enckeylen) {
+	case AES_KEYSIZE_128:
+		ctx->key_type = OTX2_CPT_AES_128_BIT;
+		break;
+	case AES_KEYSIZE_192:
+		ctx->key_type = OTX2_CPT_AES_192_BIT;
+		break;
+	case AES_KEYSIZE_256:
+		ctx->key_type = OTX2_CPT_AES_256_BIT;
+		break;
+	default:
+		/* Invalid key length */
+		return -EINVAL;
+	}
+
+	ctx->enc_key_len = enckeylen;
+	ctx->auth_key_len = authkeylen;
+
+	status = aead_hmac_init(cipher);
+	if (status)
+		return status;
+
+	return 0;
+}
+
+static int otx2_cpt_aead_ecb_null_sha_setkey(struct crypto_aead *cipher,
+					     const unsigned char *key,
+					     unsigned int keylen)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(cipher);
+	struct crypto_authenc_key_param *param;
+	struct rtattr *rta = (void *)key;
+	int enckeylen = 0;
+
+	if (!RTA_OK(rta, keylen))
+		return -EINVAL;
+
+	if (rta->rta_type != CRYPTO_AUTHENC_KEYA_PARAM)
+		return -EINVAL;
+
+	if (RTA_PAYLOAD(rta) < sizeof(*param))
+		return -EINVAL;
+
+	param = RTA_DATA(rta);
+	enckeylen = be32_to_cpu(param->enckeylen);
+	key += RTA_ALIGN(rta->rta_len);
+	keylen -= RTA_ALIGN(rta->rta_len);
+	if (enckeylen != 0)
+		return -EINVAL;
+
+	if (keylen > OTX2_CPT_MAX_KEY_SIZE)
+		return -EINVAL;
+
+	memcpy(ctx->key, key, keylen);
+	ctx->enc_key_len = enckeylen;
+	ctx->auth_key_len = keylen;
+
+	return 0;
+}
+
+static int otx2_cpt_aead_gcm_aes_setkey(struct crypto_aead *cipher,
+					const unsigned char *key,
+					unsigned int keylen)
+{
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(cipher);
+
+	/*
+	 * For aes gcm we expect to get encryption key (16, 24, 32 bytes)
+	 * and salt (4 bytes)
+	 */
+	switch (keylen) {
+	case AES_KEYSIZE_128 + AES_GCM_SALT_SIZE:
+		ctx->key_type = OTX2_CPT_AES_128_BIT;
+		ctx->enc_key_len = AES_KEYSIZE_128;
+		break;
+	case AES_KEYSIZE_192 + AES_GCM_SALT_SIZE:
+		ctx->key_type = OTX2_CPT_AES_192_BIT;
+		ctx->enc_key_len = AES_KEYSIZE_192;
+		break;
+	case AES_KEYSIZE_256 + AES_GCM_SALT_SIZE:
+		ctx->key_type = OTX2_CPT_AES_256_BIT;
+		ctx->enc_key_len = AES_KEYSIZE_256;
+		break;
+	default:
+		/* Invalid key and salt length */
+		return -EINVAL;
+	}
+
+	/* Store encryption key and salt */
+	memcpy(ctx->key, key, keylen);
+
+	return 0;
+}
+
+static inline int create_aead_ctx_hdr(struct aead_request *req, u32 enc,
+				      u32 *argcnt)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	struct otx2_cpt_fc_ctx *fctx = &rctx->fctx;
+	int mac_len = crypto_aead_authsize(tfm);
+	int ds;
+
+	rctx->ctrl_word.e.enc_data_offset = req->assoclen;
+
+	switch (ctx->cipher_type) {
+	case OTX2_CPT_AES_CBC:
+		if (req->assoclen > 248 || !IS_ALIGNED(req->assoclen, 8))
+			return -EINVAL;
+
+		fctx->enc.enc_ctrl.e.iv_source = OTX2_CPT_FROM_CPTR;
+		/* Copy encryption key to context */
+		memcpy(fctx->enc.encr_key, ctx->key + ctx->auth_key_len,
+		       ctx->enc_key_len);
+		/* Copy IV to context */
+		memcpy(fctx->enc.encr_iv, req->iv, crypto_aead_ivsize(tfm));
+
+		ds = crypto_shash_digestsize(ctx->hashalg);
+		if (ctx->mac_type == OTX2_CPT_SHA384)
+			ds = SHA512_DIGEST_SIZE;
+		if (ctx->ipad)
+			memcpy(fctx->hmac.e.ipad, ctx->ipad, ds);
+		if (ctx->opad)
+			memcpy(fctx->hmac.e.opad, ctx->opad, ds);
+		break;
+
+	case OTX2_CPT_AES_GCM:
+		if (crypto_ipsec_check_assoclen(req->assoclen))
+			return -EINVAL;
+
+		fctx->enc.enc_ctrl.e.iv_source = OTX2_CPT_FROM_DPTR;
+		/* Copy encryption key to context */
+		memcpy(fctx->enc.encr_key, ctx->key, ctx->enc_key_len);
+		/* Copy salt to context */
+		memcpy(fctx->enc.encr_iv, ctx->key + ctx->enc_key_len,
+		       AES_GCM_SALT_SIZE);
+
+		rctx->ctrl_word.e.iv_offset = req->assoclen - AES_GCM_IV_OFFSET;
+		break;
+
+	default:
+		/* Unknown cipher type */
+		return -EINVAL;
+	}
+	cpu_to_be64s(&rctx->ctrl_word.flags);
+
+	req_info->ctrl.s.dma_mode = OTX2_CPT_DMA_MODE_SG;
+	req_info->ctrl.s.se_req = 1;
+	req_info->req.opcode.s.major = OTX2_CPT_MAJOR_OP_FC |
+				 DMA_MODE_FLAG(OTX2_CPT_DMA_MODE_SG);
+	if (enc) {
+		req_info->req.opcode.s.minor = 2;
+		req_info->req.param1 = req->cryptlen;
+		req_info->req.param2 = req->cryptlen + req->assoclen;
+	} else {
+		req_info->req.opcode.s.minor = 3;
+		req_info->req.param1 = req->cryptlen - mac_len;
+		req_info->req.param2 = req->cryptlen + req->assoclen - mac_len;
+	}
+
+	fctx->enc.enc_ctrl.e.enc_cipher = ctx->cipher_type;
+	fctx->enc.enc_ctrl.e.aes_key = ctx->key_type;
+	fctx->enc.enc_ctrl.e.mac_type = ctx->mac_type;
+	fctx->enc.enc_ctrl.e.mac_len = mac_len;
+	cpu_to_be64s(&fctx->enc.enc_ctrl.u);
+
+	/*
+	 * Storing Packet Data Information in offset
+	 * Control Word First 8 bytes
+	 */
+	req_info->in[*argcnt].vptr = (u8 *)&rctx->ctrl_word;
+	req_info->in[*argcnt].size = CONTROL_WORD_LEN;
+	req_info->req.dlen += CONTROL_WORD_LEN;
+	++(*argcnt);
+
+	req_info->in[*argcnt].vptr = (u8 *)fctx;
+	req_info->in[*argcnt].size = sizeof(struct otx2_cpt_fc_ctx);
+	req_info->req.dlen += sizeof(struct otx2_cpt_fc_ctx);
+	++(*argcnt);
+
+	return 0;
+}
+
+static inline void create_hmac_ctx_hdr(struct aead_request *req, u32 *argcnt,
+				      u32 enc)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+
+	req_info->ctrl.s.dma_mode = OTX2_CPT_DMA_MODE_SG;
+	req_info->ctrl.s.se_req = 1;
+	req_info->req.opcode.s.major = OTX2_CPT_MAJOR_OP_HMAC |
+				 DMA_MODE_FLAG(OTX2_CPT_DMA_MODE_SG);
+	req_info->is_trunc_hmac = ctx->is_trunc_hmac;
+
+	req_info->req.opcode.s.minor = 0;
+	req_info->req.param1 = ctx->auth_key_len;
+	req_info->req.param2 = ctx->mac_type << 8;
+
+	/* Add authentication key */
+	req_info->in[*argcnt].vptr = ctx->key;
+	req_info->in[*argcnt].size = round_up(ctx->auth_key_len, 8);
+	req_info->req.dlen += round_up(ctx->auth_key_len, 8);
+	++(*argcnt);
+}
+
+static inline int create_aead_input_list(struct aead_request *req, u32 enc)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 inputlen =  req->cryptlen + req->assoclen;
+	u32 status, argcnt = 0;
+
+	status = create_aead_ctx_hdr(req, enc, &argcnt);
+	if (status)
+		return status;
+	update_input_data(req_info, req->src, inputlen, &argcnt);
+	req_info->in_cnt = argcnt;
+
+	return 0;
+}
+
+static inline void create_aead_output_list(struct aead_request *req, u32 enc,
+					   u32 mac_len)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info =  &rctx->cpt_req;
+	u32 argcnt = 0, outputlen = 0;
+
+	if (enc)
+		outputlen = req->cryptlen +  req->assoclen + mac_len;
+	else
+		outputlen = req->cryptlen + req->assoclen - mac_len;
+
+	update_output_data(req_info, req->dst, 0, outputlen, &argcnt);
+	req_info->out_cnt = argcnt;
+}
+
+static inline void create_aead_null_input_list(struct aead_request *req,
+					       u32 enc, u32 mac_len)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	u32 inputlen, argcnt = 0;
+
+	if (enc)
+		inputlen =  req->cryptlen + req->assoclen;
+	else
+		inputlen =  req->cryptlen + req->assoclen - mac_len;
+
+	create_hmac_ctx_hdr(req, &argcnt, enc);
+	update_input_data(req_info, req->src, inputlen, &argcnt);
+	req_info->in_cnt = argcnt;
+}
+
+static inline int create_aead_null_output_list(struct aead_request *req,
+					       u32 enc, u32 mac_len)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info =  &rctx->cpt_req;
+	struct scatterlist *dst;
+	u8 *ptr = NULL;
+	int argcnt = 0, status, offset;
+	u32 inputlen;
+
+	if (enc)
+		inputlen =  req->cryptlen + req->assoclen;
+	else
+		inputlen =  req->cryptlen + req->assoclen - mac_len;
+
+	/*
+	 * If source and destination are different
+	 * then copy payload to destination
+	 */
+	if (req->src != req->dst) {
+
+		ptr = kmalloc(inputlen, (req_info->areq->flags &
+					 CRYPTO_TFM_REQ_MAY_SLEEP) ?
+					 GFP_KERNEL : GFP_ATOMIC);
+		if (!ptr)
+			return -ENOMEM;
+
+		status = sg_copy_to_buffer(req->src, sg_nents(req->src), ptr,
+					   inputlen);
+		if (status != inputlen) {
+			status = -EINVAL;
+			goto error_free;
+		}
+		status = sg_copy_from_buffer(req->dst, sg_nents(req->dst), ptr,
+					     inputlen);
+		if (status != inputlen) {
+			status = -EINVAL;
+			goto error_free;
+		}
+		kfree(ptr);
+	}
+
+	if (enc) {
+		/*
+		 * In an encryption scenario hmac needs
+		 * to be appended after payload
+		 */
+		dst = req->dst;
+		offset = inputlen;
+		while (offset >= dst->length) {
+			offset -= dst->length;
+			dst = sg_next(dst);
+			if (!dst)
+				return -ENOENT;
+		}
+
+		update_output_data(req_info, dst, offset, mac_len, &argcnt);
+	} else {
+		/*
+		 * In a decryption scenario calculated hmac for received
+		 * payload needs to be compare with hmac received
+		 */
+		status = sg_copy_buffer(req->src, sg_nents(req->src),
+					rctx->fctx.hmac.s.hmac_recv, mac_len,
+					inputlen, true);
+		if (status != mac_len)
+			return -EINVAL;
+
+		req_info->out[argcnt].vptr = rctx->fctx.hmac.s.hmac_calc;
+		req_info->out[argcnt].size = mac_len;
+		argcnt++;
+	}
+
+	req_info->out_cnt = argcnt;
+	return 0;
+
+error_free:
+	kfree(ptr);
+	return status;
+}
+
+static int cpt_aead_enc_dec(struct aead_request *req, u8 reg_type, u8 enc)
+{
+	struct otx2_cpt_req_ctx *rctx = aead_request_ctx(req);
+	struct otx2_cpt_req_info *req_info = &rctx->cpt_req;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct otx2_cpt_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct pci_dev *pdev;
+	int status, cpu_num;
+
+	/* Clear control words */
+	rctx->ctrl_word.flags = 0;
+	rctx->fctx.enc.enc_ctrl.u = 0;
+
+	req_info->callback = otx2_cpt_aead_callback;
+	req_info->areq = &req->base;
+	req_info->req_type = reg_type;
+	req_info->is_enc = enc;
+	req_info->is_trunc_hmac = false;
+
+	switch (reg_type) {
+	case OTX2_CPT_AEAD_ENC_DEC_REQ:
+		status = create_aead_input_list(req, enc);
+		if (status)
+			return status;
+		create_aead_output_list(req, enc, crypto_aead_authsize(tfm));
+		break;
+
+	case OTX2_CPT_AEAD_ENC_DEC_NULL_REQ:
+		create_aead_null_input_list(req, enc,
+					    crypto_aead_authsize(tfm));
+		status = create_aead_null_output_list(req, enc,
+						crypto_aead_authsize(tfm));
+		if (status)
+			return status;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	if (!req_info->req.param1 ||
+	    (req_info->req.param1 > OTX2_CPT_MAX_REQ_SIZE) ||
+	    (req_info->req.param2 > OTX2_CPT_MAX_REQ_SIZE) ||
+	    !IS_ALIGNED(req_info->req.param1, ctx->enc_align_len))
+		return -EINVAL;
+
+	status = get_se_device(&pdev, &cpu_num);
+	if (status)
+		return status;
+
+	req_info->ctrl.s.grp = otx2_cpt_get_kcrypto_eng_grp_num(pdev);
+
+	/*
+	 * We perform an asynchronous send and once
+	 * the request is completed the driver would
+	 * intimate through registered call back functions
+	 */
+	status = otx2_cpt_do_request(pdev, req_info, cpu_num);
+
+	return status;
+}
+
+static int otx2_cpt_aead_encrypt(struct aead_request *req)
+{
+	return cpt_aead_enc_dec(req, OTX2_CPT_AEAD_ENC_DEC_REQ, true);
+}
+
+static int otx2_cpt_aead_decrypt(struct aead_request *req)
+{
+	return cpt_aead_enc_dec(req, OTX2_CPT_AEAD_ENC_DEC_REQ, false);
+}
+
+static int otx2_cpt_aead_null_encrypt(struct aead_request *req)
+{
+	return cpt_aead_enc_dec(req, OTX2_CPT_AEAD_ENC_DEC_NULL_REQ, true);
+}
+
+static int otx2_cpt_aead_null_decrypt(struct aead_request *req)
+{
+	return cpt_aead_enc_dec(req, OTX2_CPT_AEAD_ENC_DEC_NULL_REQ, false);
+}
+
+static struct skcipher_alg otx2_cpt_skciphers[] = { {
+	.base.cra_name = "xts(aes)",
+	.base.cra_driver_name = "cpt_xts_aes",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.ivsize = AES_BLOCK_SIZE,
+	.min_keysize = 2 * AES_MIN_KEY_SIZE,
+	.max_keysize = 2 * AES_MAX_KEY_SIZE,
+	.setkey = otx2_cpt_skcipher_xts_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "cbc(aes)",
+	.base.cra_driver_name = "cpt_cbc_aes",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.ivsize = AES_BLOCK_SIZE,
+	.min_keysize = AES_MIN_KEY_SIZE,
+	.max_keysize = AES_MAX_KEY_SIZE,
+	.setkey = otx2_cpt_skcipher_cbc_aes_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "ecb(aes)",
+	.base.cra_driver_name = "cpt_ecb_aes",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = AES_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.ivsize = 0,
+	.min_keysize = AES_MIN_KEY_SIZE,
+	.max_keysize = AES_MAX_KEY_SIZE,
+	.setkey = otx2_cpt_skcipher_ecb_aes_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "cfb(aes)",
+	.base.cra_driver_name = "cpt_cfb_aes",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = 1,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.ivsize = AES_BLOCK_SIZE,
+	.min_keysize = AES_MIN_KEY_SIZE,
+	.max_keysize = AES_MAX_KEY_SIZE,
+	.setkey = otx2_cpt_skcipher_cfb_aes_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "cbc(des3_ede)",
+	.base.cra_driver_name = "cpt_cbc_des3_ede",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.min_keysize = DES3_EDE_KEY_SIZE,
+	.max_keysize = DES3_EDE_KEY_SIZE,
+	.ivsize = DES_BLOCK_SIZE,
+	.setkey = otx2_cpt_skcipher_cbc_des3_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+}, {
+	.base.cra_name = "ecb(des3_ede)",
+	.base.cra_driver_name = "cpt_ecb_des3_ede",
+	.base.cra_flags = CRYPTO_ALG_ASYNC,
+	.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.base.cra_ctxsize = sizeof(struct otx2_cpt_enc_ctx),
+	.base.cra_alignmask = 7,
+	.base.cra_priority = 4001,
+	.base.cra_module = THIS_MODULE,
+
+	.init = otx2_cpt_enc_dec_init,
+	.min_keysize = DES3_EDE_KEY_SIZE,
+	.max_keysize = DES3_EDE_KEY_SIZE,
+	.ivsize = 0,
+	.setkey = otx2_cpt_skcipher_ecb_des3_setkey,
+	.encrypt = otx2_cpt_skcipher_encrypt,
+	.decrypt = otx2_cpt_skcipher_decrypt,
+} };
+
+static struct aead_alg otx2_cpt_aeads[] = { {
+	.base = {
+		.cra_name = "authenc(hmac(sha1),cbc(aes))",
+		.cra_driver_name = "cpt_hmac_sha1_cbc_aes",
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_cbc_aes_sha1_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_cbc_aes_sha_setkey,
+	.setauthsize = otx2_cpt_aead_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA1_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha256),cbc(aes))",
+		.cra_driver_name = "cpt_hmac_sha256_cbc_aes",
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_cbc_aes_sha256_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_cbc_aes_sha_setkey,
+	.setauthsize = otx2_cpt_aead_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA256_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha384),cbc(aes))",
+		.cra_driver_name = "cpt_hmac_sha384_cbc_aes",
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_cbc_aes_sha384_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_cbc_aes_sha_setkey,
+	.setauthsize = otx2_cpt_aead_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA384_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha512),cbc(aes))",
+		.cra_driver_name = "cpt_hmac_sha512_cbc_aes",
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_cbc_aes_sha512_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_cbc_aes_sha_setkey,
+	.setauthsize = otx2_cpt_aead_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_BLOCK_SIZE,
+	.maxauthsize = SHA512_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha1),ecb(cipher_null))",
+		.cra_driver_name = "cpt_hmac_sha1_ecb_null",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_ecb_null_sha1_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_ecb_null_sha_setkey,
+	.setauthsize = otx2_cpt_aead_null_set_authsize,
+	.encrypt = otx2_cpt_aead_null_encrypt,
+	.decrypt = otx2_cpt_aead_null_decrypt,
+	.ivsize = 0,
+	.maxauthsize = SHA1_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha256),ecb(cipher_null))",
+		.cra_driver_name = "cpt_hmac_sha256_ecb_null",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_ecb_null_sha256_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_ecb_null_sha_setkey,
+	.setauthsize = otx2_cpt_aead_null_set_authsize,
+	.encrypt = otx2_cpt_aead_null_encrypt,
+	.decrypt = otx2_cpt_aead_null_decrypt,
+	.ivsize = 0,
+	.maxauthsize = SHA256_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha384),ecb(cipher_null))",
+		.cra_driver_name = "cpt_hmac_sha384_ecb_null",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_ecb_null_sha384_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_ecb_null_sha_setkey,
+	.setauthsize = otx2_cpt_aead_null_set_authsize,
+	.encrypt = otx2_cpt_aead_null_encrypt,
+	.decrypt = otx2_cpt_aead_null_decrypt,
+	.ivsize = 0,
+	.maxauthsize = SHA384_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "authenc(hmac(sha512),ecb(cipher_null))",
+		.cra_driver_name = "cpt_hmac_sha512_ecb_null",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_ecb_null_sha512_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_ecb_null_sha_setkey,
+	.setauthsize = otx2_cpt_aead_null_set_authsize,
+	.encrypt = otx2_cpt_aead_null_encrypt,
+	.decrypt = otx2_cpt_aead_null_decrypt,
+	.ivsize = 0,
+	.maxauthsize = SHA512_DIGEST_SIZE,
+}, {
+	.base = {
+		.cra_name = "rfc4106(gcm(aes))",
+		.cra_driver_name = "cpt_rfc4106_gcm_aes",
+		.cra_blocksize = 1,
+		.cra_flags = CRYPTO_ALG_ASYNC,
+		.cra_ctxsize = sizeof(struct otx2_cpt_aead_ctx),
+		.cra_priority = 4001,
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+	},
+	.init = otx2_cpt_aead_gcm_aes_init,
+	.exit = otx2_cpt_aead_exit,
+	.setkey = otx2_cpt_aead_gcm_aes_setkey,
+	.setauthsize = otx2_cpt_aead_gcm_set_authsize,
+	.encrypt = otx2_cpt_aead_encrypt,
+	.decrypt = otx2_cpt_aead_decrypt,
+	.ivsize = AES_GCM_IV_SIZE,
+	.maxauthsize = AES_GCM_ICV_SIZE,
+} };
+
+static inline int cpt_register_algs(void)
+{
+	int i, err = 0;
+
+	if (!IS_ENABLED(CONFIG_DM_CRYPT)) {
+		for (i = 0; i < ARRAY_SIZE(otx2_cpt_skciphers); i++)
+			otx2_cpt_skciphers[i].base.cra_flags &=
+							~CRYPTO_ALG_DEAD;
+
+		err = crypto_register_skciphers(otx2_cpt_skciphers,
+						ARRAY_SIZE(otx2_cpt_skciphers));
+		if (err)
+			return err;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(otx2_cpt_aeads); i++)
+		otx2_cpt_aeads[i].base.cra_flags &= ~CRYPTO_ALG_DEAD;
+
+	err = crypto_register_aeads(otx2_cpt_aeads,
+				    ARRAY_SIZE(otx2_cpt_aeads));
+	if (err) {
+		crypto_unregister_skciphers(otx2_cpt_skciphers,
+					    ARRAY_SIZE(otx2_cpt_skciphers));
+		return err;
+	}
+
+	return 0;
+}
+
+static inline void cpt_unregister_algs(void)
+{
+	crypto_unregister_skciphers(otx2_cpt_skciphers,
+				    ARRAY_SIZE(otx2_cpt_skciphers));
+	crypto_unregister_aeads(otx2_cpt_aeads, ARRAY_SIZE(otx2_cpt_aeads));
+}
+
+static int compare_func(const void *lptr, const void *rptr)
+{
+	const struct cpt_device_desc *ldesc = (struct cpt_device_desc *) lptr;
+	const struct cpt_device_desc *rdesc = (struct cpt_device_desc *) rptr;
+
+	if (ldesc->dev->devfn < rdesc->dev->devfn)
+		return -1;
+	if (ldesc->dev->devfn > rdesc->dev->devfn)
+		return 1;
+	return 0;
+}
+
+static void swap_func(void *lptr, void *rptr, int size)
+{
+	struct cpt_device_desc *ldesc = lptr;
+	struct cpt_device_desc *rdesc = rptr;
+	struct cpt_device_desc desc;
+
+	desc = *ldesc;
+	*ldesc = *rdesc;
+	*rdesc = desc;
+}
+
+int otx2_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
+			 int num_queues, int num_devices)
+{
+	int ret = 0;
+	int count;
+
+	mutex_lock(&mutex);
+	count = atomic_read(&se_devices.count);
+	if (count >= OTX2_CPT_MAX_LFS_NUM) {
+		dev_err(&pdev->dev, "No space to add a new device\n");
+		ret = -ENOSPC;
+		goto unlock;
+	}
+	se_devices.desc[count].num_queues = num_queues;
+	se_devices.desc[count++].dev = pdev;
+	atomic_inc(&se_devices.count);
+
+	if (atomic_read(&se_devices.count) == num_devices &&
+	    is_crypto_registered == false) {
+		if (cpt_register_algs()) {
+			dev_err(&pdev->dev,
+				"Error in registering crypto algorithms\n");
+			ret =  -EINVAL;
+			goto unlock;
+		}
+		try_module_get(mod);
+		is_crypto_registered = true;
+	}
+	sort(se_devices.desc, count, sizeof(struct cpt_device_desc),
+	     compare_func, swap_func);
+
+unlock:
+	mutex_unlock(&mutex);
+	return ret;
+}
+
+void otx2_cpt_crypto_exit(struct pci_dev *pdev, struct module *mod)
+{
+	struct cpt_device_table *dev_tbl;
+	bool dev_found = false;
+	int i, j, count;
+
+	mutex_lock(&mutex);
+
+	dev_tbl = &se_devices;
+	count = atomic_read(&dev_tbl->count);
+	for (i = 0; i < count; i++) {
+		if (pdev == dev_tbl->desc[i].dev) {
+			for (j = i; j < count-1; j++)
+				dev_tbl->desc[j] = dev_tbl->desc[j+1];
+			dev_found = true;
+			break;
+		}
+	}
+
+	if (!dev_found) {
+		dev_err(&pdev->dev, "%s device not found\n", __func__);
+		goto unlock;
+	}
+	if (atomic_dec_and_test(&se_devices.count)) {
+		cpt_unregister_algs();
+		module_put(mod);
+		is_crypto_registered = false;
+	}
+unlock:
+	mutex_unlock(&mutex);
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
new file mode 100644
index 000000000000..c71e2af24ec3
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
@@ -0,0 +1,170 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2020 Marvell.
+ */
+
+#ifndef __OTX2_CPT_ALGS_H
+#define __OTX2_CPT_ALGS_H
+
+#include <crypto/hash.h>
+#include "otx2_cpt_common.h"
+
+#define OTX2_CPT_MAX_ENC_KEY_SIZE    32
+#define OTX2_CPT_MAX_HASH_KEY_SIZE   64
+#define OTX2_CPT_MAX_KEY_SIZE (OTX2_CPT_MAX_ENC_KEY_SIZE + \
+			       OTX2_CPT_MAX_HASH_KEY_SIZE)
+enum otx2_cpt_request_type {
+	OTX2_CPT_ENC_DEC_REQ            = 0x1,
+	OTX2_CPT_AEAD_ENC_DEC_REQ       = 0x2,
+	OTX2_CPT_AEAD_ENC_DEC_NULL_REQ  = 0x3,
+	OTX2_CPT_PASSTHROUGH_REQ	= 0x4
+};
+
+enum otx2_cpt_major_opcodes {
+	OTX2_CPT_MAJOR_OP_MISC = 0x01,
+	OTX2_CPT_MAJOR_OP_FC   = 0x33,
+	OTX2_CPT_MAJOR_OP_HMAC = 0x35,
+};
+
+enum otx2_cpt_cipher_type {
+	OTX2_CPT_CIPHER_NULL = 0x0,
+	OTX2_CPT_DES3_CBC = 0x1,
+	OTX2_CPT_DES3_ECB = 0x2,
+	OTX2_CPT_AES_CBC  = 0x3,
+	OTX2_CPT_AES_ECB  = 0x4,
+	OTX2_CPT_AES_CFB  = 0x5,
+	OTX2_CPT_AES_CTR  = 0x6,
+	OTX2_CPT_AES_GCM  = 0x7,
+	OTX2_CPT_AES_XTS  = 0x8
+};
+
+enum otx2_cpt_mac_type {
+	OTX2_CPT_MAC_NULL = 0x0,
+	OTX2_CPT_MD5      = 0x1,
+	OTX2_CPT_SHA1     = 0x2,
+	OTX2_CPT_SHA224   = 0x3,
+	OTX2_CPT_SHA256   = 0x4,
+	OTX2_CPT_SHA384   = 0x5,
+	OTX2_CPT_SHA512   = 0x6,
+	OTX2_CPT_GMAC     = 0x7
+};
+
+enum otx2_cpt_aes_key_len {
+	OTX2_CPT_AES_128_BIT = 0x1,
+	OTX2_CPT_AES_192_BIT = 0x2,
+	OTX2_CPT_AES_256_BIT = 0x3
+};
+
+union otx2_cpt_encr_ctrl {
+	u64 u;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 enc_cipher:4;
+		u64 reserved_59:1;
+		u64 aes_key:2;
+		u64 iv_source:1;
+		u64 mac_type:4;
+		u64 reserved_49_51:3;
+		u64 auth_input_type:1;
+		u64 mac_len:8;
+		u64 reserved_32_39:8;
+		u64 encr_offset:16;
+		u64 iv_offset:8;
+		u64 auth_offset:8;
+#else
+		u64 auth_offset:8;
+		u64 iv_offset:8;
+		u64 encr_offset:16;
+		u64 reserved_32_39:8;
+		u64 mac_len:8;
+		u64 auth_input_type:1;
+		u64 reserved_49_51:3;
+		u64 mac_type:4;
+		u64 iv_source:1;
+		u64 aes_key:2;
+		u64 reserved_59:1;
+		u64 enc_cipher:4;
+#endif
+	} e;
+};
+
+struct otx2_cpt_cipher {
+	const char *name;
+	u8 value;
+};
+
+struct otx2_cpt_fc_enc_ctx {
+	union otx2_cpt_encr_ctrl enc_ctrl;
+	u8 encr_key[32];
+	u8 encr_iv[16];
+};
+
+union otx2_cpt_fc_hmac_ctx {
+	struct {
+		u8 ipad[64];
+		u8 opad[64];
+	} e;
+	struct {
+		u8 hmac_calc[64]; /* HMAC calculated */
+		u8 hmac_recv[64]; /* HMAC received */
+	} s;
+};
+
+struct otx2_cpt_fc_ctx {
+	struct otx2_cpt_fc_enc_ctx enc;
+	union otx2_cpt_fc_hmac_ctx hmac;
+};
+
+struct otx2_cpt_enc_ctx {
+	u32 key_len;
+	u8 enc_key[OTX2_CPT_MAX_KEY_SIZE];
+	u8 cipher_type;
+	u8 key_type;
+	u8 enc_align_len;
+};
+
+union otx2_cpt_offset_ctrl {
+	u64 flags;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u64 reserved:32;
+		u64 enc_data_offset:16;
+		u64 iv_offset:8;
+		u64 auth_offset:8;
+#else
+		u64 auth_offset:8;
+		u64 iv_offset:8;
+		u64 enc_data_offset:16;
+		u64 reserved:32;
+#endif
+	} e;
+};
+
+struct otx2_cpt_req_ctx {
+	struct otx2_cpt_req_info cpt_req;
+	union otx2_cpt_offset_ctrl ctrl_word;
+	struct otx2_cpt_fc_ctx fctx;
+};
+
+struct otx2_cpt_sdesc {
+	struct shash_desc shash;
+};
+
+struct otx2_cpt_aead_ctx {
+	u8 key[OTX2_CPT_MAX_KEY_SIZE];
+	struct crypto_shash *hashalg;
+	struct otx2_cpt_sdesc *sdesc;
+	u8 *ipad;
+	u8 *opad;
+	u32 enc_key_len;
+	u32 auth_key_len;
+	u8 cipher_type;
+	u8 mac_type;
+	u8 key_type;
+	u8 is_trunc_hmac;
+	u8 enc_align_len;
+};
+int otx2_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
+			 int num_queues, int num_devices);
+void otx2_cpt_crypto_exit(struct pci_dev *pdev, struct module *mod);
+
+#endif /* __OTX2_CPT_ALGS_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 6798e42dfade..46829e9f2efd 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -4,6 +4,7 @@
 #include "otx2_cpt_common.h"
 #include "otx2_cptvf.h"
 #include "otx2_cptlf.h"
+#include "otx2_cptvf_algs.h"
 #include <rvu_reg.h>
 
 #define OTX2_CPTVF_DRV_NAME "octeontx2-cptvf"
@@ -211,6 +212,8 @@ static void cptvf_lf_shutdown(struct otx2_cptlfs_info *lfs)
 	otx2_cptlf_free_irqs_affinity(lfs);
 	/* Disable instruction queue */
 	otx2_cptlf_disable_iqueues(lfs);
+	/* Unregister crypto algorithms */
+	otx2_cpt_crypto_exit(lfs->pdev, THIS_MODULE);
 	/* Unregister LFs interrupts */
 	otx2_cptlf_unregister_interrupts(lfs);
 	/* Cleanup LFs software side */
@@ -270,8 +273,16 @@ static int cptvf_lf_init(struct otx2_cptvf_dev *cptvf)
 		goto unregister_intr;
 
 	atomic_set(&lfs->state, OTX2_CPTLF_STARTED);
-
+	/* Register crypto algorithms */
+	ret = otx2_cpt_crypto_init(lfs->pdev, THIS_MODULE, lfs_num, 1);
+	if (ret) {
+		dev_err(&lfs->pdev->dev, "algorithms registration failed\n");
+		goto disable_irqs;
+	}
 	return 0;
+
+disable_irqs:
+	otx2_cptlf_free_irqs_affinity(lfs);
 unregister_intr:
 	otx2_cptlf_unregister_interrupts(lfs);
 cleanup_lf_sw:
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
index 05fd59082b5a..b8d567ed9168 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -530,3 +530,10 @@ void otx2_cpt_post_process(struct otx2_cptlf_wqe *wqe)
 	process_pending_queue(wqe->lfs->pdev,
 			      &wqe->lfs->lf[wqe->lf_num].pqueue);
 }
+
+int otx2_cpt_get_kcrypto_eng_grp_num(struct pci_dev *pdev)
+{
+	struct otx2_cptvf_dev *cptvf = pci_get_drvdata(pdev);
+
+	return cptvf->lfs.kcrypto_eng_grp_num;
+}
-- 
2.28.0

