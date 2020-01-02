Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B641712E850
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 16:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgABPvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 10:51:14 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43069 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbgABPvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 10:51:13 -0500
Received: by mail-pl1-f195.google.com with SMTP id p27so17946861pli.10
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 07:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MhQG0/5JezNv1KtQT1rgY66YIDnDZ+v70hNo6D0LoXg=;
        b=RhVR6tn88iqM9CAUBuIXpC8u7enUg5KhZQzj0GVrdn/23ih1Mi5aXE//i/LbuUb6JS
         XJv5C66APOE7/VFJ7f6chnXcg3hU+P9y05EGl3LG8UGI2uYd1JJTo18ArBgTNMTqNXv7
         pn/7QuBC8goVmWplj8gh1M37fOG+1fdQY+iVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MhQG0/5JezNv1KtQT1rgY66YIDnDZ+v70hNo6D0LoXg=;
        b=OBPs84fimv/ZLFxUb8/axHkp6QQYPCiWcsHt2soPldTnrzEWOCLd1dBfe8IUUP3EMv
         tbU14VSbfJJ/xGZLzStT1HS9VyPGhJnoRjBTaIpgisFpRQrOEdqT3ZemiZtsaEzuwtPL
         WVeEvxgh5GklexMGR3zcmqtUjY4Z2TC7Gej1ATJ56kk4rcvCLfJm5QvqjcKwwsLkAupH
         38HpBzsk4XMQFUz36ZZEs9TLtlBKnJsDH2edZ9Oqta6y7byWUWiKjh0X6XFb+s2vZ4LL
         ZG7BIP9InFS39mRUt6WyTXuJgMofvbxD4GC4E2AWCVMqsiEhyl0Ru5QFuT8JgbEe0CEr
         22DA==
X-Gm-Message-State: APjAAAUFQxvzR5ytLXufVp09cRlfCThjjpNgUJKJ2fg9ECfPwrMMM2Vn
        hFUyh02a02/34gPTxWcUi2XsRg==
X-Google-Smtp-Source: APXvYqxmTFehZbAfKFT1nOlnLy/69betFFYIHUPY6KrYNNfHnEW3rMAgBVj9YfpNL5BAF1lBPsgaMw==
X-Received: by 2002:a17:90b:3004:: with SMTP id hg4mr20589047pjb.52.1577980273180;
        Thu, 02 Jan 2020 07:51:13 -0800 (PST)
Received: from Ninja.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2sm11499420pjv.18.2020.01.02.07.51.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 02 Jan 2020 07:51:12 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vasundhara-v.volam@broadcom.com, vikram.prakash@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH v1 2/3] devlink: add devink notification when reporter update health state
Date:   Thu,  2 Jan 2020 21:18:10 +0530
Message-Id: <1577980091-25118-3-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1577980091-25118-1-git-send-email-vikas.gupta@broadcom.com>
References: <1577980091-25118-1-git-send-email-vikas.gupta@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add a devlink notification when reporter update the health
state.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 net/core/devlink.c | 59 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e686ae6..d30aa47 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4844,23 +4844,6 @@ devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 
 void
-devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
-				     enum devlink_health_reporter_state state)
-{
-	if (WARN_ON(state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY &&
-		    state != DEVLINK_HEALTH_REPORTER_STATE_ERROR))
-		return;
-
-	if (reporter->health_state == state)
-		return;
-
-	reporter->health_state = state;
-	trace_devlink_health_reporter_state_update(reporter->devlink,
-						   reporter->ops->name, state);
-}
-EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
-
-void
 devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter)
 {
 	reporter->recovery_count++;
@@ -5097,6 +5080,48 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static void devlink_recover_notify(struct devlink_health_reporter *reporter,
+				   enum devlink_command cmd)
+{
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_health_reporter_fill(msg, reporter->devlink,
+					      reporter, cmd, 0, 0, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family,
+				devlink_net(reporter->devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+void
+devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
+				     enum devlink_health_reporter_state state)
+{
+	if (WARN_ON(state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY &&
+		    state != DEVLINK_HEALTH_REPORTER_STATE_ERROR))
+		return;
+
+	if (reporter->health_state == state)
+		return;
+
+	reporter->health_state = state;
+	trace_devlink_health_reporter_state_update(reporter->devlink,
+						   reporter->ops->name, state);
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+}
+EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
+
 static int devlink_nl_cmd_health_reporter_get_doit(struct sk_buff *skb,
 						   struct genl_info *info)
 {
-- 
2.7.4

