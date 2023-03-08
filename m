Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1436AFB66
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCHAka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjCHAk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:40:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A8AA8EA4
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 16:39:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0AB9615E7
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 00:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54CBC4339E;
        Wed,  8 Mar 2023 00:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678235970;
        bh=7Sgqr/TeA2DGJ1fneVJU7rxqGCSxha2FR7Z7N6XvdoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oL6VQajvR5MwkKOxo/zK1DezwMGtN+loCmd4Xl+MVBhebBUGFcYr0Bq78P1DIQ0Oq
         N7IVJOLyQYpVr1vCxW0wyKbjGLmYmMwCKaUa5TtK3DebVcedMTsJexV4NQjBalhJAg
         hR+Aqf4Hz5DVlpDNWxfSr46IHFuitRfTlTyoXJ8dWC85bLtHPjlQVDTsAGJOA95loe
         crO0S4afJ7T8m6FdoekA98rfomj5p0Ju2x9GCyBzRqHSIfLxIJkZ0VbauLozJz3Ok5
         i91qFPdVPYyvP6SO00KpW/OnTTyLy5wyODBaw1mr31ocwAfvs3mJR1Q+QG4pWMdUkW
         xIVg1MS+P/TWA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        lorenzo@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/2] tools: ynl: move the enum classes to shared code
Date:   Tue,  7 Mar 2023 16:39:22 -0800
Message-Id: <20230308003923.445268-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308003923.445268-1-kuba@kernel.org>
References: <20230308003923.445268-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move bulk of the EnumSet and EnumEntry code to shared
code for reuse by cli.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/__init__.py |   7 ++-
 tools/net/ynl/lib/nlspec.py   |  96 ++++++++++++++++++++++++++++++
 tools/net/ynl/ynl-gen-c.py    | 107 +++++++---------------------------
 3 files changed, 121 insertions(+), 89 deletions(-)

diff --git a/tools/net/ynl/lib/__init__.py b/tools/net/ynl/lib/__init__.py
index a2cb8b16d6f1..4b3797fe784b 100644
--- a/tools/net/ynl/lib/__init__.py
+++ b/tools/net/ynl/lib/__init__.py
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 
-from .nlspec import SpecAttr, SpecAttrSet, SpecFamily, SpecOperation
+from .nlspec import SpecAttr, SpecAttrSet, SpecEnumEntry, SpecEnumSet, \
+    SpecFamily, SpecOperation
 from .ynl import YnlFamily
 
-__all__ = ["SpecAttr", "SpecAttrSet", "SpecFamily", "SpecOperation",
-           "YnlFamily"]
+__all__ = ["SpecAttr", "SpecAttrSet", "SpecEnumEntry", "SpecEnumSet",
+           "SpecFamily", "SpecOperation", "YnlFamily"]
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 0a2cfb5862aa..7c1cf6c1499e 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -57,6 +57,91 @@ jsonschema = None
         pass
 
 
