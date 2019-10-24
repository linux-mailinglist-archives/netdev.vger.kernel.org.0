Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC61E2783
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 02:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389995AbfJXAtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 20:49:25 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38266 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407750AbfJXAtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 20:49:20 -0400
Received: by mail-pl1-f195.google.com with SMTP id w8so10956012plq.5
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 17:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ooAaH290DoNGIT/8IMExYM+TG0qPwbD9l7j4IH/0iwI=;
        b=zhSSC/qXI3DS6KoFEhp3eTXt3D6j3Q55sAZa2+FQZM+SG6RXxlMVvgSyR8AePSAtYH
         QK+ZxFJr9m6vxjv6+DBZ+EsOPDmfAMQu8Z8MKjYouT25wzdxcjPAadGL788UXFib64Ai
         DCVciVuqiHGUUvUtpoh1RGR/PJWrrYa0hG+nvF0Mu1WVI/lH9aPy+wijM92AdsN07urL
         Ks/E2H6X4ZDjsyaPBZ8H2rD/X/OgA/fNPjA+lDP/QsuVBTLJqWqi/gHJZdrZyrYcAa+m
         UcfSVzz2uCXrTGBnMiV/lCcHErUmDTBOijTY/yLIXlWcYzkvBg5uSVHe2oXkCn/jkdXO
         qKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ooAaH290DoNGIT/8IMExYM+TG0qPwbD9l7j4IH/0iwI=;
        b=fIyPvRLlQUjqGs+uvhmoOaGvsLlVj80xXJ6snXNTkYy62zZHht2SftrkgnpB6FbYxr
         jmJCXdYokfTDqUozZPCVTBwvHPCCh5G5nsujmTTYoGZ/G/F2JgDGY9MItk7ltWx4Br4u
         mYTmYnuzAbu/xcXpwjMk8drOm6IjoxY1FEnsPz7OkfxfjiL0bX1Q3vYUi8iWz/LtJEwh
         RyXUrejB+z0dxeIrFts4q2oJy3gldvxcUvqHfA2zW08i5vXtML2yPn0z1RT+lu7XBgN4
         o6PXYtT2ljZm36fniITp1P6aZsvtvp/pOR5NDOTJRqsJHFlb6TZQUqW/jYIiK7ubQMsI
         cFPA==
X-Gm-Message-State: APjAAAX+mVQsSNoX6JT5mhmYYEoG0zFenXBXP8MYDvNs+kdaG2xYElU/
        KkKUTetQQ4W52tYTeeo1Lq47Vk1bTZjk2Q==
X-Google-Smtp-Source: APXvYqxEHPlcY2hIqxT3Pkw62ASzXiQDLWYvoFmVLPsN4sPoaz9wCE9Z9o0hOQpCZ4o3w8mDCokJ9w==
X-Received: by 2002:a17:902:7045:: with SMTP id h5mr11954609plt.236.1571878158114;
        Wed, 23 Oct 2019 17:49:18 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b3sm24696440pfd.125.2019.10.23.17.49.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 17:49:17 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/6] ionic: add heartbeat check
Date:   Wed, 23 Oct 2019 17:48:57 -0700
Message-Id: <20191024004900.6561-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024004900.6561-1-snelson@pensando.io>
References: <20191024004900.6561-1-snelson@pensando.io>
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

