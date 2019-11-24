Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58738108198
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfKXDbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:37 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33515 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfKXDbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:36 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so838238pgk.0
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nXjFmpo55xeV43Ih0pLTHAKh7PqBMhqMwCXB1inqVRI=;
        b=b75J0faEJo9RaFQGtOzsX55iv1ZdPrxtw2x+uffuw2Ynfu6YIsV8yy1M6CorHd4Jof
         VV3ZUFna6S5zONNiyAo1acy4phAhLvHbd4G5YRL6YtTRbFZkneKzi10oaV+iBvyHiCr/
         xsz2mceb3fYRZPvHKM71frOs9T+lsQe+IUXnU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nXjFmpo55xeV43Ih0pLTHAKh7PqBMhqMwCXB1inqVRI=;
        b=AsrDWRcgag23EE8uTu7TdMfrLeG/GlRcrOcM4tNoHSIO02H6mO9iAmWxOjmyTSM6qF
         8LRQDHDXGLJdTw6/amDQJHsGUkyTv1/c8IYfe5vJLoZ1GhcIz6Z31lVZY82qbOLMXM+M
         QocwpbfIcxooYqqpODAEsPUFdijhtb9UeGw+byPgPwzRXKo3ZY91Zv7NTGqLxr52xXBw
         laqpgajdnIYxbCa7eHaiHaUk0Gub6oNQTMwhYO/yoDw4uWY4p/+H7DtiewRw+xCw1zzq
         Ud7JZMfh5x+iQPlh79J/sAG1cDczJR8yaA+ECLhC7qJmjbKl7uHGS7BKzmOOTJ//pxCt
         cKmw==
X-Gm-Message-State: APjAAAWmFGkKe6GDDbnet+DlRsGsOXcXYfUJZVCXyvl5Hz20MDPk3TEu
        9mGbwZNCEiVBCneTFybJ0tAZmQ==
X-Google-Smtp-Source: APXvYqwSDtVm0EoWvoFbekrdpNqOjIeaSHRvSd8+5ugDmFiZNRO3cMDsvPXvBw3ZRrDAAKJtOqHm+Q==
X-Received: by 2002:a63:c013:: with SMTP id h19mr25200013pgg.447.1574566295336;
        Sat, 23 Nov 2019 19:31:35 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:34 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 11/13] bnxt_en: Add async. event logic for PHY configuration changes.
Date:   Sat, 23 Nov 2019 22:30:48 -0500
Message-Id: <1574566250-7546-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the link settings have been changed by another function sharing the
port, firmware will send us an async. message.  In response, we will
call the new bnxt_init_ethtool_link_settings() function to update
the current settings.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 ++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 1b86ba8..4b0303a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -250,10 +250,12 @@ static const u16 bnxt_vf_req_snif[] = {
 
 static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_LINK_STATUS_CHANGE,
+	ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_PF_DRVR_UNLOAD,
 	ASYNC_EVENT_CMPL_EVENT_ID_PORT_CONN_NOT_ALLOWED,
 	ASYNC_EVENT_CMPL_EVENT_ID_VF_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CFG_CHANGE,
+	ASYNC_EVENT_CMPL_EVENT_ID_PORT_PHY_CFG_CHANGE,
 	ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY,
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_RECOVERY,
 };
@@ -1968,6 +1970,10 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		set_bit(BNXT_LINK_SPEED_CHNG_SP_EVENT, &bp->sp_event);
 	}
 	/* fall through */
+	case ASYNC_EVENT_CMPL_EVENT_ID_LINK_SPEED_CHANGE:
+	case ASYNC_EVENT_CMPL_EVENT_ID_PORT_PHY_CFG_CHANGE:
+		set_bit(BNXT_LINK_CFG_CHANGE_SP_EVENT, &bp->sp_event);
+		/* fall through */
 	case ASYNC_EVENT_CMPL_EVENT_ID_LINK_STATUS_CHANGE:
 		set_bit(BNXT_LINK_CHNG_SP_EVENT, &bp->sp_event);
 		break;
@@ -10324,6 +10330,10 @@ static void bnxt_sp_task(struct work_struct *work)
 				       &bp->sp_event))
 			bnxt_hwrm_phy_qcaps(bp);
 
+		if (test_and_clear_bit(BNXT_LINK_CFG_CHANGE_SP_EVENT,
+				       &bp->sp_event))
+			bnxt_init_ethtool_link_settings(bp);
+
 		rc = bnxt_update_link(bp, true);
 		mutex_unlock(&bp->link_lock);
 		if (rc)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 94c8a92..cab1703 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1763,6 +1763,7 @@ struct bnxt {
 #define BNXT_RING_COAL_NOW_SP_EVENT	17
 #define BNXT_FW_RESET_NOTIFY_SP_EVENT	18
 #define BNXT_FW_EXCEPTION_SP_EVENT	19
+#define BNXT_LINK_CFG_CHANGE_SP_EVENT	21
 
 	struct delayed_work	fw_reset_task;
 	int			fw_reset_state;
-- 
2.5.1

