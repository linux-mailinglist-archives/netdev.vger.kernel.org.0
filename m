Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D88E141D4D
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 11:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgASKcY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Jan 2020 05:32:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53781 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726744AbgASKcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 05:32:24 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-_ttaMflqOxiZA-LFqV1fAw-1; Sun, 19 Jan 2020 05:32:18 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E8F1800D50;
        Sun, 19 Jan 2020 10:32:17 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-110.ams2.redhat.com [10.36.117.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B73F0108438D;
        Sun, 19 Jan 2020 10:32:15 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH iproute2-next v2] ip: xfrm: add espintcp encapsulation
Date:   Sun, 19 Jan 2020 11:32:09 +0100
Message-Id: <110d0a77532fcd895597f7087d1f408aadbfeb5d.1579429631.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: _ttaMflqOxiZA-LFqV1fAw-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While at it, convert xfrm_xfrma_print and xfrm_encap_type_parse to use
the UAPI macros for encap_type as suggested by David Ahern, and add the
UAPI udp.h header (sync'd from ipsec-next to get the TCP_ENCAP_ESPINTCP
definition).

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
v2: add udp.h header and use the macros

 include/uapi/linux/udp.h | 47 ++++++++++++++++++++++++++++++++++++++++
 ip/ipxfrm.c              | 14 ++++++++----
 ip/xfrm_state.c          |  2 +-
 man/man8/ip-xfrm.8       |  4 ++--
 4 files changed, 60 insertions(+), 7 deletions(-)
 create mode 100644 include/uapi/linux/udp.h

diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
new file mode 100644
index 000000000000..2d1f561b89d2
--- /dev/null
+++ b/include/uapi/linux/udp.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * INET		An implementation of the TCP/IP protocol suite for the LINUX
+ *		operating system.  INET is implemented using the  BSD Socket
+ *		interface as the means of communication with the user level.
+ *
+ *		Definitions for the UDP protocol.
+ *
+ * Version:	@(#)udp.h	1.0.2	04/28/93
+ *
+ * Author:	Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ */
+#ifndef _UDP_H
+#define _UDP_H
+
+#include <linux/types.h>
+
+struct udphdr {
+	__be16	source;
+	__be16	dest;
+	__be16	len;
+	__sum16	check;
+};
+
+/* UDP socket options */
+#define UDP_CORK	1	/* Never send partially complete segments */
+#define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
+#define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
+#define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
+#define UDP_SEGMENT	103	/* Set GSO segmentation size */
+#define UDP_GRO		104	/* This socket can receive UDP GRO packets */
+
+/* UDP encapsulation types */
+#define UDP_ENCAP_ESPINUDP_NON_IKE	1 /* draft-ietf-ipsec-nat-t-ike-00/01 */
+#define UDP_ENCAP_ESPINUDP	2 /* draft-ietf-ipsec-udp-encaps-06 */
+#define UDP_ENCAP_L2TPINUDP	3 /* rfc2661 */
+#define UDP_ENCAP_GTP0		4 /* GSM TS 09.60 */
+#define UDP_ENCAP_GTP1U		5 /* 3GPP TS 29.060 */
+#define UDP_ENCAP_RXRPC		6
+#define TCP_ENCAP_ESPINTCP	7 /* Yikes, this is really xfrm encap types. */
+
+#endif /* _UDP_H */
diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index 32f560933a47..fec206abc1f0 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -34,6 +34,7 @@
 #include <netdb.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
+#include <linux/udp.h>
 
 #include "utils.h"
 #include "xfrm.h"
@@ -753,12 +754,15 @@ void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
 
 		fprintf(fp, "type ");
 		switch (e->encap_type) {
-		case 1:
+		case UDP_ENCAP_ESPINUDP_NON_IKE:
 			fprintf(fp, "espinudp-nonike ");
 			break;
-		case 2:
+		case UDP_ENCAP_ESPINUDP:
 			fprintf(fp, "espinudp ");
 			break;
+		case TCP_ENCAP_ESPINTCP:
+			fprintf(fp, "espintcp ");
+			break;
 		default:
 			fprintf(fp, "%u ", e->encap_type);
 			break;
@@ -1208,9 +1212,11 @@ int xfrm_encap_type_parse(__u16 *type, int *argcp, char ***argvp)
 	char **argv = *argvp;
 
 	if (strcmp(*argv, "espinudp-nonike") == 0)
-		*type = 1;
+		*type = UDP_ENCAP_ESPINUDP_NON_IKE;
 	else if (strcmp(*argv, "espinudp") == 0)
-		*type = 2;
+		*type = UDP_ENCAP_ESPINUDP;
+	else if (strcmp(*argv, "espintcp") == 0)
+		*type = TCP_ENCAP_ESPINTCP;
 	else
 		invarg("ENCAP-TYPE value is invalid", *argv);
 
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index b03ccc5807e9..df2d50c3843b 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -130,7 +130,7 @@ static void usage(void)
 		"LIMIT-LIST := [ LIMIT-LIST ] limit LIMIT\n"
 		"LIMIT := { time-soft | time-hard | time-use-soft | time-use-hard } SECONDS |\n"
 		"         { byte-soft | byte-hard } SIZE | { packet-soft | packet-hard } COUNT\n"
-		"ENCAP := { espinudp | espinudp-nonike } SPORT DPORT OADDR\n"
+		"ENCAP := { espinudp | espinudp-nonike | espintcp } SPORT DPORT OADDR\n"
 		"DIR := in | out\n");
 
 	exit(-1);
diff --git a/man/man8/ip-xfrm.8 b/man/man8/ip-xfrm.8
index cfce1e40b7f7..f99f30bb448a 100644
--- a/man/man8/ip-xfrm.8
+++ b/man/man8/ip-xfrm.8
@@ -207,7 +207,7 @@ ip-xfrm \- transform configuration
 
 .ti -8
 .IR ENCAP " :="
-.RB "{ " espinudp " | " espinudp-nonike " }"
+.RB "{ " espinudp " | " espinudp-nonike " | " espintcp " }"
 .IR SPORT " " DPORT " " OADDR
 
 .ti -8
@@ -548,7 +548,7 @@ sets limits in seconds, bytes, or numbers of packets.
 .TP
 .I ENCAP
 encapsulates packets with protocol
-.BR espinudp " or " espinudp-nonike ","
+.BR espinudp ", " espinudp-nonike ", or " espintcp ","
 .RI "using source port " SPORT ", destination port "  DPORT
 .RI ", and original address " OADDR "."
 
-- 
2.25.0

