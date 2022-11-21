Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F53631D35
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiKUJrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiKUJrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:47:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D320697362;
        Mon, 21 Nov 2022 01:47:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 924D6B80DB8;
        Mon, 21 Nov 2022 09:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55D0C433D6;
        Mon, 21 Nov 2022 09:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669024023;
        bh=HIQ2aiXqHffXudy5bIIYyTtVPp45N10Zp+on4Ytbzt0=;
        h=From:To:Cc:Subject:Date:From;
        b=kRtjkGLcpaTdluA3MPqMp/OBRucZ44PHfZF34mfgf17QHkP/8YR46Hx5a1OmHu3Qw
         g0wIN1z30f2VFu1U77SsQhX9sJ2xbc06dCKwkdmPZpStPUOS68E68yqUjdgcz/w2cT
         pe6PY7zlJEOK+AXvuPmP0FqRNQkYwoLnGxO2KQIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>, linux-nfs@vger.kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 1/5] kobject: make kobject_get_ownership() take a constant kobject *
Date:   Mon, 21 Nov 2022 10:46:45 +0100
Message-Id: <20221121094649.1556002-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9144; i=gregkh@linuxfoundation.org; h=from:subject; bh=HIQ2aiXqHffXudy5bIIYyTtVPp45N10Zp+on4Ytbzt0=; b=owGbwMvMwCRo6H6F97bub03G02pJDMnVnuw5ldPS6tKre1+vkzhzoFdmhsH6vHieSzff35Fs1svn eKzSEcvCIMjEICumyPJlG8/R/RWHFL0MbU/DzGFlAhnCwMUpABNJMGCY73nXbtrMz9Mbph3mjDrW6H 6W8biNIcOCpR4Jy/NfcTjI9PU2vu+58azV6uJDAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call, kobject_get_ownership(), does not modify the kobject passed
into it, so make it const.  This propagates down into the kobj_type
function callbacks so make the kobject passed into them also const,
ensuring that nothing in the kobject is being changed here.

This helps make it more obvious what calls and callbacks do, and do not,
modify structures passed to them.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org
Cc: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/class.c    | 2 +-
 drivers/base/core.c     | 8 ++++----
 fs/nfs/sysfs.c          | 4 ++--
 include/linux/kobject.h | 8 ++++----
 lib/kobject.c           | 4 ++--
 net/bridge/br_if.c      | 2 +-
 net/core/net-sysfs.c    | 8 ++++----
 net/sunrpc/sysfs.c      | 8 ++++----
 8 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 8ceafb7d0203..86ec554cfe60 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -62,7 +62,7 @@ static void class_release(struct kobject *kobj)
 	kfree(cp);
 }
 
-static const struct kobj_ns_type_operations *class_child_ns_type(struct kobject *kobj)
+static const struct kobj_ns_type_operations *class_child_ns_type(const struct kobject *kobj)
 {
 	struct subsys_private *cp = to_subsys_private(kobj);
 	struct class *class = cp->class;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index ab01828fe6c1..a79b99ecf4d8 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2335,7 +2335,7 @@ static void device_release(struct kobject *kobj)
 	kfree(p);
 }
 
-static const void *device_namespace(struct kobject *kobj)
+static const void *device_namespace(const struct kobject *kobj)
 {
 	const struct device *dev = kobj_to_dev(kobj);
 	const void *ns = NULL;
@@ -2346,7 +2346,7 @@ static const void *device_namespace(struct kobject *kobj)
 	return ns;
 }
 
-static void device_get_ownership(struct kobject *kobj, kuid_t *uid, kgid_t *gid)
+static void device_get_ownership(const struct kobject *kobj, kuid_t *uid, kgid_t *gid)
 {
 	const struct device *dev = kobj_to_dev(kobj);
 
@@ -2986,9 +2986,9 @@ static void class_dir_release(struct kobject *kobj)
 }
 
 static const
-struct kobj_ns_type_operations *class_dir_child_ns_type(struct kobject *kobj)
+struct kobj_ns_type_operations *class_dir_child_ns_type(const struct kobject *kobj)
 {
-	struct class_dir *dir = to_class_dir(kobj);
+	const struct class_dir *dir = to_class_dir(kobj);
 	return dir->class->ns_type;
 }
 
diff --git a/fs/nfs/sysfs.c b/fs/nfs/sysfs.c
index a6f740366963..67a87800b3a9 100644
--- a/fs/nfs/sysfs.c
+++ b/fs/nfs/sysfs.c
@@ -26,7 +26,7 @@ static void nfs_netns_object_release(struct kobject *kobj)
 }
 
 static const struct kobj_ns_type_operations *nfs_netns_object_child_ns_type(
-		struct kobject *kobj)
+		const struct kobject *kobj)
 {
 	return &net_ns_type_operations;
 }
@@ -130,7 +130,7 @@ static void nfs_netns_client_release(struct kobject *kobj)
 	kfree(c);
 }
 
