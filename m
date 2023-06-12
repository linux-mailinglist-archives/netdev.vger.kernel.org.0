Return-Path: <netdev+bounces-10181-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED32772CADD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 18:00:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A83A52810ED
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DA821CCA;
	Mon, 12 Jun 2023 15:59:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44241E532
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB994C4339E;
	Mon, 12 Jun 2023 15:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686585573;
	bh=HRNikLWTkzcc0XIrBypbMxwvqb4X0E5nfqyox2f8A5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXEtjk4+f1ygHfhzCmYpPTbcSe0lzMG18pRoVmlwMSRP003+mcLYt9oBMgXY4Fiq3
	 Re/T5S/JuHgHfxfis+4d3MXvrY6wFKIxDId5lbIZsg/9bbLTiaWjSCck6WIaCl/i55
	 0oM5VGysi3WihnB/CFb7wyifwOUe6+Afj+jZjrq0lQ1cVkz4Y4ZM1xyqTpLKtAgzpR
	 R//+umqMpeE1EAFzr7JOqbCT8VA/ZcXuCKUDtTVX5MTBYHa2jn4D0hAnIO0FDPVr04
	 mDe8yqYVf43dUzW+gTkgwSfyclSttvS+txVBNWowwPHP3qiOSOeVWtk5g2eLBnmKgj
	 87Rbbidjz42Dw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	arkadiusz.kubalewski@intel.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/2] tools: ynl-gen: inherit policy in multi-attr
Date: Mon, 12 Jun 2023 08:59:20 -0700
Message-Id: <20230612155920.1787579-3-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612155920.1787579-1-kuba@kernel.org>
References: <20230612155920.1787579-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of reimplementing policies in MutliAttr for every
underlying type forward the calls to the base type.
This will be needed for DPLL which uses a multi-attr nest,
and currently gets an invalid NLA_NEST policy generated.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 42 ++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 54777d529f5e..71c5e79e877f 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -462,6 +462,11 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
 
 
 class TypeMultiAttr(Type):
+    def __init__(self, family, attr_set, attr, value, base_type):
+        super().__init__(family, attr_set, attr, value)
+
+        self.base_type = base_type
+
     def is_multi_val(self):
         return True
 
@@ -497,13 +502,11 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         else:
             raise Exception(f"Free of MultiAttr sub-type {self.attr['type']} not supported yet")
 
+    def _attr_policy(self, policy):
+        return self.base_type._attr_policy(policy)
+
     def _attr_typol(self):
-        if 'type' not in self.attr or self.attr['type'] == 'nest':
-            return f'.type = YNL_PT_NEST, .nest = &{self.nested_render_name}_nest, '
-        elif self.attr['type'] in scalars:
-            return f".type = YNL_PT_U{self.attr['type'][1:]}, "
-        else:
-            raise Exception(f"Sub-type {self.attr['type']} not supported yet")
+        return self.base_type._attr_typol()
 
     def _attr_get(self, ri, var):
         return f'n_{self.c_name}++;', None, None
@@ -717,29 +720,32 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
             self.c_name = ''
 
     def new_attr(self, elem, value):
-        if 'multi-attr' in elem and elem['multi-attr']:
-            return TypeMultiAttr(self.family, self, elem, value)
-        elif elem['type'] in scalars:
-            return TypeScalar(self.family, self, elem, value)
+        if elem['type'] in scalars:
+            t = TypeScalar(self.family, self, elem, value)
         elif elem['type'] == 'unused':
-            return TypeUnused(self.family, self, elem, value)
+            t = TypeUnused(self.family, self, elem, value)
         elif elem['type'] == 'pad':
-            return TypePad(self.family, self, elem, value)
+            t = TypePad(self.family, self, elem, value)
         elif elem['type'] == 'flag':
-            return TypeFlag(self.family, self, elem, value)
+            t = TypeFlag(self.family, self, elem, value)
         elif elem['type'] == 'string':
-            return TypeString(self.family, self, elem, value)
+            t = TypeString(self.family, self, elem, value)
         elif elem['type'] == 'binary':
-            return TypeBinary(self.family, self, elem, value)
+            t = TypeBinary(self.family, self, elem, value)
         elif elem['type'] == 'nest':
-            return TypeNest(self.family, self, elem, value)
+            t = TypeNest(self.family, self, elem, value)
         elif elem['type'] == 'array-nest':
-            return TypeArrayNest(self.family, self, elem, value)
+            t = TypeArrayNest(self.family, self, elem, value)
         elif elem['type'] == 'nest-type-value':
-            return TypeNestTypeValue(self.family, self, elem, value)
+            t = TypeNestTypeValue(self.family, self, elem, value)
         else:
             raise Exception(f"No typed class for type {elem['type']}")
 
+        if 'multi-attr' in elem and elem['multi-attr']:
+            t = TypeMultiAttr(self.family, self, elem, value, t)
+
+        return t
+
 
 class Operation(SpecOperation):
     def __init__(self, family, yaml, req_value, rsp_value):
-- 
2.40.1


