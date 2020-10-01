Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5604B27FB0C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 10:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbgJAIHF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Oct 2020 04:07:05 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:48057 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731459AbgJAIHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 04:07:04 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-To-CSBxWNle7O1IMxEJkdQ-1; Thu, 01 Oct 2020 04:00:43 -0400
X-MC-Unique: To-CSBxWNle7O1IMxEJkdQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F235D106C10B;
        Thu,  1 Oct 2020 08:00:41 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.192.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35C945C1CF;
        Thu,  1 Oct 2020 08:00:41 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 08/12] ipv6: advertise IFLA_LINK_NETNSID when dumping ipv6 addresses
Date:   Thu,  1 Oct 2020 09:59:32 +0200
Message-Id: <00ecfc1804b58d8dbb23b8a6e7e5c0646f0100e1.1600770261.git.sd@queasysnail.net>
In-Reply-To: <cover.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we're not advertising link-netnsid when dumping IPv6
addresses, so the "ip -6 addr" command will not correctly interpret
the value of the IFLA_LINK attribute.

For example, we'll get:
    9: macvlan0@macvlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000
        <snip>

Instead of:
    9: macvlan0@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000 link-netns main
        <snip>

ndisc_ifinfo_sysctl_change calls inet6_fill_ifinfo without rcu or
rtnl, so I'm adding rcu_read_lock around rtnl_fill_link_netnsid.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv6/addrconf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 688e441a8699..fb95c0227dfe 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5533,6 +5533,7 @@ static inline size_t inet6_if_nlmsg_size(void)
 	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_ADDRESS */
 	       + nla_total_size(4) /* IFLA_MTU */
 	       + nla_total_size(4) /* IFLA_LINK */
+	       + nla_total_size(4) /* IFLA_LINK_NETNSID */
 	       + nla_total_size(1) /* IFLA_OPERSTATE */
 	       + nla_total_size(inet6_ifla6_size()); /* IFLA_PROTINFO */
 }
@@ -5840,6 +5841,14 @@ static int inet6_fill_ifinfo(struct sk_buff *skb, struct inet6_dev *idev,
 	    nla_put_u8(skb, IFLA_OPERSTATE,
 		       netif_running(dev) ? dev->operstate : IF_OPER_DOWN))
 		goto nla_put_failure;
+
+	rcu_read_lock();
+	if (rtnl_fill_link_netnsid(skb, dev, dev_net(dev), GFP_ATOMIC)) {
+		rcu_read_unlock();
+		goto nla_put_failure;
+	}
+	rcu_read_unlock();
+
 	protoinfo = nla_nest_start_noflag(skb, IFLA_PROTINFO);
 	if (!protoinfo)
 		goto nla_put_failure;
-- 
2.28.0

