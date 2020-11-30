Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC94A2C869C
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgK3OYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:24:31 -0500
Received: from spam.lhost.no ([5.158.192.84]:36709 "EHLO mx03.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbgK3OYb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 09:24:31 -0500
X-ASG-Debug-ID: 1606746221-0ffc0524df13b1b0001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx03.lhost.no with ESMTP id Myb3HenIUroiQQC1 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Mon, 30 Nov 2020 15:23:42 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Mon, 30
 Nov 2020 15:23:38 +0100
Subject: [PATCH iproute2-next v1] iplink macvlan: Added bcqueuelen parameter
To:     Jakub Kicinski <kuba@kernel.org>, <stephen@networkplumber.org>
X-ASG-Orig-Subj: [PATCH iproute2-next v1] iplink macvlan: Added bcqueuelen parameter
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <jiri@resnulli.us>, <kaber@trash.net>, <edumazet@google.com>,
        <vyasevic@redhat.com>, <alexander.duyck@gmail.com>,
        <thomas.karlsson@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <80f814c3-0957-7f65-686c-f5fbb073f65c@paneda.se>
Date:   Mon, 30 Nov 2020 15:23:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: sv
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1606746222
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx03.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 6632
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up patch to iproute2 that allows the user
to set and retrieve the added IFLA_MACVLAN_BC_QUEUE_LEN parameter
via the bcqueuelen command line argument

This controls the requested size of the macvlan queue for broadcast
and multicast packages.

If not specified the driver default (1000) is used.

Note: The request is per macvlan but the actually used queue
length per port is the maximum of any request to any macvlan
connected to the same port.

The used queue length (IFLA_MACVLAN_BC_QUEUE_LEN_USED) is also
retrieved and displayed in order to aid in the understanding
of the setting. However, it cannot be directly set.

Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>
---

v1 Initial version
   Note: This patch first requires that the corresponding
   kernel patch in 0c88607c-1b63-e8b5-8a84-14b63e55e8e2@paneda.se
   to macvlan is merged to be usable.

 include/uapi/linux/if_link.h |  2 ++
 ip/iplink_macvlan.c          | 33 +++++++++++++++++++++++++++++++--
 man/man8/ip-link.8.in        | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 307e5c24..faa90938 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -586,6 +586,8 @@ enum {
 	IFLA_MACVLAN_MACADDR,
 	IFLA_MACVLAN_MACADDR_DATA,
 	IFLA_MACVLAN_MACADDR_COUNT,
+	IFLA_MACVLAN_BC_QUEUE_LEN,
+	IFLA_MACVLAN_BC_QUEUE_LEN_USED,
 	__IFLA_MACVLAN_MAX,
 };
 
diff --git a/ip/iplink_macvlan.c b/ip/iplink_macvlan.c
index b966a615..302a3748 100644
--- a/ip/iplink_macvlan.c
+++ b/ip/iplink_macvlan.c
@@ -30,12 +30,13 @@
 static void print_explain(struct link_util *lu, FILE *f)
 {
 	fprintf(f,
-		"Usage: ... %s mode MODE [flag MODE_FLAG] MODE_OPTS\n"
+		"Usage: ... %s mode MODE [flag MODE_FLAG] MODE_OPTS [bcqueuelen BC_QUEUE_LEN]\n"
 		"\n"
 		"MODE: private | vepa | bridge | passthru | source\n"
 		"MODE_FLAG: null | nopromisc\n"
 		"MODE_OPTS: for mode \"source\":\n"
-		"\tmacaddr { { add | del } <macaddr> | set [ <macaddr> [ <macaddr>  ... ] ] | flush }\n",
+		"\tmacaddr { { add | del } <macaddr> | set [ <macaddr> [ <macaddr>  ... ] ] | flush }\n"
+		"BC_QUEUE_LEN: Length of the rx queue for broadcast/multicast: [0-4294967295]\n",
 		lu->id
 	);
 }
@@ -62,6 +63,14 @@ static int flag_arg(const char *arg)
 	return -1;
 }
 
