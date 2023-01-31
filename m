Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FAC68222A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjAaCeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjAaCeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C9336097;
        Mon, 30 Jan 2023 18:34:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9662BB818C2;
        Tue, 31 Jan 2023 02:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4647C4339E;
        Tue, 31 Jan 2023 02:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132443;
        bh=VE1MQZ6xXvdfefBgdpPnNIg7JKXa3Rh+M/UzCqPREeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaZmO6NXH3UsQYTQwftu0hFGuva/O9LFnMPfVUdKp6UlPwnJc3L+ARy09PxaSBibv
         aEOrzmsypJPcIUB5APOZKyG19mBBi9EOU8z+sptA//rZR6Rj4cSRFnPGXX/0Su7Mbk
         /YHtzHSsidPjUuxpTTx1PjKzqoR4mxxl0xg3h98pGaE4xGJGIyUpRspg39hnBcU9Yj
         9qVZEs7EpJpuGMjM1V3qNYBYdwUO0T5p1psZEiFw4qmm/N3tselY4+sBojCxP9T6gV
         vzSfxm2NSkfI553aJIuVBx2NMRb0wsnIZAWEPcHPxxay/RK/twaRAEXmHFPSGTz9Th
         ydUsQz3R79zkg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 07/14] tools: ynl: support multi-attr
Date:   Mon, 30 Jan 2023 18:33:47 -0800
Message-Id: <20230131023354.1732677-8-kuba@kernel.org>
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

Ethtool uses mutli-attr, add the support to YNL.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 690065003935..c16326495cb7 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -373,22 +373,29 @@ genl_family_name_to_id = None
             attr_spec = attr_space.attrs_by_val[attr.type]
             if attr_spec["type"] == 'nest':
                 subdict = self._decode(NlAttrs(attr.raw), attr_spec['nested-attributes'])
-                rsp[attr_spec['name']] = subdict
+                decoded = subdict
             elif attr_spec['type'] == 'u8':
-                rsp[attr_spec['name']] = attr.as_u8()
+                decoded = attr.as_u8()
             elif attr_spec['type'] == 'u32':
-                rsp[attr_spec['name']] = attr.as_u32()
+                decoded = attr.as_u32()
             elif attr_spec['type'] == 'u64':
-                rsp[attr_spec['name']] = attr.as_u64()
+                decoded = attr.as_u64()
             elif attr_spec["type"] == 'string':
-                rsp[attr_spec['name']] = attr.as_strz()
+                decoded = attr.as_strz()
             elif attr_spec["type"] == 'binary':
-                rsp[attr_spec['name']] = attr.as_bin()
+                decoded = attr.as_bin()
             elif attr_spec["type"] == 'flag':
-                rsp[attr_spec['name']] = True
+                decoded = True
             else:
                 raise Exception(f'Unknown {attr.type} {attr_spec["name"]} {attr_spec["type"]}')
 
+            if not attr_spec.is_multi:
+                rsp[attr_spec['name']] = decoded
+            elif attr_spec.name in rsp:
+                rsp[attr_spec.name].append(decoded)
+            else:
+                rsp[attr_spec.name] = [decoded]
+
             if 'enum' in attr_spec:
                 self._decode_enum(rsp, attr_spec)
         return rsp
-- 
2.39.1

