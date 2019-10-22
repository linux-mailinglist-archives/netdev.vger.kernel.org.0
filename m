Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96022E0D42
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389271AbfJVUba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:31:30 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41612 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbfJVUb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:31:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so10626584pga.8
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 13:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ooAaH290DoNGIT/8IMExYM+TG0qPwbD9l7j4IH/0iwI=;
        b=C5sL6mfpryphtjl/ZskCYEyBpW2TFoKXwQHNHZ9vm3caY0a4kwSStgdvL8aKeI6gzG
         yslJg6cHVdTFSbzg7d075PLXo2066UVJocL9FDlGRskPRM5d6Jacjfe0Px/QqvPAx70u
         YoEO3sBx5oB8BYSf1dSdoF/AvjlZ1auL+VCasV8nbxgrUtEMD7jMNF8ilx05x77cM4uO
         MdqQHjbFWxwxIhIK1pfQfswOHAunCcuv+r9z4BhLuu6amxyHpxJ6jnoUuylK35OBvtq2
         zrS4v+e9RIS35FsjW4C9k52e34v0azaCqBi4KU57MjOmrxt0riDA4tsaC8dd8q2ACkXa
         Xx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ooAaH290DoNGIT/8IMExYM+TG0qPwbD9l7j4IH/0iwI=;
        b=G2rgMgHdG0PzU3ypw46yK+ZDq4JM6KjD+jgBSw+513qdStQMz/qqeStAm/KL2jqtg0
         CeWaGelVQUmhm51z6r6aOXJ7AVZgPU+Bca8uAvMm0yVeAwnTyrMxpt3Z/g2kEr3bAFBv
         HLCIdAvQJhDAm3EdYJmdJMlPNU3d6yNcsy1D0jum0z9NE1C17H99GU2KUVSoeGpLZcuS
         1EjcxILuNZTRJJjitdeff4VJ6bsy1GRMNi03aUtuYnzrIMAuKKvLnlj0w6vKRie5AUqs
         32ElyUKy+2EDN0LJUTDZO4wtJLum4+WVC9yih3ea48u++T1SoCdTDwNstcepGtoLbGUK
         5CNQ==
X-Gm-Message-State: APjAAAU3KTZ6Wqp7bJ0Ec4N6hVUM4nea910mFxo3jFu0/roJ162uWVI+
        mWbM1BsO67Pg5zcjY0xFRb5Ek+FNnSIiJQ==
X-Google-Smtp-Source: APXvYqzgy4bHEc3g5fh2TC5L7zxCiosJ8sjD5q9KNSGKG5lMnk9ps+mscBlSTlpHfcAZKxn/Nv3YQg==
X-Received: by 2002:aa7:8e16:: with SMTP id c22mr6351414pfr.116.1571776285873;
        Tue, 22 Oct 2019 13:31:25 -0700 (PDT)
Received: from driver-dev1.pensando.io.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q143sm20754530pfq.103.2019.10.22.13.31.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 13:31:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/6] ionic: add heartbeat check
Date:   Tue, 22 Oct 2019 13:31:10 -0700
Message-Id: <20191022203113.30015-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191022203113.30015-1-snelson@pensando.io>
References: <20191022203113.30015-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of our firmware has a heartbeat feature that the driver
can watch for to see if the FW is still alive and likely to
answer a dev_cmd or AdminQ request.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 43 +++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  4 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  | 24 ++++++++++-
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index d168a6435322..544a9f799afc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -84,6 +84,49 @@ void ionic_dev_teardown(struct ionic *ionic)
 }
 
 /* Devcmd Interface */
