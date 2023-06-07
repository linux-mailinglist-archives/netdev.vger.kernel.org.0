Return-Path: <netdev+bounces-9045-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A249726B79
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:25:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A60EB1C20EBF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB7A3B8B1;
	Wed,  7 Jun 2023 20:24:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA73B3AE48
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436B4C4339B;
	Wed,  7 Jun 2023 20:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169449;
	bh=Gizo4l0Z9rZKsGLdyY25LF7qmFMLyCVvG6Ns16BNInI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THMAzyLKdRbwm0Hx2QwY1+cM5ramqkZTkIh1GBZTByjO7VcBz+eVIA0/YD/jYPUWH
	 w+noA/Q7tXpykdrazsUdm50XbuIQHqgY/X83GbDPlugxkWf0/D31znL+oEgjgfEIKK
	 t/kT52g/+PFz1jTA+cj7LHZmT7wASNyh8GnriQdBWNbgaLKM/jSqyMR7p7CmnNVmRm
	 Urx4y2ZTpm2xMA7xbiQC66N3acMA49whmrHg85HhS54aRzO2FhU+rQ7/02SYliQTiv
	 Geco2cacmF4PK8lcdcVluG95gqi0Ws5Sz3fAnYJSw5bxb288esY2DLuVzo+KYY5tNj
	 wHhWZ0xt/88Tg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/11] tools: ynl-gen: try to sort the types more intelligently
Date: Wed,  7 Jun 2023 13:23:57 -0700
Message-Id: <20230607202403.1089925-6-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607202403.1089925-1-kuba@kernel.org>
References: <20230607202403.1089925-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to sort the structures to avoid the need for forward
declarations. While at it remove the sort of structs when
rendering, it doesn't do anything.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 7b3e79e17c01..d9c74a678df8 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -875,6 +875,28 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                         inherit.add('idx')
                     self.pure_nested_structs[nested].set_inherited(inherit)
 
+        # Try to reorder according to dependencies
+        pns_key_list = list(self.pure_nested_structs.keys())
+        pns_key_seen = set()
+        rounds = len(pns_key_list)**2  # it's basically bubble sort
+        for _ in range(rounds):
+            if len(pns_key_list) == 0:
+                break
+            name = pns_key_list.pop(0)
+            finished = True
+            for _, spec in self.attr_sets[name].items():
+                if 'nested-attributes' in spec:
+                    if spec['nested-attributes'] not in pns_key_seen:
+                        # Dicts are sorted, this will make struct last
+                        struct = self.pure_nested_structs.pop(name)
+                        self.pure_nested_structs[name] = struct
+                        finished = False
+                        break
+            if finished:
+                pns_key_seen.add(name)
+            else:
+                pns_key_list.append(name)
+
     def _load_all_notify(self):
         for op_name, op in self.ops.items():
             if not op:
@@ -2379,7 +2401,7 @@ _C_KW = {
             cw.nl()
 
             cw.p('/* Common nested types */')
-            for attr_set, struct in sorted(parsed.pure_nested_structs.items()):
+            for attr_set, struct in parsed.pure_nested_structs.items():
                 ri = RenderInfo(cw, parsed, args.mode, "", "", "", attr_set)
                 print_type_full(ri, struct)
 
@@ -2448,7 +2470,7 @@ _C_KW = {
                 put_typol(cw, struct)
 
             cw.p('/* Common nested types */')
-            for attr_set, struct in sorted(parsed.pure_nested_structs.items()):
+            for attr_set, struct in parsed.pure_nested_structs.items():
                 ri = RenderInfo(cw, parsed, args.mode, "", "", "", attr_set)
 
                 free_rsp_nested(ri, struct)
-- 
2.40.1


