Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE5B6A7389
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCASgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCASgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:36:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730C73C7BC;
        Wed,  1 Mar 2023 10:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AE35B8110C;
        Wed,  1 Mar 2023 18:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB26C433EF;
        Wed,  1 Mar 2023 18:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677695807;
        bh=8QK1u8EV59bYDX/FqMygIaZVKVOTZpGe9Fl30a3pVz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIgvUfnvfIXDLC+5A6vIQMstYFLX0h/wiiG1EcM1d6TOC/fsRsqRogCc6O3uRO7gK
         IaLeKtx9vqkLXpdmXzqWKPVB77at+eP0ZDDL8OZ7JtInKvaE3cukFmnDNQ/SG9K9AU
         YlxnhABiSiZbNnyL7rz+KQNcNLUUGN5sUPo/2NN1uhTeniVPPVF82xY0aXruuzSJae
         rXFbgon9HL7iud+1RdvWRB0khC9RWaYzGFlNLw3MlycqE3u4rTFmyGqBj59vmxJDlj
         1Jvn3RyLpfr1BkPtyElL+JlAIUuXDBW6sZzPm5N/fNNaxgDoIiLV1Ni6elEBipPJHF
         BNH9plgtAzPJA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/3] tools: ynl: use 1 as the default for first entry in attrs/ops
Date:   Wed,  1 Mar 2023 10:36:41 -0800
Message-Id: <20230301183642.2168393-3-kuba@kernel.org>
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

Pretty much all families use value: 1 or reserve as unspec
the first entry in attribute set and the first operation.
Make this the default. Update documentation (the doc for
values of operations just refers back to doc for attrs
so updating only attrs).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/userspace-api/netlink/specs.rst | 7 ++++++-
 tools/net/ynl/lib/nlspec.py                   | 6 +++---
 tools/net/ynl/ynl-gen-c.py                    | 7 +++++--
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/userspace-api/netlink/specs.rst b/Documentation/userspace-api/netlink/specs.rst
index 1424ab1b9b33..32e53328d113 100644
--- a/Documentation/userspace-api/netlink/specs.rst
+++ b/Documentation/userspace-api/netlink/specs.rst
@@ -197,7 +197,12 @@ value
 Numerical attribute ID, used in serialized Netlink messages.
 The ``value`` property can be skipped, in which case the attribute ID
 will be the value of the previous attribute plus one (recursively)
-and ``0`` for the first attribute in the attribute set.
+and ``1`` for the first attribute in the attribute set.
+
+Attributes (and operations) use ``1`` as the default value for the first
+entry (unlike enums in definitions which start from ``0``) because
+entry ``0`` is almost always reserved as undefined. Spec can explicitly
+set value to ``0`` if needed.
 
 Note that the ``value`` of an attribute is defined only in its main set
 (not in subsets).
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index dff31dad36c5..9d394e50de23 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -96,7 +96,7 @@ jsonschema = None
         self.attrs_by_val = collections.OrderedDict()
 
         if self.subset_of is None:
-            val = 0
+            val = 1
             for elem in self.yaml['attributes']:
                 if 'value' in elem:
                     val = elem['value']
@@ -252,7 +252,7 @@ jsonschema = None
         self._resolution_list.append(elem)
 
     def _dictify_ops_unified(self):
-        val = 0
+        val = 1
         for elem in self.yaml['operations']['list']:
             if 'value' in elem:
                 val = elem['value']
@@ -263,7 +263,7 @@ jsonschema = None
             self.msgs[op.name] = op
 
     def _dictify_ops_directional(self):
-        req_val = rsp_val = 0
+        req_val = rsp_val = 1
         for elem in self.yaml['operations']['list']:
             if 'notify' in elem:
                 if 'value' in elem:
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 274e9c566f61..62f8f2c3c56c 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2044,14 +2044,17 @@ _C_KW = {
     max_value = f"({cnt_name} - 1)"
 
     uapi_enum_start(family, cw, family['operations'], 'enum-name')
+    val = 0
     for op in family.msgs.values():
         if separate_ntf and ('notify' in op or 'event' in op):
             continue
 
         suffix = ','
-        if 'value' in op:
-            suffix = f" = {op['value']},"
+        if op.value != val:
+            suffix = f" = {op.value},"
+            val = op.value
         cw.p(op.enum_name + suffix)
+        val += 1
     cw.nl()
     cw.p(cnt_name + ('' if max_by_define else ','))
     if not max_by_define:
-- 
2.39.2

