Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E0A3FA53F
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhH1LJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbhH1LJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:08 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECB2C061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:18 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g21so13851820edw.4
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O6PU9BNFRciVQMe7iAxXKKxQJbsvApp/c24DcKGAh/A=;
        b=o2ZCgLqhw/x6qId4fUk38s17i6+GDldgZOQxE7KR5e/frKPnb73L7kSUH9FoSuCMvX
         oQexf8+xljSkTzsrskE1l0mykgtoTbs/SfYRBZCXMtuNVw44Gv31q4T1GVM09dnriFAg
         4XddtKivRFRqwQTOD7yuHqqIHa0ZJjghS23OcK+OAku90Jj5CBPd55yHIocdmNjhAVZ/
         Fiqv3oGNGHFtn3PkQru5MUtCcNsBRmW543qgX6yywh29+btVO/vhkDSdZeyT4XKo5Hrg
         vGA5vCjfStith8dLx1whn25Biq79yvBWvw8HK9xmRBrcRxfs0fbmKDF5nqzcfzBGu/iK
         jGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O6PU9BNFRciVQMe7iAxXKKxQJbsvApp/c24DcKGAh/A=;
        b=ZsrmyeV5U7lMqkAEFsKkyHy1QQJxxBUwG4cF26sh+EbeMTe7vDbTkRgB35eL8zQFKi
         rfy1tGGCBbmjOkdMJAIXHWeiPsgQqG0zPnK0fw2ULecuyWtjdNVdASBvdCSORiBNF2nH
         RNwvRY7gTZiwhHRdjx0HYPWAt8exC1bYGgDbqzB69SEAWDBqibrhuaAOxQzVhautexpP
         +eVHEDQc5tIVIzS5p/4LDT8X5G6QJtnusR3P9t3A2jyeREfQ6INcnYq11IJbfMAT3nSQ
         VA1i5LQ0smv8ZHBS5+YAIwicTyQH/KZ7FjsPWEP1XUFRBXde78IUWEEQ4UEJZ5bQMjpC
         ffvQ==
X-Gm-Message-State: AOAM531NvUQ8q2BHnGDLdvqJ37MY9cAA/c9Z4mOZ/u3QWiULZFdYN+Tf
        EewI0CMKsvinl3kqC2n0d7t1grhVwx5ZYPOT
X-Google-Smtp-Source: ABdhPJzw/1hRrzE6MbZVXvdut6I9YwPTlDnt0/ncLF14Ncsz6ziZF5b12itR8GMnHwXYqzR+CMU0fA==
X-Received: by 2002:a05:6402:1248:: with SMTP id l8mr14332457edw.94.1630148896722;
        Sat, 28 Aug 2021 04:08:16 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:16 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 02/19] bridge: vlan: factor out vlan option printing
Date:   Sat, 28 Aug 2021 14:07:48 +0300
Message-Id: <20210828110805.463429-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Factor out the code which prints current per-vlan options from
print_vlan_rtm without any changes, later we'll filter based on the vlan
attribute and add support for global vlan option printing.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: new patch (split off of previous patch 02)

 bridge/vlan.c | 110 ++++++++++++++++++++++++++------------------------
 1 file changed, 58 insertions(+), 52 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 9b6511f189ff..b9d928010cb4 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -621,11 +621,67 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
+static void print_vlan_opts(struct rtattr *a)
+{
+	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1];
+	struct bridge_vlan_xstats vstats;
+	struct bridge_vlan_info *vinfo;
+	__u16 vrange = 0;
+	__u8 state = 0;
+
+	parse_rtattr_flags(vtb, BRIDGE_VLANDB_ENTRY_MAX, RTA_DATA(a),
+			   RTA_PAYLOAD(a), NLA_F_NESTED);
+	vinfo = RTA_DATA(vtb[BRIDGE_VLANDB_ENTRY_INFO]);
+
+	memset(&vstats, 0, sizeof(vstats));
+	if (vtb[BRIDGE_VLANDB_ENTRY_RANGE])
+		vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_ENTRY_RANGE]);
+	else
+		vrange = vinfo->vid;
+
+	if (vtb[BRIDGE_VLANDB_ENTRY_STATE])
+		state = rta_getattr_u8(vtb[BRIDGE_VLANDB_ENTRY_STATE]);
+
+	if (vtb[BRIDGE_VLANDB_ENTRY_STATS]) {
+		struct rtattr *stb[BRIDGE_VLANDB_STATS_MAX+1];
+		struct rtattr *attr;
+
+		attr = vtb[BRIDGE_VLANDB_ENTRY_STATS];
+		parse_rtattr(stb, BRIDGE_VLANDB_STATS_MAX, RTA_DATA(attr),
+			     RTA_PAYLOAD(attr));
+
+		if (stb[BRIDGE_VLANDB_STATS_RX_BYTES]) {
+			attr = stb[BRIDGE_VLANDB_STATS_RX_BYTES];
+			vstats.rx_bytes = rta_getattr_u64(attr);
+		}
+		if (stb[BRIDGE_VLANDB_STATS_RX_PACKETS]) {
+			attr = stb[BRIDGE_VLANDB_STATS_RX_PACKETS];
+			vstats.rx_packets = rta_getattr_u64(attr);
+		}
+		if (stb[BRIDGE_VLANDB_STATS_TX_PACKETS]) {
+			attr = stb[BRIDGE_VLANDB_STATS_TX_PACKETS];
+			vstats.tx_packets = rta_getattr_u64(attr);
+		}
+		if (stb[BRIDGE_VLANDB_STATS_TX_BYTES]) {
+			attr = stb[BRIDGE_VLANDB_STATS_TX_BYTES];
+			vstats.tx_bytes = rta_getattr_u64(attr);
+		}
+	}
+	print_range("vlan", vinfo->vid, vrange);
+	print_vlan_flags(vinfo->flags);
+	print_nl();
+	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
+	print_stp_state(state);
+	print_nl();
+	if (show_stats)
+		__print_one_vlan_stats(&vstats);
+}
+
 int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 {
-	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1], *a;
 	struct br_vlan_msg *bvm = NLMSG_DATA(n);
 	int len = n->nlmsg_len;
