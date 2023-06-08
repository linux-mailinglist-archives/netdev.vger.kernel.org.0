Return-Path: <netdev+bounces-9376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14796728A0C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:14:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE07328180E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09D3370DA;
	Thu,  8 Jun 2023 21:12:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C8334CFD
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350ACC433B3;
	Thu,  8 Jun 2023 21:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258730;
	bh=CC14cFt6sXVGTbBsKUA3SmNQAWu/8m3dJQxKdKsCDa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOga/s4MZyvDUn2LIM4AkyRZOTD/S/XCIoi3JfkMkSaWlRyfr/y+ollm5UWv6IgOk
	 07VVuBOKtZmvgBwuR/6VF970SJUuOm02ziJiAmj8rxtdW9b5IOxctaY+ZTOqsGYaug
	 KkECVLdFqlbte1j7Omv1rjRUQR2Wxb8IXXwf8XsIfz6wTjbLaiHhAeT+lvIU3eTBFl
	 vVChRaM5mL+r3UOv4GlhvmcbV259hAgGmzPe+rDqe2SPBZaDnFY2lfQdZ+/gQS8iuU
	 2swZtRSfytA4r9frWoTRZv0iOpBq/WTrZUXIHaL8lHDZUxtA+Zo56Bi4DNex8+/NvL
	 KYExUeOairMfw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/12] tools: ynl-gen: sanitize notification tracking
Date: Thu,  8 Jun 2023 14:11:57 -0700
Message-Id: <20230608211200.1247213-10-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608211200.1247213-1-kuba@kernel.org>
References: <20230608211200.1247213-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't modify the raw dicts (as loaded from YAML) to pretend
that the notify attributes also exist on the ops. This makes
the code easier to follow.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py |  5 ++-
 tools/net/ynl/ynl-gen-c.py  | 65 +++++++++++++------------------------
 2 files changed, 27 insertions(+), 43 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 9f7ad87d69af..623c5702bd10 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -329,8 +329,8 @@ jsonschema = None
 
         attr_sets  dict of attribute sets
         msgs       dict of all messages (index by name)
-        msgs_by_value  dict of all messages (indexed by name)
         ops        dict of all valid requests / responses
