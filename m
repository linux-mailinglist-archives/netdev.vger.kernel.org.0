Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1FE262AD9
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgIIIrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729990AbgIIIqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:46:31 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5318EC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:46:30 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 5so1583699pgl.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eF7CXOHDjUtM7J2SqPc01CaynU91WRPCCBCJ/GO5aGk=;
        b=GcL2CMJdGR0v5ZtiWrCDKDWN8FZh8Uk6qbgA5PyllakS8p9/N8s2NgxgghajnIJ1b1
         7JtEiqWedy5O4WnE5okrk31FR3T5WY2qzy4FAmfgVKe+JGaIy+vpkDz/QDTEQeWX3f6j
         E80XCmivK10u8VLBYyxdiruwAhWBCribqJr/OZfkZVgyRNhTS0FHMac6iQgV2q8bFAKJ
         6rnk3rwIYieemYEsYblZaktVeV+F3eHKxkIPGEDw5yRXtzbHBs9VRXCMP2/1BLT2irK6
         KH7OkxwyQbs/1NIKcE3W/jG6YsDCCLfSy80TrPMhg8LKutSCWZI9KNp55f01kIt4MeZq
         vsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eF7CXOHDjUtM7J2SqPc01CaynU91WRPCCBCJ/GO5aGk=;
        b=WHbU+IlzVYt+E1F67kx520SF5oaXxhMx/Vc14C1dioWLAm9UokQfqUIsnxwkoUNR81
         PLXm6rE0SY3R6s0Yg62mVBU9UDUDnMgbxKNwGxSOZ7eXoyyx9gpWq3DjmQFiY2OPN1jZ
         QNtgIYn1EeJ21NBzHjVWbtAd+IBhG51etJT/Nw0uLZD4iMLYAy+fX7nv3oqEl2rJQsVD
         U7VDGc+TA/ziN1hMf5cguGBeobv6A1HqKZvxHvBGJR1mt66I50ZLIbI5cxrc+/7FWhk2
         ILcGnuhhubx5EbaidJa1S3FPP1P3h5V84HrKeBZL76rtR4hj0fMkkZ2eU7/3ULi5knhG
         fapw==
X-Gm-Message-State: AOAM533JNkSFD2hmtKNCXRMHTEjaBKQ7wQe3oeS0Nz+KiwOscZXoR3se
        bUHnvfCKlVQPhTv3Q3EE4os=
X-Google-Smtp-Source: ABdhPJx3xzsLASoCSUvM0DrQir6+6LXYbh1JN1eFvJthAF4ZdXSgDjB6+ku8nNBz7RYEE09Sxt+6Bg==
X-Received: by 2002:a63:f53:: with SMTP id 19mr2263758pgp.26.1599641187853;
        Wed, 09 Sep 2020 01:46:27 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:46:27 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 18/20] ethernet: qlogic: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:08 +0530
