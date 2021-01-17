Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5C62F8FF9
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 01:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbhAQA5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 19:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbhAQA5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 19:57:52 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280D2C061573
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 16:57:12 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id n186so6027874oia.5
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 16:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KcQLGNMv+gn4ZaAMDKl9EbuFKBb/7QVfQxRd6fjtaMY=;
        b=ahq+VnV96/CSWqGmmXXSOm4iEnfylLmMbrGGOhmwhEGI+C/wsBCT8OnEJhzd2IfMDh
         ZkqGh8QEVtqM4mK9sDshW3Te8etIBpWdrT8hfnVEchO5CEpfcDS1YNQeSP59YtBbCjIc
         zrPED+/0OxKv7hDyy5DLMMLIkQdz7XJTiNuxDfe2igUqD2uSVw5aubZ8n0MjhGMsU/Go
         eTRkdNTFwE4cOUVf+N/DieT5h/SKIcEipC58Ynkc1phkGJP+4Xeyf7UbYjwYtMi61TvY
         dvc9kD4xFiRUV0rFYHohVMJvNrFn1tht35mgin+3D7vU1jeTyA1UEmMYtN9607mua/Kv
         gLEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KcQLGNMv+gn4ZaAMDKl9EbuFKBb/7QVfQxRd6fjtaMY=;
        b=RTve4L4QALz3fF4EnDCUkfZGyjsV/e6tgNifzGwxfgWsT+RNqkG4YNsP+aWAEgI0fp
         doWu9y6xJW3QWA49XQhVDOqMBQRtt8skT3vZZhEuomLPkCFkEwWmqxKZDK/xOUrhxhww
         YWktKkLAIz2xM13GbMt47OiJCqZ5IgFb8yKv1EySufhC/hmJm+RZ/+YtUfJNuumzGrE2
         63dO/VXV69OmIU2uHsZ7IXpz2Is5hUDP5RUxiDSCSQcQAk/qNvOKyd/Vg3TFhV4opPpN
         ZnZ5ZlXSQQ/2zI6NA3uaHEUvgZB/OVMc0pfSw+9DaOmh8e+st3X0Z9SWOSBXmQ1HWkyz
         BI9A==
X-Gm-Message-State: AOAM532IV0K8NKUu87rZgfkTyfe1140bTfvmlJhxe8xlVx0G1y5DfGNy
        zT/iM17twQe7crdJbtPZsPIcR92YiWULPQ==
X-Google-Smtp-Source: ABdhPJyLxG+CvQrCydvfpIza7JYIaY+XQRrMkdcW2LJWzF9VsP0XMqIs0/VB4QoYiuq4FGjn8ysmuQ==
X-Received: by 2002:aca:5e42:: with SMTP id s63mr9773096oib.96.1610845031103;
        Sat, 16 Jan 2021 16:57:11 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1c14:d05:b7d:917b])
        by smtp.gmail.com with ESMTPSA id l1sm1238614otf.79.2021.01.16.16.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 16:57:10 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com,
        syzbot+b3b63b6bff456bd95294@syzkaller.appspotmail.com,
        syzbot+ba67b12b1ca729912834@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net-next] net_sched: fix RTNL deadlock again caused by request_module()
Date:   Sat, 16 Jan 2021 16:56:57 -0800
Message-Id: <20210117005657.14810-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

tcf_action_init_1() loads tc action modules automatically with
request_module() after parsing the tc action names, and it drops RTNL
lock and re-holds it before and after request_module(). This causes a
lot of troubles, as discovered by syzbot, because we can be in the
middle of batch initializations when we create an array of tc actions.

One of the problem is deadlock:

CPU 0					CPU 1
rtnl_lock();
for (...) {
  tcf_action_init_1();
    -> rtnl_unlock();
    -> request_module();
				rtnl_lock();
				for (...) {
				  tcf_action_init_1();
				    -> tcf_idr_check_alloc();
				   // Insert one action into idr,
				   // but it is not committed until
				   // tcf_idr_insert_many(), then drop
				   // the RTNL lock in the _next_
				   // iteration
				   -> rtnl_unlock();
    -> rtnl_lock();
    -> a_o->init();
      -> tcf_idr_check_alloc();
      // Now waiting for the same index
      // to be committed
				    -> request_module();
				    -> rtnl_lock()
				    // Now waiting for RTNL lock
				}
				rtnl_unlock();
}
rtnl_unlock();

