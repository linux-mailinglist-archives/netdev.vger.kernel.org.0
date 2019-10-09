Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8FCCD09ED
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfJIIbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:31:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfJIIbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 04:31:42 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8241CC057E32;
        Wed,  9 Oct 2019 08:31:42 +0000 (UTC)
Received: from griffin.upir.cz (ovpn-204-237.brq.redhat.com [10.40.204.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94DDB60166;
        Wed,  9 Oct 2019 08:31:41 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Peter Oskolkov <posk@google.com>
Subject: [PATCH bpf] bpf: lwtunnel: fix reroute supplying invalid dst
Date:   Wed,  9 Oct 2019 10:31:24 +0200
Message-Id: <111664d58fe4e9dd9c8014bb3d0b2dab93086a9e.1570609794.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 09 Oct 2019 08:31:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dst in bpf_input() has lwtstate field set. As it is of the
LWTUNNEL_ENCAP_BPF type, lwtstate->data is struct bpf_lwt. When the bpf
program returns BPF_LWT_REROUTE, ip_route_input_noref is directly called on
this skb. This causes invalid memory access, as ip_route_input_slow calls
skb_tunnel_info(skb) that expects the dst->lwstate->data to be
struct ip_tunnel_info. This results to struct bpf_lwt being accessed as
struct ip_tunnel_info.

Drop the dst before calling the IP route input functions (both for IPv4 and
IPv6).

Reported by KASAN.

Fixes: 3bd0b15281af ("bpf: add handling of BPF_LWT_REROUTE to lwt_bpf.c")
Cc: Peter Oskolkov <posk@google.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 net/core/lwt_bpf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index f93785e5833c..74cfb8b5ab33 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -88,11 +88,16 @@ static int bpf_lwt_input_reroute(struct sk_buff *skb)
 	int err = -EINVAL;
 
 	if (skb->protocol == htons(ETH_P_IP)) {
+		struct net_device *dev = skb_dst(skb)->dev;
 		struct iphdr *iph = ip_hdr(skb);
 
+		dev_hold(dev);
+		skb_dst_drop(skb);
 		err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
-					   iph->tos, skb_dst(skb)->dev);
+					   iph->tos, dev);
+		dev_put(dev);
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+		skb_dst_drop(skb);
 		err = ipv6_stub->ipv6_route_input(skb);
 	} else {
 		err = -EAFNOSUPPORT;
-- 
2.18.1

