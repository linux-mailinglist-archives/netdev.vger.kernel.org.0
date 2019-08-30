Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F74CA2DB8
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfH3D4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:56:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43621 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfH3Dzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:46 -0400
Received: by mail-pg1-f193.google.com with SMTP id k3so2785380pgb.10
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I7jSxi2SGQVyvDHooUdq5wCBA8Dn6WC1tBwzv9bj6yA=;
        b=GUqsLpI7+uNYbyAmYwOuMsS877EdniEfJ5BwIJlt3W9gozTh4qO18/BvixOXz40UqT
         SAtmTSnset4brBIuOvYQrpG5ZH1N6Bug067FmpZ/Cp4fEA1RxnvBLfH6AAQKNzb/S8o5
         k1+SDELHg3wHBNsIsKbUgbnyJSeYL4wHMenWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I7jSxi2SGQVyvDHooUdq5wCBA8Dn6WC1tBwzv9bj6yA=;
        b=nkiBYbJqDlplf67SlB3QNIgTL+iE2xCTM8ongR/9qZv7OGBVEbCIaiE73qrp/djO1v
         ajDVBwM+ld0U4B8RUz/H+bIoiuyAJflC/zYDPv9nUKL9HBxLg9bkUm7oTvw5BOeGnhkn
         trtLeA+rOB3zKiBFT0DENO5WY3uMQgjAuE5Brzxh6iu7d4Oo8pVrVYc8Z0EKT6v5y0h4
         StfCGaHidoHE8xqrb20OOjvUISS6UgKE6qbxNh7YvX0qQ/nMQs/IOi9w8M+IDPJhL44y
         gIJNtetXgh0G0mIeL9ti85Y8GGNc1Vqc5MRXOVEen1JiQuQGaQBHnEdFD/zNEyEYm7At
         wXDQ==
X-Gm-Message-State: APjAAAX08CuP80fTpkhMLZMnPoA0KFafgec5Wiz9BUFKC+JdTKoPSr/l
        U+6laSUbPeN7VXyejQXsUBi0M26pYpM=
X-Google-Smtp-Source: APXvYqxvy9/f/X13bnFP4Qu4uoDJ6O3rksbZaw3UIOcnLM1R/VU9LheeumUyGTop8ETr/QCmAqWCgw==
X-Received: by 2002:aa7:8611:: with SMTP id p17mr15794679pfn.41.1567137346359;
        Thu, 29 Aug 2019 20:55:46 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:45 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 15/22] bnxt_en: Handle RESET_NOTIFY async event from firmware.
Date:   Thu, 29 Aug 2019 23:54:58 -0400
Message-Id: <1567137305-5853-16-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This event from firmware signals a coordinated reset initiated by the
firmware.  It may be triggered by some error conditions encountered
in the firmware or other orderly reset conditions.

We store the parameters from this event.  Subsequent patches will
add logic to handle reset itself using devlink reporters.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 11 +++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4caacab..d1d33f6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -254,6 +254,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_PORT_CONN_NOT_ALLOWED,
 	ASYNC_EVENT_CMPL_EVENT_ID_VF_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CFG_CHANGE,
+	ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY,
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
 };
 
@@ -1979,6 +1980,16 @@ static int bnxt_async_event_process(struct bnxt *bp,
 			goto async_event_process_exit;
 		set_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event);
 		break;
+	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY:
+		bp->fw_reset_timestamp = jiffies;
+		bp->fw_reset_min_dsecs = cmpl->timestamp_lo;
+		if (!bp->fw_reset_min_dsecs)
+			bp->fw_reset_min_dsecs = BNXT_DFLT_FW_RST_MIN_DSECS;
+		bp->fw_reset_max_dsecs = le16_to_cpu(cmpl->timestamp_hi);
+		if (!bp->fw_reset_max_dsecs)
+			bp->fw_reset_max_dsecs = BNXT_DFLT_FW_RST_MAX_DSECS;
+		set_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event);
+		break;
 	case ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY: {
 		struct bnxt_fw_health *fw_health = bp->fw_health;
 		u32 data1 = le32_to_cpu(cmpl->event_data1);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a75fe16..858dc40 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1719,6 +1719,13 @@ struct bnxt {
 #define BNXT_FLOW_STATS_SP_EVENT	15
 #define BNXT_UPDATE_PHY_SP_EVENT	16
 #define BNXT_RING_COAL_NOW_SP_EVENT	17
+#define BNXT_FW_RESET_NOTIFY_SP_EVENT	18
+
+	u16			fw_reset_min_dsecs;
+#define BNXT_DFLT_FW_RST_MIN_DSECS	20
+	u16			fw_reset_max_dsecs;
+#define BNXT_DFLT_FW_RST_MAX_DSECS	60
+	unsigned long		fw_reset_timestamp;
 
 	struct bnxt_fw_health	*fw_health;
 
-- 
2.5.1

