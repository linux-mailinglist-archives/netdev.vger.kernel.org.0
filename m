Return-Path: <netdev+bounces-7293-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4331A71F884
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:38:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F174D2819E7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:38:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F15815CF;
	Fri,  2 Jun 2023 02:36:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489961854
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DB7C433AA;
	Fri,  2 Jun 2023 02:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673358;
	bh=gXZVWSgmqMOaBYFsluAobPSVroTD4QG/HCshrW+9CoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUBLyiRo15BlBgmqNzXxoRPlWIQufHErMxK5pbSJJNCRYy3fiQhrIq8n+ISSeqevB
	 GRCZBBY34Jsjwbtu8mlEQxOEZwWz5PRIPRduAQZ5TitSWcCndvwLweEGqR3vaikzdc
	 2lOwC5rFNsK8fBtTmUNa1Kvu+UdVkyXmrtHPCfA7ZjTebZFsbKpyDu3oM/nonh0au+
	 sfbbZ8owEiQYe5ZEGVKNB4oWqicnBYQ8SoRTfGXXec1ZKPdPVkJObXAs9UO5nkpMEK
	 fJxMhXnXXmdUJ7hl6IOH+sX/9N/r0nO6MYFslTCiVwjtNohktGr3UbL6C063UgrQTo
	 x2lNORLH2nDIA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/10] tools: ynl-gen: generate static descriptions of notifications
Date: Thu,  1 Jun 2023 19:35:48 -0700
Message-Id: <20230602023548.463441-11-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230602023548.463441-1-kuba@kernel.org>
References: <20230602023548.463441-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Notifications may come in at any time. The family must be always
ready to parse a random incoming notification. Generate notification
table for parsing and tell YNL which request we're processing
to distinguish responses from notifications.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 52 ++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 320e5e90920a..4c12c6f8968e 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -887,6 +887,12 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                     self.hooks[when][op_mode]['set'].add(name)
                     self.hooks[when][op_mode]['list'].append(name)
 
+    def has_notifications(self):
+        for op in self.ops.values():
+            if 'notify' in op or 'event' in op:
+                return True
+        return False
+
 
 class RenderInfo:
     def __init__(self, cw, family, ku_space, op, op_name, op_mode, attr_set=None):
@@ -1587,6 +1593,7 @@ _C_KW = {
     elif ri.op_mode == 'notify' or ri.op_mode == 'event':
         ri.cw.p('__u16 family;')
         ri.cw.p('__u8 cmd;')
+        ri.cw.p('struct ynl_ntf_base_type *next;')
         ri.cw.p(f"void (*free)({type_name(ri, 'reply')} *ntf);")
     ri.cw.p(f"{type_name(ri, 'reply', deref=True)} obj __attribute__ ((aligned (8)));")
     ri.cw.block_end(line=';')
@@ -2109,14 +2116,43 @@ _C_KW = {
     cw.p(f'#endif /* {hdr_prot} */')
 
 
+def _render_user_ntf_entry(ri, op):
+    ri.cw.block_start(line=f"[{op.enum_name}] = ")
+    ri.cw.p(f".alloc_sz\t= sizeof({type_name(ri, 'event')}),")
+    ri.cw.p(f".cb\t\t= {op_prefix(ri, 'reply', deref=True)}_parse,")
+    ri.cw.p(f".policy\t\t= &{ri.struct['reply'].render_name}_nest,")
+    ri.cw.p(f".free\t\t= (void *){op_prefix(ri, 'notify')}_free,")
+    ri.cw.block_end(line=',')
+
+
 def render_user_family(family, cw, prototype):
     symbol = f'const struct ynl_family ynl_{family.c_name}_family'
     if prototype:
         cw.p(f'extern {symbol};')
-    else:
-        cw.block_start(f'{symbol} = ')
-        cw.p(f'.name = "{family.name}",')
-        cw.block_end(line=';')
+        return
+
+    ntf = family.has_notifications()
+    if ntf:
+        cw.block_start(line=f"static const struct ynl_ntf_info {family['name']}_ntf_info[] = ")
+        for ntf_op in sorted(family.all_notify.keys()):
+            op = family.ops[ntf_op]
+            ri = RenderInfo(cw, family, "user", op, ntf_op, "notify")
+            for ntf in op['notify']['cmds']:
+                _render_user_ntf_entry(ri, ntf)
+        for op_name, op in family.ops.items():
+            if 'event' not in op:
+                continue
+            ri = RenderInfo(cw, family, "user", op, op_name, "event")
+            _render_user_ntf_entry(ri, op)
+        cw.block_end(line=";")
+        cw.nl()
+
+    cw.block_start(f'{symbol} = ')
+    cw.p(f'.name\t\t= "{family.name}",')
+    if ntf:
+        cw.p(f".ntf_info\t= {family['name']}_ntf_info,")
+        cw.p(f".ntf_info_size\t= MNL_ARRAY_SIZE({family['name']}_ntf_info),")
+    cw.block_end(line=';')
 
 
 def find_kernel_root(full_path):
@@ -2277,7 +2313,6 @@ _C_KW = {
             print_kernel_family_struct_src(parsed, cw)
 
     if args.mode == "user":
-        has_ntf = False
         if args.header:
             cw.p('/* Enums */')
             put_op_name_fwd(parsed, cw)
@@ -2322,7 +2357,6 @@ _C_KW = {
                 if 'notify' in op:
                     cw.p(f"/* {op.enum_name} - notify */")
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
-                    has_ntf = True
                     if not ri.type_consistent:
                         raise Exception(f'Only notifications with consistent types supported ({op.name})')
                     print_wrapped_type(ri)
@@ -2334,7 +2368,7 @@ _C_KW = {
                     cw.nl()
                     print_wrapped_type(ri)
 
-            if has_ntf:
+            if parsed.has_notifications():
                 cw.p('/* --------------- Common notification parsing --------------- */')
                 print_ntf_parse_prototype(parsed, cw)
             cw.nl()
@@ -2390,14 +2424,12 @@ _C_KW = {
                 if 'notify' in op:
                     cw.p(f"/* {op.enum_name} - notify */")
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
-                    has_ntf = True
                     if not ri.type_consistent:
                         raise Exception(f'Only notifications with consistent types supported ({op.name})')
                     print_ntf_type_free(ri)
 
                 if 'event' in op:
                     cw.p(f"/* {op.enum_name} - event */")
-                    has_ntf = True
 
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
                     parse_rsp_msg(ri)
@@ -2405,7 +2437,7 @@ _C_KW = {
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, "event")
                     print_ntf_type_free(ri)
 
-            if has_ntf:
+            if parsed.has_notifications():
                 cw.p('/* --------------- Common notification parsing --------------- */')
                 print_ntf_type_parse(parsed, cw, args.mode)
 
-- 
2.40.1


