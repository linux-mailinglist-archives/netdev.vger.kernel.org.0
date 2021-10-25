Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE48439C85
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhJYRD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234307AbhJYRDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B04760FBF;
        Mon, 25 Oct 2021 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181241;
        bh=pPSGWUuXi7JNj3fCppNPAytjD6qYZABDSAvksdujfGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cj45TVyVO3wW8Bu8t+mx9864Yr7zdLJa8js0RyUVlK3hUN8fgfl9ioNd6pJQBg0m9
         RWdD8BJeamy9M4aO6Rfw+3pApjePzdr3GptmKe/0nDQl8Zddu8bKqEYOEig2ttkMbw
         0FpJK9kDKqumPty9AnRYEOgIVOR5esl3VokPareFVaifggEggUdC3hdO/Id+Bv103q
         CLf+kMkCF6/FB55/9iBTbDoKV9L88czcwWjIKnvmWFJ7U8dCJtZhk3+kzkH9sOhLTH
         Vt3KcJCDIhTF8oKZLvrfY/qOFmZvWTeV7a1ANBH1N7pQnPfKgVbHv9ptv66Z9kufqV
         Gqf5blXVcv4Rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugene Crosser <crosser@average.org>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/13] vrf: Revert "Reset skb conntrack connection..."
Date:   Mon, 25 Oct 2021 13:00:18 -0400
Message-Id: <20211025170023.1394358-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025170023.1394358-1-sashal@kernel.org>
References: <20211025170023.1394358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eugene Crosser <crosser@average.org>

[ Upstream commit 55161e67d44fdd23900be166a81e996abd6e3be9 ]

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
Acked-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index d406da82b4fb..2746f77745e4 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1313,8 +1313,6 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
 
-	nf_reset_ct(skb);
-
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
 	 * For strict packets with a source LLA, determine the dst using the
@@ -1371,8 +1369,6 @@ static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
 
-	nf_reset_ct(skb);
-
 	if (ipv4_is_multicast(ip_hdr(skb)->daddr))
 		goto out;
 
-- 
2.33.0

