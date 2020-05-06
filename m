Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B2F1C70EA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgEFMzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728655AbgEFMzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:19 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25E8C0610D5
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:18 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so2534063wma.4
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zTN3/BskZ+4ol3oKCkQfAC6PGLClSpQxixHtq6iy11w=;
        b=P9H43lx47Vxc5u0F2V6Am7sedKcGD3APLPbEn0X71S4DrJtXbqOTdJy/XXScrO+jo6
         5KHe7tbNefK1V7fdbK10HDiEgWdCVso7a9bQLSUOb0ro5A1X62B37gYEIQT202pv16c+
         8S8HXaont4c9W61pJ8Mt1uPes6/iSeCR1FQms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zTN3/BskZ+4ol3oKCkQfAC6PGLClSpQxixHtq6iy11w=;
        b=r37O6kkFsoD1LgqQ1f62AyzPCfrDzrziRu3IXmIIYHwyiMZRxDzjnqUGSpgDRzIe6g
         91pGa9hcYN9z7d0W1iPCVW/2TYGS+KpPp+EuVgc749hawqgRVIh7dt1T8C6pAfBoDh0n
         jJa5LmVbM3tR8kMeTR6ItdV6BDs75rh8ioKdZX3O3g2zpU82z3BZewsnK1ouq9u0vVCl
         dC72EBbCKmCH3D5OjNVdHbFP2kqhQCNk3880NV5Q4GV8XVtx/UBOUfX0EH1yo1fqBU58
         5zCmCNpVtpbmS2TfYg7CP/8DtlnQSRet6EBwTktnoyKi9cplHKoNQ8D0V3vbASMR6osP
         +9Qw==
X-Gm-Message-State: AGi0PuY5AUh7cGAB3wZbXkhXFPqLfDvDwYiWeQDq3GGjOL8OyAR31F1z
        jWxsK0hO87esbFTNXZ+SCzGSGfxm2D8=
X-Google-Smtp-Source: APiQypJ4WYnTJsctfjlpcaBjR0dz4PFVQe1iFckiO5RfZGZ7VMGvnzpc6fZKFsQMcvlEuitF+elG7g==
X-Received: by 2002:a1c:f211:: with SMTP id s17mr4793139wmc.168.1588769717257;
        Wed, 06 May 2020 05:55:17 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v124sm720012wme.45.2020.05.06.05.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:16 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 01/17] flow_dissector: Extract attach/detach/query helpers
Date:   Wed,  6 May 2020 14:54:57 +0200
Message-Id: <20200506125514.1020829-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
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
index 1262ec460ab3..716c47ac1e75 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -31,6 +31,7 @@ struct seq_file;
 struct btf;
 struct btf_type;
 struct exception_table_entry;
+struct mutex;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1660,4 +1661,11 @@ enum bpf_text_poke_type {
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
index dfaf5df13722..bc25bb1085b1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8740,6 +8740,74 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
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

