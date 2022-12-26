Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B01656161
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 10:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiLZJIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 04:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiLZJIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 04:08:37 -0500
X-Greylist: delayed 134 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Dec 2022 01:08:36 PST
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8281CD8;
        Mon, 26 Dec 2022 01:08:35 -0800 (PST)
Received: from myt5-8800bd68420f.qloud-c.yandex.net (myt5-8800bd68420f.qloud-c.yandex.net [IPv6:2a02:6b8:c12:4615:0:640:8800:bd68])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 5EA9D5FCEF;
        Mon, 26 Dec 2022 12:06:19 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:1::1:f])
        by myt5-8800bd68420f.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id D6KfxX0ReqM1-CeqjHN3x;
        Mon, 26 Dec 2022 12:06:17 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1672045577; bh=hreEt9oBsbG7JpAJajQXCkDGpKyNaPQ4PR/13o4Hum8=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=FDPwZddpeGNhoWfyPPtFZMHB8HDH6VkJWYc2dDIUr23c1K915T5eyXVE7ctFDtZvl
         cHc4rsIx/fFm8YDlKfgGca2HbJvhvuTjxA36oLUbCfvH8zRO7D/lF7ve4mBYncQLYx
         l9HLYED7E/FdQWDj3R/VlG52FptdR4IFeEHBNrS0=
Authentication-Results: myt5-8800bd68420f.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Varun Prakash <varun@chelsio.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>, Wu Bo <wubo40@huawei.com>,
        Nilesh Javali <njavali@marvell.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RESEND PATCH v2] cxgbi: move cxgbi_ddp_set_one_ppod to cxgb_ppm and remove its duplicate
Date:   Mon, 26 Dec 2022 12:06:09 +0300
Message-Id: <20221226090609.1917788-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cxgbit and libcxgbi both used the exact same function but with slightly
different names, and a missing NULL check in one case. Move the function
to libcxgb/libcxgb_ppm.c and nuke the duplicate.

This also renames the function to cxgbi_ppm_set_one_ppod so that it
matches the rest of the functions in cxgb_ppm.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Acked-by: Varun Prakash <varun@chelsio.com>
---
 .../ethernet/chelsio/libcxgb/libcxgb_ppm.c    | 56 ++++++++++++++++++
 .../ethernet/chelsio/libcxgb/libcxgb_ppm.h    |  5 ++
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c            |  2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c            |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c                 | 55 ------------------
 drivers/scsi/cxgbi/libcxgbi.h                 |  3 -
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c      | 57 +------------------
 7 files changed, 64 insertions(+), 116 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
index 854d87e1125c..9103826b0d27 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
@@ -527,6 +527,62 @@ unsigned int cxgbi_tagmask_set(unsigned int ppmax)
 }
 EXPORT_SYMBOL(cxgbi_tagmask_set);
 
+void
+cxgbi_ppm_set_one_ppod(struct cxgbi_pagepod *ppod,
+		       struct cxgbi_task_tag_info *ttinfo,
+		       struct scatterlist **sg_pp, unsigned int *sg_off)
+{
+	struct scatterlist *sg = sg_pp ? *sg_pp : NULL;
+	unsigned int offset = sg_off ? *sg_off : 0;
+	dma_addr_t addr = 0UL;
+	unsigned int len = 0;
+	int i;
+
+	memcpy(ppod, &ttinfo->hdr, sizeof(struct cxgbi_pagepod_hdr));
+
+	if (sg) {
+		addr = sg_dma_address(sg);
+		len = sg_dma_len(sg);
+	}
+
+	for (i = 0; i < PPOD_PAGES_MAX; i++) {
+		if (sg) {
+			ppod->addr[i] = cpu_to_be64(addr + offset);
+			offset += PAGE_SIZE;
+			if (offset == (len + sg->offset)) {
+				offset = 0;
+				sg = sg_next(sg);
+				if (sg) {
+					addr = sg_dma_address(sg);
+					len = sg_dma_len(sg);
+				}
+			}
+		} else {
+			ppod->addr[i] = 0ULL;
+		}
+	}
+
+	/*
+	 * the fifth address needs to be repeated in the next ppod, so do
+	 * not move sg
+	 */
+	if (sg_pp) {
+		*sg_pp = sg;
+		*sg_off = offset;
+	}
+
+	if (offset == len) {
+		offset = 0;
+		if (sg) {
+			sg = sg_next(sg);
+			if (sg)
+				addr = sg_dma_address(sg);
+		}
+	}
+	ppod->addr[i] = sg ? cpu_to_be64(addr + offset) : 0ULL;
+}
+EXPORT_SYMBOL(cxgbi_ppm_set_one_ppod);
+
 MODULE_AUTHOR("Chelsio Communications");
 MODULE_DESCRIPTION("Chelsio common library");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h
