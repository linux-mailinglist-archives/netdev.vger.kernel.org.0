Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634DD678DD4
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjAXCBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjAXCBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:01:31 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722B8CDD6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:01:29 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 0703C20261; Tue, 24 Jan 2023 10:01:25 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1674525685;
        bh=MmgVl6bENYLnjTNlm5rADiTwduNNn5ZNakeEDeKLv4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DE4c1lAGtYbqPtc8yZdv4kyZR+nl3YahPG1/vlMDeIij4VbIYCrBcEZwkgtOEuIfE
         VCjhlOAgLnxcgYIHTm09RhYG1HfW+dIDruhrt1OAqKW5EzP0ZQVAE9nVRPln3QiXKe
         j/5bDDE2UP8JrYCkfexGLlOyNv3/Oisrc+m13KUtG0RYHP+2nawtrqVX8CWkvsvgA3
         4VkLykpqTVRd0I/LS6p0RDAaeC+5DU92n1TCkPu4e+Hug69xsNyQgv1zx08rE8kyP5
         KHmwEWAQRqDKRf+c82ZCZyFYsz/fHh0WuSSuRAugqhOpiZVln502Zq6UWZW3cXx45C
         07AFHGxG2kACg==
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Noam Rathaus <noamr@ssd-disclosure.com>
Subject: [PATCH net 2/4] net: mctp: move expiry timer delete to unhash
Date:   Tue, 24 Jan 2023 10:01:04 +0800
Message-Id: <20230124020106.743966-3-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230124020106.743966-1-jk@codeconstruct.com.au>
References: <20230124020106.743966-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we delete the key expiry timer (in sk->close) before
unhashing the sk. This means that another thread may find the sk through
its presence on the key list, and re-queue the timer.

This change moves the timer deletion to the unhash, after we have made
the key no longer observable, so the timer cannot be re-queued.

Fixes: 7b14e15ae6f4 ("mctp: Implement a timeout for tags")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/af_mctp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index fc9e728b6333..fb6ae3110528 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -544,9 +544,6 @@ static int mctp_sk_init(struct sock *sk)
 
 static void mctp_sk_close(struct sock *sk, long timeout)
 {
-	struct mctp_sock *msk = container_of(sk, struct mctp_sock, sk);
-
-	del_timer_sync(&msk->key_expiry);
 	sk_common_release(sk);
 }
 
@@ -581,6 +578,12 @@ static void mctp_sk_unhash(struct sock *sk)
 		__mctp_key_remove(key, net, fl2, MCTP_TRACE_KEY_CLOSED);
 	}
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
+
+	/* Since there are no more tag allocations (we have removed all of the
+	 * keys), stop any pending expiry events. the timer cannot be re-queued
+	 * as the sk is no longer observable
+	 */
+	del_timer_sync(&msk->key_expiry);
 }
 
 static struct proto mctp_proto = {
-- 
2.35.1

