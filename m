Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6D73F8862
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242619AbhHZNKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242565AbhHZNKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9E7C0617AE
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:32 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ia27so6132247ejc.10
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EFcZZdhQYrOSc7ekJCimNuGSWWEbvofzt4SglFR8sLg=;
        b=ZHt+gLaczvD3GXB/FGAYHFzDdtbRtDIExHJXu0+DiydojAhPn1w0jMAoCgAxovg6Mb
         TlcTXbDs44V7bV5h9FuuU7t79H1dzmFY3KitNu3xYPDaU5YinYBUEdf7njHxBrSlD98Z
         gwPgRgGjB0LGtxQfEUi38ktPKctSIgLUnHg9NI7/lEX9YizzOhsAk8tsaI58NqF8hOL5
         xGjR0UgcFNOUIUNeKcWi/eQC/DHovLZk7JAcq7k1AS5cjYABvPJEDy3aYRPJnFUEV+ER
         JBb3QrM8RxeltjjJna4lBRpNwoQgKnBR5R7b/E7+kbOmMxmi+etpBla4P+cCQqBPAoZO
         919g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EFcZZdhQYrOSc7ekJCimNuGSWWEbvofzt4SglFR8sLg=;
        b=i5KTMOES6lC4nKzBoXeWuHzvl9jzenYs3OYf3VHi7IT++6PGju5dJkBzToNPF2GJNW
         XnzyfV3pDkZ0lD1XQh0Qn2BskNaPDgBFzGmHyYT0SiINNTusRZbNkl4b9tzWaY8xlxAm
         bhCbSaWiq8rIrnSgnfqCzq64+oYV4uOqpcDNrQ/1w8Yc6uIKwEboqPl1QYO34Huk8q6X
         pEPpFFTu3N+8x3Do2bw10+g/W5y3mUY5ZglZFnyhz9da5Xv99ftF4uEGSg7uod9s5+/N
         OlvlObuDjVB0tsKhee6rKBqQyxvcPEhWyUkG7MDQ6OGLKxtqhNjBV9QoCNmYZVS+l9Ut
         PtPw==
X-Gm-Message-State: AOAM53174DuCdOnJpV8UEvB7+hNhZEGM/aOjyfAuqXU2F1zZb8C7Ei8l
        AL40tvJaBCfveYDniOGqznZzxvMUaVF77KLq
X-Google-Smtp-Source: ABdhPJy9kfCbY8UcFpVdk8Sm5OFCBN8O8srKSkfGcb1dAojsUmGFCbMP+J/nlQf8ol0D6xmgQVlX6w==
X-Received: by 2002:a17:906:8258:: with SMTP id f24mr4208100ejx.375.1629983370665;
        Thu, 26 Aug 2021 06:09:30 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:30 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 13/17] bridge: vlan: add global mcast_query_interval option
Date:   Thu, 26 Aug 2021 16:05:29 +0300
Message-Id: <20210826130533.149111-14-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_query_interval
option which controls the interval between queries sent by the bridge
after the end of the startup phase. To be consistent with the same
bridge-wide option the value is reported with USER_HZ granularity and
the same granularity is expected when setting it.
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_query_interval 13000

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  9 ++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index c7cd069c29a4..206cbdea10cb 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -46,6 +46,7 @@ static void usage(void)
 		"                                                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
 		"                                                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
 		"                                                      [ mcast_querier_interval QUERIER_INTERVAL ]\n"
+		"                                                      [ mcast_query_interval QUERY_INTERVAL ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -465,6 +466,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr64(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL,
 				  val64);
+		} else if (strcmp(*argv, "mcast_query_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_query_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -843,6 +852,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			     "mcast_querier_interval %llu ",
 			     rta_getattr_u64(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL];
+		print_lluint(PRINT_ANY, "mcast_query_interval",
+			     "mcast_query_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index f5c72ec83f93..cb1170f8d5c9 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -173,7 +173,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_membership_interval
 .IR MEMBERSHIP_INTERVAL " ] [ "
 .B mcast_querier_interval
-.IR QUERIER_INTERVAL " ]"
+.IR QUERIER_INTERVAL " ] [ "
+.B mcast_query_interval
+.IR QUERY_INTERVAL " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -981,6 +983,11 @@ after this delay has passed, the bridge will start to send its own queries
 .BI mcast_querier
 was enabled).
 
+.TP
+.BI mcast_query_interval " QUERY_INTERVAL "
+interval between queries sent by the bridge after the end of the
+startup phase.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

