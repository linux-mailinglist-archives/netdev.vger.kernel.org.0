Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874CD3634F8
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhDRMDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhDRMDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 08:03:37 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01363C06174A
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:08 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id w186so12131891wmg.3
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=on3EgqSKCI//AH2PnGOSrMuXlDspgsGk19tPu2f6tWQ=;
        b=zgiUqJG55c77cfyJVvxo5rBBUC4l5+Tbae8RDOZiijuksl4JvkgwrQyVHT4spiDkDL
         AEIBKYeDEuWwX4wrRPQeAL7AMadIpkrDxTBxyNXNrfkp+WRDBtTXTAlUPjDsVCcCoDo6
         1YDjNIZVeJvxMv+EyW7ltSHxoj5UDIGkwDJBkaxOVhtUQ+n1oq2+mQ0C59FDlp+ib0eM
         Z1zqViluOpE3ZUqKJu5oU1e9TG1/SGEBLV89sXoVV6izepurOg666sPNteFRa9lzNZUy
         MfjKApCdaUp/oJGYwQmgK73uUa7DRlZyzk4OOJCjXjYGBNgzdRVy5r+hZ0H4HdmIQAY/
         0eEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=on3EgqSKCI//AH2PnGOSrMuXlDspgsGk19tPu2f6tWQ=;
        b=h8MPlbj4piWA7dcNDBiwkz8lu850gKkZkhKBTlAu5YPVzXpZYp0GIwrG3y6jxGjda1
         +OzYj+n9Dix6h8kdIuCf5ZBKpDeIRP4dcmYqOIN8SYoLzB6G5T4mDnEsnIOa/mNxJt2U
         IzhuptxbOJOfWWSGYouuQj2fxRov4P/ot8e4txJuYyjKUqG91iFFc+DnjkykXS0KZVs1
         3ou0c+TVYF1O/RFAYKRAAP7/T5hOBcdCIymSRDatZ+Pq8gSSmNTI0YR4e75ZA8AAYfbO
         dC1qzOlMzhXRnHi4vwHVK3WrBVUiZyLGZsfOx/9O5dx0PuQ8WByMnzQdprz4amjufg73
         4Mtg==
X-Gm-Message-State: AOAM532BYBKqynJOwof5SWZK3zK8uUn5CgGNT6EsqmGNWGwg7gn9N+1E
        UqgX6dCR+oUTFMhGVm0fw92PWl2V3z6re0ai
X-Google-Smtp-Source: ABdhPJzKaM1k4yDyaMtCnpCpDGE+Xy6pUAYzSNOdvct7ACWWqstx3qqBLrQq+BJ6ndIWosRNunw4ZQ==
X-Received: by 2002:a1c:bd85:: with SMTP id n127mr16725009wmf.37.1618747386393;
        Sun, 18 Apr 2021 05:03:06 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x25sm16584763wmj.34.2021.04.18.05.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 05:03:06 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 5/6] bridge: vlan: add support for the new rtm dump call
Date:   Sun, 18 Apr 2021 15:01:36 +0300
Message-Id: <20210418120137.2605522-6-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418120137.2605522-1-razor@blackwall.org>
References: <20210418120137.2605522-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Use the new bridge vlan rtm dump helper to dump all of the available
vlan information when -details (-d) is used with vlan show. It is also
capable of dumping vlan stats if -statistics (-s) is added.
Currently this is the only interface capable of dumping per-vlan
options. The vlan dump format is compatible with current vlan show, it
uses the same helpers to dump vlan information. The new addition is one
line which will contain the per-vlan options (similar to ip -d link show
for ports). Currently only the vlan STP state is printed.
The call uses compressed vlan format by default.

Example:
$ bridge -s -d vlan show
port              vlan-id
virbr1            1 PVID Egress Untagged
                    state forwarding

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/br_common.h   |   1 +
 bridge/vlan.c        | 147 ++++++++++++++++++++++++++++++++++++++++---
 include/libnetlink.h |   5 ++
 man/man8/bridge.8    |   7 ++-
 4 files changed, 152 insertions(+), 8 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index 33e56452702b..43870546ff28 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -12,6 +12,7 @@ int print_mdb_mon(struct nlmsghdr *n, void *arg);
 int print_fdb(struct nlmsghdr *n, void *arg);
 void print_stp_state(__u8 state);
 int parse_stp_state(const char *arg);
+int print_vlan_rtm(struct nlmsghdr *n, void *arg);
 
 int do_fdb(int argc, char **argv);
 int do_mdb(int argc, char **argv);
