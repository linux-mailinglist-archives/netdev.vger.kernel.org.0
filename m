Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D43A16B184
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgBXVIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:08:05 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53137 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgBXVIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:08:04 -0500
Received: by mail-wm1-f66.google.com with SMTP id p9so788396wmc.2
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UzDE9t1MgRSyHA9/Wao5K88v/blca0pYthQZXcBi5hk=;
        b=Qog/SxDkQPwFMtTHC/AXmt581a5jp0xRilPTlteAqdOPRfd7yjGqb4UzqTlYb8cQBI
         HdW3Ec18pga8lG1DrlntIFwvVHT3zBPvBN16iMH8ciYRvxdvjPm9mgsKT3OcVpkC2fzR
         5R4yAAzt9+dnzxHxQ9D+Z9MolegMZf2iZucT1HS1x8wA/cPgrhxs+Kmvt2oIDbXkzupN
         zV4Onl8ShFhAvcgDv6aOtBsm4tucQkEskvj2JVVMEXwGe8vT7MtcQq/TuyAc8VusY7oD
         2NnJ6Uw0UGjrIMoazkQG1It27TDh6Wuu/dLSUrDVdzVU5KKTn881/tvovIeDMCZdieH0
         S2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UzDE9t1MgRSyHA9/Wao5K88v/blca0pYthQZXcBi5hk=;
        b=W6GwjfIx34uze/UP1d0cvmWfZjyc2a83Xs+cxlKRie+X4L3VRFXHvgVb2CYxZAwE/i
         9+08a6oSe81VN/cb1VlvYklWN9Z3/ELBRGA6fShw0rByHuTGfiPyKoB+MnSQ6OI+4UtD
         Q/vUxf95tJ2ga0Ikvj4Yf+BHhsUfAKvWXKxv6SWw/MQNHX4F2xLJsV5/B8loCEBtTG4p
         ria1CqtDQqwLlRBLy+EAZUVGQEZK3qOWTs66xbrvv9x+BNReCrBxzZmLxeELOmZCIz21
         zkQqtSYHE752A3TcjJqwA4No0qwM8FQOyDM7+uJHSERVWcrpD+kYKIpxUCR2UvVtcBIe
         7KxA==
X-Gm-Message-State: APjAAAXppWvpgIkz/4B9DBQA4u49T2byRzqb0e1msZCOSjO341FgCQsl
        BdpxGkSNsg9kvic0XFDJsrepty3/AF8=
X-Google-Smtp-Source: APXvYqwj/dZLGrBIZIEHKlRk1okP4psrGtWba7QviO464ZjvJb510LmJ+h+0ViaZ6To5Sz9Zy1dwHw==
X-Received: by 2002:a1c:4341:: with SMTP id q62mr856361wma.107.1582578481012;
        Mon, 24 Feb 2020 13:08:01 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id v131sm937459wme.23.2020.02.24.13.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:08:00 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 01/10] flow_offload: pass action cookie through offload structures
Date:   Mon, 24 Feb 2020 22:07:49 +0100
Message-Id: <20200224210758.18481-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224210758.18481-1-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend struct flow_action_entry in order to hold TC action cookie
specified by user inserting the action.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/flow_offload.h | 11 +++++++++++
 net/core/flow_offload.c    | 21 +++++++++++++++++++++
 net/sched/cls_api.c        | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index c6f7bd22db60..4d72224de438 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -156,6 +156,16 @@ enum flow_action_mangle_base {
 
 typedef void (*action_destr)(void *priv);
 
+struct flow_action_cookie {
+	unsigned int cookie_len;
+	unsigned long cookie[0];
+};
+
+struct flow_action_cookie *flow_action_cookie_create(void *data,
+						     unsigned int len,
+						     gfp_t gfp);
+void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
+
 struct flow_action_entry {
 	enum flow_action_id		id;
 	action_destr			destructor;
@@ -214,6 +224,7 @@ struct flow_action_entry {
 			u8		ttl;
 		} mpls_mangle;
 	};
+	struct flow_action_cookie *cookie; /* user defined action cookie */
 };
 
 struct flow_action {
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 45b6a59ac124..d21348202ba6 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -167,6 +167,27 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_enc_opts);
 
+struct flow_action_cookie *flow_action_cookie_create(void *data,
+						     unsigned int len,
+						     gfp_t gfp)
+{
+	struct flow_action_cookie *cookie;
+
+	cookie = kmalloc(sizeof(*cookie) + len, gfp);
+	if (!cookie)
+		return NULL;
+	cookie->cookie_len = len;
+	memcpy(cookie->cookie, data, len);
+	return cookie;
+}
+EXPORT_SYMBOL(flow_action_cookie_create);
+
+void flow_action_cookie_destroy(struct flow_action_cookie *cookie)
+{
+	kfree(cookie);
+}
+EXPORT_SYMBOL(flow_action_cookie_destroy);
+
 struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv))
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 13c33eaf1ca1..4e766c5ab77a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3382,14 +3382,40 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 }
 EXPORT_SYMBOL(tc_setup_cb_reoffload);
 
+static int tcf_act_get_cookie(struct flow_action_entry *entry,
+			      const struct tc_action *act)
+{
+	struct tc_cookie *cookie;
+	int err = 0;
+
+	rcu_read_lock();
+	cookie = rcu_dereference(act->act_cookie);
+	if (cookie) {
+		entry->cookie = flow_action_cookie_create(cookie->data,
+							  cookie->len,
+							  GFP_ATOMIC);
+		if (!entry->cookie)
+			err = -ENOMEM;
+	}
+	rcu_read_unlock();
+	return err;
+}
+
+static void tcf_act_put_cookie(struct flow_action_entry *entry)
+{
+	flow_action_cookie_destroy(entry->cookie);
+}
+
 void tc_cleanup_flow_action(struct flow_action *flow_action)
 {
 	struct flow_action_entry *entry;
 	int i;
 
-	flow_action_for_each(i, entry, flow_action)
+	flow_action_for_each(i, entry, flow_action) {
+		tcf_act_put_cookie(entry);
 		if (entry->destructor)
 			entry->destructor(entry->destructor_priv);
+	}
 }
 EXPORT_SYMBOL(tc_cleanup_flow_action);
 
@@ -3447,6 +3473,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 
 		entry = &flow_action->entries[j];
 		spin_lock_bh(&act->tcfa_lock);
+		err = tcf_act_get_cookie(entry, act);
+		if (err)
+			goto err_out_locked;
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
 		} else if (is_tcf_gact_shot(act)) {
-- 
2.21.1

