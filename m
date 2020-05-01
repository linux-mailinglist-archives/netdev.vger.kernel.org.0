Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893E21C0FF2
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgEAIri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgEAIrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:47:37 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC2AC035494
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:47:36 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q124so4294308pgq.13
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jO974P2SgNt56IdBfJHFWe6yIEEN7EPpqSWztd8c4cM=;
        b=Dk3Mrya5LJnNznzughd+KerCNvdjX4r88Hs7r9J6ZlUs1/5TO4dW15ELZ2tDOKqf6+
         8G5NKTsKPk5Bm1MccMZ7SslUvau1XGkgH7AEHbXPGsqy2ErYPxAunrfd3rqwsBl2vUd9
         5ckfQ0S7M5P9atKPiFLZvlhuYSMYNBh647A1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jO974P2SgNt56IdBfJHFWe6yIEEN7EPpqSWztd8c4cM=;
        b=RgfyXCpoqQT5Iz3rOUZTkybm/UVuXXxnPuo0bxiOqRLbWTOY5/wHZMDzfr4eK1k/zE
         b+jyOKD4+0jaqLqe7gqL/ZK4ESHhS0p4OZLKW2uj5xbgD972FMPZGLsPkPmXNNlCBVta
         bmjtDvqmsczEBQCWEh+Y8dCy8yFSqB0Zs1N3OXZa/o4XrpQCLYKcZZH8cvO9XS8KPM3Q
         naWkAtjnTVD2ULGjzPwrRj/lUaE5W+BknQlcbUNlxCY1fTnpUH5u0NAGpCOUlPTgZF6C
         T6ZpLon8rD2+rGA6u8jRlMRp3fH22et6+u36xEB30b377rI1DbPkGDdGf/B49/4dGwu/
         pAUQ==
X-Gm-Message-State: AGi0PuYm7yBMGuuOfgTOh4JGxFEiJKkk+euX4m2uuP/c8rrcD02Na1ov
        FcxaSkAPnOrS/jQL/DS1KAfOa3lPTrc=
X-Google-Smtp-Source: APiQypINnWj6LsW/OWOzuAunH4Iv8rV3VzrAGtC15PywjVubqxJIlcAtB2pyzN8D5Ryvm+H9irDmbw==
X-Received: by 2002:a62:d086:: with SMTP id p128mr3273764pfg.241.1588322856038;
        Fri, 01 May 2020 01:47:36 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id mj4sm1578460pjb.0.2020.05.01.01.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:47:35 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH iproute2 v2 3/6] bridge: Fix output with empty vlan lists
Date:   Fri,  1 May 2020 17:47:17 +0900
Message-Id: <20200501084720.138421-4-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
References: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consider this configuration:

ip link add br0 type bridge
ip link add vx0 type vxlan dstport 4789 external
ip link set dev vx0 master br0
bridge vlan del vid 1 dev vx0
ip link add vx1 type vxlan dstport 4790 external
ip link set dev vx1 master br0

	root@vsid:/src/iproute2# ./bridge/bridge vlan
	port    vlan-id
	br0      1 PVID Egress Untagged

	vx0     None
	vx1      1 PVID Egress Untagged

	root@vsid:/src/iproute2#

Note the useless and inconsistent empty lines.

	root@vsid:/src/iproute2# ./bridge/bridge vlan tunnelshow
	port    vlan-id tunnel-id
	br0
	vx0     None
	vx1

What's the difference between "None" and ""?

	root@vsid:/src/iproute2# ./bridge/bridge -j -p vlan tunnelshow
	[ {
		"ifname": "br0",
		"tunnels": [ ]
	    },{
		"ifname": "vx1",
		"tunnels": [ ]
	    } ]

Why does vx0 appear in normal output and not json output?
Why output an empty list for br0 and vx1?

Fix these inconsistencies and avoid outputting entries with no values. This
makes the behavior consistent with other iproute2 commands, for example
`ip -6 addr`: if an interface doesn't have any ipv6 addresses, it is not
part of the listing.

Fixes: 8652eeb3ab12 ("bridge: vlan: support for per vlan tunnel info")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c                            | 36 +++++++++++++-----------
 testsuite/tests/bridge/vlan/show.t       | 30 ++++++++++++++++++++
 testsuite/tests/bridge/vlan/tunnelshow.t |  2 +-
 3 files changed, 50 insertions(+), 18 deletions(-)
 create mode 100755 testsuite/tests/bridge/vlan/show.t

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 37ff2973..b126fae2 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -290,8 +290,7 @@ static void print_vlan_tunnel_info(struct rtattr *tb, int ifindex)
 	int rem = RTA_PAYLOAD(list);
 	__u16 last_vid_start = 0;
 	__u32 last_tunid_start = 0;
-
-	open_vlan_port(ifindex, "%s", VLAN_SHOW_TUNNELINFO);
+	bool opened = false;
 
 	for (i = RTA_DATA(list); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
 		struct rtattr *ttb[IFLA_BRIDGE_VLAN_TUNNEL_MAX+1];
@@ -331,13 +330,20 @@ static void print_vlan_tunnel_info(struct rtattr *tb, int ifindex)
 		else if (vcheck_ret == 0)
 			continue;
 
+		if (!opened) {
+			open_vlan_port(ifindex, "%s", VLAN_SHOW_TUNNELINFO);
+			opened = true;
+		}
+
 		open_json_object(NULL);
 		print_range("vlan", last_vid_start, tunnel_vid);
 		print_range("tunid", last_tunid_start, tunnel_id);
 		close_json_object();
 		print_string(PRINT_FP, NULL, "%s", _SL_);
 	}
