Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A247439C0A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbhJYQvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbhJYQu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:50:59 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A59C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:37 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 75so11530322pga.3
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3sADqxOwcycN3Ol5Y822tWtM/xawBqRDa2NO7ajIG2Q=;
        b=Dh4N6tfp5zrCg2n5srQ+KZr1fV/7Pf1b7e+uzG7v4da4eAKFasI8irtvCmfAVXLf/2
         maBAi0102ur12tCZIaly4CYEkmnXbZcOHWm5855Z/mPqId94NjJO8KiYvKf2kGIZsq3E
         qIt0WgAkY3pMvyOHWFKOzb6EWuQ+6ic9e74Ng0PEKwn80iZBNQcWqS6gkiFs0NpuRCNc
         PFnlYFriMhQOEEsgAxXTlCh6OdkTIsTJkuIqAw2EQ0th3D8RAPMNJEOynH6tPm7x4Ktn
         gaXM3xVzw6WS//rpULZid/h3sV8l6MS2c0FKpq1827hYe96hmQtBYMSSAiOHbLOWkIZC
         ShAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3sADqxOwcycN3Ol5Y822tWtM/xawBqRDa2NO7ajIG2Q=;
        b=LNP+QnTpoX4tQLgbdNw/VTPud/9i+/InDK0wsFmtfGXcGf35fyLnvQn/sf5apt6NK3
         gEONeo5PxMTX3OW3npsExRkcoaJQ3YJg7iQLJPZNjA5qu28mxT9YZ7WSl5kOPpHxvAwM
         cjcOlzOZsJ2lWNT5uVtUSGio483MAnoKOzv5cpqiTfySgjcLbUBX5Tkc3CMPJgeGHhkf
         loZ6PTW/vnF7jdiU/R7d4jo7aA0xgUv/tTOxiZfxt32FCqrYA6mQQSNNVmSnJECU4/5j
         jh2isGP1gBuPKmiOibFeAiFp+ZCxMcasaGA8jo4aeIyyLjnV0NsVnJhG1AfMWznZOJYW
         7hMw==
X-Gm-Message-State: AOAM533FePjt69+0qy+qVITL9x42oezDeX5z7nLqZ+66CGOL+EaS1415
        Gx1uqVC1bkGXuliy6MKjljU=
X-Google-Smtp-Source: ABdhPJxwHrs6LMTuIMcJj89XYHUoF5UXalafCKN+WYOhAIlzQZouab2KKcfW0T+XDQqKbX/PupVBZw==
X-Received: by 2002:a05:6a00:10c5:b0:47b:d112:96d6 with SMTP id d5-20020a056a0010c500b0047bd11296d6mr17253184pfu.59.1635180517260;
        Mon, 25 Oct 2021 09:48:37 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:36 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 07/10] ipv6: guard IPV6_MINHOPCOUNT with a static key
Date:   Mon, 25 Oct 2021 09:48:22 -0700
Message-Id: <20211025164825.259415-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
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
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
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
index c93b2d48bb89a845c880679572c75a8791589525..6945583c0fa48256db5510866342e4aab672fd71 100644
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
@@ -1727,10 +1729,13 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
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

