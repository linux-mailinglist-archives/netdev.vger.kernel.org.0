Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1F027307F
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgIURFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:05:32 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:45832 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgIURFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600707921; x=1632243921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+xvJTPi/xd8SPHkALoZvzIyD6vBFGkU/bxuPC1VHTbk=;
  b=uPJHpYr3+TOHmCPVA6mmtpKLuSqVrr4WC2Fkn/Hq16AYdpZgsyPkOsBr
   2mj0KrLfRZdDS6fS2NjmYF7kAsn752Rzk0pXYz/SWgVJ4JDCI0aLlFP7Y
   ixKAk/OH3ngObO0QdT4XiC7y1W+j4X2bJsgFY6dvP/xLnAYQYC6lHIXpQ
   0=;
X-IronPort-AV: E=Sophos;i="5.77,287,1596499200"; 
   d="scan'208";a="55405859"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Sep 2020 17:05:19 +0000
Received: from EX13D07EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 64BCEA06FD;
        Mon, 21 Sep 2020 17:05:17 +0000 (UTC)
Received: from ucc1378de9e2c58.ant.amazon.com (10.43.160.229) by
 EX13D07EUA004.ant.amazon.com (10.43.165.172) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 21 Sep 2020 17:05:11 +0000
From:   Stefan Nuernberger <snu@amazon.com>
To:     <carnil@debian.org>
CC:     <aams@amazon.de>, <dwmw@amazon.co.uk>, <edumazet@google.com>,
        <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        <orcohen@paloaltonetworks.com>, <snu@amazon.de>,
        <stable@vger.kernel.org>, Stefan Nuernberger <snu@amazon.com>,
        Amit Shah <aams@amazon.com>
Subject: [PATCH] net/packet: fix overflow in tpacket_rcv
Date:   Mon, 21 Sep 2020 19:02:50 +0200
Message-ID: <20200921170250.28535-1-snu@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200905065422.GA556394@eldamar.local>
References: <20200905065422.GA556394@eldamar.local>
MIME-Version: 1.0
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D01UWB004.ant.amazon.com (10.43.161.157) To
 EX13D07EUA004.ant.amazon.com (10.43.165.172)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Cohen <orcohen@paloaltonetworks.com>

commit acf69c946233259ab4d64f8869d4037a198c7f06 upstream.

Using tp_reserve to calculate netoff can overflow as
tp_reserve is unsigned int and netoff is unsigned short.

This may lead to macoff receving a smaller value then
sizeof(struct virtio_net_hdr), and if po->has_vnet_hdr
is set, an out-of-bounds write will occur when
calling virtio_net_hdr_from_skb.

The bug is fixed by converting netoff to unsigned int
and checking if it exceeds USHRT_MAX.

This addresses CVE-2020-14386

Fixes: 8913336a7e8d ("packet: add PACKET_RESERVE sockopt")
Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>

[ snu: backported to pre-5.3, changed tp_drops counting/locking ]

Signed-off-by: Stefan Nuernberger <snu@amazon.com>
CC: David Woodhouse <dwmw@amazon.co.uk>
CC: Amit Shah <aams@amazon.com>
CC: stable@vger.kernel.org
---
 net/packet/af_packet.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index fb643945e424..b5b79f501541 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2161,7 +2161,8 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	int skb_len = skb->len;
 	unsigned int snaplen, res;
 	unsigned long status = TP_STATUS_USER;
-	unsigned short macoff, netoff, hdrlen;
+	unsigned short macoff, hdrlen;
+	unsigned int netoff;
 	struct sk_buff *copy_skb = NULL;
 	struct timespec ts;
 	__u32 ts_status;
@@ -2223,6 +2224,12 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		}
 		macoff = netoff - maclen;
 	}
+	if (netoff > USHRT_MAX) {
+		spin_lock(&sk->sk_receive_queue.lock);
+		po->stats.stats1.tp_drops++;
+		spin_unlock(&sk->sk_receive_queue.lock);
+		goto drop_n_restore;
+	}
 	if (po->tp_version <= TPACKET_V2) {
 		if (macoff + snaplen > po->rx_ring.frame_size) {
 			if (po->copy_thresh &&
-- 
2.28.0




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