+class SpecEnumEntry(SpecElement):
+    """ Entry within an enum declared in the Netlink spec.
+
+    Attributes:
+        doc         documentation string
+        enum_set    back reference to the enum
+        value       numerical value of this enum (use accessors in most situations!)
+
+    Methods:
+        raw_value   raw value, i.e. the id in the enum, unlike user value which is a mask for flags
+        user_value   user value, same as raw value for enums, for flags it's the mask
+    """
+    def __init__(self, enum_set, yaml, prev, value_start):
+        if isinstance(yaml, str):
+            yaml = {'name': yaml}
+        super().__init__(enum_set.family, yaml)
+
+        self.doc = yaml.get('doc', '')
+        self.enum_set = enum_set
+
+        if 'value' in yaml:
+            self.value = yaml['value']
+        elif prev:
+            self.value = prev.value + 1
+        else:
+            self.value = value_start
+
+    def has_doc(self):
+        return bool(self.doc)
+
+    def raw_value(self):
+        return self.value
+
+    def user_value(self):
+        if self.enum_set['type'] == 'flags':
+            return 1 << self.value
+        else:
+            return self.value
+
+
+class SpecEnumSet(SpecElement):
+    """ Enum type
+
+    Represents an enumeration (list of numerical constants)
+    as declared in the "definitions" section of the spec.
+
+    Attributes:
+        type          enum or flags
+        entries       entries by name
+    Methods:
+        get_mask      for flags compute the mask of all defined values
+    """
+    def __init__(self, family, yaml):
+        super().__init__(family, yaml)
+
+        self.type = yaml['type']
+
+        prev_entry = None
+        value_start = self.yaml.get('value-start', 0)
+        self.entries = dict()
+        for entry in self.yaml['entries']:
+            e = self.new_entry(entry, prev_entry, value_start)
+            self.entries[e.name] = e
+            prev_entry = e
+
+    def new_entry(self, entry, prev_entry, value_start):
+        return SpecEnumEntry(self, entry, prev_entry, value_start)
+
+    def has_doc(self):
+        if 'doc' in self.yaml:
+            return True
+        for entry in self.entries.values():
+            if entry.has_doc():
+                return True
+        return False
+
+    def get_mask(self):
+        mask = 0
+        idx = self.yaml.get('value-start', 0)
+        for _ in self.entries.values():
+            mask |= 1 << idx
+            idx += 1
+        return mask
+
+
 class SpecAttr(SpecElement):
     """ Single Netlink atttribute type
 
@@ -193,6 +278,7 @@ jsonschema = None
         msgs       dict of all messages (index by name)
         msgs_by_value  dict of all messages (indexed by name)
         ops        dict of all valid requests / responses
+        consts     dict of all constants/enums
     """
     def __init__(self, spec_path, schema_path=None):
         with open(spec_path, "r") as stream:
@@ -222,6 +308,7 @@ jsonschema = None
         self.req_by_value = collections.OrderedDict()
         self.rsp_by_value = collections.OrderedDict()
         self.ops = collections.OrderedDict()
+        self.consts = collections.OrderedDict()
 
         last_exception = None
         while len(self._resolution_list) > 0:
@@ -242,6 +329,9 @@ jsonschema = None
             if len(resolved) == 0:
                 raise last_exception
 
+    def new_enum(self, elem):
+        return SpecEnumSet(self, elem)
+
     def new_attr_set(self, elem):
         return SpecAttrSet(self, elem)
 
@@ -296,6 +386,12 @@ jsonschema = None
     def resolve(self):
         self.resolve_up(super())
 
+        for elem in self.yaml['definitions']:
+            if elem['type'] == 'enum' or elem['type'] == 'flags':
+                self.consts[elem['name']] = self.new_enum(elem)
+            else:
+                self.consts[elem['name']] = elem
+
         for elem in self.yaml['attribute-sets']:
             attr_set = self.new_attr_set(elem)
             self.attr_sets[elem['name']] = attr_set
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index c940ca834d3f..1bcc5354d800 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -6,7 +6,7 @@ import collections
 import os
 import yaml
 
-from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation
+from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, SpecEnumEntry
 
 
 def c_upper(name):
@@ -567,97 +567,37 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation
         self.inherited = [c_lower(x) for x in sorted(self._inherited)]
 
 
-class EnumEntry:
+class EnumEntry(SpecEnumEntry):
     def __init__(self, enum_set, yaml, prev, value_start):
-        if isinstance(yaml, str):
-            self.name = yaml
-            yaml = {}
-            self.doc = ''
-        else:
-            self.name = yaml['name']
-            self.doc = yaml.get('doc', '')
-
-        self.yaml = yaml
-        self.enum_set = enum_set
-        self.c_name = c_upper(enum_set.value_pfx + self.name)
-
-        if 'value' in yaml:
-            self.value = yaml['value']
-            if prev:
-                self.value_change = (self.value != prev.value + 1)
-        elif prev:
-            self.value_change = False
-            self.value = prev.value + 1
+        super().__init__(enum_set, yaml, prev, value_start)
+
+        if prev:
+            self.value_change = (self.value != prev.value + 1)
         else:
-            self.value = value_start
             self.value_change = (self.value != 0)
-
         self.value_change = self.value_change or self.enum_set['type'] == 'flags'
 
