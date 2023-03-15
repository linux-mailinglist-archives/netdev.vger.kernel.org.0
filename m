Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C936BC0A2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjCOXEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbjCOXEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:04:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1834778C8F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 16:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAF2FB81F87
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 23:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B47C433EF;
        Wed, 15 Mar 2023 23:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921467;
        bh=lxaOAaqROjb/pP1AosN8mqKLePuHN3BDz2CJ0CJw0HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9j2JyeR8RtanGlgDr7TCX6y8iWV+gp1HnUV+D/vyVqEkEJ1ZX41x1rDNUNYGs5cW
         4jy7++tJd5WP9Crgk1cNaXJEk5qIAp/i0wGL4HrpGd5J0EJgII2I43LwayJEY/WLcI
         Pm+Hd/nw4JV10CQlzFWfGh515ceI/lrJMYc1mH+Wa0iiXDg+x4/RaMC92HyyZzagJf
         88xXoPQ84qUCa9OVXojSX6lxi+pRJxgD0e9wCGt031VM81x3pZMVpTyTIN7MMIL8P7
         xRh/WHmsl7QKV/X+uUcKJ9H36WeNI+n9dzNw8LURbWBaKglpRclxv5F8A+f209zdqZ
         b0AsPR97XCA4g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        chuck.lever@oracle.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/3] ynl: make the tooling check the license
Date:   Wed, 15 Mar 2023 16:03:51 -0700
Message-Id: <20230315230351.478320-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315230351.478320-1-kuba@kernel.org>
References: <20230315230351.478320-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The (only recently documented) expectation is that all specs
are under a certain license, but we don't actually enforce it.
What's worse we then go ahead and assume the license was right,
outputting the expected license into generated files.

Cc: Chuck Lever <chuck.lever@oracle.com>
Fixes: 37d9df224d1e ("ynl: re-license uniformly under GPL-2.0 OR BSD-3-Clause")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py |  8 ++++++++
 tools/net/ynl/ynl-gen-c.py  | 13 +++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index e01a72d06638..d04450c2a44a 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -274,6 +274,7 @@ jsonschema = None
 
     Attributes:
         proto     protocol type (e.g. genetlink)
+        license   spec license (loaded from an SPDX tag on the spec)
 
         attr_sets  dict of attribute sets
         msgs       dict of all messages (index by name)
@@ -283,6 +284,13 @@ jsonschema = None
     """
     def __init__(self, spec_path, schema_path=None):
         with open(spec_path, "r") as stream:
+            prefix = '# SPDX-License-Identifier: '
+            first = stream.readline().strip()
+            if not first.startswith(prefix):
+                raise Exception('SPDX license tag required in the spec')
+            self.license = first[len(prefix):]
+
+            stream.seek(0)
             spec = yaml.safe_load(stream)
 
         self._resolution_list = []
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 3b4d03a50fc1..c16671a02621 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2059,6 +2059,10 @@ _C_KW = {
 
     try:
         parsed = Family(args.spec)
+        if parsed.license != '((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)':
+            print('Spec license:', parsed.license)
+            print('License must be: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)')
+            os.sys.exit(1)
     except yaml.YAMLError as exc:
         print(exc)
         os.sys.exit(1)
@@ -2067,13 +2071,10 @@ _C_KW = {
     cw = CodeWriter(BaseNlLib(), out_file)
 
     _, spec_kernel = find_kernel_root(args.spec)
-    if args.mode == 'uapi':
-        cw.p('/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */')
+    if args.mode == 'uapi' or args.header:
+        cw.p(f'/* SPDX-License-Identifier: {parsed.license} */')
     else:
-        if args.header:
-            cw.p('/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */')
-        else:
-            cw.p('// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)')
+        cw.p(f'// SPDX-License-Identifier: {parsed.license}')
     cw.p("/* Do not edit directly, auto-generated from: */")
     cw.p(f"/*\t{spec_kernel} */")
     cw.p(f"/* YNL-GEN {args.mode} {'header' if args.header else 'source'} */")
-- 
2.39.2

