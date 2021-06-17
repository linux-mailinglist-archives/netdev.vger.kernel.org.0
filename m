Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1D63ABA9A
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhFQR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:26:21 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:38930 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232113AbhFQR0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:26:19 -0400
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 15HHO2m7015392
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Jun 2021 19:24:02 +0200
From:   Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Subject: [iproute2-next v1] seg6: add support for SRv6 End.DT46 Behavior
Date:   Thu, 17 Jun 2021 19:23:54 +0200
Message-Id: <20210617172354.10607-1-paolo.lungaroni@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We introduce the new "End.DT46" action for supporting the SRv6 End.DT46
Behavior in iproute2.
The SRv6 End.DT46 Behavior, defined in RFC 8986 [1] section 4.8, can be
used to implement L3 VPNs based on Segment Routing over IPv6 networks in
multi-tenants environments and it is capable of handling both IPv4 and
IPv6 tenant traffic at the same time.
The SRv6 End.DT46 Behavior decapsulates the received packets and it
performs the IPv4 or IPv6 routing lookup in the routing table of the
tenant.

As for the End.DT4 and for the End.DT6 in VRF mode, the SRv6 End.DT46
Behavior leverages a VRF device in order to force the routing lookup into
the associated routing table using the "vrftable" attribute.

To make the End.DT46 work properly, it must be guaranteed that the
routing table used for routing lookup operations is bound to one and
only one VRF during the tunnel creation. Such constraint has to be
enforced by enabling the VRF strict_mode sysctl parameter, i.e.:

 $ sysctl -wq net.vrf.strict_mode=1

Note that the same approach is used for the End.DT4 Behavior and for the
End.DT6 Behavior in VRF mode.

An SRv6 End.DT46 Behavior instance can be created as follows:

 $ ip -6 route add 2001:db8::1 encap seg6local action End.DT46 vrftable 100 dev vrf100

Standard Output:
 $ ip -6 route show 2001:db8::1
 2001:db8::1  encap seg6local action End.DT46 vrftable 100 dev vrf100 metric 1024 pref medium

JSON Output:
$ ip -6 -j -p route show 2001:db8::1
[ {
        "dst": "2001:db8::1",
        "encap": "seg6local",
        "action": "End.DT46",
        "vrftable": 100,
        "dev": "vrf100",
        "metric": 1024,
        "flags": [ ],
        "pref": "medium"
} ]

This patch updates the route.8 man page and the ip route help with the
information related to End.DT46.
Considering that the same information was missing for the SRv6 End.DT4 and
the End.DT6 Behaviors, we have also added it.

[1] https://www.rfc-editor.org/rfc/rfc8986.html#name-enddt46-decapsulation-and-s

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
---
 include/uapi/linux/seg6_local.h |  2 ++
 ip/iproute.c                    |  4 +--
 ip/iproute_lwtunnel.c           |  1 +
 man/man8/ip-route.8.in          | 48 +++++++++++++++++++++++++++++++++
 4 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
index 85955514..ab724498 100644
--- a/include/uapi/linux/seg6_local.h
+++ b/include/uapi/linux/seg6_local.h
@@ -64,6 +64,8 @@ enum {
 	SEG6_LOCAL_ACTION_END_AM	= 14,
 	/* custom BPF action */
 	SEG6_LOCAL_ACTION_END_BPF	= 15,
+	/* decap and lookup of DA in v4 or v6 table */
+	SEG6_LOCAL_ACTION_END_DT46	= 16,
 
 	__SEG6_LOCAL_ACTION_MAX,
 };
diff --git a/ip/iproute.c b/ip/iproute.c
index c6d87e58..bdeb9644 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -107,8 +107,8 @@ static void usage(void)
 		"SEGMODE := [ encap | inline ]\n"
 		"SEG6LOCAL := action ACTION [ OPTIONS ] [ count ]\n"
 		"ACTION := { End | End.X | End.T | End.DX2 | End.DX6 | End.DX4 |\n"