-    def __getitem__(self, key):
-        return self.yaml[key]
-
-    def __contains__(self, key):
-        return key in self.yaml
-
-    def has_doc(self):
-        return bool(self.doc)
+        # Added by resolve:
+        self.c_name = None
+        delattr(self, "c_name")
 
-    # raw value, i.e. the id in the enum, unlike user value which is a mask for flags
-    def raw_value(self):
-        return self.value
+    def resolve(self):
+        self.resolve_up(super())
 
-    # user value, same as raw value for enums, for flags it's the mask
-    def user_value(self):
-        if self.enum_set['type'] == 'flags':
-            return 1 << self.value
-        else:
-            return self.value
+        self.c_name = c_upper(self.enum_set.value_pfx + self.name)
 
 
-class EnumSet:
+class EnumSet(SpecEnumSet):
     def __init__(self, family, yaml):
-        self.yaml = yaml
-        self.family = family
-
         self.render_name = c_lower(family.name + '-' + yaml['name'])
         self.enum_name = 'enum ' + self.render_name
 
         self.value_pfx = yaml.get('name-prefix', f"{family.name}-{yaml['name']}-")
 
-        self.type = yaml['type']
-
-        prev_entry = None
-        value_start = self.yaml.get('value-start', 0)
-        self.entries = {}
-        self.entry_list = []
-        for entry in self.yaml['entries']:
-            e = EnumEntry(self, entry, prev_entry, value_start)
-            self.entries[e.name] = e
-            self.entry_list.append(e)
-            prev_entry = e
-
-    def __getitem__(self, key):
-        return self.yaml[key]
-
-    def __contains__(self, key):
-        return key in self.yaml
-
-    def has_doc(self):
-        if 'doc' in self.yaml:
-            return True
-        for entry in self.entry_list:
-            if entry.has_doc():
-                return True
-        return False
+        super().__init__(family, yaml)
 
-    def get_mask(self):
-        mask = 0
-        idx = self.yaml.get('value-start', 0)
-        for _ in self.entry_list:
-            mask |= 1 << idx
-            idx += 1
-        return mask
+    def new_entry(self, entry, prev_entry, value_start):
+        return EnumEntry(self, entry, prev_entry, value_start)
 
 
 class AttrSet(SpecAttrSet):
@@ -792,8 +732,6 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation
 
         self.mcgrps = self.yaml.get('mcast-groups', {'list': []})
 
-        self.consts = dict()
-
         self.hooks = dict()
         for when in ['pre', 'post']:
             self.hooks[when] = dict()
@@ -820,6 +758,9 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation
         if self.kernel_policy == 'global':
             self._load_global_policy()
 
+    def new_enum(self, elem):
+        return EnumSet(self, elem)
+
     def new_attr_set(self, elem):
         return AttrSet(self, elem)
 
@@ -837,12 +778,6 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation
                 }
 
     def _dictify(self):
-        for elem in self.yaml['definitions']:
-            if elem['type'] == 'enum' or elem['type'] == 'flags':
-                self.consts[elem['name']] = EnumSet(self, elem)
-            else:
-                self.consts[elem['name']] = elem
-
         ntf = []
         for msg in self.msgs.values():
             if 'notify' in msg:
@@ -1980,7 +1915,7 @@ _C_KW = {
                 if 'doc' in enum:
                     doc = ' - ' + enum['doc']
                 cw.write_doc_line(enum.enum_name + doc)
-                for entry in enum.entry_list:
+                for entry in enum.entries.values():
                     if entry.has_doc():
                         doc = '@' + entry.c_name + ': ' + entry['doc']
                         cw.write_doc_line(doc)
@@ -1988,7 +1923,7 @@ _C_KW = {
 
             uapi_enum_start(family, cw, const, 'name')
             name_pfx = const.get('name-prefix', f"{family.name}-{const['name']}-")
-            for entry in enum.entry_list:
+            for entry in enum.entries.values():
                 suffix = ','
                 if entry.value_change:
                     suffix = f" = {entry.user_value()}" + suffix
-- 
2.39.2

