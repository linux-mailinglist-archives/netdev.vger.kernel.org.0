Return-Path: <netdev+bounces-7292-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E6C971F883
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F050A2819BA
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02D94406;
	Fri,  2 Jun 2023 02:36:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE4615CF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A3AC433B3;
	Fri,  2 Jun 2023 02:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673357;
	bh=4JeCpRZLs/uR+QiSe1U9JHaYJzUKduNF5DIhxE3hr+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=joVbpUTl86BugQXjOJSRBpucA/xaHPgmnKXln7uuUekibP0thr5ih33TSv5iDbP8b
	 cXika5sRz1VTRCaWE873xpvMsRsXeFEGAezR3D9lzct7bkCtzlfwQxVFpa0Xwsr+6V
	 eFTBZ4R/0LoOiQGeSxHvc914/ePRwy1uVU8N3Hlh8l6n779xbt0vcCmaIB/K2LeAus
	 k8N/jO937cU24BFSqCJUt0u1/Xy4H9GCkodxZrwH+vB5yjbAONeT9Mf7YuLqPeywU+
	 pnwgp37GS0XvD1e9LDZCsnFGlX/8yNl14JMKjdRjb5nmiwneeWI5EoQWpJB7sAUMPq
	 aNKs2G61ARHwA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/10] tools: ynl-gen: switch to family struct
Date: Thu,  1 Jun 2023 19:35:47 -0700
Message-Id: <20230602023548.463441-10-kuba@kernel.org>
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

We'll want to store static info about the family soon.
Generate a struct. This changes creation from, e.g.:

	 ys = ynl_sock_create("netdev", &yerr);
to:
	 ys = ynl_sock_create(&ynl_netdev_family, &yerr);

on user's side.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 4a7ca2823270..320e5e90920a 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2109,6 +2109,16 @@ _C_KW = {
     cw.p(f'#endif /* {hdr_prot} */')
 
 
+def render_user_family(family, cw, prototype):
+    symbol = f'const struct ynl_family ynl_{family.c_name}_family'
+    if prototype:
+        cw.p(f'extern {symbol};')
+    else:
+        cw.block_start(f'{symbol} = ')
+        cw.p(f'.name = "{family.name}",')
+        cw.block_end(line=';')
+
+
 def find_kernel_root(full_path):
     sub_path = ''
     while True:
@@ -2204,6 +2214,8 @@ _C_KW = {
                 cw.p(f'#include "{one}"')
         else:
             cw.p('struct ynl_sock;')
+            cw.nl()
+            render_user_family(parsed, cw, True)
         cw.nl()
 
     if args.mode == "kernel":
@@ -2397,6 +2409,9 @@ _C_KW = {
                 cw.p('/* --------------- Common notification parsing --------------- */')
                 print_ntf_type_parse(parsed, cw, args.mode)
 
+            cw.nl()
+            render_user_family(parsed, cw, False)
+
     if args.header:
         cw.p(f'#endif /* {hdr_prot} */')
 
-- 
2.40.1


