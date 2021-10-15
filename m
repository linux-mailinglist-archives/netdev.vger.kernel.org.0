Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0980742FE69
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbhJOWzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:55:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:46082 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243407AbhJOWzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 18:55:40 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mbW4y-000Bf7-Gr; Sat, 16 Oct 2021 00:53:32 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iproute2 -next 4/4] ip, neigh: Add NTF_EXT_MANAGED support
Date:   Sat, 16 Oct 2021 00:53:19 +0200
Message-Id: <20211015225319.2284-5-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211015225319.2284-1-daniel@iogearbox.net>
References: <20211015225319.2284-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26323/Fri Oct 15 10:25:36 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ip neigh does not support the NTF_EXT_MANAGED flag. Add cmdline
support.

Usage example:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 managed extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a managed extern_learn REACHABLE
  [...]

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 ip/ipneigh.c            | 20 +++++++++++++++-----
 man/man8/ip-neighbour.8 |  9 +++++++++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 9510e03e..9a56b4a5 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -51,7 +51,8 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage: ip neigh { add | del | change | replace }\n"
 		"		{ ADDR [ lladdr LLADDR ] [ nud STATE ] proxy ADDR }\n"
-		"		[ dev DEV ] [ router ] [ use ] [ extern_learn ] [ protocol PROTO ]\n"
+		"		[ dev DEV ] [ router ] [ use ] [ managed ] [ extern_learn ]\n"
+		"		[ protocol PROTO ]\n"
 		"\n"
 		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
 		"				  [ vrf NAME ]\n"
@@ -115,6 +116,7 @@ static int ipneigh_modify(int cmd, int flags, int argc, char **argv)
 		.ndm.ndm_family = preferred_family,
 		.ndm.ndm_state = NUD_PERMANENT,
 	};
+	__u32 ext_flags = 0;
 	char  *dev = NULL;
 	int dst_ok = 0;
 	int dev_ok = 0;
@@ -150,6 +152,9 @@ static int ipneigh_modify(int cmd, int flags, int argc, char **argv)
 			req.ndm.ndm_flags |= NTF_ROUTER;
 		} else if (strcmp(*argv, "use") == 0) {
 			req.ndm.ndm_flags |= NTF_USE;
+		} else if (strcmp(*argv, "managed") == 0) {
+			ext_flags |= NTF_EXT_MANAGED;
+			req.ndm.ndm_state = NUD_NONE;
 		} else if (matches(*argv, "extern_learn") == 0) {
 			req.ndm.ndm_flags |= NTF_EXT_LEARNED;
 		} else if (strcmp(*argv, "dev") == 0) {
@@ -185,7 +190,10 @@ static int ipneigh_modify(int cmd, int flags, int argc, char **argv)
 	req.ndm.ndm_family = dst.family;
 	if (addattr_l(&req.n, sizeof(req), NDA_DST, &dst.data, dst.bytelen) < 0)
 		return -1;
-
+	if (ext_flags &&
+	    addattr_l(&req.n, sizeof(req), NDA_FLAGS_EXT, &ext_flags,
+		      sizeof(ext_flags)) < 0)
+		return -1;
 	if (lla && strcmp(lla, "null")) {
 		char llabuf[20];
 		int l;
@@ -305,6 +313,7 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 	int len = n->nlmsg_len;
 	struct rtattr *tb[NDA_MAX+1];
 	static int logit = 1;
+	__u32 ext_flags = 0;
 	__u8 protocol = 0;
 
 	if (n->nlmsg_type != RTM_NEWNEIGH && n->nlmsg_type != RTM_DELNEIGH &&
@@ -348,6 +357,8 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 
 	if (tb[NDA_PROTOCOL])
 		protocol = rta_getattr_u8(tb[NDA_PROTOCOL]);
+	if (tb[NDA_FLAGS_EXT])
+		ext_flags = rta_getattr_u32(tb[NDA_FLAGS_EXT]);
 
 	if (filter.protocol && filter.protocol != protocol)
 		return 0;
@@ -430,13 +441,12 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 
 	if (r->ndm_flags & NTF_ROUTER)
 		print_null(PRINT_ANY, "router", "%s ", "router");
-
 	if (r->ndm_flags & NTF_PROXY)
 		print_null(PRINT_ANY, "proxy", "%s ", "proxy");
-
+	if (ext_flags & NTF_EXT_MANAGED)
+		print_null(PRINT_ANY, "managed", "%s ", "managed");
 	if (r->ndm_flags & NTF_EXT_LEARNED)
 		print_null(PRINT_ANY, "extern_learn", "%s ", "extern_learn");
-
 	if (r->ndm_flags & NTF_OFFLOADED)
 		print_null(PRINT_ANY, "offload", "%s ", "offload");
 
diff --git a/man/man8/ip-neighbour.8 b/man/man8/ip-neighbour.8
index ed2dcd5a..1331d7cb 100644
--- a/man/man8/ip-neighbour.8
+++ b/man/man8/ip-neighbour.8
@@ -26,6 +26,7 @@ ip-neighbour \- neighbour/arp tables management.
 .IR DEV " ] [ "
 .BR router " ] [ "
 .BR use " ] [ "
+.BR managed " ] [ "
 .BR extern_learn " ]"
 
 .ti -8
@@ -99,6 +100,14 @@ the kernel that a controller is using this dynamic entry. If the entry
 does not exist, the kernel will resolve it. If it exists, an attempt
 to refresh the neighbor entry will be triggered.
 
+.TP
+.BI managed
+this neigh entry is "managed". This option can be used to indicate to
+the kernel that a controller is using this dynamic entry. In contrast
+to "use", if the entry does not exist, the kernel will resolve it and
+periodically attempt to auto-refresh the neighbor entry such that it
+remains in resolved state when possible.
+
 .TP
 .BI extern_learn
 this neigh entry was learned externally. This option can be used to
-- 
2.27.0

