Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14EA571CFD
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 16:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiGLOl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 10:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiGLOlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:41:22 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646EFBAABF
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:41:21 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v10-20020a05600c15ca00b003a2db8aa2c4so4939263wmf.2
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8uVD57S1SdiB8uSmTU3BT3oak0rYxr+EQzizPmHsZCg=;
        b=f4DYprUZRZ+3Gd/SwSMuUiDL4an28b0kDPUuUBcP29s2j4bBb9prUPCFgM3+th2Ffc
         FqZEhVMAzGRLQG874t6MXTfCEsL1upa8xEKnyMb2Qm7ed+smoMdNrGX9p9aXNU8CgBUl
         Y6DfjFcVmIWfLfUsI/Zdt3Hw18jYhbiQropFl6f46qKCLTsgU4Tz7F++nI+M8YHoVwIF
         GoBO0pqhbxaH0LxkO6dnThTVfMS8UxDkR9pQUO9V/KcDqVUrr+V92L21eeBvuKYtALHX
         Tz6RjUr3oa1xxeMEIRFn6JzG7HHW08+Ik/f9ct35TkaDhu80vvm9Ih9WmMuRgUU2jceE
         ghDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8uVD57S1SdiB8uSmTU3BT3oak0rYxr+EQzizPmHsZCg=;
        b=krrLIQfQcFdfV60ZvulUxdZBixNW8dtMomrxoGLoNUfKUN6AZK08/1t2PvB83rE/ax
         B6ffamPCySro9IltqlEGr7pSw4URG1uqeqP7xMSnNtoRFMeZFSar8WLd39g4qdownMM0
         m0rIWWvWetL7dqTY/6q5roaZEXlu7WNbvsbiOyN3IsfXiXnrizLXzpLItWNRVrnQWQpF
         AE9dO34GUAzI1lCyka0548iXRerwrjxx8VymnN8kXD4vhEUFzEmex8WwK1nAQ8+5s+yK
         MUWtecPoEekVWiBhcab5bwn94Lx72lTqEjx5L6raZAAZtMP0kzPPbwWNmca3UedXiKOA
         Kzpw==
X-Gm-Message-State: AJIora/+wF2bU3Ag5krb8lNypCS4ZpdOtzPecOGeIYOijqVfuPD47n19
        SL3EYegjPhKyr62KVRfgVDJ8ONejYXqE8mz3kFo=
X-Google-Smtp-Source: AGRyM1vFxWc166/rv7pAHpsmbwmGHzjOA2dcAq6H1kQL0psH2ijBaqhxUYzN52HR1scMQYVVefeTSQ==
X-Received: by 2002:a05:600c:4e47:b0:3a2:ed79:9160 with SMTP id e7-20020a05600c4e4700b003a2ed799160mr4266761wmq.1.1657636879954;
        Tue, 12 Jul 2022 07:41:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d15-20020a5d538f000000b0021b5861eaf7sm8623569wrv.3.2022.07.12.07.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:41:19 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFCv2 4/9] net: devlink: add unlocked variants of devlink_sb*() functions
Date:   Tue, 12 Jul 2022 16:41:07 +0200
Message-Id: <20220712144112.2905407-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712144112.2905407-1-jiri@resnulli.us>
References: <20220712144112.2905407-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add unlocked variants of devlink_sb*() functions to be used
in drivers called-in with devlink->lock held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  5 ++++
 net/core/devlink.c    | 54 ++++++++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index d341753753ce..0057809a13b0 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1579,10 +1579,15 @@ void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
 void devlink_linecard_activate(struct devlink_linecard *linecard);
 void devlink_linecard_deactivate(struct devlink_linecard *linecard);
+int devl_sb_register(struct devlink *devlink, unsigned int sb_index,
+		     u32 size, u16 ingress_pools_count,
+		     u16 egress_pools_count, u16 ingress_tc_count,
+		     u16 egress_tc_count);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
 			u16 egress_tc_count);
+void devl_sb_unregister(struct devlink *devlink, unsigned int sb_index);
 void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index);
 int devlink_dpipe_table_register(struct devlink *devlink,
 				 const char *table_name,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1688271ef7b2..64dab4024d11 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10375,25 +10375,21 @@ void devlink_linecard_deactivate(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
 
-int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
-			u32 size, u16 ingress_pools_count,
-			u16 egress_pools_count, u16 ingress_tc_count,
-			u16 egress_tc_count)
+int devl_sb_register(struct devlink *devlink, unsigned int sb_index,
+		     u32 size, u16 ingress_pools_count,
+		     u16 egress_pools_count, u16 ingress_tc_count,
+		     u16 egress_tc_count)
 {
 	struct devlink_sb *devlink_sb;
-	int err = 0;
 
-	devl_lock(devlink);
-	if (devlink_sb_index_exists(devlink, sb_index)) {
-		err = -EEXIST;
-		goto unlock;
-	}
+	lockdep_assert_held(&devlink->lock);
+
+	if (devlink_sb_index_exists(devlink, sb_index))
+		return -EEXIST;
 
 	devlink_sb = kzalloc(sizeof(*devlink_sb), GFP_KERNEL);
-	if (!devlink_sb) {
-		err = -ENOMEM;
-		goto unlock;
-	}
+	if (!devlink_sb)
+		return -ENOMEM;
 	devlink_sb->index = sb_index;
 	devlink_sb->size = size;
 	devlink_sb->ingress_pools_count = ingress_pools_count;
@@ -10401,23 +10397,45 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 	devlink_sb->ingress_tc_count = ingress_tc_count;
 	devlink_sb->egress_tc_count = egress_tc_count;
 	list_add_tail(&devlink_sb->list, &devlink->sb_list);
-unlock:
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devl_sb_register);
+
+int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
+			u32 size, u16 ingress_pools_count,
+			u16 egress_pools_count, u16 ingress_tc_count,
+			u16 egress_tc_count)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_sb_register(devlink, sb_index, size, ingress_pools_count,
+			       egress_pools_count, ingress_tc_count,
+			       egress_tc_count);
 	devl_unlock(devlink);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_sb_register);
 
-void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
+void devl_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 {
 	struct devlink_sb *devlink_sb;
 
-	devl_lock(devlink);
+	lockdep_assert_held(&devlink->lock);
+
 	devlink_sb = devlink_sb_get_by_index(devlink, sb_index);
 	WARN_ON(!devlink_sb);
 	list_del(&devlink_sb->list);
-	devl_unlock(devlink);
 	kfree(devlink_sb);
 }
+EXPORT_SYMBOL_GPL(devl_sb_unregister);
+
+void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
+{
+	devl_lock(devlink);
+	devl_sb_unregister(devlink, sb_index);
+	devl_unlock(devlink);
+}
 EXPORT_SYMBOL_GPL(devlink_sb_unregister);
 
 /**
-- 
2.35.3