This is not easy to solve, we can move the request_module() before
this loop and pre-load all the modules we need for this netlink
message and then do the rest initializations. So the loop breaks down
to two now:

        for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
                struct tc_action_ops *a_o;

                a_o = tc_action_load_ops(name, tb[i]...);
                ops[i - 1] = a_o;
        }

        for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
                act = tcf_action_init_1(ops[i - 1]...);
        }

Although this looks serious, it only has been reported by syzbot, so it
seems hard to trigger this by humans. And given the size of this patch,
I'd suggest to make it to net-next and not to backport to stable.

This patch has been tested by syzbot and tested with tdc.py by me.

Fixes: 0fedc63fadf ("net_sched: commit action insertions together")
Reported-and-tested-by: syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+b3b63b6bff456bd95294@syzkaller.appspotmail.com
Reported-by: syzbot+ba67b12b1ca729912834@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/act_api.h |   5 +-
 net/sched/act_api.c   | 104 +++++++++++++++++++++++++++---------------
 net/sched/cls_api.c   |  11 ++++-
 3 files changed, 79 insertions(+), 41 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 55dab604861f..761c0e331915 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -186,10 +186,13 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct nlattr *est, char *name, int ovr, int bind,
 		    struct tc_action *actions[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack);
+struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
+					 bool rtnl_held,
+					 struct netlink_ext_ack *extack);
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
-				    bool rtnl_held,
+				    struct tc_action_ops *ops, bool rtnl_held,
 				    struct netlink_ext_ack *extack);
 int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
 		    int ref, bool terse);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2e85b636b27b..4dd235ce9a07 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -928,19 +928,13 @@ static void tcf_idr_insert_many(struct tc_action *actions[])
 	}
 }
 
-struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
-				    struct nlattr *nla, struct nlattr *est,
-				    char *name, int ovr, int bind,
-				    bool rtnl_held,
-				    struct netlink_ext_ack *extack)
+struct tc_action_ops *tc_action_load_ops(char *name, struct nlattr *nla,
+					 bool rtnl_held,
+					 struct netlink_ext_ack *extack)
 {
-	struct nla_bitfield32 flags = { 0, 0 };
-	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
-	struct tc_action *a;
+	struct nlattr *tb[TCA_ACT_MAX + 1];
 	struct tc_action_ops *a_o;
-	struct tc_cookie *cookie = NULL;
 	char act_name[IFNAMSIZ];
-	struct nlattr *tb[TCA_ACT_MAX + 1];
 	struct nlattr *kind;
 	int err;
 
@@ -948,33 +942,21 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
 						  tcf_action_policy, extack);
 		if (err < 0)
-			goto err_out;
+			return ERR_PTR(err);
 		err = -EINVAL;
 		kind = tb[TCA_ACT_KIND];
 		if (!kind) {
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
-			goto err_out;
+			return ERR_PTR(err);
 		}
 		if (nla_strscpy(act_name, kind, IFNAMSIZ) < 0) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
-			goto err_out;
-		}
-		if (tb[TCA_ACT_COOKIE]) {
-			cookie = nla_memdup_cookie(tb);
-			if (!cookie) {
-				NL_SET_ERR_MSG(extack, "No memory to generate TC cookie");
-				err = -ENOMEM;
-				goto err_out;
-			}
+			return ERR_PTR(err);
 		}
-		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
-		if (tb[TCA_ACT_FLAGS])
-			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
 	} else {
 		if (strlcpy(act_name, name, IFNAMSIZ) >= IFNAMSIZ) {
 			NL_SET_ERR_MSG(extack, "TC action name too long");
-			err = -EINVAL;
-			goto err_out;
+			return ERR_PTR(-EINVAL);
 		}
 	}
 
@@ -996,24 +978,56 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 		 * indicate this using -EAGAIN.
 		 */
 		if (a_o != NULL) {
-			err = -EAGAIN;
-			goto err_mod;
+			module_put(a_o->owner);
+			return ERR_PTR(-EAGAIN);
 		}
 #endif
 		NL_SET_ERR_MSG(extack, "Failed to load TC action module");
