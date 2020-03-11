Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3315181EA6
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgCKRFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:05:44 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:33681 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgCKRFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 13:05:43 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2020 13:05:42 EDT
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 02BGsSfk025391
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 11 Mar 2020 17:54:29 +0100
From:   Paolo Lungaroni <paolo.lungaroni@cnit.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>
Subject: [net] seg6: fix SRv6 L2 tunnels to use IANA-assigned protocol number
Date:   Wed, 11 Mar 2020 17:54:06 +0100
Message-Id: <20200311165406.22044-1-paolo.lungaroni@cnit.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Internet Assigned Numbers Authority (IANA) has recently assigned
a protocol number value of 143 for Ethernet [1].

Before this assignment, encapsulation mechanisms such as Segment Routing
used the IPv6-NoNxt protocol number (59) to indicate that the encapsulated
payload is an Ethernet frame.

In this patch, we add the definition of the Ethernet protocol number to the
kernel headers and update the SRv6 L2 tunnels to use it.

[1] https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml

Signed-off-by: Paolo Lungaroni <paolo.lungaroni@cnit.it>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Acked-by: Ahmed Abdelsalam <ahmed.abdelsalam@gssi.it>
---
 include/uapi/linux/in.h  | 2 ++
 net/ipv6/seg6_iptunnel.c | 2 +-
 net/ipv6/seg6_local.c    | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 1521073b6348..8533bf07450f 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -74,6 +74,8 @@ enum {
 #define IPPROTO_UDPLITE		IPPROTO_UDPLITE
   IPPROTO_MPLS = 137,		/* MPLS in IP (RFC 4023)		*/
 #define IPPROTO_MPLS		IPPROTO_MPLS
+  IPPROTO_ETHERNET = 143,	/* Ethernet-within-IPv6 Encapsulation	*/
+#define IPPROTO_ETHERNET	IPPROTO_ETHERNET
   IPPROTO_RAW = 255,		/* Raw IP packets			*/
 #define IPPROTO_RAW		IPPROTO_RAW
   IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index ab7f124ff5d7..8c52efe299cc 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -268,7 +268,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 		skb_mac_header_rebuild(skb);
 		skb_push(skb, skb->mac_len);
 
-		err = seg6_do_srh_encap(skb, tinfo->srh, NEXTHDR_NONE);
+		err = seg6_do_srh_encap(skb, tinfo->srh, IPPROTO_ETHERNET);
 		if (err)
 			return err;
 
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 7cbc19731997..8165802d8e05 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -282,7 +282,7 @@ static int input_action_end_dx2(struct sk_buff *skb,
 	struct net_device *odev;
 	struct ethhdr *eth;
 
-	if (!decap_and_validate(skb, NEXTHDR_NONE))
+	if (!decap_and_validate(skb, IPPROTO_ETHERNET))
 		goto drop;
 
 	if (!pskb_may_pull(skb, ETH_HLEN))
-- 
2.20.1

