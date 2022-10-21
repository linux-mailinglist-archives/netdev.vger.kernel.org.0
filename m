Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D675607A98
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiJUP2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiJUP1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:27:24 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356DF24AE22;
        Fri, 21 Oct 2022 08:27:22 -0700 (PDT)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mv7bQ0Gnvz686w8;
        Fri, 21 Oct 2022 23:26:10 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 17:27:20 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:27:19 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
Subject: [PATCH v8 12/12] landlock: Document Landlock's network support
Date:   Fri, 21 Oct 2022 23:26:44 +0800
Message-ID: <20221021152644.155136-13-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describes network access rules for TCP sockets. Adds network access
example in the tutorial. Points out AF_UNSPEC socket family behaviour.
Adds kernel configuration support for network.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v7:
* Fixes documentaion logic errors and typos as Mickaёl suggested:
https://lore.kernel.org/netdev/9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net/

Changes since v6:
* Adds network support documentaion.

---
 Documentation/userspace-api/landlock.rst | 72 +++++++++++++++++++-----
 1 file changed, 59 insertions(+), 13 deletions(-)

diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
index d8cd8cd9ce25..d0610ec9ce05 100644
--- a/Documentation/userspace-api/landlock.rst
+++ b/Documentation/userspace-api/landlock.rst
@@ -11,10 +11,10 @@ Landlock: unprivileged access control
 :Date: October 2022

 The goal of Landlock is to enable to restrict ambient rights (e.g. global
-filesystem access) for a set of processes.  Because Landlock is a stackable
-LSM, it makes possible to create safe security sandboxes as new security layers
-in addition to the existing system-wide access-controls. This kind of sandbox
-is expected to help mitigate the security impact of bugs or
+filesystem or network access) for a set of processes.  Because Landlock
+is a stackable LSM, it makes possible to create safe security sandboxes as new
+security layers in addition to the existing system-wide access-controls. This
+kind of sandbox is expected to help mitigate the security impact of bugs or
 unexpected/malicious behaviors in user space applications.  Landlock empowers
 any process, including unprivileged ones, to securely restrict themselves.

