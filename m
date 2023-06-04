Return-Path: <netdev+bounces-7803-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 065E27218F7
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 19:59:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EF241C20AA3
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 17:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B06810947;
	Sun,  4 Jun 2023 17:58:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C4C1079C
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 17:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8FAC433EF;
	Sun,  4 Jun 2023 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685901526;
	bh=YWVobWnX75GGwzA0NQyCxihXlmv1ljj8G3Fl1Un4xw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mb7kJImQMIzPlbIPs4Hd3H6dujVYVaX1nIWLi+C1QLU1I/pA/nmnx22UXAgSBuxWL
	 tNF3yzCzhxHjaIS2cEM4dpRZpABk2bCqPfMkxhbedT0hIoMIPR9zytPlNTb/M7RCVk
	 +6sH15xtRpa2eR57qSguszCgFuAt63uRi20X6YPOwa/5JlC3ZQIqw0pbxN1TvbA2YN
	 hOeTouyDLOah2bFH+D2JoFZtgCMeT5dxXZAT4yWHOnlzjEUooF1PrzXtIC3hXCC4WQ
	 85G+n8j+U8g9LsofErdoGrJZJHJxFi8Pjpu2M0EEj75qz6XXaV0P6/9HZ0Laj6iI0g
	 KM+MsAEhtPoJQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	simon.horman@corigine.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/4] tools: ynl-gen: clean up stray new lines at the end of reply-less requests
Date: Sun,  4 Jun 2023 10:58:40 -0700
Message-Id: <20230604175843.662084-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230604175843.662084-1-kuba@kernel.org>
References: <20230604175843.662084-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not print empty lines before closing brackets.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 4c12c6f8968e..1e64c5c2a087 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -944,9 +944,10 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def _is_cond(cls, line):
         return line.startswith('if') or line.startswith('while') or line.startswith('for')
 
-    def p(self, line, add_ind=0):
+    def p(self, line, add_ind=0, eat_nl=False):
         if self._nl:
-            self._out.write('\n')
+            if not eat_nl:
+                self._out.write('\n')
             self._nl = False
         ind = self._ind
         if line[-1] == ':':
@@ -971,7 +972,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
         if line and line[0] not in {';', ','}:
             line = ' ' + line
         self._ind -= 1
-        self.p('}' + line)
+        self.p('}' + line, eat_nl=True)
 
     def write_doc_line(self, doc, indent=True):
         words = doc.split()
-- 
2.40.1


