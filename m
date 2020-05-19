Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D0D1D8D83
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 04:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgESCOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 22:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgESCOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 22:14:44 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35312C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:44 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t40so682094pjb.3
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mwm2Gn3RVUSYq6peuZAN7YZa8fScnz+SaOBaUqhVDYY=;
        b=MLZax+iyoC4RIE6Gm+TwHQylp4d+ivipFRgjXLVGLnB4ACrQNDbf2Xv/4/JIT5XdCR
         HehXLuOkjuBW2gLA9ekYJMUkIyO3bpR6Rydy8bFbyT69pr2bINIkE9feV8J3+vhP0bN9
         gTbibVqEXlVuf8RG5QIOJ8gNyGWyV6Gpc/f0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mwm2Gn3RVUSYq6peuZAN7YZa8fScnz+SaOBaUqhVDYY=;
        b=YI/+n6whwBNZKalkDnzxDJC/1tJlto+zlpxSBdKEEzS3PpCac33jdNiIVz6r0zXQ8D
         JeXoc7WNPkpnFV6Wb6UjVPAknq58L5+zAt1SPB9tzkBqumbnN1G0BA+zV+xWPp3cV0Ye
         v7UBB719Mtaw3asa16p42DqdkR823T+SHztaaep0ZAaS8JlScErKyqhb2zoX1yotZO5f
         C1+7SU4dSQ9Nzzsz27bUDC+zxdsIMsCI9bmrmuAMJdZZwGt4A3Jn+p+t/p7UcoV7lGby
         ugQYI3+cUV5/T0FPIVnra/4Co1+bmUhYiU3yEvHaXK6GsJyKsGc1l/xoerHTEW9wUPtY
         k6YA==
X-Gm-Message-State: AOAM531MVagikFw1yt2LL1N+en5L+FBzOsmWn129d6M5r23TDpfefQZQ
        1MnWYH3mXmaJyJk3UyTqGvFHlKPMuJA=
X-Google-Smtp-Source: ABdhPJzSHo48BDHju9mr0GudjroWO+IxKpxzz2diUITTU/4svORWmXcmzd0YDagDc9IvlnFxkgq8YQ==
X-Received: by 2002:a17:902:7897:: with SMTP id q23mr6607790pll.269.1589854483721;
        Mon, 18 May 2020 19:14:43 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id 5sm664753pjf.19.2020.05.18.19.14.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 19:14:43 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next 4/6] nexthop: add support for notifiers
Date:   Mon, 18 May 2020 19:14:32 -0700
Message-Id: <1589854474-26854-5-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
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
 net/ipv4/nexthop.c          | 28 ++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

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
index d314b27..a13ce753 100644
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
@@ -831,6 +842,8 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 	bool do_flush = false;
 	struct fib_info *fi;
 
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
+
 	list_for_each_entry(fi, &nh->fi_list, nh_list) {
 		fi->fib_flags |= RTNH_F_DEAD;
 		do_flush = true;
@@ -1867,6 +1880,21 @@ static struct notifier_block nh_netdev_notifier = {
 	.notifier_call = nh_netdev_event,
 };
 
+static ATOMIC_NOTIFIER_HEAD(nexthop_notif_chain);
+
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

