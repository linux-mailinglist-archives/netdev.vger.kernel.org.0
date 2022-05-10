Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7440F521FC3
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346512AbiEJPwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346468AbiEJPue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:50:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5259A289BCC;
        Tue, 10 May 2022 08:45:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81E73B81DF9;
        Tue, 10 May 2022 15:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0334C385CC;
        Tue, 10 May 2022 15:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197498;
        bh=HDvTOfzkdRxHd6HWC3WkqsEF8BETWp49rWnYi3S1Hlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djCQe0vq0nYy/T1A3/BQlsZBLRaC4osWUyRNmbEz1HnnryE6fHkPnqv3d8wT2UWeN
         ojIShLiQBrp480AKGkbZZ8yALH9PdKUw/jELvKeDNXEuij2/UO7uoE5c2H1BUPJuZF
         nTpB26JgYqp9RG2q1Rdaix6xLIbzPP7PpyTiNulUzkB4dZXXWiCSW5GgiLkUEPiJok
         Jm1tRPD/lBJqW1UsC5/9Woonc1kSPDYtgP6GJZcJK9Dx7FFLR4lx4+YL4j2hbRRvgk
         YT+OMZbtcL0HxGJMS6hjmDE5Weeo8szXmFjFHkHYfkfdBwDqsUF8+7+AaRdyQgt7l7
         3Rqefs3+jrNdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 13/19] tcp: use different parts of the port_offset for index and offset
Date:   Tue, 10 May 2022 11:44:23 -0400
Message-Id: <20220510154429.153677-13-sashal@kernel.org>
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

[ Upstream commit 9e9b70ae923baf2b5e8a0ea4fd0c8451801ac526 ]

Amit Klein suggests that we use different parts of port_offset for the
table's index and the port offset so that there is no direct relation
between them.

Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 606a4220ebb9..81a33af8393d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -777,7 +777,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	net_get_random_once(table_perturb, sizeof(table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
-	offset = READ_ONCE(table_perturb[index]) + port_offset;
+	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
 	offset %= remaining;
 
 	/* In first pass we try ports of @low parity.
-- 
2.35.1

