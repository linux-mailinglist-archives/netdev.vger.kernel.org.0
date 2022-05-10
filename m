Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AE2521F6D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346295AbiEJPsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346306AbiEJPsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB8A2802CB;
        Tue, 10 May 2022 08:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81418614A6;
        Tue, 10 May 2022 15:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B669C385CC;
        Tue, 10 May 2022 15:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197458;
        bh=lhW8NJEDdIn54Z0I2VF12YbCHzDA9ZNvrF4WYLJPgbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyC5tfYaBLuViTOr2H66clPsg7QRWQuFgpg75MQFmfAD1/aLc423HW1wFVDPkXzky
         WvPn94ca/wrHBrsQt945f1VmZNU7jEeJpnzQq5aqr3RUSxAU75sgLA9PfekBVkhQj1
         PJAoaC8r2hfPrxsy3Ach39CKGuScsxE5CVUQtNRItB36JqaEJbVZixIIm55HTVO74N
         Y9IcbOsK9Reo8WuY+rKjmAfpWZL0MzfCvc6Rc4QibAHwD99n+Z/yGXTe7wlsLPdtO6
         YO+vsYFP6pt2n00/I+l0vcMKBP+2kMuT9flQ5lmwiy/TKC5vDikhCodNUm0cX1Vi4P
         j+o3AzVDXUsWQ==
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
Subject: [PATCH AUTOSEL 5.17 16/21] tcp: add small random increments to the source port
Date:   Tue, 10 May 2022 11:43:35 -0400
Message-Id: <20220510154340.153400-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154340.153400-1-sashal@kernel.org>
References: <20220510154340.153400-1-sashal@kernel.org>
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
index 29c701cd8312..63bb4902f018 100644
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

