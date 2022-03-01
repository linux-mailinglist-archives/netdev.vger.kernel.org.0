Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE804C961E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 21:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbiCAUTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 15:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238015AbiCAUS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 15:18:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3882D3FBDB;
        Tue,  1 Mar 2022 12:18:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFA3D61763;
        Tue,  1 Mar 2022 20:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A4AC340F2;
        Tue,  1 Mar 2022 20:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165886;
        bh=/UQX7PDAgZm+2XBb1KJevOgdGQXGHiW7vLKQqRymvpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBsaJWC7vcEPtAGUvHswaRG6nrg4U0MET5mhVFtRjYXSv3XGiMs3xtw76MnriyZMI
         LBqUtAlO/Zh4jIZA+9M/QELkYetZ90Wtd5haQoGKu86OlfqH/wyN4gK9maJaOwwn1b
         BpRzn3k4GVrllBk5r/5CV7S1neW2RZVA/Um2zyZNfCJ61z2imznqkwHoePwvdOSCpC
         k2OZKQFlujrx2msAKaNWhjDpZ6GC9jb5dZTMss7mLCTXtl0PVSDyvmxrhYVdYn01aX
         HRXYirMGJNC80Fx9gRviSwDzd3J6/PikQFXadoYpDBrMRegk3gEgEnEkHb5d+aYJAF
         kpeeDihyz3XaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Niels Dossche <niels.dossche@ugent.be>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 19/23] ipv6: prevent a possible race condition with lifetimes
Date:   Tue,  1 Mar 2022 15:16:18 -0500
Message-Id: <20220301201629.18547-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
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
index c6e1989ab2ed9..01cbfb4321eec 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4996,6 +4996,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
 		goto error;
 
+	spin_lock_bh(&ifa->lock);
 	if (!((ifa->flags&IFA_F_PERMANENT) &&
 	      (ifa->prefered_lft == INFINITY_LIFE_TIME))) {
 		preferred = ifa->prefered_lft;
@@ -5017,6 +5018,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 		preferred = INFINITY_LIFE_TIME;
 		valid = INFINITY_LIFE_TIME;
 	}
+	spin_unlock_bh(&ifa->lock);
 
 	if (!ipv6_addr_any(&ifa->peer_addr)) {
 		if (nla_put_in6_addr(skb, IFA_LOCAL, &ifa->addr) < 0 ||
-- 
2.34.1

