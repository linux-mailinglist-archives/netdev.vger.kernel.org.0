Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A991CE33B
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgEKSw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729215AbgEKSw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:52:26 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CC0C05BD0A
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:24 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id v12so12270314wrp.12
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nSivWb3QDofiBZMqyO7kOgrM+Q+I6G7D3bjxIkCgD9M=;
        b=iGRDEaI02V4EZxUWsAedwQTbA+LE7wyG5CfS9CJIa0S7AM/HWQBgO1+uqUbDAo8uZz
         jkUvjsyGvzHcGaBzn2ZwGX441PyfvEeyr83VC2ewDcMGPXiLetzrxEa1Jq2h+fAWfFHQ
         q4jng9c+AK6aq7N5pATqJJkkVSz0Bh7VXxWZQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nSivWb3QDofiBZMqyO7kOgrM+Q+I6G7D3bjxIkCgD9M=;
        b=EXPPahUqBRpa7CzqQRbLS53e8vIjDUn/ke3w3d4eHxBsXxnbZfVMcYT07Dd/Y/mmGe
         /1/1ReKomyPGVw9afOnUc3cZREKz8rOt20llp8dykX4vO4p8uI14nFWkqgZTM9Pc3xkd
         XSGr8uyteRAlC6dvEPnwsDQ7oLNgUY5GG9ApIm+NwHm3uUm8NLXJwG6q3/L3RUG62VrD
         xQHjsl1jyWmXMJITpxcNMrEc7JMpgVW1KvppVm8+eizHzxPhkAiTDay17B5G91qjFAvg
         FMGVisKbr0ero0wjzqC/oDidCLJFT9NNrAeLU/8JmHx503RHW1IgpAOe53vjRh7vCfG5
         c4tQ==
X-Gm-Message-State: AGi0Pub/0HacLmt+0LQj4WBYxVybHppWzjk3KULEzlGR/2f2gb46KOS4
        GY/rsM2p+RFlrpoSWt27RSo19eMWGK8=
X-Google-Smtp-Source: APiQypJIc+6evEBthviUr24GRcnrqU3j4tR0VGFuZlUSDqQbIAJqIdUQGkv7jP4H+hWIhKkJ7xp79A==
X-Received: by 2002:adf:f146:: with SMTP id y6mr21628372wro.132.1589223142787;
        Mon, 11 May 2020 11:52:22 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d1sm9933382wrc.26.2020.05.11.11.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 11:52:22 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 01/17] flow_dissector: Extract attach/detach/query helpers
Date:   Mon, 11 May 2020 20:52:02 +0200
Message-Id: <20200511185218.1422406-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200511185218.1422406-1-jakub@cloudflare.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move generic parts of callbacks for querying, attaching, and detaching a
single BPF program for reuse by other BPF program types.

Subsequent patch makes use of the extracted routines.

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/bpf.h       |  8 +++++
 net/core/filter.c         | 68 +++++++++++++++++++++++++++++++++++++++
 net/core/flow_dissector.c | 61 +++++++----------------------------
 3 files changed, 88 insertions(+), 49 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cf4b6e44f2bc..1cf4fae7987d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -32,6 +32,7 @@ struct btf;
 struct btf_type;
 struct exception_table_entry;
 struct seq_operations;
+struct mutex;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1696,4 +1697,11 @@ enum bpf_text_poke_type {
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *addr1, void *addr2);
 
+int bpf_prog_query_one(struct bpf_prog __rcu **pprog,
+		       const union bpf_attr *attr,
+		       union bpf_attr __user *uattr);
+int bpf_prog_attach_one(struct bpf_prog __rcu **pprog, struct mutex *lock,
+			struct bpf_prog *prog, u32 flags);
+int bpf_prog_detach_one(struct bpf_prog __rcu **pprog, struct mutex *lock);
+
 #endif /* _LINUX_BPF_H */
diff --git a/net/core/filter.c b/net/core/filter.c
index da0634979f53..48ed970f4ae1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8738,6 +8738,74 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
 	return ret;
 }
 
