Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D2A6AE3C1
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCGPDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjCGPDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:03:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB43D8091A;
        Tue,  7 Mar 2023 06:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A02EBB818EB;
        Tue,  7 Mar 2023 14:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFBEC433D2;
        Tue,  7 Mar 2023 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200873;
        bh=ZUx6s1eJcolQfbulbwPNkhGN+26Dh4joSnuTvg9/z0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEOAgvlrQsR3cvVSqTz18bvMsEZ1mXD/h536kr1Q50A1uRKGgEAvWawykBcvhrfjq
         7GTvDzoC3V4VOqJwa9dERS8qW+1CioAT6p+xZcKp03PFgdu9KvRjcZIQzmKVq2Ji5G
         C9BrIaJGdys4g2SkNmj4nWYiuM6HOaZNe2blNhmrNBFYAiY4+Mf2EVvFXIVbBhxH4s
         wU81mZTDzSjbqlka7nRnyZMR0Tx+jK08SCieIqeg2Oxq5NjLrFZz0/DMJM6csMTaMl
         i99SCWiL2LwWn1iM0UHVR/BfD0iWffnlqgkoPC+JYM5hQBVs9ncudnpA9k5JECrNVP
         FulL3JxQXbdLA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: [PATCH net-next 2/8] tools: ynl: fix get_mask utility routine
Date:   Tue,  7 Mar 2023 15:53:59 +0100
Message-Id: <12a91d4e401c5390a34a3074fe9d8dfa41d43f35.1678200041.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678200041.git.lorenzo@kernel.org>
References: <cover.1678200041.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix get_mask utility routine in order to take into account possible gaps
in the elements list.

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index f2e41dd962d4..0d6df9414aa9 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -652,10 +652,8 @@ class EnumSet:
 
     def get_mask(self):
         mask = 0
-        idx = self.yaml.get('value-start', 0)
-        for _ in self.entry_list:
-            mask |= 1 << idx
-            idx += 1
+        for e in self.entry_list:
+            mask += e.user_value()
         return mask
 
 
-- 
2.39.2