diff --git a/bridge/vlan.c b/bridge/vlan.c
index 09884870df81..c681e14189b8 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -16,6 +16,7 @@
 #include "utils.h"
 
 static unsigned int filter_index, filter_vlan;
+static int vlan_rtm_cur_ifidx = -1;
 
 enum vlan_show_subject {
 	VLAN_SHOW_VLAN,
@@ -517,14 +518,8 @@ static void print_vlan_flags(__u16 flags)
 	close_json_array(PRINT_JSON, NULL);
 }
 
-static void print_one_vlan_stats(const struct bridge_vlan_xstats *vstats)
+static void __print_one_vlan_stats(const struct bridge_vlan_xstats *vstats)
 {
-	open_json_object(NULL);
-
-	print_hu(PRINT_ANY, "vid", "%hu", vstats->vid);
-	print_vlan_flags(vstats->flags);
-	print_nl();
-
 	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
 	print_lluint(PRINT_ANY, "rx_bytes", "RX: %llu bytes",
 		     vstats->rx_bytes);
@@ -536,6 +531,16 @@ static void print_one_vlan_stats(const struct bridge_vlan_xstats *vstats)
 		     vstats->tx_bytes);
 	print_lluint(PRINT_ANY, "tx_packets", " %llu packets\n",
 		     vstats->tx_packets);
+}
+
+static void print_one_vlan_stats(const struct bridge_vlan_xstats *vstats)
+{
+	open_json_object(NULL);
+
+	print_hu(PRINT_ANY, "vid", "%hu", vstats->vid);
+	print_vlan_flags(vstats->flags);
+	print_nl();
+	__print_one_vlan_stats(vstats);
 
 	close_json_object();
 }
