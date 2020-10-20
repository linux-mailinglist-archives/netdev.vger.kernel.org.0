Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD71629327E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389642AbgJTA6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgJTA6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:53 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7074CC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:53 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CFZy36GjxzQk03;
        Tue, 20 Oct 2020 02:58:51 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2y0uzib2G1OIqkTRPIQlmQjLQwKdDD9WpN8ecA9PLA=;
        b=AcYEthZoEwU8NbCZFHGBkwNmJJh/vAEXEaAMYZGxBS/zRhjVM8lTvMhUYfE9BQsHuQmtZl
        H4zNVLY8pW0yA8CWxe8YaoaXlf0vrZR3j2sgZ0FYvAHwauuFUXbofHuBN2z2afyFjqQtlj
        w411PvIdwia/AsyrYvooy3Bb5C6A7f9tE1iG9HeO80SNfUwnx+DbxavKlXCO9dn0dCVO7b
        ZzaJZMtJQ+86obV34zubBHqroHtfL1fIJw1ioJg1IfjsLBMSUyXWgsEMIVZiQfqg57khp2
        I43nWYIrd/V9EjM60v1fpM4vrJBypap23VRI6cXmgVnWHAFYtyipxQRirEdU0g==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id 6VV0ZyNmMT1d; Tue, 20 Oct 2020 02:58:47 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 05/15] ip: iplink: Convert to use parse_on_off(), parse_flag_on_off()
Date:   Tue, 20 Oct 2020 02:58:13 +0200
Message-Id: <a11809a4517827d3340e7e7c7b8dbbad32584180.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.14 / 15.00 / 15.00
X-Rspamd-Queue-Id: CB4FD271
X-Rspamd-UID: 7a2618
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Invoke parse_flag_on_off() instead of rolling a custom function. Several
places have the on/off logic reversed vs. how the flag is specified (e.g.
IFF_NOARP vs. "arp" on command line). For those, invoke parse_on_off() and
then set_flag() with a negated value.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 ip/iplink.c | 182 +++++++++++++++++++---------------------------------
 1 file changed, 66 insertions(+), 116 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 5ec33a98b96e..422e2fdccde5 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -135,14 +135,6 @@ static void usage(void)
 	iplink_usage();
 }
 
-static int on_off(const char *msg, const char *realval)
-{
-	fprintf(stderr,
-		"Error: argument of \"%s\" must be \"on\" or \"off\", not \"%s\"\n",
-		msg, realval);
-	return -1;
-}
-
 static void *BODY;		/* cached dlopen(NULL) handle */
 static struct link_util *linkutil_list;
 
@@ -351,6 +343,7 @@ static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
 	int len, argc = *argcp;
 	char **argv = *argvp;
 	struct rtattr *vfinfo;
+	int ret;
 
 	tivt.min_tx_rate = -1;
 	tivt.max_tx_rate = -1;
@@ -463,12 +456,9 @@ static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
 			struct ifla_vf_spoofchk ivs;
 
 			NEXT_ARG();
-			if (matches(*argv, "on") == 0)
-				ivs.setting = 1;
-			else if (matches(*argv, "off") == 0)
-				ivs.setting = 0;
-			else
-				return on_off("spoofchk", *argv);
+			ivs.setting = parse_on_off("spoofchk", *argv, &ret);
+			if (ret)
+				return ret;
 			ivs.vf = vf;
 			addattr_l(&req->n, sizeof(*req), IFLA_VF_SPOOFCHK,
 				  &ivs, sizeof(ivs));
@@ -477,12 +467,9 @@ static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
 			struct ifla_vf_rss_query_en ivs;
 
 			NEXT_ARG();
-			if (matches(*argv, "on") == 0)
-				ivs.setting = 1;
-			else if (matches(*argv, "off") == 0)
-				ivs.setting = 0;
-			else
-				return on_off("query_rss", *argv);
+			ivs.setting = parse_on_off("query_rss", *argv, &ret);
+			if (ret)
+				return ret;
 			ivs.vf = vf;
 			addattr_l(&req->n, sizeof(*req), IFLA_VF_RSS_QUERY_EN,
 				  &ivs, sizeof(ivs));
