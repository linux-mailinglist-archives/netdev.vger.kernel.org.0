Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2859567C144
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 01:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjAZACn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 19:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjAZACm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 19:02:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579092CC47
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 16:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21364B81C5E
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 00:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A20CC4339C;
        Thu, 26 Jan 2023 00:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674691358;
        bh=5c6Gwqw1x0tgfqAncIDtlpoPTpYEqVMExwvKf4poV7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlrG43iLWsprJ7ljY2Csw84XmDhVyDJ7AEpLnmpc0RRkZnoJSzS3npDhDjw9VqsWR
         Eis7bpuDG1wJ+byzJj06LFpPL6UjpuVS7UfUpJxxVsjEWqzf7jzAHU/uq6EJqi1lot
         HezxJ5ASrkr7e0+yu7afOVMMbJ+FDS9cy0cFFHXz6wVjA1mP8VHLcSMlsRJ/lffEYZ
         9RtdWlSPJ4QSPlmWoX09JviJWpoobMBpQZjmLdR2h0RmDCfNeMd5DEw5P+FRQsJkmX
         5QzDQdByCH+bt8P+YAEFnSEuDda33Q+OVyfqtNx1C1xuAfEI3isxf0lMHtfEi9VjQz
         0adyVvKW4ZlIg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 1/3] tools: ynl: support kdocs for flags in code generation
Date:   Wed, 25 Jan 2023 16:02:33 -0800
Message-Id: <20230126000235.1085551-2-kuba@kernel.org>
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

Lorenzo reports that after switching from enum to flags netdev
family lost ability to render kdoc (and the enum contents got
generally garbled).

Combine the flags and enum handling in uAPI handling.

Reported-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 0c0f18540b7f..91df8eec86f9 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -565,6 +565,7 @@ import yaml
             self.doc = yaml.get('doc', '')
 
         self.yaml = yaml
+        self.enum_set = enum_set
         self.c_name = c_upper(enum_set.value_pfx + self.name)
 
         if 'value' in yaml:
@@ -572,11 +573,14 @@ import yaml
             if prev:
                 self.value_change = (self.value != prev.value + 1)
         elif prev:
+            self.value_change = False
             self.value = prev.value + 1
         else:
             self.value = value_start
             self.value_change = (self.value != 0)
 
+        self.value_change = self.value_change or self.enum_set['type'] == 'flags'
+
     def __getitem__(self, key):
         return self.yaml[key]
 
@@ -586,6 +590,17 @@ import yaml
     def has_doc(self):
         return bool(self.doc)
 
+    # raw value, i.e. the id in the enum, unlike user value which is a mask for flags
+    def raw_value(self):
+        return self.value
+
+    # user value, same as raw value for enums, for flags it's the mask
+    def user_value(self):
+        if self.enum_set['type'] == 'flags':
+            return 1 << self.value
+        else:
+            return self.value
+
 
 class EnumSet:
     def __init__(self, family, yaml):
@@ -824,7 +839,7 @@ import yaml
 
     def _dictify(self):
         for elem in self.yaml['definitions']:
-            if elem['type'] == 'enum':
+            if elem['type'] == 'enum' or elem['type'] == 'flags':
                 self.consts[elem['name']] = EnumSet(self, elem)
             else:
                 self.consts[elem['name']] = elem
@@ -1973,7 +1988,8 @@ _C_KW = {
             defines = []
             cw.nl()
 
-        if const['type'] == 'enum':
+        # Write kdoc for enum and flags (one day maybe also structs)
+        if const['type'] == 'enum' or const['type'] == 'flags':
             enum = family.consts[const['name']]
 
             if enum.has_doc():
@@ -1989,13 +2005,11 @@ _C_KW = {
                 cw.p(' */')
 
             uapi_enum_start(family, cw, const, 'name')
-            first = True
             name_pfx = const.get('name-prefix', f"{family.name}-{const['name']}-")
             for entry in enum.entry_list:
                 suffix = ','
-                if first and 'value-start' in const:
-                    suffix = f" = {const['value-start']}" + suffix
-                first = False
+                if entry.value_change:
+                    suffix = f" = {entry.user_value()}" + suffix
                 cw.p(entry.c_name + suffix)
 
             if const.get('render-max', False):
@@ -2005,17 +2019,6 @@ _C_KW = {
                 cw.p(max_name + ' = (__' + max_name + ' - 1)')
             cw.block_end(line=';')
             cw.nl()
-        elif const['type'] == 'flags':
-            uapi_enum_start(family, cw, const, 'name')
-            i = const.get('value-start', 0)
-            for item in const['entries']:
-                item_name = item
-                if 'name-prefix' in const:
-                    item_name = c_upper(const['name-prefix'] + item)
-                cw.p(f'{item_name} = {1 << i},')
-                i += 1
-            cw.block_end(line=';')
-            cw.nl()
         elif const['type'] == 'const':
             defines.append([c_upper(family.get('c-define-name',
                                                f"{family.name}-{const['name']}")),
-- 
2.39.1

