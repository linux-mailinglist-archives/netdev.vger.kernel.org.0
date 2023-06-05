Return-Path: <netdev+bounces-8165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95BAD722F12
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1280C1C20D09
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49F7C23D68;
	Mon,  5 Jun 2023 19:01:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE4723D45
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5FFC4339B;
	Mon,  5 Jun 2023 19:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685991670;
	bh=YWVobWnX75GGwzA0NQyCxihXlmv1ljj8G3Fl1Un4xw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nczHBKdaeMB/iALJYHzY/TSFD9hKXXcGHMZD8IjVz4m3CCGiKPv/uqna4bxrVnlFl
	 Uh2I+sRNp22gktB5ythSauTKD2lwpsQobpHW0oFZVyBc5ruYilmwwM+fi735Ce1IBD
	 eBSaKeTL+u+/zmSX9AULYZCFCeVkfiffiG34yf1JglaIBkq5DcGNznDBG4YxJBRKyA
	 eL8l9l24HoDdV59ZsKHqvwR/0rybf/B6jbC7w61/7ifoPvNX5X4q3FfWO4gft0KdL7
	 fB+KhvcEJxKFdU0gbYs5dJgDlQg0uktn+/J7EdorttPi5iGva+rlCiPBWEYhkySgvF
	 WtXFhHPRXHM8g==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	simon.horman@corigine.com,
	sdf@google.com,
	willemdebruijn.kernel@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 1/4] tools: ynl-gen: clean up stray new lines at the end of reply-less requests
Date: Mon,  5 Jun 2023 12:01:05 -0700
Message-Id: <20230605190108.809439-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605190108.809439-1-kuba@kernel.org>
References: <20230605190108.809439-1-kuba@kernel.org>
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


