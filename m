Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8681DA947
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgETEdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgETEdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 00:33:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D504EC061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:33:43 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j21so852810pgb.7
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kK249+zYFnOrRN7LIA5KrsG/PShQF3xdchiUSg4SigE=;
        b=WfK76uf09uD8FfkI6GVAGCqjBzTTamZph1pMKnKmhVwNIK1sPVHdFllXoeldaK5TgH
         SWLGKQev4mATy4DZT03PYOHj3mzkH93IAf91S1KRa+iTx1Q9l/lYiyH+NOg6wWCqyatc
         90z3rOEnS0Fnt7uhJQ+GmHvpvMWOnU9TNiltc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kK249+zYFnOrRN7LIA5KrsG/PShQF3xdchiUSg4SigE=;
        b=AKPJcqd2e8GYhCSG2T0f9a5mwYtnirep5te2QfuKrm8HOicRPJGuKlUPmAvt74bTO2
         LhZstnyJ6+zU+VO1P+AjaSU2jy+yrR4NBYI8xfHa1esrKBxP2bDKxG4uhbuphVk5YQJt
         rnqt8XVRu+AFn7IpVePuoAaeY98+c0wzdHZSYrbhFXTQth3ZCsPAQzpuQg+zLNyuQ2e+
         431OOnBwEZH2TdQKBNngVMsjS4ldYGrEHl62uZ9xBBfs7299fKhKvihQbALZbIqbv7Xb
         qzaoUaqtS6LnDvgl8wGeuNA4FHp3FE8LtrbDC9Tg13NQPllZL5N296LBzAU4dGpLPgoP
         x46w==
X-Gm-Message-State: AOAM532tipB/BIdtErFIRj/3/AwWJAG1onzOIZ5zn/xuyNZrEJsMj/eb
        7zVr3qSGxfo7uuCdfMjPiyjIAQ==
X-Google-Smtp-Source: ABdhPJx3uGcZWCxrkHREM/yHSH+C/pxTDi5u0kTFHDBUJhVtTYpTclXNEtYnjDQ71ORaUhe+DTqRfw==
X-Received: by 2002:a62:8888:: with SMTP id l130mr2437273pfd.140.1589949223204;
        Tue, 19 May 2020 21:33:43 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id g17sm753250pgg.43.2020.05.19.21.33.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 21:33:42 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v2 3/5] nexthop: add support for notifiers
Date:   Tue, 19 May 2020 21:33:32 -0700
Message-Id: <1589949214-14711-4-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589949214-14711-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589949214-14711-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This patch adds nexthop add/del notifiers. To be used by
vxlan driver in a later patch. Could possibly be used by
switchdev drivers in the future.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 include/net/netns/nexthop.h |  1 +
 include/net/nexthop.h       | 12 ++++++++++++
 net/ipv4/nexthop.c          | 26 ++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/include/net/netns/nexthop.h b/include/net/netns/nexthop.h
index c712ee5..1937476 100644
--- a/include/net/netns/nexthop.h
+++ b/include/net/netns/nexthop.h
@@ -14,5 +14,6 @@ struct netns_nexthop {
 
 	unsigned int		seq;		/* protected by rtnl_mutex */
 	u32			last_id_allocated;
+	struct atomic_notifier_head notifier_chain;
 };
 #endif
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index d929c98..4c95168 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -10,6 +10,7 @@
 #define __LINUX_NEXTHOP_H
 
 #include <linux/netdevice.h>
+#include <linux/notifier.h>
 #include <linux/route.h>
 #include <linux/types.h>
 #include <net/ip_fib.h>
@@ -102,6 +103,17 @@ struct nexthop {
 	};
 };
 
+enum nexthop_event_type {
+	NEXTHOP_EVENT_ADD,
+	NEXTHOP_EVENT_DEL
+};
+
+int call_nexthop_notifier(struct notifier_block *nb, struct net *net,
+			  enum nexthop_event_type event_type,
+			  struct nexthop *nh);
+int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
+int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
+
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
 void nexthop_free_rcu(struct rcu_head *head);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index bf91edc..39f4957 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -36,6 +36,17 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 	[NHA_FDB]		= { .type = NLA_FLAG },
 };
 
+static int call_nexthop_notifiers(struct net *net,
+				  enum fib_event_type event_type,
+				  struct nexthop *nh)
+{
+	int err;
+
+	err = atomic_notifier_call_chain(&net->nexthop.notifier_chain,
+					 event_type, nh);
+	return notifier_to_errno(err);
+}
+
 static unsigned int nh_dev_hashfn(unsigned int val)
 {
 	unsigned int mask = NH_DEV_HASHSIZE - 1;
@@ -826,6 +837,8 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 	bool do_flush = false;
 	struct fib_info *fi;
 
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
+
 	list_for_each_entry(fi, &nh->fi_list, nh_list) {
 		fi->fib_flags |= RTNH_F_DEAD;
 		do_flush = true;
@@ -1865,6 +1878,19 @@ static struct notifier_block nh_netdev_notifier = {
 	.notifier_call = nh_netdev_event,
 };
 
+int register_nexthop_notifier(struct net *net, struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&net->nexthop.notifier_chain, nb);
+}
+EXPORT_SYMBOL(register_nexthop_notifier);
+
+int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&net->nexthop.notifier_chain,
+						nb);
+}
+EXPORT_SYMBOL(unregister_nexthop_notifier);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
-- 
2.1.4

