Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024DD3F885A
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242579AbhHZNKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242341AbhHZNKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:13 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82520C0617AD
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:23 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b7so4605750edu.3
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NftQxmYPxo3GG5EzKsDrgiloRa3JulEDPqpRpzypQNI=;
        b=mP2kZK9OTQgDN9CDUyvabj1K2KC0RYUGOw1IVUHGtsI37odo4DsQJ3ywqRWeMF20//
         fjQ30LxQFd0zV5G7ZuLJR8lz/qgm85LfNPTpGZGDKSkhKAs/uLKJ6frX7TfnLvpMYmRi
         xxbhZXsICIWy42oLnUi2QSdUdqp2Sw6iCiDCWpseLdZvUFm8zKDnL8bmiunyK2F/xQXg
         otdww/D79FIk+IhD49MdC8sGR3mTeVI/vnBvWNB1e7ubILXadL/HtkCnMn7dIEkDmjG9
         sPlFnYwFt20YQfmhy6Cjsw9nPnYRHL0FB5ybzHGRCj5tCh5cD1YGtBWRjs2370W/Pn+5
         NmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NftQxmYPxo3GG5EzKsDrgiloRa3JulEDPqpRpzypQNI=;
        b=hiiuXZDnd0Uj8lOlDk8nAMRDPwiAeLeNnkYaHSHbFCBJSFvEPSGE+BgInC0Rf0J3qi
         SaPRQ5+wZaANcQxtBitHLwMHBty519kfBBGNgasYqauFR2O4FoC1WgXGMukC9CPYVP28
         a8l9igqNCTbnbKNBFyzMncGRg9dmozOSRScJAHCSzv58RyC6lZFodmm6ab6TML9CpbAI
         ldM56+I8t7AZ2IT4QxrZvsQec515+3EbMGjaLjuVxCgcE9vsKf/OBJPbDLKkB71/UwNp
         YG5zhuho3RUBrSlPiVoUUVJho4qwXuUw6jS+iZV2d6CSoKBajM9bbH1MfAC4UCQjIIdj
         WPhg==
X-Gm-Message-State: AOAM5315fSKdQA2hxce2RjqJjh/bWYnFrhmRpREhYveMj+mJ0BzXumU6
        Ek7XI5jNNy6EFoPZeyoW0IXh5bJnvQvH/4jy
X-Google-Smtp-Source: ABdhPJyfm5mGp6K+Oh3hHprfD74MF2hPULZ6UTpO+R+LhKAdwFoMoV2ponHNYVOz+1o6Zh+vLdPrqg==
X-Received: by 2002:a05:6402:d6b:: with SMTP id ec43mr916075edb.107.1629983361863;
        Thu, 26 Aug 2021 06:09:21 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:21 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 06/17] bridge: vlan: add global mcast_igmp_version option
Date:   Thu, 26 Aug 2021 16:05:22 +0300
Message-Id: <20210826130533.149111-7-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_igmp_version option
which controls the IGMP version on the vlan (default 2).
Syntax: $ bridge vlan global set dev bridge vid 1 mcast_igmp_version 3

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 12 ++++++++++++
 man/man8/bridge.8 |  8 +++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 372e5b43be0f..346026b6f955 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -39,6 +39,7 @@ static void usage(void)
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV [ mcast_snooping MULTICAST_SNOOPING ]\n"
+		"                                                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -405,6 +406,12 @@ static int vlan_global_option_set(int argc, char **argv)
 				invarg("invalid mcast_snooping", *argv);
 			addattr8(&req.n, 1024,
 				 BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING, val8);
+		} else if (strcmp(*argv, "mcast_igmp_version") == 0) {
+			NEXT_ARG();
+			if (get_u8(&val8, *argv, 0))
+				invarg("invalid mcast_igmp_version", *argv);
+			addattr8(&req.n, 1024,
+				 BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION, val8);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -743,6 +750,11 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_snooping", "mcast_snooping %u ",
 			   rta_getattr_u8(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION];
+		print_uint(PRINT_ANY, "mcast_igmp_version",
+			   "mcast_igmp_version %u ", rta_getattr_u8(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index d894289b2dc2..224647b49843 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -159,7 +159,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B vid
 .IR VID " [ "
 .B mcast_snooping
-.IR MULTICAST_SNOOPING " ]"
+.IR MULTICAST_SNOOPING " ] [ "
+.B mcast_igmp_version
+.IR IGMP_VERSION " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -931,6 +933,10 @@ turn multicast snooping for VLAN entry with VLAN ID on
 or off
 .RI ( MULTICAST_SNOOPING " == 0). Default is on. "
 
+.TP
+.BI mcast_igmp_version " IGMP_VERSION "
+set the IGMP version. Default is 2.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

