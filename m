Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530C63F885F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242620AbhHZNKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242491AbhHZNKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:16 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ED8C0613CF
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:29 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bt14so6190422ejb.3
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VHIb4g/rbWh8Qy+OOXTamr/Z4haRg+kioKbGIb/RsaY=;
        b=XtljKKh6p09zS8028ja7SuIaqZAqYqW0peUbhOmyil/n1g3q5E16ujNKSAMaJpdMUr
         bI/q5qKDHaFy2TudKsfuUn719aECPpU6nr7kePPWrioBN6LgLmqxTgUNViwqSlRW6Fne
         PGvyzTdYhAop6pRICeoum2hAgC64PPIKE95OnO0TUNVoujD+yIb4XEMd/sds89yObRv2
         7KAFDjPs0Ot5Slmc13M1hwn16KJabWO2/cZOa4QUBVWL2Tn4408S2RKjNvun84dmtvrR
         v4IEAQfQek5EHg5TQzk5Y2ts3aOvTqg/AvjhjxmlNxT2vydmEOWevFjgeDsIPYsH4bEl
         sxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VHIb4g/rbWh8Qy+OOXTamr/Z4haRg+kioKbGIb/RsaY=;
        b=LYaN9zh9ufLefCUUKP82tUMbKcbDak/p1S9fF/HX4FnqU8XXlD/hDpeuOYUtAb+ZVv
         aq5D5PXa90AW0tuS3Kb560Kg63i7PMSIIdRruOShhn+ZMKel6m5BO6W2GAXU3h4ELA6R
         UtocyuNpY2UynfN8zmh0Mr8u5dd4due5mSYEq2cUY62BQIbVwe3vXKM1krUaer1e5IpG
         IC2zVWbhZsBqh6jLXnljMCuPgAjwcT9OTn/Wz2Ju2wMVK3I78JEQDq/evwAteb6IeoSZ
         Gj3OS6fKORueKfO80cDKQtHSglRbGcvOgVwIGw2gzFmJ0n9oKkCGTKERfo9mOFJblUSX
         nCGA==
X-Gm-Message-State: AOAM5300rVtFIcXwCYyUwAU0WdF+qYyjBxY+vQkP5uRj/Qh1ga/+B8bn
        vjnnYooUa0pjx6WG3vYmWvo62VCGV6pSeCWo
X-Google-Smtp-Source: ABdhPJzdtOP6qvnCrqy86u/lKFiJ1W6b2YgThaVmpObIcG7t75MHyR/ckueEQXOfvtF0BGmDLDm8LQ==
X-Received: by 2002:a17:906:1f82:: with SMTP id t2mr4108433ejr.499.1629983367620;
        Thu, 26 Aug 2021 06:09:27 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:27 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 10/17] bridge: vlan: add global mcast_last_member_interval option
Date:   Thu, 26 Aug 2021 16:05:26 +0300
Message-Id: <20210826130533.149111-11-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_last_member_interval
option which controls the interval between queries to find remaining
members of a group after a leave message. To be consistent with the same
bridge-wide option the value is reported with USER_HZ granularity and
the same granularity is expected when setting it.
The default is 100 (1 second).
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_last_member_interval 200

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 16 ++++++++++++++++
 man/man8/bridge.8 |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index bf8555b87b33..c3234a90b4fa 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -42,6 +42,7 @@ static void usage(void)
 		"                                                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"                                                      [ mcast_mld_version MLD_VERSION ]\n"
 		"                                                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
+		"                                                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
 		"                                                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
@@ -360,6 +361,7 @@ static int vlan_global_option_set(int argc, char **argv)
 	short vid_end = -1;
 	char *d = NULL;
 	short vid = -1;
+	__u64 val64;
 	__u32 val32;
 	__u8 val8;
 
@@ -437,6 +439,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr32(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT,
 				  val32);
+		} else if (strcmp(*argv, "mcast_last_member_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_last_member_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -791,6 +801,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			   "mcast_last_member_count %u ",
 			   rta_getattr_u32(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL];
+		print_lluint(PRINT_ANY, "mcast_last_member_interval",
+			     "mcast_last_member_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT]) {
 		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT];
 		print_uint(PRINT_ANY, "mcast_startup_query_count",
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 7741382321cb..0d973a9db0e0 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -166,6 +166,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR MLD_VERSION " ] [ "
 .B mcast_last_member_count
 .IR LAST_MEMBER_COUNT " ] [ "
+.B mcast_last_member_interval
+.IR LAST_MEMBER_INTERVAL " ] [ "
 .B mcast_startup_query_count
 .IR STARTUP_QUERY_COUNT " ]"
 
@@ -953,6 +955,11 @@ set multicast last member count, ie the number of queries the bridge
 will send before stopping forwarding a multicast group after a "leave"
 message has been received. Default is 2.
 
+.TP
+.BI mcast_last_member_interval " LAST_MEMBER_INTERVAL "
+interval between queries to find remaining members of a group,
+after a "leave" message is received.
+
 .TP
 .BI mcast_startup_query_count " STARTUP_QUERY_COUNT "
 set the number of queries to send during startup phase. Default is 2.
-- 
2.31.1

