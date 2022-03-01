Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E920B4C966E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 21:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbiCAUYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 15:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238273AbiCAUW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 15:22:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DCD79C52;
        Tue,  1 Mar 2022 12:19:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE2256175F;
        Tue,  1 Mar 2022 20:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED30C340F2;
        Tue,  1 Mar 2022 20:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165967;
        bh=oeHYLosH0rGD25dO4lclQ4e9vwxl+hCvFdwkzpcdhck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5dYThiMzXLqyUluTqxFfNoGxM/U4GayDo6bXfJsau1FF1ovle9fX2F49fnIb9DBC
         MQ2b4kkZQH8/Gsu+/6zSwkr4+JXME3gtsS4cOkKP2BevmiqeU8jo8cgVnB4ZBoOlkD
         P+63gjovXNWG1v25TEn1ZOo8Gm3rSpGzI9fVKInMv5JNjll1lou1DPC/tTeXyzDfhY
         ZXflV58Y17xGtytHIXjXGz67OlQUI+I5Ol6F2Rf2oPqW2gWVs+MPNU1dDRbwUTDrfM
         FvqyrGMAxxcScdLeAdR5bK0AB366sR8NNyQXTfWsfxN3BgFBeEqhHALV0Z+DzNh6sN
         Q9fBRwEvCx18A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Niels Dossche <niels.dossche@ugent.be>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/14] ipv6: prevent a possible race condition with lifetimes
Date:   Tue,  1 Mar 2022 15:18:23 -0500
Message-Id: <20220301201833.18841-11-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201833.18841-1-sashal@kernel.org>
References: <20220301201833.18841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 6c0d8833a605e195ae219b5042577ce52bf71fff ]

valid_lft, prefered_lft and tstamp are always accessed under the lock
"lock" in other places. Reading these without taking the lock may result
in inconsistencies regarding the calculation of the valid and preferred
variables since decisions are taken on these fields for those variables.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
Link: https://lore.kernel.org/r/20220223131954.6570-1-niels.dossche@ugent.be
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4dde49e628fab..616556f50f2be 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4975,6 +4975,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
 		goto error;
 
+	spin_lock_bh(&ifa->lock);
 	if (!((ifa->flags&IFA_F_PERMANENT) &&
 	      (ifa->prefered_lft == INFINITY_LIFE_TIME))) {
 		preferred = ifa->prefered_lft;
@@ -4996,6 +4997,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 		preferred = INFINITY_LIFE_TIME;
 		valid = INFINITY_LIFE_TIME;
 	}
+	spin_unlock_bh(&ifa->lock);
 
 	if (!ipv6_addr_any(&ifa->peer_addr)) {
 		if (nla_put_in6_addr(skb, IFA_LOCAL, &ifa->addr) < 0 ||
-- 
2.34.1

