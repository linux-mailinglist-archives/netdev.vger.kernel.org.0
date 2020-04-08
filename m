Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B401A24FE
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgDHPWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:22:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39079 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728772AbgDHPWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 11:22:38 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jMCXC-0001BO-7U; Wed, 08 Apr 2020 15:22:34 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/8] kobject_uevent: remove unneeded netlink_ns check
Date:   Wed,  8 Apr 2020 17:21:44 +0200
Message-Id: <20200408152151.5780-2-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408152151.5780-1-christian.brauner@ubuntu.com>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Back when I rewrote large chunks of uevent sending I should have removed
the .netlink_ns method completely after having removed it's last user in
[1]. Let's remove it now and also remove the helper associated with it
that is unused too.

Fixes: a3498436b3a0 ("netns: restrict uevents") /* No backport needed. */
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 Documentation/filesystems/sysfs-tagging.txt |  1 -
 include/linux/kobject_ns.h                  |  3 ---
 lib/kobject.c                               | 13 -------------
 lib/kobject_uevent.c                        |  2 +-
 net/core/net-sysfs.c                        |  6 ------
 5 files changed, 1 insertion(+), 24 deletions(-)

diff --git a/Documentation/filesystems/sysfs-tagging.txt b/Documentation/filesystems/sysfs-tagging.txt
index c7c8e6438958..51d28dd8b84f 100644
--- a/Documentation/filesystems/sysfs-tagging.txt
+++ b/Documentation/filesystems/sysfs-tagging.txt
@@ -37,6 +37,5 @@ Users of this interface:
 - define a type in the kobj_ns_type enumeration.
 - call kobj_ns_type_register() with its kobj_ns_type_operations which has
   - current_ns() which returns current's namespace
-  - netlink_ns() which returns a socket's namespace
   - initial_ns() which returns the initial namesapce
 - call kobj_ns_exit() when an individual tag is no longer valid
diff --git a/include/linux/kobject_ns.h b/include/linux/kobject_ns.h
index 069aa2ebef90..991a9286bcea 100644
--- a/include/linux/kobject_ns.h
+++ b/include/linux/kobject_ns.h
@@ -32,7 +32,6 @@ enum kobj_ns_type {
 /*
  * Callbacks so sysfs can determine namespaces
  *   @grab_current_ns: return a new reference to calling task's namespace
- *   @netlink_ns: return namespace to which a sock belongs (right?)
  *   @initial_ns: return the initial namespace (i.e. init_net_ns)
  *   @drop_ns: drops a reference to namespace
  */
@@ -40,7 +39,6 @@ struct kobj_ns_type_operations {
 	enum kobj_ns_type type;
 	bool (*current_may_mount)(void);
 	void *(*grab_current_ns)(void);
-	const void *(*netlink_ns)(struct sock *sk);
 	const void *(*initial_ns)(void);
 	void (*drop_ns)(void *);
 };
@@ -52,7 +50,6 @@ const struct kobj_ns_type_operations *kobj_ns_ops(struct kobject *kobj);
 
 bool kobj_ns_current_may_mount(enum kobj_ns_type type);
 void *kobj_ns_grab_current(enum kobj_ns_type type);
-const void *kobj_ns_netlink(enum kobj_ns_type type, struct sock *sk);
 const void *kobj_ns_initial(enum kobj_ns_type type);
 void kobj_ns_drop(enum kobj_ns_type type, void *ns);
 
diff --git a/lib/kobject.c b/lib/kobject.c
index 83198cb37d8d..6f07083cc111 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -1092,19 +1092,6 @@ void *kobj_ns_grab_current(enum kobj_ns_type type)
 }
 EXPORT_SYMBOL_GPL(kobj_ns_grab_current);
 
-const void *kobj_ns_netlink(enum kobj_ns_type type, struct sock *sk)
-{
-	const void *ns = NULL;
-
-	spin_lock(&kobj_ns_type_lock);
-	if ((type > KOBJ_NS_TYPE_NONE) && (type < KOBJ_NS_TYPES) &&
-	    kobj_ns_ops_tbl[type])
-		ns = kobj_ns_ops_tbl[type]->netlink_ns(sk);
-	spin_unlock(&kobj_ns_type_lock);
-
-	return ns;
-}
-
 const void *kobj_ns_initial(enum kobj_ns_type type)
 {
 	const void *ns = NULL;
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 7998affa45d4..a45b3eeaa2b9 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -400,7 +400,7 @@ static int kobject_uevent_net_broadcast(struct kobject *kobj,
 	 * are the only tag relevant here since we want to decide which
 	 * network namespaces to broadcast the uevent into.
 	 */
-	if (ops && ops->netlink_ns && kobj->ktype->namespace)
+	if (ops && kobj->ktype->namespace)
 		if (ops->type == KOBJ_NS_TYPE_NET)
 			net = kobj->ktype->namespace(kobj);
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4c826b8bf9b1..5d05e13a96cc 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1592,16 +1592,10 @@ static const void *net_initial_ns(void)
 	return &init_net;
 }
 
-static const void *net_netlink_ns(struct sock *sk)
-{
-	return sock_net(sk);
-}
-
 const struct kobj_ns_type_operations net_ns_type_operations = {
 	.type = KOBJ_NS_TYPE_NET,
 	.current_may_mount = net_current_may_mount,
 	.grab_current_ns = net_grab_current_ns,
-	.netlink_ns = net_netlink_ns,
 	.initial_ns = net_initial_ns,
 	.drop_ns = net_drop_ns,
 };
-- 
2.26.0

