Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852DC68222B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjAaCeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjAaCeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0A419F1A;
        Mon, 30 Jan 2023 18:34:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86368B8165D;
        Tue, 31 Jan 2023 02:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5838C433EF;
        Tue, 31 Jan 2023 02:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132442;
        bh=NOE/X1dK0JFc8XEYpg14yfFzyn7RgGNfRMcIGtf0o+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8gNjRdj7Ca0Tc1+fIjHYseSJSzskJ3U6xEavazrACOzur2vMYkvmq51WO/M0vlRk
         6OcDG09XqywealimMyXYgnOn9vuLprrU17KU7Rzah0R/xzcO0SmYAOBuGAcP+YygtT
         TrD5hmZNY8MKV9C5Fw6GV3t8UK2FOJq1MYOalOc9uGYj3NwVRurgxKVfdw2wVdp0JQ
         SbaFyD6zR81WjC2QMOR1XLzBogLy/vZaqdupYL4xvvAwwaFoD5ugkVTMkUKSM+IXKf
         OVDl8U8f23oNadS1AH6aOkexXyIqIFXl0o6Z2vdfmwUo54btC7DASwM31p7zU5aLAW
         qXItOu6cPO2GQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 05/14] tools: ynl: add support for types needed by ethtool
Date:   Mon, 30 Jan 2023 18:33:45 -0800
Message-Id: <20230131023354.1732677-6-kuba@kernel.org>
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

