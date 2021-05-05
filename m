Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B57374C02
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 01:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhEEXhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 19:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhEEXhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 19:37:45 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7C8C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 16:36:47 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id o1so2680839qta.1
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 16:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zy4vxZEs9D5ZkvyoT5fFdYLZaXKfmxS3Ig3++IgAX0w=;
        b=KMAtz4JWy0PrUo4bDeM8f2oF6XxPghNCN4azNKreG6CSdWnPZUMA6uE5alIQvEFsUO
         /OJJClUFxFwsyCkHEsk3tUvVWlJLjnfO3kHgfMyhSpoqCHFeEOdnGCeYfOTb5+3mtD/O
         M268POtPdul2gx1ipEh2YB054jTw+xq89fgoXUZ9Vf2cPT7cOo9h37yvoYE1nKQvipHX
         pkny7MzYAA/55ZTSfFnslCWCWM80qR1X6Xy28AHGoHgMMZJJnZoZ9HlMjnWHGd5mB1xK
         l+CJ6ee4erS50Dz1pHe+WzzktSLmcplyFlLacaiWM7gBMR8xN271XKDTqtjMqSAnubSN
         7SjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zy4vxZEs9D5ZkvyoT5fFdYLZaXKfmxS3Ig3++IgAX0w=;
        b=KShEKBMNjHFf/6yDujwqxrUm1vTE2J1wCqhwqVaaLSXCgqin7oOy3ZRaU3rtMuSMoW
         C9wgPC8k9l+XNgDqNDnbgEFVG/6XYHiBnW84YPal1lqPys8MfSM0Bi/I7hQleyNBGlJJ
         VACQslU01CCy+W8nqfTJtWcLwu7jPL2qZAxmXmbNRrYTMSJROWjONdOGEfcVmadVnsm2
         wD4IXunowt7UObOpT6keoHAKP99XAaKXotMFyJEpmc5Nbh8R1efZiA2BXwnGHs1Q6GlU
         2zy9XinFX/adnDwyYIMxL5jk6fYX3X+Awz44kQaijsr6gPtze4UJO2N8M+Vi+8jt4Wt8
         w5SA==
X-Gm-Message-State: AOAM5307hodMidoDT0Q9R4pIFqv3IqQy/s1a1nKB9zmazjvzawvKnKBY
        /E4wIc4F43f08sKMmEEOpv9NPWIcbxNe4g==
X-Google-Smtp-Source: ABdhPJwnIKVCH8IhBqVVjeK/LbvPoht+sxHzC7RnOfINV8Db+RavQbnFXlmddo3shOpirJLA1Kz1WA==
X-Received: by 2002:ac8:7f53:: with SMTP id g19mr1169694qtk.249.1620257806677;
        Wed, 05 May 2021 16:36:46 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id k15sm711527qtg.68.2021.05.05.16.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 16:36:46 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com,
        Taehee Yoo <ap420073@gmail.com>
Subject: [Patch net] rtnetlink: use rwsem to protect rtnl_af_ops list
Date:   Wed,  5 May 2021 16:36:42 -0700
Message-Id: <20210505233642.13661-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We use RTNL lock and RCU read lock to protect the global
list rtnl_af_ops, however, this forces the af_ops readers
being in atomic context while iterating this list,
particularly af_ops->set_link_af(). This was not a problem
until we begin to take mutex lock down the path in
__ipv6_dev_mc_dec().

Convert RTNL+RCU to rwsemaphore, so that we can block on
the reader side while still allowing parallel readers.

Reported-and-tested-by: syzbot+7d941e89dd48bcf42573@syzkaller.appspotmail.com
Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface mld data")
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/rtnetlink.c | 68 +++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 714d5fa38546..624ee5ab4183 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -538,12 +538,13 @@ static size_t rtnl_link_get_size(const struct net_device *dev)
 }
 
 static LIST_HEAD(rtnl_af_ops);
