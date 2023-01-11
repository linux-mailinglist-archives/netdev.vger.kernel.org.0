Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784DE665E62
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbjAKOvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjAKOvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:51:21 -0500
Received: from wizmail.org (wizmail.org [85.158.153.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C271306
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:51:20 -0800 (PST)
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=wizmail.org; s=e202001; h=Content-Transfer-Encoding:MIME-Version:References
        :In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=+Lx7HYJi478KJgtP+7zZrGVWXuZIlQ0gr3NAaTCXY0k=; b=GSknYEHxOpwvV0d
        VMoTUtRkzw149hQ6X2GCGy+nj7Am72affJ/SygOzfnT7HDn8cO7WH9LmpQCiL8sQ+M+vtCg==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizmail.org
        ; s=r202001; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=+Lx7HYJi478KJgtP+7zZrGVWXuZIlQ0gr3NAaTCXY0k=; b=BTfKvT8J7R+Jclc
        xoTG7xk4nvD3EuOyfAKD5czZeRFuKv6wztz7WOet/2aNmgi4Z+2Zj/7SAabRQauyU7878cEJH1Ao+
        2Viqh7CgT8ePPXeIzfVxP/maDitgLbinGkYeTijbLT7Rh+4aBehL3BY88DRftHrpvdUFYBxryGah6
        asta6juClEjBRLJPYjmccOBiqakpdX9Ec0bZ9tn8h/SL8J0t8DMHgDZI2WOANKFmAYpS8uVKT5fxn
        Zc8mZsZ20ZxYCsXzxxUD3/f8NMPJQaApTSvcQZ9nuIhrFs9PqNnqEdvcRyMlF3bDipCex7zCmXYO6
        oERP2WzD7wg7rr6BuqA==;
Authentication-Results: wizmail.org;
        local=pass (non-smtp, wizmail.org) u=root
Received: from root
        by [] (Exim 4.96.108)
        with local
        id 1pFcBW-004jF9-0T
        (return-path <root@w81.gulag.org.uk>);
        Wed, 11 Jan 2023 14:34:34 +0000
From:   jgh@redhat.com
To:     netdev@vger.kernel.org
Cc:     Jeremy Harris <jgh@redhat.com>
Subject: [RFC PATCH 1/7] net: NIC driver Rx ring ECN: skbuff and tcp support
Date:   Wed, 11 Jan 2023 14:34:21 +0000
Message-Id: <20230111143427.1127174-2-jgh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230111143427.1127174-1-jgh@redhat.com>
References: <20230111143427.1127174-1-jgh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Harris <jgh@redhat.com>

This is the infrastructure and the primary information-consumer
for the facility.

Signed-off-by: Jeremy Harris <jgh@redhat.com>
---
 include/linux/skbuff.h | 2 ++
 net/core/skbuff.c      | 1 +
 net/ipv4/tcp_input.c   | 8 +++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a10..8bdf0049e1a3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -804,6 +804,7 @@ typedef unsigned char *sk_buff_data_t;
  *		the packet minus one that have been verified as
  *		CHECKSUM_UNNECESSARY (max 3)
  *	@scm_io_uring: SKB holds io_uring registered files
+ *	@congestion_experienced: data-source or channel for SKB has congestion
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@slow_gro: state present at GRO time, slower prepare step required
@@ -983,6 +984,7 @@ struct sk_buff {
 	__u8			slow_gro:1;
 	__u8			csum_not_inet:1;
 	__u8			scm_io_uring:1;
+	__u8			congestion_experienced:1;
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3a10387f9434..37940dd3dbe9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5548,6 +5548,7 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	to->truesize += delta;
 	to->len += len;
 	to->data_len += len;
+	to->congestion_experienced |= from->congestion_experienced;
 
 	*delta_truesize = delta;
 	return true;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cc072d2cfcd8..217374eefe41 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -338,8 +338,14 @@ static void tcp_ecn_withdraw_cwr(struct tcp_sock *tp)
 static void __tcp_ecn_check_ce(struct sock *sk, const struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
+	__u8 ecn;
 
-	switch (TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK) {
+	if (unlikely(skb->congestion_experienced))
+		ecn = INET_ECN_CE;
+	else
+		ecn = TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK;
+
+	switch (ecn) {
 	case INET_ECN_NOT_ECT:
 		/* Funny extension: if ECT is not set on a segment,
 		 * and we already seen ECT on a previous segment,
-- 
2.39.0

