Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3286B2414
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjCIM0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCIM0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:26:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D4CEBACB;
        Thu,  9 Mar 2023 04:26:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E96161B3C;
        Thu,  9 Mar 2023 12:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F649C433D2;
        Thu,  9 Mar 2023 12:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678364761;
        bh=Q4zxT630uhEY6mwv9Nn3u8BcxGOGhv23DrCxmUdjDJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V03VHnzIwNp16v88oJqM6pHrrgb1lQlZE8G05In+YT7W0Yg/ptvLgN7tfetpJB3DR
         iWR76tDMPNg7DRWDttEP3Fn/z0SQu0kHQLeY8oVliZFWC3jmKy9Q+ulW/gzGPyKCEv
         guext1HjijUbg+q+8vEzdwdJmDmajjWrAfgjPnWUPrXDu3w291LOfsUjNEwazUutvp
         gU4fuBXFBuioRd9j2XyzRVqTLFjTWmkc+1YlZ/e1nqhkOGEq0TqNOdc/EsTfDg17jr
         fV+qiC63X8OQ5iXM5xc9DszJJbQ7h5TvSfNgNPb87b29Wnc2paFYL4TTsvKWeMf5dY
         4HZNXDw6979OA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: [PATCH net v2 1/8] tools: ynl: fix render-max for flags definition
Date:   Thu,  9 Mar 2023 13:25:25 +0100
Message-Id: <f319eca141cf449cd6d629d005d05bc96541fd5f.1678364613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678364612.git.lorenzo@kernel.org>
References: <cover.1678364612.git.lorenzo@kernel.org>
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

Properly manage render-max property for flags definition type
introducing mask value and setting it to (last_element << 1) - 1
instead of adding max value set to last_element + 1

Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 1bcc5354d800..d47376f19de7 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1931,9 +1931,14 @@ def render_uapi(family, cw):
 
             if const.get('render-max', False):
                 cw.nl()
-                max_name = c_upper(name_pfx + 'max')
-                cw.p('__' + max_name + ',')
-                cw.p(max_name + ' = (__' + max_name + ' - 1)')
+                if const['type'] == 'flags':
+                    max_name = c_upper(name_pfx + 'mask')
+                    max_val = f' = {enum.get_mask()},'
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

