Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270B81C4993
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 00:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgEDW2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 18:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728209AbgEDW2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 18:28:32 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801B2C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 15:28:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a5so114432pjh.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 15:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qic54R4NggcJN+/5ioaMrmL7rZZprEXwI9Tmar3DcZQ=;
        b=H+uF5EuJN+WWf5ZI0vtjtGgsmzpUm7fBHcZ2sMHxFpn+veC4ynt8pcHwf44aV3bEbm
         WAZom3ifyYJYTqfuwYElUSPxDsa5jEhkLXrsEeHERtM6c3xJcankkiZxaMXedRWhKVOc
         ZPYeCzm64acvZdcFU0RzZkPMSmMPjZMGzIU14=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qic54R4NggcJN+/5ioaMrmL7rZZprEXwI9Tmar3DcZQ=;
        b=U5NBILfz0p9FzQzaO/nNibnmv8Lqnigc517AopVMZqNGDBDex3HpA+rUrb0+sMjuNJ
         ySnudy2B2pjGjtIHqor93hLPPlbB3hRezI5mfOEpeycurVPwM524V3D9xtzbt8PNH46D
         s0ZGsfm5GVwWHIgszn0gK1ZteAmDKIE+N72ME0dkdS2mNZqkhclHv3U7II5QL/73QtPq
         6SFwVsaY/OP8zN5B0zvHYINscUxMLnAosklohS7UxGn7ilb85QqkxONcBIHQQ4buCZzt
         cdZakOc4AXYJ+SMLwdMryx/GivF7GpTbAvqUIuinyhNneHHM8SCLfQGLPPwsDlEpSIt7
         4oyA==
X-Gm-Message-State: AGi0PuZEvQrxfOsXzpWp8PI9EBwrTYU2oqwju/gmKsez3A+huFpg0Rg7
        5TZeWkbA7fUiWqMRvIKdc7t5RQ==
X-Google-Smtp-Source: APiQypIC/100T8gDZL/jwUSbRhAQrfYNvAcSqJe1b4sFicdGbT17gSiNmYm4HIgxurK/cEZNNN1/UQ==
X-Received: by 2002:a17:902:7203:: with SMTP id ba3mr152257plb.202.1588631312051;
        Mon, 04 May 2020 15:28:32 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id ie17sm21213pjb.19.2020.05.04.15.28.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 15:28:31 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        idosch@mellanox.com, jiri@mellanox.com, petrm@mellanox.com
Subject: [RFC PATCH net-next 3/5] nexthop: add support for notifiers
Date:   Mon,  4 May 2020 15:28:19 -0700
Message-Id: <1588631301-21564-4-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
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
 net/ipv4/nexthop.c          | 27 +++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

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
index 3ad4e97..0301740 100644
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
+int register_nexthop_notifier(struct notifier_block *nb);
+int unregister_nexthop_notifier(struct notifier_block *nb);
+
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
 void nexthop_free_rcu(struct rcu_head *head);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 98f8d2a..514bb4e 100644
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
@@ -814,6 +825,8 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 		ipv6_stub->ip6_del_rt(net, f6i,
 				      !net->ipv4.sysctl_nexthop_compat_mode);
 	}
+
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
 }
 
 static void __remove_nexthop(struct net *net, struct nexthop *nh,
@@ -1838,6 +1851,20 @@ static struct notifier_block nh_netdev_notifier = {
 	.notifier_call = nh_netdev_event,
 };
 
+static ATOMIC_NOTIFIER_HEAD(nexthop_notif_chain);
+
+int register_nexthop_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&nexthop_notif_chain, nb);
+}
+EXPORT_SYMBOL(register_nexthop_notifier);
+
+int unregister_nexthop_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&nexthop_notif_chain, nb);
+}
+EXPORT_SYMBOL(unregister_nexthop_notifier);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
-- 
2.1.4

