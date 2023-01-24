Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDB8678DD5
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjAXCBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjAXCBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:01:33 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726CC11161
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:01:29 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 68D5C2036E; Tue, 24 Jan 2023 10:01:25 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1674525685;
        bh=AyLhRsZxXzbiDViZIVo9hcCIXcOxqV0TYtP/V49oCPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=CtN7QNx86XJNkQOLVTbALOUMx8U6GSpQY4ohi/1ApUmiMkPAopeUDQTREgGbgsAsM
         5ID383t49TEyNYcvh1X4QWJ2sNImWyuQsW6rr8TA+q6oC4Abd4nWPwE6XA0Ysi7qDb
         fRMFFJpNNY0Pplf8jrGtpn/lfn8eLcW+ylh+R4wfXaJxecJnyjEVHxAoNqVz7TwqRE
         PfESLSD+1jMHX7jsCzcIkRZ9THJSU3SYUBfJNNNURjy9qYOh9cy7WLnTnNr2kQr4Aj
         ZsyWUlx5taIHW9QbIP9inUBSTG2tSsjQ3TxbQU1FdF3VsYx43R+8WUdgoUgporbmLx
         oJxuhlo7ntBNw==
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Noam Rathaus <noamr@ssd-disclosure.com>
Subject: [PATCH net 3/4] net: mctp: hold key reference when looking up a general key
Date:   Tue, 24 Jan 2023 10:01:05 +0800
Message-Id: <20230124020106.743966-4-jk@codeconstruct.com.au>
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

From: Paolo Abeni <pabeni@redhat.com>

Currently, we have a race where we look up a sock through a "general"
(ie, not directly associated with the (src,dest,tag) tuple) key, then
drop the key reference while still holding the key's sock.

This change expands the key reference until we've finished using the
sock, and hence the sock reference too.

Commit message changes from Jeremy Kerr <jk@codeconstruct.com.au>.

Reported-by: Noam Rathaus <noamr@ssd-disclosure.com>
Fixes: 73c618456dc5 ("mctp: locking, lifetime and validity changes for sk_keys")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/route.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index ce10ba7ae839..06c0de21984d 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -317,8 +317,8 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 
 static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 {
+	struct mctp_sk_key *key, *any_key = NULL;
 	struct net *net = dev_net(skb->dev);
-	struct mctp_sk_key *key;
 	struct mctp_sock *msk;
 	struct mctp_hdr *mh;
 	unsigned long f;
@@ -363,13 +363,11 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * key for reassembly - we'll create a more specific
 			 * one for future packets if required (ie, !EOM).
 			 */
-			key = mctp_lookup_key(net, skb, MCTP_ADDR_ANY, &f);
-			if (key) {
-				msk = container_of(key->sk,
+			any_key = mctp_lookup_key(net, skb, MCTP_ADDR_ANY, &f);
+			if (any_key) {
+				msk = container_of(any_key->sk,
 						   struct mctp_sock, sk);
-				spin_unlock_irqrestore(&key->lock, f);
-				mctp_key_unref(key);
-				key = NULL;
+				spin_unlock_irqrestore(&any_key->lock, f);
 			}
 		}
 
@@ -475,6 +473,8 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 		spin_unlock_irqrestore(&key->lock, f);
 		mctp_key_unref(key);
 	}
+	if (any_key)
+		mctp_key_unref(any_key);
 out:
 	if (rc)
 		kfree_skb(skb);
-- 
2.35.1

