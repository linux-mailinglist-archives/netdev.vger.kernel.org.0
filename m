Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B6734FBC6
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhCaIiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbhCaIh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:37:59 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB6AC06174A;
        Wed, 31 Mar 2021 01:37:59 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f3so4490988pgv.0;
        Wed, 31 Mar 2021 01:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ccaqSjNvl3ukMYGkyGN2LDQ+g0PkcsvzVn6FgeWnsB8=;
        b=Ir1o/yyI84ELGXmN6cJWa04Z2AdEQdo4yGyXFbzdBlfpVR4511nZDnMBRir/l27Ecu
         fbZriubFEBloqBT4fs6mmut0SwID3bETtyyXsEGYm1/TTJrJUJUvJe4eE5QH1qbCiL39
         nBlBCLFvayJZH767OjfTN4fDyR9bbCXKenAQF4AGp4OFeS9CEcovCAo437qkZBR/WFVt
         g+SIjATKBjaTrot+FuLWZiDlGPok9AX2/58XmhOrYrM7YzU3KnJYjeVQ1f4r/U/cVNEa
         o7t/4r3YNHB/9U3+dEYMriYX0cLkApZ2B7w3QBNUFa/jmeKIpCA/5fg2GpCkYp9YQrwD
         pqjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ccaqSjNvl3ukMYGkyGN2LDQ+g0PkcsvzVn6FgeWnsB8=;
        b=GJkHLEYYcgu726Qd6JyUncYcdRejvzL2Psb6qdhUrO7jzkVGGiCK779OihnksXFX19
         NfozrlkiCX07pN9uxRoz/sYhyadz1WRNZmoItNpruNYNIZRlp6I6uMaX6n3HrqlZ9rlb
         XrFw+7xejxGCMQQmFxnYGOpWj4MpjUGYflKEFgN1lIaEfBb299R8wBYp4xcPttLmFhPv
         Ok41iIV2F2yujYaZdwL/kUgLlavgsXs3RaqcBeIoeUAjo00tbZg8sg2UZ7xCXaIYmsUm
         +Su+5V/tuBHOxWzG1/zYBxHbqNl0jBdFHT3GIZ0rzP61Lv2Ubis7TvOAl8n7WkK2U4MW
         GLqw==
X-Gm-Message-State: AOAM531tBApTXZfD5yy3zYNscuOkISpmQNtKRHwdmUyyxa3yT5rHxZVM
        OGvAcPIVIrt0OhxD0ZYPc5U=
X-Google-Smtp-Source: ABdhPJx0rU9MB8WdE3sOLqZAhyfW+WVNQVbMecQS0EfThM7L8SlkimebnQdO29EcuWsI97x0xISoTA==
X-Received: by 2002:a62:7f45:0:b029:205:9617:a819 with SMTP id a66-20020a627f450000b02902059617a819mr1914033pfd.17.1617179878714;
        Wed, 31 Mar 2021 01:37:58 -0700 (PDT)
Received: from localhost ([47.8.37.177])
        by smtp.gmail.com with ESMTPSA id x25sm1489541pfn.81.2021.03.31.01.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:37:58 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     xiyou.wangcong@gmail.com
Cc:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org, memxor@gmail.com,
        netdev@vger.kernel.org, toke@redhat.com, vladbu@nvidia.com
Subject: [PATCH net-next v3] net: sched: bump refcount for new action in ACT replace mode
Date:   Wed, 31 Mar 2021 14:07:24 +0530
Message-Id: <20210331083723.171150-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAM_iQpVAo+Zxus-FC59xzwcmbS7UOi6F8kNMzsrEVrBY2YRtNA@mail.gmail.com>
References: <CAM_iQpVAo+Zxus-FC59xzwcmbS7UOi6F8kNMzsrEVrBY2YRtNA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, action creation using ACT API in replace mode is buggy.  When
invoking for non-existent action index 42,

	tc action replace action bpf obj foo.o sec <xyz> index 42

kernel creates the action, fills up the netlink response, and then just
deletes the action while notifying userspace of success.

	tc action show action bpf

doesn't list the action.

This happens due to the following sequence when ovr = 1 (replace mode)
is enabled:

tcf_idr_check_alloc is used to atomically check and either obtain
reference for existing action at index, or reserve the index slot using
a dummy entry (ERR_PTR(-EBUSY)).

This is necessary as pointers to these actions will be held after
dropping the idrinfo lock, so bumping the reference count is necessary
as we need to insert the actions, and notify userspace by dumping their
attributes. Finally, we drop the reference we took using the
tcf_action_put_many call in tcf_action_add. However, for the case where
a new action is created due to free index, its refcount remains one.
This when paired with the put_many call leads to the kernel setting up
the action, notifying userspace of its creation, and then tearing it
down. For existing actions, the refcount is still held so they remain
unaffected.

