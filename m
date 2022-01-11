Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BBA48A4F3
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346301AbiAKBZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346230AbiAKBYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:50 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A8FC061756;
        Mon, 10 Jan 2022 17:24:49 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v6so30028273wra.8;
        Mon, 10 Jan 2022 17:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CAcyrl4yFF10VZJC35lqjrTek3vjD8DPs+k+UlDzF8o=;
        b=dNsgW2pqYkHcV4tliHqD2/1yZ07xzfHAd/nGN3CSqtAuHUyJn3l3Fbf677mtw5/8oF
         WRQHiiN0z9nbd4sSicnOIicTPiEf0wgK3BUakBlhHkk/QP8lC2BvZu5GGxtPgqJkhfEf
         jyxxVqFRuhoHo2exaVnag4uPxN1c2/ye1saCpIS81seidXE5wXHBAZZfaoh7jJLb5J+g
         T4dJXAmYL3NmVy50zedX3Y0aww1gziqAy4Mhgqe2CViDz2jatvCAYYq/0x5Ty4ErI8BT
         zOSfaIgxPxkztwGYHity2ue/vX3iGszzwzujWRZZFpASltyEv2lW14PrAI+Tj2pCzXQ9
         XULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CAcyrl4yFF10VZJC35lqjrTek3vjD8DPs+k+UlDzF8o=;
        b=ZeQwNfkPnioy7tOOZKdMDbiMAbjaNnSWw+Jlp7KvcDLRy0tVmUwtDR76LbbG3d0mWS
         pU/2TqiM4EhfQuIphvT39JJR4VCLQCf7MVyFq+R3zKxcwKr3lLYp/qlK4BfvIHtvk1hu
         B/uIaPAs/bogaUrem3o1A76snP+/GIkAIDpUbmj+OnHSDu4oBCSdllqa/twm8E7BKtD9
         8snWcW/IpdyLek61wnvpSJTqm0nSM4JUdIsfagDFCysiSjjtmKBhxH8oMIhNLrJdhrp+
         Kg/gt+qzzQjdWXq/Y7ABoaDOpiO+vAICtDAUfF3hrMuMrzBBAdIJffnWiQmNLRq+kzC2
         ZkFg==
X-Gm-Message-State: AOAM532g0JF+1kMsqbmYlbDUVzuByRsQ4TSR5k+beGbvpXYyveiCZqh6
        +yEDmJxWkbAgg7PJ+Nc5+Y16VdtYncc=
X-Google-Smtp-Source: ABdhPJwIPAOximG+U7jQn8f5BT/isT4/o3WdWwtKIl6LRoLnhjlGtEM0oyGSTrXIJiF98kmck1ltfA==
X-Received: by 2002:a05:6000:18c6:: with SMTP id w6mr1732499wrq.449.1641864288448;
        Mon, 10 Jan 2022 17:24:48 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 05/14] ipv6: don't zero cork's flowi after use
Date:   Tue, 11 Jan 2022 01:21:37 +0000
Message-Id: <e2cbbc9e6d55253fa4e254f746dfb8f91b6b0fe7.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It doesn't appear there is any reason to zero cork->fl after use, i.e.
in ip6_cork_release(), especially when cork struct is on-stack. Not
only the memset accounts to 0.3-0.5% of total cycles (perf profiling),
but also prevents other optimisations implemented in further patches.
Also, now we can remove a relatively expensive flow copy in
udp_v6_push_pending_frames().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c |  1 -
 net/ipv6/udp.c        | 10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 88349e49717a..b8fdda9ac797 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1831,7 +1831,6 @@ static void ip6_cork_release(struct inet_cork_full *cork,
 		cork->base.dst = NULL;
 		cork->base.flags &= ~IPCORK_ALLFRAG;
 	}
-	memset(&cork->fl, 0, sizeof(cork->fl));
 }
 
 struct sk_buff *__ip6_make_skb(struct sock *sk,
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 0c10ee0124b5..9a91b51d8e3f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1266,23 +1266,17 @@ static int udp_v6_push_pending_frames(struct sock *sk)
 {
 	struct sk_buff *skb;
 	struct udp_sock  *up = udp_sk(sk);
-	struct flowi6 fl6;
 	int err = 0;
 
 	if (up->pending == AF_INET)
 		return udp_push_pending_frames(sk);
 
-	/* ip6_finish_skb will release the cork, so make a copy of
-	 * fl6 here.
-	 */
-	fl6 = inet_sk(sk)->cork.fl.u.ip6;
-
 	skb = ip6_finish_skb(sk);
 	if (!skb)
 		goto out;
 
-	err = udp_v6_send_skb(skb, &fl6, &inet_sk(sk)->cork.base);
-
+	err = udp_v6_send_skb(skb, &inet_sk(sk)->cork.fl.u.ip6,
+			      &inet_sk(sk)->cork.base);
 out:
 	up->len = 0;
 	up->pending = 0;
-- 
2.34.1

