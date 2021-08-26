Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FE53F8865
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242661AbhHZNKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242595AbhHZNKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:23 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525B9C061292
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id ia27so6132421ejc.10
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ClaN8lopGILywhWB4yU24sYj1z57kxETA0aK5OrHPjg=;
        b=TRbiwVG4zwmwJEBhgE3wYwAeNHMe7dsnBr2AMlF2y1eC24diV1tbwoEv9P8Q7qv1tZ
         wHclSAYX05D6+JZFPS1AeAmMzyFTE3Ycz0InKp9NTko4DQnwzz2gQCqOG+lnRSLbIXAs
         DD5bzV34mj+KWxBwChS25nP4cyYEV+PXb/xULu6BRVPGDe0FLbQ66euMOQ9Yg9mJqE0e
         B8a6L+bcOSfVZtuDEonmbw5/C+JDOjn2dDTAQd8eChrCiSAQCzW/dn0Qe5HDYxS+M1+B
         ONtOQCUYbNhxNr5njPIin69Cdp/TNtpvBB8gIhVPox3woqpNIzSD6ZWswaJaZ6l+fw2g
         t4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ClaN8lopGILywhWB4yU24sYj1z57kxETA0aK5OrHPjg=;
        b=jDDZ8R9o2dxD/gcPVESKlPYqEaVFXsd2eQOrvj1A2oTPILG+9+yzb4bd7cZ15qisNU
         dZYdSjhKW9IXjMHnIZSYDUdeUsCUw6VAHetKVN2e9EtVWqMq9f889svdVRNNkpTJBOBx
         bLpNN6TeJ1uk/ZpwO/qcpQP8m8jyV/1dRrxE2+EYIZw9qVBSR4LbHNDi3GFXklWjgvpy
         9aShp6ldI55/i5u9b18FDBVlAXiqFpgOyjLigmvST3eOovJvI9R4lXQQD8NwYQvLItD1
         GmlNOE8eYDG5XXt61SN1M9NLja9DFfkM6AkczTxShKadQuDNqYxvP+teadugnyDtRKE0
         Og5A==
X-Gm-Message-State: AOAM531suY96tntkocFKzEap1U0PAmXEmH+XA+eBWQtyvyPFbKQD0yGp
        RYcxvZHNDimhaRT45ZIM+7ITeaNVMMHsfiai
X-Google-Smtp-Source: ABdhPJwwWBVMVJETKl5QvnJNuM8Rw+Gap92Oa3VNgSHxZxBJ7cS/aHZDVBXvWyyvmARxjU8C5fm0bg==
X-Received: by 2002:a17:906:a0c:: with SMTP id w12mr4144124ejf.376.1629983372642;
        Thu, 26 Aug 2021 06:09:32 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:32 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 15/17] bridge: vlan: add global mcast_startup_query_interval option
Date:   Thu, 26 Aug 2021 16:05:31 +0300
Message-Id: <20210826130533.149111-16-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_startup_query_interval
option which controls the interval between queries in the startup phase.
To be consistent with the same bridge-wide option the value is reported
with USER_HZ granularity and the same granularity is expected when setting
it.
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_startup_query_interval 15000

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 0f6d8849843f..6bd9feebba72 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -44,6 +44,7 @@ static void usage(void)
 		"                                                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
 		"                                                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
 		"                                                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
+		"                                                      [ mcast_startup_query_interval STARTUP_QUERY_INTERVAL ]\n"
 		"                                                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
 		"                                                      [ mcast_querier_interval QUERIER_INTERVAL ]\n"
 		"                                                      [ mcast_query_interval QUERY_INTERVAL ]\n"
@@ -483,6 +484,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr64(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL,
 				  val64);
+		} else if (strcmp(*argv, "mcast_startup_query_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_startup_query_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -849,6 +858,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			   "mcast_startup_query_count %u ",
 			   rta_getattr_u32(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL];
+		print_lluint(PRINT_ANY, "mcast_startup_query_interval",
+			     "mcast_startup_query_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL]) {
 		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL];
 		print_lluint(PRINT_ANY, "mcast_membership_interval",
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index e9cd5f9f4fe6..eeceb309d219 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -170,6 +170,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR LAST_MEMBER_INTERVAL " ] [ "
 .B mcast_startup_query_count
 .IR STARTUP_QUERY_COUNT " ] [ "
+.B mcast_startup_query_interval
+.IR STARTUP_QUERY_INTERVAL " ] [ "
 .B mcast_membership_interval
 .IR MEMBERSHIP_INTERVAL " ] [ "
 .B mcast_querier_interval
@@ -972,6 +974,10 @@ after a "leave" message is received.
 .BI mcast_startup_query_count " STARTUP_QUERY_COUNT "
 set the number of queries to send during startup phase. Default is 2.
 
+.TP
+.BI mcast_startup_query_interval " STARTUP_QUERY_INTERVAL "
+interval between queries in the startup phase.
+
 .TP
 .BI mcast_membership_interval " MEMBERSHIP_INTERVAL "
 delay after which the bridge will leave a group,
-- 
2.31.1

