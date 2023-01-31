Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06EC682219
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjAaCeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjAaCeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F653609C;
        Mon, 30 Jan 2023 18:34:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 575CA61234;
        Tue, 31 Jan 2023 02:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671C3C4339E;
        Tue, 31 Jan 2023 02:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132439;
        bh=cY+HZdRNd8OIFxn9pJrtYSKQIVlqBCGFUCPGH3foy94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjfPuBHwTuqtpoB9GAI/vMzB5lkVAS0OMLsavjb6xwnE8BJq4LXQzNBNrMwQqp8xk
         imYa8MUTBPDrUHertK9AdPOjWQqwCslkv9ldujC9Nnu4AWpr8McSTc1//8LhFTeFh6
         vaqk5A4D9nxQR2yTFm08dmChcNrhqIoGLOuA1qQyWCJYM70gOaU4VVk5F9YS8skwJ7
         JqddfBe9+JNBsErRyB4ebvEpcRhUr5A8laTqoGY5Kdz9bFn8ANd5OfxWRIQA9lsUQW
         LVJ61ldeUWIgmnT3OhjU8yBgjIiVn7lU5H2m7ERt1mZJJmMWo4ffA3avUoZ6w5iQa0
         UuMMYyba9GnWg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 01/14] tools: ynl-gen: prevent do / dump reordering
Date:   Mon, 30 Jan 2023 18:33:41 -0800
Message-Id: <20230131023354.1732677-2-kuba@kernel.org>
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

