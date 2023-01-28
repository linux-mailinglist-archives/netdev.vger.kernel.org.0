Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273DD67F4B1
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjA1Ecg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjA1Ec0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ACE7C306
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 963AD60A08
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE598C433EF;
        Sat, 28 Jan 2023 04:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880344;
        bh=H08foJN1GxlObkJcF6JuE5N6coWdFY46pqMFEk0WPSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXZB2rf5AdNjWSu++tw2KSwQmRRA7xQENnIR8Tx/0N1CiqpPyVa3Bgv54mylxw59y
         ubL9Wl/QDMNNfnU9dTMYAyiUloEGGVIuu0BUXHB+07jqXth9QvphHTRbmtKCL0ZO3y
         YyTY3y2j1DEYUmtwYXPcRVIy065mkS6ed8GNGotAVMk7TvJM/DhpB2KvI5Kc8LhO07
         C/oAxrcjhK1HcZ1AvWpE0El6RmaE2oL2IraPKa+DjQMU5937HS18kMnkiLhM/zeGsr
         9uTyIN2MguKeXeGhC1QwN2fMwnwN+0nAwpdKZaGWB2cQp+9DllEqMRN8MsSV7s82FB
         Js03MdAuo+xtQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/13] netlink: specs: finish up operation enum-models
Date:   Fri, 27 Jan 2023 20:32:15 -0800
Message-Id: <20230128043217.1572362-12-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230128043217.1572362-1-kuba@kernel.org>
References: <20230128043217.1572362-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I had a (bright?) idea of introducing the concept of enum-models
to account for all the weird ways families enumerate their messages.
I've never finished it because generating C code for each of them
is pretty daunting. But for languages which can use ID values directly
the support is simple enough, so clean this up a bit.

"unified" model is what I recommend going forward.
"directional" model is what ethtool uses.
"notify-split" is used by the proposed DPLL code, but we can just
make them use "unified", it hasn't been merged :)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/genetlink-c.yaml        |  4 +-
 Documentation/netlink/genetlink-legacy.yaml   | 11 ++-
 Documentation/netlink/genetlink.yaml          |  4 +-
 .../netlink/genetlink-legacy.rst              | 82 +++++++++++++++++++
 4 files changed, 92 insertions(+), 9 deletions(-)

diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
index e23e3c94a932..bbcfa2472b04 100644
--- a/Documentation/netlink/genetlink-c.yaml
+++ b/Documentation/netlink/genetlink-c.yaml
@@ -218,9 +218,7 @@ additionalProperties: False
           to a single enum.
           "directional" has the messages sent to the kernel and from the kernel
           enumerated separately.
-          "notify-split" has the notifications and request-response types in
-          different enums.
-        enum: [ unified, directional, notify-split ]
+        enum: [ unified ]
       name-prefix:
         description: |
           Prefix for the C enum name of the command. The name is formed by concatenating
diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index 88db2431ef26..5642925c4ceb 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -241,9 +241,7 @@ additionalProperties: False
           to a single enum.
           "directional" has the messages sent to the kernel and from the kernel
           enumerated separately.
-          "notify-split" has the notifications and request-response types in
-          different enums.
-        enum: [ unified, directional, notify-split ]
+        enum: [ unified, directional ] # Trim
       name-prefix:
         description: |
           Prefix for the C enum name of the command. The name is formed by concatenating
@@ -307,6 +305,13 @@ additionalProperties: False
                       type: array
                       items:
                         type: string
+                    # Start genetlink-legacy
+                    value:
+                      description: |
+                        ID of this message if value for request and response differ,
+                        i.e. requests and responses have different message enums.
+                      $ref: '#/$defs/uint'
+                    # End genetlink-legacy
                 reply: *subop-attr-list
                 pre:
                   description: Hook for a function to run before the main callback (pre_doit or start).
diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink/genetlink.yaml
index b5e712bbe7e7..62a922755ce2 100644
--- a/Documentation/netlink/genetlink.yaml
+++ b/Documentation/netlink/genetlink.yaml
@@ -188,9 +188,7 @@ additionalProperties: False
           to a single enum.
           "directional" has the messages sent to the kernel and from the kernel
           enumerated separately.
-          "notify-split" has the notifications and request-response types in
-          different enums.
-        enum: [ unified, directional, notify-split ]
+        enum: [ unified ]
       name-prefix:
         description: |
           Prefix for the C enum name of the command. The name is formed by concatenating
diff --git a/Documentation/userspace-api/netlink/genetlink-legacy.rst b/Documentation/userspace-api/netlink/genetlink-legacy.rst
index 65cbbffee0bf..ae6053e3e50c 100644
--- a/Documentation/userspace-api/netlink/genetlink-legacy.rst
+++ b/Documentation/userspace-api/netlink/genetlink-legacy.rst
@@ -74,6 +74,88 @@ type. Inside the attr-index nest are the policy attributes. Modern
 Netlink families should have instead defined this as a flat structure,
 the nesting serves no good purpose here.
 
+Operations
+==========
+
+Enum (message ID) model
+-----------------------
+
+unified
+~~~~~~~
+
+Modern families use the ``unified`` message ID model, which uses
+a single enumeration for all messages within family. Requests and
+responses share the same message ID. Notifications have separate
+IDs from the same space. For example given the following list
+of operations:
+
+.. code-block:: yaml
+
+  -
+    name: a
+    value: 1
+    do: ...
+  -
+    name: b
+    do: ...
+  -
+    name: c
+    value: 4
+    notify: a
+  -
+    name: d
+    do: ...
+
+Requests and responses for aperation ``a`` will have the ID of 1,
+the requests and responses of ``b`` - 2 (since there is no explicit
+``value`` it's previous operation ``+ 1``). Notification ``c`` will
+used the ID of 4, operation ``d`` 5 etc.
+
+directional
+~~~~~~~~~~~
+
+The ``directional`` model splits the ID assignment by the direction of
+the message. Messages from and to the kernel can't be confused with
+each other so this conserves the ID space (at the cost of making
+the programming more cumbersome).
+
+In this case ``value`` attribute should be specified in the ``request``
+``reply`` sections of the operations (if an operation has both ``do``
+and ``dump`` the IDs are shared, ``value`` should be set in ``do``).
+For notifications the ``value`` is provided at the op level but it
+only allocates a ``reply`` (i.e. a "from-kernel" ID). Let's look
+at an example:
+
+.. code-block:: yaml
+
+  -
+    name: a
+    do:
+      request:
+        value: 2
+	attributes: ...
+      reply:
+        value: 1
+	attributes: ...
+  -
+    name: b
+    notify: a
+  -
+    name: c
+    notify: a
+    value: 7
+  -
+    name: d
+    do: ...
+
+In this case ``a`` will use 2 when sending the message to the kernel
+and expects message with ID 1 in response. Notificatoin ``b`` allocates
+a "from-kernel" ID which is 2. ``c`` allocates "from-kernel" ID of 7.
+If operation ``d`` does not set ``values`` explicitly in the spec
+it will be allocated 3 for the request (``a`` is the previous operation
+with a request section and the value of 2) and 8 for response (``c`` is
+the previous operation in the "from-kernel" direction).
+
 Other quirks (todo)
 ===================
 
-- 
2.39.1

