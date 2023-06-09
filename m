Return-Path: <netdev+bounces-9726-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F19F972A57B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A978B281AC9
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D108723C71;
	Fri,  9 Jun 2023 21:43:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E5921069
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFCBC4339B;
	Fri,  9 Jun 2023 21:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347034;
	bh=C0G13RZVWdd5UCdwNT85o53KG3h/qLVm26UvUMB39ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aznwYq8yfxW6Y5rnOUyvGGD3fkDb9k9xbfOcMiaVePzuWPlOEI/yyvECzPPvzdEwf
	 MzQkV1MHD9LHyvLrLt2kgt0W5oP5Gg5JWZ6BsXs8C373juIzgzYnhh8M4vbZFr/NuH
	 EWiHBcsb8TFzqiEwlOMHNwyYwTOVRBQYvy8T0SQc2rJ4M5Fox0uyNo7ebIxugzhaCR
	 sAj0Hhc+Rbv6bqljLxd0ouqTZMVizITL9Cf5Vno/Rx8oUp3Fph6ivlUZeC0OijpbP9
	 9zlNkxs5JPobejTy0192DwlVFlgNuAjQTl9vRDCiJQXaqCo///R5U9eeanIG9Nr5Rg
	 cOVpxXvAiLTRw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/12] tools: ynl-gen: support excluding tricky ops
Date: Fri,  9 Jun 2023 14:43:35 -0700
Message-Id: <20230609214346.1605106-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
References: <20230609214346.1605106-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ethtool family has a small handful of quite tricky ops
and a lot of simple very useful ops. Teach ynl-gen to skip
ops so that we can bypass the tricky ones.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py | 12 ++++++++++--
 tools/net/ynl/ynl-gen-c.py  | 10 +++++++---
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index c5d4a6d476a0..1ba572cae27b 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -334,7 +334,7 @@ jsonschema = None
         consts     dict of all constants/enums
         fixed_header  string, optional name of family default fixed header struct
     """
-    def __init__(self, spec_path, schema_path=None):
+    def __init__(self, spec_path, schema_path=None, exclude_ops=None):
         with open(spec_path, "r") as stream:
             prefix = '# SPDX-License-Identifier: '
             first = stream.readline().strip()
@@ -349,6 +349,8 @@ jsonschema = None
 
         super().__init__(self, spec)
 
+        self._exclude_ops = exclude_ops if exclude_ops else []
+
         self.proto = self.yaml.get('protocol', 'genetlink')
         self.msg_id_model = self.yaml['operations'].get('enum-model', 'unified')
 
@@ -449,7 +451,13 @@ jsonschema = None
                 req_val = None
             if rsp_val == rsp_val_next:
                 rsp_val = None
-            op = self.new_operation(elem, req_val, rsp_val)
+
+            skip = False
+            for exclude in self._exclude_ops:
+                skip |= bool(exclude.match(elem['name']))
+            if not skip:
+                op = self.new_operation(elem, req_val, rsp_val)
+
             req_val = req_val_next
             rsp_val = rsp_val_next
 
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 7b051c00cfc3..a55c4cec2529 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -4,6 +4,7 @@
 import argparse
 import collections
 import os
+import re
 import yaml
 
 from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, SpecEnumEntry
@@ -739,7 +740,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
 
 
 class Family(SpecFamily):
-    def __init__(self, file_name):
+    def __init__(self, file_name, exclude_ops):
         # Added by resolve:
         self.c_name = None
         delattr(self, "c_name")
@@ -754,7 +755,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         self.hooks = None
         delattr(self, "hooks")
 
-        super().__init__(file_name)
+        super().__init__(file_name, exclude_ops=exclude_ops)
 
         self.fam_key = c_upper(self.yaml.get('c-family-name', self.yaml["name"] + '_FAMILY_NAME'))
         self.ver_key = c_upper(self.yaml.get('c-version-name', self.yaml["name"] + '_FAMILY_VERSION'))
@@ -2241,6 +2242,7 @@ _C_KW = {
     parser.add_argument('--header', dest='header', action='store_true', default=None)
     parser.add_argument('--source', dest='header', action='store_false')
     parser.add_argument('--user-header', nargs='+', default=[])
+    parser.add_argument('--exclude-op', action='append', default=[])
     parser.add_argument('-o', dest='out_file', type=str)
     args = parser.parse_args()
 
@@ -2249,8 +2251,10 @@ _C_KW = {
     if args.header is None:
         parser.error("--header or --source is required")
 
+    exclude_ops = [re.compile(expr) for expr in args.exclude_op]
+
     try:
-        parsed = Family(args.spec)
+        parsed = Family(args.spec, exclude_ops)
         if parsed.license != '((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)':
             print('Spec license:', parsed.license)
             print('License must be: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)')
-- 
2.40.1


