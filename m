Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EE1308D83
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhA2Tic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:38:32 -0500
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:7414 "EHLO
        bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbhA2Tia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:38:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3911; q=dns/txt; s=iport;
  t=1611949108; x=1613158708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8T6xhh/+97MYL69HOZHijmar/RuLTo27yNHNS+EKjJA=;
  b=WiGPGAOZKyws+5k6txWJ9KIAlQVxbdK9h/Ci35OBlUxAfwK7Kb9qsd1q
   vp006ykzO+fwZr22yiUoRXzL+McRMnCq7E2yqYu6Cy5z9WNbwN5IKF/Q5
   wSxLXHIhav77V7rVwWGmRaEQojlutGjXALthNIGPGvaUXgj6bRdVIItYv
   4=;
X-IronPort-AV: E=Sophos;i="5.79,386,1602547200"; 
   d="scan'208";a="175655162"
Received: from vla196-nat.cisco.com (HELO bgl-core-4.cisco.com) ([72.163.197.24])
  by bgl-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 29 Jan 2021 19:28:13 +0000
Received: from bgl-ads-1848.cisco.com (bgl-ads-1848.cisco.com [173.39.51.250])
        by bgl-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 10TJSCZL010736
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 29 Jan 2021 19:28:12 GMT
Received: by bgl-ads-1848.cisco.com (Postfix, from userid 838444)
        id 6A207CC1251; Sat, 30 Jan 2021 00:58:12 +0530 (IST)
From:   Aviraj CJ <acj@cisco.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, xe-linux-external@cisco.com,
        acj@cisco.com
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [Internal review][PATCH stable v5.4 2/2] IPv6: reply ICMP error if the first fragment don't include all headers
Date:   Sat, 30 Jan 2021 00:57:41 +0530
Message-Id: <20210129192741.117693-2-acj@cisco.com>
X-Mailer: git-send-email 2.26.2.Cisco
In-Reply-To: <20210129192741.117693-1-acj@cisco.com>
References: <20210129192741.117693-1-acj@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 173.39.51.250, bgl-ads-1848.cisco.com
X-Outbound-Node: bgl-core-4.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

commit 2efdaaaf883a143061296467913c01aa1ff4b3ce upstream.

Based on RFC 8200, Section 4.5 Fragment Header:

  -  If the first fragment does not include all headers through an
     Upper-Layer header, then that fragment should be discarded and
     an ICMP Parameter Problem, Code 3, message should be sent to
     the source of the fragment, with the Pointer field set to zero.

Checking each packet header in IPv6 fast path will have performance impact,
so I put the checking in ipv6_frag_rcv().

As the packet may be any kind of L4 protocol, I only checked some common
protocols' header length and handle others by (offset + 1) > skb->len.
Also use !(frag_off & htons(IP6_OFFSET)) to catch atomic fragments
(fragmented packet with only one fragment).

When send ICMP error message, if the 1st truncated fragment is ICMP message,
icmp6_send() will break as is_ineligible() return true. So I added a check
in is_ineligible() to let fragment packet with nexthdr ICMP but no ICMP header
return false.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Aviraj CJ <acj@cisco.com>
---
 net/ipv6/icmp.c       |  8 +++++++-
 net/ipv6/reassembly.c | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 7d3a3894f785..e9bb89131e02 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -158,7 +158,13 @@ static bool is_ineligible(const struct sk_buff *skb)
 		tp = skb_header_pointer(skb,
 			ptr+offsetof(struct icmp6hdr, icmp6_type),
 			sizeof(_type), &_type);
-		if (!tp || !(*tp & ICMPV6_INFOMSG_MASK))
+
+		/* Based on RFC 8200, Section 4.5 Fragment Header, return
+		 * false if this is a fragment packet with no icmp header info.
+		 */
+		if (!tp && frag_off != 0)
+			return false;
+		else if (!tp || !(*tp & ICMPV6_INFOMSG_MASK))
 			return true;
 	}
 	return false;
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1f5d4d196dcc..c8cf1bbad74a 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -42,6 +42,8 @@
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 
 #include <net/sock.h>
 #include <net/snmp.h>
@@ -322,7 +324,9 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	struct frag_queue *fq;
 	const struct ipv6hdr *hdr = ipv6_hdr(skb);
 	struct net *net = dev_net(skb_dst(skb)->dev);
-	int iif;
+	__be16 frag_off;
+	int iif, offset;
+	u8 nexthdr;
 
 	if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
 		goto fail_hdr;
@@ -351,6 +355,33 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 		return 1;
 	}
 
+	/* RFC 8200, Section 4.5 Fragment Header:
+	 * If the first fragment does not include all headers through an
+	 * Upper-Layer header, then that fragment should be discarded and
+	 * an ICMP Parameter Problem, Code 3, message should be sent to
+	 * the source of the fragment, with the Pointer field set to zero.
+	 */
+	nexthdr = hdr->nexthdr;
+	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
+	if (offset >= 0) {
+		/* Check some common protocols' header */
+		if (nexthdr == IPPROTO_TCP)
+			offset += sizeof(struct tcphdr);
+		else if (nexthdr == IPPROTO_UDP)
+			offset += sizeof(struct udphdr);
+		else if (nexthdr == IPPROTO_ICMPV6)
+			offset += sizeof(struct icmp6hdr);
+		else
+			offset += 1;
+
+		if (!(frag_off & htons(IP6_OFFSET)) && offset > skb->len) {
+			__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
+					IPSTATS_MIB_INHDRERRORS);
+			icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
+			return -1;
+		}
+	}
+
 	iif = skb->dev ? skb->dev->ifindex : 0;
 	fq = fq_find(net, fhdr->identification, hdr, iif);
 	if (fq) {
-- 
2.26.2.Cisco

