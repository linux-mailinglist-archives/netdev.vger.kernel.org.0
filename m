Return-Path: <netdev+bounces-7614-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32D98720DEC
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:26:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9280F281AC6
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 05:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3A05245;
	Sat,  3 Jun 2023 05:25:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9236F1FD5
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 05:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17CFC433EF;
	Sat,  3 Jun 2023 05:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685769951;
	bh=YWVobWnX75GGwzA0NQyCxihXlmv1ljj8G3Fl1Un4xw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLP6a40Ed63XYEiRGggv86JytWh/eWmWCqOUHX4m9myKHcHLqFS4+9r1oR22SV4x7
	 afacJIdMoLyRCMWw4KPlvEVfFkTUqklAljF7HvT9jweNFIEREUxSqaM+ckkqzt6k59
	 k6H5qM7lHqWQkNprZMxq8PSwbGq60pXoX7vcYIjeyy9dc7IL1YO6xA+ly+MIVJn8e/
	 LEB0pMRdhEh7co1J+N8qgOqWc6EI4YAIaJDu5/lkFa1jX/+CNWAAdoLMTcDwwGVRmf
	 8mDfLcltBpzpwZB8HZHbin1FOxlNHHQforh9siOMSkie7Z1IDf8kZPdKXP7YJqiUp1
	 TfX7dTlTg7hJA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/4] tools: ynl-gen: clean up stray new lines at the end of reply-less requests
Date: Fri,  2 Jun 2023 22:25:44 -0700
Message-Id: <20230603052547.631384-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230603052547.631384-1-kuba@kernel.org>
References: <20230603052547.631384-1-kuba@kernel.org>
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


