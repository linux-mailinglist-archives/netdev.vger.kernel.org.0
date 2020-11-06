Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D453F2A9A51
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgKFRCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:02:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52494 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727557AbgKFRCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 12:02:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604682126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZkxJN2pG0H55OfgSG0ZLVwRKHMCCE+bBVgApsriI7dQ=;
        b=YNwHMstkJWfrwp+/v2ICj1cbzPBWxKHxUd02L1XhKK7EbVYlyU50R4MWnoAcwzB5dJwIX9
        EERfO/TSnYQ71aWt+wvLUVJEelhxgH0BFE3RkT5aHntcvcQ+uSuw2NgbYtYEBzgyU6n/WK
        9GfE5T1Fq3qIE4a8j59fm99erH5AFo0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-D3TLjyGAMxOk5eZZtYYgDg-1; Fri, 06 Nov 2020 12:01:54 -0500
X-MC-Unique: D3TLjyGAMxOk5eZZtYYgDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DB9286ABD3;
        Fri,  6 Nov 2020 17:01:52 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E7355D9D5;
        Fri,  6 Nov 2020 17:01:49 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jianlin Shi <jishi@redhat.com>, David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Aaron Conole <aconole@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] tunnels: Fix off-by-one in lower MTU bounds for ICMP/ICMPv6 replies
Date:   Fri,  6 Nov 2020 17:59:52 +0100
Message-Id: <4f5fc2f33bfdf8409549fafd4f952b008bf04d63.1604681709.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianlin reports that a bridged IPv6 VXLAN endpoint, carrying IPv6
packets over a link with a PMTU estimation of exactly 1350 bytes,
won't trigger ICMPv6 Packet Too Big replies when the encapsulated
datagrams exceed said PMTU value. VXLAN over IPv6 adds 70 bytes of
overhead, so an ICMPv6 reply indicating 1280 bytes as inner MTU
would be legitimate and expected.

This comes from an off-by-one error I introduced in checks added
as part of commit 4cb47a8644cc ("tunnels: PMTU discovery support
for directly bridged IP packets"), whose purpose was to prevent
sending ICMPv6 Packet Too Big messages with an MTU lower than the
smallest permissible IPv6 link MTU, i.e. 1280 bytes.

In iptunnel_pmtud_check_icmpv6(), avoid triggering a reply only if
the advertised MTU would be less than, and not equal to, 1280 bytes.

Also fix the analogous comparison for IPv4, that is, skip the ICMP
reply only if the resulting MTU is strictly less than 576 bytes.

This becomes apparent while running the net/pmtu.sh bridged VXLAN
or GENEVE selftests with adjusted lower-link MTU values. Using
e.g. GENEVE, setting ll_mtu to the values reported below, in the
test_pmtu_ipvX_over_bridged_vxlanY_or_geneveY_exception() test
function, we can see failures on the following tests:

             test                | ll_mtu
  -------------------------------|--------
  pmtu_ipv4_br_geneve4_exception |   626
  pmtu_ipv6_br_geneve4_exception |  1330
  pmtu_ipv6_br_geneve6_exception |  1350

owing to the different tunneling overheads implied by the
corresponding configurations.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/ipv4/ip_tunnel_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 25f1caf5abf9..e25be2d01a7a 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -263,7 +263,7 @@ static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
 	const struct icmphdr *icmph = icmp_hdr(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 
-	if (mtu <= 576 || iph->frag_off != htons(IP_DF))
+	if (mtu < 576 || iph->frag_off != htons(IP_DF))
 		return 0;
 
 	if (ipv4_is_lbcast(iph->daddr)  || ipv4_is_multicast(iph->daddr) ||
@@ -359,7 +359,7 @@ static int iptunnel_pmtud_check_icmpv6(struct sk_buff *skb, int mtu)
 	__be16 frag_off;
 	int offset;
 
-	if (mtu <= IPV6_MIN_MTU)
+	if (mtu < IPV6_MIN_MTU)
 		return 0;
 
 	if (stype == IPV6_ADDR_ANY || stype == IPV6_ADDR_MULTICAST ||
-- 
2.28.0

