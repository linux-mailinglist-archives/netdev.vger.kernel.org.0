Return-Path: <netdev+bounces-9048-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 828C7726B91
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF06E1C20B0E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A963B8C9;
	Wed,  7 Jun 2023 20:24:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D47A3B8A6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A973C43443;
	Wed,  7 Jun 2023 20:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169450;
	bh=i65U5EklXVmBKzVgDXQiVCVTHcRA82OjjacFr0Snhow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkYUlJ0Ew6gvwS3f9T88HKXSFqMPoKODecqwnvaNylEBVbe7O95ZrsAxv7urcGi5m
	 GLbtoC08JLOLlr6raDzRDvBCYMi+7KacdodQI22DW+AzQ3ceZOvdQRvWB2xBeCCIvD
	 YY4VRPWpzSgzQQeOmbKuiA4hbblD+ekO3nf51VsLC2o16ACp0UcihKey48ihf1Vpnk
	 JkCHQKFSvpxKY1qhjlDCmU5Zdj3qcYLc1WbTz8FKEIRgP+xiqB6hZ2jpPB1g7CrOU7
	 htFmv7yTyDtS8Xc74e/X4CCXoLoQfjbmMbgQSDVVW4kq6g6gkW1Rm/4S27uGg4ZFo9
	 qZiRvbaLfh4fQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/11] tools: ynl-gen: walk nested types in depth
Date: Wed,  7 Jun 2023 13:23:59 -0700
Message-Id: <20230607202403.1089925-8-kuba@kernel.org>
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

So far we had only created structures for nested types nested
directly in messages (second level of attrs so to speak).
Walk types in depth to support deeper nesting.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 41 +++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 1a97cd517116..0cb0f74e714b 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -854,27 +854,44 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
                 self.root_sets[op['attribute-set']]['reply'].update(rsp_attrs)
 
     def _load_nested_sets(self):
+        attr_set_queue = list(self.root_sets.keys())
+        attr_set_seen = set(self.root_sets.keys())
+
+        while len(attr_set_queue):
+            a_set = attr_set_queue.pop(0)
+            for attr, spec in self.attr_sets[a_set].items():
+                if 'nested-attributes' not in spec:
+                    continue
+
+                nested = spec['nested-attributes']
+                if nested not in attr_set_seen:
+                    attr_set_queue.append(nested)
+                    attr_set_seen.add(nested)
+
+                inherit = set()
+                if nested not in self.root_sets:
+                    if nested not in self.pure_nested_structs:
+                        self.pure_nested_structs[nested] = Struct(self, nested, inherited=inherit)
+                else:
+                    raise Exception(f'Using attr set as root and nested not supported - {nested}')
+
+                if 'type-value' in spec:
+                    if nested in self.root_sets:
+                        raise Exception("Inheriting members to a space used as root not supported")
+                    inherit.update(set(spec['type-value']))
+                elif spec['type'] == 'array-nest':
+                    inherit.add('idx')
+                self.pure_nested_structs[nested].set_inherited(inherit)
+
         for root_set, rs_members in self.root_sets.items():
             for attr, spec in self.attr_sets[root_set].items():
                 if 'nested-attributes' in spec:
-                    inherit = set()
                     nested = spec['nested-attributes']
-                    if nested not in self.root_sets:
-                        if nested not in self.pure_nested_structs:
-                            self.pure_nested_structs[nested] = Struct(self, nested, inherited=inherit)
                     if attr in rs_members['request']:
                         self.pure_nested_structs[nested].request = True
                     if attr in rs_members['reply']:
                         self.pure_nested_structs[nested].reply = True
 
-                    if 'type-value' in spec:
-                        if nested in self.root_sets:
-                            raise Exception("Inheriting members to a space used as root not supported")
-                        inherit.update(set(spec['type-value']))
-                    elif spec['type'] == 'array-nest':
-                        inherit.add('idx')
-                    self.pure_nested_structs[nested].set_inherited(inherit)
-
         # Try to reorder according to dependencies
         pns_key_list = list(self.pure_nested_structs.keys())
         pns_key_seen = set()
-- 
2.40.1


