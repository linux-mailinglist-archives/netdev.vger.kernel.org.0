Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609423A591F
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 16:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhFMOqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 10:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbhFMOqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 10:46:09 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41CFC061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 07:43:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id o9so6632243pgd.2
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 07:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=admH69WwWHg/51d+9NCBP6U2S76mlrc/E9mDIfezmhc=;
        b=cNBWazbep2rGuZmbRsWIBmKf7I3tlGzGUEvRyeargVpfK8zwxo89x9A0Z5f7PE9jK6
         FV/VlEsu04EceHps4s/X1BmdL+PaobVtWTEq7/V1yTbwJ4baaDvF2fZCYs1TKTaE1ofo
         LxiwSlCmSlre7xompKD8BBqr8QG/6lGhdIl+q3hK/XjyjtWuJNmjmxegGvQmm3B3dsYR
         ylKCSI4yoMhTkTvVqRuYkUiiTl2d4NOrykW6zmYLDHD8Taif2Fzo9dEgDmgEZESkRDd8
         Q/SXc+WMpWbOaW3tD+SQe3RXzpOVZvSCGfSxYDGwWueBekyvvQdAkNtpSJDHA4ADc3IU
         uGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=admH69WwWHg/51d+9NCBP6U2S76mlrc/E9mDIfezmhc=;
        b=sDR4odp3Ke/HqWNlfQS2qiyoItvVQSPDGfveMIAj5kJu3PBd+DyC4QLXjwDl+KvniA
         Mf4qgeBZJrciJboQWgyr1Khwlj4zKnM+i4B9D0XcXMXpYZtk6NAuaWhMSWZ25y+ZiGZB
         O6juRx9HY2I9wah6F5eLd3BbzjN1PyDyExMka5vWyg9Q1VUXZdMlOxRt9X1qypzGK+Re
         O5iJYeFqzZcNOF6Lnvdox9M/CcqY3aRHuSK8r5gH3ZcrMKUF36UG4w/8wGy+15GZnZQB
         BX95/6OSV2824Kl9lAzjtfycrDfosF1vqKYnxxOuWhltfIfLFw3Qy1tRDlFc93Ri62Kz
         uwEA==
X-Gm-Message-State: AOAM531l/884hAU199nC+JK6K1bmMnVmSxUTv+algOgnGIOBaMi3w4QD
        FYrFrQUx0NM0yZDgBrq/2TY=
X-Google-Smtp-Source: ABdhPJz4F6UsvlYV0SRjipg+F2QeHCg8Yo7gVcm/hiFK+10nSZky5wbN6akQqsUB6EXJn2pUqvBQVA==
X-Received: by 2002:a05:6a00:d65:b029:2ec:2bfa:d0d1 with SMTP id n37-20020a056a000d65b02902ec2bfad0d1mr17630963pfv.14.1623595436156;
        Sun, 13 Jun 2021 07:43:56 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id e21sm9632676pjh.55.2021.06.13.07.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 07:43:55 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next] mld: avoid unnecessary high order page allocation in mld_newpack()
Date:   Sun, 13 Jun 2021 14:43:44 +0000
Message-Id: <20210613144344.31311-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If link mtu is too big, mld_newpack() allocates high-order page.
But most mld packets don't need high-order page.
So, it might waste unnecessary pages.
To avoid this, it makes mld_newpack() try to allocate order-0 page.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv6/mcast.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index d36ef9d25e73..54ec163fbafa 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1729,22 +1729,25 @@ static void ip6_mc_hdr(struct sock *sk, struct sk_buff *skb,
 
 static struct sk_buff *mld_newpack(struct inet6_dev *idev, unsigned int mtu)
 {
+	u8 ra[8] = { IPPROTO_ICMPV6, 0, IPV6_TLV_ROUTERALERT,
+		     2, 0, 0, IPV6_TLV_PADN, 0 };
 	struct net_device *dev = idev->dev;
-	struct net *net = dev_net(dev);
-	struct sock *sk = net->ipv6.igmp_sk;
-	struct sk_buff *skb;
-	struct mld2_report *pmr;
-	struct in6_addr addr_buf;
-	const struct in6_addr *saddr;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
-	unsigned int size = mtu + hlen + tlen;
+	struct net *net = dev_net(dev);
+	const struct in6_addr *saddr;
+	struct in6_addr addr_buf;
+	struct mld2_report *pmr;
+	struct sk_buff *skb;
+	unsigned int size;
+	struct sock *sk;
 	int err;
-	u8 ra[8] = { IPPROTO_ICMPV6, 0,
-		     IPV6_TLV_ROUTERALERT, 2, 0, 0,
-		     IPV6_TLV_PADN, 0 };
 
-	/* we assume size > sizeof(ra) here */
+	sk = net->ipv6.igmp_sk;
+	/* we assume size > sizeof(ra) here
+	 * Also try to not allocate high-order pages for big MTU
+	 */
+	size = min_t(int, mtu, PAGE_SIZE / 2) + hlen + tlen;
 	skb = sock_alloc_send_skb(sk, size, 1, &err);
 	if (!skb)
 		return NULL;
-- 
2.17.1

