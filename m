Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1564916BF06
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgBYKpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:34 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50202 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730242AbgBYKpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:33 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so2479570wmb.0
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SS2QFyZIJelZ/sd9XZ/hXTMvynBDfSWHspJ07fvITKs=;
        b=ObZf8Ops+4fX3VHrL9eMT7u3vdo93FAd7vYGcWkkBDsDaPJm59VbwFaBPFMdZ8VQ6B
         1ZiOv5QwUVFidzDuu8c9DrN0jlwNK3qZ2w39hp+lu+wLiBtsVb27t8D/lsrV+1nP0IIE
         Oxh12cO6C38y42U0fVWDp4D0R7VPFKmgqd6nE+0mXrlMfDV8IrZWjqAfQQ7M6JYHEnCE
         bIUNGQF165XYsaOv2ZiFDTInndnhUY5VKB6d7WjCnPfxVqF2qbykNQX0vej7D4EjddTF
         aI/KPuAplxHfnK0WM3aIM5ju7nt7rGMhDO3baZquENVz2kBk9omxxVO6Jdbk3TZeiP7e
         G1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SS2QFyZIJelZ/sd9XZ/hXTMvynBDfSWHspJ07fvITKs=;
        b=LU/TAiQS3z4HrkyPisR5XKVSnJ1twGfSOHAKLiRTeF0twF58uYTiolO6Dt1F1eb54I
         +sFxiRDEHTibJyUc/eioGbXX7UfrNWYXQ1UJmV2MVIOXp9xG09b46+LDOuklQa7p4iEW
         NQwlXjSIFZSz0YUVqn5L9wNMrksY6D03PhaLoGrea6fKw32rq2iydAM7X4gsSKZRGjAM
         F+XzY1zgJzHlVJfJQRuDznHzb3oJ2tMj8wET4yfI/QEhYOprNl+WsWgWcsWSjthaJWmG
         TCiOm7tvLnJlQYqCgt0HaPXcA9PgzlFmk5LQooEOppaFrRwqwiqSZ318qd8BqoG7hA/V
         FSLg==
X-Gm-Message-State: APjAAAX1lcI9ynQv81Jk3Qs2QS3mfmjDifp8GO5PdfcndcTD+57kXdmi
        pOeFhCJj3imC3mJPECcl6q8no2wiGmY=
X-Google-Smtp-Source: APXvYqzi/dpk/oHxWYBqu2wz4K0A0A2tDMGToLAPfkg76OXoyx1Vs8okixcm1nxGda9m3YQT829+AA==
X-Received: by 2002:a1c:8156:: with SMTP id c83mr4502096wmd.164.1582627529897;
        Tue, 25 Feb 2020 02:45:29 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id f207sm3842343wme.9.2020.02.25.02.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:29 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 01/10] flow_offload: pass action cookie through offload structures
Date:   Tue, 25 Feb 2020 11:45:18 +0100
Message-Id: <20200225104527.2849-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
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
v1->v2:
- s/[0]/[]/
- used u8* instead of unsigned long* for cookie
- used u32 for cookie_len
---
 include/net/flow_offload.h | 11 +++++++++++
 net/core/flow_offload.c    | 21 +++++++++++++++++++++
 net/sched/cls_api.c        | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index c6f7bd22db60..4e864c34a1b0 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -156,6 +156,16 @@ enum flow_action_mangle_base {
 
 typedef void (*action_destr)(void *priv);
 
+struct flow_action_cookie {
+	u32 cookie_len;
+	u8 cookie[];
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

