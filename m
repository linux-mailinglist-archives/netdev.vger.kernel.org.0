Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBBB3F8864
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242652AbhHZNKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242601AbhHZNKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:23 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D865C06129D
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:35 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id h9so6182233ejs.4
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u5XtiFItYdd7uR4ZlYXGn1qUQ0JotICTN4TUEvviF2s=;
        b=IgF6W6QLXuOwckUyGavEwCxC6zp0505s+Pvt2ABYTuvRpKOKxgujp65Kyfd/6N404Q
         GRiN/JKOeZrO7QN0w1JxiAg8JJbLqRrVyfZPjA/c2xI7AR0M/J1L3AazVdtrNWbSExgt
         4nenEUe92TgWjqdho3cC57SU84dHnWFsA1Eq5X8qZkqdOrYD16WHfI/qFywX02AztpUo
         qb54Rac1ALJZXlopWRu1PMiwzVtL8LCFuV1iKJrAni6pp3AH5QeXHR82GUOkTBdRiRdf
         yFCdxGZZ7DiEw36eQ+KbtMlA04kcufFx6Ulv+tNIdMgocQ61vgKviL3RcbVs1yDb6BRS
         BYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u5XtiFItYdd7uR4ZlYXGn1qUQ0JotICTN4TUEvviF2s=;
        b=X2R4vehJCnLQtZ9a/AImawXJGr+tGRI2luYyfs5mJ+QrIY7Q0yzL/QreiXgsLK3wFC
         X2k7SNFzfc1wJ5L1IfgxAmeSa622wVIOW8GvMwmSYJ9gvphEajSvYP+0YhmKK4h2KIS0
         pRctv3NZlsy3WeQcliK66aa1ATHhosmUAoHU6wnt49t/sUbZPhI5O5h9chXPtagy4pZV
         rKhxIYPUeglqqQxkdzKAlrSFR0toXuNplnqZ6zTBf9tHMMRe6An2BKysJ89iSaa5nmOq
         LHhFiAerRSZ3V769XrprDIH6pidDYyXb0iBCbhpei42hV1dEaSelH6+h7QLf7otH9Zdz
         JRtw==
X-Gm-Message-State: AOAM530GS2IWGjSNauF/kHWK3d7/aivv7TCRa30DhRlFwKhZOLhZVsuS
        vjgDEhjjbL1Tuqsft3NaEEtqhyyAbBx+xpdl
X-Google-Smtp-Source: ABdhPJz+H89VKOXD2+w3cfTX/X1rP5iQ3aHBr+L4Yrro0fugdx9BP8heQjSx0G6Dml6EQ37p/DKd4g==
X-Received: by 2002:a17:906:a04f:: with SMTP id bg15mr4317384ejb.417.1629983373791;
        Thu, 26 Aug 2021 06:09:33 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:33 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 16/17] bridge: vlan: add global mcast_querier option
Date:   Thu, 26 Aug 2021 16:05:32 +0300
Message-Id: <20210826130533.149111-17-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_querier option which
controls if the bridge will act as a multicast querier for that vlan.
Syntax: $ bridge vlan global set dev bridge vid 1 mcast_querier 1

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 12 ++++++++++++
 man/man8/bridge.8 | 10 ++++++++++
 2 files changed, 22 insertions(+)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 6bd9feebba72..acc6a2e4b885 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -39,6 +39,7 @@ static void usage(void)
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV [ mcast_snooping MULTICAST_SNOOPING ]\n"
+		"                                                      [ mcast_querier MULTICAST_QUERIER ]\n"
 		"                                                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"                                                      [ mcast_mld_version MLD_VERSION ]\n"
 		"                                                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
@@ -417,6 +418,12 @@ static int vlan_global_option_set(int argc, char **argv)
 				invarg("invalid mcast_snooping", *argv);
 			addattr8(&req.n, 1024,
 				 BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING, val8);
+		} else if (strcmp(*argv, "mcast_querier") == 0) {
+			NEXT_ARG();
+			if (get_u8(&val8, *argv, 0))
+				invarg("invalid mcast_querier", *argv);
+			addattr8(&req.n, 1024,
+				 BRIDGE_VLANDB_GOPTS_MCAST_QUERIER, val8);
 		} else if (strcmp(*argv, "mcast_igmp_version") == 0) {
 			NEXT_ARG();
 			if (get_u8(&val8, *argv, 0))
@@ -830,6 +837,11 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_snooping", "mcast_snooping %u ",
 			   rta_getattr_u8(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER];
+		print_uint(PRINT_ANY, "mcast_querier", "mcast_querier %u ",
+			   rta_getattr_u8(vattr));
+	}
 	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION]) {
 		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION];
 		print_uint(PRINT_ANY, "mcast_igmp_version",
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index eeceb309d219..76d2fa09d5bc 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -160,6 +160,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR VID " [ "
 .B mcast_snooping
 .IR MULTICAST_SNOOPING " ] [ "
+.B mcast_querier
+.IR MULTICAST_QUERIER " ] [ "
 .B mcast_igmp_version
 .IR IGMP_VERSION " ] [ "
 .B mcast_mld_version
@@ -951,6 +953,14 @@ turn multicast snooping for VLAN entry with VLAN ID on
 or off
 .RI ( MULTICAST_SNOOPING " == 0). Default is on. "
 
+.TP
+.BI mcast_querier " MULTICAST_QUERIER "
+enable
+.RI ( MULTICAST_QUERIER " > 0) "
+or disable
+.RI ( MULTICAST_QUERIER " == 0) "
+IGMP/MLD querier, ie sending of multicast queries by the bridge. Default is disabled.
+
 .TP
 .BI mcast_igmp_version " IGMP_VERSION "
 set the IGMP version. Default is 2.
-- 
2.31.1

