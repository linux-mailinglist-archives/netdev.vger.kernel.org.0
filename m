Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D5111FE8F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfLPGo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:44:29 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:33625 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfLPGoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:44:19 -0500
Received: by mail-pj1-f53.google.com with SMTP id r67so2551583pjb.0
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IGmMiS7hY2bdt/WHCzHFZ8jUomL6IBEPbbcC5INKHlA=;
        b=apD1J9SA7lLC9yECks+p/+WPspQiu27Rpc3kQj19B8JgE1oEcJeJlfDnL/VCHVDBBj
         gUDrjhcGeZ4sMWeRorSB/vwy3wSazfp8qw8++nHdlySHsG+CbhLAnaeMYsLGqGWZGwt8
         ln8p6HmY1k+hHvXyemOP4K5k9zPMLIQ1tS2G8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IGmMiS7hY2bdt/WHCzHFZ8jUomL6IBEPbbcC5INKHlA=;
        b=uHOcg1PSwAOnlPV4U/lmokivOUKGTncHKjvwlqWKSEcYM7WCBFTPA8eHa0CclqoPzR
         9oCufaDR9sa/i3VTXrFkl5NyLOqmyzyziSdBn2njfseVSxJE9I9+ufd+ui1VZDSH2rhU
         ICmVSkJqCZnji4jpURXHTmsN+V3AMSEJsHStCpSi07hjHqpiqvbSHKiVqFNYCFq3AZ/l
         LVg4Q255MCxdO3AR/e2tPBSdLwPkEQjOFmtaX7hvj1I04A+H+Of8G6L0OF0V8W3chUwu
         u9ihWq1lAkGDSHGlXfnERB2FZrBuBzy9wJoGOockg2WTGW2FPedlr3oaag4hILO2aNHN
         yVrQ==
X-Gm-Message-State: APjAAAUS/ppz+pfaAs9/NuhrSQp6x+tfHxJ07ITkmqvGXYqbRPWj5FcB
        thxn9KW61pDQJnrGQJ6aGu46DjaMnjI=
X-Google-Smtp-Source: APXvYqyGpP8Bm0nV4kxB6qou0U+uopokyvQ0l0Q72ZzKy3kE5iDLhuRYYL2UCnkVT/JHB3K4jDMAoA==
X-Received: by 2002:a17:902:9a04:: with SMTP id v4mr14557791plp.192.1576478658000;
        Sun, 15 Dec 2019 22:44:18 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id y62sm21881502pfg.45.2019.12.15.22.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 22:44:16 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH iproute2 7/8] bridge: Deduplicate vlan show functions
Date:   Mon, 16 Dec 2019 15:43:43 +0900
Message-Id: <20191216064344.1470824-8-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
References: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

print_vlan() and print_vlan_tunnel() are almost identical copies, save for
a missing newline in the latter which leads to broken output of "vlan
tunnelshow" in normal mode.

Fixes: c7c1a1ef51ae ("bridge: colorize output and use JSON print library")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c                            | 91 +++++++-----------------
 testsuite/tests/bridge/vlan/tunnelshow.t |  7 ++
 2 files changed, 34 insertions(+), 64 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 428eeee3..19283bca 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -16,7 +16,11 @@
 #include "utils.h"
 
 static unsigned int filter_index, filter_vlan;
-static int show_vlan_tunnel_info = 0;
+
+enum vlan_show_subject {
+	VLAN_SHOW_VLAN,
+	VLAN_SHOW_TUNNELINFO,
+};
 
 static void usage(void)
 {
@@ -278,7 +282,7 @@ static void print_range(const char *name, __u32 start, __u32 id)
 
 }
 
-static void print_vlan_tunnel_info(FILE *fp, struct rtattr *tb, int ifindex)
+static void print_vlan_tunnel_info(struct rtattr *tb, int ifindex)
 {
 	struct rtattr *i, *list = tb;
 	int rem = RTA_PAYLOAD(list);
@@ -347,52 +351,9 @@ static void print_vlan_tunnel_info(FILE *fp, struct rtattr *tb, int ifindex)
 		close_vlan_port();
 }
 
