Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B0264FF8E
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiLRQEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiLRQDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:03:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD45EBF43;
        Sun, 18 Dec 2022 08:02:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CB91B80BA2;
        Sun, 18 Dec 2022 16:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0A2C433F0;
        Sun, 18 Dec 2022 16:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379352;
        bh=pypPerhJUgi/qZ7FyWevrIR26NY3KeAIW4GacpD/Flg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIHS9xYXAUGtEExxZjQ0QvSqEZF0YJC6hwtAoGKHjjgmuFdWGrppxUJ8w/gVDnA7A
         kr1QZ7quInkbWqFMcZRFQpD/xMZONrVF3OmsSEg10soHFH8++Wh0aNTHIblm6SCy9m
         /8w5KwYNpch6JDZ0w78QDL7KGKHU8B7xJytG59nB83ir0/Px0h7SoMAW7NzEfs8dVL
         hTt86DHnvRTqEqkvQmAAksDtT3tKI96VP9IyJOs2VuU/Cmb9Vakl7ve3ZNqRih/M7P
         hFaeXRl61zWN2xedZ/Em+FY1YWb4Rua0IpVO2Q8VuIKJrJmCUJ99IyID0SvBCQq7o6
         h6/pkkgd1XjfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 10/85] openvswitch: Use kmalloc_size_roundup() to match ksize() usage
Date:   Sun, 18 Dec 2022 11:00:27 -0500
Message-Id: <20221218160142.925394-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit ab3f7828c9793a5dfa99a54dc19ae3491c38bfa3 ]

Round up allocations with kmalloc_size_roundup() so that openvswitch's
use of ksize() is always accurate and no special handling of the memory
is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: dev@openvswitch.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221018090628.never.537-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 4a07ab094a84..ead5418c126e 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2309,7 +2309,7 @@ static struct sw_flow_actions *nla_alloc_flow_actions(int size)
 
 	WARN_ON_ONCE(size > MAX_ACTIONS_BUFSIZE);
 
-	sfa = kmalloc(sizeof(*sfa) + size, GFP_KERNEL);
+	sfa = kmalloc(kmalloc_size_roundup(sizeof(*sfa) + size), GFP_KERNEL);
 	if (!sfa)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.35.1

