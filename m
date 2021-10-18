Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F60432649
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhJRSZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbhJRSZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:25:50 -0400
Received: from dehost.average.org (dehost.average.org [IPv6:2a01:4f8:130:53eb::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69FFC06161C;
        Mon, 18 Oct 2021 11:23:38 -0700 (PDT)
Received: from wncross.lan (unknown [IPv6:2a02:8106:1:6800:28c6:cddd:3280:eea4])
        by dehost.average.org (Postfix) with ESMTPA id 6386038F8DE9;
        Mon, 18 Oct 2021 20:23:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1634581417; bh=ujGZfHbCd3lp5Q061tU/2QOrw+hXBosdROpCNY1a1pQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HApV5Rzw/U5Sr76JYCwYX2Szt+LZJ9ObAoOcvtAHEw1736BrZYDPjYDzrSeDro6ii
         b0QYN8rACwcJI4R8Ecf5rDLFuLyUd6IzEp57F3ic5HNsodJoW2SOFb0S2DfO8hgjsW
         EhmRjaAutpFJHftuhE2oQv4oEGshunhO0YdG2l7s=
From:   Eugene Crosser <crosser@average.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        Eugene Crosser <crosser@average.org>
Subject: [PATCH net 1/1] vrf: Revert "Reset skb conntrack connection..."
Date:   Mon, 18 Oct 2021 20:22:50 +0200
Message-Id: <20211018182250.23093-2-crosser@average.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018182250.23093-1-crosser@average.org>
References: <20211018182250.23093-1-crosser@average.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1.

When an interface is enslaved in a VRF, prerouting conntrack hook is
called twice: once in the context of the original input interface, and
once in the context of the VRF interface. If no special precausions are
taken, this leads to creation of two conntrack entries instead of one,
and breaks SNAT.

Commit above was intended to avoid creation of extra conntrack entries
when input interface is enslaved in a VRF. It did so by resetting
conntrack related data associated with the skb when it enters VRF context.

However it breaks netfilter operation. Imagine a use case when conntrack
zone must be assigned based on the original input interface, rather than
VRF interface (that would make original interfaces indistinguishable). One
could create netfilter rules similar to these:

        chain rawprerouting {
                type filter hook prerouting priority raw;
                iif realiface1 ct zone set 1 return
                iif realiface2 ct zone set 2 return
        }

This works before the mentioned commit, but not after: zone assignment
is "forgotten", and any subsequent NAT or filtering that is dependent
on the conntrack zone does not work.

Here is a reproducer script that demonstrates the difference in behaviour.

==========
#!/bin/sh

# This script demonstrates unexpected change of nftables behaviour
# caused by commit 09e856d54bda5f28 ""vrf: Reset skb conntrack
# connection on VRF rcv"
# https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=09e856d54bda5f288ef8437a90ab2b9b3eab83d1
#
# Before the commit, it was possible to assign conntrack zone to a
# packet (or mark it for `notracking`) in the prerouting chanin, raw
# priority, based on the `iif` (interface from which the packet
# arrived).
# After the change, # if the interface is enslaved in a VRF, such
# assignment is lost. Instead, assignment based on the `iif` matching
# the VRF master interface is honored. Thus it is impossible to
# distinguish packets based on the original interface.
#
# This script demonstrates this change of behaviour: conntrack zone 1
# or 2 is assigned depending on the match with the original interface
# or the vrf master interface. It can be observed that conntrack entry
# appears in different zone in the kernel versions before and after
# the commit.

IPIN=172.30.30.1
IPOUT=172.30.30.2
PFXL=30

ip li sh vein >/dev/null 2>&1 && ip li del vein
ip li sh tvrf >/dev/null 2>&1 && ip li del tvrf
nft list table testct >/dev/null 2>&1 && nft delete table testct

ip li add vein type veth peer veout
ip li add tvrf type vrf table 9876
ip li set veout master tvrf
ip li set vein up
ip li set veout up
ip li set tvrf up
/sbin/sysctl -w net.ipv4.conf.veout.accept_local=1
/sbin/sysctl -w net.ipv4.conf.veout.rp_filter=0
ip addr add $IPIN/$PFXL dev vein
ip addr add $IPOUT/$PFXL dev veout

nft -f - <<__END__
table testct {
	chain rawpre {
		type filter hook prerouting priority raw;
		iif { veout, tvrf } meta nftrace set 1
		iif veout ct zone set 1 return
		iif tvrf ct zone set 2 return
		notrack
	}
	chain rawout {
		type filter hook output priority raw;
		notrack
	}
}
__END__

uname -rv
conntrack -F
ping -W 1 -c 1 -I vein $IPOUT
conntrack -L

Signed-off-by: Eugene Crosser <crosser@average.org>
---
 drivers/net/vrf.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index bf2fac913942..662e26117353 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1360,8 +1360,6 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
 
-	nf_reset_ct(skb);
-
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
 	 * For strict packets with a source LLA, determine the dst using the
@@ -1424,8 +1422,6 @@ static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
 
-	nf_reset_ct(skb);
-
 	if (ipv4_is_multicast(ip_hdr(skb)->daddr))
 		goto out;
 
-- 
2.32.0

