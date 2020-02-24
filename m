Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5B516AD10
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgBXRVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:21:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57113 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbgBXRV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:21:28 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j6HQ5-0004D9-89; Mon, 24 Feb 2020 17:21:25 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v4 7/9] net-sysfs: add netdev_change_owner()
Date:   Mon, 24 Feb 2020 18:21:08 +0100
Message-Id: <20200224172110.4121492-8-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224172110.4121492-1-christian.brauner@ubuntu.com>
References: <20200224172110.4121492-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function to change the owner of a network device when it is moved
between network namespaces.

Currently, when moving network devices between network namespaces the
ownership of the corresponding sysfs entries is not changed. This leads
to problems when tools try to operate on the corresponding sysfs files.
This leads to a bug whereby a network device that is created in a
network namespaces owned by a user namespace will have its corresponding
sysfs entry owned by the root user of the corresponding user namespace.
If such a network device has to be moved back to the host network
namespace the permissions will still be set to the user namespaces. This
means unprivileged users can e.g. trigger uevents for such incorrectly
owned devices. They can also modify the settings of the device itself.
Both of these things are unwanted.

For example, workloads will create network devices in the host network
namespace. Other tools will then proceed to move such devices between
network namespaces owner by other user namespaces. While the ownership
of the device itself is updated in
net/core/net-sysfs.c:dev_change_net_namespace() the corresponding sysfs
entry for the device is not:

drwxr-xr-x 5 nobody nobody    0 Jan 25 18:08 .
drwxr-xr-x 9 nobody nobody    0 Jan 25 18:08 ..
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 addr_assign_type
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 addr_len
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 address
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 broadcast
-rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_changes
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_down_count
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_up_count
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dev_id
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dev_port
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dormant
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 duplex
-rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 flags
-rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 gro_flush_timeout
-rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 ifalias
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 ifindex
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 iflink
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 link_mode
-rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 mtu
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 name_assign_type
-rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 netdev_group
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 operstate
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_port_id
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_port_name
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_switch_id
drwxr-xr-x 2 nobody nobody    0 Jan 25 18:09 power
-rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 proto_down
drwxr-xr-x 4 nobody nobody    0 Jan 25 18:09 queues
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 speed
drwxr-xr-x 2 nobody nobody    0 Jan 25 18:09 statistics
lrwxrwxrwx 1 nobody nobody    0 Jan 25 18:08 subsystem -> ../../../../class/net
-rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 tx_queue_len
-r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 type
-rw-r--r-- 1 nobody nobody 4096 Jan 25 18:08 uevent

However, if a device is created directly in the network namespace then
the device's sysfs permissions will be correctly updated:

drwxr-xr-x 5 root   root      0 Jan 25 18:12 .
drwxr-xr-x 9 nobody nobody    0 Jan 25 18:08 ..
-r--r--r-- 1 root   root   4096 Jan 25 18:12 addr_assign_type
-r--r--r-- 1 root   root   4096 Jan 25 18:12 addr_len
-r--r--r-- 1 root   root   4096 Jan 25 18:12 address
-r--r--r-- 1 root   root   4096 Jan 25 18:12 broadcast
-rw-r--r-- 1 root   root   4096 Jan 25 18:12 carrier
-r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_changes
-r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_down_count
-r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_up_count
-r--r--r-- 1 root   root   4096 Jan 25 18:12 dev_id
-r--r--r-- 1 root   root   4096 Jan 25 18:12 dev_port
-r--r--r-- 1 root   root   4096 Jan 25 18:12 dormant
-r--r--r-- 1 root   root   4096 Jan 25 18:12 duplex
-rw-r--r-- 1 root   root   4096 Jan 25 18:12 flags
-rw-r--r-- 1 root   root   4096 Jan 25 18:12 gro_flush_timeout
-rw-r--r-- 1 root   root   4096 Jan 25 18:12 ifalias
-r--r--r-- 1 root   root   4096 Jan 25 18:12 ifindex
-r--r--r-- 1 root   root   4096 Jan 25 18:12 iflink
-r--r--r-- 1 root   root   4096 Jan 25 18:12 link_mode
-rw-r--r-- 1 root   root   4096 Jan 25 18:12 mtu
-r--r--r-- 1 root   root   4096 Jan 25 18:12 name_assign_type
-rw-r--r-- 1 root   root   4096 Jan 25 18:12 netdev_group
-r--r--r-- 1 root   root   4096 Jan 25 18:12 operstate
-r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_port_id
-r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_port_name
-r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_switch_id
drwxr-xr-x 2 root   root      0 Jan 25 18:12 power
-rw-r--r-- 1 root   root   4096 Jan 25 18:12 proto_down
drwxr-xr-x 4 root   root      0 Jan 25 18:12 queues
-r--r--r-- 1 root   root   4096 Jan 25 18:12 speed
drwxr-xr-x 2 root   root      0 Jan 25 18:12 statistics
lrwxrwxrwx 1 nobody nobody    0 Jan 25 18:12 subsystem -> ../../../../class/net
-rw-r--r-- 1 root   root   4096 Jan 25 18:12 tx_queue_len
-r--r--r-- 1 root   root   4096 Jan 25 18:12 type
-rw-r--r-- 1 root   root   4096 Jan 25 18:12 uevent

