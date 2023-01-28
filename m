Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1753F67F4A9
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjA1Ec0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjA1EcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813B5790A2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 443C7B8220B
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3FF6C4339E;
        Sat, 28 Jan 2023 04:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880339;
        bh=cY+HZdRNd8OIFxn9pJrtYSKQIVlqBCGFUCPGH3foy94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cg+8rf5UZgT5T3LFUHhko/332DrJW/9HGknWZpB/tLW8qJjXZrmelNFLKzPsmR8n9
         E4oPm3vemsJOBAqTXVXPnUeI3eANxE96C/FcCq00R9psNlfjo5bMGb1pq1kNMCQzGm
         Zt16NRaSJ+S4on1MGqAG7gcVFoMYviRfMDQMSz5UAp2aT581RckA6pQahPFInWKsdB
         1i2SanR5dl9SrKDe2ieipCxK880/TjZ+ggE73wb8X2j2/01Bc/cMp1uHdX2Lau1B/k
         rFQLN6WlKwuHtimeWoHXYpyUrTUasOIhzH2AG4YvR0WPhSrgSyWhrj522zBiag2thO
         HcdBbVIEu6PKg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/13] tools: ynl-gen: prevent do / dump reordering
Date:   Fri, 27 Jan 2023 20:32:05 -0800
Message-Id: <20230128043217.1572362-2-kuba@kernel.org>
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

An earlier fix tried to address generated code jumping around
one code-gen run to another. Turns out dict()s are already
ordered since Python 3.7, the problem is that we iterate over
operation modes using a set(). Sets are unordered in Python.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 1aa872e582ab..e5002d420961 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -933,7 +933,7 @@ import yaml
             if attr_set_name != op['attribute-set']:
                 raise Exception('For a global policy all ops must use the same set')
 
-            for op_mode in {'do', 'dump'}:
+            for op_mode in ['do', 'dump']:
                 if op_mode in op:
                     global_set.update(op[op_mode].get('request', []))
 
@@ -2244,7 +2244,7 @@ _C_KW = {
 
             for op_name, op in parsed.ops.items():
                 if parsed.kernel_policy in {'per-op', 'split'}:
-                    for op_mode in {'do', 'dump'}:
+                    for op_mode in ['do', 'dump']:
                         if op_mode in op and 'request' in op[op_mode]:
                             cw.p(f"/* {op.enum_name} - {op_mode} */")
                             ri = RenderInfo(cw, parsed, args.mode, op, op_name, op_mode)
-- 
2.39.1

