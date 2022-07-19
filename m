Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F934579372
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiGSGtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiGSGsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:48:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3732714D
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:53 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id oy13so25318572ejb.1
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aspQd0C3p+e2wV89GVeOMWKHXEruM7RQ62Y/eHOaDM0=;
        b=WVn/5NqIm96cSAK6N8gBWOF6J08+Lp+iCKNdtjmxYMjDH26OeLCGo6SPOb+mEvcQFH
         D0FCcHL7PUNsvhpzFOJx1Xw+ipHFF0nwXC+P7ypYXTHTCZJLnBQbqCRgieBNHjBoKahe
         6dVw9/0hB41oFuNIdswKuT/aaZAESEQuEndKZJYcFT2WCkI2+6rW5COgcWPsZbZVBAKI
         sKphW071F9J2vAZgFcb4ZrguomL3xEoC21JFPov6ZAs5QLqWvdqdovO7CAez9yE03kVn
         TNG3jOJVZYqVv9XRYS8eT8t07/9GNoYCtcdXAgeJ2vxWVE2Y+UXEs8LPbhW52bCqH8jH
         qS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aspQd0C3p+e2wV89GVeOMWKHXEruM7RQ62Y/eHOaDM0=;
        b=wqstJ2UMY8Am+7hxGaDQJeVBWzCwkbboQwurubVuY6xk3r6+9MD2y8+QnOpfVRuM7O
         mvi28QWJuXLbMAf7Mnl/z3+W1N5XGHkA5UhC3VbXLmhAVg0KNvU3PuusSmwh2fegznd7
         Rd2+y23Xh7go5XUKb/00nOpEKpuCsA14di+EzAz8Eqx+0TWbhvbdby9Aevi9Xq9nuPcT
         Js1MoEBIguVW8JqwR6L1wf9JYEfkUbfVEe03KQmk9tNX+PZW+4GbQKEsEQ/n7Pc63gSV
         w5UdKYoyLuTq8U6AsQAkI7KLAzynXNv/BAeZFEi7wfUBI6d3HmVyHBtrNQU3LaBlo+6B
         qDCg==
X-Gm-Message-State: AJIora8UYlxB2mUu33d7/bhc66aEsTWc9CzGSzJK5dTiOD+ytYptg/vw
        uZuetfwKF8D0FugKoy5QrP+qayTv9YrqF0uQV5A=
X-Google-Smtp-Source: AGRyM1tvic+WpefWknbnuj5vZNoOVbsc9+xuiVJrXpmSVkf+rSnP4aAxJjYBT+tv8wos4gGIkc8CTQ==
X-Received: by 2002:a17:906:d54b:b0:72e:ece1:2956 with SMTP id cr11-20020a170906d54b00b0072eece12956mr20319159ejc.156.1658213331556;
        Mon, 18 Jul 2022 23:48:51 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k8-20020a17090632c800b0072f3efb96aasm1571952ejk.128.2022.07.18.23.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:48:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 02/12] net: devlink: introduce nested devlink entity for line card
Date:   Tue, 19 Jul 2022 08:48:37 +0200
Message-Id: <20220719064847.3688226-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
References: <20220719064847.3688226-1-jiri@resnulli.us>
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
---
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
index aca1dd7c1f07..777d01223f58 100644
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
 
@@ -10389,6 +10412,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->nested_devlink);
 	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
 	linecard->type = NULL;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
@@ -10407,6 +10431,7 @@ EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
 {
 	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->nested_devlink);
 	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING_FAILED;
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
 	mutex_unlock(&linecard->state_lock);
@@ -10454,6 +10479,23 @@ void devlink_linecard_deactivate(struct devlink_linecard *linecard)
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

