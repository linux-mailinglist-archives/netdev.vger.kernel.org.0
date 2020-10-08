Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E27628756C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgJHNut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730399AbgJHNus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:50:48 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5C2C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 06:50:48 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ce10so8225290ejc.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 06:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b2AV8YXRBWPkekGUIXzfbnQPT4fBp6YeQuxKMHW1txQ=;
        b=sKBziavh1v+2QOa6E5K+BojfkIsyNDW6MqZJswp3a15wGJlUMaDKyO8SooXDvprTPS
         +wIArUS06N+ThbmfPrRVWxNz3xsmlJEo2pSnz0HIWIXV5X2i3Ww4j9RJbZCcLCrJcoAl
         ubp07y1P93a8wykRwNggkdD4HSWPtqBvUoOHmwKs9W+mqTR5uDU1QXEWgfPjoIGkXrPG
         90MIvq5x/uxvT85Wc6yGbvok5m7I9JwLQ51fCeu70d7n2TlYG/MAdYN+9+9huzt/kTxT
         ZTPKq4b88+LrQm3nb+iMj3qO7govwNbLmPpabAYn8lIvLQHu14GHhsczGYkp5+D1RPZD
         kk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b2AV8YXRBWPkekGUIXzfbnQPT4fBp6YeQuxKMHW1txQ=;
        b=uoF0Rnyp1GVmTS4Fh908i9/vCzYxWFBF3OfLZ15pKujOU6X+gMwbBO2n58yaXaxJJH
         Nr7cXSDvOXhve+sqi6ijZcqsPdZJZ5XEBD1iMwqIUycl5/j8PazzqpAxCoKzrJO8yLk6
         XGfmv+mN31qa1++sdaGDxdevCGhqu+ZM1oCel6igpLk7ZnEXeIOXmQV6WGZi4cYGnVci
         01cx6guxS6VHyrANohorzxuzlxGEhLyVvFSWGtTY4Dzcr/SuuIDhqGVO0Qyj/MDkYoBW
         kqVyfuv+QzBN/D+/CO4S5zV4beY6UnxBWZO52PkYT8nY+tD4l3Qiy+KqTfp1xWzou9+5
         pk4Q==
X-Gm-Message-State: AOAM5334NUPdmVykcd/R0gJAay6NORk6IXRX+hgPLDmCbfrA1VnsWHpO
        6xA7NWaupbLadkK8yBJ1OV9BboBjx/dKOfqW
X-Google-Smtp-Source: ABdhPJzPvtC6COt2PAmygnhdklAeweGtMNoDrbDLIyLjj9wqZ1DwdwdXSxz6yc1mpwfXfOZHYFtmWQ==
X-Received: by 2002:a17:906:715a:: with SMTP id z26mr8887247ejj.300.1602165046694;
        Thu, 08 Oct 2020 06:50:46 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w21sm4169617ejo.70.2020.10.08.06.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 06:50:46 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 1/6] bridge: mdb: add support for source address
Date:   Thu,  8 Oct 2020 16:50:19 +0300
Message-Id: <20201008135024.1515468-2-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201008135024.1515468-1-razor@blackwall.org>
References: <20201008135024.1515468-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

This patch adds the user-space control and dump of mdb entry source
address. When setting the new MDBA_SET_ENTRY_ATTRS nested attribute is
used and inside is added MDBE_ATTR_SOURCE based on the address family.
When dumping we look for MDBA_MDB_EATTR_SOURCE and if present we add the
"src x.x.x.x" output. The source address will be always shown as it's
needed to match the entry to modify it from user-space.

Example:
 $ bridge mdb add dev bridge port ens13 grp 239.0.0.1 src 1.2.3.4 permanent vid 100
 $ bridge mdb show
 dev bridge port ens13 grp 239.0.0.1 src 1.2.3.4 permanent vid 100

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/mdb.c      | 38 ++++++++++++++++++++++++++++++++------
 man/man8/bridge.8 |  8 ++++++++
 2 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 928ae56d29a7..01c8a6e389a8 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -31,7 +31,7 @@ static unsigned int filter_index, filter_vlan;
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: bridge mdb { add | del } dev DEV port PORT grp GROUP [permanent | temp] [vid VID]\n"
+		"Usage: bridge mdb { add | del } dev DEV port PORT grp GROUP [src SOURCE] [permanent | temp] [vid VID]\n"
 		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
