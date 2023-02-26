Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5748E6A3287
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjBZPxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBZPxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:53:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD60F77D;
        Sun, 26 Feb 2023 07:53:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11B48B80BA9;
        Sun, 26 Feb 2023 14:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3110C433D2;
        Sun, 26 Feb 2023 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422728;
        bh=ZHQWuqdyWe3kl4WNzkTxVi/Vt/O3yh/zQaaiKBgwVaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYJKtShSG+5kapAOvqYdNlKP/SmEsCiCf1cRtl6zwEAbU/Tpj2PV6fQYrcBAuaVjO
         +fSi71y0PJJ85fLnggiIJ1fHgBc6RYCX4eeZlyXywikVtxp7OWBv+d7wMO+YexaQNI
         WKhROkyJ7AoJsmZ/hG1nNb8EdOSnmuEtU53MwGPFXk43fDeftVfXWv4n4zuhjjQaPW
         I2/WLrw+mciKZ200rdZ0qstGasXS/4K6hiYksj0mlywAEnx7qjJ1MK1fM4meFOo7sA
         QFtjwC23AlYcqVqmnBTD6ZAKQxrxHTd5l37y8fzeB0VyvV3YzhpRggJN0ZoNo4K/vK
         hoT3RNc3OJ17Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 17/53] inet: fix fast path in __inet_hash_connect()
Date:   Sun, 26 Feb 2023 09:44:09 -0500
Message-Id: <20230226144446.824580-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 21cbd90a6fab7123905386985e3e4a80236b8714 ]

__inet_hash_connect() has a fast path taken if sk_head(&tb->owners) is
equal to the sk parameter.
sk_head() returns the hlist_entry() with respect to the sk_node field.
However entries in the tb->owners list are inserted with respect to the
sk_bind_node field with sk_add_bind_node().
Thus the check would never pass and the fast path never execute.

This fast path has never been executed or tested as this bug seems
to be present since commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), thus
remove it to reduce code complexity.

Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index f58d73888638b..7a13dd7f546b6 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -1008,17 +1008,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	u32 index;
 
 	if (port) {
-		head = &hinfo->bhash[inet_bhashfn(net, port,
-						  hinfo->bhash_size)];
-		tb = inet_csk(sk)->icsk_bind_hash;
-		spin_lock_bh(&head->lock);
-		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
-			inet_ehash_nolisten(sk, NULL, NULL);
-			spin_unlock_bh(&head->lock);
-			return 0;
-		}
-		spin_unlock(&head->lock);
-		/* No definite answer... Walk to established hash table */
+		local_bh_disable();
 		ret = check_established(death_row, sk, port, NULL);
 		local_bh_enable();
 		return ret;
-- 
2.39.0

