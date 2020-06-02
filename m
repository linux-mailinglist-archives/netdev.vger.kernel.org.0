Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FED11EB6FD
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgFBIF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:05:59 -0400
Received: from static-27.netfusion.at ([83.215.238.27]:56064 "EHLO
        mail.inliniac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgFBIF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 04:05:58 -0400
Received: by mail.inliniac.net (Postfix, from userid 108)
        id 5BD4F1A3B; Tue,  2 Jun 2020 10:08:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on tulpe.vuurmuur.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        SURBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.2
Received: from z440.inliniac.lan (a80-127-179-75.adsl.xs4all.nl [80.127.179.75])
        (Authenticated sender: victor)
        by mail.inliniac.net (Postfix) with ESMTPSA id 1C6E510C;
        Tue,  2 Jun 2020 10:07:56 +0200 (CEST)
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
Subject: [PATCH net-next v2] af-packet: new flag to indicate all csums are good
Date:   Tue,  2 Jun 2020 10:05:33 +0200
Message-Id: <20200602080535.1427-1-victor@inliniac.net>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new flag (TP_STATUS_CSUM_UNNECESSARY) to indicate
that the driver has completely validated the checksums in the packet.

The TP_STATUS_CSUM_UNNECESSARY flag differs from TP_STATUS_CSUM_VALID
in that the new flag will only be set if all the layers are valid,
while TP_STATUS_CSUM_VALID is set as well if only the IP layer is valid.

The name is derived from the skb->ip_summed setting CHECKSUM_UNNECESSARY.

Security tools such as Suricata, Snort, Zeek/Bro need to know not
only that a packet has not been corrupted, but also that the
checksums are correct. Without this an attacker could send a packet,
for example a TCP RST packet, that would be accepted by the
security tool, but rejected by the end host creating an impendance
mismatch.

To avoid this scenario tools currently will have to (re)calcultate/validate
the checksums as well. With this patch this becomes unnecessary for many
of the packets.

This patch has been tested with Suricata with the virtio driver,
where it reduced the ammount of time spent in the Suricata TCP
checksum validation to about half.

Signed-off-by: Victor Julien <victor@inliniac.net>
---
 Documentation/networking/packet_mmap.rst | 80 +++++++++++++-----------
 include/uapi/linux/if_packet.h           |  1 +
 net/packet/af_packet.c                   | 11 ++--
 3 files changed, 52 insertions(+), 40 deletions(-)

diff --git a/Documentation/networking/packet_mmap.rst b/Documentation/networking/packet_mmap.rst
index 6c009ceb1183..1711be47d61d 100644
--- a/Documentation/networking/packet_mmap.rst
+++ b/Documentation/networking/packet_mmap.rst
@@ -437,42 +437,50 @@ and the following flags apply:
 Capture process
 ^^^^^^^^^^^^^^^
 
-     from include/linux/if_packet.h
-
-     #define TP_STATUS_COPY          (1 << 1)
-     #define TP_STATUS_LOSING        (1 << 2)
-     #define TP_STATUS_CSUMNOTREADY  (1 << 3)
-     #define TP_STATUS_CSUM_VALID    (1 << 7)
-
-======================  =======================================================
-TP_STATUS_COPY		This flag indicates that the frame (and associated
-			meta information) has been truncated because it's
-			larger than tp_frame_size. This packet can be
-			read entirely with recvfrom().
-
-			In order to make this work it must to be
-			enabled previously with setsockopt() and
-			the PACKET_COPY_THRESH option.
-
-			The number of frames that can be buffered to
-			be read with recvfrom is limited like a normal socket.
-			See the SO_RCVBUF option in the socket (7) man page.
-
-TP_STATUS_LOSING	indicates there were packet drops from last time
-			statistics where checked with getsockopt() and
-			the PACKET_STATISTICS option.
-
-TP_STATUS_CSUMNOTREADY	currently it's used for outgoing IP packets which
-			its checksum will be done in hardware. So while
-			reading the packet we should not try to check the
-			checksum.
-
-TP_STATUS_CSUM_VALID	This flag indicates that at least the transport
-			header checksum of the packet has been already
-			validated on the kernel side. If the flag is not set
-			then we are free to check the checksum by ourselves
-			provided that TP_STATUS_CSUMNOTREADY is also not set.
-======================  =======================================================
+from include/linux/if_packet.h::
+
+     #define TP_STATUS_COPY		(1 << 1)
+     #define TP_STATUS_LOSING		(1 << 2)
+     #define TP_STATUS_CSUMNOTREADY	(1 << 3)
+     #define TP_STATUS_CSUM_VALID	(1 << 7)
+     #define TP_STATUS_CSUM_UNNECESSARY	(1 << 8)
+
+==========================  =====================================================
+TP_STATUS_COPY		    This flag indicates that the frame (and associated
+			    meta information) has been truncated because it's
+			    larger than tp_frame_size. This packet can be
+			    read entirely with recvfrom().
+
+			    In order to make this work it must to be
+			    enabled previously with setsockopt() and
+			    the PACKET_COPY_THRESH option.
+
+			    The number of frames that can be buffered to
+			    be read with recvfrom is limited like a normal socket.
+			    See the SO_RCVBUF option in the socket (7) man page.
+
+TP_STATUS_LOSING	    indicates there were packet drops from last time
+			    statistics where checked with getsockopt() and
+			    the PACKET_STATISTICS option.
+
+TP_STATUS_CSUMNOTREADY	    currently it's used for outgoing IP packets which
+			    its checksum will be done in hardware. So while
+			    reading the packet we should not try to check the
+			    checksum.
+
+TP_STATUS_CSUM_VALID	    This flag indicates that at least the transport
+			    header checksum of the packet has been already
+			    validated on the kernel side. If the flag is not set
+			    then we are free to check the checksum by ourselves
+			    provided that TP_STATUS_CSUMNOTREADY is also not set.
+
+TP_STATUS_CSUM_UNNECESSARY  This flag indicates that the driver validated all
+			    the packets csums. If it is not set it might be that
+			    the driver doesn't support this, or that one of the
+			    layers csums is bad. TP_STATUS_CSUM_VALID may still
+			    be set if the transport layer csum is correct or
+			    if the driver supports only this mode.
+==========================  =====================================================
 
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
index 29bd405adbbd..94e213537646 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2215,10 +2215,13 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		status |= TP_STATUS_CSUMNOTREADY;
-	else if (skb->pkt_type != PACKET_OUTGOING &&
-		 (skb->ip_summed == CHECKSUM_COMPLETE ||
-		  skb_csum_unnecessary(skb)))
-		status |= TP_STATUS_CSUM_VALID;
+	else if (skb->pkt_type != PACKET_OUTGOING) {
+		if (skb->ip_summed == CHECKSUM_UNNECESSARY)
+			status |= TP_STATUS_CSUM_UNNECESSARY | TP_STATUS_CSUM_VALID;
+		else if (skb->ip_summed == CHECKSUM_COMPLETE ||
+			 skb_csum_unnecessary(skb))
+			status |= TP_STATUS_CSUM_VALID;
+	}
 
 	if (snaplen > res)
 		snaplen = res;
-- 
2.17.1

