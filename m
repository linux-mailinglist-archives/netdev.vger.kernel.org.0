Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A741075B6
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKVQXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 11:23:52 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:32849 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbfKVQXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 11:23:52 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id xAMGN8QH031618
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Nov 2019 17:23:12 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <dav.lebrun@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next, v3 1/1] seg6: allow local packet processing for SRv6 End.DT6 behavior
Date:   Fri, 22 Nov 2019 17:22:42 +0100
Message-Id: <20191122162242.2574-2-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122162242.2574-1-andrea.mayer@uniroma2.it>
References: <20191122162242.2574-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

End.DT6 behavior makes use of seg6_lookup_nexthop() function which drops
all packets that are destined to be locally processed. However, DT* should
be able to deliver decapsulated packets that are destined to local
addresses. Function seg6_lookup_nexthop() is also used by DX6, so in order
to maintain compatibility I created another routing helper function which
is called seg6_lookup_any_nexthop(). This function is able to take into
account both packets that have to be processed locally and the ones that
are destined to be forwarded directly to another machine. Hence,
seg6_lookup_any_nexthop() is used in DT6 rather than seg6_lookup_nexthop()
to allow local delivery.

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 net/ipv6/seg6_local.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index e70567446f28..85a5447a3e8d 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -149,8 +149,9 @@ static void advance_nextseg(struct ipv6_sr_hdr *srh, struct in6_addr *daddr)
 	*daddr = *addr;
 }
 
-int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
-			u32 tbl_id)
+static int
+seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
+			u32 tbl_id, bool local_delivery)
 {
 	struct net *net = dev_net(skb->dev);
 	struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -158,6 +159,7 @@ int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 	struct dst_entry *dst = NULL;
 	struct rt6_info *rt;
 	struct flowi6 fl6;
+	int dev_flags = 0;
 
 	fl6.flowi6_iif = skb->dev->ifindex;
 	fl6.daddr = nhaddr ? *nhaddr : hdr->daddr;
@@ -182,7 +184,13 @@ int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 		dst = &rt->dst;
 	}
 
-	if (dst && dst->dev->flags & IFF_LOOPBACK && !dst->error) {
+	/* we want to discard traffic destined for local packet processing,
+	 * if @local_delivery is set to false.
+	 */
+	if (!local_delivery)
+		dev_flags |= IFF_LOOPBACK;
+
+	if (dst && (dst->dev->flags & dev_flags) && !dst->error) {
 		dst_release(dst);
 		dst = NULL;
 	}
@@ -199,6 +207,12 @@ int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 	return dst->error;
 }
 
+int seg6_lookup_nexthop(struct sk_buff *skb,
+			struct in6_addr *nhaddr, u32 tbl_id)
+{
+	return seg6_lookup_any_nexthop(skb, nhaddr, tbl_id, false);
+}
+
 /* regular endpoint function */
 static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 {
@@ -396,7 +410,7 @@ static int input_action_end_dt6(struct sk_buff *skb,
 
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
 
-	seg6_lookup_nexthop(skb, NULL, slwt->table);
+	seg6_lookup_any_nexthop(skb, NULL, slwt->table, true);
 
 	return dst_input(skb);
 
-- 
2.20.1