+	struct rtattr *a;
 	int rem;
 
 	if (n->nlmsg_type != RTM_NEWVLAN && n->nlmsg_type != RTM_DELVLAN &&
@@ -660,49 +716,6 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 
 	rem = len;
 	for (a = BRVLAN_RTA(bvm); RTA_OK(a, rem); a = RTA_NEXT(a, rem)) {
-		struct bridge_vlan_xstats vstats;
-		struct bridge_vlan_info *vinfo;
-		__u32 vrange = 0;
-		__u8 state = 0;
-
-		parse_rtattr_flags(vtb, BRIDGE_VLANDB_ENTRY_MAX, RTA_DATA(a),
-				   RTA_PAYLOAD(a), NLA_F_NESTED);
-		vinfo = RTA_DATA(vtb[BRIDGE_VLANDB_ENTRY_INFO]);
-
-		memset(&vstats, 0, sizeof(vstats));
-		if (vtb[BRIDGE_VLANDB_ENTRY_RANGE])
-			vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_ENTRY_RANGE]);
-		else
-			vrange = vinfo->vid;
-
-		if (vtb[BRIDGE_VLANDB_ENTRY_STATE])
-			state = rta_getattr_u8(vtb[BRIDGE_VLANDB_ENTRY_STATE]);
-
-		if (vtb[BRIDGE_VLANDB_ENTRY_STATS]) {
-			struct rtattr *stb[BRIDGE_VLANDB_STATS_MAX+1];
-			struct rtattr *attr;
-
-			attr = vtb[BRIDGE_VLANDB_ENTRY_STATS];
-			parse_rtattr(stb, BRIDGE_VLANDB_STATS_MAX, RTA_DATA(attr),
-				     RTA_PAYLOAD(attr));
-
-			if (stb[BRIDGE_VLANDB_STATS_RX_BYTES]) {
-				attr = stb[BRIDGE_VLANDB_STATS_RX_BYTES];
-				vstats.rx_bytes = rta_getattr_u64(attr);
-			}
-			if (stb[BRIDGE_VLANDB_STATS_RX_PACKETS]) {
-				attr = stb[BRIDGE_VLANDB_STATS_RX_PACKETS];
-				vstats.rx_packets = rta_getattr_u64(attr);
-			}
-			if (stb[BRIDGE_VLANDB_STATS_TX_PACKETS]) {
-				attr = stb[BRIDGE_VLANDB_STATS_TX_PACKETS];
-				vstats.tx_packets = rta_getattr_u64(attr);
-			}
-			if (stb[BRIDGE_VLANDB_STATS_TX_BYTES]) {
-				attr = stb[BRIDGE_VLANDB_STATS_TX_BYTES];
-				vstats.tx_bytes = rta_getattr_u64(attr);
-			}
-		}
 		if (vlan_rtm_cur_ifidx != bvm->ifindex) {
 			open_vlan_port(bvm->ifindex, VLAN_SHOW_VLAN);
 			open_json_object(NULL);
@@ -711,14 +724,7 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 			open_json_object(NULL);
 			print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
 		}
-		print_range("vlan", vinfo->vid, vrange);
-		print_vlan_flags(vinfo->flags);
-		print_nl();
-		print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
-		print_stp_state(state);
-		print_nl();
-		if (show_stats)
-			__print_one_vlan_stats(&vstats);
+		print_vlan_opts(a);
 		close_json_object();
 	}
 
-- 
2.31.1

