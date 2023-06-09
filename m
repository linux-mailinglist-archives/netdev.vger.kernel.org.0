Return-Path: <netdev+bounces-9727-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D91672A57C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:44:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD3101C2118B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD84023C89;
	Fri,  9 Jun 2023 21:43:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55B72341D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124F6C4339C;
	Fri,  9 Jun 2023 21:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347035;
	bh=zfgJbHlrW2iaMsh37i/aoZ8YXjA5F4yYFmyJAaLeeAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nINohI0fYXFsY03pbUDY4UE6bfm4pxxXWsCZgDbQBgirkqgx9Gf26bjMUUDyx0TGs
	 qLGsSUgnYSMaSp5Bja0gxsBFdP6nI0pO0xNdmrHH8rpSTjHw1sNwmad/dk24ryLZQV
	 LpVKR6NGyMGUKkSb7m/kNxAEBFo7ymFo5Uolz6XrtWyiHDndLgCLkEGiZYKDRRzcZs
	 ANBv/BAwufaUjbXpzbbYjITDm/AOfotZoYprJN2J86l7yadEsoSlc10pCZns3eatug
	 mcbojf5ELoSmtNqcf8If3kIIGyRgIjDQb9wtfec3z40Wdke108/E6awTr6uINpGejt
	 qwQEMFy/EDnQQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/12] tools: ynl-gen: record extra args for regen
Date: Fri,  9 Jun 2023 14:43:36 -0700
Message-Id: <20230609214346.1605106-3-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609214346.1605106-1-kuba@kernel.org>
References: <20230609214346.1605106-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ynl-regen needs to know the arguments used to generate a file.
Record excluded ops and, while at it, user headers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 5 +++++
 tools/net/ynl/ynl-regen.sh | 4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index a55c4cec2529..89d9471e9c2b 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2281,6 +2281,11 @@ _C_KW = {
     cw.p("/* Do not edit directly, auto-generated from: */")
     cw.p(f"/*\t{spec_kernel} */")
     cw.p(f"/* YNL-GEN {args.mode} {'header' if args.header else 'source'} */")
+    if args.exclude_op or args.user_header:
+        line = ''
+        line += ' --user-header '.join([''] + args.user_header)
+        line += ' --exclude-op '.join([''] + args.exclude_op)
+        cw.p(f'/* YNL-ARG{line} */')
     cw.nl()
 
     if args.mode == 'uapi':
diff --git a/tools/net/ynl/ynl-regen.sh b/tools/net/ynl/ynl-regen.sh
index 2a4525e2aa17..8d4ca6a50582 100755
--- a/tools/net/ynl/ynl-regen.sh
+++ b/tools/net/ynl/ynl-regen.sh
@@ -19,6 +19,7 @@ for f in $files; do
     # params:     0       1      2     3
     #         $YAML YNL-GEN kernel $mode
     params=( $(git grep -B1 -h '/\* YNL-GEN' $f | sed 's@/\*\(.*\)\*/@\1@') )
+    args=$(sed -n 's@/\* YNL-ARG \(.*\) \*/@\1@p' $f)
 
     if [ $f -nt ${params[0]} -a -z "$force" ]; then
 	echo -e "\tSKIP $f"
@@ -26,5 +27,6 @@ for f in $files; do
     fi
 
     echo -e "\tGEN ${params[2]}\t$f"
-    $TOOL --mode ${params[2]} --${params[3]} --spec $KDIR/${params[0]} -o $f
+    $TOOL --mode ${params[2]} --${params[3]} --spec $KDIR/${params[0]} \
+	  $args -o $f
 done
-- 
2.40.1


