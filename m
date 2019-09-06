Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D681AB0CA
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 05:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392083AbfIFDB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 23:01:56 -0400
Received: from alln-iport-5.cisco.com ([173.37.142.92]:22445 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731491AbfIFDBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 23:01:55 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Sep 2019 23:01:54 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3688; q=dns/txt; s=iport;
  t=1567738914; x=1568948514;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=29g/MjG/SRZo9iSryE61I7U40l+EK7iDhodwVw1msDc=;
  b=NkgqaJCONYmFd3y8/zjtuYSX2CRaYkC2/3M6jfHtLiq+8D9H5MEogpKO
   uN68DM8tx/skeXF1MyXFl4Czm57rQdMm4c5g0O7vPt5zx0YsdlnibwTXO
   ENId8STpGETnjknyxWoFyHs3KeHpLxBdeN5jRNEOxhXZ51KXF++GbxsXP
   A=;
X-IronPort-AV: E=Sophos;i="5.64,472,1559520000"; 
   d="scan'208";a="325908215"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 06 Sep 2019 02:54:50 +0000
Received: from sjc-ads-4595.cisco.com (sjc-ads-4595.cisco.com [10.28.38.115])
        by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTP id x862snTN032447;
        Fri, 6 Sep 2019 02:54:49 GMT
Received: by sjc-ads-4595.cisco.com (Postfix, from userid 19784)
        id 8FB421223; Thu,  5 Sep 2019 19:54:49 -0700 (PDT)
From:   Enke Chen <enkechen@cisco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Cc:     enkechen@cisco.com, linux-kernel@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: [PATCH] net: Remove the source address setting in connect() for UDP
Date:   Thu,  5 Sep 2019 19:54:37 -0700
Message-Id: <20190906025437.613-1-enkechen@cisco.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.28.38.115, sjc-ads-4595.cisco.com
X-Outbound-Node: rcdn-core-8.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The connect() system call for a UDP socket is for setting the destination
address and port. But the current code mistakenly sets the source address
for the socket as well. Remove the source address setting in connect() for
UDP in this patch.

Implications of the bug:

  - Packet drop:

    On a multi-homed device, an address assigned to any interface may
    qualify as a source address when originating a packet. If needed, the
    IP_PKTINFO option can be used to explicitly specify the source address.
    But with the source address being mistakenly set for the socket in
    connect(), a return packet (for the socket) destined to an interface
    address different from that source address would be wrongly dropped
    due to address mismatch.

    This can be reproduced easily. The dropped packets are shown in the
    following output by "netstat -s" for UDP:

          xxx packets to unknown port received

  - Source address selection:

    The source address, if unspecified via "bind()" or IP_PKTINFO, should
    be determined by routing at the time of packet origination, and not at
    the time when the connect() call is made. The difference matters as
    routing can change, e.g., by interface down/up events, and using a
    source address of an "down" interface is known to be problematic.

There is no backward compatibility issue here as the source address setting
in connect() is not needed anyway.

  - No impact on the source address selection when the source address
    is explicitly specified by "bind()", or by the "IP_PKTINFO" option.

  - In the case that the source address is not explicitly specified,
    the selection of the source address would be more accurate and
    reliable based on the up-to-date routing table.

Signed-off-by: Enke Chen <enkechen@cisco.com>
---
 net/ipv4/datagram.c |  7 -------
 net/ipv6/datagram.c | 15 +--------------
 2 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index f915abff1350..4065808ec6c1 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -64,13 +64,6 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 		err = -EACCES;
 		goto out;
 	}
-	if (!inet->inet_saddr)
-		inet->inet_saddr = fl4->saddr;	/* Update source address */
-	if (!inet->inet_rcv_saddr) {
-		inet->inet_rcv_saddr = fl4->saddr;
-		if (sk->sk_prot->rehash)
-			sk->sk_prot->rehash(sk);
-	}
 	inet->inet_daddr = fl4->daddr;
 	inet->inet_dport = usin->sin_port;
 	sk->sk_state = TCP_ESTABLISHED;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index ecf440a4f593..80388cd50dc3 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -197,19 +197,6 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 			goto out;
 
 		ipv6_addr_set_v4mapped(inet->inet_daddr, &sk->sk_v6_daddr);
-
-		if (ipv6_addr_any(&np->saddr) ||
-		    ipv6_mapped_addr_any(&np->saddr))
-			ipv6_addr_set_v4mapped(inet->inet_saddr, &np->saddr);
-
-		if (ipv6_addr_any(&sk->sk_v6_rcv_saddr) ||
-		    ipv6_mapped_addr_any(&sk->sk_v6_rcv_saddr)) {
-			ipv6_addr_set_v4mapped(inet->inet_rcv_saddr,
-					       &sk->sk_v6_rcv_saddr);
-			if (sk->sk_prot->rehash)
-				sk->sk_prot->rehash(sk);
-		}
-
 		goto out;
 	}
 
@@ -247,7 +234,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 	 *	destination cache for it.
 	 */
 
-	err = ip6_datagram_dst_update(sk, true);
+	err = ip6_datagram_dst_update(sk, false);
 	if (err) {
 		/* Restore the socket peer info, to keep it consistent with
 		 * the old socket state
-- 
2.19.1