-		"            End.DT6 | End.DT4 | End.B6 | End.B6.Encaps | End.BM |\n"
-		"            End.S | End.AS | End.AM | End.BPF }\n"
+		"            End.DT6 | End.DT4 | End.DT46 | End.B6 | End.B6.Encaps |\n"
+		"            End.BM | End.S | End.AS | End.AM | End.BPF }\n"
 		"OPTIONS := OPTION [ OPTIONS ]\n"
 		"OPTION := { srh SEG6HDR | nh4 ADDR | nh6 ADDR | iif DEV | oif DEV |\n"
 		"            table TABLEID | vrftable TABLEID | endpoint PROGNAME }\n"
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index ebc688e2..c4bae68d 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -220,6 +220,7 @@ static const char *seg6_action_names[SEG6_LOCAL_ACTION_MAX + 1] = {
 	[SEG6_LOCAL_ACTION_END_AS]		= "End.AS",
 	[SEG6_LOCAL_ACTION_END_AM]		= "End.AM",
 	[SEG6_LOCAL_ACTION_END_BPF]		= "End.BPF",
+	[SEG6_LOCAL_ACTION_END_DT46]		= "End.DT46",
 };
 
 static const char *format_action_type(int action)
diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index 2978bc0e..4b1947ab 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -834,6 +834,49 @@ rules. This action only accepts packets with either a zero Segments
 Left value or no SRH at all, and an inner IPv6 packet. Other
 matching packets are dropped.
 
+.BR End.DT6 " { " table " | " vrftable " } "
+.I TABLEID
+- Decapsulate the inner IPv6 packet and forward it according to the
+specified lookup table.
+.I TABLEID
+is either a number or a string from the file
+.BR "@SYSCONFDIR@/rt_tables" .
+If
+.B vrftable
+is used, the argument must be a VRF device associated with
+the table id. Moreover, the VRF table associated with the
+table id must be configured with the VRF strict mode turned
+on (net.vrf.strict_mode=1). This action only accepts packets
+with either a zero Segments Left value or no SRH at all,
+and an inner IPv6 packet. Other matching packets are dropped.
+
+.B End.DT4 vrftable
+.I TABLEID
+- Decapsulate the inner IPv4 packet and forward it according to the
+specified lookup table.
+.I TABLEID
+is either a number or a string from the file
+.BR "@SYSCONFDIR@/rt_tables" .
+The argument must be a VRF device associated with the table id.
+Moreover, the VRF table associated with the table id must be configured
+with the VRF strict mode turned on (net.vrf.strict_mode=1). This action
+only accepts packets with either a zero Segments Left value or no SRH
+at all, and an inner IPv4 packet. Other matching packets are dropped.
+
+.B End.DT46 vrftable
+.I TABLEID
+- Decapsulate the inner IPv4 or IPv6 packet and forward it according
+to the specified lookup table.
+.I TABLEID
+is either a number or a string from the file
+.BR "@SYSCONFDIR@/rt_tables" .
+The argument must be a VRF device associated with the table id.
+Moreover, the VRF table associated with the table id must be configured
+with the VRF strict mode turned on (net.vrf.strict_mode=1). This action
+only accepts packets with either a zero Segments Left value or no SRH
+at all, and an inner IPv4 or IPv6 packet. Other matching packets are
+dropped.
+
 .B End.B6 srh segs
 .IR SEGMENTS " [ "
 .B hmac
@@ -1172,6 +1215,11 @@ ip -6 route add 2001:db8:1::/64 encap seg6 mode encap segs 2001:db8:42::1,2001:d
 Adds an IPv6 route with SRv6 encapsulation and two segments attached.
 .RE
 .PP
+ip -6 route add 2001:db8:1::/64 encap seg6local action End.DT46 vrftable 100 dev vrf100
+.RS 4
+Adds an IPv6 route with SRv6 decapsulation and forward with lookup in VRF table.
+.RE
+.PP
 ip route add 10.1.1.0/30 nhid 10
 .RS 4
 Adds an ipv4 route using nexthop object with id 10.
-- 
2.20.1

