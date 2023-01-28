Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58EB67F4B3
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjA1Ecw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjA1Ec0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E177AE56
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73C44B821F1
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30A6C433A8;
        Sat, 28 Jan 2023 04:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880341;
        bh=4X4qpdN+MMgQhjiWQOyMjI2hWl/Jc6y8G8msUCyGCjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rViYS6xuzbKUdxE0cyjtCJhKjmqSX40jQmZy+tmFBn8M9oIyOeiHDGFKeyg+da0U8
         wfQD+PMvVskPQdapHqfxYh7e/WS3AtnPjQW/tJeDtKPmRohnnFZC5va8S8FPDY1Jpk
         OmYUGXUQYqpALOnGxKxirz/PpeRw+oLVaMDZN9ANn+FaYXnYtxLnUHljT42rdy7L+I
         2WLkJYZm2/EmgDD6QdV+aTQkaxznVhSmfap4SNmFFftEWWjrhWBeDojP/ukdiWUZKj
         y+/JtHRtTMxfkv1hR5YMwrswIHNZQrxglktOYllu3QHo7li5KhKZ7SLiwyZpXAfnuE
         u4AMZTipdup4w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/13] tools: ynl: use the common YAML loading and validation code
Date:   Fri, 27 Jan 2023 20:32:08 -0800
Message-Id: <20230128043217.1572362-5-kuba@kernel.org>
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

Adapt the common object hierarchy in code gen and CLI.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/ynl.py   | 118 ++++-------------
 tools/net/ynl/ynl-gen-c.py | 256 +++++++++++++++++--------------------
 2 files changed, 142 insertions(+), 232 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index b71523d71d46..0ceb627ba686 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -1,13 +1,14 @@
 # SPDX-License-Identifier: BSD-3-Clause
 
 import functools
-import jsonschema
 import os
 import random
 import socket
 import struct
 import yaml
 
+from .nlspec import SpecFamily
+
 #
 # Generic Netlink code which should really be in some library, but I can't quickly find one.
 #
@@ -158,8 +159,8 @@ import yaml
                 # We don't have the ability to parse nests yet, so only do global
                 if 'miss-type' in self.extack and 'miss-nest' not in self.extack:
                     miss_type = self.extack['miss-type']
-                    if len(attr_space.attr_list) > miss_type:
-                        spec = attr_space.attr_list[miss_type]
+                    if miss_type in attr_space.attrs_by_val:
+                        spec = attr_space.attrs_by_val[miss_type]
                         desc = spec['name']
                         if 'doc' in spec:
                             desc += f" ({spec['doc']})"
@@ -289,100 +290,31 @@ genl_family_name_to_id = None
 #
 
 
-class YnlAttrSpace:
-    def __init__(self, family, yaml):
-        self.yaml = yaml
-
-        self.attrs = dict()
-        self.name = self.yaml['name']
-        self.subspace_of = self.yaml['subset-of'] if 'subspace-of' in self.yaml else None
-
-        val = 0
-        max_val = 0
-        for elem in self.yaml['attributes']:
-            if 'value' in elem:
-                val = elem['value']
-            else:
-                elem['value'] = val
-            if val > max_val:
-                max_val = val
-            val += 1
-
-            self.attrs[elem['name']] = elem
-
-        self.attr_list = [None] * (max_val + 1)
-        for elem in self.yaml['attributes']:
-            self.attr_list[elem['value']] = elem
-
-    def __getitem__(self, key):
-        return self.attrs[key]
-
-    def __contains__(self, key):
-        return key in self.yaml
-
-    def __iter__(self):
-        yield from self.attrs
-
-    def items(self):
-        return self.attrs.items()
-
-
-class YnlFamily:
+class YnlFamily(SpecFamily):
     def __init__(self, def_path, schema=None):
-        self.include_raw = False
+        super().__init__(def_path, schema)
 
