Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85414682218
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjAaCeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjAaCeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3713D360BF;
        Mon, 30 Jan 2023 18:34:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 699466137F;
        Tue, 31 Jan 2023 02:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F55C433A8;
        Tue, 31 Jan 2023 02:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132440;
        bh=8aIRZBVZVhnH3fFHrFLyeWEEmbede6p8M0TZ1K683HE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfURkvwXrgnA2VtnaJykewGjahnxAI194het03gJOI037Xd4trZNZ712wzLF2m5zJ
         Vjhi1ETasXIPWBwVxtDE+KahGfZW+2rsWe1YzSC8uTQNeVevo5K0BrTokXE7AUlZL5
         1uoX6OwvkpugejdHB3tCMu8BZ4sZXTud7rnIxMLdls16H7wjE56qWJeTt95FpY9G3k
         WT7rbrNEARQKtoNczEBz1hv2KOQ7OVpp19AIW56SklISJGsJUEweug4c14BMOCiCqo
         2SbqlJGaGDxxIUpWeqdFit5tr8QSsSzMVSlQx+YE+KZlJFjzezfJWJiveJscUBdd8n
         bQIhtPQWZSXfQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 03/14] tools: ynl: add an object hierarchy to represent parsed spec
Date:   Mon, 30 Jan 2023 18:33:43 -0800
Message-Id: <20230131023354.1732677-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
References: <20230131023354.1732677-1-kuba@kernel.org>
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

There's a lot of copy and pasting going on between the "cli"
and code gen when it comes to representing the parsed spec.
Create a library which both can use.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/__init__.py |   4 +-
 tools/net/ynl/lib/nlspec.py   | 301 ++++++++++++++++++++++++++++++++++
 2 files changed, 304 insertions(+), 1 deletion(-)
 create mode 100644 tools/net/ynl/lib/nlspec.py

diff --git a/tools/net/ynl/lib/__init__.py b/tools/net/ynl/lib/__init__.py
index 0a6102758ebe..3c73f59eabab 100644
--- a/tools/net/ynl/lib/__init__.py
+++ b/tools/net/ynl/lib/__init__.py
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: BSD-3-Clause
 
+from .nlspec import SpecAttr, SpecAttrSet, SpecFamily, SpecOperation
 from .ynl import YnlFamily
 