Fortunately due to rtnl_lock serialization requirement, such an action
with refcount == 1 will not be concurrently deleted by anything else, at
best CLS API can move its refcount up and down by binding to it after it
has been published from tcf_idr_insert_many. Since refcount is atleast
one until put_many call, CLS API cannot delete it. Also __tcf_action_put
release path already ensures deterministic outcome (either new action
will be created or existing action will be reused in case CLS API tries
to bind to action concurrently) due to idr lock serialization.

We fix this by making refcount of newly created actions as 2 in ACT API
replace mode. A relaxed store will suffice as visibility is ensured only
after the tcf_idr_insert_many call.

We also remember the new actions that we took an additional reference on,
and relinquish the temporal reference during rollback on failure.

Note that in case of creation or overwriting using CLS API only (i.e.
bind = 1), overwriting existing action object is not allowed, and any
such request is silently ignored (without error).

The refcount bump that occurs in tcf_idr_check_alloc call there for
existing action will pair with tcf_exts_destroy call made from the owner
module for the same action. In case of action creation, there is no
existing action, so no tcf_exts_destroy callback happens.

This means no code changes for CLS API.

Fixes: cae422f379f3 ("net: sched: use reference counting action init")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
Changelog:

v2 -> v3
Cleanup new action on rollback after raising refcount (Cong)

v1 -> v2
Remove erroneous tcf_action_put_many call in tcf_exts_validate (Vlad)
Isolate refcount bump to ACT API in replace mode
---
 include/net/act_api.h |  2 +-
 net/sched/act_api.c   | 24 ++++++++++++++++++++++--
 net/sched/cls_api.c   |  2 +-
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 2bf3092ae7ec..a01ff5fa641e 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -194,7 +194,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
 				    struct tc_action_ops *ops, bool rtnl_held,
-				    struct netlink_ext_ack *extack);
+				    struct netlink_ext_ack *extack, bool *ref);
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
 		    int ref, bool terse);
 int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index b919826939e0..718bc197b9a7 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -993,7 +993,7 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
 				    struct tc_action_ops *a_o, bool rtnl_held,
-				    struct netlink_ext_ack *extack)
+				    struct netlink_ext_ack *extack, bool *ref)
 {
 	struct nla_bitfield32 flags = { 0, 0 };
 	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
@@ -1042,6 +1042,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (err != ACT_P_CREATED)
 		module_put(a_o->owner);

+	if (!bind && ovr && err == ACT_P_CREATED) {
+		if (ref)
+			*ref = true;
+
+		refcount_set(&a->tcfa_refcnt, 2);
+	}
+
 	return a;

 err_out:
@@ -1062,10 +1069,13 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
 	struct tc_action *act;
+	u32 new_actions = 0;
 	size_t sz = 0;
 	int err;
 	int i;

+	BUILD_BUG_ON(TCA_ACT_MAX_PRIO > sizeof(new_actions) * 8);
+
 	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX_PRIO, nla, NULL,
 					  extack);
 	if (err < 0)
@@ -1083,8 +1093,9 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	}

 	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
+		bool ovr_new = false;
 		act = tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
-					ops[i - 1], rtnl_held, extack);
+					ops[i - 1], rtnl_held, extack, &ovr_new);
 		if (IS_ERR(act)) {
 			err = PTR_ERR(act);
 			goto err;
@@ -1092,6 +1103,10 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
+
+		/* remember new actions that we take a reference on */
+		if (ovr_new)
+			new_actions |= 1UL << (i - 1);
 	}

 	/* We have to commit them all together, because if any error happened in
@@ -1103,6 +1118,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	return i - 1;

 err:
+	/* reset the reference back to 1 in case of error */
+	for (i = 0; i < TCA_ACT_MAX_PRIO && actions[i]; i++) {
+		if (new_actions & (1UL << i))
+			refcount_set(&actions[i]->tcfa_refcnt, 1);
+	}
 	tcf_action_destroy(actions, bind);
 err_mod:
 	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d3db70865d66..4f4a7355b1e1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3052,7 +3052,7 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 			act = tcf_action_init_1(net, tp, tb[exts->police],
 						rate_tlv, "police", ovr,
 						TCA_ACT_BIND, a_o, rtnl_held,
-						extack);
+						extack, NULL);
 			if (IS_ERR(act)) {
 				module_put(a_o->owner);
 				return PTR_ERR(act);
--
2.30.2

