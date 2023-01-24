Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82E678DD3
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbjAXCBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjAXCBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:01:31 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725BB10AA0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:01:29 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id BFBA521688; Tue, 24 Jan 2023 10:01:25 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1674525685;
        bh=DCmSZpGbUwHzMdBsEUb1P7R+nEn7Pf7UaTqxtDsphAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Tf7tU13tcgWNKLjjStI+PiFiAfGd+mI/1oHXDyw6ruQlinuCZA7nP3/5qmAAqpv+k
         LMOHdx3w3Sm+9vTFwWkNzGf7vKeLVOtgDrE10lrzaEcWNYgMOBlIFZE29eBDkPAguo
         J2K8d1AL4Fu/q8fpIji4M6tG6PQeyR11imhQ88TKU/gt1U0ZCvHdMrxsRMFB3VuNpd
         sM5nVkbKmwhWczFiZRSBnnm74R8Lyzsecd4KIZhxo15iusB0qdqBtS9QG7KeF/g2vG
         fKBL6pMCZOl7v5daf76FALrTqfBUQ/KOA4+2NxKtvliu1eTQgUoWMKCo4HTwuHJ/hu
         IP/n4Oss4042A==
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Noam Rathaus <noamr@ssd-disclosure.com>
Subject: [PATCH net 4/4] net: mctp: mark socks as dead on unhash, prevent re-add
Date:   Tue, 24 Jan 2023 10:01:06 +0800
Message-Id: <20230124020106.743966-5-jk@codeconstruct.com.au>
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

Once a socket has been unhashed, we want to prevent it from being
re-used in a sk_key entry as part of a routing operation.

This change marks the sk as SOCK_DEAD on unhash, which prevents addition
into the net's key list.

We need to do this during the key add path, rather than key lookup, as
we release the net keys_lock between those operations.

Fixes: 4a992bbd3650 ("mctp: Implement message fragmentation & reassembly")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/af_mctp.c | 1 +
 net/mctp/route.c   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index fb6ae3110528..45bbe3e54cc2 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -577,6 +577,7 @@ static void mctp_sk_unhash(struct sock *sk)
 		spin_lock_irqsave(&key->lock, fl2);
 		__mctp_key_remove(key, net, fl2, MCTP_TRACE_KEY_CLOSED);
 	}
+	sock_set_flag(sk, SOCK_DEAD);
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 
 	/* Since there are no more tag allocations (we have removed all of the
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 06c0de21984d..f51a05ec7162 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -179,6 +179,11 @@ static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
 
 	spin_lock_irqsave(&net->mctp.keys_lock, flags);
 
+	if (sock_flag(&msk->sk, SOCK_DEAD)) {
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+
 	hlist_for_each_entry(tmp, &net->mctp.keys, hlist) {
 		if (mctp_key_match(tmp, key->local_addr, key->peer_addr,
 				   key->tag)) {
@@ -200,6 +205,7 @@ static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
 		hlist_add_head(&key->sklist, &msk->keys);
 	}
 
+out_unlock:
 	spin_unlock_irqrestore(&net->mctp.keys_lock, flags);
 
 	return rc;
-- 
2.35.1