@@ -118,16 +118,16 @@ static void br_print_router_ports(FILE *f, struct rtattr *attr,
 static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 			    struct nlmsghdr *n, struct rtattr **tb)
 {
+	const void *grp, *src;
 	SPRINT_BUF(abuf);
 	const char *dev;
-	const void *src;
 	int af;
 
 	if (filter_vlan && e->vid != filter_vlan)
 		return;
 
 	af = e->addr.proto == htons(ETH_P_IP) ? AF_INET : AF_INET6;
-	src = af == AF_INET ? (const void *)&e->addr.u.ip4 :
+	grp = af == AF_INET ? (const void *)&e->addr.u.ip4 :
 			      (const void *)&e->addr.u.ip6;
 	dev = ll_index_to_name(ifindex);
 
@@ -140,8 +140,13 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 
 	print_color_string(PRINT_ANY, ifa_family_color(af),
 			    "grp", " grp %s",
-			    inet_ntop(af, src, abuf, sizeof(abuf)));
-
+			    inet_ntop(af, grp, abuf, sizeof(abuf)));
+	if (tb && tb[MDBA_MDB_EATTR_SOURCE]) {
+		src = (const void *)RTA_DATA(tb[MDBA_MDB_EATTR_SOURCE]);
+		print_color_string(PRINT_ANY, ifa_family_color(af),
+				   "src", " src %s",
+				   inet_ntop(af, src, abuf, sizeof(abuf)));
+	}
 	print_string(PRINT_ANY, "state", " %s",
 			   (e->state & MDB_PERMANENT) ? "permanent" : "temp");
 
@@ -378,8 +383,8 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 		.n.nlmsg_type = cmd,
 		.bpm.family = PF_BRIDGE,
 	};
+	char *d = NULL, *p = NULL, *grp = NULL, *src = NULL;
 	struct br_mdb_entry entry = {};
-	char *d = NULL, *p = NULL, *grp = NULL;
 	short vid = 0;
 
 	while (argc > 0) {
@@ -400,6 +405,9 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 		} else if (strcmp(*argv, "vid") == 0) {
 			NEXT_ARG();
 			vid = atoi(*argv);
+		} else if (strcmp(*argv, "src") == 0) {
+			NEXT_ARG();
+			src = *argv;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -431,6 +439,24 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 
 	entry.vid = vid;
 	addattr_l(&req.n, sizeof(req), MDBA_SET_ENTRY, &entry, sizeof(entry));
+	if (src) {
+		struct rtattr *nest = addattr_nest(&req.n, sizeof(req),
+						   MDBA_SET_ENTRY_ATTRS);
+		struct in6_addr src_ip6;
+		__be32 src_ip4;
+
+		nest->rta_type |= NLA_F_NESTED;
+		if (!inet_pton(AF_INET, src, &src_ip4)) {
+			if (!inet_pton(AF_INET6, src, &src_ip6)) {
+				fprintf(stderr, "Invalid source address \"%s\"\n", src);
+				return -1;
+			}
+			addattr_l(&req.n, sizeof(req), MDBE_ATTR_SOURCE, &src_ip6, sizeof(src_ip6));
+		} else {
+			addattr32(&req.n, sizeof(req), MDBE_ATTR_SOURCE, src_ip4);
+		}
+		addattr_nest_end(&req.n, nest);
+	}
 
 	if (rtnl_talk(&rth, &req.n, NULL) < 0)
 		return -1;
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index b06005763bc2..84b9b70c7dea 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -116,6 +116,8 @@ bridge \- show / manipulate bridge addresses and devices
 .I PORT
 .B grp
 .IR GROUP " [ "
+.B src
+.IR SOURCE " ] [ "
 .BR permanent " | " temp " ] [ "
 .B vid
 .IR VID " ] "
@@ -694,6 +696,12 @@ the port.
 - the mdb entry is temporary (default)
 .sp
 
+.TP
+.BI src " SOURCE"
+optional source IP address of a sender for this multicast group. If IGMPv3 for IPv4, or
+MLDv2 for IPv6 respectively, are enabled it will be included in the lookup when
+forwarding multicast traffic.
+
 .TP
 .BI vid " VID"
 the VLAN ID which is known to have members of this multicast group.
-- 
2.25.4

