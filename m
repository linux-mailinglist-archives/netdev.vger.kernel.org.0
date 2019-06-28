Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA785A314
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfF1SEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:04:07 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36835 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfF1SEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:04:07 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so3659244plt.3
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nab/iiRPK11wrPPa+rNpgDlOn3uxcOFhhll3EctSaWM=;
        b=mNXsDfnoS2RrdpRJfY6NTTgVT3tIFtR7dZeT43wFlfPivanYLSBFShulKhB1YcYNnX
         TfG/QJs90rNC6BiOjUTbGM48+KhCWZ7B9nY+DCPrRCvwgGT/Xq3QFiW5SFtcLsnSkrrp
         OWS3kUrFFS4Sm2ipbTb5nhf6CMNjLuKQjoRjUBHGdXRwTgnO+kxg/+sgZv+1WwsrKVm0
         AmTcjMTukHoxS5bN5TBJAsXL2N3crDn2yYp/HxdE8S9sqfel7irhp1WwgTPv5cHB0TWi
         DJ7U1Jd5bpNCcui4OaJGieyQ146oMLd82mLOfBxXqbOpt4czG6YnF1UcTDBf/TDPZ+iY
         Swwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nab/iiRPK11wrPPa+rNpgDlOn3uxcOFhhll3EctSaWM=;
        b=Z3zgeE4f4wtA3UR9dRlwLnSH0Y3l/Ez526dHwbJrOAA5oIsUkbw7P2WMB03bVkQTWM
         S7jbszjaSf3qH2WcbZh+w2XSmalTTzeIdWwx0PYu0FFl0rAMciC2QPUjmjCE0bLJkHCX
         5zi8SgHMhy+uNhwARh0fOC48rCxvurpuC31saO4/ykNiAXZZjF/ZZ0h4rUCukhz5+3n4
         aPIA1H+Pe+nuKRLsU2PFZA0Lnz/DaOGhHOS8OKUGoA1KU6TwlA5rAm4kEIciB9aDUSda
         +peTyRqShDmmSmUTWci/VRmMVigGoClGr9/cevYJbmgEqaeU6XMt7u/Xisopfnerg9EH
         jemg==
X-Gm-Message-State: APjAAAXIG9sCSRiZBRopw5zeMC2hRkaHzCf5hTjVDFbIecUVvhCEX1pF
        2uDZdL04+twnsGJMJhigHBwZj4ucoSQ=
X-Google-Smtp-Source: APXvYqxLMlcwnX8+8hgs/3wN20j1wgivfZS+oxhUovzSZvfo78KAatht1f5E047x4uV//CVOF2YrMA==
X-Received: by 2002:a17:902:a607:: with SMTP id u7mr13255340plq.43.1561745046022;
        Fri, 28 Jun 2019 11:04:06 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id d6sm2175919pgv.4.2019.06.28.11.04.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:04:05 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, chrism@mellanox.com, willy@infradead.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Li Shuang <shuali@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [Patch net 2/3] idr: introduce idr_for_each_entry_continue_ul()
Date:   Fri, 28 Jun 2019 11:03:42 -0700
Message-Id: <20190628180343.8230-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
References: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly, other callers of idr_get_next_ul() suffer the same
overflow bug as they don't handle it properly either.

Introduce idr_for_each_entry_continue_ul() to help these callers
iterate from a given ID.

cls_flower needs more care here because it still has overflow when
does arg->cookie++, we have to fold its nested loops into one
and remove the arg->cookie++.

