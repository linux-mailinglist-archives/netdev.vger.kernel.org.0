Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B971203C10
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbgFVQDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729883AbgFVQDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:03:05 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AFBC061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:03:05 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id u25so9977795lfm.1
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HdIvYx+tqNu7jSLu3BPp4H3DI+qK/NhTufCEIwjYSL0=;
        b=WEpePu8IePtYAMhO+wmxma3RHSXd+WCdHpWUpHLC0k2nwUpsC9qWY595DtIcvwHwVQ
         MASOLqJMqhZsKMT7rJLieof1veM9DIVCovycaG0ukxrCIEaewYRxX+Ql1Wwf0WYLJEGv
         UTvlqS5rOjlN8neqEquP3kg6s3xRforEYxiVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HdIvYx+tqNu7jSLu3BPp4H3DI+qK/NhTufCEIwjYSL0=;
        b=n/XZGU1eSUwf65mqwpD1Sy5knaKdC3iNTvz0TtSWS5bCt9mQZXSpiwPj3x4fg9WAtP
         jm4VCNgLUcztJ205Wd2IgnQMGJYCDOSD4Y1qudV/hTN8XjIGFdOYbZLUioz/tpQsJ/XU
         V8IzmeaDQPNdzmgVu1E0v16xIgD1WuZfWV1no41rtXWFtglIpDOMAlJOYPCrwOQZt8UT
         nEme6pfRORlxNl19fTR+KtE7n1F/VEIo1wjNrGG348ATDNPq0WgpCkSjxmH337k7cEBv
         jqF/KmESDUvQBFmGna9kYQ1lEpPOsUUaDg19Y68PqYql5ldMdbvKdfWoPqgSOdUIDQSY
         iv3A==
X-Gm-Message-State: AOAM533PZz/rjtNHseXWaahX5FvSgJxx3NIsp8Sgb6lOOERXy+Dd5DpU
        DhQ5dNnXvQ8NStfWrfqFoa5cog==
X-Google-Smtp-Source: ABdhPJxEL3eGf2Cf84ZqN9aFIy1XV25Ayy9SFXzFFbdHMkltEwjumbpcUtz6XoFKWWm1cSuhsxPEnQ==
X-Received: by 2002:ac2:44b7:: with SMTP id c23mr10138487lfm.169.1592841783556;
        Mon, 22 Jun 2020 09:03:03 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id x16sm274131lfc.76.2020.06.22.09.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 09:03:02 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 1/3] flow_dissector: Pull BPF program assignment up to bpf-netns
Date:   Mon, 22 Jun 2020 18:02:58 +0200
Message-Id: <20200622160300.636567-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200622160300.636567-1-jakub@cloudflare.com>
References: <20200622160300.636567-1-jakub@cloudflare.com>
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

