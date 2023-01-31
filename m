Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B15968222E
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjAaCem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjAaCeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D7C303DE;
        Mon, 30 Jan 2023 18:34:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 841C4B8190E;
        Tue, 31 Jan 2023 02:34:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3001C433EF;
        Tue, 31 Jan 2023 02:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132444;
        bh=tGb81Ui669yq+FO9Xi0mcdWvM+2ed3UhiiK0sigu4pY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaEi3tNTqsk28GkqbY1qlEu0T3e2rSofTygZ0E6GUDIQzDvLxGlNzpvfnE6gmeUVZ
         9D75q6QKzNGMIu2EADFXRs+14DRu4ykA5xcPvzeTFj1p3T7/t/ED4BPvcR2VCMVQOz
         4m0tPhm4qEA6MPSeIa3fd3Sfh5WZnlWEEJZ/ZGX2v/c1CyTYyiy1rEJrnWPTdZQpSl
         pcj9N0bsTF9AXkizPySU61Q4W8jIth+Rh1VZv4sQTPy0+a8CEy57ONehADI//aIoMp
         RsplprlFlwSeI+n6dpjNoSAE62qBx7wPCPPfbzGLPsFjOfcFqcNRIsPc/eR3aJAGWc
         pmpa2Mvr6zNIg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 09/14] tools: ynl: use operation names from spec on the CLI
Date:   Mon, 30 Jan 2023 18:33:49 -0800
Message-Id: <20230131023354.1732677-10-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
References: <20230131023354.1732677-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I wrote the first version of the Python code I was quite
excited that we can generate class methods directly from the
spec. Unfortunately we need to use valid identifiers for method
names (specifically no dashes are allowed). Don't reuse those
names on the CLI, it's much more natural to use the operation
names exactly as listed in the spec.

Instead of:
  ./cli --do rings_get
use:
  ./cli --do rings-get

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/cli.py     | 9 +++++----
 tools/net/ynl/lib/ynl.py | 6 ++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/net/ynl/cli.py b/tools/net/ynl/cli.py
index 5c4eb5a68514..05d1f4069ce1 100755
--- a/tools/net/ynl/cli.py
+++ b/tools/net/ynl/cli.py
@@ -32,10 +32,11 @@ from lib import YnlFamily
     if args.sleep:
         time.sleep(args.sleep)
 
-    if args.do or args.dump:
-        method = getattr(ynl, args.do if args.do else args.dump)
-
-        reply = method(attrs, dump=bool(args.dump))
+    if args.do:
+        reply = ynl.do(args.do, attrs)
+        pprint.PrettyPrinter().pprint(reply)
+    if args.dump:
+        reply = ynl.dump(args.dump, attrs)
         pprint.PrettyPrinter().pprint(reply)
 
     if args.ntf:
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 2ff3e6dbdbf6..1c7411ee04dc 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -520,3 +520,9 @@ genl_family_name_to_id = None
         if not dump and len(rsp) == 1:
             return rsp[0]
         return rsp
+
+    def do(self, method, vals):
+        return self._op(method, vals)
+
+    def dump(self, method, vals):
+        return self._op(method, vals, dump=True)
-- 
2.39.1

