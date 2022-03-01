Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EDC4C969D
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 21:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbiCAUZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 15:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbiCAUXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 15:23:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46408A6E8;
        Tue,  1 Mar 2022 12:21:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A0BCDCE1EA0;
        Tue,  1 Mar 2022 20:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BF3C340EE;
        Tue,  1 Mar 2022 20:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646166030;
        bh=lv1SkZb9g7oL1FouA4XlJnK02eswM+jLeseDhprZDB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQppqmmot1u8JWa/MO/K7gGu3pqBrTJCmiOq4H9LjvzbYTLoFFJkqZSnO7bpJi4bG
         wVkQKvgyIRqYYHnsmCTxdg777ne9HyBIUl7LxNx2XDOsKZHrHvsa0Hgs4jfORyAHF3
         nZasqnM16Ppnh9Ga50BOdJ7s0ooB1e3yluAbs8FkEKChfj4lradWtQsFyiDGbMdI2l
         s5tblRmmsmbVr0ukBN1ulebbPay2zBWbwGtsr2bhahOTs6herxWsfz7PaychK6jo1w
         x4w0ffSZSRXqhdBWCrsyUgK16tLCtVGEKRyHpNr6SwZmFrx5uUxzl8duBAOSgFAqXd
         n9Kb5gQbDMx6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Niels Dossche <niels.dossche@ugent.be>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/11] ipv6: prevent a possible race condition with lifetimes
Date:   Tue,  1 Mar 2022 15:19:41 -0500
Message-Id: <20220301201951.19066-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201951.19066-1-sashal@kernel.org>
References: <20220301201951.19066-1-sashal@kernel.org>
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
index d1f29a3eb70be..60d070b254846 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4924,6 +4924,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
 		goto error;
 
+	spin_lock_bh(&ifa->lock);
 	if (!((ifa->flags&IFA_F_PERMANENT) &&
 	      (ifa->prefered_lft == INFINITY_LIFE_TIME))) {
 		preferred = ifa->prefered_lft;
@@ -4945,6 +4946,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 		preferred = INFINITY_LIFE_TIME;
 		valid = INFINITY_LIFE_TIME;
 	}
+	spin_unlock_bh(&ifa->lock);
 
 	if (!ipv6_addr_any(&ifa->peer_addr)) {
 		if (nla_put_in6_addr(skb, IFA_LOCAL, &ifa->addr) < 0 ||
-- 
2.34.1

