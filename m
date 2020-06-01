Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7DE1EB07F
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgFAUzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:55:31 -0400
Received: from static-27.netfusion.at ([83.215.238.27]:55874 "EHLO
        mail.inliniac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbgFAUza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 16:55:30 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jun 2020 16:55:29 EDT
Received: by mail.inliniac.net (Postfix, from userid 108)
        id 0E40A80C; Mon,  1 Jun 2020 22:52:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on tulpe.vuurmuur.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        SURBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.2
Received: from z440.inliniac.lan (a80-127-179-75.adsl.xs4all.nl [80.127.179.75])
        (Authenticated sender: victor)
        by mail.inliniac.net (Postfix) with ESMTPSA id 3F64410C;
        Mon,  1 Jun 2020 22:52:11 +0200 (CEST)
From:   Victor Julien <victor@inliniac.net>
To:     netdev@vger.kernel.org
Cc:     victor@inliniac.net, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Mao Wenan <maowenan@huawei.com>, Arnd Bergmann <arnd@arndb.de>,
        Neil Horman <nhorman@tuxdriver.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] af-packet: new flag to indicate all csums are good
Date:   Mon,  1 Jun 2020 22:49:37 +0200
Message-Id: <20200601204938.13302-1-victor@inliniac.net>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new flag (TP_STATUS_CSUM_UNNECESSARY) to indicate
that the driver has completely validated the checksums in the packet.

The flag differs from TP_STATUS_CSUM_VALID in that it will only
be set if all the layers are valid, while TP_STATUS_CSUM_VALID is
set as well if only the IP layer is valid.

The name is derived from the skb->ip_summed setting CHECKSUM_UNNECESSARY.

Security tools such as Suricata, Snort, Zeek/Bro need to know not
only that a packet has not been corrupted, but also that the
checksums are correct. Without this an attacker could send a packet,
for example a TCP RST packet, that would be accepted by the
security tool, but rejected by the end host.

To avoid this scenario tools will have to (re)calcultate/validate
the checksum as well.

This patch has been tested with Suricata with the virtio driver,
where it reduced the ammount of time spent in the Suricata TCP
checksum validation to about half.

Signed-off-by: Victor Julien <victor@inliniac.net>
---
 Documentation/networking/packet_mmap.rst | 6 ++++++
 include/uapi/linux/if_packet.h           | 1 +
 net/packet/af_packet.c                   | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/Documentation/networking/packet_mmap.rst b/Documentation/networking/packet_mmap.rst
index 6c009ceb1183..f670292e6d95 100644
--- a/Documentation/networking/packet_mmap.rst
+++ b/Documentation/networking/packet_mmap.rst
@@ -472,6 +472,12 @@ TP_STATUS_CSUM_VALID	This flag indicates that at least the transport
 			validated on the kernel side. If the flag is not set
 			then we are free to check the checksum by ourselves
 			provided that TP_STATUS_CSUMNOTREADY is also not set.
+TP_STATUS_CSUM_UNNECESSARY  This flag indicates that the driver validated all
+                        the packets csums. If it is not set it might be that
+                        the driver doesn't support this, or that one of the
+                        layers csums is bad. TP_STATUS_CSUM_VALID may still
+                        be set if the transport layer csum is correct or
+                        if the driver supports only this mode.
 ======================  =======================================================
 
 for convenience there are also the following defines::
diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
index 3d884d68eb30..76a5c762e2e0 100644
--- a/include/uapi/linux/if_packet.h
+++ b/include/uapi/linux/if_packet.h
@@ -113,6 +113,7 @@ struct tpacket_auxdata {
 #define TP_STATUS_BLK_TMO		(1 << 5)
 #define TP_STATUS_VLAN_TPID_VALID	(1 << 6) /* auxdata has valid tp_vlan_tpid */
 #define TP_STATUS_CSUM_VALID		(1 << 7)
+#define TP_STATUS_CSUM_UNNECESSARY	(1 << 8)
 
 /* Tx ring - header status */
 #define TP_STATUS_AVAILABLE	      0
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 29bd405adbbd..5dd8bad9bc23 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2215,6 +2215,9 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		status |= TP_STATUS_CSUMNOTREADY;
+	else if (skb->pkt_type != PACKET_OUTGOING &&
+		 skb->ip_summed == CHECKSUM_UNNECESSARY)
+		status |= (TP_STATUS_CSUM_UNNECESSARY | TP_STATUS_CSUM_VALID);
 	else if (skb->pkt_type != PACKET_OUTGOING &&
 		 (skb->ip_summed == CHECKSUM_COMPLETE ||
 		  skb_csum_unnecessary(skb)))
-- 
2.17.1

