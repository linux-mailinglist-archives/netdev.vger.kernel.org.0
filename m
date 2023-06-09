Return-Path: <netdev+bounces-9729-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A7272A57F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:45:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1947F281A84
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038E423D7E;
	Fri,  9 Jun 2023 21:43:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09B621069
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D274BC433A7;
	Fri,  9 Jun 2023 21:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347037;
	bh=VCBy6tnIGaebOCzxVj7F95ghTJQcMRnlKe2LTMsX5Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfoOfqZezptkWwdE2Vs7pI1fkNBu9zgb5918UgXxc203jA2tV0QpSjB1HB5/FJTLt
	 02g0zTzlwewdw3Im4tXd4Gf8cwUxzktj1qAKzFhpPc/2tzaSm9nMs0S7K6Mb0VKNML
	 ZwKG/8v0BXHyp1zOpxvg0u+w63cer0cu1NBOB8fg49q2ZgVj9ex8gnAafXPlXKvbtu
	 CKFeKTMbGQ83XlxxtiLz3Zl8jEfkdJ73BzK5z6psRk70Fnl/4MEjzNCdcVCDa3sDhx
	 aUzHQLg0dZMeR5dDw2+NTpXljS0dTteFtJGMKgUeHwj+V+qO0mVEQz5/pYHXVLqHnK
	 /2tp8r5rALZ7Q==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/12] tools: ynl-gen: resolve enum vs struct name conflicts
Date: Fri,  9 Jun 2023 14:43:40 -0700
Message-Id: <20230609214346.1605106-7-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
References: <20230609214346.1605106-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ethtool has an attribute set called stringset, from which
we'll generate struct ethtool_stringset. Unfortunately,
the old ethtool header declares enum ethtool_stringset
(the same name), to which compilers object.

This seems unavoidable. Check struct names against known
constants and append an underscore if conflict is detected.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 82ee6c7fa22d..870f98d0e12c 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -49,6 +49,11 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
             else:
                 self.nested_render_name = f"{family.name}_{c_lower(self.nested_attrs)}"
 
+            if self.nested_attrs in self.family.consts:
+                self.nested_struct_type = 'struct ' + self.nested_render_name + '_'
+            else:
+                self.nested_struct_type = 'struct ' + self.nested_render_name
+
         self.c_name = c_lower(self.name)
         if self.c_name in _C_KW:
             self.c_name += '_'
@@ -425,7 +430,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
 
 class TypeNest(Type):
     def _complex_member_type(self, ri):
-        return f"struct {self.nested_render_name}"
+        return self.nested_struct_type
 
     def free(self, ri, var, ref):
         ri.cw.p(f'{self.nested_render_name}_free(&{var}->{ref}{self.c_name});')
@@ -470,7 +475,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
 
     def _complex_member_type(self, ri):
         if 'type' not in self.attr or self.attr['type'] == 'nest':
-            return f"struct {self.nested_render_name}"
+            return self.nested_struct_type
         elif self.attr['type'] in scalars:
             scalar_pfx = '__' if ri.ku_space == 'user' else ''
             return scalar_pfx + self.attr['type']
@@ -530,7 +535,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
 
     def _complex_member_type(self, ri):
         if 'sub-type' not in self.attr or self.attr['sub-type'] == 'nest':
-            return f"struct {self.nested_render_name}"
+            return self.nested_struct_type
         elif self.attr['sub-type'] in scalars:
             scalar_pfx = '__' if ri.ku_space == 'user' else ''
             return scalar_pfx + self.attr['sub-type']
@@ -550,7 +555,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
 
 class TypeNestTypeValue(Type):
     def _complex_member_type(self, ri):
-        return f"struct {self.nested_render_name}"
+        return self.nested_struct_type
 
     def _attr_typol(self):
         return f'.type = YNL_PT_NEST, .nest = &{self.nested_render_name}_nest, '
@@ -593,6 +598,8 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         else:
             self.render_name = f"{family.name}_{c_lower(space_name)}"
         self.struct_name = 'struct ' + self.render_name
+        if self.nested and space_name in family.consts:
+            self.struct_name += '_'
         self.ptr_name = self.struct_name + ' *'
 
         self.request = False
@@ -994,10 +1001,13 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         if not self.attr_set:
             self.attr_set = op['attribute-set']
 
+        self.type_name_conflict = False
         if op:
             self.type_name = c_lower(op.name)
         else:
             self.type_name = c_lower(attr_set)
+            if attr_set in family.consts:
+                self.type_name_conflict = True
 
         self.cw = cw
 
@@ -1634,12 +1644,17 @@ _C_KW = {
 
 def print_free_prototype(ri, direction, suffix=';'):
     name = op_prefix(ri, direction)
+    struct_name = name
+    if ri.type_name_conflict:
+        struct_name += '_'
     arg = free_arg_name(direction)
-    ri.cw.write_func_prot('void', f"{name}_free", [f"struct {name} *{arg}"], suffix=suffix)
+    ri.cw.write_func_prot('void', f"{name}_free", [f"struct {struct_name} *{arg}"], suffix=suffix)
 
 
 def _print_type(ri, direction, struct):
     suffix = f'_{ri.type_name}{direction_to_suffix[direction]}'
+    if not direction and ri.type_name_conflict:
+        suffix += '_'
 
     if ri.op_mode == 'dump':
         suffix += '_dump'
-- 
2.40.1


