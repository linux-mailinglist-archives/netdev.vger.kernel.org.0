Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A286F3F8856
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbhHZNKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241640AbhHZNKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:05 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEE1C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:18 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id t19so6140886ejr.8
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TXPUt2JdaQ55E00ISU1OjYxSbcH47hkR9O7fdSCmbYM=;
        b=ph0twr5ogIroIrvFROyeQ75AoVfRZmwcI+mMvmwgKLpnPMHsmYVYgQoQCeuYn/YCHU
         IMao26Ok6WDnyUJ+ffhoi6XS8CYf+vnWkawAK8UEGuzciFQLEc1EwAw4Mvum70dlb2CG
         RMGbdG1p3bF0eQ+K8Rp2LpqXqP0JCkwj3oTFAv4nVQ5p63jcUjUe44sTqgAEsWpn+c3u
         ay062YUMsNBj9aTwedICxOB+4g+f4YL8HC/dVWdDRQKQPQe4Wlmqt2r1Mgl5ovjObMJv
         vwFCSHrEY45SKUU/hvxhKQUQsv59qYt1PiYXukHTU8dpcWHhU6Cc/n5MHw480JQTZtEn
         WDeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TXPUt2JdaQ55E00ISU1OjYxSbcH47hkR9O7fdSCmbYM=;
        b=KwIHELcl/TGlt53TxxhldbzvQwggyETUiqhfNjXfnzHU2X1cgtYNs7w20ac1ZS6yPK
         WW9tB71V0gYduN51l5w1ueiPpBy27gaWobMmDRofdhu5suT65WU9ho2NESUokpDnUwxJ
         298bUxmR3bOQXJUWIMisanvTqykqfCEjvPiE16z/8DIK6mu3za7dPjd3APhr8N6hsYyN
         kXDggQtw48pkCrqCj1ovO4+ejzA3pXjACt2tl01LXqLUM4bjtV0YBTnCw3Rbif5iV1TY
         0MIfEx5dggRnbDmfFS8iTbUtSHIU5vnxlFr9AI2YiPdE/Hv3IMPwbOhMuNUIVYStLFwD
         Pjvg==
X-Gm-Message-State: AOAM530dCaKln/oGM3ENAObCwGVFYelUgo5wMEts5J7U50FckGFgUeAg
        dYRObd60+Cpix0Gag1tz1zzFwI9cSKuOY5oG
X-Google-Smtp-Source: ABdhPJx9ObPidwb7pXFVwoiXuf3rVnqxIOLGFs+jzNEJj11X2ajLCkh/mA1sYWFyHsoXoX7UAuGALQ==
X-Received: by 2002:a17:906:165a:: with SMTP id n26mr4344864ejd.236.1629983356418;
        Thu, 26 Aug 2021 06:09:16 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:16 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 01/17] ip: bridge: add support for mcast_vlan_snooping
Date:   Thu, 26 Aug 2021 16:05:17 +0300
Message-Id: <20210826130533.149111-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for mcast_vlan_snooping option which controls per-vlan
multicast snooping, also update the man page.
Syntax: $ ip link set dev bridge type bridge mcast_vlan_snooping 0/1

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/iplink_bridge.c    | 29 +++++++++++++++++++++++++++++
 man/man8/ip-link.8.in |  8 ++++++++
 2 files changed, 37 insertions(+)

diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index d12fd0558f7d..0f96b77ec3e1 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -43,6 +43,7 @@ static void print_explain(FILE *f)
 		"		  [ vlan_stats_enabled VLAN_STATS_ENABLED ]\n"
 		"		  [ vlan_stats_per_port VLAN_STATS_PER_PORT ]\n"
 		"		  [ mcast_snooping MULTICAST_SNOOPING ]\n"
