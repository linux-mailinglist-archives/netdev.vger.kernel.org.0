Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7A86AE3BF
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjCGPDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjCGPDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:03:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E975E7F029;
        Tue,  7 Mar 2023 06:54:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85801B818FB;
        Tue,  7 Mar 2023 14:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8624C433EF;
        Tue,  7 Mar 2023 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200869;
        bh=xW3ABD0BkQGuhZsKxVZkhTGUDRh/hEXsfgK3MFqALVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yg2abeh52wsabunFAijYME0cy/8RUmOsop/YI7HzVKqdTLgpzvfl0xHy8inPINmGm
         7M9O7kTSNnlYjRX9FRDx8VfnssCrYhLGQ1bNXMfieNF81CUjWdFVHj+jsaMIpZhi3W
         WMdFzfzZsxS4aun+aOjQWHztuOX2pFeFX/dUlAISpPQyFGInvuCxgMm13kvZAOtA5u
         5eKEAZandxa/b0Cxl1i2JewtVGGFiP41s5u/sc24ZT5H+I29moXRhN9i9pj3vVlcs7
         7lviykITxkvSa/bsQEQNWCMvNAzIiR9QlJhPpUnG4iwo83WXEjEmX82NZtNMj+EEcy
         BDsnY+xtUr4gQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: [PATCH net-next 1/8] tools: ynl: fix render-max for flags definition
Date:   Tue,  7 Mar 2023 15:53:58 +0100
Message-Id: <b4359cc25819674de797029eb7e4a746853c1df4.1678200041.git.lorenzo@kernel.org>
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

Properly manage render-max property for flags definition type
introducing mask value and setting it to (last_element << 1) - 1
instead of adding max value set to last_element + 1

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 274e9c566f61..f2e41dd962d4 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1995,9 +1995,14 @@ def render_uapi(family, cw):
 
             if const.get('render-max', False):
                 cw.nl()
-                max_name = c_upper(name_pfx + 'max')
-                cw.p('__' + max_name + ',')
-                cw.p(max_name + ' = (__' + max_name + ' - 1)')
+                if const['type'] == 'flags':
+                    max_name = c_upper(name_pfx + 'mask')
+                    max_val = f' = {(entry.user_value() << 1) - 1},'
+                    cw.p(max_name + max_val)
+                else:
+                    max_name = c_upper(name_pfx + 'max')
+                    cw.p('__' + max_name + ',')
+                    cw.p(max_name + ' = (__' + max_name + ' - 1)')
             cw.block_end(line=';')
             cw.nl()
         elif const['type'] == 'const':
-- 
2.39.2

