Return-Path: <netdev+bounces-9368-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F61E7289FE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B49551C2100E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D4A34CD0;
	Thu,  8 Jun 2023 21:12:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA2B31F1A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB66C4339B;
	Thu,  8 Jun 2023 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258727;
	bh=fn6Dfk0OlmM4DZX4GNWDv3FvR6WuinJooOzvIKh1bGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoHY+LaTz7K+cOxnjL0dUXbO5hQdiFKJEbkW8C8AslaDBNT2Wkeyk7Uo57bA43FSt
	 3+awCxVBA/yygt5Q62JdxYpwVZuE4hSRaRC5mdg1wcE5u3gU1/PJUpCnHnJWPB9Zeg
	 DGCS6zWVyh2x/JK+ej91MPa4zpPBVPuRqs1KYSa/LwQ1kI/plY5/BdbigUHvjaP5IJ
	 nRk46DnQb9vm2paOFMU4g6/h5e0BaCRc2KaxtdbFLczFNRMY13pky5mckoENXYGJsv
	 e4udPleUimuX+xhriVgCwXqCsUA0HmVxEa3zeZUGZ6R5mcch2AxS5jy9oFljOBRiBn
	 RzgmeTXQEKAHQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next 01/12] tools: ynl-gen: cleanup user space header includes
Date: Thu,  8 Jun 2023 14:11:49 -0700
Message-Id: <20230608211200.1247213-2-kuba@kernel.org>
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

Bots started screaming that we're including stdlib.h twice.
While at it move string.h into a common spot and drop stdio.h
which we don't need.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5464
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5466
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5467
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 251c5bfffd8d..e1b86b1fba66 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2323,8 +2323,8 @@ _C_KW = {
         headers = ['uapi/' + parsed.uapi_header]
     else:
         cw.p('#include <stdlib.h>')
+        cw.p('#include <string.h>')
         if args.header:
-            cw.p('#include <string.h>')
             cw.p('#include <linux/types.h>')
         else:
             cw.p(f'#include "{parsed.name}-user.h"')
@@ -2339,9 +2339,6 @@ _C_KW = {
 
     if args.mode == "user":
         if not args.header:
-            cw.p("#include <stdlib.h>")
-            cw.p("#include <stdio.h>")
-            cw.p("#include <string.h>")
             cw.p("#include <libmnl/libmnl.h>")
             cw.p("#include <linux/genetlink.h>")
             cw.nl()
-- 
2.40.1


