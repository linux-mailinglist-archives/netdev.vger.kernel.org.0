Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113623FA542
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhH1LJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbhH1LJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:12 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB38FC0613D9
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:21 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b7so13861651edu.3
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uvcpjl3RMdixDibCiplQ5MzSh09Qn5UHrWTxz2yOydw=;
        b=ArHx3d0DVnuPcO6SxxiDIkZ9rv8sNpC6l1aaT3IBZFE31LtSKQR4VC6yLBQzAeOEpA
         mUu+puZG12lkrmMsrBVrAx5zOK7a8rOHSYAzJiKJONgmFn+aYiYwEWf9NZGq/aJQIA6+
         9sbWstGrcvthgbvxRKReku+6TWj6hDVJZ5ZLmoK5DFoScGcN1gD760kDaZYmdc56rxKF
         LxOpftykcI7MHJmNdPMzs5YlbOL0Ztxzl3CJQx+0whOHrKf5kcsDbGPUYb9R8Y1bdf+H
         smx+/WbBrImRnS1SW9ihmTdtm0IY/oT0D5Q9Y4HH4vr08dFLfrpbFex8v5tuEc42t5FU
         pKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uvcpjl3RMdixDibCiplQ5MzSh09Qn5UHrWTxz2yOydw=;
        b=YMv7S1BzZVyb+bzuBahZfLMo2CEYV9qNM9gfXcIVdCS1YcBFTD4WBo6hvgbqUUBgBA
         ssvZ2UQqqnRfL2i1/5LJqD6fnS/kQ9CxJ25StodJOulffHVrWMQrwbcxSG+lHZ1RSayE
         fJQcVaEjeV/AfV4TMMRRCHIgQ4Bgcfv06fsoE/v+KWU3RljCIyXTmNs2JQUIxqQPERni
         ix2HFTL/VwduuGbYhCLFxdClwFLokUov9kG2doVM6B3YxY7ryOAwQYSHjZqAii8mEV0g
         5Q+z/1oizh5HqhfzbUOGL8MIcXxtAimjFiE7MOh+mIZxA4SNHuKxNcpHjhLSddBMbGpd
         HK2A==
X-Gm-Message-State: AOAM531+Kl7zqZ99yE++mnAtLRN1n1tMFzwsyIFrmcc3lsD4ZZkFS7xD
        /sRi6rZ2EB1ZzBU6SucVV5AMpVG46a1SHsMa
X-Google-Smtp-Source: ABdhPJwZQOZpv8wjW0wqzbrjeYjyESSqLLNbVdu2RwdFQgiyH67HB9v/czYzdlVT5T5YIs+uCwCrIw==
X-Received: by 2002:a50:c905:: with SMTP id o5mr14655908edh.250.1630148900252;
        Sat, 28 Aug 2021 04:08:20 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:19 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 05/19] bridge: vlan: add support for vlan filtering when dumping options
Date:   Sat, 28 Aug 2021 14:07:51 +0300
Message-Id: <20210828110805.463429-6-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
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
 bridge/vlan.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 424fe8371733..69a1d3c295b6 100644
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
@@ -746,23 +772,14 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor, bool global_only
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
-		close_json_object();
 	}
 
 	return 0;
-- 
2.31.1

