Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C37A25DA32
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgIDNnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:43:40 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:34021 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730502AbgIDNn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599227007; x=1630763007;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SBTfKd85yjkvCUVU1mYg4+pcLmsGUnhzQ3U/pJ5HYpo=;
  b=OAvMKFSPbXgij4mJiekp1nR+z/0KO2s397cmM+8qebXBemYG9WLW0WzA
   62gIRYJIwkPq1DytJ99Fs8KSU66yyKCtUjjHyy6W+n9AtOqpffu9bjGYp
   3uLJBB+BF91QTYMi/mATB6VuvogjO1A/QpObvTjdWksNDiihPa7oi+lQt
   0=;
X-IronPort-AV: E=Sophos;i="5.76,389,1592870400"; 
   d="scan'208";a="72413418"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Sep 2020 13:32:11 +0000
Received: from EX13D07EUA004.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id A92DEA2212;
        Fri,  4 Sep 2020 13:32:09 +0000 (UTC)
Received: from ucc1378de9e2c58.ant.amazon.com (10.43.162.38) by
 EX13D07EUA004.ant.amazon.com (10.43.165.172) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Sep 2020 13:32:04 +0000
From:   Stefan Nuernberger <snu@amazon.com>
To:     <orcohen@paloaltonetworks.com>
CC:     <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Stefan Nuernberger <snu@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Amit Shah <aams@amazon.com>, <stable@vger.kernel.org>
Subject: [PATCH] net/packet: fix overflow in tpacket_rcv
Date:   Fri, 4 Sep 2020 15:30:52 +0200
Message-ID: <20200904133052.20299-1-snu@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <CAM6JnLf_8nwzq+UGO+amXpeApCDarJjwzOEHQd5qBhU7YKm3DQ@mail.gmail.com>
References: <CAM6JnLf_8nwzq+UGO+amXpeApCDarJjwzOEHQd5qBhU7YKm3DQ@mail.gmail.com>
MIME-Version: 1.0
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13d09UWA002.ant.amazon.com (10.43.160.186) To
 EX13D07EUA004.ant.amazon.com (10.43.165.172)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Cohen <orcohen@paloaltonetworks.com>

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

[ snu: backported to 4.9, changed tp_drops counting/locking ]

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



