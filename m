Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079E56F0095
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242817AbjD0GAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239435AbjD0GAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:00:12 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179D01FEF
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:00:12 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-54f8d59a8a9so97919387b3.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682575211; x=1685167211;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i1mVgaQpO1YAZRd12mVNFIudQTmVsH0/NXoKU0acUPU=;
        b=UG8HnKVMnhCIVqKhYrfSaL+wOt7iKLs9dzd5FrOXXRPhn+fX4LHmNP7Jedygmk8rMX
         rM8qT0WNfQJMQmJJ4iSZPZf8UcD4Sc+GuV368bVk0hgFdNbOpPasZP9vhZaafebPvfZ8
         QAbWi3k3X9Kqv7b+6SY7bCLPzcLFym0vJo/+b98vptdpTrLNH9H5+SSHY8nH5dtW3L4T
         Mk1REXAAxhfBVjXNhRdOw2EAW68ObbU3g9WlLp96KP3jvXJMq/sD0x/CNDOLflU+2FgV
         nsDaAice/2mvMWJbBSVkl0yiAmlyPffDepk2fqP2sXrT57NasRvsBSRLbI7qUU5S/LsS
         EmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682575211; x=1685167211;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i1mVgaQpO1YAZRd12mVNFIudQTmVsH0/NXoKU0acUPU=;
        b=NUGklf6sUf3oNAv4v3B0FB4ieSF2XM8QbpVPqMKO4bTa8ZMMQXGMH4i/yPubO+Hb7z
         YAfwXH/4vD+GaQdtob7iTwX8yV6r7kyAGQPI1rL9Dh2c62ebxRudFKTSKAKeZXbr/eFs
         I9R6Dwt0lfvlZnl8MqO37ElVbkCzdeULn4Bz+ElWgELY4po0X/Gy/6SoqmmKD9P5Chau
         /njBiOWul+rG6W4H1A6oWVHyf8cimBF6iUAoLS1yt2f3IkWNE1nWnhIiqKqjPfn4Mx7Q
         0BgP1TMTV+Hju4QKt/CZt4r4ymob9HBqYkrItc0w0ji8dBADPHV5uq75ebN+BABDcjaf
         3ZGw==
X-Gm-Message-State: AC+VfDy/zgha5YI+c37ggTxA1FzAc6j+ok7KqaEYP8JE9m1cFvTyCCgz
        lGAjPotcR2sUQdC0YDiG1PQHL6Z+Xe+ydg==
X-Google-Smtp-Source: ACHHUZ7IRAslvPZ9cy7JsQiPq7mgZe6txdjWSxSwB4oggZnH2/5VzmrSSE24SJuVVZzpYHq2cMAaFQ==
X-Received: by 2002:a0d:d9c4:0:b0:54f:3ca:3cae with SMTP id b187-20020a0dd9c4000000b0054f03ca3caemr506301ywe.20.1682575211057;
        Wed, 26 Apr 2023 23:00:11 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2631:b6d6:1241:19c])
        by smtp.gmail.com with ESMTPSA id z66-20020a0df045000000b0054f56baf3f2sm4606350ywe.122.2023.04.26.23.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 23:00:10 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Palash Oswal <oswalpalash@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net v2] sit: update dev->needed_headroom in ipip6_tunnel_bind_dev()
Date:   Wed, 26 Apr 2023 23:00:06 -0700
Message-Id: <20230427060006.640809-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

When a tunnel device is bound with the underlying device, its
dev->needed_headroom needs to be updated properly. IPv4 tunnels
already do the same in ip_tunnel_bind_dev(). Otherwise we may
not have enough header room for skb, especially after commit
b17f709a2401 ("gue: TX support for using remote checksum offload option").

Fixes: 32b8a8e59c9c ("sit: add IPv4 over IPv4 support")
Reported-by: Palash Oswal <oswalpalash@gmail.com>
Link: https://lore.kernel.org/netdev/CAGyP=7fDcSPKu6nttbGwt7RXzE3uyYxLjCSE97J64pRxJP8jPA@mail.gmail.com/
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
v2: follow reverse Christmas tree style

Note, this is targeting for -net and -table, so I'd keep the fix
small. We can refactor and reuse ip_tunnel_bind_dev() for -net-next.

 net/ipv6/sit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 70d81bba5093..3ffb6a5b1f82 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1095,12 +1095,13 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
 
 static void ipip6_tunnel_bind_dev(struct net_device *dev)
 {
+	struct ip_tunnel *tunnel = netdev_priv(dev);
+	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 	struct net_device *tdev = NULL;
-	struct ip_tunnel *tunnel;
+	int hlen = LL_MAX_HEADER;
 	const struct iphdr *iph;
 	struct flowi4 fl4;
 
-	tunnel = netdev_priv(dev);
 	iph = &tunnel->parms.iph;
 
 	if (iph->daddr) {
@@ -1123,14 +1124,15 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
 
 	if (tdev && !netif_is_l3_master(tdev)) {
-		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 		int mtu;
 
 		mtu = tdev->mtu - t_hlen;
 		if (mtu < IPV6_MIN_MTU)
 			mtu = IPV6_MIN_MTU;
 		WRITE_ONCE(dev->mtu, mtu);
+		hlen = tdev->hard_header_len + tdev->needed_headroom;
 	}
+	dev->needed_headroom = t_hlen + hlen;
 }
 
 static void ipip6_tunnel_update(struct ip_tunnel *t, struct ip_tunnel_parm *p,
-- 
2.34.1

