Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F898682237
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjAaCel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjAaCeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C20366A1;
        Mon, 30 Jan 2023 18:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F5656137F;
        Tue, 31 Jan 2023 02:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235B3C4339C;
        Tue, 31 Jan 2023 02:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132445;
        bh=j+kyGgtoUOADBSzi2R1vS+gr/S9Y+L2rptW8JwphwwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqaCl6tOrCQz6PZq+ZvKr9FdeZJAN9I4vVhLRvjoGjkb3QAg2EuhjBavB9m0N51wG
         lV/LUY/gpxdEaradwUFNsPwXaw1UGE5aUwd33r7PUsx6gV0GoDnf3TMVkx2H5E+Dya
         6ExnZQDgYTu5FatXd8cG5LQITTtoyrUST1dTNuc3RvB7DKiG0r9mVrZdaAQt7dgstx
         /NvsmHMghjFPsiO1BDDIbxA4FWUDCrhTma8Md+4eD2ubbGyn0/jSE/yD25gG+GZDz6
         LmUDu/WNLydKbWO/D9JupuE/6BLm6Pl4rA2LxeMiQED/veLSbf65Pqiq7SW2b7WMio
         d2fdTkwyCb2Bg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 11/14] netlink: specs: finish up operation enum-models
Date:   Mon, 30 Jan 2023 18:33:51 -0800
Message-Id: <20230131023354.1732677-12-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
References: <20230131023354.1732677-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
v2: spelling fixes
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
index 65cbbffee0bf..3bf0bcdf21d8 100644
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
+Requests and responses for operation ``a`` will have the ID of 1,
+the requests and responses of ``b`` - 2 (since there is no explicit
+``value`` it's previous operation ``+ 1``). Notification ``c`` will
+use the ID of 4, operation ``d`` 5 etc.
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
+        attributes: ...
+      reply:
+        value: 1
+        attributes: ...
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
+and expects message with ID 1 in response. Notification ``b`` allocates
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

