Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093F03F885E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242573AbhHZNKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242466AbhHZNKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:15 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C30C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id t19so6141952ejr.8
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h+MjvZZhi13YxfUdVl5lVW2QMBSGT4N4+4fOZEIOdRc=;
        b=dkDcBpMmO4ufJQAEAnjNt/uLZNk/3GRtfmlIdhq1r2OdhU0IggMIOY+7NK08iLNWD4
         M3SjHwQMBK8oaD1enVqu42BchoT8EyCHBPuC7+00r/pv8CuLqh0YIRhapnNjhQBrnrqo
         vwXuIoZv6wsOwpdXlfWSaiQKDPPnGrYVuRGfeXro2jC7toHrLEWtmPJWmAYc5PNF8QHW
         EOGqU0p+jKofZuWe9DKfQ4A2ECk7uS7lCqTTIiQZm1b+WaoNG2CWgIv611LgiJ7QJjTw
         BoJdGxfbYHNm4TaLRAHzDb8nYnVluTY6bYLxaBzCT5Z9Iy/hAcWhRRS4P73vBiLx7st4
         vuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h+MjvZZhi13YxfUdVl5lVW2QMBSGT4N4+4fOZEIOdRc=;
        b=aBZkALHFwWtmEUZQMOFDM+9wDGo0toZ0HZ8SY7ypC3iolooWM764ChucmoJI3nJtvA
         M3OR4kdqplNKENuJJVgF6pP9g2L74wY5q4wEnxAKi8scFiMGJV9Bi7mqBLfpluqlYaw+
         aP5eiIPIvbJ/4uF7hIDEHfoGYMWSvMar13gdvkIRI8qH6/nVqxjskZUZvzryzRBgsBnI
         d+8ev3b61TOlAUhUizoJpre+fRWNclVt48lN6zto3Li2B9Xk+3Q2dpgPK9gvZ20efoLc
         8ePSKcuAVolhJtBVAQ7mRNHsBcKeVZvxOqgAUXuknQvZOI77WX0oV/vE6t2thbj+JOTI
         SoKA==
X-Gm-Message-State: AOAM532/KbdZPJaJHrl+M+3Js5svadnWYuw9tMp6lkzls6TAmzmdk97g
        XIzwLdL6XorOGP1dRkrpG7WzCyt2RlStALDY
X-Google-Smtp-Source: ABdhPJwOuv7jYUAWrSP5Dwd0UuLqq8arJXlxPmYs8ojWkfbVC1pb6NVPgnhmKF2EDPgznTIiNkItbA==
X-Received: by 2002:a17:907:12d5:: with SMTP id vp21mr4187961ejb.144.1629983365601;
        Thu, 26 Aug 2021 06:09:25 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:25 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 09/17] bridge: vlan: add global mcast_startup_query_count option
Date:   Thu, 26 Aug 2021 16:05:25 +0300
Message-Id: <20210826130533.149111-10-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_startup_query_count
option which controls the number of queries the bridge will send on the
vlan during startup phase (default 2).
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_startup_query_count 5

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  8 +++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index ee9442e3908f..bf8555b87b33 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -42,6 +42,7 @@ static void usage(void)
 		"                                                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"                                                      [ mcast_mld_version MLD_VERSION ]\n"
 		"                                                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
+		"                                                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -428,6 +429,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr32(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT,
 				  val32);
+		} else if (strcmp(*argv, "mcast_startup_query_count") == 0) {
+			NEXT_ARG();
+			if (get_u32(&val32, *argv, 0))
+				invarg("invalid mcast_startup_query_count",
+				       *argv);
+			addattr32(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT,
+				  val32);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -782,6 +791,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			   "mcast_last_member_count %u ",
 			   rta_getattr_u32(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT];
+		print_uint(PRINT_ANY, "mcast_startup_query_count",
+			   "mcast_startup_query_count %u ",
+			   rta_getattr_u32(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index cea755184336..7741382321cb 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -165,7 +165,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_mld_version
 .IR MLD_VERSION " ] [ "
 .B mcast_last_member_count
-.IR LAST_MEMBER_COUNT " ]"
+.IR LAST_MEMBER_COUNT " ] [ "
+.B mcast_startup_query_count
+.IR STARTUP_QUERY_COUNT " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -951,6 +953,10 @@ set multicast last member count, ie the number of queries the bridge
 will send before stopping forwarding a multicast group after a "leave"
 message has been received. Default is 2.
 
+.TP
+.BI mcast_startup_query_count " STARTUP_QUERY_COUNT "
+set the number of queries to send during startup phase. Default is 2.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

