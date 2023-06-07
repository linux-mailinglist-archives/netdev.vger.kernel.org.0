Return-Path: <netdev+bounces-9044-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BEB5726B5F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C19CD1C20F13
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF823AE79;
	Wed,  7 Jun 2023 20:24:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0AF3AE55
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1420C433D2;
	Wed,  7 Jun 2023 20:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169449;
	bh=4C/R78t7JqWHr2qZc7vSK6H/yKXF4JFilPgLSa3t4/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbSfP5C2qPEIfTltj6Tp984RwS0rUi3P9TJRF90DIw3B81ze/JhW8PVy9KerzDFjG
	 hubClVgxsSpfIU5flx78bBpkb57PZuJ66W1DqNcqR3erPlsZ+7IKxinXnEYulBryDS
	 /krGOISZZm6SaDYIih7w/f3gg6HverNIAKCCLUF0E6STcfcbGvQUqRG7+oYFIipGB8
	 oq4NowlM/acXKR9QOYxkpJ7vBhzoEtM4ipuTdVTdzBIob6R3mKwFDbzvkxRID3/9wh
	 ZJtihir9U7KVr/gxMlk5N3zZ1vIiWnBZC6T/QadEHglWFMG6lF0WgyxBsG/mAE75Zr
	 0Xd+3TRCEBJow==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/11] tools: ynl-gen: enable code gen for directional specs
Date: Wed,  7 Jun 2023 13:23:56 -0700
Message-Id: <20230607202403.1089925-5-kuba@kernel.org>
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

I think that user space code gen for directional specs
works after recent changes. Let them through.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py |  7 ++++---
 tools/net/ynl/ynl-gen-c.py  | 10 +++++++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index bd5da8aaeac7..9f7ad87d69af 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -324,6 +324,7 @@ jsonschema = None
 
     Attributes:
         proto     protocol type (e.g. genetlink)
+        msg_id_model   enum-model for operations (unified, directional etc.)
         license   spec license (loaded from an SPDX tag on the spec)
 
         attr_sets  dict of attribute sets
@@ -349,6 +350,7 @@ jsonschema = None
         super().__init__(self, spec)
 
         self.proto = self.yaml.get('protocol', 'genetlink')
+        self.msg_id_model = self.yaml['operations'].get('enum-model', 'unified')
 
         if schema_path is None:
             schema_path = os.path.dirname(os.path.dirname(spec_path)) + f'/{self.proto}.yaml'
@@ -477,10 +479,9 @@ jsonschema = None
             attr_set = self.new_attr_set(elem)
             self.attr_sets[elem['name']] = attr_set
 
-        msg_id_model = self.yaml['operations'].get('enum-model', 'unified')
-        if msg_id_model == 'unified':
+        if self.msg_id_model == 'unified':
             self._dictify_ops_unified()
-        elif msg_id_model == 'directional':
+        elif self.msg_id_model == 'directional':
             self._dictify_ops_directional()
 
         for op in self.msgs.values():
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index efcf91675dfa..7b3e79e17c01 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -709,9 +709,6 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def __init__(self, family, yaml, req_value, rsp_value):
         super().__init__(family, yaml, req_value, rsp_value)
 
-        if req_value != rsp_value:
-            raise Exception("Directional messages not supported by codegen")
-
         self.render_name = family.name + '_' + c_lower(self.name)
 
         self.dual_policy = ('do' in yaml and 'request' in yaml['do']) and \
@@ -2243,6 +2240,13 @@ _C_KW = {
         os.sys.exit(1)
         return
 
+    supported_models = ['unified']
+    if args.mode == 'user':
+        supported_models += ['directional']
+    if parsed.msg_id_model not in supported_models:
+        print(f'Message enum-model {parsed.msg_id_model} not supported for {args.mode} generation')
+        os.sys.exit(1)
+
     cw = CodeWriter(BaseNlLib(), out_file)
 
     _, spec_kernel = find_kernel_root(args.spec)
-- 
2.40.1