-	close_vlan_port();
+
+	if (opened)
+		close_vlan_port();
 }
 
 static int print_vlan(struct nlmsghdr *n, void *arg)
@@ -366,16 +372,8 @@ static int print_vlan(struct nlmsghdr *n, void *arg)
 		return 0;
 
 	parse_rtattr(tb, IFLA_MAX, IFLA_RTA(ifm), len);
-
-	/* if AF_SPEC isn't there, vlan table is not preset for this port */
-	if (!tb[IFLA_AF_SPEC]) {
-		if (!filter_vlan && !is_json_context()) {
-			color_fprintf(stdout, COLOR_IFNAME, "%s",
-				      ll_index_to_name(ifm->ifi_index));
-			fprintf(stdout, "\tNone\n");
-		}
+	if (!tb[IFLA_AF_SPEC])
 		return 0;
-	}
 
 	switch (*subject) {
 	case VLAN_SHOW_VLAN:
@@ -385,9 +383,7 @@ static int print_vlan(struct nlmsghdr *n, void *arg)
 		print_vlan_tunnel_info(tb[IFLA_AF_SPEC], ifm->ifi_index);
 		break;
 	}
-	print_string(PRINT_FP, NULL, "%s", _SL_);
 
-	fflush(stdout);
 	return 0;
 }
 
@@ -588,8 +584,7 @@ void print_vlan_info(struct rtattr *tb, int ifindex)
 	struct rtattr *i, *list = tb;
 	int rem = RTA_PAYLOAD(list);
 	__u16 last_vid_start = 0;
-
-	open_vlan_port(ifindex, "%s", VLAN_SHOW_VLAN);
+	bool opened = false;
 
 	for (i = RTA_DATA(list); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
 		struct bridge_vlan_info *vinfo;
@@ -608,6 +603,11 @@ void print_vlan_info(struct rtattr *tb, int ifindex)
 		else if (vcheck_ret == 0)
 			continue;
 
+		if (!opened) {
+			open_vlan_port(ifindex, "%s", VLAN_SHOW_VLAN);
+			opened = true;
+		}
+
 		open_json_object(NULL);
 		print_range("vlan", last_vid_start, vinfo->vid);
 
@@ -615,7 +615,9 @@ void print_vlan_info(struct rtattr *tb, int ifindex)
 		close_json_object();
 		print_string(PRINT_FP, NULL, "%s", _SL_);
 	}
-	close_vlan_port();
+
+	if (opened)
+		close_vlan_port();
 }
 
 int do_vlan(int argc, char **argv)
diff --git a/testsuite/tests/bridge/vlan/show.t b/testsuite/tests/bridge/vlan/show.t
new file mode 100755
index 00000000..3def2022
--- /dev/null
+++ b/testsuite/tests/bridge/vlan/show.t
@@ -0,0 +1,30 @@
+#!/bin/sh
+
+. lib/generic.sh
+
+ts_log "[Testing vlan show]"
+
+BR_DEV="$(rand_dev)"
+VX0_DEV="$(rand_dev)"
+VX1_DEV="$(rand_dev)"
+
+ts_ip "$0" "Add $BR_DEV bridge interface" link add $BR_DEV type bridge
+
+ts_ip "$0" "Add $VX0_DEV vxlan interface" \
+	link add $VX0_DEV type vxlan dstport 4789 external
+ts_ip "$0" "Enslave $VX0_DEV under $BR_DEV" \
+	link set dev $VX0_DEV master $BR_DEV
+ts_bridge "$0" "Delete default vlan from $VX0_DEV" \
+	vlan del dev $VX0_DEV vid 1
+ts_ip "$0" "Add $VX1_DEV vxlan interface" \
+	link add $VX1_DEV type vxlan dstport 4790 external
+ts_ip "$0" "Enslave $VX1_DEV under $BR_DEV" \
+	link set dev $VX1_DEV master $BR_DEV
+
+# Test that bridge ports without vlans do not appear in the output
+ts_bridge "$0" "Show vlan" vlan
+test_on_not "$VX0_DEV"
+
+# Test that bridge ports without tunnels do not appear in the output
+ts_bridge "$0" "Show vlan tunnel info" vlan tunnelshow
+test_lines_count 1 # header only
diff --git a/testsuite/tests/bridge/vlan/tunnelshow.t b/testsuite/tests/bridge/vlan/tunnelshow.t
index fd41bfcb..3e9c12a2 100755
--- a/testsuite/tests/bridge/vlan/tunnelshow.t
+++ b/testsuite/tests/bridge/vlan/tunnelshow.t
@@ -28,6 +28,6 @@ ts_bridge "$0" "Add tunnel with vni > 16k" \
 
 ts_bridge "$0" "Show tunnel info" vlan tunnelshow dev $VX_DEV
 test_on "1030\s+65556"
-test_lines_count 5
+test_lines_count 4
 
 ts_bridge "$0" "Dump tunnel info" -j vlan tunnelshow dev $VX_DEV
-- 
2.26.0

