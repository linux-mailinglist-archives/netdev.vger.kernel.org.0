Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E0723B4A5
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgHDFyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:54:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57305 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726398AbgHDFyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 01:54:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596520457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=31u+5QtVSUX3lAFvKOYQd1LBFaATNpSm1kiiRImWK+s=;
        b=Dft+OpM2s0pqpU+eT+XhTv1RFd84bGFf0d//Z2vIboj+qDhfvWdMUR9ruIku3ad8MebTSk
        NBCwpIwKypsYjEproYAZvHRgtbfpKRciNpK9BiKxAQa7YYJV41gsjj21U/L8yZa5NkFmfG
        ByvrLFt59wrbTIn8e2FvBqxLSTrRX+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-KmquQOWcPIyt3lyBdn2dYg-1; Tue, 04 Aug 2020 01:54:13 -0400
X-MC-Unique: KmquQOWcPIyt3lyBdn2dYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBFBF1DE1;
        Tue,  4 Aug 2020 05:54:11 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3E211001B2C;
        Tue,  4 Aug 2020 05:54:08 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/6] ipv4: route: Ignore output interface in FIB lookup for PMTU route
Date:   Tue,  4 Aug 2020 07:53:42 +0200
Message-Id: <ec94f1f590e6cb57d128ce10e4306e589544944d.1596520062.git.sbrivio@redhat.com>
In-Reply-To: <cover.1596520062.git.sbrivio@redhat.com>
References: <cover.1596520062.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, processes sending traffic to a local bridge with an
encapsulation device as a port don't get ICMP errors if they exceed
the PMTU of the encapsulated link.

David Ahern suggested this as a hack, but it actually looks like
the correct solution: when we update the PMTU for a given destination
by means of updating or creating a route exception, the encapsulation
might trigger this because of PMTU discovery happening either on the
encapsulation device itself, or its lower layer. This happens on
bridged encapsulations only.

The output interface shouldn't matter, because we already have a
valid destination. Drop the output interface restriction from the
associated route lookup.

For UDP tunnels, we will now have a route exception created for the
encapsulation itself, with a MTU value reflecting its headroom, which
allows a bridge forwarding IP packets originated locally to deliver
errors back to the sending socket.

The behaviour is now consistent with IPv6 and verified with selftests
pmtu_ipv{4,6}_br_{geneve,vxlan}{4,6}_exception introduced later in
this series.

v2:
- reset output interface only for bridge ports (David Ahern)
- add and use netif_is_any_bridge_port() helper (David Ahern)

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/linux/netdevice.h | 5 +++++
 net/ipv4/route.c          | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 88d40b9abaa1..90444622b703 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4840,6 +4840,11 @@ static inline bool netif_is_ovs_port(const struct net_device *dev)
 	return dev->priv_flags & IFF_OVS_DATAPATH;
 }
 
+static inline bool netif_is_any_bridge_port(const struct net_device *dev)
+{
+	return netif_is_bridge_port(dev) || netif_is_ovs_port(dev);
+}
+
 static inline bool netif_is_team_master(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_TEAM;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a01efa062f6b..8ca6bcab7b03 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1050,6 +1050,11 @@ static void ip_rt_update_pmtu(struct dst_entry *dst, struct sock *sk,
 	struct flowi4 fl4;
 
 	ip_rt_build_flow_key(&fl4, sk, skb);
+
+	/* Don't make lookup fail for bridged encapsulations */
+	if (skb && netif_is_any_bridge_port(skb->dev))
+		fl4.flowi4_oif = 0;
+
 	__ip_rt_update_pmtu(rt, &fl4, mtu);
 }
 
-- 
2.27.0

