Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38793FA54B
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhH1LJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbhH1LJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:21 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73323C061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id q3so13829537edt.5
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DF+exTBtMRtFeXw/oti+cwAQwyYfRw66qv3NA0eX2E4=;
        b=oRf01UpXij7KOEMroAYx8+udFFj3IJ6hACZAClgD23GkCKaDW0BzSBuF3Qpsz+0rWt
         SAaE5tjB1fwOiqjUBE3VvkuWR3Ff/OiaEbhxvOmAgVVqVfp1UzqMocOcQprL54dhETez
         9Lso/1bTP/e2OgnePyln7Sl2zPQSc38PbRB7Dvg0lCI+Anr4MCI/EFjH0DAR2H+g7D7Z
         Nh8zTIj9nqX3A+equFmeAU8KXE+jESpwOlyoJROR2eEa0wyFGJiTN0McIs17YxSyOQoD
         xu324YCPdvWeuWKtY50UMlSQUPXdz5hyHN6y/uzqvtxkZPc2iOviXeP+KBGxwmi3O76x
         xXaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DF+exTBtMRtFeXw/oti+cwAQwyYfRw66qv3NA0eX2E4=;
        b=DqoRMqkPLi3Vhwk5x9TzNexBlUSTGqk3Avv0uDkOyXyDpibfcS6vH+3VLdaDwHHcxU
         OsknizQvqFoWBd+z6z0mHhPHDYezcbZ4BOq5UCG0sgduZiheE5clwXgJHLqESP2Eyvr6
         hrapPk9m8PkaANy8gkwGwEBc1fkozD9mRfL1GZmErk91lIdqR/BxCcAx3Cb6elP6y0So
         ivVGjQZxuEpzJfAe6WLclWLu0Etn4auuBS9gvnaStw5Z54+c0jHngGoQQPrI+Wk3Zxvj
         1u78joFCWgfhzJpcO6qs9HcoK6hEKJfuAasiDoeNXUmSfqeRo+5NulZi9jChRckBzFWG
         T8hA==
X-Gm-Message-State: AOAM530Dv8kbDMU8TVr16JKJiviN/UnAcv4jyhUe+mQEax72w5V9cOvA
        zSaJxQi3bpavA/tX5RHynksCjaSrsftw6Zo3
X-Google-Smtp-Source: ABdhPJx5P/z3Yx6q6qdjSJMfUElEUN87kJwD7CKlwXEz8g1Tm0M9w5t17vpC0S6Wzl/R93WtLu4hEw==
X-Received: by 2002:aa7:c790:: with SMTP id n16mr14467066eds.223.1630148909765;
        Sat, 28 Aug 2021 04:08:29 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:29 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 14/19] bridge: vlan: add global mcast_querier_interval option
Date:   Sat, 28 Aug 2021 14:08:00 +0300
Message-Id: <20210828110805.463429-15-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
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
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 | 12 +++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index acdbb4a1b562..5494dd15c76e 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -46,6 +46,7 @@ static void usage(void)
 		"                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
 		"                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
 		"                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
+		"                      [ mcast_querier_interval QUERIER_INTERVAL ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -457,6 +458,14 @@ static int vlan_global_option_set(int argc, char **argv)
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
@@ -829,6 +838,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
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

