Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F183520A0AB
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 16:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405378AbgFYOOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 10:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405286AbgFYOOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 10:14:04 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B54C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 07:14:03 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id d21so3295653lfb.6
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 07:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YWExEfsXXQUQcMS8kRbVy31FOuquakLr9FFsow70cAs=;
        b=pP62zYhiJb5j/NwXGy0sfg9MKWeWoFCHA5VpaG+lC4GMpq3yMi8R54xFKIb0vF5csB
         hMClUYGIqOhkXIT0A6bwPtNFH5U47VvluKreVFnPSKgkrGHeFE65LeDJDq9M0inB/I0s
         gI7ECEcbj5Lgan9O2dZqaS+FC4xgGEO1ajB0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YWExEfsXXQUQcMS8kRbVy31FOuquakLr9FFsow70cAs=;
        b=TrQ8q5xLpmCnIqyqIi9vcS4v07Q623Aw5z4np/zSEVHtQnRSGI5ShuFjgCRBwrIicr
         gP3oaVBq3hnVap1ZXi72PB24jxr8EwOEkyTnAA2CXKVbDv2ziGZsBBAd1aa9Uz+l41nk
         dPY5cOmdWtHJITPE3a2R1UBpwUbAnF+HyET4BVD2WdYyonKdy/5Y+Y8HSPdvPkuturRq
         at6MCeyHj8SkXBYyuEoDzS9i+YzvJsNfVtEAwZ/0i9UBfON1CshKPg0Rjin3cnxyWX5A
         CCC0qeMKxN9T3nTv3gZsSHRtEgpbh8VzDcFeeynRMM8rNH5ZSNNF9ZUjmI+KEEiWCVkB
         QAFA==
X-Gm-Message-State: AOAM533Agdpl8B/dfoWpH3Qf8oDsPMdvv2k90JOes8M4EyuhvB499xi2
        Y1UDGFiXARAO/kodurkwFPStxQ==
X-Google-Smtp-Source: ABdhPJy92NGNaqtCE+TGjZVGoVoylwKmv+EjsRZm3+5ZueZ3egvLjOh57qYgdQ0Nksm3TCgnOEWvww==
X-Received: by 2002:a19:dc08:: with SMTP id t8mr15446981lfg.191.1593094442286;
        Thu, 25 Jun 2020 07:14:02 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id y2sm4523489lfh.1.2020.06.25.07.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 07:14:01 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v3 1/4] flow_dissector: Pull BPF program assignment up to bpf-netns
Date:   Thu, 25 Jun 2020 16:13:54 +0200
Message-Id: <20200625141357.910330-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200625141357.910330-1-jakub@cloudflare.com>
References: <20200625141357.910330-1-jakub@cloudflare.com>
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

