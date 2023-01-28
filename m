Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C7A67F4AA
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjA1Ec1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjA1EcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A6A7C307
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D3BD60AD1
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FC3C433A1;
        Sat, 28 Jan 2023 04:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880342;
        bh=VE1MQZ6xXvdfefBgdpPnNIg7JKXa3Rh+M/UzCqPREeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XioEdCihya4Xm39uSq6AavS1rqzpB7A4KEQetRGqydWwHUGGyIZL4xIzD++K2VM5r
         NcDv68QAlPBvkuy8Od/mhmKQK/N94afHHk+SAJaIEOKow5bZuAEtvywcLbu8A5QhZ9
         tciKoz4vhwaJz7x+sYkayF9y4BQ7lnbw0qU7IyMvA0sIPpGQVr9nsDELTCHfxJl7jv
         EKk7s/0Tm/27THSkUnVwceVmlJmAtj0N3u3IMnWO3v+2ocojzDHcE2+3sYGdYlKVWr
         hqh5H6MAQCwstDgOXlBlKc3XtMbsr5FwVBwVilJGIh3/raU8Vhj6RF7pjGYp5SSQM2
         1Ce47ku4i3NfA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/13] tools: ynl: support multi-attr
Date:   Fri, 27 Jan 2023 20:32:11 -0800
Message-Id: <20230128043217.1572362-8-kuba@kernel.org>
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

