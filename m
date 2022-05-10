Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F036F521F63
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344106AbiEJPsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346278AbiEJPsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:48:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBFDB4;
        Tue, 10 May 2022 08:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 527ACCE1F3A;
        Tue, 10 May 2022 15:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD77C385CC;
        Tue, 10 May 2022 15:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197453;
        bh=U2F4MNu14K9ar6PkUlBK9hCvtcnVPeCtfUn2rI1S2SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTthjueGUx1BW3Z/OefKQ6dj7rEpLicsqwJS2Ai7lngPTNpHZyc7l6/pwix5CL7/n
         dDefVdEW+BSjt9+e+yeVC619FnLqLRBA1LAuXkguxcXiu39yh48H/dYP9wqVRRA/Fu
         J1KmQLC/XKws+J8RpHpqvSjdG/LYA62CHwg2l55gDWY4raV/E7cZgq2FTEPNtxOFM4
         bgPPZMX8wOmCySnUG06lpa49FLKV/aZEMbDijt+Fk7YtY4vFfYK+VlZ8Wd5kkEosxq
         GR0wUDxmU26GF3c5MeGZhJFPpzHPHlAWYCbSW4zyTdXPROm6t63eoV7ZbATZhmhKwm
         LrisrOf9kkW9A==
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
Subject: [PATCH AUTOSEL 5.17 14/21] tcp: use different parts of the port_offset for index and offset
Date:   Tue, 10 May 2022 11:43:33 -0400
Message-Id: <20220510154340.153400-14-sashal@kernel.org>
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
index 9d24d9319f3d..29c701cd8312 100644
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

