Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF7821CBED
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgGLWim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:38:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54954 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727795AbgGLWim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:38:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594593520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RLUAIQFedM+9pe7Sacd9d/An/VyoXp1EJq3jixSZeYg=;
        b=YbZL9o2ScxI3dOBe4jTyRQapAgfcL8HW2Ote+ANUbeyWd6RMZStEXUV+weWKFFzl6VFJKx
        e7hN8whAyzSqznd8S1mvNWqK3B8+5wBDhYw4VTm1xQJ3bUp0JQYYKkR303cdwL+4Y1lZl0
        3hAJW1EP15e94BLWN8UUyra+ojXms3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-TYT9WdHQMZC0mrUgmd8jQw-1; Sun, 12 Jul 2020 18:38:25 -0400
X-MC-Unique: TYT9WdHQMZC0mrUgmd8jQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D6EA106B245;
        Sun, 12 Jul 2020 22:38:24 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30EAD5D9EF;
        Sun, 12 Jul 2020 22:38:21 +0000 (UTC)
Date:   Mon, 13 Jul 2020 00:38:13 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netdev@vger.kernel.org>, aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200713003813.01f2d5d3@elisabeth>
In-Reply-To: <20200712200705.9796-2-fw@strlen.de>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-2-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, 12 Jul 2020 22:07:03 +0200
Florian Westphal <fw@strlen.de> wrote:

> vxlan and geneve take the to-be-transmitted skb, prepend the
> encapsulation header and send the result.
> 
> Neither vxlan nor geneve can do anything about a lowered path mtu
> except notifying the peer/upper dst entry.

It could, and I think it should, update its MTU, though. I didn't
include this in the original implementation of PMTU discovery for UDP
tunnels as it worked just fine for locally generated and routed
traffic, but here we go.

As PMTU discovery happens, we have a route exception on the lower
layer for the given path, and we know that VXLAN will use that path,
so we also know there's no point in having a higher MTU on the VXLAN
device, it's really the maximum packet size we can use.

See the change to vxlan_xmit_one() in the sketch patch below.

> In routed setups, vxlan takes the updated pmtu from the encap sockets'
> dst entry and will notify/update the dst entry of the current skb.
> 
> Some setups, however, will use vxlan as a bridge port (or openvs vport).

And, on top of that, I think what we're missing on the bridge is to
update the MTU when a port lowers its MTU. The MTU is changed only as
interfaces are added, which feels like a bug. We could use the lower
layer notifier to fix this.

In the sketch below, I'm changing a few lines to adjust the MTU to the
lowest MTU value between all ports, for testing purposes.

I tried to represent the issue you're hitting with a new test case in
the pmtu.sh selftest, also included in the diff. Would that work for
Open vSwitch?

If OVS queries the MTU of VXLAN devices, I guess that should be enough.
I'm not sure it does that though. The changes to the bridge wouldn't
even be needed, but I think it's something we should also fix
eventually.

---
 drivers/net/vxlan.c                 |   13 +++++++++++++
 net/bridge/br_if.c                  |    8 +++++---
 net/bridge/br_input.c               |    6 ++++++
 tools/testing/selftests/net/pmtu.sh |   17 ++++++++++++++++-
 4 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5bb448ae6c9c..2e051b7366bf 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2580,6 +2580,7 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
+static int vxlan_change_mtu(struct net_device *dev, int new_mtu);
 static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			   __be32 default_vni, struct vxlan_rdst *rdst,
 			   bool did_rsc)
@@ -2714,6 +2715,18 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		ndst = &rt->dst;
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
 
+		/* TODO: doesn't conflict with RFC 7348, RFC 1191, but not ideal
+		 * as we can't track PMTU increases:
+		 * - use a notifier on route cache and add a configuration field
+		 *   to track user changes
+		 * - embed logic from skb_tunnel_check_pmtu() and get this fixed
+		 *   for free for all the tunnels
+		 */
+		if (skb->len > dst_mtu(ndst) - VXLAN_HEADROOM) {
+			vxlan_change_mtu(vxlan->dev,
+					 dst_mtu(ndst) - VXLAN_HEADROOM);
+		}
+
 		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a0e9a7937412..6253b6d40d43 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -505,9 +505,11 @@ void br_mtu_auto_adjust(struct net_bridge *br)
 {
 	ASSERT_RTNL();
 
-	/* if the bridge MTU was manually configured don't mess with it */
-	if (br_opt_get(br, BROPT_MTU_SET_BY_USER))
-		return;
+	/* TODO: if (br_opt_get(br, BROPT_MTU_SET_BY_USER)), we should not
+	 * increase the MTU, but skipping decreases breaks functionality:
+	 * - add an 'opt' to track the set value and allow the user to decrease
+	 *   the MTU arbitrarily
+	 */
 
 	/* change to the minimum MTU and clear the flag which was set by
 	 * the bridge ndo_change_mtu callback
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 59a318b9f646..2429f70ce4ee 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -283,6 +283,12 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 			goto drop;
 	}
 
+	/* TODO: use lower layer notifier instead. Some tunnels implement this
+	 * properly (see e.g. vti6 and pmtu_vti6_link_change_mtu selftest in
+	 * net/pmtu.sh)
+	 */
+	br_mtu_auto_adjust(p->br);
+
 	if (unlikely(is_link_local_ether_addr(dest))) {
 		u16 fwd_mask = p->br->group_fwd_mask_required;
 
diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 77c09cd339c3..09731d9ea11a 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -169,7 +169,8 @@ tests="
 	cleanup_ipv4_exception		ipv4: cleanup of cached exceptions	1
 	cleanup_ipv6_exception		ipv6: cleanup of cached exceptions	1
 	list_flush_ipv4_exception	ipv4: list and flush cached exceptions	1
-	list_flush_ipv6_exception	ipv6: list and flush cached exceptions	1"
+	list_flush_ipv6_exception	ipv6: list and flush cached exceptions	1
+	pmtu_ipv4_vxlan4_exception_bridge	IPv4 over vxlan4 with bridge		1"
 
 NS_A="ns-A"
 NS_B="ns-B"
@@ -864,6 +865,20 @@ test_pmtu_ipv4_vxlan4_exception() {
 	test_pmtu_ipvX_over_vxlanY_or_geneveY_exception vxlan  4 4
 }
 
+test_pmtu_ipv4_vxlan4_exception_bridge() {
+	test_pmtu_ipvX_over_vxlanY_or_geneveY_exception vxlan  4 4
+
+	ip -n ns-A link add br0 type bridge
+	ip -n ns-A link set br0 up
+	ip -n ns-A link set dev br0 mtu 5000
+	ip -n ns-A link set vxlan_a master br0
+
+	ip -n ns-A addr del 192.168.2.1/24 dev vxlan_a
+	ip -n ns-A addr add 192.168.2.1/24 dev br0
+
+	ping -c 1 -w 2 -M want -s 5000 192.168.2.2
+}
+
 test_pmtu_ipv6_vxlan4_exception() {
 	test_pmtu_ipvX_over_vxlanY_or_geneveY_exception vxlan  6 4
 }


-- 
Stefano