+int bpf_prog_query_one(struct bpf_prog __rcu **pprog,
+		       const union bpf_attr *attr,
+		       union bpf_attr __user *uattr)
+{
+	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
+	u32 prog_id, prog_cnt = 0, flags = 0;
+	struct bpf_prog *attached;
+
+	if (attr->query.query_flags)
+		return -EINVAL;
+
+	rcu_read_lock();
+	attached = rcu_dereference(*pprog);
+	if (attached) {
+		prog_cnt = 1;
+		prog_id = attached->aux->id;
+	}
+	rcu_read_unlock();
+
+	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
+		return -EFAULT;
+	if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
+		return -EFAULT;
+
+	if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
+		return 0;
+
+	if (copy_to_user(prog_ids, &prog_id, sizeof(u32)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int bpf_prog_attach_one(struct bpf_prog __rcu **pprog, struct mutex *lock,
+			struct bpf_prog *prog, u32 flags)
+{
+	struct bpf_prog *attached;
+
+	if (flags)
+		return -EINVAL;
+
+	attached = rcu_dereference_protected(*pprog,
+					     lockdep_is_held(lock));
+	if (attached == prog) {
+		/* The same program cannot be attached twice */
+		return -EINVAL;
+	}
+	rcu_assign_pointer(*pprog, prog);
+	if (attached)
+		bpf_prog_put(attached);
+
+	return 0;
+}
+
+int bpf_prog_detach_one(struct bpf_prog __rcu **pprog, struct mutex *lock)
+{
+	struct bpf_prog *attached;
+
+	attached = rcu_dereference_protected(*pprog,
+					     lockdep_is_held(lock));
+	if (!attached)
+		return -ENOENT;
+	RCU_INIT_POINTER(*pprog, NULL);
+	bpf_prog_put(attached);
+
+	return 0;
+}
+
 #ifdef CONFIG_INET
 static void bpf_init_reuseport_kern(struct sk_reuseport_kern *reuse_kern,
 				    struct sock_reuseport *reuse,
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3eff84824c8b..5ff99ed175bd 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -73,46 +73,22 @@ EXPORT_SYMBOL(skb_flow_dissector_init);
 int skb_flow_dissector_prog_query(const union bpf_attr *attr,
 				  union bpf_attr __user *uattr)
 {
-	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
-	u32 prog_id, prog_cnt = 0, flags = 0;
-	struct bpf_prog *attached;
 	struct net *net;
-
-	if (attr->query.query_flags)
-		return -EINVAL;
+	int ret;
 
 	net = get_net_ns_by_fd(attr->query.target_fd);
 	if (IS_ERR(net))
 		return PTR_ERR(net);
 
-	rcu_read_lock();
-	attached = rcu_dereference(net->flow_dissector_prog);
-	if (attached) {
-		prog_cnt = 1;
-		prog_id = attached->aux->id;
-	}
-	rcu_read_unlock();
+	ret = bpf_prog_query_one(&net->flow_dissector_prog, attr, uattr);
 
 	put_net(net);
-
-	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
-		return -EFAULT;
-	if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
-		return -EFAULT;
-
-	if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
-		return 0;
-
-	if (copy_to_user(prog_ids, &prog_id, sizeof(u32)))
-		return -EFAULT;
-
-	return 0;
+	return ret;
 }
 
 int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
 				       struct bpf_prog *prog)
 {
-	struct bpf_prog *attached;
 	struct net *net;
 	int ret = 0;
 
@@ -145,16 +121,9 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
 		}
 	}
 
-	attached = rcu_dereference_protected(net->flow_dissector_prog,
-					     lockdep_is_held(&flow_dissector_mutex));
-	if (attached == prog) {
-		/* The same program cannot be attached twice */
-		ret = -EINVAL;
-		goto out;
-	}
-	rcu_assign_pointer(net->flow_dissector_prog, prog);
-	if (attached)
-		bpf_prog_put(attached);
+	ret = bpf_prog_attach_one(&net->flow_dissector_prog,
+				  &flow_dissector_mutex, prog,
+				  attr->attach_flags);
 out:
 	mutex_unlock(&flow_dissector_mutex);
 	return ret;
@@ -162,21 +131,15 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
 
 int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
 {
-	struct bpf_prog *attached;
-	struct net *net;
+	struct net *net = current->nsproxy->net_ns;
+	int ret;
 
-	net = current->nsproxy->net_ns;
 	mutex_lock(&flow_dissector_mutex);
-	attached = rcu_dereference_protected(net->flow_dissector_prog,
-					     lockdep_is_held(&flow_dissector_mutex));
-	if (!attached) {
-		mutex_unlock(&flow_dissector_mutex);
-		return -ENOENT;
-	}
-	RCU_INIT_POINTER(net->flow_dissector_prog, NULL);
-	bpf_prog_put(attached);
+	ret =  bpf_prog_detach_one(&net->flow_dissector_prog,
+				   &flow_dissector_mutex);
 	mutex_unlock(&flow_dissector_mutex);
-	return 0;
+
+	return ret;
 }
 
 /**
-- 
2.25.3