-        with open(def_path, "r") as stream:
-            self.yaml = yaml.safe_load(stream)
-
-        if schema:
-            with open(schema, "r") as stream:
-                schema = yaml.safe_load(stream)
-
-            jsonschema.validate(self.yaml, schema)
+        self.include_raw = False
 
         self.sock = socket.socket(socket.AF_NETLINK, socket.SOCK_RAW, Netlink.NETLINK_GENERIC)
         self.sock.setsockopt(Netlink.SOL_NETLINK, Netlink.NETLINK_CAP_ACK, 1)
         self.sock.setsockopt(Netlink.SOL_NETLINK, Netlink.NETLINK_EXT_ACK, 1)
 
-        self._ops = dict()
-        self._spaces = dict()
         self._types = dict()
 
-        for elem in self.yaml['attribute-sets']:
-            self._spaces[elem['name']] = YnlAttrSpace(self, elem)
-
         for elem in self.yaml['definitions']:
             self._types[elem['name']] = elem
 
-        async_separation = 'async-prefix' in self.yaml['operations']
         self.async_msg_ids = set()
         self.async_msg_queue = []
-        val = 0
-        max_val = 0
-        for elem in self.yaml['operations']['list']:
-            if not (async_separation and ('notify' in elem or 'event' in elem)):
-                if 'value' in elem:
-                    val = elem['value']
-                else:
-                    elem['value'] = val
-                val += 1
-                max_val = max(val, max_val)
-
-            if 'notify' in elem or 'event' in elem:
-                self.async_msg_ids.add(elem['value'])
-
-            self._ops[elem['name']] = elem
-
-            op_name = elem['name'].replace('-', '_')
 
-            bound_f = functools.partial(self._op, elem['name'])
-            setattr(self, op_name, bound_f)
+        for msg in self.msgs.values():
+            if msg.is_async:
+                self.async_msg_ids.add(msg.value)
 
-        self._op_array = [None] * max_val
-        for _, op in self._ops.items():
-            self._op_array[op['value']] = op
-            if 'notify' in op:
-                op['attribute-set'] = self._ops[op['notify']]['attribute-set']
+        for op_name, op in self.ops.items():
+            bound_f = functools.partial(self._op, op_name)
+            setattr(self, op.ident_name, bound_f)
 
         self.family = GenlFamily(self.yaml['name'])
 
@@ -395,8 +327,8 @@ genl_family_name_to_id = None
                              self.family.genl_family['mcast'][mcast_name])
 
     def _add_attr(self, space, name, value):
-        attr = self._spaces[space][name]
-        nl_type = attr['value']
+        attr = self.attr_sets[space][name]
+        nl_type = attr.value
         if attr["type"] == 'nest':
             nl_type |= Netlink.NLA_F_NESTED
             attr_payload = b''
@@ -430,10 +362,10 @@ genl_family_name_to_id = None
         rsp[attr_spec['name']] = value
 
     def _decode(self, attrs, space):
-        attr_space = self._spaces[space]
+        attr_space = self.attr_sets[space]
         rsp = dict()
         for attr in attrs:
-            attr_spec = attr_space.attr_list[attr.type]
+            attr_spec = attr_space.attrs_by_val[attr.type]
             if attr_spec["type"] == 'nest':
                 subdict = self._decode(NlAttrs(attr.raw), attr_spec['nested-attributes'])
                 rsp[attr_spec['name']] = subdict
@@ -457,9 +389,9 @@ genl_family_name_to_id = None
         if self.include_raw:
             msg['nlmsg'] = nl_msg
             msg['genlmsg'] = genl_msg
-        op = self._op_array[genl_msg.genl_cmd]
+        op = self.msgs_by_value[genl_msg.genl_cmd]
         msg['name'] = op['name']
-        msg['msg'] = self._decode(genl_msg.raw_attrs, op['attribute-set'])
+        msg['msg'] = self._decode(genl_msg.raw_attrs, op.attr_set.name)
         self.async_msg_queue.append(msg)
 
     def check_ntf(self):
@@ -487,16 +419,16 @@ genl_family_name_to_id = None
                 self.handle_ntf(nl_msg, gm)
 
     def _op(self, method, vals, dump=False):
