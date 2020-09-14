Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273AC2685F3
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgINHbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgINHbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:31:03 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD6BC061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:31:02 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n14so11875555pff.6
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4pvqiAF/2hxgxDrlvN/6Nw0fmCS9vrU/LfosPmNZwNc=;
        b=nLge9+/foq24qWLq8+CpURdHBq0A1uSqkMxcDualUB4peA+mPLtzQa2rbwR4HotIkG
         ClT0p7nuq1kYIO+BnrpLbNQr5PTafWkTkQ7XQ8RVecmX1fcAPzVUvz6dpc+DLO9M+X9F
         KZ1mCAs9Dnr2nxW+T99v5qEMuMncoPP5awB9uGIrtpEFr9xo0iaOvEnJe4EF3VsIeRcp
         VgnTh1TmhBp/5q4Xn+8eYyVRgAMDBNU9O5eU0OdMEAjNLcCiiRbibiI3msdXI/brsh8K
         OS7E99CgcLNRiYtJmCrcYk6aukTrcnV/qwe5edv3BZi/pgZaDJ9JDwV6MPVc9XumtKSo
         eTUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4pvqiAF/2hxgxDrlvN/6Nw0fmCS9vrU/LfosPmNZwNc=;
        b=Qkoxoy6FcZDgj4wMo7MNZdgjgFCxIH8pUykKIECbhGwuagGjeu2okYxbr7cjppiAOT
         pNXAWXaOWpJ2fTolMc65HdfKj0hWBoU86z55+lYqoeuPVMQEC1dpcf28s717srtu7xjW
         OGosq00OUM+fHaSdzdSmtcIFk/5nyMeJQfcG1u7N0H0b34XUG0YBCTBpNAoT0C2LCIeK
         uug5LUX+w8gjUwg41+Jawg/qjUfZktExnC+5Okk382mcjKvgSDs6wV3b9kZDhNGAEMle
         VRufTuW3NV2QfwIYkKnmn++mAU1NHAH766bpuqJiD/Wa1ODv1CNYTC/IzwJ3EXSapOcO
         XdXg==
X-Gm-Message-State: AOAM533h7gBkC81EhLC5MYgmQdh7QdPrORYWsUrs3/w1mQErGWhrL7Jx
        rmAadra7vZ5fOSxUYrf0MnE=
X-Google-Smtp-Source: ABdhPJzTajTwM5nJLvJADMJEK0uXB+Vi1hOCifNZLW7i2KhYcD5KiyBT8ZqP5bVR07R6afCbfj1Mdw==
X-Received: by 2002:a17:902:8306:b029:d0:cbe1:e7aa with SMTP id bd6-20020a1709028306b02900d0cbe1e7aamr13462616plb.27.1600068662478;
        Mon, 14 Sep 2020 00:31:02 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:31:02 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 18/20] qed: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:37 +0530
Message-Id: <20200914072939.803280-19-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
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

