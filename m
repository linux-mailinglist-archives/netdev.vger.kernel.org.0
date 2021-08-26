Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B423A3F885D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242633AbhHZNK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242091AbhHZNKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:13 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48836C0613C1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:26 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s25so4662129edw.0
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SAHIuM6aUX02e/D7QQ2Nf6PHecj7go+UggKGNFx80hk=;
        b=l+M/EVJz/dxoklzcE66JmNc9UgcPb7CmYTNDx7YmaHFSKmMH7HckgHvMna85FyMW28
         BzNWelxVO4d+e5zk6k8my/I643gUludXo2qtfAdtS7dQ+oGHg9izLtfBXfgHwSVcKJEK
         0bVYpKaXi//JGpIb1idWtynSNn4NtxQKuN3kwFXsusnqokcZCwS3uAPGeIKZuDAYK7xU
         lEzH3kezIrb25eXweWwb9sGrB+moXTsSGtWpjQZqJ6JE9CSMsrGyyALl4OKCKHk3OnuK
         lnJuZMI0yugt5zo6d1IfF04ygw9VqL90qaa04i5cUuzRubbdhj9nvIVAhVVAvFdLMrAz
         5JRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SAHIuM6aUX02e/D7QQ2Nf6PHecj7go+UggKGNFx80hk=;
        b=Fg/VZYJJWmRCj0Icfc4ejxxuZXCZc81LYFdzZwmcQ7XvR3D67kqBCMwCxElyRvcccr
         DfP3Aqei5Cyye4qcH2Y+7fOATNQZ1mbT6OC9y+hpTm30LBpwzknzRjhOgPp5nL1T6P0O
         Y4xZMk9AwqVrltPEyx8KEP/kRa+qkE/0G2iMlrcGrx6venWCeaxucJXIyYWiKGF4Ifux
         IUtJ1PZS0gBLpzJwczFc+pFRR/Ns1GXE/NbSU9azgh6VI8kwyEcnAqwLV3YH25sXnV7t
         MBw6rVE9KXurcm3vR5EibZmNhswuAmLAS2EoPA1jQ22T9moqf7ka3cx2DZqk4lgZDkWC
         ebvQ==
X-Gm-Message-State: AOAM5313Zs6S/YsblrFOIn5NmfxkvQuKcRawr5HLJkBc+SLNoHwPfT61
        IDjcB5qroH4Nmu+mJ0exFL93S5CY9mDypxWZ
X-Google-Smtp-Source: ABdhPJzK1mV08PZVd5NTiZV1AMQKaSs/O6YWtu2hFmmVBRl363d8mk0dsEAa1RVYHvFpz3Ap+7yTbA==
X-Received: by 2002:aa7:cf82:: with SMTP id z2mr4263012edx.254.1629983364624;
        Thu, 26 Aug 2021 06:09:24 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:24 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 08/17] bridge: vlan: add global mcast_last_member_count option
Date:   Thu, 26 Aug 2021 16:05:24 +0300
Message-Id: <20210826130533.149111-9-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_last_member_count option
which controls the number of queries the bridge will send on the vlan after
a leave is received (default 2).
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_last_member_count 10

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 | 10 +++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 00b4f8a00d9b..ee9442e3908f 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -41,6 +41,7 @@ static void usage(void)
 		"       bridge vlan global { set } vid VLAN_ID dev DEV [ mcast_snooping MULTICAST_SNOOPING ]\n"
 		"                                                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"                                                      [ mcast_mld_version MLD_VERSION ]\n"
+		"                                                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -358,6 +359,7 @@ static int vlan_global_option_set(int argc, char **argv)
 	short vid_end = -1;
 	char *d = NULL;
 	short vid = -1;
+	__u32 val32;
 	__u8 val8;
 
 	afspec = addattr_nest(&req.n, sizeof(req),
@@ -419,6 +421,13 @@ static int vlan_global_option_set(int argc, char **argv)
 				invarg("invalid mcast_mld_version", *argv);
 			addattr8(&req.n, 1024,
 				 BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION, val8);
+		} else if (strcmp(*argv, "mcast_last_member_count") == 0) {
+			NEXT_ARG();
+			if (get_u32(&val32, *argv, 0))
+				invarg("invalid mcast_last_member_count", *argv);
+			addattr32(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT,
+				  val32);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -767,6 +776,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_mld_version",
 			   "mcast_mld_version %u ", rta_getattr_u8(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT];
+		print_uint(PRINT_ANY, "mcast_last_member_count",
+			   "mcast_last_member_count %u ",
+			   rta_getattr_u32(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index dcbff9367334..cea755184336 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -163,7 +163,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_igmp_version
 .IR IGMP_VERSION " ] [ "
 .B mcast_mld_version
-.IR MLD_VERSION " ]"
+.IR MLD_VERSION " ] [ "
+.B mcast_last_member_count
+.IR LAST_MEMBER_COUNT " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -943,6 +945,12 @@ set the IGMP version. Default is 2.
 .BI mcast_mld_version " MLD_VERSION "
 set the MLD version. Default is 1.
 
+.TP
+.BI mcast_last_member_count " LAST_MEMBER_COUNT "
+set multicast last member count, ie the number of queries the bridge
+will send before stopping forwarding a multicast group after a "leave"
+message has been received. Default is 2.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

