Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF32444ACB0
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343522AbhKILgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237400AbhKILfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 06:35:55 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB30BC061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 03:33:09 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g19so13202530pfb.8
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 03:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=fO9WFV8F4TyUDMb8YJlmXZSb4ymnIYoC/ZrNTQ5M18Y=;
        b=tfh2pJFgqE6eQHerjrMd7ZDA7D8PgRlU0vzOw5VCfk+CigYWbortt2g//OX9tzpLKg
         atHId1dyTyi5qPIvLDW7Etgh3KjgwssCO9QNEQFvvLmYVFkNgVd1SqHCpZkAj6JpZYob
         NZRV5E1td8jJLBmri2YmuHNdNqUdVaya7lkcag3vf8rkvUMXeHMqKK3bosG9955lRNU3
         Esw/wyZQ7ldgIh8JVqE5f3GTSODxwJH7OFSwEO0DO0l7KQy7Y4VnwWQywqwf9hTOhck5
         CIlw+qe7l2yIOQjVsBghzRGxkD2f6the3cYhJl6Gj8FSpf3lVBe2DkkyE9DoLuvJeJT8
         OuqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fO9WFV8F4TyUDMb8YJlmXZSb4ymnIYoC/ZrNTQ5M18Y=;
        b=Ao7B27F4JtyaHmKLarNTOxoQXOpxuBgMlnNsB6EHaQSoqdBwqcV5kRnRzrtzTOMlJH
         M/102Ba4kXl0NjLwOyh2C19cElbPC3U1Jt9/U2Az30QyB32QRFCBGhg80jq9NQffbbo7
         CL2eUtCpQznLn3x8Ms3C4QRnYgpIo+eDe4f/L0BVZHF8EfuTBqes+h8rNHCo9xT2hfPx
         xnGCNSPS0my0mK7t2oN/+tA9ujV3pOvZ3uzKdupMqImqOo8BpYU1PgaJOAyyxCF/fxGg
         mvezl6aPan27jd7IPo1QmURnupKFIPvvILNte5jGA6iyDlwnOxivh57bq+Y+TryzQWry
         CoAQ==
X-Gm-Message-State: AOAM5323seU47BQRNyaAaC4OmtqgVhMO2CNxGDyuHSY0om9te/+gEJX0
        +Nm2mjPO6uqkS856TqE+oC5+Gg==
X-Google-Smtp-Source: ABdhPJyzn9Q/ehsjtHasSdutRKQBETfy9pR1GDs66kz0L6FPuvPdKrgLO0RPsMtbufg3JyqIRoWOAw==
X-Received: by 2002:a63:8bc3:: with SMTP id j186mr5222010pge.250.1636457589253;
        Tue, 09 Nov 2021 03:33:09 -0800 (PST)
Received: from node1.smartx.com ([103.97.201.31])
        by smtp.gmail.com with ESMTPSA id j6sm14937193pgq.0.2021.11.09.03.33.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Nov 2021 03:33:08 -0800 (PST)
From:   Changliang Wu <changliang.wu@smartx.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, idosch@OSS.NVIDIA.COM, amcohen@nvidia.com,
        fw@strlen.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        changliang.wu@smartx.com
Subject: [PATCH] ipv4: add sysctl knob to control the discarding of skb from local in ip_forward
Date:   Tue,  9 Nov 2021 06:32:57 -0500
Message-Id: <1636457577-43305-1-git-send-email-changliang.wu@smartx.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change is meant to add a control for forwarding skb from local.
By default, ip forward will not receive the pakcet to/from the local.
But in some special cases, for example:
-
|  ovs-bridge  gw-port |  <---->   kube-proxy(iptables) |
-
Ovs sends the packet to the gateway, which requires iptables for nat,
such as kube-proxy (iptables), and then sends it back to the gateway
through routing for further processing in ovs.

Signed-off-by: Changliang Wu <changliang.wu@smartx.com>
---
 include/net/netns/ipv4.h   | 1 +
 net/ipv4/af_inet.c         | 1 +
 net/ipv4/ip_forward.c      | 6 +++---
 net/ipv4/sysctl_net_ipv4.c | 7 +++++++
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 2f65701..0dbe0d6 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -94,6 +94,7 @@ struct netns_ipv4 {
 	u8 sysctl_ip_no_pmtu_disc;
 	u8 sysctl_ip_fwd_use_pmtu;
 	u8 sysctl_ip_fwd_update_priority;
+	u8 sysctl_ip_fwd_accept_local;
 	u8 sysctl_ip_nonlocal_bind;
 	u8 sysctl_ip_autobind_reuse;
 	/* Shall we try to damage output packets if routing dev changes? */
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 0189e3c..b5dc205 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1844,6 +1844,7 @@ static __net_init int inet_init_net(struct net *net)
 	 */
 	net->ipv4.sysctl_ip_default_ttl = IPDEFTTL;
 	net->ipv4.sysctl_ip_fwd_update_priority = 1;
+	net->ipv4.sysctl_ip_fwd_accept_local = 0;
 	net->ipv4.sysctl_ip_dynaddr = 0;
 	net->ipv4.sysctl_ip_early_demux = 1;
 	net->ipv4.sysctl_udp_early_demux = 1;
diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 00ec819..06b7e00 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -95,9 +95,6 @@ int ip_forward(struct sk_buff *skb)
 	if (skb->pkt_type != PACKET_HOST)
 		goto drop;
 
-	if (unlikely(skb->sk))
-		goto drop;
-
 	if (skb_warn_if_lro(skb))
 		goto drop;
 
@@ -110,6 +107,9 @@ int ip_forward(struct sk_buff *skb)
 	skb_forward_csum(skb);
 	net = dev_net(skb->dev);
 
+	if (unlikely(!net->ipv4.sysctl_ip_fwd_accept_local && skb->sk))
+		goto drop;
+
 	/*
 	 *	According to the RFC, we must first decrease the TTL field. If
 	 *	that reaches zero, we must reply an ICMP control message telling
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 97eb547..d95e2e3 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -756,6 +756,13 @@ static int proc_fib_multipath_hash_fields(struct ctl_table *table, int write,
 		.extra2		= SYSCTL_ONE,
 	},
 	{
+		.procname	= "ip_forward_accept_local",
+		.data		= &init_net.ipv4.sysctl_ip_fwd_accept_local,
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+	},
+	{
 		.procname	= "ip_nonlocal_bind",
 		.data		= &init_net.ipv4.sysctl_ip_nonlocal_bind,
 		.maxlen		= sizeof(u8),
-- 
1.8.3.1

