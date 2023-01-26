Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF23367C146
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 01:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjAZACv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 19:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjAZACn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 19:02:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EE53A861
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 16:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70761B81C66
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 00:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97F3C4339E;
        Thu, 26 Jan 2023 00:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674691359;
        bh=ozw8mv6BXVF3wW0k53iqSxn5XDaDz+6JRot2NQxwYm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gcn0j/gfLgd+5ehOJrmBbyJia5rSMG4jD9NOxMBO8x0fQRYArzc5RDbB2N2rhUIBX
         XPf+xdKyRfKhN2QYXOjDeRXRRv+1/8Tcfsc9rfEFfmx93rtZucfgjX+HOxtNgrF6Gl
         10vk/NoJxk+IrNa12qF6ydHIEMRbaM6NgLAilIznL6qwszz5rGV5QJEZXClfF/vrXe
         0wyxBlsfrpxOn6ZgrNIJpEPaZYFSoAWPFtoNEDJWJ70UjayrbsHeDS3d0tMBf1+/EN
         LNuI/8xCmPM3SWk29k2dL7i/YfGrPj4YFtkyUBkWPTfmRc0IRHzY84fHJv/U765wMS
         c/x21FNUVorKw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/3] tools: ynl: rename ops_list -> msg_list
Date:   Wed, 25 Jan 2023 16:02:34 -0800
Message-Id: <20230126000235.1085551-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126000235.1085551-1-kuba@kernel.org>
References: <20230126000235.1085551-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ops_list contains all the operations, but the main iteration use
case is to walk only ops which define attrs. Rename ops_list to
msg_list, because now it looks like the contents are the same,
just the format is different. While at it convert from tuple
to just keys, none of the users care about the name of the op.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 91df8eec86f9..9297cfacbe06 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -790,8 +790,10 @@ import yaml
         self.mcgrps = self.yaml.get('mcast-groups', {'list': []})
 
         self.consts = dict()
+        # list of all operations
+        self.msg_list = []
+        # dict of operations which have their own message type (have attributes)
         self.ops = dict()
-        self.ops_list = []
         self.attr_sets = dict()
         self.attr_sets_list = []
 
@@ -858,7 +860,7 @@ import yaml
             op = Operation(self, elem, val)
             val += 1
 
-            self.ops_list.append((elem['name'], op),)
+            self.msg_list.append(op)
             if 'notify' in elem:
                 ntf.append(op)
                 continue
@@ -2063,7 +2065,7 @@ _C_KW = {
     max_value = f"({cnt_name} - 1)"
 
     uapi_enum_start(family, cw, family['operations'], 'enum-name')
-    for _, op in family.ops_list:
+    for op in family.msg_list:
         if separate_ntf and ('notify' in op or 'event' in op):
             continue
 
@@ -2082,7 +2084,7 @@ _C_KW = {
 
     if separate_ntf:
         uapi_enum_start(family, cw, family['operations'], enum_name='async-enum')
-        for _, op in family.ops_list:
+        for op in family.msg_list:
             if separate_ntf and not ('notify' in op or 'event' in op):
                 continue
 
-- 
2.39.1

