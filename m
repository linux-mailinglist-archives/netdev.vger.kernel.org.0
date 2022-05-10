Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316ED521F79
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346381AbiEJPtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346320AbiEJPsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DF427D01B;
        Tue, 10 May 2022 08:44:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EF4D614EA;
        Tue, 10 May 2022 15:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C87C385A6;
        Tue, 10 May 2022 15:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197462;
        bh=I5cs4rPMg6JZJCSn7sJ6TZVwO84ivOWm5OxLrZprd7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkppcW2bNUWVVuqQ1u5mNlwHdpJZrgBDRVi+SxUWjmWCQ4+aXGe048bSFIBrAXgmL
         oxfLEpZG8wCYLWORK/zBH6wlmuDMVXGi9Cy8spFQSzFNOFwbdDAWn9kpSK1F53iVeN
         gxif3qqRD1dkJD7ri1lifKVUWwBaUWpB0txSR37ky7uwJI/Ii6g3EJzgvAt5aTIG9g
         FEMso/fJjITnOFLe5+PVE6Y52d+iZ7AWCFRmAkTTrXdeAXgpEVqQgfT9N47JFx/NCZ
         Dw8G0mwSl+/P38s/YIDnhXlufTE7w7s/C+iLfaHd9+DKYpAZGhdYbEkvrdkpkVFMS+
         rnsnmt7yo/sFQ==
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
Subject: [PATCH AUTOSEL 5.17 18/21] tcp: increase source port perturb table to 2^16
Date:   Tue, 10 May 2022 11:43:37 -0400
Message-Id: <20220510154340.153400-18-sashal@kernel.org>
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

[ Upstream commit 4c2c8f03a5ab7cb04ec64724d7d176d00bcc91e5 ]

Moshe Kol, Amit Klein, and Yossi Gilad reported being able to accurately
identify a client by forcing it to emit only 40 times more connections
than there are entries in the table_perturb[] table. The previous two
improvements consisting in resalting the secret every 10s and adding
randomness to each port selection only slightly improved the situation,
and the current value of 2^8 was too small as it's not very difficult
to make a client emit 10k connections in less than 10 seconds.

Thus we're increasing the perturb table from 2^8 to 2^16 so that the
same precision now requires 2.6M connections, which is more difficult in
this time frame and harder to hide as a background activity. The impact
is that the table now uses 256 kB instead of 1 kB, which could mostly
affect devices making frequent outgoing connections. However such
components usually target a small set of destinations (load balancers,
database clients, perf assessment tools), and in practice only a few
entries will be visited, like before.

A live test at 1 million connections per second showed no performance
difference from the previous value.

Reported-by: Moshe Kol <moshe.kol@mail.huji.ac.il>
Reported-by: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Reported-by: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 48ca07853068..cc5f66328b47 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -726,11 +726,12 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
  * property might be used by clever attacker.
- * RFC claims using TABLE_LENGTH=10 buckets gives an improvement,
- * we use 256 instead to really give more isolation and
- * privacy, this only consumes 1 KB of kernel memory.
+ * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
+ * attacks were since demonstrated, thus we use 65536 instead to really
+ * give more isolation and privacy, at the expense of 256kB of kernel
+ * memory.
  */
-#define INET_TABLE_PERTURB_SHIFT 8
+#define INET_TABLE_PERTURB_SHIFT 16
 #define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
 static u32 *table_perturb;
 
-- 
2.35.1

