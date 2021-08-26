Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944943F885C
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242629AbhHZNKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242365AbhHZNKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:13 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C60C0617AE
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g22so4547722edy.12
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hye+h2craTGXO3/8i1mqA88tF8d6QqW/HA7G4Bin9aw=;
        b=ruN/zXezT/vglxL3bmoOxtPokVPM3/dqhJ5fz2Lbc4ZAQHev8XLFS7W4OmEhQ1bm5F
         BwVj90FJJWif+ydi20dyCI7DJL7JQtTq9wRge6vRLvWp3wb/eGey3LaqNCwDY5MWu6wK
         IPaWcX/dy7Bx6FDscs2tsyaVt6h7Sz/DaTDYMeJSX9OH/sXTUqNZJ2nSVubsI7DFT4eJ
         NCPwdI4SCJAXewlJhLUtRyZfRAVDzbxQye/xhIv03+uTSyxPg9QnS1GoCnJP1k6WH6fP
         Bn/GvE2WM884+fctD8+aA7aJFGOhUBaJi6FvEDTUnAgv/MlRU+qWkOHCmdgwB8LLfiBt
         E39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hye+h2craTGXO3/8i1mqA88tF8d6QqW/HA7G4Bin9aw=;
        b=QFthBPtvQxIahzr0DesHEV0tY44EHrfxBbG55DfLlYsTBT3yovkNkvwBT4bueCiZCV
         MaVQtTelKew3cf+etO3vjF2cL1gmUW57DUpxWOzdhSNINXFfbv87WX93JTJmmjJ9RG5t
         QDO8NtRIlnkAzk89ck58Oipz9Sj9xUFPaMb+/KZwbtuncLyjv4RBaPHHVv7twnY0fYLj
         GUVFdsSJbJD7DQLBANwW8MsMw9xCIADRRyofj7fc9SkZimMdUfRCT+jgz2JwWrPn8Dx/
         yiS/dhkiCV90WYQCgBCivbq2JVjjo3xo9BpdS7f7xOKxUa4S8rAOkgKrRi2l8ds7sgq6
         p/Yg==
X-Gm-Message-State: AOAM531fnhz6h8A0QcVYfMTrk8yuJIz7v90XlFcPTxXqCtKVOAk/zf/N
        KOPXfyrKRU/cPbZk6jmVo+9NVYGNFHMy/Wlb
X-Google-Smtp-Source: ABdhPJyvr0Vg7eb9kNg+SgK5MWj55LTa/OunEmVScpYpFCwaqQoxqvFwuHkok8uSwYBs48rfLylqqg==
X-Received: by 2002:a05:6402:714:: with SMTP id w20mr368976edx.62.1629983363575;
        Thu, 26 Aug 2021 06:09:23 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:23 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 07/17] bridge: vlan: add global mcast_mld_version option
Date:   Thu, 26 Aug 2021 16:05:23 +0300
Message-Id: <20210826130533.149111-8-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
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
 bridge/vlan.c     | 12 ++++++++++++
 man/man8/bridge.8 |  8 +++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 346026b6f955..00b4f8a00d9b 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -40,6 +40,7 @@ static void usage(void)
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV [ mcast_snooping MULTICAST_SNOOPING ]\n"
 		"                                                      [ mcast_igmp_version IGMP_VERSION ]\n"
+		"                                                      [ mcast_mld_version MLD_VERSION ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -412,6 +413,12 @@ static int vlan_global_option_set(int argc, char **argv)
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
@@ -755,6 +762,11 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
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