Message-Id: <20200909084510.648706-19-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c  | 27 +++-------------------
 drivers/net/ethernet/qlogic/qed/qed_int.h  |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c | 14 +++++------
 4 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index b2a7b53ee760..22bc4ec7859a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -572,7 +572,7 @@ struct qed_hwfn {
 	struct qed_consq		*p_consq;
 
 	/* Slow-Path definitions */
-	struct tasklet_struct		*sp_dpc;
+	struct tasklet_struct		sp_dpc;
 	bool				b_sp_dpc_enabled;
 
 	struct qed_ptt			*p_main_ptt;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index f8c5a864812d..578935f643b8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1216,9 +1216,9 @@ static void qed_sb_ack_attn(struct qed_hwfn *p_hwfn,
 	barrier();
 }
 
-void qed_int_sp_dpc(unsigned long hwfn_cookie)
+void qed_int_sp_dpc(struct tasklet_struct *t)
 {
-	struct qed_hwfn *p_hwfn = (struct qed_hwfn *)hwfn_cookie;
+	struct qed_hwfn *p_hwfn = from_tasklet(p_hwfn, t, sp_dpc);
 	struct qed_pi_info *pi_info = NULL;
 	struct qed_sb_attn_info *sb_attn;
 	struct qed_sb_info *sb_info;
@@ -2285,34 +2285,14 @@ u64 qed_int_igu_read_sisr_reg(struct qed_hwfn *p_hwfn)
 
 static void qed_int_sp_dpc_setup(struct qed_hwfn *p_hwfn)
 {
-	tasklet_init(p_hwfn->sp_dpc,
-		     qed_int_sp_dpc, (unsigned long)p_hwfn);
+	tasklet_setup(&p_hwfn->sp_dpc, qed_int_sp_dpc);
 	p_hwfn->b_sp_dpc_enabled = true;
 }
 
-static int qed_int_sp_dpc_alloc(struct qed_hwfn *p_hwfn)
-{
-	p_hwfn->sp_dpc = kmalloc(sizeof(*p_hwfn->sp_dpc), GFP_KERNEL);
-	if (!p_hwfn->sp_dpc)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void qed_int_sp_dpc_free(struct qed_hwfn *p_hwfn)
-{
-	kfree(p_hwfn->sp_dpc);
-	p_hwfn->sp_dpc = NULL;
-}
-
 int qed_int_alloc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	int rc = 0;
 
-	rc = qed_int_sp_dpc_alloc(p_hwfn);
-	if (rc)
-		return rc;
-
 	rc = qed_int_sp_sb_alloc(p_hwfn, p_ptt);
 	if (rc)
 		return rc;
@@ -2326,7 +2306,6 @@ void qed_int_free(struct qed_hwfn *p_hwfn)
 {
 	qed_int_sp_sb_free(p_hwfn);
 	qed_int_sb_attn_free(p_hwfn);
-	qed_int_sp_dpc_free(p_hwfn);
 }
 
 void qed_int_setup(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h b/drivers/net/ethernet/qlogic/qed/qed_int.h
index 86809d7bc2de..c5550e96bbe1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
@@ -140,7 +140,7 @@ int qed_int_sb_release(struct qed_hwfn *p_hwfn,
  * @param p_hwfn - pointer to hwfn
  *
  */
-void qed_int_sp_dpc(unsigned long hwfn_cookie);
+void qed_int_sp_dpc(struct tasklet_struct *t);
 
 /**
  * @brief qed_int_get_num_sbs - get the number of status
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index f39f629242a1..9352c2f52ecd 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -841,7 +841,7 @@ static irqreturn_t qed_single_int(int irq, void *dev_instance)
 
 		/* Slowpath interrupt */
 		if (unlikely(status & 0x1)) {
-			tasklet_schedule(hwfn->sp_dpc);
+			tasklet_schedule(&hwfn->sp_dpc);
 			status &= ~0x1;
 			rc = IRQ_HANDLED;
 		}
@@ -887,7 +887,7 @@ int qed_slowpath_irq_req(struct qed_hwfn *hwfn)
 			 id, cdev->pdev->bus->number,
 			 PCI_SLOT(cdev->pdev->devfn), hwfn->abs_pf_id);
 		rc = request_irq(cdev->int_params.msix_table[id].vector,
-				 qed_msix_sp_int, 0, hwfn->name, hwfn->sp_dpc);
+				 qed_msix_sp_int, 0, hwfn->name, &hwfn->sp_dpc);
 	} else {
 		unsigned long flags = 0;
 
@@ -919,8 +919,8 @@ static void qed_slowpath_tasklet_flush(struct qed_hwfn *p_hwfn)
 	 * enable function makes this sequence a flush-like operation.
 	 */
 	if (p_hwfn->b_sp_dpc_enabled) {
-		tasklet_disable(p_hwfn->sp_dpc);
-		tasklet_enable(p_hwfn->sp_dpc);
+		tasklet_disable(&p_hwfn->sp_dpc);
+		tasklet_enable(&p_hwfn->sp_dpc);
 	}
 }
 
@@ -949,7 +949,7 @@ static void qed_slowpath_irq_free(struct qed_dev *cdev)
 				break;
 			synchronize_irq(cdev->int_params.msix_table[i].vector);
 			free_irq(cdev->int_params.msix_table[i].vector,
-				 cdev->hwfns[i].sp_dpc);
+				 &cdev->hwfns[i].sp_dpc);
 		}
 	} else {
 		if (QED_LEADING_HWFN(cdev)->b_int_requested)
@@ -968,11 +968,11 @@ static int qed_nic_stop(struct qed_dev *cdev)
 		struct qed_hwfn *p_hwfn = &cdev->hwfns[i];
 
 		if (p_hwfn->b_sp_dpc_enabled) {
-			tasklet_disable(p_hwfn->sp_dpc);
+			tasklet_disable(&p_hwfn->sp_dpc);
 			p_hwfn->b_sp_dpc_enabled = false;
 			DP_VERBOSE(cdev, NETIF_MSG_IFDOWN,
 				   "Disabled sp tasklet [hwfn %d] at %p\n",
-				   i, p_hwfn->sp_dpc);
+				   i, &p_hwfn->sp_dpc);
 		}
 	}
 
-- 
2.25.1

