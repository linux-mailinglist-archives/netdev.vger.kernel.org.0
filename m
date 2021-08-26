Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DA43F8861
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbhHZNKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242564AbhHZNKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A59EC0617A8
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bt14so6190595ejb.3
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sjd0EUn1Nz66aOXuJU4ejq3SwyE3zJni8Naxa0nEgqI=;
        b=Pl4NIj+Y0G4g2PJJTvpFUzJ5ETuNvULzaiiqtDS75T9R/t90cEfKkIFpVv75Ev8K0u
         iZBUU8BtnLzvHqWyll54+owJ7/ERBVo/WFdEoCSSnKNGYWuhieM41A1cirsgOcHCsYFy
         mTt5iud3Ssuq/hy8n3h7zXYMS4DreIHXlX6c3XyqOhmxremFdaqZgHh3s/OUw8F/TLUS
         QHvvIudyYN+dAtRBrv4qVhVM5/yjgr6hqq7SIF3p4D2BWlZYDZA8UjOAX2UepzPAXz+3
         fhSbK3i1Bzy1CNUQ++ttwFmUfl4pVUtTMWm9Ms2d9NCYCgxH6Z+lTun6nyJ0Td4SucW2
         /NhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sjd0EUn1Nz66aOXuJU4ejq3SwyE3zJni8Naxa0nEgqI=;
        b=azPiqfwnsd/pIfLyvx3MeMGg6le+pB8XO8mT007+1Idx00YZ3QZ3VNqIlfjQQ+9+qG
         DoPy94vB8IhCmWb1Dn+Jb77+2kjC6GZkgqm/eYWoREMrJ0cQQ/n89exWjrORtkQoIMEq
         dBZmxgj6XhCSSb5mefsHk8ss3cmhULlLGFvBdjZKMR1LD0euasViuWl+WxtDdzp5zZ1T
         EK4OtAybQg5eB2oP6QX7HFNo8kmhnUkIgU4FcB1+ouEGMbvv1O0UU/SsH7YuDIAdgo0P
         i9zKBoRUZ5hqaiCIxfDZHznIfwHcIANR/hCgP6J8Weake289b2lz6WrKQ1IfveF1YbpE
         vnPw==
X-Gm-Message-State: AOAM531dSTSmTBp8ww2yGJVqh8hCB/xP4TDCF+Fab0tj+0HsOl172poI
        oluNuguIXuxDZmOmBUVpivm2lSu0NbYEp1hr
X-Google-Smtp-Source: ABdhPJy6gdJHTZXhfTymSiVSiaEct/H91INF9Os4djFbUeINItCGjN/q220vTr3t3lueFk/AnVE48g==
X-Received: by 2002:a17:906:30d8:: with SMTP id b24mr4162771ejb.358.1629983369637;
        Thu, 26 Aug 2021 06:09:29 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:29 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 12/17] bridge: vlan: add global mcast_querier_interval option
Date:   Thu, 26 Aug 2021 16:05:28 +0300
Message-Id: <20210826130533.149111-13-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_querier_interval
option which controls the interval after which if no other router
queries are seen the bridge will start sending its own queries.
To be consistent with the same bridge-wide option the value is reported
with USER_HZ granularity and the same granularity is expected when
setting it.
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_querier_interval 13000

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 | 12 +++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 757c34c6497b..c7cd069c29a4 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -45,6 +45,7 @@ static void usage(void)
 		"                                                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
 		"                                                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
 		"                                                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
+		"                                                      [ mcast_querier_interval QUERIER_INTERVAL ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -456,6 +457,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr64(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL,
 				  val64);
+		} else if (strcmp(*argv, "mcast_querier_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_querier_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -828,6 +837,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			     "mcast_membership_interval %llu ",
 			     rta_getattr_u64(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL];
+		print_lluint(PRINT_ANY, "mcast_querier_interval",
+			     "mcast_querier_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index a026ca16f89a..f5c72ec83f93 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -171,7 +171,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_startup_query_count
 .IR STARTUP_QUERY_COUNT " ] [ "
 .B mcast_membership_interval
-.IR MEMBERSHIP_INTERVAL " ]"
+.IR MEMBERSHIP_INTERVAL " ] [ "
+.B mcast_querier_interval
+.IR QUERIER_INTERVAL " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -971,6 +973,14 @@ set the number of queries to send during startup phase. Default is 2.
 delay after which the bridge will leave a group,
 if no membership reports for this group are received.
 
+.TP
+.BI mcast_querier_interval " QUERIER_INTERVAL "
+interval between queries sent by other routers. If no queries are seen
+after this delay has passed, the bridge will start to send its own queries
+(as if
+.BI mcast_querier
+was enabled).
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

