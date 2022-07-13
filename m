Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05467573E39
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbiGMUw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiGMUw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:52:58 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B91831912
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657745577; x=1689281577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bx3WPWEyqfFufRuWieInySF2S2Mwaexci4bJns7YGFk=;
  b=NHAmvFfF/beRKPljPZUA514Ith4WAS4ms0X56x3ctOxz7+4pDvEJzzO9
   Q9U9sYKEvnU3CBh+mUDqGRsVhaTVKS17cB3pFuYDX7M+dvwhppjRzNOPS
   AdRgfJ/CjFyN9TmGtusuTfo3RK3Ki2yBhuL6ZbSj/SaFY4NrDnT7BT3o7
   Q=;
X-IronPort-AV: E=Sophos;i="5.92,269,1650931200"; 
   d="scan'208";a="237978816"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 13 Jul 2022 20:52:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id DC2F330001C;
        Wed, 13 Jul 2022 20:52:39 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 13 Jul 2022 20:52:39 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 13 Jul 2022 20:52:36 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 01/15] ip: Fix data-races around sysctl_ip_default_ttl.
Date:   Wed, 13 Jul 2022 13:51:51 -0700
Message-ID: <20220713205205.15735-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220713205205.15735-1-kuniyu@amazon.com>
References: <20220713205205.15735-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_ip_default_ttl, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 drivers/net/ethernet/netronome/nfp/flower/action.c | 2 +-
 include/net/route.h                                | 2 +-
 net/ipv4/ip_sockglue.c                             | 2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                | 4 ++--
 net/ipv4/proc.c                                    | 2 +-
 net/netfilter/nf_synproxy_core.c                   | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 0147de405365..ffb6f6d05a07 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -474,7 +474,7 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 			set_tun->ttl = ip4_dst_hoplimit(&rt->dst);
 			ip_rt_put(rt);
 		} else {
-			set_tun->ttl = net->ipv4.sysctl_ip_default_ttl;
+			set_tun->ttl = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		}
 	}
 
diff --git a/include/net/route.h b/include/net/route.h
index 991a3985712d..bbcf2aba149f 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -373,7 +373,7 @@ static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 	struct net *net = dev_net(dst->dev);
 
 	if (hoplimit == 0)
-		hoplimit = net->ipv4.sysctl_ip_default_ttl;
+		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 	return hoplimit;
 }
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 445a9ecaefa1..d497d525dea3 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1606,7 +1606,7 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	{
 		struct net *net = sock_net(sk);
 		val = (inet->uc_ttl == -1 ?
-		       net->ipv4.sysctl_ip_default_ttl :
+		       READ_ONCE(net->ipv4.sysctl_ip_default_ttl) :
 		       inet->uc_ttl);
 		break;
 	}
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 918c61fda0f3..d640adcaf1b1 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -62,7 +62,7 @@ struct sk_buff *nf_reject_skb_v4_tcp_reset(struct net *net,
 
 	skb_reserve(nskb, LL_MAX_HEADER);
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
-				   net->ipv4.sysctl_ip_default_ttl);
+				   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
 	niph->tot_len = htons(nskb->len);
 	ip_send_check(niph);
@@ -117,7 +117,7 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 
 	skb_reserve(nskb, LL_MAX_HEADER);
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_ICMP,
-				   net->ipv4.sysctl_ip_default_ttl);
+				   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 
 	skb_reset_transport_header(nskb);
 	icmph = skb_put_zero(nskb, sizeof(struct icmphdr));
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 28836071f0a6..0088a4c64d77 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -387,7 +387,7 @@ static int snmp_seq_show_ipstats(struct seq_file *seq, void *v)
 
 	seq_printf(seq, "\nIp: %d %d",
 		   IPV4_DEVCONF_ALL(net, FORWARDING) ? 1 : 2,
-		   net->ipv4.sysctl_ip_default_ttl);
+		   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 
 	BUILD_BUG_ON(offsetof(struct ipstats_mib, mibs) != 0);
 	snmp_get_cpu_field64_batch(buff64, snmp4_ipstats_list,
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index e479dd0561c5..16915f8eef2b 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -405,7 +405,7 @@ synproxy_build_ip(struct net *net, struct sk_buff *skb, __be32 saddr,
 	iph->tos	= 0;
 	iph->id		= 0;
 	iph->frag_off	= htons(IP_DF);
-	iph->ttl	= net->ipv4.sysctl_ip_default_ttl;
+	iph->ttl	= READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 	iph->protocol	= IPPROTO_TCP;
 	iph->check	= 0;
 	iph->saddr	= saddr;
-- 
2.30.2

