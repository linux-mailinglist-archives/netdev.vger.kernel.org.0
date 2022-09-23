Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9E15E732B
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiIWE7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiIWE7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:59:22 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BC6115BE4;
        Thu, 22 Sep 2022 21:59:21 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id ml1so8353750qvb.1;
        Thu, 22 Sep 2022 21:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=w7WgXqDy6uF6D+cwyb3YICMekC6oPMZu16hQg76TAnA=;
        b=mCh0hQB87AyS+SvnmXQml6Ibr0omif9APXSh7t707zyN3sjQt2K2/Sx4adFGzQM/SH
         4TLyvSNnrqdQeI89nPdnBU4X6yoOG/r0V3G4PvbCyf2is0izv2JG4Vm1ga6w8q5jgLvp
         BfDOYMRN5z9vL7ZHbgc1zg0jJj/CqK39G8dBD//GekYY8vdJbKzu2VDHtliv5YKS9W3F
         lAZwR+9TYG4BhMHLiqIop9Y6WdYGu5c5Ao/BmXpwDd1z+8eNLbu/iIFPIcEq3TVTa1an
         RngSul6mSsUV5rKYj+qtHYlRZaGxF/JpIhaaB7ZhhOcxphLu3ww2tCQQsRKZTrqf2dFD
         NELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=w7WgXqDy6uF6D+cwyb3YICMekC6oPMZu16hQg76TAnA=;
        b=JrnhLkohsHiRzmHUdV8Zv/iPGaCamCmxFeRhqTkvoQbW3K7FVCAbpeLa56TIVnuA/4
         H/gvDJvbt0276uSf53EkeyOkllDdE7gJEsqwDFAjHh7zwG+xIMQs4AyqGRHgn3jRrp6S
         C0fTgynLsN5JVEb+yfIE2sANSB/fz3BWNreszMOP+TBpr1BhYmmCIKyReI8+2GlplMMG
         mX4oe7X7mwfWtYc1Qzlm1KIs7umDRK25Rwe8iY9bKbmbZom2beY5nO7lKBkFZ0aE06ci
         AvhlS+xRrK72vQE/NNEHUmF6VWjtGMPYTlwz5malkEaiHQJXmdot6PKB3f/wUhQrtWSt
         PxVw==
X-Gm-Message-State: ACrzQf0TQomQLZidecY8043+CZNh6kMXHXyZ67RhlMD/xQ6YrkI4IaqU
        DpjTvj2fd6J/ftbTyuQ5v24BuU/3vA==
X-Google-Smtp-Source: AMsMyM67b/wMw8cHGqon+6muFXWM74Sl4GqRVyNjNFY1g0kOQxvmpqa/nFFOoWnxPwqMzhdFILw2fA==
X-Received: by 2002:a05:6214:2528:b0:4ad:6fa4:4170 with SMTP id gg8-20020a056214252800b004ad6fa44170mr5430291qvb.113.1663909160182;
        Thu, 22 Sep 2022 21:59:20 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id x2-20020ac86b42000000b0034305a91aaesm4519573qts.83.2022.09.22.21.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 21:59:19 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next RESEND 1/2] udp: Refactor udp_read_skb()
Date:   Thu, 22 Sep 2022 21:59:13 -0700
Message-Id: <343b5d8090a3eb764068e9f1d392939e2b423747.1663909008.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <03db9765fe1ef0f61bfc87fc68b5a95b4126aa4e.1663143016.git.peilin.ye@bytedance.com>
References: <03db9765fe1ef0f61bfc87fc68b5a95b4126aa4e.1663143016.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Delete the unnecessary while loop in udp_read_skb() for readability.
Additionally, since recv_actor() cannot return a value greater than
skb->len (see sk_psock_verdict_recv()), remove the redundant check.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/ipv4/udp.c | 46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 560d9eadeaa5..d63118ce5900 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1801,41 +1801,29 @@ EXPORT_SYMBOL(__skb_recv_udp);
 
 int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
-	int copied = 0;
-
-	while (1) {
-		struct sk_buff *skb;
-		int err, used;
-
-		skb = skb_recv_udp(sk, MSG_DONTWAIT, &err);
-		if (!skb)
-			return err;
+	struct sk_buff *skb;
+	int err, copied;
 
-		if (udp_lib_checksum_complete(skb)) {
-			__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
-					IS_UDPLITE(sk));
-			__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
-					IS_UDPLITE(sk));
-			atomic_inc(&sk->sk_drops);
-			kfree_skb(skb);
-			continue;
-		}
+try_again:
+	skb = skb_recv_udp(sk, MSG_DONTWAIT, &err);
+	if (!skb)
+		return err;
 
-		WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
-		used = recv_actor(sk, skb);
-		if (used <= 0) {
-			if (!copied)
-				copied = used;
-			kfree_skb(skb);
-			break;
-		} else if (used <= skb->len) {
-			copied += used;
-		}
+	if (udp_lib_checksum_complete(skb)) {
+		int is_udplite = IS_UDPLITE(sk);
+		struct net *net = sock_net(sk);
 
+		__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, is_udplite);
+		__UDP_INC_STATS(net, UDP_MIB_INERRORS, is_udplite);
+		atomic_inc(&sk->sk_drops);
 		kfree_skb(skb);
-		break;
+		goto try_again;
 	}
 
+	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
+	copied = recv_actor(sk, skb);
+	kfree_skb(skb);
+
 	return copied;
 }
 EXPORT_SYMBOL(udp_read_skb);
-- 
2.20.1

