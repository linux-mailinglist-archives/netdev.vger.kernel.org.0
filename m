Return-Path: <netdev+bounces-9370-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7684728A01
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 832BC2817FC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F24834CE9;
	Thu,  8 Jun 2023 21:12:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429CC34CC6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC704C433A7;
	Thu,  8 Jun 2023 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258729;
	bh=S1fPLZA1Krg4ATGmPWSiv0K/bSJIx7dA5pthAGgsQGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiJSqbKj5b2M3PU1TI+ZfWi26ich8USzH8HoUNl6KmD9/A7+fXhh5gfHNJpEERIQb
	 jZS1lOvWUzQX8k9SrIlEfMPSS4f3cL9EeCdBLk5macqLuuOPSXL/RdrrMuw7iH2Xtg
	 E8U8Ogv9UWs+EU5RBIYYWqZwG/ZhIgzgJn2JKCxBWZwCB69YH2mlYJNqn3mvZmH2rK
	 cT4N1P6n048aJq3hgF9D2ihDt08a/rrH5wZDl2Ej/KS4GXKIa8Kn9I1riNk3Bp9R/N
	 qdBwfprGC3CtapG277FWL7PIN5z/zgqZnsI1KJPzZQNeqo3Qrpo2EDJKQ0FTB5BsFa
	 i9h6cqpXV/xCw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/12] tools: ynl-gen: get attr type outside of if()
Date: Thu,  8 Jun 2023 14:11:53 -0700
Message-Id: <20230608211200.1247213-6-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608211200.1247213-1-kuba@kernel.org>
References: <20230608211200.1247213-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reading attr type with mnl_attr_get_type() for each condition
leads to most conditions being longer than 80 chars.
Avoid this by reading the type to a variable on the stack.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index d2edded5f747..ecd8beba7e0d 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -153,7 +153,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
             init_lines = [init_lines]
 
         kw = 'if' if first else 'else if'
-        ri.cw.block_start(line=f"{kw} (mnl_attr_get_type(attr) == {self.enum_name})")
+        ri.cw.block_start(line=f"{kw} (type == {self.enum_name})")
         if local_vars:
             for local in local_vars:
                 ri.cw.p(local)
@@ -1418,6 +1418,8 @@ _C_KW = {
 
     ri.cw.nl()
     ri.cw.block_start(line=iter_line)
+    ri.cw.p('unsigned int type = mnl_attr_get_type(attr);')
+    ri.cw.nl()
 
     first = True
     for _, arg in struct.member_list():
-- 
2.40.1


