Return-Path: <netdev+bounces-9042-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E82F9726B56
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 367241C20F28
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A5C83AE5F;
	Wed,  7 Jun 2023 20:24:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D8D3AE43
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05952C433EF;
	Wed,  7 Jun 2023 20:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169448;
	bh=5HPDLYH28NhJgDQsArHYiJ/Uts+4Ek/06Q5BLzB1L70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a97ccEvbD4MvWuhJWhTfN4fgLLJp0NWqsz1sfGDLRuIwhZfqSIkpgLn6sMRBS3CRJ
	 bDHu6gkWLU00azD+97VNTzAZOS8TIchlVQLAqxYwVBDrek04NVXgMAfEcruE+A4DtU
	 oVwaLHQuQEPWPSVBOdeNdf2fU/j6XfCQ51wMWt6rZC3RlqPB4I4WLA00wUEgRqUMOA
	 4Trj9h4uSPmPW+f/BTI+KSZxjisJhyh3T++ObGuGR3Cqtvbzqaif9NNBQL/fZ33kqX
	 hHEXP7AJPZxz3B0N2WHeCsUWWYz36iZ74FqgFjUxasmxEYZ5U4Pa8UuKKLHEdbWd2L
	 zmrrqYXuwv0zg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/11] tools: ynl-gen: use enum names in op strmap more carefully
Date: Wed,  7 Jun 2023 13:23:54 -0700
Message-Id: <20230607202403.1089925-3-kuba@kernel.org>
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

In preparation for supporting families which use different msg
ids to and from the kernel - make sure the ids in op strmap
are correct. The map is expected to be used mostly for notifications,
don't generate a separate map for the "to kernel" direction.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/generated/fou-user.c | 1 -
 tools/net/ynl/lib/nlspec.py        | 4 ++++
 tools/net/ynl/ynl-gen-c.py         | 6 +++++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/generated/fou-user.c b/tools/net/ynl/generated/fou-user.c
index c99b5d438021..a0f33bb882e4 100644
--- a/tools/net/ynl/generated/fou-user.c
+++ b/tools/net/ynl/generated/fou-user.c
@@ -16,7 +16,6 @@
 
 /* Enums */
 static const char * const fou_op_strmap[] = {
-	[FOU_CMD_UNSPEC] = "unspec",
 	[FOU_CMD_ADD] = "add",
 	[FOU_CMD_DEL] = "del",
 	[FOU_CMD_GET] = "get",
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index ada22b073aa2..bd5da8aaeac7 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -442,6 +442,10 @@ jsonschema = None
             else:
                 raise Exception("Can't parse directional ops")
 
+            if req_val == req_val_next:
+                req_val = None
+            if rsp_val == rsp_val_next:
+                rsp_val = None
             op = self.new_operation(elem, req_val, rsp_val)
             req_val = req_val_next
             rsp_val = rsp_val_next
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index c07340715601..8a0abf9048db 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1220,7 +1220,11 @@ _C_KW = {
     map_name = f'{family.name}_op_strmap'
     cw.block_start(line=f"static const char * const {map_name}[] =")
     for op_name, op in family.msgs.items():
-        cw.p(f'[{op.enum_name}] = "{op_name}",')
+        if op.rsp_value:
+            if op.req_value == op.rsp_value:
+                cw.p(f'[{op.enum_name}] = "{op_name}",')
+            else:
+                cw.p(f'[{op.rsp_value}] = "{op_name}",')
     cw.block_end(line=';')
     cw.nl()
 
-- 
2.40.1


