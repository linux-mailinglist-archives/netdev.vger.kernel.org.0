Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E1D57B953
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241235AbiGTPNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241188AbiGTPMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:12:48 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59FF56B97
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:42 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n12so13715946wrc.8
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qDmK8qr/Ni6czMNH3oQkAl0YR9A8UXiA+Eag63UlQPI=;
        b=DNNVLLI1pKU8AxskCyuOa7QwsyVRYwDQmeAcPwnl8ZEmIKPYIQdTQKswhLi5grPazY
         EXY00Wh3TC++J7GgK1ku6SDAzIY4jBJTxpI3P75W8UL/etPg4BBtV+dOWNSE7FkEWeEu
         7SHzu5vXtljOAQfmxUACpNUOAngihTEigMHAjSz4NZIgiFwxdQ5nhy/Lr4QqMgceLiw0
         6hZtk3Cx0WR4uNuEcQyhAbcFSf+1UA4KaP5VSFgjIM29xjNmMHHPGCbckwIHuLJiAloJ
         KCAQ7RE1kGmvDZXWAZnhHBC4qDSIIRUsDxZSi24ZbrMphKEqaUmNGoBHdmqSeGeZnFm0
         j7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qDmK8qr/Ni6czMNH3oQkAl0YR9A8UXiA+Eag63UlQPI=;
        b=KBBdvHsEE4IaFfckxGgYu5nvn9pBBZWxxrt3sl3nNlBaoZjfcpwPES4BHREszpeQMk
         2ABQFzq3pK2gr//hG4JxwH7GtiCUPaqkejyqG5GURNULvJdVntmeZYyN3lF/JC50IRMC
         M2Dl1Ad8xWh7+ODWqvHdBt+zl4/kb30wp3WQn5J/4cSLh5sUer+rm7AL892lRXtzbNn3
         0kFNSilzlZZxh/wj0IatkoapTh9z4yjvwmnsHXxE7c1gnCyabbQXMVY5qPzYsv2Q7HIc
         NhpD72KMb8AQZILE2lWB33bq9AGUQQeC9Ulr/PWoB/bs3t036EUI/GvOp01ozHvEfYNe
         iiqQ==
X-Gm-Message-State: AJIora9DNDSCRw5ykquV5TkYTiYOrj7EORbb+QszK/M0Mz7Qfdeyoxz3
        pTSFxFsaI8D3/pwddfb6RsnAGSjBGWJft8uUyPw=
X-Google-Smtp-Source: AGRyM1sM26nDUxXSQKXuuIVmBDiGJX6lMUD7H6PxA39cmwiEQUwPJtlVVy3Pn2YqHhpmfAR6JwyM8Q==
X-Received: by 2002:a5d:4607:0:b0:21d:93fb:aace with SMTP id t7-20020a5d4607000000b0021d93fbaacemr31052714wrq.704.1658329961310;
        Wed, 20 Jul 2022 08:12:41 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s7-20020a5d5107000000b0021e4c3b2967sm1504528wrt.65.2022.07.20.08.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:12:40 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v3 02/11] net: devlink: introduce nested devlink entity for line card
Date:   Wed, 20 Jul 2022 17:12:25 +0200
Message-Id: <20220720151234.3873008-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220720151234.3873008-1-jiri@resnulli.us>
References: <20220720151234.3873008-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

For the purpose of exposing device info and allow flash update which is
going to be implemented in follow-up patches, introduce a possibility
for a line card to expose relation to nested devlink entity. The nested
devlink entity represents the line card.

Example:

$ devlink lc show pci/0000:01:00.0 lc 1
pci/0000:01:00.0:
  lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
    supported_types:
       16x100G
$ devlink dev show auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v2->v3:
- added Ido's RWB tag
v1->v2:
- s/delink/devlink in devlink_linecard_nested_dl_set comment
- fixed alignment
- s/updated/update in patch description
- added Jakub's ack
- added "net: " prefix to patch subject
- rebased
---
 include/net/devlink.h        |  2 ++
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 42 ++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 780744b550b8..5bd3fac12e9e 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1580,6 +1580,8 @@ void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
 void devlink_linecard_activate(struct devlink_linecard *linecard);
 void devlink_linecard_deactivate(struct devlink_linecard *linecard);
+void devlink_linecard_nested_dl_set(struct devlink_linecard *linecard,
+				    struct devlink *nested_devlink);
 int devl_sb_register(struct devlink *devlink, unsigned int sb_index,
 		     u32 size, u16 ingress_pools_count,
 		     u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b3d40a5d72ff..541321695f52 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -576,6 +576,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
+	DEVLINK_ATTR_NESTED_DEVLINK,		/* nested */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6a3931a8e338..2833461fb703 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -89,6 +89,7 @@ struct devlink_linecard {
 	const char *type;
 	struct devlink_linecard_type *types;
 	unsigned int types_count;
+	struct devlink *nested_devlink;
 };
 
 /**
@@ -815,6 +816,24 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
 	return 0;
 }
 
+static int devlink_nl_put_nested_handle(struct sk_buff *msg, struct devlink *devlink)
+{
+	struct nlattr *nested_attr;
+
+	nested_attr = nla_nest_start(msg, DEVLINK_ATTR_NESTED_DEVLINK);
+	if (!nested_attr)
+		return -EMSGSIZE;
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, nested_attr);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, nested_attr);
+	return -EMSGSIZE;
+}
+
 struct devlink_reload_combination {
 	enum devlink_reload_action action;
 	enum devlink_reload_limit limit;
@@ -2127,6 +2146,10 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 		nla_nest_end(msg, attr);
 	}
 
+	if (linecard->nested_devlink &&
+	    devlink_nl_put_nested_handle(msg, linecard->nested_devlink))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -10390,6 +10413,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->nested_devlink);
 	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
 	linecard->type = NULL;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
@@ -10408,6 +10432,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->nested_devlink);
 	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING_FAILED;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 	mutex_unlock(&linecard->state_lock);
@@ -10455,6 +10480,23 @@ void devlink_linecard_deactivate(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
 
+/**
+ *	devlink_linecard_nested_dl_set - Attach/detach nested devlink
+ *					 instance to linecard.
+ *
+ *	@linecard: devlink linecard
+ *	@nested_devlink: devlink instance to attach or NULL to detach
+ */
+void devlink_linecard_nested_dl_set(struct devlink_linecard *linecard,
+				    struct devlink *nested_devlink)
+{
+	mutex_lock(&linecard->state_lock);
+	linecard->nested_devlink = nested_devlink;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->state_lock);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_nested_dl_set);
+
 int devl_sb_register(struct devlink *devlink, unsigned int sb_index,
 		     u32 size, u16 ingress_pools_count,
 		     u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.35.3

