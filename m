Return-Path: <netdev+bounces-7291-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B1471F882
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F11F1C211A8
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0BCF15AA;
	Fri,  2 Jun 2023 02:36:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2CE15C9
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9A3C433B0;
	Fri,  2 Jun 2023 02:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673357;
	bh=7X65X6kDwAxKipI84JCv8SDjLr1x1VCNXZZDURP4PR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIar4oOedrUDtVukL7/bEGUarFJoeQXcUGdyNWW9xDOkmkY95wiD+YCrlG8Eg2UwQ
	 BP/NLV3/uowghZeka+gnvii/vFj0cWTwII9yT+r4/ObI5CglyZc7DM9YETxev1m3Bm
	 vMHybJW/D8NGi9KEV0uaizA06uW3IOwqfcSjzdX+cRVjuENcsc/Bny3rPaEb8Xv8eg
	 +kiI16NRsqUk+gbdIDh3/n90iVBK4+OTYnPMW9JivMgen/vU5ylTmYT2nvNODREyg5
	 giZjzGORwww5oyeIZHGq4kNBeMDMkpML7sQSEVuJd7Wz9inxqrIMeOnpr5wcc3YBdM
	 IYEgOY+XOobbg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/10] tools: ynl-gen: generate alloc and free helpers for req
Date: Thu,  1 Jun 2023 19:35:46 -0700
Message-Id: <20230602023548.463441-9-kuba@kernel.org>
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

We expect user to allocate requests with calloc(),
make things a bit more consistent and provide helpers.
Generate free calls, too.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 7d833a42e060..4a7ca2823270 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1476,6 +1476,14 @@ _C_KW = {
     return 'obj'
 
 
+def print_alloc_wrapper(ri, direction):
+    name = op_prefix(ri, direction)
+    ri.cw.write_func_prot(f'static inline struct {name} *', f"{name}_alloc", [f"void"])
+    ri.cw.block_start()
+    ri.cw.p(f'return calloc(1, sizeof(struct {name}));')
+    ri.cw.block_end()
+
+
 def print_free_prototype(ri, direction, suffix=';'):
     name = op_prefix(ri, direction)
     arg = free_arg_name(direction)
@@ -1523,6 +1531,7 @@ _C_KW = {
 
 def print_type_helpers(ri, direction, deref=False):
     print_free_prototype(ri, direction)
+    ri.cw.nl()
 
     if ri.ku_space == 'user' and direction == 'request':
         for _, attr in ri.struct[direction].member_list():
@@ -1531,6 +1540,7 @@ _C_KW = {
 
 
 def print_req_type_helpers(ri):
+    print_alloc_wrapper(ri, "request")
     print_type_helpers(ri, "request")
 
 
@@ -1554,6 +1564,12 @@ _C_KW = {
     print_type(ri, "request")
 
 
+def print_req_free(ri):
+    if 'request' not in ri.op[ri.op_mode]:
+        return
+    _free_type(ri, 'request', ri.struct['request'])
+
+
 def print_rsp_type(ri):
     if (ri.op_mode == 'do' or ri.op_mode == 'dump') and 'reply' in ri.op[ri.op_mode]:
         direction = 'reply'
@@ -2344,6 +2360,7 @@ _C_KW = {
                 if 'do' in op and 'event' not in op:
                     cw.p(f"/* {op.enum_name} - do */")
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, "do")
+                    print_req_free(ri)
                     print_rsp_free(ri)
                     parse_rsp_msg(ri)
                     print_req(ri)
-- 
2.40.1


