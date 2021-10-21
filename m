Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA3A436796
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhJUQZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhJUQZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:27 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19211C061224
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:11 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so6089710pjq.0
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a78ceogwZklintSvLdEa+VabuxrsNS5i6SlSoSFi624=;
        b=M6FUBtSar+1rFTnD7SHgo+ietdAi7aVw7eVL5kL+FqPA02ZnGrHbCYrcyKLvuMCf+k
         YbpTSwALsaWwAAOf1yvZ+dftA38KCgeT8Zf/R9P1ohFngz6/iLMtg5FhjaQnmRZ4ClEv
         cz8xVeoTQ9qxSkjaAYSNjczUBxJURUNKwqGVQJyXDTsEpPrpe0RbNOF530WBlhPzAzhx
         71K55q5RlUsUkRcIcwVk/aK55eH3jGjOspZYCcVMKYd9YLy2Pnnft9Lmw/xmprenxlCs
         pDhsOEsMR+t9QICn3Y7Zrf0+m+Wf4RmU83wXvF/4M5l7zH3TOi76wzRm97lKZcLSbSfZ
         0Ezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a78ceogwZklintSvLdEa+VabuxrsNS5i6SlSoSFi624=;
        b=LdFLsnTJO6owW3veZ0kxiBYw+AplgqTQLnTIFcKM/A9tXkXySnw27n5hKTqTJM+l3Y
         DJCMtrEdlY89Vpq04G9MJgKjzZ7WOxI3zcmDfQbLY6ZGdCWK5jLP0Lo9HfLWysxi5WIP
         lw2xFiACY5NrXcaEKAX2BdqaKMyCKMK27O8WW520V/9Vebs1qwYsy8EOPgDWKiGtulib
         nN/xrrnXMmhNXNrx5griP0e40NHc+wqwk94Lv5v8rRzmkaCsEFN1e0aBuqUQhdVM3jFc
         guXh+uroRL46kXhZFI+GT/h+1gwoR5KcaQE0VvOcXSfE5odldJ+akd1MNpVLCY6RScIF
         HgFA==
X-Gm-Message-State: AOAM531+EadAN3q6TXd7Milz+ds4k2DhgBP/Ju3yFvVPnS96uAGWnmbg
        86Dhc2GNVeHmek3v+mBwaGo=
X-Google-Smtp-Source: ABdhPJy10zr8n+SqheZm5/ucrY/nCwMd4iP/+rAuJ1IjBHF8yyUH1bDuPmpLtFmw+59T2UMQ8RducA==
X-Received: by 2002:a17:90a:de0b:: with SMTP id m11mr7685928pjv.90.1634833390613;
        Thu, 21 Oct 2021 09:23:10 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:10 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 6/9] ipv6: guard IPV6_MINHOPCOUNT with a static key
Date:   Thu, 21 Oct 2021 09:22:50 -0700
Message-Id: <20211021162253.333616-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

RFC 5082 IPV6_MINHOPCOUNT is rarely used on hosts.

Add a static key to remove from TCP fast path useless code,
and potential cache line miss to fetch tcp_inet6_sk(sk)->min_hopcount

Note that once ip6_min_hopcount static key has been enabled,
it stays enabled until next boot.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h       |  1 +
 net/ipv6/ipv6_sockglue.c |  6 ++++++
 net/ipv6/tcp_ipv6.c      | 21 +++++++++++++--------
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index f2d0ecc257bb28e6dd162d180c371e2b0487c8e3..c19bf51ded1d026e795a3f9ae0ff3be766fc174e 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1092,6 +1092,7 @@ struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
 /*
  *	socket options (ipv6_sockglue.c)
  */
+DECLARE_STATIC_KEY_FALSE(ip6_min_hopcount);
 
 int ipv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		    unsigned int optlen);
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 9c3d28764b5c3a47a73491ea5d656867ece4fed2..41efca817db4228f265235a471449a3790075ce7 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -55,6 +55,8 @@
 struct ip6_ra_chain *ip6_ra_chain;
 DEFINE_RWLOCK(ip6_ra_lock);
 
+DEFINE_STATIC_KEY_FALSE(ip6_min_hopcount);
+
 int ip6_ra_control(struct sock *sk, int sel)
 {
 	struct ip6_ra_chain *ra, *new_ra, **rap;
@@ -950,6 +952,10 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			goto e_inval;
 		if (val < 0 || val > 255)
 			goto e_inval;
+
+		if (val)
+			static_branch_enable(&ip6_min_hopcount);
+
 		/* tcp_v6_err() and tcp_v6_rcv() might read min_hopcount
 		 * while we are changing it.
 		 */
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2247f525364b16e89afedbec8f4ec3367bf88aa8..bbff3df27d1c24d7a47849b28297ba129baafc99 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -414,10 +414,12 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (sk->sk_state == TCP_CLOSE)
 		goto out;
 
-	/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
-	if (ipv6_hdr(skb)->hop_limit < READ_ONCE(tcp_inet6_sk(sk)->min_hopcount)) {
-		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
-		goto out;
+	if (static_branch_unlikely(&ip6_min_hopcount)) {
+		/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
+		if (ipv6_hdr(skb)->hop_limit < READ_ONCE(tcp_inet6_sk(sk)->min_hopcount)) {
+			__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
+			goto out;
+		}
 	}
 
 	tp = tcp_sk(sk);
@@ -1724,10 +1726,13 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			return 0;
 		}
 	}
-	/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
-	if (hdr->hop_limit < READ_ONCE(tcp_inet6_sk(sk)->min_hopcount)) {
-		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
-		goto discard_and_relse;
+
+	if (static_branch_unlikely(&ip6_min_hopcount)) {
+		/* min_hopcount can be changed concurrently from do_ipv6_setsockopt() */
+		if (hdr->hop_limit < READ_ONCE(tcp_inet6_sk(sk)->min_hopcount)) {
+			__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
+			goto discard_and_relse;
+		}
 	}
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
-- 
2.33.0.1079.g6e70778dc9-goog

