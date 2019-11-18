Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FB91000D4
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKRI5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:57:12 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37594 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfKRI5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 03:57:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id b10so796640pgd.4
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 00:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/qBFnpDc+zFKWb7kGdwlYvQssem/I+/uU7m9SYFnn1A=;
        b=QmUn7e5J4xTOgU34tcnTglxsljmJhCFAj3FeztiHVcwkXnNM98NLnrbUiQquh6iAOk
         UHcTc89k5dFAiKtK7miGcl2C/51gfxwgn/975J2JPvnJVVxOFwLr0kPYT5UVNVMe0z5o
         KZzSVXChmgmom0cq3bmkf3GtCwbZmIwrU8hcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/qBFnpDc+zFKWb7kGdwlYvQssem/I+/uU7m9SYFnn1A=;
        b=nWinwOt7komutY+wY+ttIzD9iucu6tSg1TLEqja9bNjzKBHjj8iROr5gBr52UHe7Dw
         iTUB+XTaftGqeAUyREPx6/INC48bDXELGydELzX4MTEHTtO9vT7WMoH5DKH72MR8Qr5X
         WS6kFu9CyIYwQ4K7JYZ4kC6GecuqCnyOaDt+pDPFfVXW6kgywcnsjZ5C11XuA/T612NW
         IifIyh6YB9LCWjuyOzVNwDp+/u3TRxWpsPITf0/a+j6KSKccR2nijFWqlnkaFdEvWMOD
         LXav0AN6dMktxuWKKbtLUgZw3bQdZZuZuhqi79/Ja+om5LMYHiQBq5nNT/7qxUVI0GFG
         koDQ==
X-Gm-Message-State: APjAAAUR0CgRXrVlqg+m90uv6jA0a15Qfxh2fOfxPjTZLQSGRGUgMwat
        9bQPhTlG37gjj8RRbqND4scbbA==
X-Google-Smtp-Source: APXvYqy+UGQR5xXspOy6qrD8yzG+amGPiQ95Yk69sU4iIDVOfgIMOTAfZhqRca7xMW95XgfUwzCHBA==
X-Received: by 2002:aa7:961d:: with SMTP id q29mr5996682pfg.89.1574067429681;
        Mon, 18 Nov 2019 00:57:09 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q41sm19120230pja.20.2019.11.18.00.57.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 00:57:09 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 6/9] bnxt_en: Report health status update after reset is done
Date:   Mon, 18 Nov 2019 03:56:40 -0500
Message-Id: <1574067403-4344-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Report health status update to devlink health reporter, once
reset is completed.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 21 +++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  1 +
 4 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 178490c..a168324 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10750,6 +10750,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		smp_mb__before_atomic();
 		clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 		bnxt_ulp_start(bp, rc);
+		bnxt_dl_health_status_update(bp, true);
 		rtnl_unlock();
 		break;
 	}
@@ -10757,6 +10758,8 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 
 fw_reset_abort:
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	if (bp->fw_reset_state != BNXT_FW_RESET_STATE_POLL_VF)
+		bnxt_dl_health_status_update(bp, false);
 	bp->fw_reset_state = 0;
 	rtnl_lock();
 	dev_close(bp->dev);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 271085f..37549ca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1384,6 +1384,7 @@ struct bnxt_fw_health {
 	u32 last_fw_reset_cnt;
 	u8 enabled:1;
 	u8 master:1;
+	u8 fatal:1;
 	u8 tmr_multiplier;
 	u8 tmr_counter;
 	u8 fw_reset_seq_cnt;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index ae4ddf3..d85e439 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -91,6 +91,7 @@ static int bnxt_fw_fatal_recover(struct devlink_health_reporter *reporter,
 	if (!priv_ctx)
 		return -EOPNOTSUPP;
 
+	bp->fw_health->fatal = true;
 	event = fw_reporter_ctx->sp_event;
 	if (event == BNXT_FW_RESET_NOTIFY_SP_EVENT)
 		bnxt_fw_reset(bp);
@@ -199,6 +200,26 @@ void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
 	}
 }
 
+void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy)
+{
+	struct bnxt_fw_health *health = bp->fw_health;
+	u8 state;
+
+	if (healthy)
+		state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
+	else
+		state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
+
+	if (health->fatal)
+		devlink_health_reporter_state_update(health->fw_fatal_reporter,
+						     state);
+	else
+		devlink_health_reporter_state_update(health->fw_reset_reporter,
+						     state);
+
+	health->fatal = false;
+}
+
 static const struct devlink_ops bnxt_dl_ops = {
 #ifdef CONFIG_BNXT_SRIOV
 	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 2f4fd0a..665d4bd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -57,6 +57,7 @@ struct bnxt_dl_nvm_param {
 };
 
 void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event);
+void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy);
 int bnxt_dl_register(struct bnxt *bp);
 void bnxt_dl_unregister(struct bnxt *bp);
 
-- 
2.5.1

