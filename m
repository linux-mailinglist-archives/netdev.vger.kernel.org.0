Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75872682221
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjAaCeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjAaCeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B828833440;
        Mon, 30 Jan 2023 18:34:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E58661368;
        Tue, 31 Jan 2023 02:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D64C4339B;
        Tue, 31 Jan 2023 02:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132443;
        bh=17O1RdheotiLHL1Fqe7/TmxyBIiBIeKRG2swJ+Wvif0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MlScTqsyikmfYGj5lV1f3IGO3ZFFpetx5gSXPDLngjaTnXObJdnEGA3fAsQLILkR5
         JPSLsM2dXMnkNcDsJHFXWgSrKjBrm2h8xTwl/vSxgj7grpKCCmSN0+vvllUVxHYfXo
         ffQfb6S8FmeudaSb2M/YLP0AhDdDFPQzc2MB518/Qkf5YkCXJiMIQPRmZnJQj6eVAI
         2oGin7kHvm9NuyEEc0Qtj0RQzcm/6Z2XT1+t7tQKVESDxkFYVQ7RaxCEaNFrHf/LWn
         3orxjL7t/H8pESRwhtlUayf1Nx8I+nn/Q+zgZRllx4V1B0YGPyg3/JCahNFl5uUUIm
         53M8HG00T295g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 08/14] tools: ynl: support pretty printing bad attribute names
Date:   Mon, 30 Jan 2023 18:33:48 -0800
Message-Id: <20230131023354.1732677-9-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131023354.1732677-1-kuba@kernel.org>
References: <20230131023354.1732677-1-kuba@kernel.org>
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

