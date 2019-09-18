Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413BBB6B00
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 20:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388873AbfIRSwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 14:52:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36733 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387645AbfIRSwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 14:52:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so595309pfr.3
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 11:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Okiu/elfIgaQjLf/NcyUs2b0iC336LxObVGspA2lzqA=;
        b=edyaNwt+eE1B1lgdsf/YGnTJT7plTJ12j36UTrWUO/FNne2Cz4e3Jsmk0R1p+1RuKI
         wxis/VxbSyAsbRssjpJ8QEihlf90LcB+Eol37VpQzbP4CzHi7fjm0o4HFYGnT/NS3sth
         M5x4sS9d9PtxDr7DSNWf6FftE21sx5C2KZ3I0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Okiu/elfIgaQjLf/NcyUs2b0iC336LxObVGspA2lzqA=;
        b=QLTE2nI/FKTDR4UWLyYuNMRu9L5dCf2np09LgxCiS5Xw2OE4YD57SExwrvXxlZo8WS
         3uc7wSchPLb7J1qGBl7gKZGFzK8mmk80dYStxsG+gLlbN5bmfvSjpIkD8xiJlc0AEMhw
         11gugaiXN6aR3WqtHt8cml9GH90Z/g09HaMDe1cHf9XCBkb/vW8+78Lt/aQF7q5Jw/ml
         /WIXmr51YjyYFz56BgVFAiuL13x2Vg6Hhk3iTLAC0IocVBuMtx7jL/p5NNl23LavDRqr
         em7VwRNheqMVRZsG0VjphLDEC2nedAKfk/YDJBfS3mjohj1cIRCBYjdviLk6Y6a5h/WG
         COfQ==
X-Gm-Message-State: APjAAAXw1Az1OxgIE5bAW6+qyoFc3A40N0jEwzdhQdD+rveO/iKkzSNH
        KsnU2vYRL2gdTO+lT8P7f9pOBQ==
X-Google-Smtp-Source: APXvYqzEryEbvffH4fIUESAvKGyMWpAjiAWue/Z8tPbRhL3fkmz6diIJu/4RxieSqZDIvsTOUIGGJQ==
X-Received: by 2002:aa7:9835:: with SMTP id q21mr5970232pfl.122.1568832742624;
        Wed, 18 Sep 2019 11:52:22 -0700 (PDT)
Received: from shitalt.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o42sm3745010pjo.32.2019.09.18.11.52.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Sep 2019 11:52:22 -0700 (PDT)
From:   Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
To:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Subject: [PATCH] devlink: add devlink notification for recovery
Date:   Thu, 19 Sep 2019 00:22:21 +0530
Message-Id: <1568832741-20850-1-git-send-email-sheetal.tigadoli@broadcom.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vikas Gupta <vikas.gupta@broadcom.com>

Add a devlink notification for reporter recovery

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
---
 net/core/devlink.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e48680e..42909fb 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4730,6 +4730,28 @@ struct devlink_health_reporter *
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_state_update);
 
+static void __devlink_recover_notify(struct devlink *devlink,
+				     enum devlink_command cmd)
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
+	err = devlink_nl_fill(msg, devlink, cmd, 0, 0, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
 static int
 devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 				void *priv_ctx)
@@ -4747,6 +4769,9 @@ struct devlink_health_reporter *
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
 	reporter->last_recovery_ts = jiffies;
 
+	__devlink_recover_notify(reporter->devlink,
+				 DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+
 	return 0;
 }
 
-- 
1.9.1