-        op = self._ops[method]
+        op = self.ops[method]
 
         nl_flags = Netlink.NLM_F_REQUEST | Netlink.NLM_F_ACK
         if dump:
             nl_flags |= Netlink.NLM_F_DUMP
 
         req_seq = random.randint(1024, 65535)
-        msg = _genl_msg(self.family.family_id, nl_flags, op['value'], 1, req_seq)
+        msg = _genl_msg(self.family.family_id, nl_flags, op.value, 1, req_seq)
         for name, value in vals.items():
-            msg += self._add_attr(op['attribute-set'], name, value)
+            msg += self._add_attr(op.attr_set.name, name, value)
         msg = _genl_msg_finalize(msg)
 
         self.sock.send(msg, 0)
@@ -505,7 +437,7 @@ genl_family_name_to_id = None
         rsp = []
         while not done:
             reply = self.sock.recv(128 * 1024)
-            nms = NlMsgs(reply, attr_space=self._spaces[op['attribute-set']])
+            nms = NlMsgs(reply, attr_space=op.attr_set)
             for nl_msg in nms:
                 if nl_msg.error:
                     print("Netlink error:", os.strerror(-nl_msg.error))
@@ -517,7 +449,7 @@ genl_family_name_to_id = None
 
                 gm = GenlMsg(nl_msg)
                 # Check if this is a reply to our request
-                if nl_msg.nl_seq != req_seq or gm.genl_cmd != op['value']:
+                if nl_msg.nl_seq != req_seq or gm.genl_cmd != op.value:
                     if gm.genl_cmd in self.async_msg_ids:
                         self.handle_ntf(nl_msg, gm)
                         continue
@@ -525,7 +457,7 @@ genl_family_name_to_id = None
                         print('Unexpected message: ' + repr(gm))
                         continue
 
-                rsp.append(self._decode(gm.raw_attrs, op['attribute-set']))
+                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name))
 
         if not rsp:
             return None
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index e5002d420961..dc14da634e8e 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2,10 +2,11 @@
 
 import argparse
 import collections
-import jsonschema
 import os
 import yaml
 
+from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation
+
 
 def c_upper(name):
     return name.upper().replace('-', '_')
@@ -28,12 +29,12 @@ import yaml
                    "ynl_cb_array, NLMSG_MIN_TYPE)"
 
 
-class Type:
-    def __init__(self, family, attr_set, attr):
-        self.family = family
+class Type(SpecAttr):
+    def __init__(self, family, attr_set, attr, value):
+        super().__init__(family, attr_set, attr, value)
+
         self.attr = attr
-        self.value = attr['value']
-        self.name = c_lower(attr['name'])
+        self.attr_set = attr_set
         self.type = attr['type']
         self.checks = attr.get('checks', {})
 
@@ -46,17 +47,17 @@ import yaml
             else:
                 self.nested_render_name = f"{family.name}_{c_lower(self.nested_attrs)}"
 
-        self.enum_name = f"{attr_set.name_prefix}{self.name}"
-        self.enum_name = c_upper(self.enum_name)
         self.c_name = c_lower(self.name)
         if self.c_name in _C_KW:
             self.c_name += '_'
 
-    def __getitem__(self, key):
-        return self.attr[key]
+        # Added by resolve():
+        self.enum_name = None
+        delattr(self, "enum_name")
 
-    def __contains__(self, key):
-        return key in self.attr
+    def resolve(self):
+        self.enum_name = f"{self.attr_set.name_prefix}{self.name}"
+        self.enum_name = c_upper(self.enum_name)
 
     def is_multi_val(self):
         return None
@@ -214,24 +215,34 @@ import yaml
 
 
 class TypeScalar(Type):
-    def __init__(self, family, attr_set, attr):
-        super().__init__(family, attr_set, attr)
+    def __init__(self, family, attr_set, attr, value):
+        super().__init__(family, attr_set, attr, value)
+
+        self.byte_order_comment = ''
+        if 'byte-order' in attr:
+            self.byte_order_comment = f" /* {attr['byte-order']} */"
+
+        # Added by resolve():
+        self.is_bitfield = None
+        delattr(self, "is_bitfield")
+        self.type_name = None
+        delattr(self, "type_name")
+
+    def resolve(self):
+        self.resolve_up(super())
 
