Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3603F885B
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbhHZNKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242278AbhHZNKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:13 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F155C0617A8
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:22 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r19so4520392eds.13
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZM29v3ealuL3u63ymxXiHwHpgDk5gIlTm7WUhOMS5n4=;
        b=irjnN2oaMh46cxPwsyyEeytL9U1hf2oPbgyj64aNt4xWdOK9/YdzoX0wV3YCLDP2S2
         AIhJSyhEkuL3ykMmhSyjKTmNTSv+3YCZghbo0F9YgTQkbQbH0AL/B2HUEFPMtvHlsFal
         H5Hotvzj5pLkhzKJgyD4bWSOlByFszJ7Z2uC8xfq5rzX6zkYo5LSMhwpJKyg01Wjl/lV
         vRs1/KeO4NJLOXa1BjF1fwwUtPToNZV7iY3lOz5JPG7/tIWhNC9818QQz5Kcb+YYoTTN
         mA2+CdnpWjG0AYAKP3mw8Ttzr/0//CLex53Bg2W+HleRLZfxaJT4oPx3su37KbxYN8Ll
         T/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZM29v3ealuL3u63ymxXiHwHpgDk5gIlTm7WUhOMS5n4=;
        b=Ze6evdBZQwqU6FpOdvdbSmF9oQ6jpe/hqdtqJRCXjvJNNqTLV6DpsXIfMcBn8zMX62
         BVV0C/iOAuALTbk31XJ5yCdksDfzKCzlH9Bd/XXtxxNdScfTx3RhXGHFPCDyp2yJNfwZ
         T+3fI0Pi541Lty18647s7DScgrmRcli/ZruY63zJ6UKkbMhuZfTbs6i4K2rSjj3QwAUy
         45YqIl31l/MMZumO8OWsupdryXZoh8lAXrdmTAdWSB5jiReRenXXpqwJVK8DL/H7htWI
         xBvIYwD6J4ZSuTV8SnjTNoZGxkuieNSXk/8vHwP4FygHa58YKH33wtXumeRmj4WUfulg
         7kXg==
X-Gm-Message-State: AOAM532FJpIMum/TSJ63fvnPyJ3vP2laXUnK6/TeM2Fb+UXwcAtk+qYT
        ZGCuXvZU8GiDTuzUV7z+jq7cCqTNqwobrSgi
X-Google-Smtp-Source: ABdhPJyxKLMPlFM7CrHDlZacOHt8lnFT4NW16z2CdOMlcj6ornF7KAzFvl5azM8i/88hUsVvOLwdlA==
X-Received: by 2002:a05:6402:8c6:: with SMTP id d6mr4336707edz.30.1629983360783;
        Thu, 26 Aug 2021 06:09:20 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:20 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 05/17] bridge: vlan: add global mcast_snooping option
Date:   Thu, 26 Aug 2021 16:05:21 +0300
Message-Id: <20210826130533.149111-6-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
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
 bridge/vlan.c     | 19 +++++++++++++++++--
 man/man8/bridge.8 | 11 ++++++++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 34fba0a5bdfb..372e5b43be0f 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -9,6 +9,7 @@
 #include <linux/if_bridge.h>
 #include <linux/if_ether.h>
 #include <string.h>
+#include <errno.h>
 
 #include "json_print.h"
 #include "libnetlink.h"
@@ -37,7 +38,7 @@ static void usage(void)
 		"       bridge vlan { set } vid VLAN_ID dev DEV [ state STP_STATE ]\n"
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
-		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
+		"       bridge vlan global { set } vid VLAN_ID dev DEV [ mcast_snooping MULTICAST_SNOOPING ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -355,6 +356,7 @@ static int vlan_global_option_set(int argc, char **argv)
 	short vid_end = -1;
 	char *d = NULL;
 	short vid = -1;
+	__u8 val8;
 
 	afspec = addattr_nest(&req.n, sizeof(req),
 			      BRIDGE_VLANDB_GLOBAL_OPTIONS);
@@ -397,6 +399,12 @@ static int vlan_global_option_set(int argc, char **argv)
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
@@ -702,7 +710,7 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 
 static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 {
-	struct rtattr *vtb[BRIDGE_VLANDB_GOPTS_MAX + 1];
+	struct rtattr *vtb[BRIDGE_VLANDB_GOPTS_MAX + 1], *vattr;
 	__u16 vid, vrange = 0;
 
 	if ((a->rta_type & NLA_TYPE_MASK) != BRIDGE_VLANDB_GLOBAL_OPTIONS)
@@ -729,6 +737,13 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
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