index 1b4156461ba1..f2178ee0b18a 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h
@@ -332,4 +332,9 @@ int cxgbi_ppm_release(struct cxgbi_ppm *ppm);
 void cxgbi_tagmask_check(unsigned int tagmask, struct cxgbi_tag_format *);
 unsigned int cxgbi_tagmask_set(unsigned int ppmax);
 
+void
+cxgbi_ppm_set_one_ppod(struct cxgbi_pagepod *ppod,
+		       struct cxgbi_task_tag_info *ttinfo,
+		       struct scatterlist **sg_pp, unsigned int *sg_off);
+
 #endif	/*__LIBCXGB_PPM_H__*/
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index ff9d4287937a..0399e82362b7 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1115,7 +1115,7 @@ static int ddp_set_map(struct cxgbi_ppm *ppm, struct cxgbi_sock *csk,
 		req = (struct ulp_mem_io *)skb->head;
 		ppod = (struct cxgbi_pagepod *)(req + 1);
 		sg_off = i * PPOD_PAGES_MAX;
-		cxgbi_ddp_set_one_ppod(ppod, ttinfo, &sg,
+		cxgbi_ppm_set_one_ppod(ppod, ttinfo, &sg,
 				       &sg_off);
 		skb->priority = CPL_PRIORITY_CONTROL;
 		cxgb3_ofld_send(ppm->lldev, skb);
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index c07d2e3b4bcf..1f768cc3fbfb 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -2035,7 +2035,7 @@ static int ddp_ppod_write_idata(struct cxgbi_ppm *ppm, struct cxgbi_sock *csk,
 	ppod = (struct cxgbi_pagepod *)(idata + 1);
 
 	for (i = 0; i < npods; i++, ppod++)
-		cxgbi_ddp_set_one_ppod(ppod, ttinfo, sg_pp, sg_off);
+		cxgbi_ppm_set_one_ppod(ppod, ttinfo, sg_pp, sg_off);
 
 	cxgbi_skcb_set_flag(skb, SKCBF_TX_MEM_WRITE);
 	cxgbi_skcb_set_flag(skb, SKCBF_TX_FLAG_COMPL);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index af281e271f88..6a2627a73f26 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1151,61 +1151,6 @@ scmd_get_params(struct scsi_cmnd *sc, struct scatterlist **sgl,
 	/* Caution: for protection sdb, sdb->length is invalid */
 }
 
-void cxgbi_ddp_set_one_ppod(struct cxgbi_pagepod *ppod,
-			    struct cxgbi_task_tag_info *ttinfo,
-			    struct scatterlist **sg_pp, unsigned int *sg_off)
-{
-	struct scatterlist *sg = sg_pp ? *sg_pp : NULL;
-	unsigned int offset = sg_off ? *sg_off : 0;
-	dma_addr_t addr = 0UL;
-	unsigned int len = 0;
-	int i;
-
-	memcpy(ppod, &ttinfo->hdr, sizeof(struct cxgbi_pagepod_hdr));
-
-	if (sg) {
-		addr = sg_dma_address(sg);
-		len = sg_dma_len(sg);
-	}
-
-	for (i = 0; i < PPOD_PAGES_MAX; i++) {
-		if (sg) {
-			ppod->addr[i] = cpu_to_be64(addr + offset);
-			offset += PAGE_SIZE;
-			if (offset == (len + sg->offset)) {
-				offset = 0;
-				sg = sg_next(sg);
-				if (sg) {
-					addr = sg_dma_address(sg);
-					len = sg_dma_len(sg);
-				}
-			}
-		} else {
-			ppod->addr[i] = 0ULL;
-		}
-	}
-
-	/*
-	 * the fifth address needs to be repeated in the next ppod, so do
-	 * not move sg
-	 */
-	if (sg_pp) {
-		*sg_pp = sg;
-		*sg_off = offset;
-	}
-
-	if (offset == len) {
-		offset = 0;
-		sg = sg_next(sg);
-		if (sg) {
-			addr = sg_dma_address(sg);
-			len = sg_dma_len(sg);
-		}
-	}
-	ppod->addr[i] = sg ? cpu_to_be64(addr + offset) : 0ULL;
-}
-EXPORT_SYMBOL_GPL(cxgbi_ddp_set_one_ppod);
-
 /*
  * APIs interacting with open-iscsi libraries
  */
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 3687b5c0cf90..f90e747bcb4f 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -636,9 +636,6 @@ int cxgbi_ddp_init(struct cxgbi_device *, unsigned int, unsigned int,
 			unsigned int, unsigned int);
 int cxgbi_ddp_cleanup(struct cxgbi_device *);
 void cxgbi_ddp_page_size_factor(int *);
-void cxgbi_ddp_set_one_ppod(struct cxgbi_pagepod *,
-			    struct cxgbi_task_tag_info *,
-			    struct scatterlist **sg_pp, unsigned int *sg_off);
 int cxgbi_ddp_ppm_setup(void **ppm_pp, struct cxgbi_device *cdev,
 			struct cxgbi_tag_format *tformat,
 			unsigned int iscsi_size, unsigned int llimit,
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index 17fd0d8cc490..fe29f4962058 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -5,61 +5,6 @@
 
 #include "cxgbit.h"
 
-static void
-cxgbit_set_one_ppod(struct cxgbi_pagepod *ppod,
-		    struct cxgbi_task_tag_info *ttinfo,
-		    struct scatterlist **sg_pp, unsigned int *sg_off)
-{
-	struct scatterlist *sg = sg_pp ? *sg_pp : NULL;
-	unsigned int offset = sg_off ? *sg_off : 0;
-	dma_addr_t addr = 0UL;
-	unsigned int len = 0;
-	int i;
-
-	memcpy(ppod, &ttinfo->hdr, sizeof(struct cxgbi_pagepod_hdr));
-
-	if (sg) {
-		addr = sg_dma_address(sg);
-		len = sg_dma_len(sg);
-	}
-
-	for (i = 0; i < PPOD_PAGES_MAX; i++) {
-		if (sg) {
-			ppod->addr[i] = cpu_to_be64(addr + offset);
-			offset += PAGE_SIZE;
-			if (offset == (len + sg->offset)) {
-				offset = 0;
-				sg = sg_next(sg);
-				if (sg) {
-					addr = sg_dma_address(sg);
-					len = sg_dma_len(sg);
-				}
-			}
-		} else {
-			ppod->addr[i] = 0ULL;
-		}
-	}
-
-	/*
-	 * the fifth address needs to be repeated in the next ppod, so do
-	 * not move sg
-	 */
-	if (sg_pp) {
-		*sg_pp = sg;
-		*sg_off = offset;
-	}
-
-	if (offset == len) {
-		offset = 0;
-		if (sg) {
-			sg = sg_next(sg);
-			if (sg)
-				addr = sg_dma_address(sg);
-		}
-	}
-	ppod->addr[i] = sg ? cpu_to_be64(addr + offset) : 0ULL;
-}
-
 static struct sk_buff *
 cxgbit_ppod_init_idata(struct cxgbit_device *cdev, struct cxgbi_ppm *ppm,
 		       unsigned int idx, unsigned int npods, unsigned int tid)
@@ -116,7 +61,7 @@ cxgbit_ppod_write_idata(struct cxgbi_ppm *ppm, struct cxgbit_sock *csk,
 	ppod = (struct cxgbi_pagepod *)(idata + 1);
 
 	for (i = 0; i < npods; i++, ppod++)
-		cxgbit_set_one_ppod(ppod, ttinfo, sg_pp, sg_off);
+		cxgbi_ppm_set_one_ppod(ppod, ttinfo, sg_pp, sg_off);
 
 	__skb_queue_tail(&csk->ppodq, skb);
 
-- 
2.25.1

