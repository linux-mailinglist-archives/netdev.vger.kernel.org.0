Return-Path: <netdev+bounces-9043-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23E11726B5D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C332028152A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD523AE76;
	Wed,  7 Jun 2023 20:24:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CA43AE4E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE51C433A0;
	Wed,  7 Jun 2023 20:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169448;
	bh=cCUfqfqRa+lFkQKt6ABem3xPqPyMsy6OoWwn2mduaxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JY3wTUlz7Fiuc/oC6Rqg4E5IALxT/fcs2xEdKPjyTF+1l2djXwV94+vO4tx6iCQSQ
	 l9aCBjvf/jeONdPLZI9EVy2bvwoGIv5LWCwQI/T6jw+usISY0L/KYrZwkUuijPJ5Eg
	 RsCST2rYKj+Sp5chBKs3LrpSdpEIAMpZvPjcXI4KLmX2qTwz9bkN79cV3LG6nOBEWD
	 k38MzFbsDVzG1Zkc3XDlWUPj/Z1pT985ULUmYavkNhnj3ANd682315Nt3RvdJnJ2JS
	 Pj+UTefMbIzLOQ5l8jGEZTgcctkeE08FZU+cTQN88k0C2aNt7qpi9wFdMWMey5Lnuc
	 KwFyKxsl1dQkA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/11] tools: ynl-gen: refactor strmap helper generation
Date: Wed,  7 Jun 2023 13:23:55 -0700
Message-Id: <20230607202403.1089925-4-kuba@kernel.org>
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

Move generating strmap lookup function to a helper.
No functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 8a0abf9048db..efcf91675dfa 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1212,6 +1212,21 @@ _C_KW = {
     cw.nl()
 
 
+def _put_enum_to_str_helper(cw, render_name, map_name, arg_name, enum=None):
+    args = [f'int {arg_name}']
+    if enum and not ('enum-name' in enum and not enum['enum-name']):
+        args = [f'enum {render_name} {arg_name}']
+    cw.write_func_prot('const char *', f'{render_name}_str', args)
+    cw.block_start()
+    if enum and enum.type == 'flags':
+        cw.p(f'{arg_name} = ffs({arg_name}) - 1;')
+    cw.p(f'if ({arg_name} < 0 || {arg_name} >= (int)MNL_ARRAY_SIZE({map_name}))')
+    cw.p('return NULL;')
+    cw.p(f'return {map_name}[{arg_name}];')
+    cw.block_end()
+    cw.nl()
+
+
 def put_op_name_fwd(family, cw):
     cw.write_func_prot('const char *', f'{family.name}_op_str', ['int op'], suffix=';')
 
@@ -1228,13 +1243,7 @@ _C_KW = {
     cw.block_end(line=';')
     cw.nl()
 
-    cw.write_func_prot('const char *', f'{family.name}_op_str', ['int op'])
-    cw.block_start()
-    cw.p(f'if (op < 0 || op >= (int)MNL_ARRAY_SIZE({map_name}))')
-    cw.p('return NULL;')
-    cw.p(f'return {map_name}[op];')
-    cw.block_end()
-    cw.nl()
+    _put_enum_to_str_helper(cw, family.name + '_op', map_name, 'op')
 
 
 def put_enum_to_str_fwd(family, cw, enum):
@@ -1252,18 +1261,7 @@ _C_KW = {
     cw.block_end(line=';')
     cw.nl()
 
-    args = [f'enum {enum.render_name} value']
-    if 'enum-name' in enum and not enum['enum-name']:
-        args = ['int value']
-    cw.write_func_prot('const char *', f'{enum.render_name}_str', args)
-    cw.block_start()
-    if enum.type == 'flags':
-        cw.p('value = ffs(value) - 1;')
-    cw.p(f'if (value < 0 || value >= (int)MNL_ARRAY_SIZE({map_name}))')
-    cw.p('return NULL;')
-    cw.p(f'return {map_name}[value];')
-    cw.block_end()
-    cw.nl()
+    _put_enum_to_str_helper(cw, enum.render_name, map_name, 'value', enum=enum)
 
 
 def put_req_nested(ri, struct):
-- 
2.40.1


