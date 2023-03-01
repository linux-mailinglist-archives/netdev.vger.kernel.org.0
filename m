Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF8A6A738D
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCASg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCASgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:36:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F142548E09;
        Wed,  1 Mar 2023 10:36:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F2AAB810D5;
        Wed,  1 Mar 2023 18:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0021DC4339C;
        Wed,  1 Mar 2023 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677695807;
        bh=UJ5NKmoe4owCJ+AjKMsXkW6J0FjadIwP5rlFgHI3eeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elvvtZAbsbwcH/CTd0T7mFNuSUqktzBf/7Wz9bhN/A+Zw1F4qCtE38Ch5idVEnZHu
         JAqxqdAJK+3hpzBa410EaZ3L4QGrhNGTNOZf2X+r3LwvJR2cgC4/7D/ZxGIm/rukal
         NITJBfDLQb7k7VI8dNL1za29/GJHocaIVBSfcUOkGd0LkVr0qCFw78MXILr3eqDdd9
         jsN9+PhBpDolGhVcrZcD3io0oMOSBtAnCriVIYi0bxr5jeAQWvu2nRpz3xFjBFuS9i
         sOFax3Q3e8GYZFTCzEE2Zfi3f8fkUzXw4eRCA45sOws/q1z0K797vtsKAN7eLQP/CM
         497VXOym1aKYw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        corbet@lwn.net, sdf@google.com
Subject: [PATCH net 1/3] tools: ynl: fully inherit attrs in subsets
Date:   Wed,  1 Mar 2023 10:36:40 -0800
Message-Id: <20230301183642.2168393-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301183642.2168393-1-kuba@kernel.org>
References: <20230301183642.2168393-1-kuba@kernel.org>
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

To avoid having to repeat the entire definition of an attribute
(including the value) use the Attr object from the original set.
In fact this is already the documented expectation.

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: corbet@lwn.net
CC: sdf@google.com
CC: linux-doc@vger.kernel.org
---
 Documentation/userspace-api/netlink/specs.rst |  3 ++-
 tools/net/ynl/lib/nlspec.py                   | 23 ++++++++++++-------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/userspace-api/netlink/specs.rst b/Documentation/userspace-api/netlink/specs.rst
index 6ffe8137cd90..1424ab1b9b33 100644
--- a/Documentation/userspace-api/netlink/specs.rst
+++ b/Documentation/userspace-api/netlink/specs.rst
@@ -199,7 +199,8 @@ The ``value`` property can be skipped, in which case the attribute ID
 will be the value of the previous attribute plus one (recursively)
 and ``0`` for the first attribute in the attribute set.
 
-Note that the ``value`` of an attribute is defined only in its main set.
+Note that the ``value`` of an attribute is defined only in its main set
+(not in subsets).
 
 enum
 ~~~~
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 71da568e2c28..dff31dad36c5 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -95,15 +95,22 @@ jsonschema = None
         self.attrs = collections.OrderedDict()
         self.attrs_by_val = collections.OrderedDict()
 
-        val = 0
-        for elem in self.yaml['attributes']:
-            if 'value' in elem:
-                val = elem['value']
+        if self.subset_of is None:
+            val = 0
+            for elem in self.yaml['attributes']:
+                if 'value' in elem:
+                    val = elem['value']
 
-            attr = self.new_attr(elem, val)
-            self.attrs[attr.name] = attr
-            self.attrs_by_val[attr.value] = attr
-            val += 1
+                attr = self.new_attr(elem, val)
+                self.attrs[attr.name] = attr
+                self.attrs_by_val[attr.value] = attr
+                val += 1
+        else:
+            real_set = family.attr_sets[self.subset_of]
+            for elem in self.yaml['attributes']:
+                attr = real_set[elem['name']]
+                self.attrs[attr.name] = attr
+                self.attrs_by_val[attr.value] = attr
 
     def new_attr(self, elem, value):
         return SpecAttr(self.family, self, elem, value)
-- 
2.39.2

