Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD859FB76
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfH1HW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:22:57 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34272 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbfH1HW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:22:56 -0400
Received: by mail-lf1-f68.google.com with SMTP id z21so1252018lfe.1
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FOCDLn2KDYPwM+wHU1EZOVW+/h+YhGWrEzvKXUK9sag=;
        b=uYk7IdWtnZvFLYH8omKkjhFOKH5EunWPZy/7Xmd/WXAypaL9ZCtkvMv29j4tgRndTx
         ySmMBBW0bGKFn2tt2TkHjvDGhSx24bXjG33mjrMdCfXdYM1qp0veCCvjocMw47lL1crt
         FBkenQvMbqXOdG8QWdGSVb37fQvub0LOxJTCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FOCDLn2KDYPwM+wHU1EZOVW+/h+YhGWrEzvKXUK9sag=;
        b=atmiH65OMEue6aNfsAtdDs5ZdnKN+sowXrt2Ki61kDfJuIwybuiIQwjDitUIPAaGAx
         Ms2eZHOovJMw7qCJkS+BjC9WXr8OHg2TZ8Il4KN6qjjg4RO4Y+O6Ta8kTsLLqkJ/dvi6
         HtqhC9z1MNQIkFtXQmTqfnh7CWuwvzT/tGHiiK2T6vWWjXTOPtLqA7SMuSI30nstJdgl
         iBeGIt6I70U4UL1wdaa/k2EZNDWkH9Pve60mKXPidzjO5/pbYZFOEA2cqqZzMGfLphHp
         3o+Wpt6yYlhk/LkY9uIPdIQR/OBIpIiHFh99QDX7o9BZfUfvxuvIItCdbEoPs958aRpk
         yTWg==
X-Gm-Message-State: APjAAAUgbXeLe+WrMblgoMDXinMYyF/NzkP2iAWHJ4lyk8AXdspayGsZ
        fNa+a4tcFxm5bO5+kvdTHtZATQ==
X-Google-Smtp-Source: APXvYqyq8EkTC06ZfD30CkfrrRGib61QFwf07xq3ofOKuMyK7sLRXFnA+ZAXPpQUvhWAzzvBhKp9pw==
X-Received: by 2002:a19:2d19:: with SMTP id k25mr1793895lfj.76.1566976974022;
        Wed, 28 Aug 2019 00:22:54 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id r8sm587912lfc.39.2019.08.28.00.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:22:53 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFCv2 bpf-next 01/12] flow_dissector: Extract attach/detach/query helpers
Date:   Wed, 28 Aug 2019 09:22:39 +0200
Message-Id: <20190828072250.29828-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828072250.29828-1-jakub@cloudflare.com>
References: <20190828072250.29828-1-jakub@cloudflare.com>
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
 net/core/filter.c         | 73 +++++++++++++++++++++++++++++++++++++++
 net/core/flow_dissector.c | 65 ++++++----------------------------
 3 files changed, 92 insertions(+), 54 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b9d22338606..b301e0c03a8c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -23,6 +23,7 @@ struct sock;
 struct seq_file;
 struct btf;
 struct btf_type;
+struct mutex;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -1145,4 +1146,11 @@ static inline u32 bpf_xdp_sock_convert_ctx_access(enum bpf_access_type type,
 }
 #endif /* CONFIG_INET */
 
+int bpf_prog_query_one(struct bpf_prog __rcu **pprog,
+		       const union bpf_attr *attr,
+		       union bpf_attr __user *uattr);
+int bpf_prog_attach_one(struct bpf_prog __rcu **pprog, struct mutex *lock,
+			struct bpf_prog *prog, u32 flags);
+int bpf_prog_detach_one(struct bpf_prog __rcu **pprog, struct mutex *lock);
+
 #endif /* _LINUX_BPF_H */
diff --git a/net/core/filter.c b/net/core/filter.c
index 0c1059cdad3d..a498fbaa2d50 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8668,6 +8668,79 @@ int sk_get_filter(struct sock *sk, struct sock_filter __user *ubuf,
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
+	mutex_lock(lock);
+	attached = rcu_dereference_protected(*pprog,
+					     lockdep_is_held(lock));
+	if (attached) {
+		/* Only one BPF program can be attached at a time */
+		mutex_unlock(lock);
+		return -EEXIST;
+	}
+	rcu_assign_pointer(*pprog, prog);
+	mutex_unlock(lock);
+
+	return 0;
+}
+
+int bpf_prog_detach_one(struct bpf_prog __rcu **pprog, struct mutex *lock)
+{
+	struct bpf_prog *attached;
+
+	mutex_lock(lock);
+	attached = rcu_dereference_protected(*pprog,
+					     lockdep_is_held(lock));
+	if (!attached) {
+		mutex_unlock(lock);
+		return -ENOENT;
+	}
+	RCU_INIT_POINTER(*pprog, NULL);
+	bpf_prog_put(attached);
+	mutex_unlock(lock);
+
+	return 0;
+}
+
 #ifdef CONFIG_INET
 struct sk_reuseport_kern {
 	struct sk_buff *skb;
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 9741b593ea53..c51602158906 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -73,80 +73,37 @@ EXPORT_SYMBOL(skb_flow_dissector_init);
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
-	struct net *net;
+	struct net *net = current->nsproxy->net_ns;
 
-	net = current->nsproxy->net_ns;
-	mutex_lock(&flow_dissector_mutex);
-	attached = rcu_dereference_protected(net->flow_dissector_prog,
-					     lockdep_is_held(&flow_dissector_mutex));
-	if (attached) {
-		/* Only one BPF program can be attached at a time */
-		mutex_unlock(&flow_dissector_mutex);
-		return -EEXIST;
-	}
-	rcu_assign_pointer(net->flow_dissector_prog, prog);
-	mutex_unlock(&flow_dissector_mutex);
-	return 0;
+	return bpf_prog_attach_one(&net->flow_dissector_prog,
+				   &flow_dissector_mutex, prog,
+				   attr->attach_flags);
 }
 
 int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
 {
-	struct bpf_prog *attached;
-	struct net *net;
+	struct net *net = current->nsproxy->net_ns;
 
-	net = current->nsproxy->net_ns;
-	mutex_lock(&flow_dissector_mutex);
-	attached = rcu_dereference_protected(net->flow_dissector_prog,
-					     lockdep_is_held(&flow_dissector_mutex));
-	if (!attached) {
-		mutex_unlock(&flow_dissector_mutex);
-		return -ENOENT;
-	}
-	bpf_prog_put(attached);
-	RCU_INIT_POINTER(net->flow_dissector_prog, NULL);
-	mutex_unlock(&flow_dissector_mutex);
-	return 0;
+	return bpf_prog_detach_one(&net->flow_dissector_prog,
+				   &flow_dissector_mutex);
 }
+
 /**
  * skb_flow_get_be16 - extract be16 entity
  * @skb: sk_buff to extract from
-- 
2.20.1

