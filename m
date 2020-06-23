Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DB3204F1A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732267AbgFWKfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732201AbgFWKfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 06:35:04 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C7CC061755
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 03:35:03 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e4so22834122ljn.4
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 03:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YWExEfsXXQUQcMS8kRbVy31FOuquakLr9FFsow70cAs=;
        b=iD/9f0/5XWCm8HusjE+l7SLhBzQXtiOI9wlKnOXRgdCUK5FbJc4lXwBBKXj2tbj6wM
         cQuF8Qfx1bqRcFGMd20l81wCafqLfeNqvyHLcHsGOJrdwHPU3qABNbjxOGlRDOAYGJGZ
         1aHYbQW1w2s7ZqsE0sjbENpXJkR5XPWuziiRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YWExEfsXXQUQcMS8kRbVy31FOuquakLr9FFsow70cAs=;
        b=PlvcFTorsK8eL5RiSuYo2vu7mJO7tWIQZpTktlqDpaflt1O6wOaDI/JWL+mK8GEfky
         m5SDGrm0tTKxKv39JrU06FXfg43gqtSTXkfliRtSWqibbUSzGw/8ASFPDnVJ8LpygiUN
         muDu9WzJujRvnDOMZMYf1M1nZuWuDBGWqUJm9LrTz3eHiOR6s2S6XdOAKg80ZHYjISl0
         cP0iWQlF6NejbL2EG/SN+xQunr6v+uNNMbkdClr102TOWz8i+LFOx4PJhg2CDyXFnDZD
         Czu299rt/67EXvqrrNw0JgDBjbpRK6GWaa8j1RGuvw4l4yXE9G/25WyjNW7E0wEqn6tT
         gZaA==
X-Gm-Message-State: AOAM531Z2ZR1Q+NsBQFIF6mUOGKgaNnBxvtZLVo6cWAaNSsjNiT0QFBf
        p3pBvpE5cCdf2l9gdJjyfO2kMw==
X-Google-Smtp-Source: ABdhPJzNGrmbnT2u12rHEbXg98+C5CbdY0kgit4B1MO7/q5tRMfWaKNVidp6Tk5Iip3qBGx5Gf2x8A==
X-Received: by 2002:a2e:8751:: with SMTP id q17mr2643966ljj.386.1592908502315;
        Tue, 23 Jun 2020 03:35:02 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u8sm4069773lff.38.2020.06.23.03.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:35:01 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 1/3] flow_dissector: Pull BPF program assignment up to bpf-netns
Date:   Tue, 23 Jun 2020 12:34:57 +0200
Message-Id: <20200623103459.697774-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623103459.697774-1-jakub@cloudflare.com>
References: <20200623103459.697774-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for using bpf_prog_array to store attached programs by moving out
code that updates the attached program out of flow dissector.

Managing bpf_prog_array is more involved than updating a single bpf_prog
pointer. This will let us do it all from one place, bpf/net_namespace.c, in
the subsequent patch.

No functional change intended.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/flow_dissector.h |  3 ++-
 kernel/bpf/net_namespace.c   | 20 ++++++++++++++++++--
 net/core/flow_dissector.c    | 13 ++-----------
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index a7eba43fe4e4..4b6e36288ddd 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -372,7 +372,8 @@ flow_dissector_init_keys(struct flow_dissector_key_control *key_control,
 }
 
 #ifdef CONFIG_BPF_SYSCALL
-int flow_dissector_bpf_prog_attach(struct net *net, struct bpf_prog *prog);
+int flow_dissector_bpf_prog_attach_check(struct net *net,
+					 struct bpf_prog *prog);
 #endif /* CONFIG_BPF_SYSCALL */
 
 #endif
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 78cf061f8179..b951dab2687f 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -189,6 +189,7 @@ int netns_bpf_prog_query(const union bpf_attr *attr,
 int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 {
 	enum netns_bpf_attach_type type;
+	struct bpf_prog *attached;
 	struct net *net;
 	int ret;
 
@@ -207,12 +208,26 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 
 	switch (type) {
 	case NETNS_BPF_FLOW_DISSECTOR:
-		ret = flow_dissector_bpf_prog_attach(net, prog);
+		ret = flow_dissector_bpf_prog_attach_check(net, prog);
 		break;
 	default:
 		ret = -EINVAL;
 		break;
 	}
+	if (ret)
+		goto out_unlock;
+
+	attached = rcu_dereference_protected(net->bpf.progs[type],
+					     lockdep_is_held(&netns_bpf_mutex));
+	if (attached == prog) {
+		/* The same program cannot be attached twice */
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	rcu_assign_pointer(net->bpf.progs[type], prog);
+	if (attached)
+		bpf_prog_put(attached);
+
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
 
@@ -277,7 +292,7 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 
 	switch (type) {
 	case NETNS_BPF_FLOW_DISSECTOR:
-		err = flow_dissector_bpf_prog_attach(net, link->prog);
+		err = flow_dissector_bpf_prog_attach_check(net, link->prog);
 		break;
 	default:
 		err = -EINVAL;
@@ -286,6 +301,7 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 	if (err)
 		goto out_unlock;
 
+	rcu_assign_pointer(net->bpf.progs[type], link->prog);
 	net->bpf.links[type] = link;
 
 out_unlock:
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index d02df0b6d0d9..b57fb1359395 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -70,10 +70,10 @@ void skb_flow_dissector_init(struct flow_dissector *flow_dissector,
 EXPORT_SYMBOL(skb_flow_dissector_init);
 
 #ifdef CONFIG_BPF_SYSCALL
-int flow_dissector_bpf_prog_attach(struct net *net, struct bpf_prog *prog)
+int flow_dissector_bpf_prog_attach_check(struct net *net,
+					 struct bpf_prog *prog)
 {
 	enum netns_bpf_attach_type type = NETNS_BPF_FLOW_DISSECTOR;
-	struct bpf_prog *attached;
 
 	if (net == &init_net) {
 		/* BPF flow dissector in the root namespace overrides
@@ -97,15 +97,6 @@ int flow_dissector_bpf_prog_attach(struct net *net, struct bpf_prog *prog)
 			return -EEXIST;
 	}
 
-	attached = rcu_dereference_protected(net->bpf.progs[type],
-					     lockdep_is_held(&netns_bpf_mutex));
-	if (attached == prog)
-		/* The same program cannot be attached twice */
-		return -EINVAL;
-
-	rcu_assign_pointer(net->bpf.progs[type], prog);
-	if (attached)
-		bpf_prog_put(attached);
 	return 0;
 }
 #endif /* CONFIG_BPF_SYSCALL */
-- 
2.25.4