-        self.is_bitfield = False
-        if 'enum' in self.attr:
-            self.is_bitfield = family.consts[self.attr['enum']]['type'] == 'flags'
         if 'enum-as-flags' in self.attr and self.attr['enum-as-flags']:
             self.is_bitfield = True
+        elif 'enum' in self.attr:
+            self.is_bitfield = self.family.consts[self.attr['enum']]['type'] == 'flags'
+        else:
+            self.is_bitfield = False
 
         if 'enum' in self.attr and not self.is_bitfield:
-            self.type_name = f"enum {family.name}_{c_lower(self.attr['enum'])}"
+            self.type_name = f"enum {self.family.name}_{c_lower(self.attr['enum'])}"
         else:
             self.type_name = '__' + self.type
 
-        self.byte_order_comment = ''
-        if 'byte-order' in attr:
-            self.byte_order_comment = f" /* {attr['byte-order']} */"
-
     def _mnl_type(self):
         t = self.type
         # mnl does not have a helper for signed types
@@ -648,14 +659,11 @@ import yaml
         return mask
 
 
-class AttrSet:
+class AttrSet(SpecAttrSet):
     def __init__(self, family, yaml):
-        self.yaml = yaml
+        super().__init__(family, yaml)
 
-        self.attrs = dict()
-        self.name = self.yaml['name']
-        if 'subset-of' not in yaml:
-            self.subset_of = None
+        if self.subset_of is None:
             if 'name-prefix' in yaml:
                 pfx = yaml['name-prefix']
             elif self.name == family.name:
@@ -665,83 +673,68 @@ import yaml
             self.name_prefix = c_upper(pfx)
             self.max_name = c_upper(self.yaml.get('attr-max-name', f"{self.name_prefix}max"))
         else:
-            self.subset_of = self.yaml['subset-of']
             self.name_prefix = family.attr_sets[self.subset_of].name_prefix
             self.max_name = family.attr_sets[self.subset_of].max_name
 
+        # Added by resolve:
+        self.c_name = None
+        delattr(self, "c_name")
+
+    def resolve(self):
         self.c_name = c_lower(self.name)
         if self.c_name in _C_KW:
             self.c_name += '_'
-        if self.c_name == family.c_name:
+        if self.c_name == self.family.c_name:
             self.c_name = ''
 
-        val = 0
-        for elem in self.yaml['attributes']:
-            if 'value' in elem:
-                val = elem['value']
-            else:
-                elem['value'] = val
-            val += 1
-
-            if 'multi-attr' in elem and elem['multi-attr']:
-                attr = TypeMultiAttr(family, self, elem)
-            elif elem['type'] in scalars:
-                attr = TypeScalar(family, self, elem)
-            elif elem['type'] == 'unused':
-                attr = TypeUnused(family, self, elem)
-            elif elem['type'] == 'pad':
-                attr = TypePad(family, self, elem)
-            elif elem['type'] == 'flag':
-                attr = TypeFlag(family, self, elem)
-            elif elem['type'] == 'string':
-                attr = TypeString(family, self, elem)
-            elif elem['type'] == 'binary':
-                attr = TypeBinary(family, self, elem)
-            elif elem['type'] == 'nest':
-                attr = TypeNest(family, self, elem)
-            elif elem['type'] == 'array-nest':
-                attr = TypeArrayNest(family, self, elem)
-            elif elem['type'] == 'nest-type-value':
-                attr = TypeNestTypeValue(family, self, elem)
-            else:
-                raise Exception(f"No typed class for type {elem['type']}")
-
-            self.attrs[elem['name']] = attr
-
-    def __getitem__(self, key):
-        return self.attrs[key]
-
-    def __contains__(self, key):
-        return key in self.yaml
-
-    def __iter__(self):
-        yield from self.attrs
+    def new_attr(self, elem, value):
+        if 'multi-attr' in elem and elem['multi-attr']:
+            return TypeMultiAttr(self.family, self, elem, value)
+        elif elem['type'] in scalars:
+            return TypeScalar(self.family, self, elem, value)
+        elif elem['type'] == 'unused':
+            return TypeUnused(self.family, self, elem, value)
+        elif elem['type'] == 'pad':
+            return TypePad(self.family, self, elem, value)
+        elif elem['type'] == 'flag':
+            return TypeFlag(self.family, self, elem, value)
+        elif elem['type'] == 'string':
+            return TypeString(self.family, self, elem, value)
+        elif elem['type'] == 'binary':
+            return TypeBinary(self.family, self, elem, value)
+        elif elem['type'] == 'nest':
+            return TypeNest(self.family, self, elem, value)
+        elif elem['type'] == 'array-nest':
+            return TypeArrayNest(self.family, self, elem, value)
+        elif elem['type'] == 'nest-type-value':
+            return TypeNestTypeValue(self.family, self, elem, value)
+        else:
+            raise Exception(f"No typed class for type {elem['type']}")
 
