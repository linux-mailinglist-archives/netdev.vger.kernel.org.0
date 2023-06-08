Return-Path: <netdev+bounces-9377-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4294728A0D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4543E1C20A8C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:15:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74E038CC7;
	Thu,  8 Jun 2023 21:12:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAD734D62
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1601C433A7;
	Thu,  8 Jun 2023 21:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258730;
	bh=gSOOjP/ssHB9xcWs71xXhkM2W9NOkvhQ75Hgaes2w00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXXQnkM479Y8XfLq/LG5pTYiBdvPVFg0O3X8fgvKPrJ7w/CvGBlZKwc0VKGl1asJn
	 dGTFMwaKZr7BguVA6ILLLLMFxs9VW9tmy6JNvJAXAfvnsjSzu3h3WRKoskWA5jwvlF
	 vQV8fesLgVfpq0NM7KJa9vcvDIxzk1c7Trhgcqpyakid1pcdjTUBu4MWV7sDbnYklE
	 iwAGhrwxWYZCLHHS98OEZodOJu7WoQ/6AnjRuvlVakpHe8GH/oE3+554anKVoUfR7O
	 0YVddb2T2Wu1JYhDycaW8xNLnMfkIqFh7A+l6uBHOBZKZp/TmzeN7sJtZw2FGi9UPZ
	 tD+L995MlMLMQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/12] tools: ynl-gen: support code gen for events
Date: Thu,  8 Jun 2023 14:11:58 -0700
Message-Id: <20230608211200.1247213-11-kuba@kernel.org>
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

Netlink specs support both events and notifications (former can
define their own message contents). Plug in missing code to
generate types, parsers and include events into notification
tables.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py |  2 +-
 tools/net/ynl/ynl-gen-c.py  | 17 ++++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 623c5702bd10..c5d4a6d476a0 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -423,7 +423,7 @@ jsonschema = None
         self.fixed_header = self.yaml['operations'].get('fixed-header')
         req_val = rsp_val = 1
         for elem in self.yaml['operations']['list']:
-            if 'notify' in elem:
+            if 'notify' in elem or 'event' in elem:
                 if 'value' in elem:
                     rsp_val = elem['value']
                 req_val_next = req_val
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index a230598d216f..ccd73f10384c 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -828,7 +828,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                 }
 
     def _load_root_sets(self):
-        for op_name, op in self.ops.items():
+        for op_name, op in self.msgs.items():
             if 'attribute-set' not in op:
                 continue
 
@@ -839,6 +839,8 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                     req_attrs.update(set(op[op_mode]['request']['attributes']))
                 if op_mode in op and 'reply' in op[op_mode]:
                     rsp_attrs.update(set(op[op_mode]['reply']['attributes']))
+            if 'event' in op:
+                rsp_attrs.update(set(op['event']['attributes']))
 
             if op['attribute-set'] not in self.root_sets:
                 self.root_sets[op['attribute-set']] = {'request': req_attrs, 'reply': rsp_attrs}
@@ -2193,10 +2195,13 @@ _C_KW = {
     if family.ntfs:
         cw.block_start(line=f"static const struct ynl_ntf_info {family['name']}_ntf_info[] = ")
         for ntf_op_name, ntf_op in family.ntfs.items():
-            if 'notify' not in ntf_op:
-                continue
-            op = family.ops[ntf_op['notify']]
-            ri = RenderInfo(cw, family, "user", op, op.name, "notify")
+            if 'notify' in ntf_op:
+                op = family.ops[ntf_op['notify']]
+                ri = RenderInfo(cw, family, "user", op, op.name, "notify")
+            elif 'event' in ntf_op:
+                ri = RenderInfo(cw, family, "user", ntf_op, ntf_op_name, "event")
+            else:
+                raise Exception('Invalid notification ' + ntf_op_name)
             _render_user_ntf_entry(ri, ntf_op)
         for op_name, op in family.ops.items():
             if 'event' not in op:
@@ -2424,6 +2429,7 @@ _C_KW = {
                         raise Exception(f'Only notifications with consistent types supported ({op.name})')
                     print_wrapped_type(ri)
 
+            for op_name, op in parsed.ntfs.items():
                 if 'event' in op:
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'event')
                     cw.p(f"/* {op.enum_name} - event */")
@@ -2485,6 +2491,7 @@ _C_KW = {
                         raise Exception(f'Only notifications with consistent types supported ({op.name})')
                     print_ntf_type_free(ri)
 
+            for op_name, op in parsed.ntfs.items():
                 if 'event' in op:
                     cw.p(f"/* {op.enum_name} - event */")
 
-- 
2.40.1


