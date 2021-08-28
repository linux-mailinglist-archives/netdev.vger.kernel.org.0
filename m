Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614B23FA549
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhH1LJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbhH1LJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:14 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFC3C06179A
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:23 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z10so13827232edb.6
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ncMJODkts9053bN1DtpTCrMWkuDdLSmgLzTrOvQly80=;
        b=FDOtoCNr1+0OYgD7nY+n7b791pgPcdcBl3aZ1gvQy2odS35rzbrxNgvHug8S8wZZ9K
         7EQPaMo9ckMtn+BsVg7C6tbpBHZOIhcZ/qccnOe9kENTvPc5ty+tzKcNsQBfYhyag1tH
         CDimlShAEsBF7RzRm6HzrNi02FjTxwI5u9gKvY3CcNFa2iqPsYte/z5W34QeEw9v12bp
         /MQfWN8lC+w7oB1GQUb23UVpXwa7zS1HLMncFCJBR8Xvf9f1D55sqK28m2o/oMNUMHfk
         XHk9GAVceMzL4J5gtONCy25wRrpXdttQTbc+JfGHTLwQe63sDR06zwCwbsgZQC32PiUX
         p+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ncMJODkts9053bN1DtpTCrMWkuDdLSmgLzTrOvQly80=;
        b=siGYSRZplvOWI0Cz4h7ekUDS/cE2UKeaYaqYNCdJi4pKPamnfSbzHZObdg31GvR4WF
         4b0Re205uniZjQ4eBSA8/bUaZcuTpqabf6ZmWgLwSzlOjhVR4JiaDRhPkCB9VxxnPUKe
         IbR0W5efVxik/0PnQw4W53XQBUqrPIRgqolm75rJZ7s3rNQ0QdlXKyr536vyBsiu6ML2
         xQg4JcPOxnUshnKBExqzbXZORpldp20Ktu/SHDwsPZ3dsPngm2hFcY1wii32snnLoHAo
         RytBhyOXdsamo4bzOVrOc/19rNg6NUKkdiRhw9m2dSgK8DMcmZnAlT4QOriuTBpAa3Md
         Hazg==
X-Gm-Message-State: AOAM533SDAaWj/udmE3KDYpNuXq3qwGY24A6Jv32/wzOJBWJqt0d66Lm
        iuFMEhv2Uc5DX8j6GUozeu0M4lure7SLBfJU
X-Google-Smtp-Source: ABdhPJzYFijoM9YRKHBci1x7mhufMOsb6S9EavvPXCaQgHJTY6cQ09Ts3pYh2pQhIPVEeNzuD/t5VA==
X-Received: by 2002:aa7:db82:: with SMTP id u2mr14880128edt.299.1630148902236;
        Sat, 28 Aug 2021 04:08:22 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:21 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 07/19] bridge: vlan: add global mcast_snooping option
Date:   Sat, 28 Aug 2021 14:07:53 +0300
Message-Id: <20210828110805.463429-8-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_snooping option which
controls if multicast snooping is enabled or disabled for a single vlan.
Syntax: $ bridge vlan global set dev bridge vid 1 mcast_snooping 1

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 18 +++++++++++++++++-
 man/man8/bridge.8 | 11 ++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 34fba0a5bdfb..b1a8cfc4a362 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -9,6 +9,7 @@
 #include <linux/if_bridge.h>
 #include <linux/if_ether.h>
 #include <string.h>
+#include <errno.h>
 
 #include "json_print.h"
 #include "libnetlink.h"
@@ -38,6 +39,7 @@ static void usage(void)
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
+		"                      [ mcast_snooping MULTICAST_SNOOPING ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -355,6 +357,7 @@ static int vlan_global_option_set(int argc, char **argv)
 	short vid_end = -1;
 	char *d = NULL;
 	short vid = -1;
+	__u8 val8;
 
 	afspec = addattr_nest(&req.n, sizeof(req),
 			      BRIDGE_VLANDB_GLOBAL_OPTIONS);
@@ -397,6 +400,12 @@ static int vlan_global_option_set(int argc, char **argv)
 			if (vid_end != -1)
 				addattr16(&req.n, sizeof(req),
 					  BRIDGE_VLANDB_GOPTS_RANGE, vid_end);
+		} else if (strcmp(*argv, "mcast_snooping") == 0) {
+			NEXT_ARG();
+			if (get_u8(&val8, *argv, 0))
+				invarg("invalid mcast_snooping", *argv);
+			addattr8(&req.n, 1024,
+				 BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING, val8);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -702,7 +711,7 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 
 static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 {
-	struct rtattr *vtb[BRIDGE_VLANDB_GOPTS_MAX + 1];
+	struct rtattr *vtb[BRIDGE_VLANDB_GOPTS_MAX + 1], *vattr;
 	__u16 vid, vrange = 0;
 
 	if ((a->rta_type & NLA_TYPE_MASK) != BRIDGE_VLANDB_GLOBAL_OPTIONS)
@@ -729,6 +738,13 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 	}
 	print_range("vlan", vid, vrange);
 	print_nl();
+	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING];
+		print_uint(PRINT_ANY, "mcast_snooping", "mcast_snooping %u ",
+			   rta_getattr_u8(vattr));
+	}
+	print_nl();
 	close_json_object();
 }
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 796d20b662ab..d894289b2dc2 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -157,7 +157,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B dev
 .I DEV
 .B vid
-.IR VID " [ ]"
+.IR VID " [ "
+.B mcast_snooping
+.IR MULTICAST_SNOOPING " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -922,6 +924,13 @@ supported for global options.
 .BI vid " VID"
 the VLAN ID that identifies the vlan.
 
+.TP
+.BI mcast_snooping " MULTICAST_SNOOPING "
+turn multicast snooping for VLAN entry with VLAN ID on
+.RI ( MULTICAST_SNOOPING " > 0) "
+or off
+.RI ( MULTICAST_SNOOPING " == 0). Default is on. "
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