+int ionic_heartbeat_check(struct ionic *ionic)
+{
+	struct ionic_dev *idev = &ionic->idev;
+	unsigned long hb_time;
+	u32 fw_status;
+	u32 hb;
+
+	/* wait a little more than one second before testing again */
+	hb_time = jiffies;
+	if (time_before(hb_time, (idev->last_hb_time + (HZ * 2))))
+		return 0;
+
+	/* firmware is useful only if fw_status is non-zero */
+	fw_status = ioread32(&idev->dev_info_regs->fw_status);
+	if (!fw_status)
+		return -ENXIO;
+
+	/* early FW has no heartbeat, else FW will return non-zero */
+	hb = ioread32(&idev->dev_info_regs->fw_heartbeat);
+	if (!hb)
+		return 0;
+
+	/* are we stalled? */
+	if (hb == idev->last_hb) {
+		/* only complain once for each stall seen */
+		if (idev->last_hb_time != 1) {
+			dev_info(ionic->dev, "FW heartbeat stalled at %d\n",
+				 idev->last_hb);
+			idev->last_hb_time = 1;
+		}
+
+		return -ENXIO;
+	}
+
+	if (idev->last_hb_time == 1)
+		dev_info(ionic->dev, "FW heartbeat restored at %d\n", hb);
+
+	idev->last_hb = hb;
+	idev->last_hb_time = hb_time;
+
+	return 0;
+}
+
 u8 ionic_dev_cmd_status(struct ionic_dev *idev)
 {
 	return ioread8(&idev->dev_cmd_regs->comp.comp.status);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 9610aeb7d5f4..1ffb3e4dec5d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -123,6 +123,9 @@ struct ionic_dev {
 	union ionic_dev_info_regs __iomem *dev_info_regs;
 	union ionic_dev_cmd_regs __iomem *dev_cmd_regs;
 
+	unsigned long last_hb_time;
+	u32 last_hb;
+
 	u64 __iomem *db_pages;
 	dma_addr_t phy_db_pages;
 
@@ -295,5 +298,6 @@ void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
 void ionic_q_rewind(struct ionic_queue *q, struct ionic_desc_info *start);
 void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 		     unsigned int stop_index);
+int ionic_heartbeat_check(struct ionic *ionic);
 
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 15e432386b35..52eb303e903f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -245,6 +245,10 @@ static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 		goto err_out;
 	}
 
+	err = ionic_heartbeat_check(lif->ionic);
+	if (err)
+		goto err_out;
+
 	memcpy(adminq->head->desc, &ctx->cmd, sizeof(ctx->cmd));
 
 	dev_dbg(&lif->netdev->dev, "post admin queue command:\n");
@@ -305,6 +309,14 @@ int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
 	return work_done;
 }
 
+static void ionic_dev_cmd_clean(struct ionic *ionic)
+{
+	union ionic_dev_cmd_regs *regs = ionic->idev.dev_cmd_regs;
+
+	iowrite32(0, &regs->doorbell);
+	memset_io(&regs->cmd, 0, sizeof(regs->cmd));
+}
+
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 {
 	struct ionic_dev *idev = &ionic->idev;
@@ -314,6 +326,7 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 	int opcode;
 	int done;
 	int err;
+	int hb;
 
 	WARN_ON(in_interrupt());
 
@@ -328,7 +341,8 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 		if (done)
 			break;
 		msleep(20);
-	} while (!done && time_before(jiffies, max_wait));
+		hb = ionic_heartbeat_check(ionic);
+	} while (!done && !hb && time_before(jiffies, max_wait));
 	duration = jiffies - start_time;
 
 	opcode = idev->dev_cmd_regs->cmd.cmd.opcode;
@@ -336,7 +350,15 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 		ionic_opcode_to_str(opcode), opcode,
 		done, duration / HZ, duration);
 
+	if (!done && hb) {
+		ionic_dev_cmd_clean(ionic);
+		dev_warn(ionic->dev, "DEVCMD %s (%d) failed - FW halted\n",
+			 ionic_opcode_to_str(opcode), opcode);
+		return -ENXIO;
+	}
+
 	if (!done && !time_before(jiffies, max_wait)) {
+		ionic_dev_cmd_clean(ionic);
 		dev_warn(ionic->dev, "DEVCMD %s (%d) timeout after %ld secs\n",
 			 ionic_opcode_to_str(opcode), opcode, max_seconds);
 		return -ETIMEDOUT;
-- 
2.17.1