+        ntfs       dict of all async events
         consts     dict of all constants/enums
         fixed_header  string, optional name of family default fixed header struct
     """
@@ -370,6 +370,7 @@ jsonschema = None
         self.req_by_value = collections.OrderedDict()
         self.rsp_by_value = collections.OrderedDict()
         self.ops = collections.OrderedDict()
+        self.ntfs = collections.OrderedDict()
         self.consts = collections.OrderedDict()
 
         last_exception = None
@@ -491,3 +492,5 @@ jsonschema = None
                 self.rsp_by_value[op.rsp_value] = op
             if not op.is_async and 'attribute-set' in op:
                 self.ops[op.name] = op
+            elif op.is_async:
+                self.ntfs[op.name] = op
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index f88417947e60..a230598d216f 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -714,6 +714,8 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         self.dual_policy = ('do' in yaml and 'request' in yaml['do']) and \
                          ('dump' in yaml and 'request' in yaml['dump'])
 
+        self.has_ntf = False
+
         # Added by resolve:
         self.enum_name = None
         delattr(self, "enum_name")
@@ -726,12 +728,8 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         else:
             self.enum_name = self.family.async_op_prefix + c_upper(self.name)
 
-    def add_notification(self, op):
-        if 'notify' not in self.yaml:
-            self.yaml['notify'] = dict()
-            self.yaml['notify']['reply'] = self.yaml['do']['reply']
-            self.yaml['notify']['cmds'] = []
-        self.yaml['notify']['cmds'].append(op)
+    def mark_has_ntf(self):
+        self.has_ntf = True
 
 
 class Family(SpecFamily):
@@ -793,14 +791,12 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         self.root_sets = dict()
         # dict space-name -> set('request', 'reply')
         self.pure_nested_structs = dict()
-        self.all_notify = dict()
 
+        self._mark_notify()
         self._mock_up_events()
 
-        self._dictify()
         self._load_root_sets()
         self._load_nested_sets()
-        self._load_all_notify()
         self._load_hooks()
 
         self.kernel_policy = self.yaml.get('kernel-policy', 'split')
@@ -816,6 +812,11 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def new_operation(self, elem, req_value, rsp_value):
         return Operation(self, elem, req_value, rsp_value)
 
+    def _mark_notify(self):
+        for op in self.msgs.values():
+            if 'notify' in op:
+                self.ops[op['notify']].mark_has_ntf()
+
     # Fake a 'do' equivalent of all events, so that we can render their response parsing
     def _mock_up_events(self):
         for op in self.yaml['operations']['list']:
@@ -826,14 +827,6 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                     }
                 }
 
-    def _dictify(self):
-        ntf = []
-        for msg in self.msgs.values():
-            if 'notify' in msg:
-                ntf.append(msg)
-        for n in ntf:
-            self.ops[n['notify']].add_notification(n)
-
     def _load_root_sets(self):
         for op_name, op in self.ops.items():
             if 'attribute-set' not in op:
@@ -922,14 +915,6 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                         child.request |= struct.request
                         child.reply |= struct.reply
 
-    def _load_all_notify(self):
-        for op_name, op in self.ops.items():
-            if not op:
-                continue
-
-            if 'notify' in op:
-                self.all_notify[op_name] = op['notify']['cmds']
-
     def _load_global_policy(self):
         global_set = set()
         attr_set_name = None
@@ -968,21 +953,15 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                     self.hooks[when][op_mode]['set'].add(name)
                     self.hooks[when][op_mode]['list'].append(name)
 
-    def has_notifications(self):
-        for op in self.ops.values():
-            if 'notify' in op or 'event' in op:
-                return True
-        return False
-
 
 class RenderInfo:
     def __init__(self, cw, family, ku_space, op, op_name, op_mode, attr_set=None):
         self.family = family
         self.nl = cw.nlib
         self.ku_space = ku_space
+        self.op_mode = op_mode
         self.op = op
         self.op_name = op_name
-        self.op_mode = op_mode
 
         # 'do' and 'dump' response parsing is identical
         self.type_consistent = True
@@ -1004,6 +983,8 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         self.cw = cw
 
         self.struct = dict()
+        if op_mode == 'notify':
+            op_mode = 'do'
         for op_dir in ['request', 'reply']:
             if op and op_dir in op[op_mode]:
                 self.struct[op_dir] = Struct(family, self.attr_set,
@@ -2209,14 +2190,14 @@ _C_KW = {
         cw.p(f'extern {symbol};')
         return
 
-    ntf = family.has_notifications()
-    if ntf:
+    if family.ntfs:
         cw.block_start(line=f"static const struct ynl_ntf_info {family['name']}_ntf_info[] = ")
-        for ntf_op in sorted(family.all_notify.keys()):
-            op = family.ops[ntf_op]
-            ri = RenderInfo(cw, family, "user", op, ntf_op, "notify")
-            for ntf in op['notify']['cmds']:
-                _render_user_ntf_entry(ri, ntf)
+        for ntf_op_name, ntf_op in family.ntfs.items():
+            if 'notify' not in ntf_op:
+                continue
+            op = family.ops[ntf_op['notify']]
+            ri = RenderInfo(cw, family, "user", op, op.name, "notify")
+            _render_user_ntf_entry(ri, ntf_op)
         for op_name, op in family.ops.items():
             if 'event' not in op:
                 continue
@@ -2227,7 +2208,7 @@ _C_KW = {
 
     cw.block_start(f'{symbol} = ')
     cw.p(f'.name\t\t= "{family.name}",')
-    if ntf:
+    if family.ntfs:
         cw.p(f".ntf_info\t= {family['name']}_ntf_info,")
         cw.p(f".ntf_info_size\t= MNL_ARRAY_SIZE({family['name']}_ntf_info),")
     cw.block_end(line=';')
@@ -2436,7 +2417,7 @@ _C_KW = {
                     print_dump_prototype(ri)
                     cw.nl()
 
-                if 'notify' in op:
+                if op.has_ntf:
                     cw.p(f"/* {op.enum_name} - notify */")
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
                     if not ri.type_consistent:
@@ -2497,7 +2478,7 @@ _C_KW = {
                     print_dump(ri)
                     cw.nl()
 
-                if 'notify' in op:
+                if op.has_ntf:
                     cw.p(f"/* {op.enum_name} - notify */")
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
                     if not ri.type_consistent:
-- 
2.40.1


