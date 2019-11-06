Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA076F14B9
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 12:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbfKFLMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 06:12:49 -0500
Received: from correo.us.es ([193.147.175.20]:44076 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730005AbfKFLMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 06:12:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 452983066A2
        for <netdev@vger.kernel.org>; Wed,  6 Nov 2019 12:12:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FF6CD1929
        for <netdev@vger.kernel.org>; Wed,  6 Nov 2019 12:12:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 25591D1DBB; Wed,  6 Nov 2019 12:12:44 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24D70B8001;
        Wed,  6 Nov 2019 12:12:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Nov 2019 12:12:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E8D9641E4802;
        Wed,  6 Nov 2019 12:12:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/9] netfilter: ipset: Copy the right MAC address in hash:ip,mac IPv6 sets
Date:   Wed,  6 Nov 2019 12:12:31 +0100
Message-Id: <20191106111237.3183-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191106111237.3183-1-pablo@netfilter.org>
References: <20191106111237.3183-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Same as commit 1b4a75108d5b ("netfilter: ipset: Copy the right MAC
address in bitmap:ip,mac and hash:ip,mac sets"), another copy and paste
went wrong in commit 8cc4ccf58379 ("netfilter: ipset: Allow matching on
destination MAC address for mac and ipmac sets").

When I fixed this for IPv4 in 1b4a75108d5b, I didn't realise that
hash:ip,mac sets also support IPv6 as family, and this is covered by a
separate function, hash_ipmac6_kadt().

In hash:ip,mac sets, the first dimension is the IP address, and the
second dimension is the MAC address: check the IPSET_DIM_TWO_SRC flag
in flags while deciding which MAC address to copy, destination or
source.

This way, mixing source and destination matches for the two dimensions
of ip,mac hash type works as expected, also for IPv6. With this setup:

  ip netns add A
  ip link add veth1 type veth peer name veth2 netns A
  ip addr add 2001:db8::1/64 dev veth1
  ip -net A addr add 2001:db8::2/64 dev veth2
  ip link set veth1 up
  ip -net A link set veth2 up

  dst=$(ip netns exec A cat /sys/class/net/veth2/address)

  ip netns exec A ipset create test_hash hash:ip,mac family inet6
  ip netns exec A ipset add test_hash 2001:db8::1,${dst}
  ip netns exec A ip6tables -A INPUT -p icmpv6 --icmpv6-type 135 -j ACCEPT
  ip netns exec A ip6tables -A INPUT -m set ! --match-set test_hash src,dst -j DROP

ipset now correctly matches a test packet:

  # ping -c1 2001:db8::2 >/dev/null
  # echo $?
  0

Reported-by: Chen, Yi <yiche@redhat.com>
Fixes: 8cc4ccf58379 ("netfilter: ipset: Allow matching on destination MAC address for mac and ipmac sets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_ipmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index 24d8f4df4230..4ce563eb927d 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -209,7 +209,7 @@ hash_ipmac6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
 
-	if (opt->flags & IPSET_DIM_ONE_SRC)
+	if (opt->flags & IPSET_DIM_TWO_SRC)
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
-- 
2.11.0

