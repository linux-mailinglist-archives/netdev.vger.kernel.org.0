Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6183F8859
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242521AbhHZNKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241955AbhHZNKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:07 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C90C0613C1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:20 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a25so6150816ejv.6
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uKAJ9crE5Cz6adBLh36gclXQrRqELaOGODfy6aDMxGU=;
        b=VFpUDp7wrwdLEMh8U6eJayk5nHUjRnTh+hF9yMJEVe1LFMO0w+H3cYm4Z/wMD1MAqY
         BA6sVWUjp/b2r8rr3bi/u5WDo7oFfX2Inm+Ospptk1E7DSPhMD7c+JhR2cOyus/hRd/I
         wRCHa41NIguQkKJgxEwhsPz/fPlC6zA3rR6cvq0gtu1jfxBsc+rrkVI03vtnc6tu+Exo
         UBoygsiEXEmCuUoVGc4ID2V7nrxSi2xmIZfeMiybyYER3yvnAmskdUdrjc/H7H3HzM4M
         OXhcGnSrEtkuaYLGL2LATWKsB4xgwtayO1RQVt7X0ByCg+kdpBGwXnp8vPZWoQmUWuKq
         n6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uKAJ9crE5Cz6adBLh36gclXQrRqELaOGODfy6aDMxGU=;
        b=uRrfDX+Pn2NFwZuwe4byenER79hxQb+5XuE4NwNy6WuQqWLUp9vme5idFxpKp1DSiQ
         wvmVBvYxvq0cJ5jEPKS95Dux8LPH82aPF3zwoO6CksQ4f1qywlKjYQ0rooHsGdJk9QFL
         tell2jKFw472Uu8GKpMpagwT1cBkjXR41fmD4Vckldu3VEt680Ye7NLVODxa4QMlb7BN
         cpT0gLU8u5/zPUM0+Q/vrPIwzkwRHRn4A7kIIZsdmRGA0MgevZccrkI4JMCKLZ0xPz1G
         dFB2XQZHhorJMToP5HiH4lqF9ZsImkeeQNaR+ltKo+lCre6dvKcCDnmKCDT67pavw6Mz
         QYFw==
X-Gm-Message-State: AOAM531NUyKMOX4yqM5oUG3TjBY1YloR94j5BfgG1JU0uy3y99NGyGu+
        4BOIE7JTTIVXwfeSd0M8a+LvxgqM35WLfbiZ
X-Google-Smtp-Source: ABdhPJzfJv79VBS4W/jjFil3SVtyOVf9cIRqr3rBcTZ0m3N8vOcaX44YjjPnaQRLwGyt79P3uoctBQ==
X-Received: by 2002:a17:906:1fd4:: with SMTP id e20mr4269634ejt.421.1629983358602;
        Thu, 26 Aug 2021 06:09:18 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:18 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 03/17] bridge: vlan: add support for vlan filtering when dumping options
Date:   Thu, 26 Aug 2021 16:05:19 +0300
Message-Id: <20210826130533.149111-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

In order to allow vlan filtering when dumping options we need to move
all print operations into the option dumping functions and add the
filtering after we've parsed the nested attributes so we can extract the
start and end vlan ids.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c | 45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 9e33995f8f33..69a1d3c295b6 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -622,7 +622,7 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
-static void print_vlan_global_opts(struct rtattr *a)
+static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 {
 	struct rtattr *vtb[BRIDGE_VLANDB_GOPTS_MAX + 1];
 	__u16 vid, vrange = 0;
@@ -637,11 +637,24 @@ static void print_vlan_global_opts(struct rtattr *a)
 		vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_GOPTS_RANGE]);
 	else
 		vrange = vid;
+
+	if (filter_vlan && (filter_vlan < vid || filter_vlan > vrange))
+		return;
+
+	if (vlan_rtm_cur_ifidx != ifindex) {
+		open_vlan_port(ifindex, VLAN_SHOW_VLAN);
+		open_json_object(NULL);
+		vlan_rtm_cur_ifidx = ifindex;
+	} else {
+		open_json_object(NULL);
+		print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
+	}
 	print_range("vlan", vid, vrange);
 	print_nl();
+	close_json_object();
 }
 
-static void print_vlan_opts(struct rtattr *a)
+static void print_vlan_opts(struct rtattr *a, int ifindex)
 {
 	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1];
 	struct bridge_vlan_xstats vstats;
@@ -662,6 +675,9 @@ static void print_vlan_opts(struct rtattr *a)
 	else
 		vrange = vinfo->vid;
 
+	if (filter_vlan && (filter_vlan < vinfo->vid || filter_vlan > vrange))
+		return;
+
 	if (vtb[BRIDGE_VLANDB_ENTRY_STATE])
 		state = rta_getattr_u8(vtb[BRIDGE_VLANDB_ENTRY_STATE]);
 
@@ -690,6 +706,15 @@ static void print_vlan_opts(struct rtattr *a)
 			vstats.tx_bytes = rta_getattr_u64(attr);
 		}
 	}
+
+	if (vlan_rtm_cur_ifidx != ifindex) {
+		open_vlan_port(ifindex, VLAN_SHOW_VLAN);
+		open_json_object(NULL);
+		vlan_rtm_cur_ifidx = ifindex;
+	} else {
+		open_json_object(NULL);
+		print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
+	}
 	print_range("vlan", vinfo->vid, vrange);
 	print_vlan_flags(vinfo->flags);
 	print_nl();
@@ -698,6 +723,7 @@ static void print_vlan_opts(struct rtattr *a)
 	print_nl();
 	if (show_stats)
 		__print_one_vlan_stats(&vstats);
+	close_json_object();
 }
 
 int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor, bool global_only)
@@ -746,25 +772,14 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor, bool global_only
 		    (global_only && rta_type != BRIDGE_VLANDB_GLOBAL_OPTIONS))
 			continue;
 
-		if (vlan_rtm_cur_ifidx != bvm->ifindex) {
-			open_vlan_port(bvm->ifindex, VLAN_SHOW_VLAN);
-			open_json_object(NULL);
-			vlan_rtm_cur_ifidx = bvm->ifindex;
-		} else {
-			open_json_object(NULL);
-			print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
-		}
-
 		switch (rta_type) {
 		case BRIDGE_VLANDB_ENTRY:
-			print_vlan_opts(a);
+			print_vlan_opts(a, bvm->ifindex);
 			break;
 		case BRIDGE_VLANDB_GLOBAL_OPTIONS:
-			print_vlan_global_opts(a);
+			print_vlan_global_opts(a, bvm->ifindex);
 			break;
 		}
-
-		close_json_object();
 	}
 
 	return 0;
-- 
2.31.1

