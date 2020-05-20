Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EDF1DBCBA
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgETSXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgETSXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:23:21 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1957C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:23:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f15so1689581plr.3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kK249+zYFnOrRN7LIA5KrsG/PShQF3xdchiUSg4SigE=;
        b=QiuU9HmUKWTNTJfcS5og7bTYQEGTyASpEL/fvPz4rweKY6nmtes6Rmz7s0cwa7Imxg
         ER5ncxUAVFUIfoPZ9sQXxkXSMJuVuC7RFZGnjBJBUUD+kHoTFsuBXnqTXg1zVSoras5u
         WTZFodsgGsjYWjMYTWi1nvTlEHcd22yXGXkLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kK249+zYFnOrRN7LIA5KrsG/PShQF3xdchiUSg4SigE=;
        b=h8Qmxa5DzHovv3WWb1ioKmAfvVlEDVUA33saOWdVrtchQhHme8TlsJfnzt5dkKp6tq
         /EoC462uQpDtC4ggCAFk6v+OG1GBLF8cnU4LC9TKClu9yXKZSyA+9EfYA6S11aSCRbLf
         1BZ7PTxKezz8kjB5OvDksjCmMVLpFMKb2mqlKoHmsKB9emsSPGlfuHypc0GScnBSBXLN
         efsfqBEc7GDAVJPSPm/CB8PQWNMjcZD2JIkP6UQkVjTNjZG8XJcJ/btEZkJRM0ovBl5B
         Ssx4oB9MrfVoVqSsppNXBR6WknST4bKGm6IaSj/a+7Cdkzd/O08ejfn3QIbt4SMwOViY
         GAdg==
X-Gm-Message-State: AOAM532fAQo4gWzSXvgsPNTyrE0bFPFUQGjim3TzLs51cmZwjBV4HVbT
        2yBUt3J+3KQgDrLOPTtMys3/vA==
X-Google-Smtp-Source: ABdhPJwsP1mBi4hryGRZAhvcCIhCOjBI18CYXyRMu/S37XG4BEM+o48oIdMCJ9oPy3qHUeT9qAuLrQ==
X-Received: by 2002:a17:90a:589:: with SMTP id i9mr6707860pji.156.1589999000396;
        Wed, 20 May 2020 11:23:20 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id d184sm2490238pfc.130.2020.05.20.11.23.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 May 2020 11:23:19 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v3 3/5] nexthop: add support for notifiers
Date:   Wed, 20 May 2020 11:23:09 -0700
Message-Id: <1589998991-40120-4-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589998991-40120-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589998991-40120-1-git-send-email-roopa@cumulusnetworks.com>
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