-static const void *nfs_netns_client_namespace(struct kobject *kobj)
+static const void *nfs_netns_client_namespace(const struct kobject *kobj)
 {
 	return container_of(kobj, struct nfs_netns_client, kobject)->net;
 }
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index fc40fc81aeb1..d978dbceb50d 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -113,7 +113,7 @@ extern struct kobject * __must_check kobject_get_unless_zero(
 extern void kobject_put(struct kobject *kobj);
 
 extern const void *kobject_namespace(struct kobject *kobj);
-extern void kobject_get_ownership(struct kobject *kobj,
+extern void kobject_get_ownership(const struct kobject *kobj,
 				  kuid_t *uid, kgid_t *gid);
 extern char *kobject_get_path(const struct kobject *kobj, gfp_t flag);
 
@@ -121,9 +121,9 @@ struct kobj_type {
 	void (*release)(struct kobject *kobj);
 	const struct sysfs_ops *sysfs_ops;
 	const struct attribute_group **default_groups;
-	const struct kobj_ns_type_operations *(*child_ns_type)(struct kobject *kobj);
-	const void *(*namespace)(struct kobject *kobj);
-	void (*get_ownership)(struct kobject *kobj, kuid_t *uid, kgid_t *gid);
+	const struct kobj_ns_type_operations *(*child_ns_type)(const struct kobject *kobj);
+	const void *(*namespace)(const struct kobject *kobj);
+	void (*get_ownership)(const struct kobject *kobj, kuid_t *uid, kgid_t *gid);
 };
 
 struct kobj_uevent_env {
diff --git a/lib/kobject.c b/lib/kobject.c
index ba1017cd67d1..26e744a46d24 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -45,7 +45,7 @@ const void *kobject_namespace(struct kobject *kobj)
  * representation of given kobject. Normally used to adjust ownership of
  * objects in a container.
  */
-void kobject_get_ownership(struct kobject *kobj, kuid_t *uid, kgid_t *gid)
+void kobject_get_ownership(const struct kobject *kobj, kuid_t *uid, kgid_t *gid)
 {
 	*uid = GLOBAL_ROOT_UID;
 	*gid = GLOBAL_ROOT_GID;
@@ -907,7 +907,7 @@ static void kset_release(struct kobject *kobj)
 	kfree(kset);
 }
 
-static void kset_get_ownership(struct kobject *kobj, kuid_t *uid, kgid_t *gid)
+static void kset_get_ownership(const struct kobject *kobj, kuid_t *uid, kgid_t *gid)
 {
 	if (kobj->parent)
 		kobject_get_ownership(kobj->parent, uid, gid);
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 228fd5b20f10..ad13b48e3e08 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -262,7 +262,7 @@ static void release_nbp(struct kobject *kobj)
 	kfree(p);
 }
 
-static void brport_get_ownership(struct kobject *kobj, kuid_t *uid, kgid_t *gid)
+static void brport_get_ownership(const struct kobject *kobj, kuid_t *uid, kgid_t *gid)
 {
 	struct net_bridge_port *p = kobj_to_brport(kobj);
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index a8c5a7cd9701..9cfc80b8ed25 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1020,7 +1020,7 @@ static void rx_queue_release(struct kobject *kobj)
 	netdev_put(queue->dev, &queue->dev_tracker);
 }
 
-static const void *rx_queue_namespace(struct kobject *kobj)
+static const void *rx_queue_namespace(const struct kobject *kobj)
 {
 	struct netdev_rx_queue *queue = to_rx_queue(kobj);
 	struct device *dev = &queue->dev->dev;
@@ -1032,7 +1032,7 @@ static const void *rx_queue_namespace(struct kobject *kobj)
 	return ns;
 }
 
-static void rx_queue_get_ownership(struct kobject *kobj,
+static void rx_queue_get_ownership(const struct kobject *kobj,
 				   kuid_t *uid, kgid_t *gid)
 {
 	const struct net *net = rx_queue_namespace(kobj);
@@ -1623,7 +1623,7 @@ static void netdev_queue_release(struct kobject *kobj)
 	netdev_put(queue->dev, &queue->dev_tracker);
 }
 
-static const void *netdev_queue_namespace(struct kobject *kobj)
+static const void *netdev_queue_namespace(const struct kobject *kobj)
 {
 	struct netdev_queue *queue = to_netdev_queue(kobj);
 	struct device *dev = &queue->dev->dev;
@@ -1635,7 +1635,7 @@ static const void *netdev_queue_namespace(struct kobject *kobj)
 	return ns;
 }
 
-static void netdev_queue_get_ownership(struct kobject *kobj,
+static void netdev_queue_get_ownership(const struct kobject *kobj,
 				       kuid_t *uid, kgid_t *gid)
 {
 	const struct net *net = netdev_queue_namespace(kobj);
diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index c1f559892ae8..1e05a2d723f4 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -31,7 +31,7 @@ static void rpc_sysfs_object_release(struct kobject *kobj)
 }
 
 static const struct kobj_ns_type_operations *
-rpc_sysfs_object_child_ns_type(struct kobject *kobj)
+rpc_sysfs_object_child_ns_type(const struct kobject *kobj)
 {
 	return &net_ns_type_operations;
 }
@@ -381,17 +381,17 @@ static void rpc_sysfs_xprt_release(struct kobject *kobj)
 	kfree(xprt);
 }
 
-static const void *rpc_sysfs_client_namespace(struct kobject *kobj)
+static const void *rpc_sysfs_client_namespace(const struct kobject *kobj)
 {
 	return container_of(kobj, struct rpc_sysfs_client, kobject)->net;
 }
 
-static const void *rpc_sysfs_xprt_switch_namespace(struct kobject *kobj)
+static const void *rpc_sysfs_xprt_switch_namespace(const struct kobject *kobj)
 {
 	return container_of(kobj, struct rpc_sysfs_xprt_switch, kobject)->net;
 }
 
-static const void *rpc_sysfs_xprt_namespace(struct kobject *kobj)
+static const void *rpc_sysfs_xprt_namespace(const struct kobject *kobj)
 {
 	return container_of(kobj, struct rpc_sysfs_xprt,
 			    kobject)->xprt->xprt_net;
-- 
2.38.1

