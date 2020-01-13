Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC2139D95
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgAMXnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:43:02 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55677 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbgAMXm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:42:58 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d929d7a2;
        Mon, 13 Jan 2020 22:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=0gEIfT81wd3jBIyRff7NNLZ/X
        d4=; b=nBMEj4EK0pfMGzn0NQVsnr1/oct2+x18C2VKlFh1PKEu4vH3quUJO2Jp9
        nzdLxvPZ6aIY6yubJIMPl8GVT3YFJMo2e4Zf0ERdw29iilNSaP+xQQ/x6sUfwH6g
        PEQv0/mBNZpodW7SCwOVnBU5EuGuYEXhFYOediA4DUI9/OoCgpojWDQtT5Div/Or
        9WlwseKbTwDBFEQRfkIJCTx0QQF3Up0Qz4WeiOtzoKMHECNtlOdNBFGvM8fZxByO
        BFVE8K2mxZ7Ezor4kZrn4VG0K78L1r3RBxvZ5dW/OiuI2B9xzm0kZZCwAwetlWSi
        kv66TKBYY46QC7XcovE5ZWrpe5zxQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 199c41b3 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 13 Jan 2020 22:42:57 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 6/8] net: ipv4: use skb_list_walk_safe helper for gso segments
Date:   Mon, 13 Jan 2020 18:42:31 -0500
Message-Id: <20200113234233.33886-7-Jason@zx2c4.com>
In-Reply-To: <20200113234233.33886-1-Jason@zx2c4.com>
References: <20200113234233.33886-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a straight-forward conversion case for the new function, keeping
the flow of the existing code as intact as possible.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv4/ip_output.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 14db1e0b8a6e..d84819893db9 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -240,8 +240,8 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 static int ip_finish_output_gso(struct net *net, struct sock *sk,
 				struct sk_buff *skb, unsigned int mtu)
 {
+	struct sk_buff *segs, *nskb;
 	netdev_features_t features;
-	struct sk_buff *segs;
 	int ret = 0;
 
 	/* common case: seglen is <= mtu
@@ -272,8 +272,7 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 
 	consume_skb(skb);
 
-	do {
-		struct sk_buff *nskb = segs->next;
+	skb_list_walk_safe(segs, segs, nskb) {
 		int err;
 
 		skb_mark_not_on_list(segs);
@@ -281,8 +280,7 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 
 		if (err && ret == 0)
 			ret = err;
-		segs = nskb;
-	} while (segs);
+	}
 
 	return ret;
 }
-- 
2.24.1

