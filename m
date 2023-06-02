Return-Path: <netdev+bounces-7290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D1971F87F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:37:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6C532819B8
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6F315BA;
	Fri,  2 Jun 2023 02:35:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B874D1389
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA11C433A1;
	Fri,  2 Jun 2023 02:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673355;
	bh=/t12A1N+8xmaU3DVwf0Ye9PNogrQ70n9YjMWrvH8t9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjIjQcMpd6s1gpJdYzMDpueLNNdAU8eclntz7tqoqVU0/fa0HQLTcuBJyAsxtFRsm
	 OdCK5luW4C03LiCZmCRXWUrCWe19ymle8KBbD/Bl8ToRLcSwaWWbMXylKK4Z4DfowL
	 P2hF8jYiy2aQZ6iOT1IGed0AA3jegfzeCYNLvSyg9HvRUqa5/Ms0CToG3lFlVGsRQl
	 jeOqnWjSdthWUyxU0ONZcnB6Nxdi1ZBe7HC11qk35JgFVtVaOIw9DyYWIf4Wz93nKx
	 xkemRvGfFg937REpLfG56ZLqWQsvT/LqZjK5/6HyG5ifCkYKhK+LA0G1T1+5K95kNG
	 NDN/xcOti0rNg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/10] tools: ynl-gen: loosen type consistency check for events
Date: Thu,  1 Jun 2023 19:35:42 -0700
Message-Id: <20230602023548.463441-5-kuba@kernel.org>
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

Both event and notify types are always consistent. Rewrite
the condition checking if we can reuse reply types to be
less picky and let notify thru.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 40f7c47407c8..2ceb4ce1423f 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -897,11 +897,12 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         self.op_mode = op_mode
 
         # 'do' and 'dump' response parsing is identical
-        if op_mode != 'do' and 'dump' in op and 'do' in op and 'reply' in op['do'] and \
-           op["do"]["reply"] == op["dump"]["reply"]:
-            self.type_consistent = True
-        else:
-            self.type_consistent = op_mode == 'event'
+        self.type_consistent = True
+        if op_mode != 'do' and 'dump' in op and 'do' in op:
+            if ('reply' in op['do']) != ('reply' in op["dump"]):
+                self.type_consistent = False
+            elif 'reply' in op['do'] and op["do"]["reply"] != op["dump"]["reply"]:
+                self.type_consistent = False
 
         self.attr_set = attr_set
         if not self.attr_set:
@@ -2245,7 +2246,7 @@ _C_KW = {
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
                     has_ntf = True
                     if not ri.type_consistent:
-                        raise Exception('Only notifications with consistent types supported')
+                        raise Exception(f'Only notifications with consistent types supported ({op.name})')
                     print_wrapped_type(ri)
 
                 if 'event' in op:
@@ -2304,7 +2305,7 @@ _C_KW = {
                     ri = RenderInfo(cw, parsed, args.mode, op, op_name, 'notify')
                     has_ntf = True
                     if not ri.type_consistent:
-                        raise Exception('Only notifications with consistent types supported')
+                        raise Exception(f'Only notifications with consistent types supported ({op.name})')
                     print_ntf_type_free(ri)
 
                 if 'event' in op:
-- 
2.40.1