Fixes: 01683a146999 ("net: sched: refactor flower walk to iterate over idr")
Fixes: 12d6066c3b29 ("net/mlx5: Add flow counters idr")
Reported-by: Li Shuang <shuali@redhat.com>
Cc: Davide Caratti <dcaratti@redhat.com>
Cc: Vlad Buslov <vladbu@mellanox.com>
Cc: Chris Mi <chrism@mellanox.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 10 ++++---
 include/linux/idr.h                           | 14 ++++++++++
 net/sched/cls_flower.c                        | 27 +++++--------------
 3 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index c6c28f56aa29..b3762123a69c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -102,13 +102,15 @@ static struct list_head *mlx5_fc_counters_lookup_next(struct mlx5_core_dev *dev,
 	struct mlx5_fc_stats *fc_stats = &dev->priv.fc_stats;
 	unsigned long next_id = (unsigned long)id + 1;
 	struct mlx5_fc *counter;
+	unsigned long tmp;
 
 	rcu_read_lock();
 	/* skip counters that are in idr, but not yet in counters list */
-	while ((counter = idr_get_next_ul(&fc_stats->counters_idr,
-					  &next_id)) != NULL &&
-	       list_empty(&counter->list))
-		next_id++;
+	idr_for_each_entry_continue_ul(&fc_stats->counters_idr,
+				       counter, tmp, next_id) {
+		if (!list_empty(&counter->list))
+			break;
+	}
 	rcu_read_unlock();
 
 	return counter ? &counter->list : &fc_stats->counters;
diff --git a/include/linux/idr.h b/include/linux/idr.h
index 68528a72d10d..4ec8986e5dfb 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -216,6 +216,20 @@ static inline void idr_preload_end(void)
 	     entry;							\
 	     ++id, (entry) = idr_get_next((idr), &(id)))
 
+/**
+ * idr_for_each_entry_continue_ul() - Continue iteration over an IDR's elements of a given type
+ * @idr: IDR handle.
+ * @entry: The type * to use as a cursor.
+ * @tmp: A temporary placeholder for ID.
+ * @id: Entry ID.
+ *
+ * Continue to iterate over entries, continuing after the current position.
+ */
+#define idr_for_each_entry_continue_ul(idr, entry, tmp, id)		\
+	for (tmp = id;							\
+	     tmp <= id && ((entry) = idr_get_next_ul(idr, &(id))) != NULL; \
+	     tmp = id, ++id)
+
 /*
  * IDA - ID Allocator, use when translation from id to pointer isn't necessary.
  */
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index eedd5786c084..fdeede3af72e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -524,24 +524,6 @@ static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
 	return f;
 }
 
-static struct cls_fl_filter *fl_get_next_filter(struct tcf_proto *tp,
-						unsigned long *handle)
-{
-	struct cls_fl_head *head = fl_head_dereference(tp);
-	struct cls_fl_filter *f;
-
-	rcu_read_lock();
-	while ((f = idr_get_next_ul(&head->handle_idr, handle))) {
-		/* don't return filters that are being deleted */
-		if (refcount_inc_not_zero(&f->refcnt))
-			break;
-		++(*handle);
-	}
-	rcu_read_unlock();
-
-	return f;
-}
-
 static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 		       bool *last, bool rtnl_held,
 		       struct netlink_ext_ack *extack)
@@ -1691,20 +1673,25 @@ static int fl_delete(struct tcf_proto *tp, void *arg, bool *last,
 static void fl_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 		    bool rtnl_held)
 {
+	struct cls_fl_head *head = fl_head_dereference(tp);
+	unsigned long id = arg->cookie, tmp;
 	struct cls_fl_filter *f;
 
 	arg->count = arg->skip;
 
-	while ((f = fl_get_next_filter(tp, &arg->cookie)) != NULL) {
+	idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id) {
+		/* don't return filters that are being deleted */
+		if (!refcount_inc_not_zero(&f->refcnt))
+			continue;
 		if (arg->fn(tp, f, arg) < 0) {
 			__fl_put(f);
 			arg->stop = 1;
 			break;
 		}
 		__fl_put(f);
-		arg->cookie++;
 		arg->count++;
 	}
+	arg->cookie = id;
 }
 
 static struct cls_fl_filter *
-- 
2.21.0

