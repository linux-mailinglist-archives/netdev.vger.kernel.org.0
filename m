Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254C349C462
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbiAZHfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237873AbiAZHfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:37 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DC4C061747
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:37 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id h23so20407457pgk.11
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qX3uRb8j7CO3Ko5mdKX24e1eVWMtEEp5iJJng/869xI=;
        b=MIaO2raHMez5M66IBYBhkd0rJ2T2SE0g8AHQebJPKSwsH9PFHx71qYnL6Z5jMDGmLp
         yPhYkQhMY+2IBRu25FvcJ7d3ax9Re4pucwfjTCauFtachySyaFP3yy0gX7XhZJKEq3tr
         WSkLmBJGBBZR+N906TLLVej4Eqpw3Sy9EfLynQqbGpKboNJF6TxH1ZK6+7rRUyrTAy5R
         SKzAnCXOdPD4aJCrzURiAckLeeNaw/6Lgxz7cGWk5+eQD1JJDEpnyo4x9rPNcGhUgpHC
         fVzPoVyrlGwfUWNXakJu1ekRK8X2h13/s1pmxUgp6CHj7VBs06IzEec0C5o2mERsYUer
         i2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qX3uRb8j7CO3Ko5mdKX24e1eVWMtEEp5iJJng/869xI=;
        b=LYfns9Hgpe0U0PBmNZqI9AuqUWkvvrlRWsoCr761LZYASTeK3WDG0D1g3HMkrdihfR
         yPzQ0CazbgiswXn25DiIWoiyQFsNLDxb9u9Z1PIn4Cjd7WiPg7MG9/S4kQoUgFtNjg+3
         zM4jSFA8V7H2HSbtCE9kmGpUJxpfTZyjWr+gMpTbKRjPY0q+TwvJ12nmE6CRkIMETt/U
         a4WtuDFcHGMYI/NABkp8mdAbjQ+BOzdKbVplhAMFveSckRozCDXYngRSsB1EYQzZukfD
         HhDhLdTZBE2z1UWBIe02qnaUH7rUZatDTMoBJVYn+eGqPUNipQxtLBgS/YTsGEZE4vrB
         JtYw==
X-Gm-Message-State: AOAM533Xn5zt4TQp9NsFCWdLXq+0pqfBo/8Qy02lZUkGXFxeM0OjfM+8
        ZEBxIhIPTRqd9Poj7O3n6NOplDVLCMk=
X-Google-Smtp-Source: ABdhPJydx5uqz/Rwjfx6NdfwlApsMqL0v/WBnwpcrtXmgUKxmoYj6J8Nezg7Ja6OtBbpyC8t+tYpvA==
X-Received: by 2002:a05:6a00:2484:b0:4c8:ffbd:4c78 with SMTP id c4-20020a056a00248400b004c8ffbd4c78mr12590011pfv.24.1643182536304;
        Tue, 25 Jan 2022 23:35:36 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm2240819pjj.55.2022.01.25.23.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:35:35 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH RFC net-next 1/5] ipv6: separate ndisc_ns_create() from ndisc_send_ns()
Date:   Wed, 26 Jan 2022 15:35:17 +0800
Message-Id: <20220126073521.1313870-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220126073521.1313870-1-liuhangbin@gmail.com>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch separate NS message allocation steps from ndisc_send_ns(),
so it could be used in other places, like bonding, to allocate and
send IPv6 NS message.

Also export ndisc_send_skb() and ndisc_ns_create() for later bonding usage.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/ndisc.h |  5 +++++
 net/ipv6/ndisc.c    | 45 ++++++++++++++++++++++++++++++---------------
 2 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 53cb8de0e589..aac3a42de432 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -447,10 +447,15 @@ void ndisc_cleanup(void);
 
 int ndisc_rcv(struct sk_buff *skb);
 
+struct sk_buff *ndisc_ns_create(struct net_device *dev, const struct in6_addr *solicit,
+				const struct in6_addr *saddr, u64 nonce);
 void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 		   const struct in6_addr *daddr, const struct in6_addr *saddr,
 		   u64 nonce);
 
+void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
+		    const struct in6_addr *saddr);
+
 void ndisc_send_rs(struct net_device *dev,
 		   const struct in6_addr *saddr, const struct in6_addr *daddr);
 void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index f03b597e4121..f21d33bef7d9 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -466,9 +466,8 @@ static void ip6_nd_hdr(struct sk_buff *skb,
 	hdr->daddr = *daddr;
 }
 
-static void ndisc_send_skb(struct sk_buff *skb,
-			   const struct in6_addr *daddr,
-			   const struct in6_addr *saddr)
+void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
+		    const struct in6_addr *saddr)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net *net = dev_net(skb->dev);
@@ -515,6 +514,7 @@ static void ndisc_send_skb(struct sk_buff *skb,
 
 	rcu_read_unlock();
 }
+EXPORT_SYMBOL(ndisc_send_skb);
 
 void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 		   const struct in6_addr *solicited_addr,
@@ -598,22 +598,16 @@ static void ndisc_send_unsol_na(struct net_device *dev)
 	in6_dev_put(idev);
 }
 
-void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
-		   const struct in6_addr *daddr, const struct in6_addr *saddr,
-		   u64 nonce)
+struct sk_buff *ndisc_ns_create(struct net_device *dev, const struct in6_addr *solicit,
+				const struct in6_addr *saddr, u64 nonce)
 {
 	struct sk_buff *skb;
-	struct in6_addr addr_buf;
 	int inc_opt = dev->addr_len;
 	int optlen = 0;
 	struct nd_msg *msg;
 
-	if (!saddr) {
-		if (ipv6_get_lladdr(dev, &addr_buf,
-				   (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)))
-			return;
-		saddr = &addr_buf;
-	}
+	if (!saddr)
+		return NULL;
 
 	if (ipv6_addr_any(saddr))
 		inc_opt = false;
@@ -625,7 +619,7 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 
 	skb = ndisc_alloc_skb(dev, sizeof(*msg) + optlen);
 	if (!skb)
-		return;
+		return NULL;
 
 	msg = skb_put(skb, sizeof(*msg));
 	*msg = (struct nd_msg) {
@@ -647,7 +641,28 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 		memcpy(opt + 2, &nonce, 6);
 	}
 
-	ndisc_send_skb(skb, daddr, saddr);
+	return skb;
+}
+EXPORT_SYMBOL(ndisc_ns_create);
+
+void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
+		   const struct in6_addr *daddr, const struct in6_addr *saddr,
+		   u64 nonce)
+{
+	struct sk_buff *skb;
+	struct in6_addr addr_buf;
+
+	if (!saddr) {
+		if (ipv6_get_lladdr(dev, &addr_buf,
+				   (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)))
+			return;
+		saddr = &addr_buf;
+	}
+
+	skb = ndisc_ns_create(dev, solicit, saddr, nonce);
+
+	if (skb)
+		ndisc_send_skb(skb, daddr, saddr);
 }
 
 void ndisc_send_rs(struct net_device *dev, const struct in6_addr *saddr,
-- 
2.31.1

