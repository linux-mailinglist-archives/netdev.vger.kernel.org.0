Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2224B6A0F7F
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 19:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbjBWScB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 13:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjBWSb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 13:31:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BFB4E5E8
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 10:31:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFEE36175D
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 18:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073C9C433EF;
        Thu, 23 Feb 2023 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677177113;
        bh=cxqJ/M8Tf2bSyM42Q4JJP41rPkR/EVcgdE7J7slkcqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6QKJhBEhm1IvMUXArkWx834yjgN7jF3gZtkzBVHw8PPEce1R8SBkd8Bkv/zcuABH
         hOopJ7DbH8hOcJxpL/9AcblHtDXUaFxq8AB4apwHF+gX4yCCj/YfXQ+OSp50jYrRh8
         d3Z52TkbJFHO+OXGMINS/tFRIJ/1y0vRQsdrtq4mlqk54XsBkbnhQEdP2mw5gBmZ7w
         YYIWkKt6ENhvdWuggd3dc1ViAB34F05Lh7WAqF/sMzjb98/UyHsDC9WsZ5H/WcUvfs
         mkIZNUsIFnQxDwZ8kXHoE9B3XfJK++slFZPL0ou3/i002hqqQ4WooI30VbFMmQBDQZ
         ok7mGIA9Lu2Ag==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>
Subject: [PATCH net 1/3] tools: ynl-gen: fix single attribute structs with attr 0 only
Date:   Thu, 23 Feb 2023 10:31:39 -0800
Message-Id: <20230223183141.1422857-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223183141.1422857-1-kuba@kernel.org>
References: <20230223183141.1422857-1-kuba@kernel.org>
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

Chuck run into an issue with a single-element attr-set which
only has an attr with value of 0. The search for max attr in
a struct records attrs with value larger than 0 only (max_val
is set to 0 at the start). Adjust the comparison, alternatively
max_val could be init'ed to -1. Somehow picking the last attr
of a value seems like a good idea in general.

Reported-by: Chuck Lever III <chuck.lever@oracle.com>
Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 3942f24b9163..274e9c566f61 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -546,7 +546,7 @@ from lib import SpecFamily, SpecAttrSet, SpecAttr, SpecOperation
         max_val = 0
         self.attr_max_val = None
         for name, attr in self.attr_list:
-            if attr.value > max_val:
+            if attr.value >= max_val:
                 max_val = attr.value
                 self.attr_max_val = attr
             self.attrs[name] = attr
-- 
2.39.2

