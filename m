Return-Path: <netdev+bounces-9378-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 22732728A0E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF220281818
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F39F38CCC;
	Thu,  8 Jun 2023 21:12:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8956F2D279
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169CDC43442;
	Thu,  8 Jun 2023 21:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258731;
	bh=NDbhbecnx/8eBmJewgeuLrNk8s2uDC3hTrdlwOqBt5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrdWxGb16JZTj3ZMappLP/+T8lewy+L6eKxgWzx+C0xn+QoLUJzimJadTq5reor0b
	 ohqw0dmdOp1Bq0evq6jfeOmOID8nktQ7UytsXqjTt6GEfUjqFvhP9ZkLWvn6GLDYLC
	 fxcra6iWGYl/MiH5bobClWChE9EbgrrS9cRh98jHocj/yMHESoMEusEwzYqWLwpXzH
	 9ZvM2Yx7coUJAQL7JqGRZP7hvPQAPn/BjGnHWRKUEVpOhWHwtXqVLyTP1tNyOZLTnc
	 1huD7D2BGehpDILK8n/OrFpP4qM9PLQIl2yW5olrc0dAX4n1TDS4FmolZhor7G0Q6n
	 +9IvAH13oIOUg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/12] tools: ynl-gen: don't pass op_name to RenderInfo
Date: Thu,  8 Jun 2023 14:11:59 -0700
Message-Id: <20230608211200.1247213-12-kuba@kernel.org>
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

The op_name argument is barely used and identical to op.name
in all cases.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index ccd73f10384c..be860dee7239 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -957,13 +957,12 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
 
 
 class RenderInfo:
-    def __init__(self, cw, family, ku_space, op, op_name, op_mode, attr_set=None):
+    def __init__(self, cw, family, ku_space, op, op_mode, attr_set=None):
         self.family = family
         self.nl = cw.nlib
         self.ku_space = ku_space
         self.op_mode = op_mode
         self.op = op
-        self.op_name = op_name
 
         # 'do' and 'dump' response parsing is identical
         self.type_consistent = True
@@ -978,7 +977,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
             self.attr_set = op['attribute-set']
 
         if op:
-            self.type_name = c_lower(op_name)
+            self.type_name = c_lower(op.name)
         else:
             self.type_name = c_lower(attr_set)
 