+		"		  [ mcast_vlan_snooping MULTICAST_VLAN_SNOOPING ]\n"
 		"		  [ mcast_router MULTICAST_ROUTER ]\n"
 		"		  [ mcast_query_use_ifaddr MCAST_QUERY_USE_IFADDR ]\n"
 		"		  [ mcast_querier MULTICAST_QUERIER ]\n"
@@ -83,6 +84,7 @@ void br_dump_bridge_id(const struct ifla_bridge_id *id, char *buf, size_t len)
 static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 			    struct nlmsghdr *n)
 {
+	struct br_boolopt_multi bm = {};
 	__u32 val;
 
 	while (argc > 0) {
@@ -200,6 +202,18 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("invalid mcast_snooping", *argv);
 
 			addattr8(n, 1024, IFLA_BR_MCAST_SNOOPING, mcast_snoop);
+		} else if (matches(*argv, "mcast_vlan_snooping") == 0) {
+			__u32 mcvl_bit = 1 << BR_BOOLOPT_MCAST_VLAN_SNOOPING;
+			__u8 mcast_vlan_snooping;
+
+			NEXT_ARG();
+			if (get_u8(&mcast_vlan_snooping, *argv, 0))
+				invarg("invalid mcast_vlan_snooping", *argv);
+			bm.optmask |= 1 << BR_BOOLOPT_MCAST_VLAN_SNOOPING;
+			if (mcast_vlan_snooping)
+				bm.optval |= mcvl_bit;
+			else
+				bm.optval &= ~mcvl_bit;
 		} else if (matches(*argv, "mcast_query_use_ifaddr") == 0) {
 			__u8 mcast_qui;
 
@@ -379,6 +393,9 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
 		argc--, argv++;
 	}
 
+	if (bm.optmask)
+		addattr_l(n, 1024, IFLA_BR_MULTI_BOOLOPT,
+			  &bm, sizeof(bm));
 	return 0;
 }
 
@@ -559,6 +576,18 @@ static void bridge_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "mcast_snooping %u ",
 			   rta_getattr_u8(tb[IFLA_BR_MCAST_SNOOPING]));
 
+	if (tb[IFLA_BR_MULTI_BOOLOPT]) {
+		__u32 mcvl_bit = 1 << BR_BOOLOPT_MCAST_VLAN_SNOOPING;
+		struct br_boolopt_multi *bm;
+
+		bm = RTA_DATA(tb[IFLA_BR_MULTI_BOOLOPT]);
+		if (bm->optmask & mcvl_bit)
+			print_uint(PRINT_ANY,
+				   "mcast_vlan_snooping",
+				   "mcast_vlan_snooping %u ",
+				    !!(bm->optval & mcvl_bit));
+	}
+
 	if (tb[IFLA_BR_MCAST_ROUTER])
 		print_uint(PRINT_ANY,
 			   "mcast_router",
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 572bed872eed..2c278d53c050 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -1492,6 +1492,8 @@ the following additional arguments are supported:
 ] [
 .BI mcast_snooping " MULTICAST_SNOOPING "
 ] [
+.BI mcast_vlan_snooping " MULTICAST_VLAN_SNOOPING "
+] [
 .BI mcast_router " MULTICAST_ROUTER "
 ] [
 .BI mcast_query_use_ifaddr " MCAST_QUERY_USE_IFADDR "
@@ -1614,6 +1616,12 @@ per-VLAN per-port stats accounting. Can be changed only when there are no port V
 or off
 .RI ( MULTICAST_SNOOPING " == 0). "
 
+.BI mcast_vlan_snooping " MULTICAST_VLAN_SNOOPING "
+- turn multicast VLAN snooping on
+.RI ( MULTICAST_VLAN_SNOOPING " > 0) "
+or off
+.RI ( MULTICAST_VLAN_SNOOPING " == 0). "
+
 .BI mcast_router " MULTICAST_ROUTER "
 - set bridge's multicast router if IGMP snooping is enabled.
 .I MULTICAST_ROUTER
-- 
2.31.1