@@ -30,18 +30,20 @@ Landlock rules

 A Landlock rule describes an action on an object.  An object is currently a
 file hierarchy, and the related filesystem actions are defined with `access
-rights`_.  A set of rules is aggregated in a ruleset, which can then restrict
-the thread enforcing it, and its future children.
+rights`_.  Since ABI version 4 a port data appears with related network actions
+for TCP socket families.  A set of rules is aggregated in a ruleset, which
+can then restrict the thread enforcing it, and its future children.

 Defining and enforcing a security policy
 ----------------------------------------

 We first need to define the ruleset that will contain our rules.  For this
 example, the ruleset will contain rules that only allow read actions, but write
-actions will be denied.  The ruleset then needs to handle both of these kind of
+actions will be denied. The ruleset then needs to handle both of these kind of
 actions.  This is required for backward and forward compatibility (i.e. the
 kernel and user space may not know each other's supported restrictions), hence
-the need to be explicit about the denied-by-default access rights.
+the need to be explicit about the denied-by-default access rights.  Also ruleset
+will have network rules for specific ports, so it should handle network actions.

 .. code-block:: c

@@ -62,6 +64,9 @@ the need to be explicit about the denied-by-default access rights.
             LANDLOCK_ACCESS_FS_MAKE_SYM |
             LANDLOCK_ACCESS_FS_REFER |
             LANDLOCK_ACCESS_FS_TRUNCATE,
+        .handled_access_net =
+            LANDLOCK_ACCESS_NET_BIND_TCP |
+            LANDLOCK_ACCESS_NET_CONNECT_TCP,
     };

 Because we may not know on which kernel version an application will be
@@ -70,14 +75,18 @@ should try to protect users as much as possible whatever the kernel they are
 using.  To avoid binary enforcement (i.e. either all security features or
 none), we can leverage a dedicated Landlock command to get the current version
 of the Landlock ABI and adapt the handled accesses.  Let's check if we should
-remove the ``LANDLOCK_ACCESS_FS_REFER`` or ``LANDLOCK_ACCESS_FS_TRUNCATE``
-access rights, which are only supported starting with the second and third
-version of the ABI.
+remove the `LANDLOCK_ACCESS_FS_REFER` or `LANDLOCK_ACCESS_FS_TRUNCATE` or
+network access rights, which are only supported starting with the second,
+third and fourth version of the ABI.

 .. code-block:: c

     int abi;

+    #define ACCESS_NET_BIND_CONNECT ( \
+    LANDLOCK_ACCESS_NET_BIND_TCP | \
+    LANDLOCK_ACCESS_NET_CONNECT_TCP)
+
     abi = landlock_create_ruleset(NULL, 0, LANDLOCK_CREATE_RULESET_VERSION);
     if (abi < 0) {
         /* Degrades gracefully if Landlock is not handled. */
@@ -92,6 +101,9 @@ version of the ABI.
     case 2:
         /* Removes LANDLOCK_ACCESS_FS_TRUNCATE for ABI < 3 */
         ruleset_attr.handled_access_fs &= ~LANDLOCK_ACCESS_FS_TRUNCATE;
+    case 3:
+        /* Removes network support for ABI < 4 */
+        ruleset_attr.handled_access_net &= ~ACCESS_NET_BIND_CONNECT;
     }

 This enables to create an inclusive ruleset that will contain our rules.
@@ -143,8 +155,22 @@ for the ruleset creation, by filtering access rights according to the Landlock
 ABI version.  In this example, this is not required because all of the requested
 ``allowed_access`` rights are already available in ABI 1.

+For network part we can add number of rules containing a port number and actions
+that a process is allowed to do for certian ports.
+
+.. code-block:: c
+
+    struct landlock_net_service_attr net_service = {
+        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
+        .port = 8080,
+    };
+
+    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
+                            &net_service, 0);
+
 We now have a ruleset with one rule allowing read access to ``/usr`` while
-denying all other handled accesses for the filesystem.  The next step is to
+denying all other handled accesses for the filesystem.  The ruleset also contains
+a rule allowing to bind current proccess to the port 8080.  The next step is to
 restrict the current thread from gaining more privileges (e.g. thanks to a SUID
 binary).

@@ -296,6 +322,13 @@ not.  It is also possible to pass such file descriptors between processes,
 keeping their Landlock properties, even when these processes do not have an
 enforced Landlock ruleset.

+AF_UNSPEC socket family
+-----------------------
+
+Sockets of AF_UNSPEC family types are treated as AF_INET(IPv4) socket for bind()
+action.  But connect() one is not allowed by Landlock for AF_UNSPEC sockets. This
+logic prevents from disconnecting already connected sockets.
+
 Compatibility
 =============

@@ -355,7 +388,7 @@ Access rights
 -------------

 .. kernel-doc:: include/uapi/linux/landlock.h
-    :identifiers: fs_access
+    :identifiers: fs_access net_access

 Creating a new ruleset
 ----------------------
@@ -374,6 +407,7 @@ Extending a ruleset

 .. kernel-doc:: include/uapi/linux/landlock.h
     :identifiers: landlock_rule_type landlock_path_beneath_attr
+                  landlock_net_service_attr

 Enforcing a ruleset
 -------------------
@@ -451,6 +485,13 @@ always allowed when using a kernel that only supports the first or second ABI.
 Starting with the Landlock ABI version 3, it is now possible to securely control
 truncation thanks to the new ``LANDLOCK_ACCESS_FS_TRUNCATE`` access right.

+Network support (ABI < 4)
+-------------------------
+
+Starting with the Landlock ABI version 4, it is now possible to restrict TCP
+sockets' bind() and connect() actions for specific ports allowing processes
+to establish restricted connections.
+
 .. _kernel_support:

 Kernel support
@@ -469,6 +510,11 @@ still enable it by adding ``lsm=landlock,[...]`` to
 Documentation/admin-guide/kernel-parameters.rst thanks to the bootloader
 configuration.

+To be able to explicitly allow TCP operations (e.g., adding a network rule with
+`LANDLOCK_ACCESS_NET_TCP_BIND`), the kernel must support TCP (`CONFIG_INET=y`).
+Otherwise, sys_landlock_add_rule() returns an `EAFNOSUPPORT` error, which can
+safely be ignored because this kind of TCP operation is already not possible.
+
 Questions and answers
 =====================

--
2.25.1

