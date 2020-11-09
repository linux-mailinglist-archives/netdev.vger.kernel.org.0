Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732E92AB1BE
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgKIH3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:29:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728038AbgKIH3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604906987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oqrwDrpDqmyFbc0vuYm63jvpw2fuXmwCGrG/9ImCmXc=;
        b=P5DR00IHnpz418m7pYaiwdE4/gCDNz3GnCp5aTGu57w9XjIKmWXoGtYe5Pa8ChxsfrGwGk
        yI1YK/zZqxOeo3D7oGDCozv+MsuAzhlJYzCA3kwsFMXb9zX3aagkNTxxOJhBbUWW6GK58A
        C2DjllUgTLcEhr+YP8ohK1LPXfA+jqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-wbjoquqRNE6No9C0DVXMbg-1; Mon, 09 Nov 2020 02:29:43 -0500
X-MC-Unique: wbjoquqRNE6No9C0DVXMbg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A74E21009444;
        Mon,  9 Nov 2020 07:29:41 +0000 (UTC)
Received: from nusiddiq.home.org.com (ovpn-117-137.sin2.redhat.com [10.67.117.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D74A06EF57;
        Mon,  9 Nov 2020 07:29:38 +0000 (UTC)
From:   nusiddiq@redhat.com
To:     dev@openvswitch.org, netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>, Florian Westphal <fw@strlen.de>,
        Numan Siddique <nusiddiq@redhat.com>
Subject: [net-next] netfiler: conntrack: Add the option to set ct tcp flag - BE_LIBERAL per-ct basis.
Date:   Mon,  9 Nov 2020 12:59:30 +0530
Message-Id: <20201109072930.14048-1-nusiddiq@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Numan Siddique <nusiddiq@redhat.com>

Before calling nf_conntrack_in(), caller can set this flag in the
connection template for a tcp packet and any errors in the
tcp_in_window() will be ignored.

A helper function - nf_ct_set_tcp_be_liberal(nf_conn) is added which
sets this flag for both the directions of the nf_conn.

openvswitch makes use of this feature so that any out of window tcp
packets are not marked invalid. Prior to this there was no easy way
to distinguish if conntracked packet is marked invalid because of
tcp_in_window() check error or because it doesn't belong to an
existing connection.

An earlier attempt (see the link) tried to solve this problem for
openvswitch in a different way. Florian Westphal instead suggested
to be liberal in openvswitch for tcp packets.

Link: https://patchwork.ozlabs.org/project/netdev/patch/20201006083355.121018-1-nusiddiq@redhat.com/

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Numan Siddique <nusiddiq@redhat.com>
---
 include/net/netfilter/nf_conntrack_l4proto.h |  6 ++++++
 net/netfilter/nf_conntrack_core.c            | 13 +++++++++++--
 net/openvswitch/conntrack.c                  |  1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 88186b95b3c2..572ae8d2a622 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -203,6 +203,12 @@ static inline struct nf_icmp_net *nf_icmpv6_pernet(struct net *net)
 {
 	return &net->ct.nf_ct_proto.icmpv6;
 }
+
+static inline void nf_ct_set_tcp_be_liberal(struct nf_conn *ct)
+{
+	ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+}
 #endif
 
 #ifdef CONFIG_NF_CT_PROTO_DCCP
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 234b7cab37c3..8290c5b04e88 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1748,10 +1748,18 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
 				      struct sk_buff *skb,
 				      unsigned int dataoff,
 				      enum ip_conntrack_info ctinfo,
-				      const struct nf_hook_state *state)
+				      const struct nf_hook_state *state,
+				      union nf_conntrack_proto *tmpl_proto)
 {
 	switch (nf_ct_protonum(ct)) {
 	case IPPROTO_TCP:
+		if (tmpl_proto) {
+			if (tmpl_proto->tcp.seen[0].flags & IP_CT_TCP_FLAG_BE_LIBERAL)
+				ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+
+			if (tmpl_proto->tcp.seen[1].flags & IP_CT_TCP_FLAG_BE_LIBERAL)
+				ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+		}
 		return nf_conntrack_tcp_packet(ct, skb, dataoff,
 					       ctinfo, state);
 	case IPPROTO_UDP:
@@ -1843,7 +1851,8 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 		goto out;
 	}
 
-	ret = nf_conntrack_handle_packet(ct, skb, dataoff, ctinfo, state);
+	ret = nf_conntrack_handle_packet(ct, skb, dataoff, ctinfo, state,
+					 tmpl ? &tmpl->proto : NULL);
 	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4beb96139d77..64247be2b1d7 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -969,6 +969,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 			if (skb_nfct(skb))
 				nf_conntrack_put(skb_nfct(skb));
 			nf_conntrack_get(&tmpl->ct_general);
+			nf_ct_set_tcp_be_liberal(tmpl);
 			nf_ct_set(skb, tmpl, IP_CT_NEW);
 		}
 
-- 
2.28.0