@@ -491,12 +478,9 @@ static int iplink_parse_vf(int vf, int *argcp, char ***argvp,
 			struct ifla_vf_trust ivt;
 
 			NEXT_ARG();
-			if (matches(*argv, "on") == 0)
-				ivt.setting = 1;
-			else if (matches(*argv, "off") == 0)
-				ivt.setting = 0;
-			else
-				invarg("Invalid \"trust\" value\n", *argv);
+			ivt.setting = parse_on_off("trust", *argv, &ret);
+			if (ret)
+				return ret;
 			ivt.vf = vf;
 			addattr_l(&req->n, sizeof(*req), IFLA_VF_TRUST,
 				  &ivt, sizeof(ivt));
@@ -594,6 +578,7 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 	int index = 0;
 	int group = -1;
 	int addr_len = 0;
+	int err;
 
 	ret = argc;
 
@@ -687,62 +672,53 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 			NEXT_ARG();
 			req->i.ifi_change |= IFF_MULTICAST;
 
-			if (strcmp(*argv, "on") == 0)
-				req->i.ifi_flags |= IFF_MULTICAST;
-			else if (strcmp(*argv, "off") == 0)
-				req->i.ifi_flags &= ~IFF_MULTICAST;
-			else
-				return on_off("multicast", *argv);
+			parse_flag_on_off("multicast", *argv, &req->i.ifi_flags,
+					  IFF_MULTICAST, &err);
+			if (err)
+				return err;
 		} else if (strcmp(*argv, "allmulticast") == 0) {
 			NEXT_ARG();
 			req->i.ifi_change |= IFF_ALLMULTI;
 
-			if (strcmp(*argv, "on") == 0)
-				req->i.ifi_flags |= IFF_ALLMULTI;
-			else if (strcmp(*argv, "off") == 0)
-				req->i.ifi_flags &= ~IFF_ALLMULTI;
-			else
-				return on_off("allmulticast", *argv);
+			parse_flag_on_off("allmulticast", *argv, &req->i.ifi_flags,
+					  IFF_ALLMULTI, &err);
+			if (err)
+				return err;
 		} else if (strcmp(*argv, "promisc") == 0) {
 			NEXT_ARG();
 			req->i.ifi_change |= IFF_PROMISC;
 
-			if (strcmp(*argv, "on") == 0)
-				req->i.ifi_flags |= IFF_PROMISC;
-			else if (strcmp(*argv, "off") == 0)
-				req->i.ifi_flags &= ~IFF_PROMISC;
-			else
-				return on_off("promisc", *argv);
+			parse_flag_on_off("promisc", *argv, &req->i.ifi_flags,
+					  IFF_PROMISC, &err);
+			if (err)
+				return err;
 		} else if (strcmp(*argv, "trailers") == 0) {
+			int on_off;
+
 			NEXT_ARG();
 			req->i.ifi_change |= IFF_NOTRAILERS;
 
-			if (strcmp(*argv, "off") == 0)
-				req->i.ifi_flags |= IFF_NOTRAILERS;
-			else if (strcmp(*argv, "on") == 0)
-				req->i.ifi_flags &= ~IFF_NOTRAILERS;
-			else
-				return on_off("trailers", *argv);
+			on_off = parse_on_off("trailers", *argv, &err);
+			if (err)
+				return err;
+			set_flag(&req->i.ifi_flags, IFF_NOTRAILERS, !on_off);
 		} else if (strcmp(*argv, "arp") == 0) {
+			int on_off;
+
 			NEXT_ARG();
 			req->i.ifi_change |= IFF_NOARP;
 
-			if (strcmp(*argv, "on") == 0)
-				req->i.ifi_flags &= ~IFF_NOARP;
-			else if (strcmp(*argv, "off") == 0)
-				req->i.ifi_flags |= IFF_NOARP;
-			else
-				return on_off("arp", *argv);
+			on_off = parse_on_off("arp", *argv, &err);
+			if (err)
+				return err;
+			set_flag(&req->i.ifi_flags, IFF_NOARP, !on_off);
 		} else if (strcmp(*argv, "carrier") == 0) {
 			int carrier;
 
 			NEXT_ARG();
-			if (strcmp(*argv, "on") == 0)
-				carrier = 1;
-			else if (strcmp(*argv, "off") == 0)
-				carrier = 0;
-			else
-				return on_off("carrier", *argv);
+			carrier = parse_on_off("carrier", *argv, &err);
+			if (err)
+				return err;
 
 			addattr8(&req->n, sizeof(*req), IFLA_CARRIER, carrier);
 		} else if (strcmp(*argv, "vf") == 0) {
@@ -793,12 +769,10 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 			NEXT_ARG();
 			req->i.ifi_change |= IFF_DYNAMIC;
 
-			if (strcmp(*argv, "on") == 0)
-				req->i.ifi_flags |= IFF_DYNAMIC;
-			else if (strcmp(*argv, "off") == 0)
-				req->i.ifi_flags &= ~IFF_DYNAMIC;
-			else
-				return on_off("dynamic", *argv);
+			parse_flag_on_off("dynamic", *argv, &req->i.ifi_flags,
+					  IFF_DYNAMIC, &err);
+			if (err)
+				return err;
 		} else if (matches(*argv, "type") == 0) {
 			NEXT_ARG();
 			*type = *argv;
@@ -895,12 +869,9 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 			unsigned int proto_down;
 
 			NEXT_ARG();
-			if (strcmp(*argv, "on") == 0)
-				proto_down = 1;
-			else if (strcmp(*argv, "off") == 0)
-				proto_down = 0;
-			else
-				return on_off("protodown", *argv);
+			proto_down = parse_on_off("protodown", *argv, &err);
+			if (err)
+				return err;
 			addattr8(&req->n, sizeof(*req), IFLA_PROTO_DOWN,
 				 proto_down);
 		} else if (strcmp(*argv, "gso_max_size") == 0) {
@@ -1320,6 +1291,7 @@ static int do_set(int argc, char **argv)
 	struct ifreq ifr0, ifr1;
 	char *newname = NULL;
 	int htype, halen;
+	int ret;
 
 	while (argc > 0) {
 		if (strcmp(*argv, "up") == 0) {
@@ -1357,63 +1329,41 @@ static int do_set(int argc, char **argv)
 		} else if (strcmp(*argv, "multicast") == 0) {
 			NEXT_ARG();
 			mask |= IFF_MULTICAST;
-
-			if (strcmp(*argv, "on") == 0)
-				flags |= IFF_MULTICAST;
-			else if (strcmp(*argv, "off") == 0)
-				flags &= ~IFF_MULTICAST;
-			else
-				return on_off("multicast", *argv);
+			parse_flag_on_off("multicast", *argv, &flags, IFF_MULTICAST, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "allmulticast") == 0) {
 			NEXT_ARG();
 			mask |= IFF_ALLMULTI;
-
-			if (strcmp(*argv, "on") == 0)
-				flags |= IFF_ALLMULTI;
-			else if (strcmp(*argv, "off") == 0)
-				flags &= ~IFF_ALLMULTI;
-			else
-				return on_off("allmulticast", *argv);
+			parse_flag_on_off("allmulticast", *argv, &flags, IFF_ALLMULTI, &ret);
 		} else if (strcmp(*argv, "promisc") == 0) {
 			NEXT_ARG();
 			mask |= IFF_PROMISC;
-
-			if (strcmp(*argv, "on") == 0)
-				flags |= IFF_PROMISC;
-			else if (strcmp(*argv, "off") == 0)
-				flags &= ~IFF_PROMISC;
-			else
-				return on_off("promisc", *argv);
+			parse_flag_on_off("promisc", *argv, &flags, IFF_PROMISC, &ret);
 		} else if (strcmp(*argv, "trailers") == 0) {
+			int on_off;
+
 			NEXT_ARG();
 			mask |= IFF_NOTRAILERS;
-
-			if (strcmp(*argv, "off") == 0)
-				flags |= IFF_NOTRAILERS;
-			else if (strcmp(*argv, "on") == 0)
-				flags &= ~IFF_NOTRAILERS;
-			else
-				return on_off("trailers", *argv);
+			on_off = parse_on_off("trailers", *argv, &ret);
+			if (ret)
+				return ret;
+			set_flag(&flags, IFF_NOTRAILERS, !on_off);
 		} else if (strcmp(*argv, "arp") == 0) {
+			int on_off;
+
 			NEXT_ARG();
 			mask |= IFF_NOARP;
-
-			if (strcmp(*argv, "on") == 0)
-				flags &= ~IFF_NOARP;
-			else if (strcmp(*argv, "off") == 0)
-				flags |= IFF_NOARP;
-			else
-				return on_off("arp", *argv);
+			on_off = parse_on_off("arp", *argv, &ret);
+			if (ret)
+				return ret;
+			set_flag(&flags, IFF_NOARP, !on_off);
 		} else if (matches(*argv, "dynamic") == 0) {
 			NEXT_ARG();
 			mask |= IFF_DYNAMIC;
-
-			if (strcmp(*argv, "on") == 0)
-				flags |= IFF_DYNAMIC;
-			else if (strcmp(*argv, "off") == 0)
-				flags &= ~IFF_DYNAMIC;
-			else
-				return on_off("dynamic", *argv);
+			parse_flag_on_off("dynamic", *argv, &flags, IFF_DYNAMIC, &ret);
+			if (ret)
+				return ret;
 		} else {
 			if (strcmp(*argv, "dev") == 0)
 				NEXT_ARG();
-- 
2.25.1

