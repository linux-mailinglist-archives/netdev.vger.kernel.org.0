Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F185C67F4AD
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjA1Ecb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjA1EcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B557C310
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F001860AF9
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F95C433A4;
        Sat, 28 Jan 2023 04:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880342;
        bh=17O1RdheotiLHL1Fqe7/TmxyBIiBIeKRG2swJ+Wvif0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gh5xVDxuIPjLmUdd0kfsib6ksE/p4e8yzSgy6oIx8Z7iXhFx6jNQ7Y6mymJG1Q8N3
         UI/K46Vf134Y/sW/u9FFwJ41Q2sP3NUjnt8tKHcmmixlxt4UaDq0kU7KPlQkROZSpu
         Bwbo+X1iXsajUyicAe2B+OtygZWOQubizKWA8k8kkxIhNvm4jaTEGsM7f7lNAiGrrl
         LPQS1wpCFRNN2UuNdIKcgl0iFW6xeddvjUsnYgd/eG9SHrOd3mNKWXoQYHRs9y/0vD
         0e0z3dRWO8A5DGXAUq49ri1dHj/OlJjFpWAWGxQRPYU3t7EdShOE0+sPIkxXYMAAgB
         ihEeZPN7F0fcQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/13] tools: ynl: support pretty printing bad attribute names
Date:   Fri, 27 Jan 2023 20:32:12 -0800
Message-Id: <20230128043217.1572362-9-kuba@kernel.org>
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

One of my favorite features of the Netlink specs is that they
make decoding structured extack a ton easier.
Implement pretty printing bad attribute names in YNL.

For example it will now say:

  'bad-attr': '.header.flags'

rather than the useless:

  'bad-attr-offs': 32

Proof:

  $ ./cli.py --spec ethtool.yaml --do rings_get \
     --json '{"header":{"dev-index":1, "flags":4}}'
  Netlink error: Invalid argument
  nl_len = 68 (52) nl_flags = 0x300 nl_type = 2
	error: -22	extack: {'msg': 'reserved bit set',
				 'bad-attr': '.header.flags'}

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index c16326495cb7..2ff3e6dbdbf6 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -400,6 +400,40 @@ genl_family_name_to_id = None
                 self._decode_enum(rsp, attr_spec)
         return rsp
 
+    def _decode_extack_path(self, attrs, attr_set, offset, target):
+        for attr in attrs:
+            attr_spec = attr_set.attrs_by_val[attr.type]
+            if offset > target:
+                break
+            if offset == target:
+                return '.' + attr_spec.name
+
+            if offset + attr.full_len <= target:
+                offset += attr.full_len
+                continue
+            if attr_spec['type'] != 'nest':
+                raise Exception(f"Can't dive into {attr.type} ({attr_spec['name']}) for extack")
+            offset += 4
+            subpath = self._decode_extack_path(NlAttrs(attr.raw),
+                                               self.attr_sets[attr_spec['nested-attributes']],
+                                               offset, target)
+            if subpath is None:
+                return None
+            return '.' + attr_spec.name + subpath
+
+        return None
+
+    def _decode_extack(self, request, attr_space, extack):
+        if 'bad-attr-offs' not in extack:
+            return
+
+        genl_req = GenlMsg(NlMsg(request, 0, attr_space=attr_space))
+        path = self._decode_extack_path(genl_req.raw_attrs, attr_space,
+                                        20, extack['bad-attr-offs'])
+        if path:
+            del extack['bad-attr-offs']
+            extack['bad-attr'] = path
+
     def handle_ntf(self, nl_msg, genl_msg):
         msg = dict()
         if self.include_raw:
@@ -455,11 +489,17 @@ genl_family_name_to_id = None
             reply = self.sock.recv(128 * 1024)
             nms = NlMsgs(reply, attr_space=op.attr_set)
             for nl_msg in nms:
+                if nl_msg.extack:
+                    self._decode_extack(msg, op.attr_set, nl_msg.extack)
+
                 if nl_msg.error:
                     print("Netlink error:", os.strerror(-nl_msg.error))
                     print(nl_msg)
                     return
                 if nl_msg.done:
+                    if nl_msg.extack:
+                        print("Netlink warning:")
+                        print(nl_msg)
                     done = True
                     break
 
-- 
2.39.1

