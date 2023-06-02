Return-Path: <netdev+bounces-7286-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB75171F878
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 977E0281994
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55EFEA1;
	Fri,  2 Jun 2023 02:35:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF5C10E7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F5DC4339B;
	Fri,  2 Jun 2023 02:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673354;
	bh=0osxhyToT0d9UO/HUmPSFy3LW3Qu88mpeMLBqhs9ymo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HO2iGiWSiwK422HA+dbkRqjcsgHlT/LwKyA8t7TpCChAWUGCe/oRFmqHX4+1AkQOT
	 /hMAm+NvnhDuW/NFYsJyqh+4q3l9Rd8zuDod16fXHY49C7MLXWf84jHtTH69AhCC0S
	 MYyc9qDucXzawNrwJRsSu5Tn8ywM0DlV+XZ7WiieEUgVmXRAx1cr5/MhgTGjriZ0+3
	 Iz7SgievHqP6kiDkfVM0zW8DTq9SO9Xtyp3kuecLfrSJG9iRu3ggHqb7DsDw/6mLwQ
	 kxACmlLCeoo5zwprdN+PR8nJnGAPBwSh58SvsY2TpcUC+73bsXjqVdRYZCktvkaaLS
	 mIt4n09e/H/cQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/10] tools: ynl-gen: fix unused / pad attribute handling
Date: Thu,  1 Jun 2023 19:35:40 -0700
Message-Id: <20230602023548.463441-3-kuba@kernel.org>
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

Unused and Pad attributes don't carry information.
Unused should never exist, and be rejected.
Pad should be silently skipped.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 5823ddf912f6..11dcbfc21ecc 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -170,6 +170,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         for line in lines:
             ri.cw.p(line)
         ri.cw.block_end()
+        return True
 
     def _setter_lines(self, ri, member, presence):
         raise Exception(f"Setter not implemented for class type {self.type}")
@@ -197,6 +198,12 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def presence_type(self):
         return ''
 
+    def arg_member(self, ri):
+        return []
+
+    def _attr_get(self, ri, var):
+        return ['return MNL_CB_ERROR;'], None, None
+
     def _attr_typol(self):
         return '.type = YNL_PT_REJECT, '
 
@@ -208,8 +215,14 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def presence_type(self):
         return ''
 
+    def arg_member(self, ri):
+        return []
+
     def _attr_typol(self):
-        return '.type = YNL_PT_REJECT, '
+        return '.type = YNL_PT_IGNORE, '
+
+    def attr_get(self, ri, var, first):
+        pass
 
     def attr_policy(self, cw):
         pass
@@ -1211,8 +1224,9 @@ _C_KW = {
 
     first = True
     for _, arg in struct.member_list():
-        arg.attr_get(ri, 'dst', first=first)
-        first = False
+        good = arg.attr_get(ri, 'dst', first=first)
+        # First may be 'unused' or 'pad', ignore those
+        first &= not good
 
     ri.cw.block_end()
     ri.cw.nl()
-- 
2.40.1


