Return-Path: <netdev+bounces-9369-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B7D728A00
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B88301C21054
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E9634CE6;
	Thu,  8 Jun 2023 21:12:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E93447E
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEFFC433D2;
	Thu,  8 Jun 2023 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258728;
	bh=fS9wOUNqS0HPqIDFPaSCWLoeJVXn4rhA7pXpeCUR2L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ptn1IgHVGi+ahn/L+62sXHImi96Kn5bF7+s3txHs9rxS7lwK6bGoNLlnS5SVUf2B/
	 UHhxJwuYsckHthUMr6+MR5fc+T4/101z7Ka4Lsr6xaHJbDDHak3lVE0HeNiSrj4f49
	 2gRw2++R53q4WX3Q59tF5cqV/8FToIJ6mjm3n1+c7kkWrs62lAmOY9LM4Ly39H+UDY
	 Hr/qNhJqLHERln2CaQh3BRsXx45JMYBcpR2VItI+oABJlQIt634Dw9yugMpFEBVbnJ
	 hFBMwU5USTkd4qxH8iVEd57P1kEwENwrCuC11vbpNjoYYqV6IezPnAgQz7YNDzt+rq
	 ShSa9Bmmg1QAA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/12] tools: ynl-gen: combine else with closing bracket
Date: Thu,  8 Jun 2023 14:11:52 -0700
Message-Id: <20230608211200.1247213-5-kuba@kernel.org>
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

Code gen currently prints:

  }
  else if (...

This is really ugly. Fix it by delaying printing of closing
brackets in anticipation of else coming along.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 9b6ff256f80e..d2edded5f747 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1017,6 +1017,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         self.nlib = nlib
 
         self._nl = False
+        self._block_end = False
         self._silent_block = False
         self._ind = 0
         self._out = out_file
@@ -1025,11 +1026,18 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def _is_cond(cls, line):
         return line.startswith('if') or line.startswith('while') or line.startswith('for')
 
-    def p(self, line, add_ind=0, eat_nl=False):
+    def p(self, line, add_ind=0):
+        if self._block_end:
+            self._block_end = False
+            if line.startswith('else'):
+                line = '} ' + line
+            else:
+                self._out.write('\t' * self._ind + '}\n')
+
         if self._nl:
-            if not eat_nl:
-                self._out.write('\n')
+            self._out.write('\n')
             self._nl = False
+
         ind = self._ind
         if line[-1] == ':':
             ind -= 1
@@ -1053,7 +1061,14 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         if line and line[0] not in {';', ','}:
             line = ' ' + line
         self._ind -= 1
-        self.p('}' + line, eat_nl=True)
+        self._nl = False
+        if not line:
+            # Delay printing closing bracket in case "else" comes next
+            if self._block_end:
+                self._out.write('\t' * (self._ind + 1) + '}\n')
+            self._block_end = True
+        else:
+            self.p('}' + line)
 
     def write_doc_line(self, doc, indent=True):
         words = doc.split()
-- 
2.40.1


