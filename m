Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561E03FA546
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhH1LJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbhH1LJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:16 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509CFC0617AD
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:26 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z10so13827312edb.6
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y7EMagU7OglvRT33eUoDOX6tHTvsQYqQZDQ2olHJMiE=;
        b=Xf1bZ5JCF2HWo4Rt1CpPUQU6S9wbblLeb6a5wvhCCdg3lDchHjOS2KYeJV44YmmL+i
         GrIcSFo3SSJQ/Ul75brPz+goAJ0R1MwpSVRBPjoQui3IuFr2d4YLt5c0ia5LcyFyRkST
         nYtB1p5lb6jA0BWvC2zB4HVm28bIRPYm7tjKG+c1zu2lUA5tr5DjkDmmj6Ag7xYqmYq5
         KClOMBWNfxEYUiLBsQdWjFwQz1bMKi03xIvyjJKIlQn4TsuCyRE3dKROEoc6RexPDeKa
         r38DAtIUyUZAHfN5vdEKxy2pvyx75zDf5fdo7/98gsBpqPls+tI/vZh0XKlY3+x18dJM
         FUXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y7EMagU7OglvRT33eUoDOX6tHTvsQYqQZDQ2olHJMiE=;
        b=hxrXH7gizXWgCMtd5Fh3C61yja/+5gieuOwNYCtW7MZFw4WKg2FllBIXWiQEhVHqAh
         A1niTbZ7S8kdFRHJlheC2Wpokbr9qJrP4Ji24ahn74quxoEA7wluBc+bDV+gGky3wyHf
         vhJyzknHtHtgvxKkJm9ATNCcM6FEvW5kmXhli7AdXXW3djoUg4W4dqXXOdP6wGLqwO4e
         aaHt4eB1U/vv5GUXgD3Gqmndu3yqxMhG35iMgT8lbKhD38ejdKET7jae5KKXNB5Y2e/x
         y/UMwlrskGk2Naup0Oncupjn7ReY8tWBgYQxR3AfgqIQxOAozKhyYadfLgBNbZaghwHh
         KrLQ==
X-Gm-Message-State: AOAM531JEJw24qsp9og5xtvRcOJTbM8p26FkNXA20i7uJqMFtN9htZIv
        ezyNkC4bCZfIMGpbBNpXFGSff80+s3V2tPty
X-Google-Smtp-Source: ABdhPJyqDuzzpIRnWxCjZg/X21PO8Nf7qj3CgHohEaxHYUi53mDBJl84vj+G6FdeCBIVmKNIoDyt8A==
X-Received: by 2002:aa7:c4c3:: with SMTP id p3mr14388471edr.122.1630148904414;
        Sat, 28 Aug 2021 04:08:24 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:23 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 09/19] bridge: vlan: add global mcast_mld_version option
Date:   Sat, 28 Aug 2021 14:07:55 +0300
Message-Id: <20210828110805.463429-10-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_mld_version option
which controls the MLD version on the vlan (default 1).
Syntax: $ bridge vlan global set dev bridge vid 1 mcast_mld_version 2

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 12 ++++++++++++
 man/man8/bridge.8 |  8 +++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 5b97f4a167bd..aa6fbef27b06 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -41,6 +41,7 @@ static void usage(void)
 		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
 		"                      [ mcast_snooping MULTICAST_SNOOPING ]\n"
 		"                      [ mcast_igmp_version IGMP_VERSION ]\n"
+		"                      [ mcast_mld_version MLD_VERSION ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -413,6 +414,12 @@ static int vlan_global_option_set(int argc, char **argv)
 				invarg("invalid mcast_igmp_version", *argv);
 			addattr8(&req.n, 1024,
 				 BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION, val8);
+		} else if (strcmp(*argv, "mcast_mld_version") == 0) {
+			NEXT_ARG();
+			if (get_u8(&val8, *argv, 0))
+				invarg("invalid mcast_mld_version", *argv);
+			addattr8(&req.n, 1024,
+				 BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION, val8);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -756,6 +763,11 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_igmp_version",
 			   "mcast_igmp_version %u ", rta_getattr_u8(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION];
+		print_uint(PRINT_ANY, "mcast_mld_version",
+			   "mcast_mld_version %u ", rta_getattr_u8(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 224647b49843..dcbff9367334 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -161,7 +161,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_snooping
 .IR MULTICAST_SNOOPING " ] [ "
 .B mcast_igmp_version
-.IR IGMP_VERSION " ]"
+.IR IGMP_VERSION " ] [ "
+.B mcast_mld_version
+.IR MLD_VERSION " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -937,6 +939,10 @@ or off
 .BI mcast_igmp_version " IGMP_VERSION "
 set the IGMP version. Default is 2.
 
+.TP
+.BI mcast_mld_version " MLD_VERSION "
+set the MLD version. Default is 1.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