Now, when creating a network device in a network namespace owned by a
user namespace and moving it to the host the permissions will be set to
the id that the user namespace root user has been mapped to on the host
leading to all sorts of permission issues:

458752
drwxr-xr-x 5 458752 458752      0 Jan 25 18:12 .
drwxr-xr-x 9 root   root        0 Jan 25 18:08 ..
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 addr_assign_type
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 addr_len
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 address
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 broadcast
-rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_changes
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_down_count
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_up_count
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dev_id
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dev_port
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dormant
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 duplex
-rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 flags
-rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 gro_flush_timeout
-rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 ifalias
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 ifindex
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 iflink
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 link_mode
-rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 mtu
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 name_assign_type
-rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 netdev_group
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 operstate
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_port_id
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_port_name
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_switch_id
drwxr-xr-x 2 458752 458752      0 Jan 25 18:12 power
-rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 proto_down
drwxr-xr-x 4 458752 458752      0 Jan 25 18:12 queues
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 speed
drwxr-xr-x 2 458752 458752      0 Jan 25 18:12 statistics
lrwxrwxrwx 1 root   root        0 Jan 25 18:12 subsystem -> ../../../../class/net
-rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 tx_queue_len
-r--r--r-- 1 458752 458752   4096 Jan 25 18:12 type
-rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 uevent

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v2 */
unchanged

/* v3 */
-  Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
   - Add explicit uid/gid parameters.

/* v4 */
unchanged
---
 net/core/net-sysfs.c | 27 +++++++++++++++++++++++++++
 net/core/net-sysfs.h |  2 ++
 2 files changed, 29 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4c826b8bf9b1..e19967665cb0 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1767,6 +1767,33 @@ int netdev_register_kobject(struct net_device *ndev)
 	return error;
 }
 
+/* Change owner for sysfs entries when moving network devices across network
+ * namespaces owned by different user namespaces.
+ */
+int netdev_change_owner(struct net_device *ndev, const struct net *net_old,
+			const struct net *net_new)
+{
+	struct device *dev = &ndev->dev;
+	kuid_t old_uid, new_uid;
+	kgid_t old_gid, new_gid;
+	int error;
+
+	net_ns_get_ownership(net_old, &old_uid, &old_gid);
+	net_ns_get_ownership(net_new, &new_uid, &new_gid);
+
+	/* The network namespace was changed but the owning user namespace is
+	 * identical so there's no need to change the owner of sysfs entries.
+	 */
+	if (uid_eq(old_uid, new_uid) && gid_eq(old_gid, new_gid))
+		return 0;
+
+	error = device_change_owner(dev, new_uid, new_gid);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 int netdev_class_create_file_ns(const struct class_attribute *class_attr,
 				const void *ns)
 {
diff --git a/net/core/net-sysfs.h b/net/core/net-sysfs.h
index 006876c7b78d..8a5b04c2699a 100644
--- a/net/core/net-sysfs.h
+++ b/net/core/net-sysfs.h
@@ -8,5 +8,7 @@ void netdev_unregister_kobject(struct net_device *);
 int net_rx_queue_update_kobjects(struct net_device *, int old_num, int new_num);
 int netdev_queue_update_kobjects(struct net_device *net,
 				 int old_num, int new_num);
+int netdev_change_owner(struct net_device *, const struct net *net_old,
+			const struct net *net_new);
 
 #endif
-- 
2.25.1