-static int print_vlan_tunnel(struct nlmsghdr *n, void *arg)
-{
-	struct ifinfomsg *ifm = NLMSG_DATA(n);
-	struct rtattr *tb[IFLA_MAX+1];
-	int len = n->nlmsg_len;
-	FILE *fp = arg;
-
-	if (n->nlmsg_type != RTM_NEWLINK) {
-		fprintf(stderr, "Not RTM_NEWLINK: %08x %08x %08x\n",
-			n->nlmsg_len, n->nlmsg_type, n->nlmsg_flags);
-		return 0;
-	}
-
-	len -= NLMSG_LENGTH(sizeof(*ifm));
-	if (len < 0) {
-		fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
-		return -1;
-	}
-
-	if (ifm->ifi_family != AF_BRIDGE)
-		return 0;
-
-	if (filter_index && filter_index != ifm->ifi_index)
-		return 0;
-
-	parse_rtattr(tb, IFLA_MAX, IFLA_RTA(ifm), len);
-
-	/* if AF_SPEC isn't there, vlan table is not preset for this port */
-	if (!tb[IFLA_AF_SPEC]) {
-		if (!filter_vlan && !is_json_context()) {
-			color_fprintf(fp, COLOR_IFNAME, "%s",
-				      ll_index_to_name(ifm->ifi_index));
-			fprintf(fp, "\tNone\n");
-		}
-		return 0;
-	}
-
-	print_vlan_tunnel_info(fp, tb[IFLA_AF_SPEC], ifm->ifi_index);
-
-	fflush(fp);
-	return 0;
-}
-
 static int print_vlan(struct nlmsghdr *n, void *arg)
 {
-	FILE *fp = arg;
+	enum vlan_show_subject *subject = arg;
 	struct ifinfomsg *ifm = NLMSG_DATA(n);
 	int len = n->nlmsg_len;
 	struct rtattr *tb[IFLA_MAX+1];
@@ -420,17 +381,24 @@ static int print_vlan(struct nlmsghdr *n, void *arg)
 	/* if AF_SPEC isn't there, vlan table is not preset for this port */
 	if (!tb[IFLA_AF_SPEC]) {
 		if (!filter_vlan && !is_json_context()) {
-			color_fprintf(fp, COLOR_IFNAME, "%s",
+			color_fprintf(stdout, COLOR_IFNAME, "%s",
 				      ll_index_to_name(ifm->ifi_index));
-			fprintf(fp, "\tNone\n");
+			fprintf(stdout, "\tNone\n");
 		}
 		return 0;
 	}
 
-	print_vlan_info(tb[IFLA_AF_SPEC], ifm->ifi_index);
+	switch (*subject) {
+	case VLAN_SHOW_VLAN:
+		print_vlan_info(tb[IFLA_AF_SPEC], ifm->ifi_index);
+		break;
+	case VLAN_SHOW_TUNNELINFO:
+		print_vlan_tunnel_info(tb[IFLA_AF_SPEC], ifm->ifi_index);
+		break;
+	}
 	print_string(PRINT_FP, NULL, "%s", _SL_);
 
-	fflush(fp);
+	fflush(stdout);
 	return 0;
 }
 
@@ -543,7 +511,7 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
-static int vlan_show(int argc, char **argv)
+static int vlan_show(int argc, char **argv, int subject)
 {
 	char *filter_dev = NULL;
 	int ret = 0;
@@ -581,17 +549,13 @@ static int vlan_show(int argc, char **argv)
 		}
 
 		if (!is_json_context()) {
-			if (show_vlan_tunnel_info)
-				printf("port\tvlan ids\ttunnel id\n");
-			else
-				printf("port\tvlan ids\n");
+			printf("port\tvlan ids");
+			if (subject == VLAN_SHOW_TUNNELINFO)
+				printf("\ttunnel id");
+			printf("\n");
 		}
 
-		if (show_vlan_tunnel_info)
-			ret = rtnl_dump_filter(&rth, print_vlan_tunnel,
-					       stdout);
-		else
-			ret = rtnl_dump_filter(&rth, print_vlan, stdout);
+		ret = rtnl_dump_filter(&rth, print_vlan, &subject);
 		if (ret < 0) {
 			fprintf(stderr, "Dump ternminated\n");
 			exit(1);
@@ -677,15 +641,14 @@ int do_vlan(int argc, char **argv)
 		if (matches(*argv, "show") == 0 ||
 		    matches(*argv, "lst") == 0 ||
 		    matches(*argv, "list") == 0)
-			return vlan_show(argc-1, argv+1);
+			return vlan_show(argc-1, argv+1, VLAN_SHOW_VLAN);
 		if (matches(*argv, "tunnelshow") == 0) {
-			show_vlan_tunnel_info = 1;
-			return vlan_show(argc-1, argv+1);
+			return vlan_show(argc-1, argv+1, VLAN_SHOW_TUNNELINFO);
 		}
 		if (matches(*argv, "help") == 0)
 			usage();
 	} else {
-		return vlan_show(0, NULL);
+		return vlan_show(0, NULL, VLAN_SHOW_VLAN);
 	}
 
 	fprintf(stderr, "Command \"%s\" is unknown, try \"bridge vlan help\".\n", *argv);
diff --git a/testsuite/tests/bridge/vlan/tunnelshow.t b/testsuite/tests/bridge/vlan/tunnelshow.t
index 1583abb9..b2141e7c 100755
--- a/testsuite/tests/bridge/vlan/tunnelshow.t
+++ b/testsuite/tests/bridge/vlan/tunnelshow.t
@@ -16,9 +16,16 @@ ts_ip "$0" "Enslave $VX_DEV under $BR_DEV" \
 ts_ip "$0" "Set vlan_tunnel on $VX_DEV" \
 	link set dev $VX_DEV type bridge_slave vlan_tunnel on
 
+ts_bridge "$0" "Add single vlan" vlan add dev $VX_DEV vid 1000
+ts_bridge "$0" "Add single tunnel" \
+	vlan add dev $VX_DEV vid 1000 tunnel_info id 1000
+ts_bridge "$0" "Add vlan range" vlan add dev $VX_DEV vid 1010-1020
+ts_bridge "$0" "Add tunnel range" \
+	vlan add dev $VX_DEV vid 1010-1020 tunnel_info id 1010-1020
 ts_bridge "$0" "Add single vlan" vlan add dev $VX_DEV vid 1030
 ts_bridge "$0" "Add tunnel with vni > 16k" \
 	vlan add dev $VX_DEV vid 1030 tunnel_info id 65556
 
 ts_bridge "$0" "Show tunnel info" vlan tunnelshow dev $VX_DEV
 test_on "1030\s+65556"
+test_lines_count 5
-- 
2.24.0

