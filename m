Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386BE67F4AB
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjA1Ec3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjA1EcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE6E7BBEB
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32A5060A4D
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFBBC4339C;
        Sat, 28 Jan 2023 04:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880341;
        bh=NOE/X1dK0JFc8XEYpg14yfFzyn7RgGNfRMcIGtf0o+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOZgK+YeTvx9uD+rVX6ULWx4ZcaMdqilOLjN33np+YQbutQ6cWhd4SpS5VVDlYuJm
         fjQcBSycG55OW6S7oukiMk49rNLRZ3wClL17tUYnGYILMNByLEhOtYyQR7o2zdgghS
         5o/mDkA0BfEX4nKzfAQtv0XWzJ7aNrG1+QMI6tV+k0MXXepJ2NogbhQZwXWVMOQKBY
         HfD3CVwKF64tE2B1DNyGkjlDB1OKGw1HA9yCnHfvDWJkT8qukMJ8JlZMM0TVuGzt7B
         C5e7Msx6CqRwyjo8sU9F5SNfB9QRrbYDPbyUGqxJXQsCPS4pgtQvD1h5p9LvElpy1/
         Fd/bMNGy3gQSg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/13] tools: ynl: add support for types needed by ethtool
Date:   Fri, 27 Jan 2023 20:32:09 -0800
Message-Id: <20230128043217.1572362-6-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230128043217.1572362-1-kuba@kernel.org>
References: <20230128043217.1572362-1-kuba@kernel.org>
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

Ethtool needs support for handful of extra types.
It doesn't have the definitions section yet.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 0ceb627ba686..a656b655d302 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -75,6 +75,9 @@ from .nlspec import SpecFamily
         self.full_len = (self.payload_len + 3) & ~3
         self.raw = raw[offset + 4:offset + self.payload_len]
 
+    def as_u8(self):
+        return struct.unpack("B", self.raw)[0]
+
     def as_u16(self):
         return struct.unpack("H", self.raw)[0]
 
@@ -302,7 +305,7 @@ genl_family_name_to_id = None
 
         self._types = dict()
 
-        for elem in self.yaml['definitions']:
+        for elem in self.yaml.get('definitions', []):
             self._types[elem['name']] = elem
 
         self.async_msg_ids = set()
@@ -334,6 +337,8 @@ genl_family_name_to_id = None
             attr_payload = b''
             for subname, subvalue in value.items():
                 attr_payload += self._add_attr(attr['nested-attributes'], subname, subvalue)
+        elif attr["type"] == 'flag':
+            attr_payload = b''
         elif attr["type"] == 'u32':
             attr_payload = struct.pack("I", int(value))
         elif attr["type"] == 'string':
@@ -369,6 +374,8 @@ genl_family_name_to_id = None
             if attr_spec["type"] == 'nest':
                 subdict = self._decode(NlAttrs(attr.raw), attr_spec['nested-attributes'])
                 rsp[attr_spec['name']] = subdict
+            elif attr_spec['type'] == 'u8':
+                rsp[attr_spec['name']] = attr.as_u8()
             elif attr_spec['type'] == 'u32':
                 rsp[attr_spec['name']] = attr.as_u32()
             elif attr_spec['type'] == 'u64':
@@ -377,6 +384,8 @@ genl_family_name_to_id = None
                 rsp[attr_spec['name']] = attr.as_strz()
             elif attr_spec["type"] == 'binary':
                 rsp[attr_spec['name']] = attr.as_bin()
+            elif attr_spec["type"] == 'flag':
+                rsp[attr_spec['name']] = True
             else:
                 raise Exception(f'Unknown {attr.type} {attr_spec["name"]} {attr_spec["type"]}')
 
-- 
2.39.1