@@ -2197,16 +2196,16 @@ _C_KW = {
         for ntf_op_name, ntf_op in family.ntfs.items():
             if 'notify' in ntf_op:
                 op = family.ops[ntf_op['notify']]
-                ri = RenderInfo(cw, family, "user", op, op.name, "notify")
+                ri = RenderInfo(cw, family, "user", op, "notify")
             elif 'event' in ntf_op:
-                ri = RenderInfo(cw, family, "user", ntf_op, ntf_op_name, "event")
+                ri = RenderInfo(cw, family, "user", ntf_op, "event")
             else:
                 raise Exception('Invalid notification ' + ntf_op_name)
             _render_user_ntf_entry(ri, ntf_op)
         for op_name, op in family.ops.items():
             if 'event' not in op:
                 continue
-            ri = RenderInfo(cw, family, "user", op, op_name, "event")
+            ri = RenderInfo(cw, family, "user", op, "event")
             _render_user_ntf_entry(ri, op)
         cw.block_end(line=";")
         cw.nl()
@@ -2343,7 +2342,7 @@ _C_KW = {
             if parsed.kernel_policy in {'per-op', 'split'}:
                 for op_name, op in parsed.ops.items():
                     if 'do' in op and 'event' not in op:
-                        ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
+                        ri = RenderInfo(cw, parsed, args.mode, op, "do")
                         print_req_policy_fwd(cw, ri.struct['request'], ri=ri)
                         cw.nl()
 
@@ -2372,7 +2371,7 @@ _C_KW = {
                     for op_mode in ['do', 'dump']:
                         if op_mode in op and 'request' in op[op_mode]:
                             cw.p(f"/* {op.enum_name} - {op_mode} */")
-                            ri = RenderInfo(cw, parsed, args.mode, op, op_name, op_mode)
+                            ri = RenderInfo(cw, parsed, args.mode, op, op_mode)
                             print_req_policy(cw, ri.struct['request'], ri=ri)
                             cw.nl()
 
@@ -2392,7 +2391,7 @@ _C_KW = {
 
             cw.p('/* Common nested types */')
             for attr_set, struct in parsed.pure_nested_structs.items():
-                ri = RenderInfo(cw, parsed, args.mode, "", "", "", attr_set)
+                ri = RenderInfo(cw, parsed, args.mode, "", "", attr_set)
                 print_type_full(ri, struct)
 
             for op_name, op in parsed.ops.items():
@@ -2400,7 +2399,7 @@ _C_KW = {
 
                 if 'do' in op and 'event' not in op:
                     cw.p(f"/* {op.enum_name} - do */")
-                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
+                    ri = RenderInfo(cw, parsed, args.mode, op, "do")
                     print_req_type(ri)
                     print_req_type_helpers(ri)
                     cw.nl()
@@ -2412,7 +2411,7 @@ _C_KW = {
 
                 if 'dump' in op:
                     cw.p(f"/* {op.enum_name} - dump */")
-                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'dump')
+                    ri = RenderInfo(cw, parsed, args.mode, op, 'dump')
                     if 'request' in op['dump']:
                         print_req_type(ri)
                         print_req_type_helpers(ri)
@@ -2424,14 +2423,14 @@ _C_KW = {
 
                 if op.has_ntf:
                     cw.p(f"/* {op.enum_name} - notify */")
-                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
+                    ri = RenderInfo(cw, parsed, args.mode, op, 'notify')
                     if not ri.type_consistent:
                         raise Exception(f'Only notifications with consistent types supported ({op.name})')
                     print_wrapped_type(ri)
 
             for op_name, op in parsed.ntfs.items():
                 if 'event' in op:
-                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'event')
+                    ri = RenderInfo(cw, parsed, args.mode, op, 'event')
                     cw.p(f"/* {op.enum_name} - event */")
                     print_rsp_type(ri)
                     cw.nl()
@@ -2456,7 +2455,7 @@ _C_KW = {
 
             cw.p('/* Common nested types */')
             for attr_set, struct in parsed.pure_nested_structs.items():
-                ri = RenderInfo(cw, parsed, args.mode, "", "", "", attr_set)
+                ri = RenderInfo(cw, parsed, args.mode, "", "", attr_set)
 
                 free_rsp_nested(ri, struct)
                 if struct.request:
@@ -2468,7 +2467,7 @@ _C_KW = {
                 cw.p(f"/* ============== {op.enum_name} ============== */")
                 if 'do' in op and 'event' not in op:
                     cw.p(f"/* {op.enum_name} - do */")
-                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
+                    ri = RenderInfo(cw, parsed, args.mode, op, "do")
                     print_req_free(ri)
                     print_rsp_free(ri)
                     parse_rsp_msg(ri)
@@ -2477,7 +2476,7 @@ _C_KW = {
 
                 if 'dump' in op:
                     cw.p(f"/* {op.enum_name} - dump */")
-                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "dump")
+                    ri = RenderInfo(cw, parsed, args.mode, op, "dump")
                     if not ri.type_consistent:
                         parse_rsp_msg(ri, deref=True)
                     print_dump_type_free(ri)
@@ -2486,7 +2485,7 @@ _C_KW = {
 
                 if op.has_ntf:
                     cw.p(f"/* {op.enum_name} - notify */")
-                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
+                    ri = RenderInfo(cw, parsed, args.mode, op, 'notify')
                     if not ri.type_consistent:
                         raise Exception(f'Only notifications with consistent types supported ({op.name})')
                     print_ntf_type_free(ri)
@@ -2495,10 +2494,10 @@ _C_KW = {
                 if 'event' in op:
                     cw.p(f"/* {op.enum_name} - event */")
 
-                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
+                    ri = RenderInfo(cw, parsed, args.mode, op, "do")
                     parse_rsp_msg(ri)
 
-                    ri = RenderInfo(cw, parsed, args.mode, op, op_name, "event")
+                    ri = RenderInfo(cw, parsed, args.mode, op, "event")
                     print_ntf_type_free(ri)
             cw.nl()
             render_user_family(parsed, cw, False)
-- 
2.40.1


