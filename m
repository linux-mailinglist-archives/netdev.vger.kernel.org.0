Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD5212E852
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 16:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgABPvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 10:51:21 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46209 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728808AbgABPvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 10:51:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so17937534pll.13
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 07:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l8GiNbTzB0gxgqSfCeGUqR2N+xB9TfANszBuH6xbhVk=;
        b=V9mfQO+lvFeoyC1d29u4/iGjL9H5Kx7299Phh07rMp8378POUNc83NRtQwgB6UuNE4
         wtTjq8Hj7hmFN0IAZhc0+Q6SA1+BGLFrNK/ItlzwXNL+LTB4iFpQ4ntD8lbhXlaz1Y+T
         AvUAqBz/N/bI0m2byK+NEugJ5lI+wCFqTmQjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l8GiNbTzB0gxgqSfCeGUqR2N+xB9TfANszBuH6xbhVk=;
        b=W2vexYsMy78rDUaYucJV2ydrngfpv9RFvlHfteLqmb59NlNCZkTD/qnIi6CIqjHBjs
         5s0mk6u2vkJ1ILfrgENKPtyFi9VkwIAXLowfOOI7+Z8AneZrQvtrmcySFlps0h/wd3Jv
         ZmioJZsGg+0Oi5HNVrJ080EWGbUeAs6aeKcoz1vj96K990jrrFm1uElSPrQdAwOb+IUd
         y+sFux49GlJJO8DY8RgqNON/MAr3VGFnDRo6BuzO1VkJbwl+jCgfvuRPfEqUtyJWJ0wc
         58SJLtNNm3FGamYNEJ+cDtBCNKs/WKWrxbFsQ5XFwoIH9Xe/wk6N6ZXDHNC2ccFIE9Ud
         +4NA==
X-Gm-Message-State: APjAAAWDNECsxErudyDZr83MoNbCdtJM9KRVcNaf74h5nwgOQtvi/vKJ
        HTqlrT0SSGdK+dk4gLwoN9Lqkg==
X-Google-Smtp-Source: APXvYqw1oN4gWnsrwdlNQQB/kqEr/Ia2EGgZDAwGDeuYjFRcd01TGnYijs/cVowvM9nEGABw5DYJlw==
X-Received: by 2002:a17:902:b10d:: with SMTP id q13mr77923301plr.14.1577980280225;
        Thu, 02 Jan 2020 07:51:20 -0800 (PST)
Received: from Ninja.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2sm11499420pjv.18.2020.01.02.07.51.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 02 Jan 2020 07:51:19 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vasundhara-v.volam@broadcom.com, vikram.prakash@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH v1 3/3] bnxt_en: Call recovery done after reset is successfully done
Date:   Thu,  2 Jan 2020 21:18:11 +0530
Message-Id: <1577980091-25118-4-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1577980091-25118-1-git-send-email-vikas.gupta@broadcom.com>
References: <1577980091-25118-1-git-send-email-vikas.gupta@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return EINPROGRESS to devlink health reporter recover as we are not yet
done and call devlink_health_reporter_recovery_done once reset is
successfully completed from workqueue context.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 14 ++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h |  1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7b0fe19..39d4309 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10822,6 +10822,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		smp_mb__before_atomic();
 		clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 		bnxt_ulp_start(bp, rc);
+		bnxt_dl_health_recovery_done(bp);
 		bnxt_dl_health_status_update(bp, true);
 		rtnl_unlock();
 		break;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 3eedd44..0c3d224 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -89,7 +89,7 @@ static int bnxt_fw_reset_recover(struct devlink_health_reporter *reporter,
 		return -EOPNOTSUPP;
 
 	bnxt_fw_reset(bp);
-	return 0;
+	return -EINPROGRESS;
 }
 
 static const
@@ -116,7 +116,7 @@ static int bnxt_fw_fatal_recover(struct devlink_health_reporter *reporter,
 	else if (event == BNXT_FW_EXCEPTION_SP_EVENT)
 		bnxt_fw_exception(bp);
 
-	return 0;
+	return -EINPROGRESS;
 }
 
 static const
@@ -262,6 +262,16 @@ void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy)
 	health->fatal = false;
 }
 
+void bnxt_dl_health_recovery_done(struct bnxt *bp)
+{
+	struct bnxt_fw_health *hlth = bp->fw_health;
+
+	if (hlth->fatal)
+		devlink_health_reporter_recovery_done(hlth->fw_fatal_reporter);
+	else
+		devlink_health_reporter_recovery_done(hlth->fw_reset_reporter);
+}
+
 static const struct devlink_ops bnxt_dl_ops = {
 #ifdef CONFIG_BNXT_SRIOV
 	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 6db6c3d..08aaa44 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -58,6 +58,7 @@ struct bnxt_dl_nvm_param {
 
 void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event);
 void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy);
+void bnxt_dl_health_recovery_done(struct bnxt *bp);
 void bnxt_dl_fw_reporters_create(struct bnxt *bp);
 void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all);
 int bnxt_dl_register(struct bnxt *bp);
-- 
2.7.4

