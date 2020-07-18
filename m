Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F2D224A2E
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 11:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgGRJYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 05:24:50 -0400
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:17572 "EHLO
        bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgGRJYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 05:24:49 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2020 05:24:48 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1947; q=dns/txt; s=iport;
  t=1595064289; x=1596273889;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WXHweetNurO6QLaPH79F1tHWP4XFhUThgJN70Mv6QcA=;
  b=XtU7NVYqgDzjQBgcBZ/BwrL9bvjzqXxUXRmjaz1LJpZ3AUxQ90unVzsk
   yYIbUxoVk8e1D7aZDPyIQ7T3fzVFcqoaP3bYI12KJ2wIGGOwQ3Oqy2GC9
   iQfVKKN2md+Jixmf3utA5VBdSKYNUSkA9nQLT3C6xn6ICT0JdPgZv7vra
   Q=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CMAABtvRJf/xjFo0hgHQEBAQEJARIBB?=
 =?us-ascii?q?QUBgXgGAQsBg2wBIBIsjTSGTAEBAQEBAQaLSI97gX0LAQEBDi8EAQGETIIcJTY?=
 =?us-ascii?q?HDgIQAQEFAQEBAgEGBG2FZ4YdCwFGKYEVCwiDJoJYJak9gXUziH6BQBSBJAGIA?=
 =?us-ascii?q?oYCgQePEgSBQwGZbZoWBoJhmVQPIZ9ILbB7gVoJKoFXTSOBboFLUBkNjioXjiw?=
 =?us-ascii?q?5AzA3AgYIAQEDCY8lAQE?=
X-IronPort-AV: E=Sophos;i="5.75,366,1589241600"; 
   d="scan'208";a="156060473"
Received: from vla196-nat.cisco.com (HELO bgl-core-2.cisco.com) ([72.163.197.24])
  by bgl-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Jul 2020 09:17:33 +0000
Received: from SRIRAKR2-M-R0A8.cisco.com ([10.65.75.112])
        by bgl-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id 06I9HWXw006124;
        Sat, 18 Jul 2020 09:17:32 GMT
From:   Sriram Krishnan <srirakr2@cisco.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] AF_PACKET doesnt strip VLAN information
Date:   Sat, 18 Jul 2020 14:47:31 +0530
Message-Id: <20200718091732.8761-1-srirakr2@cisco.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.65.75.112, [10.65.75.112]
X-Outbound-Node: bgl-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an application sends with AF_PACKET and places a vlan header on
the raw packet; then the AF_PACKET needs to move the tag into the skb
so that it gets processed normally through the rest of the transmit
path.

This is particularly a problem on Hyper-V where the host only allows
vlan in the offload info.

Cc: xe-linux-external@cisco.com
Cc: Sriram Krishnan <srirakr2@cisco.com>
Signed-off-by: Sriram Krishnan <srirakr2@cisco.com>
---
 net/packet/af_packet.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 29bd405adbbd..10988639561e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1857,15 +1857,35 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
-static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
+static int packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 {
 	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
 	    sock->type == SOCK_RAW) {
+		__be16 ethertype;
+
 		skb_reset_mac_header(skb);
+
+		ethertype = eth_hdr(skb)->h_proto;
+		/*
+		 * If Vlan tag is present in the packet
+		 *  move it to skb
+		*/
+		if (eth_type_vlan(ethertype)) {
+			int err;
+			__be16 vlan_tci;
+
+			err = __skb_vlan_pop(skb, &vlan_tci);
+			if (unlikely(err))
+				return err;
+
+			__vlan_hwaccel_put_tag(skb, ethertype, vlan_tci);
+		}
+
 		skb->protocol = dev_parse_header_protocol(skb);
 	}
 
 	skb_probe_transport_header(skb);
+	return 0;
 }
 
 /*
@@ -1987,7 +2007,9 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
 
-	packet_parse_headers(skb, sock);
+	err = packet_parse_headers(skb, sock);
+	if (err)
+		goto out_unlock;
 
 	dev_queue_xmit(skb);
 	rcu_read_unlock();
-- 
2.24.0

