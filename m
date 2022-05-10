Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4905521FD8
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346592AbiEJPwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346410AbiEJPu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:50:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1554728AB8A;
        Tue, 10 May 2022 08:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA671B81DF9;
        Tue, 10 May 2022 15:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA23C385CF;
        Tue, 10 May 2022 15:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197503;
        bh=LRaJJ6rm2rTcuj00VtV0cAzxzyTuSvN9jZkm2Xc9noo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLsyhK38YtVPzh+H7TMznXXC9MIzCSDzk33+OsM6jgUKsRpHURACbUy+N/XONA8cg
         j6uhLxHY9EtJPrqUsvtThVhlX2/a+Ql4VElbVNB72fO/36wJxhFrjkNG+AGVZIlgOp
         MFE9dH0+Qxq7hfEa3PHLFJc1YR08qMe6qOJCGfrV0DFRN0tp+AQtVWBjo+Rvs0vTBJ
         2imuovoImqauoJM/ei5Im/IYoRd5uhqRY/LTh19g93vYHHg8yPQGva72kui1ysbaRv
         CDu5rrRxRw4/cq6n3/3hS+UETM+mPrlKH8LYCZY0H+1GPgXmqk0ByffX5i/cDGJhPM
         YFLhTVHOh67og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/19] tcp: add small random increments to the source port
Date:   Tue, 10 May 2022 11:44:25 -0400
Message-Id: <20220510154429.153677-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154429.153677-1-sashal@kernel.org>
References: <20220510154429.153677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit ca7af0402550f9a0b3316d5f1c30904e42ed257d ]

Here we're randomly adding between 0 and 7 random increments to the
selected source port in order to add some noise in the source port
selection that will make the next port less predictable.

With the default port range of 32768-60999 this means a worst case
reuse scenario of 14116/8=1764 connections between two consecutive
uses of the same port, with an average of 14116/4.5=3137. This code
was stressed at more than 800000 connections per second to a fixed
target with all connections closed by the client using RSTs (worst
condition) and only 2 connections failed among 13 billion, despite
the hash being reseeded every 10 seconds, indicating a perfectly
safe situation.

Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 81a33af8393d..573a7e66ebc8 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -833,11 +833,12 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
-	/* If our first attempt found a candidate, skip next candidate
-	 * in 1/16 of cases to add some noise.
+	/* Here we want to add a little bit of randomness to the next source
+	 * port that will be chosen. We use a max() with a random here so that
+	 * on low contention the randomness is maximal and on high contention
+	 * it may be inexistent.
 	 */
-	if (!i && !(prandom_u32() % 16))
-		i = 2;
+	i = max_t(int, i, (prandom_u32() & 7) * 2);
 	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
-- 
2.35.1

