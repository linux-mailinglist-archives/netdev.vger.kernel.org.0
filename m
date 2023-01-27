Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA9467EA3C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 17:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbjA0QA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 11:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbjA0QAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 11:00:17 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7425E8663F
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:11 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id m26so4342168qtp.9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 08:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0droLD9xWCEleZyachsSghGy62xKncNAXBCionjipGQ=;
        b=TnjJeUePPXtrUdtkEmfUx24evk3Dmem396bz05imOX/WmmcbdPf5IPJsQkzBfRxNRw
         wltR6hROhssO526Fn0dbgz1qpnXsG47Xr2n3Rceuz/zcyt13064euPvUnZTVETCFPUzW
         FZkd/AcU2YDpVq2e9yFdMNrZyzn0/cDIbnKVI3SSFBYbIXjE+20lBETY7oVjeXGq52Kr
         UKrzG1Or4p8W+/vk4nrcV5eChCf3hiiiMDT9Knz+b1dc44T9nJbb+sMcxpAM2wy5E2aQ
         iJBp1MXxEni+/IDu/m3o9/e7dbw/0thv8KDi/rHribnuDosldtG1H21e40AaqrYr2ipN
         wChw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0droLD9xWCEleZyachsSghGy62xKncNAXBCionjipGQ=;
        b=FHjgq4NwTja5ZZAYvU3SXajCKpwFZU+mdoqEV+3wQ55/Sg38FPsanmOFub4ty43Dva
         hr1caR0l6RGAlpyia6611lBWeXROOZqR8AhhvXJvktekR7bDcQUC4TE8SMkHF16Ux20B
         GO41CT0V589du4EhoVXGIYh3Q0/IA/3kcC7hL16lnXL6jr6WG8cc2jDFp59Q2yypoFiu
         qoBC/iJmuJIg8OaQ/ZGI7EVFYoc9xnOM1txTZcr0a4GKiWE2OnXyXmy7pIu/LLYF60UA
         XWsYiEolDQhF91FLPTQSnUEqT6qmLbUWilb30Ru3a6W7ClcxJoRW8JvC8r/VV12Ts65E
         zluA==
X-Gm-Message-State: AFqh2kpzD/HYfeq6Ww86AqW+ONy+LAoowfPujaM5oLrtkCChZdCGboea
        k8dEYzSJMUMt+Hd6bbh6x8xWwYYaCDrOuw==
X-Google-Smtp-Source: AMrXdXvOOyNGiBD7UJVHVwvpSVRFnxU3OGNUKdEktxlEsUvpY3iALi8yKS8C3ZyfyWO0pyYfYSfhpA==
X-Received: by 2002:ac8:4742:0:b0:3b6:8ece:caae with SMTP id k2-20020ac84742000000b003b68ececaaemr42676070qtp.28.1674835210371;
        Fri, 27 Jan 2023 08:00:10 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z3-20020a05622a124300b003b62bc6cd1csm2860659qtx.82.2023.01.27.08.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:00:10 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv3 net-next 10/10] net: add support for ipv4 big tcp
Date:   Fri, 27 Jan 2023 10:59:56 -0500
Message-Id: <798ca80553e73028eeec4be08ba1549d08b2e5fc.1674835106.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1674835106.git.lucien.xin@gmail.com>
References: <cover.1674835106.git.lucien.xin@gmail.com>
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

Similar to Eric's IPv6 BIG TCP, this patch is to enable IPv4 BIG TCP.

Firstly, allow sk->sk_gso_max_size to be set to a value greater than
GSO_LEGACY_MAX_SIZE by not trimming gso_max_size in sk_trim_gso_size()
for IPv4 TCP sockets.

Then on TX path, set IP header tot_len to 0 when skb->len > IP_MAX_MTU
in __ip_local_out() to allow to send BIG TCP packets, and this implies
that skb->len is the length of a IPv4 packet; On RX path, use skb->len
as the length of the IPv4 packet when the IP header tot_len is 0 and
skb->len > IP_MAX_MTU in ip_rcv_core(). As the API iph_set_totlen() and
skb_ip_totlen() are used in __ip_local_out() and ip_rcv_core(), we only
need to update these APIs.

Also in GRO receive, add the check for ETH_P_IP/IPPROTO_TCP, and allows
the merged packet size >= GRO_LEGACY_MAX_SIZE in skb_gro_receive(). In
GRO complete, set IP header tot_len to 0 when the merged packet size
greater than IP_MAX_MTU in iph_set_totlen() so that it can be processed
on RX path.

