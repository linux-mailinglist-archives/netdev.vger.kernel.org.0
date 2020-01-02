Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D3312E84D
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 16:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgABPvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 10:51:08 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43063 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbgABPvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 10:51:08 -0500
Received: by mail-pl1-f193.google.com with SMTP id p27so17946766pli.10
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 07:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zk5pAX30ofxWfNNLyrrb4XcjsQ00qe4OtGVhevNDX/E=;
        b=DHJDIK1KslrO4hnu6CEBxQoOTxXnyL/CgkBlPC7rJGAAswZl1QvLI3CnpB71Nb6dm8
         9q6ltgO+IrzJa74sVOfC/o5TkBvTQ51nP1qLmEKgdXFrijdeGeLemvtNHsbgipOThh6j
         BbpezO1Iluda6aQd3N5be/jmXYXXXXCCgMJY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zk5pAX30ofxWfNNLyrrb4XcjsQ00qe4OtGVhevNDX/E=;
        b=U9f4Cwt2JFl8QeQaFuCUq9CCxh93wM53dD3/CMB+iFd3uUh894Ubc8Mb1indmn5MZi
         vGCwQlzCeEhNR5t/dAsOQIiMCGGXP5lpy7c6mK6ntj60DipMJeBih7jR3BfhXdpoG0I3
         2KHTT4nzCr7/pvZTqCeIeLLPW0BKimwqTE3qr5rJzHlle7eUKh079vGZoEIPdA0JohA3
         g4dPCoCbqIj0fGfrSxSLfds2Zrd6LMLlj72G18mmow3qd4+7Q8JLxZ4bQ9dH2mScKCrY
         rjVr8XTnfyw16kuvE/9FnNSHylBXHM9s4gUPQ/hxTiVudn+Yqyohi9xzZWIku8rVwSnY
         hGkQ==
X-Gm-Message-State: APjAAAXxb3vphkx/zvh5lLGkiZLgr7iKGuHXP5Oa7KL/FcumJKVQs2pV
        O/a2PKEnwYGvkKeds8YfHZLW1g==
X-Google-Smtp-Source: APXvYqwCoHqlD2X9MCsFOU1yTWwyi/iGusL0JDSer/QcRKVGveW9amxm1aLR+oJVmIdJDTy6dlp8/w==
X-Received: by 2002:a17:902:82cc:: with SMTP id u12mr80414885plz.342.1577980267271;
        Thu, 02 Jan 2020 07:51:07 -0800 (PST)
Received: from Ninja.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2sm11499420pjv.18.2020.01.02.07.51.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 02 Jan 2020 07:51:06 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vasundhara-v.volam@broadcom.com, vikram.prakash@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH v1 1/3] devlink: add support for reporter recovery completion
Date:   Thu,  2 Jan 2020 21:18:09 +0530
Message-Id: <1577980091-25118-2-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1577980091-25118-1-git-send-email-vikas.gupta@broadcom.com>
References: <1577980091-25118-1-git-send-email-vikas.gupta@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that a reporter recovery completion do not finish
successfully when recovery is triggered via
devlink_health_reporter_recover as recovery could be processed in
different context. In such scenario an error is returned by driver when
recover hook is invoked and successful recovery completion is
intimated later.
Expose devlink recover done API to update recovery stats.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 47f87b2..453f45c 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1000,6 +1000,8 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 void
 devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 				     enum devlink_health_reporter_state state);
+void
+devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
 
 bool devlink_is_reload_failed(const struct devlink *devlink);
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 4c63c9a..e686ae6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4860,6 +4860,14 @@ devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
 
+void
+devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter)
+{
+	reporter->recovery_count++;
+	reporter->last_recovery_ts = jiffies;
+}
+EXPORT_SYMBOL_GPL(devlink_health_reporter_recovery_done);
+
 static int
 devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 				void *priv_ctx, struct netlink_ext_ack *extack)
@@ -4876,9 +4884,8 @@ devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 	if (err)
 		return err;
 
-	reporter->recovery_count++;
+	devlink_health_reporter_recovery_done(reporter);
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
-	reporter->last_recovery_ts = jiffies;
 
 	return 0;
 }
-- 
2.7.4

