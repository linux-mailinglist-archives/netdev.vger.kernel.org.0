Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773C23FA53E
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhH1LJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbhH1LJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:07 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4700FC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:17 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g22so13808231edy.12
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m6Wtwp06wnIGyXDtLEeUAXt85Va4XDGQcRgeFp4+iTo=;
        b=a6jVOcawf5lYUAYxukEO+ZMEf5agxdZ/Z5DPLeoCo8EkqLCogfr4YclWHlf8pwuqS4
         d2AQwIPYglRjF24OAXFdN02io9R7Culkj28xRUqnU8RlLLuKHKxA4YNJ2MsXggYOxKqX
         vYFyqKhc/ghR47EjkO5LQEz5VT31qjFCywudrK8gr6nba5woOQIfci6NbrZm7xg4yYIE
         SyUIgyvD2395hYnoSuKRJNsx/KvwmS0/mjgORlLLOwJOeUx8rbi9G8q1wlkhfJDgo/TG
         nMu/9oSYMo2bbpZ8Cyodrw8x/kN5cztmu7RqcaeTVfGsS0MmU1EZJ4ByV+XyCY4OwED2
         k+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m6Wtwp06wnIGyXDtLEeUAXt85Va4XDGQcRgeFp4+iTo=;
        b=BHtnS56WwJlHHYdVurkvja001o8mL+S4ZtMl3Xh4n+NBo2Mw+N4EruNmL0xRicJCcz
         t998blbX25NDuywySyd+hRCCq+IeRpiWkytKJw+h7BcQf1XTJBCBYFylAK9qWeT1ok1r
         GOtvOqDBwOmO0veBXqpB8wMfTAYIhcWq4E4ayedg/FNfJiEhuJ9AVpbmv/v0tnc9cjwU
         2JAmkxTCCkhqi2FAj1lCAxo49QHvOkMD0DnwhdPgvOLUMQeq1onkAPrIC3Acm2MnHsEc
         trPNEJeqVPpVRD92bQcd9EnRqWAgvWctduGJ1Dxoq6zTjAySra3AIAv4+C6nl2NsaCe4
         FoXA==
X-Gm-Message-State: AOAM531snLjwDBUDYolYUqyL4yago7ZsZzC6rOdZ93GiverLomBvZpOa
        T3zpYAjaMDahKHV1YBFrXvN0dkA0TYF0ULb3
X-Google-Smtp-Source: ABdhPJzlLysyZyk7DUtNkJpDEG5k9e0wPaQnLKN0TO4hKy6YoVzpeBab9hCcGOCt+aAVfDHxumJtGQ==
X-Received: by 2002:a05:6402:3d8:: with SMTP id t24mr13991883edw.214.1630148895519;
        Sat, 28 Aug 2021 04:08:15 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:15 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 01/19] ip: bridge: add support for mcast_vlan_snooping
Date:   Sat, 28 Aug 2021 14:07:47 +0300
Message-Id: <20210828110805.463429-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
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
v2: use strcmp instead of matches for option name matching

 ip/iplink_bridge.c    | 29 +++++++++++++++++++++++++++++
 man/man8/ip-link.8.in |  8 ++++++++
 2 files changed, 37 insertions(+)

diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index d12fd0558f7d..c2e63f6e0fcf 100644
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
+		} else if (strcmp(*argv, "mcast_vlan_snooping") == 0) {
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

