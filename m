Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA75E6A31FB
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjBZPOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjBZPNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:13:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6411F481;
        Sun, 26 Feb 2023 07:03:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 745EF60C16;
        Sun, 26 Feb 2023 14:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A3FC433D2;
        Sun, 26 Feb 2023 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423191;
        bh=0Bk7T2uZdKlgJ/lhz+xhUT3w1JmdN8udUEMnlO9DQeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYWjk7toasc+/VcfnERl/4bUpLJSiduPtOfFt35ZhxMJm/DJ+Ix20Ibw99DLQYC8u
         e9hTg4fRSdQ3H6vvJVPR3jklUcrzQswvQ4JfgnU/5qDrViV3krN2921/8vjFP40fen
         9vtSbkjhfkFIWGyjHN8/yQS7By6IAo80Xu0ICitvrlEB2Uz1i0TawQxyuRh4Cy7aUn
         4K7UNk/1zVtRTy3BPvxSKk+fLZgUDlqQfCYTWewnVbrZYLrjhNQFnAO/YyuNPxsMHt
         D61cyJze8VpBevyRFVGD+X8XrOvho9rw9EDQxoo1CsztBZYEN2j/mybOtMQ1nH9gjY
         Uu9xRw7S0B8Dw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/11] inet: fix fast path in __inet_hash_connect()
Date:   Sun, 26 Feb 2023 09:52:48 -0500
Message-Id: <20230226145255.829660-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145255.829660-1-sashal@kernel.org>
References: <20230226145255.829660-1-sashal@kernel.org>
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
index 590801a7487f7..c5092e2b5933e 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -616,17 +616,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
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