-		err = -ENOENT;
-		goto err_free;
+		return ERR_PTR(-ENOENT);
 	}
 
+	return a_o;
+}
+
+struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
+				    struct nlattr *nla, struct nlattr *est,
+				    char *name, int ovr, int bind,
+				    struct tc_action_ops *a_o, bool rtnl_held,
+				    struct netlink_ext_ack *extack)
+{
+	struct nla_bitfield32 flags = { 0, 0 };
+	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
+	struct nlattr *tb[TCA_ACT_MAX + 1];
+	struct tc_cookie *cookie = NULL;
+	struct tc_action *a;
+	int err;
+
 	/* backward compatibility for policer */
-	if (name == NULL)
+	if (name == NULL) {
+		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+						  tcf_action_policy, extack);
+		if (err < 0)
+			return ERR_PTR(err);
+		if (tb[TCA_ACT_COOKIE]) {
+			cookie = nla_memdup_cookie(tb);
+			if (!cookie) {
+				NL_SET_ERR_MSG(extack, "No memory to generate TC cookie");
+				err = -ENOMEM;
+				goto err_out;
+			}
+		}
+		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
+		if (tb[TCA_ACT_FLAGS])
+			flags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
+
 		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, ovr, bind,
 				rtnl_held, tp, flags.value, extack);
-	else
+	} else {
 		err = a_o->init(net, nla, est, &a, ovr, bind, rtnl_held,
 				tp, flags.value, extack);
+	}
 	if (err < 0)
-		goto err_mod;
+		goto err_out;
 
 	if (!name && tb[TCA_ACT_COOKIE])
 		tcf_set_action_cookie(&a->act_cookie, cookie);
@@ -1030,14 +1044,11 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 
 	return a;
 
-err_mod:
-	module_put(a_o->owner);
-err_free:
+err_out:
 	if (cookie) {
 		kfree(cookie->data);
 		kfree(cookie);
 	}
-err_out:
 	return ERR_PTR(err);
 }
 
@@ -1048,6 +1059,7 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		    struct tc_action *actions[], size_t *attr_size,
 		    bool rtnl_held, struct netlink_ext_ack *extack)
 {
+	struct tc_action_ops *ops[TCA_ACT_MAX_PRIO] = {};
 	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
 	struct tc_action *act;
 	size_t sz = 0;
@@ -1059,9 +1071,20 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 	if (err < 0)
 		return err;
 
+	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
+		struct tc_action_ops *a_o;
+
+		a_o = tc_action_load_ops(name, tb[i], rtnl_held, extack);
+		if (IS_ERR(a_o)) {
+			err = PTR_ERR(a_o);
+			goto err_mod;
+		}
+		ops[i - 1] = a_o;
+	}
+
 	for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
 		act = tcf_action_init_1(net, tp, tb[i], est, name, ovr, bind,
-					rtnl_held, extack);
+					ops[i - 1], rtnl_held, extack);
 		if (IS_ERR(act)) {
 			err = PTR_ERR(act);
 			goto err;
@@ -1081,6 +1104,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 
 err:
 	tcf_action_destroy(actions, bind);
+err_mod:
+	for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
+		if (ops[i])
+			module_put(ops[i]->owner);
+	}
 	return err;
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 37b77bd30974..a67c66a512a4 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3043,12 +3043,19 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
 		size_t attr_size = 0;
 
 		if (exts->police && tb[exts->police]) {
+			struct tc_action_ops *a_o;
+
+			a_o = tc_action_load_ops("police", tb[exts->police], rtnl_held, extack);
+			if (IS_ERR(a_o))
+				return PTR_ERR(a_o);
 			act = tcf_action_init_1(net, tp, tb[exts->police],
 						rate_tlv, "police", ovr,
-						TCA_ACT_BIND, rtnl_held,
+						TCA_ACT_BIND, a_o, rtnl_held,
 						extack);
-			if (IS_ERR(act))
+			if (IS_ERR(act)) {
+				module_put(a_o->owner);
 				return PTR_ERR(act);
+			}
 
 			act->type = exts->type = TCA_OLD_COMPAT;
 			exts->actions[0] = act;
-- 
2.25.1

