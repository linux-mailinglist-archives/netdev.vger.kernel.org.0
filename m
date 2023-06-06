Return-Path: <netdev+bounces-8614-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B1B724D62
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:43:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E02271C20B84
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2982720F;
	Tue,  6 Jun 2023 19:43:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978DF22E5C
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 19:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D67AC4339C;
	Tue,  6 Jun 2023 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686080598;
	bh=RCZtiym6gbHYr4RxFztUlv2TZf5mpgG6c9nFFRZ37UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h682oC/xwseP+CqXj7tfj8BuPV1yhMxCGpao+8i34/zzmwzIQLM/x0xAGRuI4Vohp
	 iJO1FLu9wcqsISjYUOdC/w8qGjxcEBlmUPJcfNRvvq2MBpUSgpSQOJ7w8DdhrQ54n0
	 U1ZqzqBKGxvoegqaOEpAw/waIeD1n1WW945atnQv/72QNG/39w+MMgPFNdKA4PHSeq
	 MpFpiOqcrOIiQloIAS/cUDf8vLmf/VUVdC87D0ZZQ5pQR3WH1NZ8a9dxKQCpdnoG/r
	 C6WG0RtZHF8gR2sL86h/26n2Bf/A2XFu2GOEI/wGIMyU0PYaQAAo6G/eFlh0KYp4qr
	 xioWZBp4vg0Dw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	willemdebruijn.kernel@gmail.com,
	chuck.lever@oracle.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] tools: ynl-gen: fill in support for MultiAttr scalars
Date: Tue,  6 Jun 2023 12:43:00 -0700
Message-Id: <20230606194302.919343-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606194302.919343-1-kuba@kernel.org>
References: <20230606194302.919343-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The handshake family needs support for MultiAttr scalars.
Right now we only support code gen for MultiAttr nested
types.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 47 ++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 1e64c5c2a087..0a043edf5e03 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -94,7 +94,10 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def arg_member(self, ri):
         member = self._complex_member_type(ri)
         if member:
-            return [member + ' *' + self.c_name]
+            arg = [member + ' *' + self.c_name]
+            if self.presence_type() == 'count':
+                arg += ['unsigned int n_' + self.c_name]
+            return arg
         raise Exception(f"Struct member not implemented for class type {self.type}")
 
     def struct_member(self, ri):
@@ -188,9 +191,12 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                 code.append(presence + ' = 1;')
         code += self._setter_lines(ri, member, presence)
 
-        ri.cw.write_func('static inline void',
-                         f"{op_prefix(ri, direction, deref=deref)}_set_{'_'.join(ref)}",
-                         body=code,
+        func_name = f"{op_prefix(ri, direction, deref=deref)}_set_{'_'.join(ref)}"
+        free = bool([x for x in code if 'free(' in x])
+        alloc = bool([x for x in code if 'alloc(' in x])
+        if free and not alloc:
+            func_name = '__' + func_name
+        ri.cw.write_func('static inline void', func_name, body=code,
                          args=[f'{type_name(ri, direction, deref=deref)} *{var}'] + self.arg_member(ri))
 
 
@@ -444,6 +450,13 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def presence_type(self):
         return 'count'
 
+    def _mnl_type(self):
+        t = self.type
+        # mnl does not have a helper for signed types
+        if t[0] == 's':
+            t = 'u' + t[1:]
+        return t
+
     def _complex_member_type(self, ri):
         if 'type' not in self.attr or self.attr['type'] == 'nest':
             return f"struct {self.nested_render_name}"
@@ -457,9 +470,14 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         return 'type' not in self.attr or self.attr['type'] == 'nest'
 
     def free(self, ri, var, ref):
-        if 'type' not in self.attr or self.attr['type'] == 'nest':
+        if self.attr['type'] in scalars:
+            ri.cw.p(f"free({var}->{ref}{self.c_name});")
+        elif 'type' not in self.attr or self.attr['type'] == 'nest':
             ri.cw.p(f"for (i = 0; i < {var}->{ref}n_{self.c_name}; i++)")
             ri.cw.p(f'{self.nested_render_name}_free(&{var}->{ref}{self.c_name}[i]);')
+            ri.cw.p(f"free({var}->{ref}{self.c_name});")
+        else:
+            raise Exception(f"Free of MultiAttr sub-type {self.attr['type']} not supported yet")
 
     def _attr_typol(self):
         if 'type' not in self.attr or self.attr['type'] == 'nest':
@@ -472,6 +490,25 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def _attr_get(self, ri, var):
         return f'{var}->n_{self.c_name}++;', None, None
 
+    def attr_put(self, ri, var):
+        if self.attr['type'] in scalars:
+            put_type = self._mnl_type()
+            ri.cw.p(f"for (unsigned int i = 0; i < {var}->n_{self.c_name}; i++)")
+            ri.cw.p(f"mnl_attr_put_{put_type}(nlh, {self.enum_name}, {var}->{self.c_name}[i]);")
+        elif 'type' not in self.attr or self.attr['type'] == 'nest':
+            ri.cw.p(f"for (unsigned int i = 0; i < {var}->n_{self.c_name}; i++)")
+            self._attr_put_line(ri, var, f"{self.nested_render_name}_put(nlh, " +
+                                f"{self.enum_name}, &{var}->{self.c_name}[i])")
+        else:
+            raise Exception(f"Put of MultiAttr sub-type {self.attr['type']} not supported yet")
+
+    def _setter_lines(self, ri, member, presence):
+        # For multi-attr we have a count, not presence, hack up the presence
+        presence = presence[:-(len('_present.') + len(self.c_name))] + "n_" + self.c_name
+        return [f"free({member});",
+                f"{member} = {self.c_name};",
+                f"{presence} = n_{self.c_name};"]
+
 
 class TypeArrayNest(Type):
     def is_multi_val(self):
-- 
2.40.1


