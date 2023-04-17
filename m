Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07936E4DB6
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjDQPx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjDQPxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:53:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C73F113
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 08:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F17C9621C0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 15:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBB5C4339C;
        Mon, 17 Apr 2023 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681746832;
        bh=xENIXCUtOXWj8PG0ELWFsHBH7G/rbpLSCxlQB3OmYIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXFaizscB4VVC0SU1cVrMq0s4wgevvsDRNqvLxYzY+5eLvFYK2Cj6u/UMN7Ufk+8o
         RyPU7WSTGVjeR5f4kbU2hQ7nlrq0UX7Qvs4AAl3maDgWSbicafXdY/CzAVzmSSqviw
         sDH6VrlT1/pSl6+XAeIErR3G1g9hFvUOw0PrqKsyRbualgrPztVQCjJDJIE73aZV7Z
         Z6gtyuS2zoZYAuC8aQtuG4D5KUU1z9lfS50p+nQp3AFBUCLrW3mwpBwD1JBs1x0Qka
         LRmbQHCV4wyZyd9ovhUqdM7BzHwPdON3v92E2ewhCeuwxMll75x4SbEQB9wacQkPnM
         85IwfK7o7/ITg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        johannes@sipsolutions.net
Subject: [PATCH net-next v2 1/5] net: skbuff: hide wifi_acked when CONFIG_WIRELESS not set
Date:   Mon, 17 Apr 2023 08:53:46 -0700
Message-Id: <20230417155350.337873-2-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417155350.337873-1-kuba@kernel.org>
References: <20230417155350.337873-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Datacenter kernel builds will very likely not include WIRELESS,
so let them shave 2 bits off the skb by hiding the wifi fields.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: johannes@sipsolutions.net
---
 include/linux/skbuff.h | 11 +++++++++++
 include/net/sock.h     |  2 +-
 net/core/skbuff.c      |  2 ++
 net/socket.c           |  2 ++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a823ec3aa326..513f03b23a73 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -953,8 +953,10 @@ struct sk_buff {
 
 	__u8			l4_hash:1;
 	__u8			sw_hash:1;
+#ifdef CONFIG_WIRELESS
 	__u8			wifi_acked_valid:1;
 	__u8			wifi_acked:1;
+#endif
 	__u8			no_fcs:1;
 	/* Indicates the inner headers are valid in the skbuff. */
 	__u8			encapsulation:1;
@@ -1187,6 +1189,15 @@ static inline unsigned int skb_napi_id(const struct sk_buff *skb)
 #endif
 }
 
+static inline bool skb_wifi_acked_valid(const struct sk_buff *skb)
+{
+#ifdef CONFIG_WIRELESS
+	return skb->wifi_acked_valid;
+#else
+	return 0;
+#endif
+}
+
 /**
  * skb_unref - decrement the skb's reference count
  * @skb: buffer
diff --git a/include/net/sock.h b/include/net/sock.h
index 5edf0038867c..8b7ed7167243 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2697,7 +2697,7 @@ sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *skb)
 	else
 		sock_write_timestamp(sk, kt);
 
-	if (sock_flag(sk, SOCK_WIFI_STATUS) && skb->wifi_acked_valid)
+	if (sock_flag(sk, SOCK_WIFI_STATUS) && skb_wifi_acked_valid(skb))
 		__sock_recv_wifi_status(msg, sk, skb);
 }
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ef81452759be..768f9d04911f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5189,6 +5189,7 @@ void skb_tstamp_tx(struct sk_buff *orig_skb,
 }
 EXPORT_SYMBOL_GPL(skb_tstamp_tx);
 
+#ifdef CONFIG_WIRELESS
 void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
 {
 	struct sock *sk = skb->sk;
@@ -5214,6 +5215,7 @@ void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
 		kfree_skb(skb);
 }
 EXPORT_SYMBOL_GPL(skb_complete_wifi_ack);
+#endif /* CONFIG_WIRELESS */
 
 /**
  * skb_partial_csum_set - set up and verify partial csum values for packet
diff --git a/net/socket.c b/net/socket.c
index 73e493da4589..a7b4b37d86df 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -957,6 +957,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(__sock_recv_timestamp);
 
+#ifdef CONFIG_WIRELESS
 void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
 	struct sk_buff *skb)
 {
@@ -972,6 +973,7 @@ void __sock_recv_wifi_status(struct msghdr *msg, struct sock *sk,
 	put_cmsg(msg, SOL_SOCKET, SCM_WIFI_STATUS, sizeof(ack), &ack);
 }
 EXPORT_SYMBOL_GPL(__sock_recv_wifi_status);
+#endif
 
 static inline void sock_recv_drops(struct msghdr *msg, struct sock *sk,
 				   struct sk_buff *skb)
-- 
2.39.2

