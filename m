Return-Path: <netdev+bounces-10180-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E2372CAD7
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E93FF2810FE
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA793200D0;
	Mon, 12 Jun 2023 15:59:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432E91C763
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7399DC4339B;
	Mon, 12 Jun 2023 15:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686585572;
	bh=D+D3Ulv7u8NL+p+VSrD/UZl9gZ9yBnpyIKSxLyP0Kxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4l8ejF9BiD5JFCAFmTna0oUBwjjKMMqgKGGKQgqRiBRC067Yg0aKTBam7FECJl08
	 mALHl+m/tWuyIhH9EvVg+hZVKDZItT/0/mQqWN0pZNJIDdTyjuy1NyLTDr7yietsoL
	 afm9biqmF26Kp9fS5UlZ9vggQd0Xzjo/YwO74Oxjr48Hl4DyFid/tbswIOcD5UZxmE
	 Zllw2PDannGx23Is3Wo2er2XaZsJ+wHl7vyuG7T63C0dfR9BDrOChVmUluVlomEq4H
	 VpqJd0AcAZTpVR1MD9Kl6eFjKJqygKd0zkGdBBJD/0Z/cE6KFEKXZNSOUOht8m6Q5d
	 pkVCmFIYOf3Fw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	arkadiusz.kubalewski@intel.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] tools: ynl-gen: correct enum policies
Date: Mon, 12 Jun 2023 08:59:19 -0700
Message-Id: <20230612155920.1787579-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612155920.1787579-1-kuba@kernel.org>
References: <20230612155920.1787579-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Scalar range validation assumes enums start at 0.
Teach it to properly calculate the value range.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 870f98d0e12c..54777d529f5e 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -300,8 +300,10 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
             return f"NLA_POLICY_MIN({policy}, {self.checks['min']})"
         elif 'enum' in self.attr:
             enum = self.family.consts[self.attr['enum']]
-            cnt = len(enum['entries'])
-            return f"NLA_POLICY_MAX({policy}, {cnt - 1})"
+            low, high = enum.value_range()
+            if low == 0:
+                return f"NLA_POLICY_MAX({policy}, {high})"
+            return f"NLA_POLICY_RANGE({policy}, {low}, {high})"
         return super()._attr_policy(policy)
 
     def _attr_typol(self):
@@ -676,6 +678,15 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def new_entry(self, entry, prev_entry, value_start):
         return EnumEntry(self, entry, prev_entry, value_start)
 
+    def value_range(self):
+        low = min([x.value for x in self.entries.values()])
+        high = max([x.value for x in self.entries.values()])
+
+        if high - low + 1 != len(self.entries):
+            raise Exception("Can't get value range for a noncontiguous enum")
+
+        return low, high
+
 
 class AttrSet(SpecAttrSet):
     def __init__(self, family, yaml):
-- 
2.40.1