-    def items(self):
-        return self.attrs.items()
 
+class Operation(SpecOperation):
+    def __init__(self, family, yaml, req_value, rsp_value):
+        super().__init__(family, yaml, req_value, rsp_value)
 
-class Operation:
-    def __init__(self, family, yaml, value):
-        self.yaml = yaml
-        self.value = value
+        if req_value != rsp_value:
+            raise Exception("Directional messages not supported by codegen")
 
-        self.name = self.yaml['name']
         self.render_name = family.name + '_' + c_lower(self.name)
-        self.is_async = 'notify' in yaml or 'event' in yaml
-        if not self.is_async:
-            self.enum_name = family.op_prefix + c_upper(self.name)
-        else:
-            self.enum_name = family.async_op_prefix + c_upper(self.name)
 
         self.dual_policy = ('do' in yaml and 'request' in yaml['do']) and \
                          ('dump' in yaml and 'request' in yaml['dump'])
 
-    def __getitem__(self, key):
-        return self.yaml[key]
+        # Added by resolve:
+        self.enum_name = None
+        delattr(self, "enum_name")
 
-    def __contains__(self, key):
-        return key in self.yaml
+    def resolve(self):
+        self.resolve_up(super())
+
+        if not self.is_async:
+            self.enum_name = self.family.op_prefix + c_upper(self.name)
+        else:
+            self.enum_name = self.family.async_op_prefix + c_upper(self.name)
 
     def add_notification(self, op):
         if 'notify' not in self.yaml:
@@ -751,21 +744,23 @@ import yaml
         self.yaml['notify']['cmds'].append(op)
 
 
-class Family:
+class Family(SpecFamily):
     def __init__(self, file_name):
-        with open(file_name, "r") as stream:
-            self.yaml = yaml.safe_load(stream)
-
-        self.proto = self.yaml.get('protocol', 'genetlink')
-
-        with open(os.path.dirname(os.path.dirname(file_name)) +
-                  f'/{self.proto}.yaml', "r") as stream:
-            schema = yaml.safe_load(stream)
-
-        jsonschema.validate(self.yaml, schema)
-
-        if self.yaml.get('protocol', 'genetlink') not in {'genetlink', 'genetlink-c', 'genetlink-legacy'}:
-            raise Exception("Codegen only supported for genetlink")
+        # Added by resolve:
+        self.c_name = None
+        delattr(self, "c_name")
+        self.op_prefix = None
+        delattr(self, "op_prefix")
+        self.async_op_prefix = None
+        delattr(self, "async_op_prefix")
+        self.mcgrps = None
+        delattr(self, "mcgrps")
+        self.consts = None
+        delattr(self, "consts")
+        self.hooks = None
+        delattr(self, "hooks")
+
+        super().__init__(file_name)
 
         self.fam_key = c_upper(self.yaml.get('c-family-name', self.yaml["name"] + '_FAMILY_NAME'))
         self.ver_key = c_upper(self.yaml.get('c-version-name', self.yaml["name"] + '_FAMILY_VERSION'))
@@ -773,12 +768,18 @@ import yaml
         if 'definitions' not in self.yaml:
             self.yaml['definitions'] = []
 