Note that by checking skb_is_gso_tcp() in API iph_totlen(), it makes
this implementation safe to use iph->len == 0 indicates IPv4 BIG TCP
packets.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/gro.c       | 12 +++++++-----
 net/core/sock.c      |  8 ++++++--
 net/ipv4/af_inet.c   |  7 ++++---
 net/ipv4/ip_input.c  |  2 +-
 net/ipv4/ip_output.c |  2 +-
 5 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index 506f83d715f8..b15f85546bdd 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -162,16 +162,18 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	struct sk_buff *lp;
 	int segs;
 
-	/* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
-	gro_max_size = READ_ONCE(p->dev->gro_max_size);
+	/* pairs with WRITE_ONCE() in netif_set_gro(_ipv4)_max_size() */
+	gro_max_size = p->protocol == htons(ETH_P_IPV6) ?
+			READ_ONCE(p->dev->gro_max_size) :
+				READ_ONCE(p->dev->gro_ipv4_max_size);
 
 	if (unlikely(p->len + len >= gro_max_size || NAPI_GRO_CB(skb)->flush))
 		return -E2BIG;
 
 	if (unlikely(p->len + len >= GRO_LEGACY_MAX_SIZE)) {
-		if (p->protocol != htons(ETH_P_IPV6) ||
-		    skb_headroom(p) < sizeof(struct hop_jumbo_hdr) ||
-		    ipv6_hdr(p)->nexthdr != IPPROTO_TCP ||
+		if (NAPI_GRO_CB(skb)->proto != IPPROTO_TCP ||
+		    (p->protocol == htons(ETH_P_IPV6) &&
+		     skb_headroom(p) < sizeof(struct hop_jumbo_hdr)) ||
 		    p->encapsulation)
 			return -E2BIG;
 	}
diff --git a/net/core/sock.c b/net/core/sock.c
index 7ba4891460ad..c98f9a4eeff9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2383,6 +2383,8 @@ static void sk_trim_gso_size(struct sock *sk)
 	    !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
 		return;
 #endif
+	if (sk->sk_family == AF_INET && sk_is_tcp(sk))
+		return;
 	sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
 }
 
@@ -2403,8 +2405,10 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 		} else {
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
-			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
-			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
+			/* pairs with the WRITE_ONCE() in netif_set_gso(_ipv4)_max_size() */
+			sk->sk_gso_max_size = sk->sk_family == AF_INET6 ?
+					READ_ONCE(dst->dev->gso_max_size) :
+						READ_ONCE(dst->dev->gso_ipv4_max_size);
 			sk_trim_gso_size(sk);
 			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 6c0ec2789943..2f992a323b95 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1485,6 +1485,7 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 	if (unlikely(ip_fast_csum((u8 *)iph, 5)))
 		goto out;
 
+	NAPI_GRO_CB(skb)->proto = proto;
 	id = ntohl(*(__be32 *)&iph->id);
 	flush = (u16)((ntohl(*(__be32 *)iph) ^ skb_gro_len(skb)) | (id & ~IP_DF));
 	id >>= 16;
@@ -1618,9 +1619,9 @@ int inet_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 
 int inet_gro_complete(struct sk_buff *skb, int nhoff)
 {
-	__be16 newlen = htons(skb->len - nhoff);
 	struct iphdr *iph = (struct iphdr *)(skb->data + nhoff);
 	const struct net_offload *ops;
+	__be16 totlen = iph->tot_len;
 	int proto = iph->protocol;
 	int err = -ENOSYS;
 
@@ -1629,8 +1630,8 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
 		skb_set_inner_network_header(skb, nhoff);
 	}
 
-	csum_replace2(&iph->check, iph->tot_len, newlen);
-	iph->tot_len = newlen;
+	iph_set_totlen(iph, skb->len - nhoff);
+	csum_replace2(&iph->check, totlen, iph->tot_len);
 
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index e880ce77322a..0aa8c49b4e1b 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -511,7 +511,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl)))
 		goto csum_error;
 
-	len = ntohs(iph->tot_len);
+	len = skb_ip_totlen(skb);
 	if (skb->len < len) {
 		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 922c87ef1ab5..4e4e308c3230 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -100,7 +100,7 @@ int __ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct iphdr *iph = ip_hdr(skb);
 
-	iph->tot_len = htons(skb->len);
+	iph_set_totlen(iph, skb->len);
 	ip_send_check(iph);
 
 	/* if egress device is enslaved to an L3 master device pass the
-- 
2.31.1

