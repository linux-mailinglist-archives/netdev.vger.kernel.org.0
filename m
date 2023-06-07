Return-Path: <netdev+bounces-9047-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CA9726B88
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:26:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF418280996
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90EB53AE68;
	Wed,  7 Jun 2023 20:24:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCA03B8AB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1B5C433AE;
	Wed,  7 Jun 2023 20:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686169450;
	bh=FkeQv3+SU4nmO1sHafuVOhvHZOP/OGGgoeBZWKjTi5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNEwlL7lu9zD+sz4VDQeE3g7ZAUbl1gLBw22FT9O0vHAA09Ok6Q3RSME/4s0AfBDr
	 IRhJVdaJ+G1o4hysozpQUACjci/qpuCJRJI+icKMBhcB5clqlpn/1COjZAHOp+vxOy
	 Hd+Kb2dtWkWBpYPOA5cJpqkML9TGi3d7H6VoHVgMHnhrgMfKFJscLSKKTRTDE8R2zD
	 j88G4goQJzMhcvkp2RZeFxY8v1W3SwZNCgQIK1xec6iEv0sIOv/qfpuUkGk1Ru5XO0
	 EJ7jg37Pg+fkVij8ZHbzN+5csZSxVEMMHjt6Qd83aO8rYPjuCXDprvYQNSYZnIzQXL
	 cUICBYEbspzJw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	jiri@resnulli.us,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/11] tools: ynl-gen: don't generate forward declarations for policies
Date: Wed,  7 Jun 2023 13:24:00 -0700
Message-Id: <20230607202403.1089925-9-kuba@kernel.org>
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

Now that all nested types have structs and are sorted topologically
there should be no need to generate forward declarations for policies.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 0cb0f74e714b..251c5bfffd8d 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1235,10 +1235,6 @@ _C_KW = {
     print_prototype(ri, "request")
 
 
-def put_typol_fwd(cw, struct):
-    cw.p(f'extern struct ynl_policy_nest {struct.render_name}_nest;')
-
-
 def put_typol(cw, struct):
     type_max = struct.attr_set.max_name
     cw.block_start(line=f'struct ynl_policy_attr {struct.render_name}_policy[{type_max} + 1] =')
@@ -2485,12 +2481,10 @@ _C_KW = {
             cw.nl()
 
             cw.p('/* Policies */')
-            for name, _ in parsed.attr_sets.items():
+            for name in parsed.pure_nested_structs:
                 struct = Struct(parsed, name)
-                put_typol_fwd(cw, struct)
-            cw.nl()
-
-            for name, _ in parsed.attr_sets.items():
+                put_typol(cw, struct)
+            for name in parsed.root_sets:
                 struct = Struct(parsed, name)
                 put_typol(cw, struct)
 
-- 
2.40.1


