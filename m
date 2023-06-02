Return-Path: <netdev+bounces-7289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D2A71F87E
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAA4B1C210DF
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1B81FA0;
	Fri,  2 Jun 2023 02:35:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E6815BE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5151C433A8;
	Fri,  2 Jun 2023 02:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673356;
	bh=HPCXRAGS9IZW3z4JOSUpExlXZcf9x8rj1vrvHyxaGUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoNbuHZrI16MChJbZJHhixcVjSOtkacZQVjzjbEPNsDqCh3W4xHMw5r0qjrY9n6lF
	 h2Yrw8oLi/N1oGrnnsvx6K3eGXIKKgIQEGcpyMWziNGSvVdoDCLIM82Rhp4zTb3x0q
	 n23cqGrDztgwvhQjaCoI+CTdlg+He7kgGaAyV49jBxC7WHoNxzRruyppuFydppQJs5
	 lqiIdYI3GcY4xoNFFtLxEWBkkw07FAXXN1mEbJ9muSsJv8Sx1o7cNz1SITe+Mx0eDo
	 YcyUIPx0L9V7XLzxq+mJJUteJv4WHhGQGwEyqyz5zcwb+i/SelfGM6yZYsBG09yuE6
	 0ljELd3pTPP/A==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/10] tools: ynl-gen: generate enum-to-string helpers
Date: Thu,  1 Jun 2023 19:35:44 -0700
Message-Id: <20230602023548.463441-7-kuba@kernel.org>
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

It's sometimes useful to print the name of an enum value,
flag or name of the op. Python can do it, add C helper
code gen for getting names of things.

Example:

  static const char * const netdev_xdp_act_strmap[] = {
	[0] = "basic",
	[1] = "redirect",
	[2] = "ndo-xmit",
	[3] = "xsk-zerocopy",
	[4] = "hw-offload",
	[5] = "rx-sg",
	[6] = "ndo-xmit-sg",
  };

  const char *netdev_xdp_act_str(enum netdev_xdp_act value)
  {
	value = ffs(value) - 1;
	if (value < 0 || value >= (int)MNL_ARRAY_SIZE(netdev_xdp_act_strmap))
		return NULL;
	return netdev_xdp_act_strmap[value];
  }

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 66 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 8bf4b70216d7..5318edfdb874 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1168,6 +1168,56 @@ _C_KW = {
     cw.nl()
 
 
+def put_op_name_fwd(family, cw):
+    cw.write_func_prot('const char *', f'{family.name}_op_str', ['int op'], suffix=';')
+
+
+def put_op_name(family, cw):
+    map_name = f'{family.name}_op_strmap'
+    cw.block_start(line=f"static const char * const {map_name}[] =")
+    for op_name, op in family.msgs.items():
+        cw.p(f'[{op.enum_name}] = "{op_name}",')
+    cw.block_end(line=';')
+    cw.nl()
+
+    cw.write_func_prot('const char *', f'{family.name}_op_str', ['int op'])
+    cw.block_start()
+    cw.p(f'if (op < 0 || op >= (int)MNL_ARRAY_SIZE({map_name}))')
+    cw.p('return NULL;')
+    cw.p(f'return {map_name}[op];')
+    cw.block_end()
+    cw.nl()
+
+
+def put_enum_to_str_fwd(family, cw, enum):
+    args = [f'enum {enum.render_name} value']
+    if 'enum-name' in enum and not enum['enum-name']:
+        args = ['int value']
+    cw.write_func_prot('const char *', f'{enum.render_name}_str', args, suffix=';')
+
+
+def put_enum_to_str(family, cw, enum):
+    map_name = f'{enum.render_name}_strmap'
+    cw.block_start(line=f"static const char * const {map_name}[] =")
+    for entry in enum.entries.values():
+        cw.p(f'[{entry.value}] = "{entry.name}",')
+    cw.block_end(line=';')
+    cw.nl()
+
+    args = [f'enum {enum.render_name} value']
+    if 'enum-name' in enum and not enum['enum-name']:
+        args = ['int value']
+    cw.write_func_prot('const char *', f'{enum.render_name}_str', args)
+    cw.block_start()
+    if enum.type == 'flags':
+        cw.p('value = ffs(value) - 1;')
+    cw.p(f'if (value < 0 || value >= (int)MNL_ARRAY_SIZE({map_name}))')
+    cw.p('return NULL;')
+    cw.p(f'return {map_name}[value];')
+    cw.block_end()
+    cw.nl()
+
+
 def put_req_nested(ri, struct):
     func_args = ['struct nlmsghdr *nlh',
                  'unsigned int attr_type',
@@ -2210,6 +2260,14 @@ _C_KW = {
     if args.mode == "user":
         has_ntf = False
         if args.header:
+            cw.p('/* Enums */')
+            put_op_name_fwd(parsed, cw)
+
+            for name, const in parsed.consts.items():
+                if isinstance(const, EnumSet):
+                    put_enum_to_str_fwd(parsed, cw, const)
+            cw.nl()
+
             cw.p('/* Common nested types */')
             for attr_set, struct in sorted(parsed.pure_nested_structs.items()):
                 ri = RenderInfo(cw, parsed, args.mode, "", "", "", attr_set)
@@ -2262,6 +2320,14 @@ _C_KW = {
                 print_ntf_parse_prototype(parsed, cw)
             cw.nl()
         else:
+            cw.p('/* Enums */')
+            put_op_name(parsed, cw)
+
+            for name, const in parsed.consts.items():
+                if isinstance(const, EnumSet):
+                    put_enum_to_str(parsed, cw, const)
+            cw.nl()
+
             cw.p('/* Policies */')
             for name, _ in parsed.attr_sets.items():
                 struct = Struct(parsed, name)
-- 
2.40.1