@@ -616,6 +621,105 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
+int print_vlan_rtm(struct nlmsghdr *n, void *arg)
+{
+	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1], *a;
+	struct br_vlan_msg *bvm = NLMSG_DATA(n);
+	int len = n->nlmsg_len;
+	bool newport = false;
+	int rem;
+
+	if (n->nlmsg_type != RTM_NEWVLAN && n->nlmsg_type != RTM_DELVLAN &&
+	    n->nlmsg_type != RTM_GETVLAN) {
+		fprintf(stderr, "Unknown vlan rtm message: %08x %08x %08x\n",
+			n->nlmsg_len, n->nlmsg_type, n->nlmsg_flags);
+		return 0;
+	}
+
+	len -= NLMSG_LENGTH(sizeof(*bvm));
+	if (len < 0) {
+		fprintf(stderr, "BUG: wrong nlmsg len %d\n", len);
+		return -1;
+	}
+
+	if (bvm->family != AF_BRIDGE)
+		return 0;
+
+	if (filter_index && filter_index != bvm->ifindex)
+		return 0;
+
+	if (vlan_rtm_cur_ifidx == -1 || vlan_rtm_cur_ifidx != bvm->ifindex) {
+		if (vlan_rtm_cur_ifidx != -1)
+			close_vlan_port();
+		open_vlan_port(bvm->ifindex, VLAN_SHOW_VLAN);
+		vlan_rtm_cur_ifidx = bvm->ifindex;
+		newport = true;
+	}
+
+	rem = len;
+	for (a = BRVLAN_RTA(bvm); RTA_OK(a, rem); a = RTA_NEXT(a, rem)) {
+		struct bridge_vlan_xstats vstats;
+		struct bridge_vlan_info *vinfo;
+		__u32 vrange = 0;
+		__u8 state = 0;
+
+		parse_rtattr_flags(vtb, BRIDGE_VLANDB_ENTRY_MAX, RTA_DATA(a),
+				   RTA_PAYLOAD(a), NLA_F_NESTED);
+		vinfo = RTA_DATA(vtb[BRIDGE_VLANDB_ENTRY_INFO]);
+
+		memset(&vstats, 0, sizeof(vstats));
+		if (vtb[BRIDGE_VLANDB_ENTRY_RANGE])
+			vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_ENTRY_RANGE]);
+		else
+			vrange = vinfo->vid;
+
+		if (vtb[BRIDGE_VLANDB_ENTRY_STATE])
+			state = rta_getattr_u8(vtb[BRIDGE_VLANDB_ENTRY_STATE]);
+
+		if (vtb[BRIDGE_VLANDB_ENTRY_STATS]) {
+			struct rtattr *stb[BRIDGE_VLANDB_STATS_MAX+1];
+			struct rtattr *attr;
+
+			attr = vtb[BRIDGE_VLANDB_ENTRY_STATS];
+			parse_rtattr(stb, BRIDGE_VLANDB_STATS_MAX, RTA_DATA(attr),
+				     RTA_PAYLOAD(attr));
+
+			if (stb[BRIDGE_VLANDB_STATS_RX_BYTES]) {
+				attr = stb[BRIDGE_VLANDB_STATS_RX_BYTES];
+				vstats.rx_bytes = rta_getattr_u64(attr);
+			}
+			if (stb[BRIDGE_VLANDB_STATS_RX_PACKETS]) {
+				attr = stb[BRIDGE_VLANDB_STATS_RX_PACKETS];
+				vstats.rx_packets = rta_getattr_u64(attr);
+			}
+			if (stb[BRIDGE_VLANDB_STATS_TX_PACKETS]) {
+				attr = stb[BRIDGE_VLANDB_STATS_TX_PACKETS];
+				vstats.tx_packets = rta_getattr_u64(attr);
+			}
+			if (stb[BRIDGE_VLANDB_STATS_TX_BYTES]) {
+				attr = stb[BRIDGE_VLANDB_STATS_TX_BYTES];
+				vstats.tx_bytes = rta_getattr_u64(attr);
+			}
+		}
+		open_json_object(NULL);
+		if (!newport)
+			print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
+		else
+			newport = false;
+		print_range("vlan", vinfo->vid, vrange);
+		print_vlan_flags(vinfo->flags);
+		print_nl();
+		print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
+		print_stp_state(state);
+		print_nl();
+		if (show_stats)
+			__print_one_vlan_stats(&vstats);
+		close_json_object();
+	}
+
+	return 0;
+}
+
 static int vlan_show(int argc, char **argv, int subject)
 {
 	char *filter_dev = NULL;
@@ -644,6 +748,34 @@ static int vlan_show(int argc, char **argv, int subject)
 
 	new_json_obj(json);
 
+	/* if show_details is true then use the new bridge vlan dump format */
+	if (show_details && subject == VLAN_SHOW_VLAN) {
+		__u32 dump_flags = show_stats ? BRIDGE_VLANDB_DUMPF_STATS : 0;
+
+		if (rtnl_brvlandump_req(&rth, PF_BRIDGE, dump_flags) < 0) {
+			perror("Cannot send dump request");
+			exit(1);
+		}
+
+		if (!is_json_context()) {
+			printf("%-" __stringify(IFNAMSIZ) "s  %-"
+			       __stringify(VLAN_ID_LEN) "s", "port",
+			       "vlan-id");
+			printf("\n");
+		}
+
+		ret = rtnl_dump_filter(&rth, print_vlan_rtm, &subject);
+		if (ret < 0) {
+			fprintf(stderr, "Dump terminated\n");
+			exit(1);
+		}
+
+		if (vlan_rtm_cur_ifidx != -1)
+			close_vlan_port();
+
+		goto out;
+	}
+
 	if (!show_stats) {
 		if (rtnl_linkdump_req_filter(&rth, PF_BRIDGE,
 					     (compress_vlans ?
@@ -697,6 +829,7 @@ static int vlan_show(int argc, char **argv, int subject)
 		}
 	}
 
+out:
 	delete_json_obj();
 	fflush(stdout);
 	return 0;
diff --git a/include/libnetlink.h b/include/libnetlink.h
index da96c69b9ede..6bff6bae6ddf 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -285,6 +285,11 @@ int rtnl_from_file(FILE *, rtnl_listen_filter_t handler,
 	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct if_stats_msg))))
 #endif
 
+#ifndef BRVLAN_RTA
+#define BRVLAN_RTA(r) \
+	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct br_vlan_msg))))
+#endif
+
 /* User defined nlmsg_type which is used mostly for logging netlink
  * messages from dump file */
 #define NLMSG_TSTAMP	15
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 90dcae73ce71..9c8ebac3c6aa 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -171,7 +171,7 @@ As a rule, the information is statistics or some time values.
 
 .TP
 .BR "\-d" , " \-details"
-print detailed information about MDB router ports.
+print detailed information about bridge vlan filter entries or MDB router ports.
 
 .TP
 .BR "\-n" , " \-net" , " \-netns " <NETNS>
@@ -881,6 +881,11 @@ STP BPDUs.
 
 This command displays the current VLAN filter table.
 
+.PP
+With the
+.B -details
+option, the command becomes verbose. It displays the per-vlan options.
+
 .PP
 With the
 .B -statistics
-- 
2.30.2

