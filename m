Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4980154B155
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241411AbiFNMhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354713AbiFNMfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:35:46 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0513C4A92F
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:31 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bg6so16990318ejb.0
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7UMDASQP02QPPbJAwdsXnOc7Iwo1LwoEgEahkA3vrq8=;
        b=RS7kvw8AilUO+qDzi4ijc+OvTLlY894FruALCC3155Q77uPcKuVVHYg1D8IyZFSeUY
         eSDTJNtZW9t0etBEGDkybC4Hddy/ShCKY4hCLF4QgNA/89Qm8hDW3hBzeDN4mt+7l1u0
         MvXBMsTaEcYNsVC1Ju2/2yULow/8Y76tMzUhq6qiAuDyJKv84kIrNnYo6kKd029F2LzU
         SNYnCztcfSaTyuqlH8nUfXmRAkQ1PRro5Chr2yc4YATsIxV5H4SIm1DVM/0sI5ulEj3Y
         gRWNek40HJRjAJFExqFAaiuyqUxfNty8CXumlubpxndaBxa+CL6LLJNSTJoOFx9YsWpG
         ZJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7UMDASQP02QPPbJAwdsXnOc7Iwo1LwoEgEahkA3vrq8=;
        b=XKYr1UPDjoJ3EhGpi5z3sUzO4k0U6fB7AYz7claUEBparWsDsljeVMCI5K/uGgngkY
         xtx6/ZdhYdYWWEjVSqG3byi0CkgcbTj8eCg3nkNVxR9CNrdBznupSzD57zSD3913j9J1
         hvUoPL08vUeWcXbI4Pwoeoz82Bn76Nuv0JWkqK4ssuy5OiPWYXS4R1I0wf3r9XKHNcm0
         W8rige4s2za4pNMepozrgHogdm8xDTXb/3dXsm0I+jrIJlYxSHY4L4q6InihbYABn2Ow
         EVhn3BESEUEsmAcrp0Rywnss5SKdcSkIra+2IqfqDX0SqbZrtzjnjsoiXdJqH7ZvsLBf
         Skzw==
X-Gm-Message-State: AOAM531HjtqXC6qwlYo4nKBECNwqhZqB6KRjtjH70KT64eyMbwsqJ6b6
        DqmrWUPX5gTnsb9D6hNweSFmlfHNawQ3+wzqp+I=
X-Google-Smtp-Source: ABdhPJwf3QQNBJo9uPQcSgNTCVlaqjm/Ss+8l62nuwzEm5nwJr2WKpqleLdUqtD7Wcg3eMRFKdur7g==
X-Received: by 2002:a17:906:2b92:b0:709:236c:de1b with SMTP id m18-20020a1709062b9200b00709236cde1bmr4236377ejg.754.1655210009583;
        Tue, 14 Jun 2022 05:33:29 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id w18-20020a05640234d200b0042e09f44f81sm7147922edc.38.2022.06.14.05.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:29 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 01/11] devlink: introduce nested devlink entity for line card
Date:   Tue, 14 Jun 2022 14:33:16 +0200
Message-Id: <20220614123326.69745-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614123326.69745-1-jiri@resnulli.us>
References: <20220614123326.69745-1-jiri@resnulli.us>
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

For the purpose of exposing device info and allow flash updated which is
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
---
 include/net/devlink.h        |  2 ++
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 42 ++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 2a2a2a0c93f7..83e62943e1d4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1584,6 +1584,8 @@ void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
 void devlink_linecard_activate(struct devlink_linecard *linecard);
 void devlink_linecard_deactivate(struct devlink_linecard *linecard);
+void devlink_linecard_nested_dl_set(struct devlink_linecard *linecard,
+				    struct devlink *nested_devlink);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
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
index db61f3a341cb..a5953cfe1baa 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -87,6 +87,7 @@ struct devlink_linecard {
 	const char *type;
 	struct devlink_linecard_type *types;
 	unsigned int types_count;
+	struct devlink *nested_devlink;
 };
 
 /**
@@ -796,6 +797,24 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
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
@@ -2100,6 +2119,10 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 		nla_nest_end(msg, attr);
 	}
 
+	if (linecard->nested_devlink &&
+	    devlink_nl_put_nested_handle(msg, linecard->nested_devlink))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -10335,6 +10358,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->nested_devlink);
 	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
 	linecard->type = NULL;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
@@ -10353,6 +10377,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->nested_devlink);
 	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING_FAILED;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 	mutex_unlock(&linecard->state_lock);
@@ -10400,6 +10425,23 @@ void devlink_linecard_deactivate(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
 
+/**
+ *	devlink_linecard_nested_dl_set - Attach/detach nested delink
+ *					 instance to linecard.
+ *
+ *	@linecard: devlink linecard
+ *      @nested_devlink: devlink instance to attach or NULL to detach
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
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.35.3