+static DECLARE_RWSEM(af_ops_sem);
 
 static const struct rtnl_af_ops *rtnl_af_lookup(const int family)
 {
 	const struct rtnl_af_ops *ops;
 
-	list_for_each_entry_rcu(ops, &rtnl_af_ops, list) {
+	list_for_each_entry(ops, &rtnl_af_ops, list) {
 		if (ops->family == family)
 			return ops;
 	}
@@ -559,9 +560,9 @@ static const struct rtnl_af_ops *rtnl_af_lookup(const int family)
  */
 void rtnl_af_register(struct rtnl_af_ops *ops)
 {
-	rtnl_lock();
-	list_add_tail_rcu(&ops->list, &rtnl_af_ops);
-	rtnl_unlock();
+	down_write(&af_ops_sem);
+	list_add_tail(&ops->list, &rtnl_af_ops);
+	up_write(&af_ops_sem);
 }
 EXPORT_SYMBOL_GPL(rtnl_af_register);
 
@@ -571,11 +572,9 @@ EXPORT_SYMBOL_GPL(rtnl_af_register);
  */
 void rtnl_af_unregister(struct rtnl_af_ops *ops)
 {
-	rtnl_lock();
-	list_del_rcu(&ops->list);
-	rtnl_unlock();
-
-	synchronize_rcu();
+	down_write(&af_ops_sem);
+	list_del(&ops->list);
+	up_write(&af_ops_sem);
 }
 EXPORT_SYMBOL_GPL(rtnl_af_unregister);
 
@@ -588,15 +587,15 @@ static size_t rtnl_link_get_af_size(const struct net_device *dev,
 	/* IFLA_AF_SPEC */
 	size = nla_total_size(sizeof(struct nlattr));
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(af_ops, &rtnl_af_ops, list) {
+	down_read(&af_ops_sem);
+	list_for_each_entry(af_ops, &rtnl_af_ops, list) {
 		if (af_ops->get_link_af_size) {
 			/* AF_* + nested data */
 			size += nla_total_size(sizeof(struct nlattr)) +
 				af_ops->get_link_af_size(dev, ext_filter_mask);
 		}
 	}
-	rcu_read_unlock();
+	up_read(&af_ops_sem);
 
 	return size;
 }
@@ -1603,7 +1602,7 @@ static int rtnl_fill_link_af(struct sk_buff *skb,
 	if (!af_spec)
 		return -EMSGSIZE;
 
-	list_for_each_entry_rcu(af_ops, &rtnl_af_ops, list) {
+	list_for_each_entry(af_ops, &rtnl_af_ops, list) {
 		struct nlattr *af;
 		int err;
 
@@ -1811,10 +1810,10 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put(skb, IFLA_PERM_ADDRESS, dev->addr_len, dev->perm_addr))
 		goto nla_put_failure;
 
-	rcu_read_lock();
+	down_read(&af_ops_sem);
 	if (rtnl_fill_link_af(skb, dev, ext_filter_mask))
-		goto nla_put_failure_rcu;
-	rcu_read_unlock();
+		goto nla_put_failure_sem;
+	up_read(&af_ops_sem);
 
 	if (rtnl_fill_prop_list(skb, dev))
 		goto nla_put_failure;
@@ -1822,8 +1821,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	nlmsg_end(skb, nlh);
 	return 0;
 
-nla_put_failure_rcu:
-	rcu_read_unlock();
+nla_put_failure_sem:
+	up_read(&af_ops_sem);
 nla_put_failure:
 	nlmsg_cancel(skb, nlh);
 	return -EMSGSIZE;
@@ -2274,27 +2273,27 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[])
 		nla_for_each_nested(af, tb[IFLA_AF_SPEC], rem) {
 			const struct rtnl_af_ops *af_ops;
 
-			rcu_read_lock();
+			down_read(&af_ops_sem);
 			af_ops = rtnl_af_lookup(nla_type(af));
 			if (!af_ops) {
-				rcu_read_unlock();
+				up_read(&af_ops_sem);
 				return -EAFNOSUPPORT;
 			}
 
 			if (!af_ops->set_link_af) {
-				rcu_read_unlock();
+				up_read(&af_ops_sem);
 				return -EOPNOTSUPP;
 			}
 
 			if (af_ops->validate_link_af) {
 				err = af_ops->validate_link_af(dev, af);
 				if (err < 0) {
-					rcu_read_unlock();
+					up_read(&af_ops_sem);
 					return err;
 				}
 			}
 
-			rcu_read_unlock();
+			up_read(&af_ops_sem);
 		}
 	}
 
@@ -2868,17 +2867,16 @@ static int do_setlink(const struct sk_buff *skb,
 		nla_for_each_nested(af, tb[IFLA_AF_SPEC], rem) {
 			const struct rtnl_af_ops *af_ops;
 
-			rcu_read_lock();
-
+			down_read(&af_ops_sem);
 			BUG_ON(!(af_ops = rtnl_af_lookup(nla_type(af))));
 
 			err = af_ops->set_link_af(dev, af, extack);
 			if (err < 0) {
-				rcu_read_unlock();
+				up_read(&af_ops_sem);
 				goto errout;
 			}
 
-			rcu_read_unlock();
+			up_read(&af_ops_sem);
 			status |= DO_SETLINK_NOTIFY;
 		}
 	}
@@ -5204,8 +5202,8 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		if (!attr)
 			goto nla_put_failure;
 
-		rcu_read_lock();
-		list_for_each_entry_rcu(af_ops, &rtnl_af_ops, list) {
+		down_read(&af_ops_sem);
+		list_for_each_entry(af_ops, &rtnl_af_ops, list) {
 			if (af_ops->fill_stats_af) {
 				struct nlattr *af;
 				int err;
@@ -5213,7 +5211,7 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 				af = nla_nest_start_noflag(skb,
 							   af_ops->family);
 				if (!af) {
-					rcu_read_unlock();
+					up_read(&af_ops_sem);
 					goto nla_put_failure;
 				}
 				err = af_ops->fill_stats_af(skb, dev);
@@ -5221,14 +5219,14 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 				if (err == -ENODATA) {
 					nla_nest_cancel(skb, af);
 				} else if (err < 0) {
-					rcu_read_unlock();
+					up_read(&af_ops_sem);
 					goto nla_put_failure;
 				}
 
 				nla_nest_end(skb, af);
 			}
 		}
-		rcu_read_unlock();
+		up_read(&af_ops_sem);
 
 		nla_nest_end(skb, attr);
 
@@ -5297,8 +5295,8 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
 		/* for IFLA_STATS_AF_SPEC */
 		size += nla_total_size(0);
 
-		rcu_read_lock();
-		list_for_each_entry_rcu(af_ops, &rtnl_af_ops, list) {
+		down_read(&af_ops_sem);
+		list_for_each_entry(af_ops, &rtnl_af_ops, list) {
 			if (af_ops->get_stats_af_size) {
 				size += nla_total_size(
 					af_ops->get_stats_af_size(dev));
@@ -5307,7 +5305,7 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
 				size += nla_total_size(0);
 			}
 		}
-		rcu_read_unlock();
+		up_read(&af_ops_sem);
 	}
 
 	return size;
-- 
2.25.1