+static int bc_queue_len_arg(const char *arg)
+{
+	fprintf(stderr,
+		"Error: argument of \"bcqueuelen\" must be a positive integer [0-4294967295], not \"%s\"\n",
+		arg);
+	return -1;
+}
+
 static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
 			  struct nlmsghdr *n)
 {
@@ -150,6 +159,14 @@ static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
 		} else if (matches(*argv, "nopromisc") == 0) {
 			flags |= MACVLAN_FLAG_NOPROMISC;
 			has_flags = 1;
+		} else if (matches(*argv, "bcqueuelen") == 0) {
+			__u32 bc_queue_len;
+			NEXT_ARG();
+			
+			if (get_u32(&bc_queue_len, *argv, 0)) {
+				return bc_queue_len_arg(*argv);
+			}
+			addattr32(n, 1024, IFLA_MACVLAN_BC_QUEUE_LEN, bc_queue_len);
 		} else if (matches(*argv, "help") == 0) {
 			explain(lu);
 			return -1;
@@ -212,6 +229,18 @@ static void macvlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[]
 	if (flags & MACVLAN_FLAG_NOPROMISC)
 		print_bool(PRINT_ANY, "nopromisc", "nopromisc ", true);
 
+	if (tb[IFLA_MACVLAN_BC_QUEUE_LEN] &&
+		RTA_PAYLOAD(tb[IFLA_MACVLAN_BC_QUEUE_LEN]) >= sizeof(__u32)) {
+		__u32 bc_queue_len = rta_getattr_u32(tb[IFLA_MACVLAN_BC_QUEUE_LEN]);
+		print_luint(PRINT_ANY, "bcqueuelen", "bcqueuelen %lu ", bc_queue_len);
+	}
+
+	if (tb[IFLA_MACVLAN_BC_QUEUE_LEN_USED] &&
+		RTA_PAYLOAD(tb[IFLA_MACVLAN_BC_QUEUE_LEN_USED]) >= sizeof(__u32)) {
+		__u32 bc_queue_len = rta_getattr_u32(tb[IFLA_MACVLAN_BC_QUEUE_LEN_USED]);
+		print_luint(PRINT_ANY, "usedbcqueuelen", "usedbcqueuelen %lu ", bc_queue_len);
+	}
+
 	/* in source mode, there are more options to print */
 
 	if (mode != MACVLAN_MODE_SOURCE)
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 1ff01744..3516765a 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1352,6 +1352,7 @@ the following additional arguments are supported:
 .BR type " { " macvlan " | " macvtap " } "
 .BR mode " { " private " | " vepa " | " bridge " | " passthru
 .RB " [ " nopromisc " ] | " source " } "
+.RB " [ " bcqueuelen " { " LENGTH " } ] "
 
 .in +8
 .sp
@@ -1395,6 +1396,18 @@ against source mac address from received frames on underlying interface. This
 allows creating mac based VLAN associations, instead of standard port or tag
 based. The feature is useful to deploy 802.1x mac based behavior,
 where drivers of underlying interfaces doesn't allows that.
+
+.BR bcqueuelen " { " LENGTH " } "
+- Set the length of the RX queue used to process broadcast and multicast packets.
+.BR LENGTH " must be a positive integer in the range [0-4294967295]."
+Setting a length of 0 will effectively drop all broadcast/multicast traffic.
+If not specified the macvlan driver default (1000) is used.
+Note that all macvlans that share the same underlying device are using the same
+.RB "queue. The parameter here is a " request ", the actual queue length used"
+will be the maximum length that any macvlan interface has requested.
+When listing device parameters both the bcqueuelen parameter
+as well as the actual used bcqueuelen are listed to better help
+the user understand the setting.
 .in -8
 
 .TP
@@ -2451,6 +2464,26 @@ Commands:
 .sp
 .in -8
 
+Update the broadcast/multicast queue length.
+
+.B "ip link set type { macvlan | macvap } "
+[
+.BI bcqueuelen "  LENGTH  "
+]
+
+.in +8
+.BI bcqueuelen " LENGTH "
+- Set the length of the RX queue used to process broadcast and multicast packets.
+.IR LENGTH " must be a positive integer in the range [0-4294967295]."
+Setting a length of 0 will effectively drop all broadcast/multicast traffic.
+If not specified the macvlan driver default (1000) is used.
+Note that all macvlans that share the same underlying device are using the same
+.RB "queue. The parameter here is a " request ", the actual queue length used"
+will be the maximum length that any macvlan interface has requested.
+When listing device parameters both the bcqueuelen parameter
+as well as the actual used bcqueuelen are listed to better help
+the user understand the setting.
+.in -8
 
 .SS  ip link show - display device attributes
 
-- 
2.29.2