-__all__ = ["YnlFamily"]
+__all__ = ["SpecAttr", "SpecAttrSet", "SpecFamily", "SpecOperation",
+           "YnlFamily"]
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
new file mode 100644
index 000000000000..4aa3b1ad97f0
--- /dev/null
+++ b/tools/net/ynl/lib/nlspec.py
@@ -0,0 +1,301 @@
+# SPDX-License-Identifier: BSD-3-Clause
+
+import collections
+import jsonschema
+import os
+import traceback
+import yaml
+
+
+class SpecElement:
+    """Netlink spec element.
+
+    Abstract element of the Netlink spec. Implements the dictionary interface
+    for access to the raw spec. Supports iterative resolution of dependencies
+    across elements and class inheritance levels. The elements of the spec
+    may refer to each other, and although loops should be very rare, having
+    to maintain correct ordering of instantiation is painful, so the resolve()
+    method should be used to perform parts of init which require access to
+    other parts of the spec.
+
+    Attributes:
+        yaml        raw spec as loaded from the spec file
+        family      back reference to the full family
+
+        name        name of the entity as listed in the spec (optional)
+        ident_name  name which can be safely used as identifier in code (optional)
+    """
+    def __init__(self, family, yaml):
+        self.yaml = yaml
+        self.family = family
+
+        if 'name' in self.yaml:
+            self.name = self.yaml['name']
+            self.ident_name = self.name.replace('-', '_')
+
+        self._super_resolved = False
+        family.add_unresolved(self)
+
+    def __getitem__(self, key):
+        return self.yaml[key]
+
+    def __contains__(self, key):
+        return key in self.yaml
+
+    def get(self, key, default=None):
+        return self.yaml.get(key, default)
+
+    def resolve_up(self, up):
+        if not self._super_resolved:
+            up.resolve()
+            self._super_resolved = True
+
+    def resolve(self):
+        pass
+
+
+class SpecAttr(SpecElement):
+    """ Single Netlink atttribute type
+
+    Represents a single attribute type within an attr space.
+
+    Attributes:
+        value      numerical ID when serialized
+        attr_set   Attribute Set containing this attr
+    """
+    def __init__(self, family, attr_set, yaml, value):
+        super().__init__(family, yaml)
+
+        self.value = value
+        self.attr_set = attr_set
+        self.is_multi = yaml.get('multi-attr', False)
+
+
+class SpecAttrSet(SpecElement):
+    """ Netlink Attribute Set class.
+
+    Represents a ID space of attributes within Netlink.
+
+    Note that unlike other elements, which expose contents of the raw spec
+    via the dictionary interface Attribute Set exposes attributes by name.
+
+    Attributes:
+        attrs      ordered dict of all attributes (indexed by name)
+        attrs_by_val  ordered dict of all attributes (indexed by value)
+        subset_of  parent set if this is a subset, otherwise None
+    """
+    def __init__(self, family, yaml):
+        super().__init__(family, yaml)
+
+        self.subset_of = self.yaml.get('subset-of', None)
+
+        self.attrs = collections.OrderedDict()
+        self.attrs_by_val = collections.OrderedDict()
+
+        val = 0
+        for elem in self.yaml['attributes']:
+            if 'value' in elem:
+                val = elem['value']
+
+            attr = self.new_attr(elem, val)
+            self.attrs[attr.name] = attr
+            self.attrs_by_val[attr.value] = attr
+            val += 1
+
+    def new_attr(self, elem, value):
+        return SpecAttr(self.family, self, elem, value)
+
+    def __getitem__(self, key):
+        return self.attrs[key]
+
+    def __contains__(self, key):
+        return key in self.attrs
+
+    def __iter__(self):
+        yield from self.attrs
+
+    def items(self):
+        return self.attrs.items()
+
+
+class SpecOperation(SpecElement):
+    """Netlink Operation
+
+    Information about a single Netlink operation.
+
+    Attributes:
+        value       numerical ID when serialized, None if req/rsp values differ
+
+        req_value   numerical ID when serialized, user -> kernel
+        rsp_value   numerical ID when serialized, user <- kernel
+        is_call     bool, whether the operation is a call
+        is_async    bool, whether the operation is a notification
+        is_resv     bool, whether the operation does not exist (it's just a reserved ID)
+        attr_set    attribute set name
+
+        yaml        raw spec as loaded from the spec file
+    """
+    def __init__(self, family, yaml, req_value, rsp_value):
+        super().__init__(family, yaml)
+
+        self.value = req_value if req_value == rsp_value else None
+        self.req_value = req_value
+        self.rsp_value = rsp_value
+
+        self.is_call = 'do' in yaml or 'dump' in yaml
+        self.is_async = 'notify' in yaml or 'event' in yaml
+        self.is_resv = not self.is_async and not self.is_call
+
+        # Added by resolve:
+        self.attr_set = None
+        delattr(self, "attr_set")
+
+    def resolve(self):
+        self.resolve_up(super())
+
+        if 'attribute-set' in self.yaml:
+            attr_set_name = self.yaml['attribute-set']
+        elif 'notify' in self.yaml:
+            msg = self.family.msgs[self.yaml['notify']]
+            attr_set_name = msg['attribute-set']
+        elif self.is_resv:
+            attr_set_name = ''
+        else:
+            raise Exception(f"Can't resolve attribute set for op '{self.name}'")
+        if attr_set_name:
+            self.attr_set = self.family.attr_sets[attr_set_name]
+
+
+class SpecFamily(SpecElement):
+    """ Netlink Family Spec class.
+
+    Netlink family information loaded from a spec (e.g. in YAML).
+    Takes care of unfolding implicit information which can be skipped
+    in the spec itself for brevity.
+
+    The class can be used like a dictionary to access the raw spec
+    elements but that's usually a bad idea.
+
+    Attributes:
+        proto     protocol type (e.g. genetlink)
+
+        attr_sets  dict of attribute sets
+        msgs       dict of all messages (index by name)
+        msgs_by_value  dict of all messages (indexed by name)
+        ops        dict of all valid requests / responses
+    """
+    def __init__(self, spec_path, schema_path=None):
+        with open(spec_path, "r") as stream:
+            spec = yaml.safe_load(stream)
+
+        self._resolution_list = []
+
+        super().__init__(self, spec)
+
+        self.proto = self.yaml.get('protocol', 'genetlink')
+
+        if schema_path is None:
+            schema_path = os.path.dirname(os.path.dirname(spec_path)) + f'/{self.proto}.yaml'
+        if schema_path:
+            with open(schema_path, "r") as stream:
+                schema = yaml.safe_load(stream)
+
+            jsonschema.validate(self.yaml, schema)
+
+        self.attr_sets = collections.OrderedDict()
+        self.msgs = collections.OrderedDict()
+        self.req_by_value = collections.OrderedDict()
+        self.rsp_by_value = collections.OrderedDict()
+        self.ops = collections.OrderedDict()
+
+        last_exception = None
+        while len(self._resolution_list) > 0:
+            resolved = []
+            unresolved = self._resolution_list
+            self._resolution_list = []
+
+            for elem in unresolved:
+                try:
+                    elem.resolve()
+                except (KeyError, AttributeError) as e:
+                    self._resolution_list.append(elem)
+                    last_exception = e
+                    continue
+
+                resolved.append(elem)
+
+            if len(resolved) == 0:
+                traceback.print_exception(last_exception)
+                raise Exception("Could not resolve any spec element, infinite loop?")
+
+    def new_attr_set(self, elem):
+        return SpecAttrSet(self, elem)
+
+    def new_operation(self, elem, req_val, rsp_val):
+        return SpecOperation(self, elem, req_val, rsp_val)
+
+    def add_unresolved(self, elem):
+        self._resolution_list.append(elem)
+
+    def _dictify_ops_unified(self):
+        val = 0
+        for elem in self.yaml['operations']['list']:
+            if 'value' in elem:
+                val = elem['value']
+
+            op = self.new_operation(elem, val, val)
+            val += 1
+
+            self.msgs[op.name] = op
+
+    def _dictify_ops_directional(self):
+        req_val = rsp_val = 0
+        for elem in self.yaml['operations']['list']:
+            if 'notify' in elem:
+                if 'value' in elem:
+                    rsp_val = elem['value']
+                req_val_next = req_val
+                rsp_val_next = rsp_val + 1
+                req_val = None
+            elif 'do' in elem or 'dump' in elem:
+                mode = elem['do'] if 'do' in elem else elem['dump']
+
+                v = mode.get('request', {}).get('value', None)
+                if v:
+                    req_val = v
+                v = mode.get('reply', {}).get('value', None)
+                if v:
+                    rsp_val = v
+
+                rsp_inc = 1 if 'reply' in mode else 0
+                req_val_next = req_val + 1
+                rsp_val_next = rsp_val + rsp_inc
+            else:
+                raise Exception("Can't parse directional ops")
+
+            op = self.new_operation(elem, req_val, rsp_val)
+            req_val = req_val_next
+            rsp_val = rsp_val_next
+
+            self.msgs[op.name] = op
+
+    def resolve(self):
+        self.resolve_up(super())
+
+        for elem in self.yaml['attribute-sets']:
+            attr_set = self.new_attr_set(elem)
+            self.attr_sets[elem['name']] = attr_set
+
+        msg_id_model = self.yaml['operations'].get('enum-model', 'unified')
+        if msg_id_model == 'unified':
+            self._dictify_ops_unified()
+        elif msg_id_model == 'directional':
+            self._dictify_ops_directional()
+
+        for op in self.msgs.values():
+            if op.req_value is not None:
+                self.req_by_value[op.req_value] = op
+            if op.rsp_value is not None:
+                self.rsp_by_value[op.rsp_value] = op
+            if not op.is_async and 'attribute-set' in op:
+                self.ops[op.name] = op
-- 
2.39.1