-        self.name = self.yaml['name']
-        self.c_name = c_lower(self.name)
         if 'uapi-header' in self.yaml:
             self.uapi_header = self.yaml['uapi-header']
         else:
             self.uapi_header = f"linux/{self.name}.h"
+
+    def resolve(self):
+        self.resolve_up(super())
+
+        if self.yaml.get('protocol', 'genetlink') not in {'genetlink', 'genetlink-c', 'genetlink-legacy'}:
+            raise Exception("Codegen only supported for genetlink")
+
+        self.c_name = c_lower(self.name)
         if 'name-prefix' in self.yaml['operations']:
             self.op_prefix = c_upper(self.yaml['operations']['name-prefix'])
         else:
@@ -791,12 +792,6 @@ import yaml
         self.mcgrps = self.yaml.get('mcast-groups', {'list': []})
 
         self.consts = dict()
-        # list of all operations
-        self.msg_list = []
-        # dict of operations which have their own message type (have attributes)
-        self.ops = collections.OrderedDict()
-        self.attr_sets = dict()
-        self.attr_sets_list = []
 
         self.hooks = dict()
         for when in ['pre', 'post']:
@@ -824,11 +819,11 @@ import yaml
         if self.kernel_policy == 'global':
             self._load_global_policy()
 
-    def __getitem__(self, key):
-        return self.yaml[key]
+    def new_attr_set(self, elem):
+        return AttrSet(self, elem)
 
-    def get(self, key, default=None):
-        return self.yaml.get(key, default)
+    def new_operation(self, elem, req_value, rsp_value):
+        return Operation(self, elem, req_value, rsp_value)
 
     # Fake a 'do' equivalent of all events, so that we can render their response parsing
     def _mock_up_events(self):
@@ -847,27 +842,10 @@ import yaml
             else:
                 self.consts[elem['name']] = elem
 
-        for elem in self.yaml['attribute-sets']:
-            attr_set = AttrSet(self, elem)
-            self.attr_sets[elem['name']] = attr_set
-            self.attr_sets_list.append((elem['name'], attr_set), )
-
         ntf = []
-        val = 0
-        for elem in self.yaml['operations']['list']:
-            if 'value' in elem:
-                val = elem['value']
-
-            op = Operation(self, elem, val)
-            val += 1
-
-            self.msg_list.append(op)
-            if 'notify' in elem:
-                ntf.append(op)
-                continue
-            if 'attribute-set' not in elem:
-                continue
-            self.ops[elem['name']] = op
+        for msg in self.msgs.values():
+            if 'notify' in msg:
+                ntf.append(msg)
         for n in ntf:
             self.ops[n['notify']].add_notification(n)
 
@@ -2033,7 +2011,7 @@ _C_KW = {
 
     max_by_define = family.get('max-by-define', False)
 
-    for _, attr_set in family.attr_sets_list:
+    for _, attr_set in family.attr_sets.items():
         if attr_set.subset_of:
             continue
 
@@ -2044,9 +2022,9 @@ _C_KW = {
         uapi_enum_start(family, cw, attr_set.yaml, 'enum-name')
         for _, attr in attr_set.items():
             suffix = ','
-            if attr['value'] != val:
-                suffix = f" = {attr['value']},"
-                val = attr['value']
+            if attr.value != val:
+                suffix = f" = {attr.value},"
+                val = attr.value
             val += 1
             cw.p(attr.enum_name + suffix)
         cw.nl()
@@ -2066,7 +2044,7 @@ _C_KW = {
     max_value = f"({cnt_name} - 1)"
 
     uapi_enum_start(family, cw, family['operations'], 'enum-name')
-    for op in family.msg_list:
+    for op in family.msgs.values():
         if separate_ntf and ('notify' in op or 'event' in op):
             continue
 
@@ -2085,7 +2063,7 @@ _C_KW = {
 
     if separate_ntf:
         uapi_enum_start(family, cw, family['operations'], enum_name='async-enum')
-        for op in family.msg_list:
+        for op in family.msgs.values():
             if separate_ntf and not ('notify' in op or 'event' in op):
                 continue
 
-- 
2.39.1

