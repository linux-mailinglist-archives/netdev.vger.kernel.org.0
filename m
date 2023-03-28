Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7547A6CB46E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 05:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjC1DCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 23:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjC1DCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 23:02:36 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1321FE7
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 20:02:33 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pgzbQ-009Nsu-SS; Tue, 28 Mar 2023 11:02:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Mar 2023 11:02:28 +0800
Date:   Tue, 28 Mar 2023 11:02:28 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next] macvlan: Add bclim parameter
Message-ID: <ZCJYxDy1fgCm+cbj@gondor.apana.org.au>
References: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for setting the broadcast queueing threshold
on macvlan devices.  This controls which multicast packets will be
processed in a workqueue instead of inline.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index d61bd32d..71ddffc6 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -633,6 +633,7 @@ enum {
 	IFLA_MACVLAN_MACADDR_COUNT,
 	IFLA_MACVLAN_BC_QUEUE_LEN,
 	IFLA_MACVLAN_BC_QUEUE_LEN_USED,
+	IFLA_MACVLAN_BC_CUTOFF,
 	__IFLA_MACVLAN_MAX,
 };
 
diff --git a/ip/iplink_macvlan.c b/ip/iplink_macvlan.c
index 0f13637d..29a9112e 100644
--- a/ip/iplink_macvlan.c
+++ b/ip/iplink_macvlan.c
@@ -26,13 +26,14 @@
 static void print_explain(struct link_util *lu, FILE *f)
 {
 	fprintf(f,
-		"Usage: ... %s mode MODE [flag MODE_FLAG] MODE_OPTS [bcqueuelen BC_QUEUE_LEN]\n"
+		"Usage: ... %s mode MODE [flag MODE_FLAG] MODE_OPTS [bcqueuelen BC_QUEUE_LEN] [bclim BCLIM]\n"
 		"\n"
 		"MODE: private | vepa | bridge | passthru | source\n"
 		"MODE_FLAG: null | nopromisc | nodst\n"
 		"MODE_OPTS: for mode \"source\":\n"
 		"\tmacaddr { { add | del } <macaddr> | set [ <macaddr> [ <macaddr>  ... ] ] | flush }\n"
-		"BC_QUEUE_LEN: Length of the rx queue for broadcast/multicast: [0-4294967295]\n",
+		"BC_QUEUE_LEN: Length of the rx queue for broadcast/multicast: [0-4294967295]\n"
+		"BCLIM: Threshold for broadcast queueing: 32-bit integer\n",
 		lu->id
 	);
 }
@@ -67,6 +68,12 @@ static int bc_queue_len_arg(const char *arg)
 	return -1;
 }
 
+static int bclim_arg(const char *arg)
+{
+	fprintf(stderr, "Error: illegal value for \"bclen\": \"%s\"\n", arg);
+	return -1;
+}
+
 static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
 			  struct nlmsghdr *n)
 {
@@ -168,6 +175,15 @@ static int macvlan_parse_opt(struct link_util *lu, int argc, char **argv,
 				return bc_queue_len_arg(*argv);
 			}
 			addattr32(n, 1024, IFLA_MACVLAN_BC_QUEUE_LEN, bc_queue_len);
+		} else if (matches(*argv, "bclim") == 0) {
+			__s32 bclim;
+			NEXT_ARG();
+
+			if (get_s32(&bclim, *argv, 0)) {
+				return bclim_arg(*argv);
+			}
+			addattr_l(n, 1024, IFLA_MACVLAN_BC_CUTOFF,
+				  &bclim, sizeof(bclim));
 		} else if (matches(*argv, "help") == 0) {
 			explain(lu);
 			return -1;
@@ -245,6 +261,12 @@ static void macvlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[]
 		print_luint(PRINT_ANY, "usedbcqueuelen", "usedbcqueuelen %lu ", bc_queue_len);
 	}
 
+	if (tb[IFLA_MACVLAN_BC_CUTOFF] &&
+		RTA_PAYLOAD(tb[IFLA_MACVLAN_BC_CUTOFF]) >= sizeof(__s32)) {
+		__s32 bclim = rta_getattr_s32(tb[IFLA_MACVLAN_BC_CUTOFF]);
+		print_int(PRINT_ANY, "bclim", "bclim %d ", bclim);
+	}
+
 	/* in source mode, there are more options to print */
 
 	if (mode != MACVLAN_MODE_SOURCE)
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index c8c65657..bec1b78b 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1479,6 +1479,7 @@ the following additional arguments are supported:
 .BR mode " { " private " | " vepa " | " bridge " | " passthru
 .RB " [ " nopromisc " ] | " source " [ " nodst " ] } "
 .RB " [ " bcqueuelen " { " LENGTH " } ] "
+.RB " [ " bclim " " LIMIT " ] "
 
 .in +8
 .sp
@@ -1537,6 +1538,13 @@ will be the maximum length that any macvlan interface has requested.
 When listing device parameters both the bcqueuelen parameter
 as well as the actual used bcqueuelen are listed to better help
 the user understand the setting.
+
+.BR bclim " " LIMIT
+- Set the threshold for broadcast queueing.
+.BR LIMIT " must be a 32-bit integer."
+Setting this to -1 disables broadcast queueing altogether.  Otherwise
+a multicast address will be queued as broadcast if the number of devices
+using it is greater than the given value.
 .in -8
 
 .TP
@@ -2699,6 +2707,9 @@ Update the broadcast/multicast queue length.
 [
 .BI bcqueuelen "  LENGTH  "
 ]
+[
+.BI bclim " LIMIT "
+]
 
 .in +8
 .BI bcqueuelen " LENGTH "
@@ -2712,6 +2723,13 @@ will be the maximum length that any macvlan interface has requested.
 When listing device parameters both the bcqueuelen parameter
 as well as the actual used bcqueuelen are listed to better help
 the user understand the setting.
+
+.BI bclim " LIMIT "
+- Set the threshold for broadcast queueing.
+.IR LIMIT " must be a 32-bit integer."
+Setting this to -1 disables broadcast queueing altogether.  Otherwise
+a multicast address will be queued as broadcast if the number of devices
+using it is greater than the given value.
 .in -8
 
 .TP
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
