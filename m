Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFF73FA547
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234104AbhH1LJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbhH1LJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:17 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA7DC0617AE
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:27 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id dm15so13824252edb.10
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AmYqgX6IPfYoCbluzwDmXfORiaqNshXT81BLb8ZHCLc=;
        b=smrcBiGHSi2AIQeUCDivwsCZeEcAXyx6bLw4H7boBJKx3aVEO4Lnv09SpAycD7XDN0
         vktYgjTZPP48InSxtNyrEzdi39PoO+aq6v7bNP/NCz7lyWoprJMeS8fCADTP0Y9XvAY+
         xYq3q580EXwF4B9Ad+3InJ/pJUiiSNI/iF1z9UyYaHy4PdR1l60Drr8FmYtwNQGEAvn0
         ZQji7WjBEQi+/Rl4AjNplbHi220oO6jneeu4EOJvE/plxu98qzJLGqAdxTpV9oYBhPED
         CX3E0B9/dgRLl4gbOkaWOQxbVhdPzrqgWvUz0Um7lRL/PoUspPp0nyPj7yX9yGXN7HN6
         L6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AmYqgX6IPfYoCbluzwDmXfORiaqNshXT81BLb8ZHCLc=;
        b=bSPqZXZjSYmDMH6bpA/3+BEprfz969Cq9ZHHGxXVaXGn8wqfosO8hyIibXOlVHtRs5
         g+nGlZbowGAeK+B3MHPaUojgbQlQlD4vfDsoNyLpV7pxdcLvr7l9z5mSz32LIdJd7rhB
         NJ1mwygw0Sr8T7GGRcp4NsdXJ85u+zZrPSDMhH+fMKN7dyUyDqmE7GDZ/kbxhmqjAwdk
         k0zU5QCTG4k5kxQ4Wn6hjuk8YF7J8zIC/et6Qpu1MAHIOS7TwmIBy92qELGQcWuPdQRy
         2HZV451MBJryu9LekpRxHalrGR5nI6tNt04xhGjWykJRJ0u2YmjqYF9I5cw/TpPvR/vq
         kw+w==
X-Gm-Message-State: AOAM532b5FYhiHWj+dW4vJtrvnbqdL2hCfloavnH4yZKxCDQ+M6EYahr
        /MeV8WeWbVXC9xL7151Y7e2Uzx25YezZJqw8
X-Google-Smtp-Source: ABdhPJxDY1B9h+AvSTr2i86DCNOQgTsmNhY2ICl8+WY7qk54WydUFnexNjTVsayQNeJ1G8ui6daYLw==
X-Received: by 2002:a50:c043:: with SMTP id u3mr1270185edd.207.1630148905573;
        Sat, 28 Aug 2021 04:08:25 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:25 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 10/19] bridge: vlan: add global mcast_last_member_count option
Date:   Sat, 28 Aug 2021 14:07:56 +0300
Message-Id: <20210828110805.463429-11-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_last_member_count option
which controls the number of queries the bridge will send on the vlan after
a leave is received (default 2).
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_last_member_count 10

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 | 10 +++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index aa6fbef27b06..479574ca38e5 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -42,6 +42,7 @@ static void usage(void)
 		"                      [ mcast_snooping MULTICAST_SNOOPING ]\n"
 		"                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"                      [ mcast_mld_version MLD_VERSION ]\n"
+		"                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -359,6 +360,7 @@ static int vlan_global_option_set(int argc, char **argv)
 	short vid_end = -1;
 	char *d = NULL;
 	short vid = -1;
+	__u32 val32;
 	__u8 val8;
 
 	afspec = addattr_nest(&req.n, sizeof(req),
@@ -420,6 +422,13 @@ static int vlan_global_option_set(int argc, char **argv)
 				invarg("invalid mcast_mld_version", *argv);
 			addattr8(&req.n, 1024,
 				 BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION, val8);
+		} else if (strcmp(*argv, "mcast_last_member_count") == 0) {
+			NEXT_ARG();
+			if (get_u32(&val32, *argv, 0))
+				invarg("invalid mcast_last_member_count", *argv);
+			addattr32(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT,
+				  val32);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -768,6 +777,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_mld_version",
 			   "mcast_mld_version %u ", rta_getattr_u8(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT];
+		print_uint(PRINT_ANY, "mcast_last_member_count",
+			   "mcast_last_member_count %u ",
+			   rta_getattr_u32(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index dcbff9367334..cea755184336 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -163,7 +163,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_igmp_version
 .IR IGMP_VERSION " ] [ "
 .B mcast_mld_version
-.IR MLD_VERSION " ]"
+.IR MLD_VERSION " ] [ "
+.B mcast_last_member_count
+.IR LAST_MEMBER_COUNT " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -943,6 +945,12 @@ set the IGMP version. Default is 2.
 .BI mcast_mld_version " MLD_VERSION "
 set the MLD version. Default is 1.
 
+.TP
+.BI mcast_last_member_count " LAST_MEMBER_COUNT "
+set multicast last member count, ie the number of queries the bridge
+will send before stopping forwarding a multicast group after a "leave"
+message has been received. Default is 2.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

