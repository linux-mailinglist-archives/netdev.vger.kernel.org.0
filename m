Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5918CC1AEB
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 07:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfI3FYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 01:24:01 -0400
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:64454 "EHLO
        bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfI3FYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 01:24:01 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2019 01:24:00 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1841; q=dns/txt; s=iport;
  t=1569821040; x=1571030640;
  h=from:to:cc:subject:date:message-id;
  bh=G+siyYRdHd2n4HbLETGj+hla7mCl53/mKPxeUkMl8FQ=;
  b=ZH1r+kg1Yvfm7x2IUvxrT3n7yAg/rzGTU+bkkIPUa2+IQ3TxO9mPMaUR
   c8rYKLkniXtQ96bcnrbj/13lrWd4NaMrIhdBuzROne/HMiq1GukpKR1hm
   1/+gJNA2/oOSsuTJQIF90C/Z96zXD35mvlhTfQ3/YE0TRvuGglf7/dqHo
   o=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AsAQA7jpFd/xjFo0hmHAEBAQQBAQwEA?=
 =?us-ascii?q?QGBVAYBAQsBg10gEiqNHoZEBQGBMol5jy+BewkBAQEOLwEBhECDXzUIDgIMAQE?=
 =?us-ascii?q?EAQEBAgEFBG2FOYV5UimBFQsIgyKBdxSqd4F0M4hzgUgUgSABhzSFaYEHjwgEg?=
 =?us-ascii?q?S8BlRyWSwaCJpULAhmZNQEtpzuBUwE2gVhNI4FugU5QEBSBWheOKjkDMJEOAQE?=
X-IronPort-AV: E=Sophos;i="5.64,565,1559520000"; 
   d="scan'208";a="119743880"
Received: from vla196-nat.cisco.com (HELO bgl-core-4.cisco.com) ([72.163.197.24])
  by bgl-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 30 Sep 2019 05:16:45 +0000
Received: from ubuntuServ16.cisco.com ([10.142.88.17])
        by bgl-core-4.cisco.com (8.15.2/8.15.2) with ESMTP id x8U5Gih6001012;
        Mon, 30 Sep 2019 05:16:45 GMT
From:   Sriram Krishnan <srirakr2@cisco.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] AF_PACKET doesnt strip VLAN information
Date:   Sat, 28 Sep 2019 10:28:24 +0530
Message-Id: <1569646705-10585-1-git-send-email-srirakr2@cisco.com>
X-Mailer: git-send-email 2.7.4
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.142.88.17, [10.142.88.17]
X-Outbound-Node: bgl-core-4.cisco.com
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
---
 net/packet/af_packet.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e2742b0..cfe0904 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1849,15 +1849,35 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
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
@@ -1979,7 +1999,9 @@ static int packet_sendmsg_spkt(struct socket *sock, struct msghdr *msg,
 	if (unlikely(extra_len == 4))
 		skb->no_fcs = 1;
 
-	packet_parse_headers(skb, sock);
+	err = packet_parse_headers(skb, sock);
+	if (err)
+		goto out_unlock;
 
 	dev_queue_xmit(skb);
 	rcu_read_unlock();
-- 
2.7.4

