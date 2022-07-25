Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EDE57FB54
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbiGYI3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiGYI3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5593F13F71
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:33 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id sz17so19223579ejc.9
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2T499h2GjpQ8ET82dtPtVxyETlKN+ysnMenwly7MV6E=;
        b=r9Xh7jT1/ZNiDdhwiWL8ARv6IJsWKar/sbr7d1dAjA0pH8FJiU24Xr918nad1jsylU
         wpKKhtgfpGRTrCfDpNEBOB761b/BvNo+QSNMun7AVdfVxH1Ngt+UZAfvGfMLlTENmEtc
         L6PyxVvxLALhHbAa2WY3MLeQNTW7aGW3WgpN4J+4hD2IpOQ9q9wC79qbWUqp7iNNQY4p
         eusKMAhOGvwWz3uzmNa5N5xhifWRtaxC4GWdyYHZzCs9ze1/IHdhKZBeronQ1/yk2AnF
         ca1ddW6EEJDpPWMhVeRYFvOYAa4FPGVV3CECyQobE3EzgqdcwMVDT95BMQeLTudzQIfw
         OVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2T499h2GjpQ8ET82dtPtVxyETlKN+ysnMenwly7MV6E=;
        b=z8/UnsWUG+FyCoS9JYQ8394H9zDuOKKbcff566E6e2o2F2DzoxPage0gX2i3wQq+bP
         /WcHy8d+kogxVIE6sTzeEgC6Okj1wEoadhmvevRgwdEw1UNclLsWuayNb7owIjnFboM0
         Vy+QOqN/QNAm5zntV3ipDQLbxQhac/4TaYUC4cZFIWREQCOuiVasEYhRHQyQXo8O2OzG
         XfZwXu99wdQKiL37Yw4MHk65XRwq6p+o8Xo+29yhOByWyOs8LH6XWwmcbK5LvtOhp5Kn
         PHU4Augu9FAxQQIQVe/kpQvA184yuu9XQsRuKiw9S5pNWSq+4gJBImPnbJTKYQlwd7d5
         wM1Q==
X-Gm-Message-State: AJIora/rGQsf8AhjK9pP428OXNwqhbDVFmOVx+GycxVSTIQh6ZxewnCo
        cAJrFEP3y5zxfGwFz9B5Bb03vt/f5ihzl1lYjp4=
X-Google-Smtp-Source: AGRyM1uT4A7M7OpGDt0/xHRLSkVM7+7DwxmGhxTb6Gyb5TV3nJuDRefXp3ApYSznBHLJoVBmt9ot9A==
X-Received: by 2002:a17:907:7241:b0:72b:347b:17a1 with SMTP id ds1-20020a170907724100b0072b347b17a1mr9484796ejc.32.1658737771743;
        Mon, 25 Jul 2022 01:29:31 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d2-20020a170906304200b0072f42ca292bsm5044298ejd.129.2022.07.25.01.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 03/12] net: devlink: introduce nested devlink entity for line card
Date:   Mon, 25 Jul 2022 10:29:16 +0200
Message-Id: <20220725082925.366455-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
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
index 865232a1455f..698b2d6e0ec7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -89,6 +89,7 @@ struct devlink_linecard {
 	const char *type;
 	struct devlink_linecard_type *types;
 	unsigned int types_count;
+	struct devlink *nested_devlink;
 };
 
 /**
@@ -856,6 +857,24 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
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
@@ -2135,6 +2154,10 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 		nla_nest_end(msg, attr);
 	}
 
+	if (linecard->nested_devlink &&
+	    devlink_nl_put_nested_handle(msg, linecard->nested_devlink))
+		goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -10255,6 +10278,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->nested_devlink);
 	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
 	linecard->type = NULL;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
@@ -10273,6 +10297,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->nested_devlink);
 	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING_FAILED;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 	mutex_unlock(&linecard->state_lock);
@@ -10320,6 +10345,23 @@ void devlink_linecard_deactivate(struct devlink_linecard *linecard)
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

