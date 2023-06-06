Return-Path: <netdev+bounces-8615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BCA6724D63
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06F6C28102A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A3228C1A;
	Tue,  6 Jun 2023 19:43:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F7623C92
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 19:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B7EC4339E;
	Tue,  6 Jun 2023 19:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686080599;
	bh=xub2e/hMBYWQKwxfR/GuJ3tWcPCh0chrgfYsiXnbpbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHccs3lc9AZE/2uUB1Gcs3iiwPzzn0D7xHrsGdv3Fru9PKKPt+RUbDtamE78f77aD
	 4gxciNko5D5LHbx6xhxmsTbTDMVsNn+5+nUCrc8eQr6qW8h8t7l76r+sTiFXIHGwe8
	 D7N5ZETIrMAVkL9ZS0O79woR2SPIF6nZEfUEWbeOy7d5czLGBYdr/wbFQkR+XvBpRb
	 XkMhyPzl85AzXq1CaN2gZBs+h7EqAgLb6WxP6dWUt/8QV4FNmB1qb0D9+3PDFenhYq
	 6E3CMVH0TFXt8FgkAlkLdhZjaoFHAU59R6wHgCQNiyuo9cr0bWOUoLrC7tUtrYk5Gg
	 5Bj4DqhTVLuYA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	willemdebruijn.kernel@gmail.com,
	chuck.lever@oracle.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] tools: ynl-gen: improve unwind on parsing errors
Date: Tue,  6 Jun 2023 12:43:01 -0700
Message-Id: <20230606194302.919343-3-kuba@kernel.org>
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

When parsing multi-attr we count the objects and then allocate
an array to hold the parsed objects. If an attr space has multiple
multi-attr objects, however, if parsing the first array fails
we'll leave the object count for the second even tho the second
array was never allocated.

This may cause crashes when freeing objects on error.

Count attributes to a variable on the stack and only set the count
in the object once the memory was allocated.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 0a043edf5e03..c07340715601 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -488,7 +488,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
             raise Exception(f"Sub-type {self.attr['type']} not supported yet")
 
     def _attr_get(self, ri, var):
-        return f'{var}->n_{self.c_name}++;', None, None
+        return f'n_{self.c_name}++;', None, None
 
     def attr_put(self, ri, var):
         if self.attr['type'] in scalars:
@@ -1306,6 +1306,11 @@ _C_KW = {
         local_vars.append('struct ynl_parse_arg parg;')
         init_lines.append('parg.ys = yarg->ys;')
 
+    all_multi = array_nests | multi_attrs
+
+    for anest in sorted(all_multi):
+        local_vars.append(f"unsigned int n_{struct[anest].c_name} = 0;")
+
     ri.cw.block_start()
     ri.cw.write_func_lvar(local_vars)
 
@@ -1316,6 +1321,11 @@ _C_KW = {
     for arg in struct.inherited:
         ri.cw.p(f'dst->{arg} = {arg};')
 
+    for anest in sorted(all_multi):
+        aspec = struct[anest]
+        ri.cw.p(f"if (dst->{aspec.c_name})")
+        ri.cw.p(f'return ynl_error_parse(yarg, "attribute already present ({struct.attr_set.name}.{aspec.name})");')
+
     ri.cw.nl()
     ri.cw.block_start(line=iter_line)
 
@@ -1331,8 +1341,9 @@ _C_KW = {
     for anest in sorted(array_nests):
         aspec = struct[anest]
 
-        ri.cw.block_start(line=f"if (dst->n_{aspec.c_name})")
-        ri.cw.p(f"dst->{aspec.c_name} = calloc(dst->n_{aspec.c_name}, sizeof(*dst->{aspec.c_name}));")
+        ri.cw.block_start(line=f"if (n_{aspec.c_name})")
+        ri.cw.p(f"dst->{aspec.c_name} = calloc({aspec.c_name}, sizeof(*dst->{aspec.c_name}));")
+        ri.cw.p(f"dst->n_{aspec.c_name} = n_{aspec.c_name};")
         ri.cw.p('i = 0;')
         ri.cw.p(f"parg.rsp_policy = &{aspec.nested_render_name}_nest;")
         ri.cw.block_start(line=f"mnl_attr_for_each_nested(attr, attr_{aspec.c_name})")
@@ -1346,8 +1357,9 @@ _C_KW = {
 
     for anest in sorted(multi_attrs):
         aspec = struct[anest]
-        ri.cw.block_start(line=f"if (dst->n_{aspec.c_name})")
-        ri.cw.p(f"dst->{aspec.c_name} = calloc(dst->n_{aspec.c_name}, sizeof(*dst->{aspec.c_name}));")
+        ri.cw.block_start(line=f"if (n_{aspec.c_name})")
+        ri.cw.p(f"dst->{aspec.c_name} = calloc(n_{aspec.c_name}, sizeof(*dst->{aspec.c_name}));")
+        ri.cw.p(f"dst->n_{aspec.c_name} = n_{aspec.c_name};")
         ri.cw.p('i = 0;')
         if 'nested-attributes' in aspec:
             ri.cw.p(f"parg.rsp_policy = &{aspec.nested_render_name}_nest;")
-- 
2.40.1


