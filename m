Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AFA6C858E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjCXTFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCXTFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:05:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0CD222DC
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6596CB822D8
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 19:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CEBC4339B;
        Fri, 24 Mar 2023 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679684641;
        bh=lt9xq52U/P+X0WRgDoUfWmKQmIbOLVyPBdrUKcbFpjU=;
        h=From:To:Cc:Subject:Date:From;
        b=QWjUwBGPeUWl2cqGSpcP/mBwlMktKvCQVOvTWMRcDKCljFKe73LBJ5gyz7zV3V17o
         OXzHpL+12FjkWAUzx8i178mLcscrVdC6BF5rmbn0Fo7c2HgsUM/I56cinvCLziM/Al
         Wrtoi02kVAF//6yHvlWISfPWxrUnUyjZHnSKUc5XEg6N7odVtFGwkB2sLiPX6coi+r
         5UWoZzGjATa3mgFbVJNPUz+lfS7ulV0O9Qk8LVtSnp1QA25fc+c7qG8326+sZdg99w
         G9aDxY5CbryfPU6qkCb520x0Cs2r4JZCFvtU28sbY+mNyF9jAOOlI9j/XZbgi5hypt
         tXo8NAGKIf9Lg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] tools: ynl: default to treating enums as flags for mask generation
Date:   Fri, 24 Mar 2023 12:03:56 -0700
Message-Id: <20230324190356.2418748-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was a bit too optimistic in commit bf51d27704c9 ("tools: ynl: fix
get_mask utility routine"), not every mask we use is necessarily
coming from an enum of type "flags". We also allow flipping an
enum into flags on per-attribute basis. That's done by
the 'enum-as-flags' property of an attribute.

Restore this functionality, it's not currently used by any in-tree
family.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py | 8 ++++----
 tools/net/ynl/ynl-gen-c.py  | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index d04450c2a44a..dba70100124a 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -90,8 +90,8 @@ jsonschema = None
     def raw_value(self):
         return self.value
 
-    def user_value(self):
-        if self.enum_set['type'] == 'flags':
+    def user_value(self, as_flags=None):
+        if self.enum_set['type'] == 'flags' or as_flags:
             return 1 << self.value
         else:
             return self.value
@@ -136,10 +136,10 @@ jsonschema = None
                 return True
         return False
 
-    def get_mask(self):
+    def get_mask(self, as_flags=None):
         mask = 0
         for e in self.entries.values():
-            mask += e.user_value()
+            mask += e.user_value(as_flags)
         return mask
 
 
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 972b87c7aaaf..cc2f8c945340 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -254,7 +254,8 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation, SpecEnumSet, S
     def _attr_policy(self, policy):
         if 'flags-mask' in self.checks or self.is_bitfield:
             if self.is_bitfield:
-                mask = self.family.consts[self.attr['enum']].get_mask()
+                enum = self.family.consts[self.attr['enum']]
+                mask = enum.get_mask(as_flags=True)
             else:
                 flags = self.family.consts[self.checks['flags-mask']]
                 flag_cnt = len(flags['entries'])
-- 
2.39.2

