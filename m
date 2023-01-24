Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F567678DD2
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjAXCBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjAXCBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:01:30 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708A99037
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:01:29 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 9856B2022A; Tue, 24 Jan 2023 10:01:24 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1674525684;
        bh=uYvpFQPZVj0rJFyVTs23uHbSWmVWuED+fLvuR/nFxUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Ivmqiq/P/juXITmGP2s/x5yPOmuFfCMzvkHDDa3ZsqRpiXv5xDb/8QRecs4REWZAg
         hQjH1tculeb1QvEvrAloNtVpCkzxtqcLKeIaZHl5vShdZQo3FjXdRe1P8P9WSn4H4H
         4eTjDCDykX9yA237o7Iwvaz7zFW/iWfAmgyNGhhpzK4+na3EmpGaJrf3+mJ8ExHP09
         ySK4uWeriWCRTTLcTUi8xBxoX1pR92MSeNJl2TgajOAiMchOD7CNOC0SYzzGo0YqrN
         KHgNOqnQRSL9vvDDmBWAks3Yx020w5bB2sfhuohbvqu/LZi3gdrP1hpjZ4VtXVh428
         a+fT9tXZY1yKQ==
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Noam Rathaus <noamr@ssd-disclosure.com>
Subject: [PATCH net 1/4] net: mctp: add an explicit reference from a mctp_sk_key to sock
Date:   Tue, 24 Jan 2023 10:01:03 +0800
Message-Id: <20230124020106.743966-2-jk@codeconstruct.com.au>
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

Currently, we correlate the mctp_sk_key lifetime to the sock lifetime
through the sock hash/unhash operations, but this is pretty tenuous, and
there are cases where we may have a temporary reference to an unhashed
sk.

This change makes the reference more explicit, by adding a hold on the
sock when it's associated with a mctp_sk_key, released on final key
unref.

Fixes: 73c618456dc5 ("mctp: locking, lifetime and validity changes for sk_keys")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/route.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index f9a80b82dc51..ce10ba7ae839 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -147,6 +147,7 @@ static struct mctp_sk_key *mctp_key_alloc(struct mctp_sock *msk,
 	key->valid = true;
 	spin_lock_init(&key->lock);
 	refcount_set(&key->refs, 1);
+	sock_hold(key->sk);
 
 	return key;
 }
@@ -165,6 +166,7 @@ void mctp_key_unref(struct mctp_sk_key *key)
 	mctp_dev_release_key(key->dev, key);
 	spin_unlock_irqrestore(&key->lock, flags);
 
+	sock_put(key->sk);
 	kfree(key);
 }
 
@@ -419,14 +421,14 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * this function.
 			 */
 			rc = mctp_key_add(key, msk);
-			if (rc) {
-				kfree(key);
-			} else {
+			if (!rc)
 				trace_mctp_key_acquire(key);
 
-				/* we don't need to release key->lock on exit */
-				mctp_key_unref(key);
-			}
+			/* we don't need to release key->lock on exit, so
+			 * clean up here and suppress the unlock via
+			 * setting to NULL
+			 */
+			mctp_key_unref(key);
 			key = NULL;
 
 		} else {
-- 
2.35.1

