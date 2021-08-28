Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4E73FA545
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbhH1LJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbhH1LJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806E7C0612E7
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:28 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id d6so13847318edt.7
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X0ZJ4kZ2XhcaybYsFDJ41WM5Pk0FLWYN3uprFlzMnb8=;
        b=rvIpoe2zF+o5k6so5oCkBEgVOj3AyqbUcNSDLtAtMzwkbW9VXLUVsUxJucq9CIko4n
         sF2eP6clfzFI7VOejUHILbX1nrkHoo3EtB29CZttkSuKzeRnsixaozeqmUjx0NDQhGAF
         Neq7XZfgTbySRnZcL/piIWyuYnDt1L//XUEa9W4aP0p8nBOLHi7/LvzWCPEVF1fc9cTg
         sgLMGCvLO5+U59Wg6u9K7RxlaUTJFHnMpmX/bMvBH70HdODQqSn1bAu5SbXQoTak9kyp
         4PMVJRbuM7VFUglL79IuGMFRusVX37JHcqobTCB3awK8JO0ALeoaKZ+YH2Ql5gt1LxiQ
         zhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X0ZJ4kZ2XhcaybYsFDJ41WM5Pk0FLWYN3uprFlzMnb8=;
        b=BLdmDxsmHxOP8wvQaFeFGBxvh5LpfzgXnIzmbF9Xwwud22qT2rHFlYqcPLruww3xYd
         e08IRVa+1E3wdBesCQ0XGc/yjtwT8bCNEKoAwPOXmqoZCt1J53K71V0U80Ig8UzHRKQ2
         WyiIbmdRLqJ9r1tD8PoAwcYSXdi7g3WJwMvvOGl1Xajdm5EGZfgACCVHrkuA9LEtKEZW
         dVvjvHFUdlQ2UzWRHTs1ui8cxaWLOdhPRBgVhPO6TN0TZtZHuY8IkZpqbjIXU6ZEXzpx
         W045CpbodKjp+sWfvzfEScEY/CDl9vz4G68DlA1ZSq37xFysUpSm+DC5YyOxgT7WMakh
         f/8g==
X-Gm-Message-State: AOAM530M+qana/vwcVzMFU5b7EtRny7thtX3dJEUI/bJN5jOwWM7wpOJ
        UHXW+DxhIfyDoR0av9HrAop7rD0NXNa9oXiQ
X-Google-Smtp-Source: ABdhPJxQYtD2A32j7cyqQKfFCSTtrAvY6F9oxm8n7q/73CUwqknPHqoBS9LuqEfUSB4LY0FUxbByaQ==
X-Received: by 2002:aa7:d2cb:: with SMTP id k11mr8455898edr.227.1630148906739;
        Sat, 28 Aug 2021 04:08:26 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:26 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 11/19] bridge: vlan: add global mcast_startup_query_count option
Date:   Sat, 28 Aug 2021 14:07:57 +0300
Message-Id: <20210828110805.463429-12-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
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
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  8 +++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 479574ca38e5..2c6ebedd2d5f 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -43,6 +43,7 @@ static void usage(void)
 		"                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"                      [ mcast_mld_version MLD_VERSION ]\n"
 		"                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
+		"                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -429,6 +430,14 @@ static int vlan_global_option_set(int argc, char **argv)
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
@@ -783,6 +792,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
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

