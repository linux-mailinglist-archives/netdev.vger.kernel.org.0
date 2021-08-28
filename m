Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322923FA54F
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhH1LJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbhH1LJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:25 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B56EC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:35 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id n11so13787768edv.11
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ljWNNrdCEzdiywEueBd0MEyhVSwrG0MAfkPuz2/DW0=;
        b=giMnTdOl287ZWSxXtNkkVDemzxuHtWBIHv0lwUtf/l+FJ6JikKxfv0ULB65oNNkdv5
         aGBLXp3LHcMKNNkwszdBFSyLqFYRa84GaLyAAQTYEOS0lol+WqQnQiWZqzNdODExZxGi
         cqRo25qRFs24Y4oi3CNtR00NhzAJo//OEZq5nfnYWAkagqzj9Cwx6jTM4LIJ9tf6Yr9S
         I0Dn8+Sl9YPk6S/NUJdDqOCvqabi9NV2lGmSAh+uM3x78zcYWlI0ODASfN/Qb//OejXd
         fSXhwLENMAQ2BJovRmaXTi5xSPJnvZifUBdnLoqWSuuQbIei7v0F7nF277x1Or5U716Q
         mheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ljWNNrdCEzdiywEueBd0MEyhVSwrG0MAfkPuz2/DW0=;
        b=KU8ewKt3ctAdA3oJjscGKQcgAiOT/XMgXy0OwR+IBrWILk+2Nqi+cZ8ViEyb5yi8lZ
         QmgVoGcrSEenCiODrUycx6+1AhMBelCvX1xppXm4xpTnpj2xQQYUTwBQTB3HMw5g/1aw
         /C4BgyX8mHoFzjAL+Mp036Eewb8bycyTIXYevf7R6SeiIjqRexkKLUtzt5ug31sibB7r
         SLCVi79t3ER1MB3Fm1PvPin/Hz3OUD3rnBgRowGJ1NFz52NzgYVSY37fZyFzOJfa1GMl
         SVNsFAJrv7czH8wpY/S2gVTPY0k1ulNxnzsRRiLK7qJcmXj+0qpjXgYbpT1YGl7XplWw
         tuFg==
X-Gm-Message-State: AOAM531JzNqr3AU/Reoi/ov3dRndavO8IABOrrhK/T32fQdwyFROP5q/
        Mb1zCiahHyDIk7wS8eiabgipkEb3pBAG8hEB
X-Google-Smtp-Source: ABdhPJxuUr28rtpMPmGh1hdmsiD8MnRjM6kVdP0FGG9m39sX6wLW9dTUrD2zUHeUz0IxEroyXZNY5w==
X-Received: by 2002:a05:6402:214:: with SMTP id t20mr14304031edv.386.1630148913554;
        Sat, 28 Aug 2021 04:08:33 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:33 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 18/19] bridge: vlan: add global mcast_querier option
Date:   Sat, 28 Aug 2021 14:08:04 +0300
Message-Id: <20210828110805.463429-19-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_querier option which
controls if the bridge will act as a multicast querier for that vlan.
Syntax: $ bridge vlan global set dev bridge vid 1 mcast_querier 1

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: adjust help msg alignment to fit in 100 columns

 bridge/vlan.c     | 12 ++++++++++++
 man/man8/bridge.8 | 10 ++++++++++
 2 files changed, 22 insertions(+)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index e8043f8574fd..afb5186d36de 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -40,6 +40,7 @@ static void usage(void)
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
 		"                      [ mcast_snooping MULTICAST_SNOOPING ]\n"
+		"                      [ mcast_querier MULTICAST_QUERIER ]\n"
 		"                      [ mcast_igmp_version IGMP_VERSION ]\n"
 		"                      [ mcast_mld_version MLD_VERSION ]\n"
 		"                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
@@ -418,6 +419,12 @@ static int vlan_global_option_set(int argc, char **argv)
 				invarg("invalid mcast_snooping", *argv);
 			addattr8(&req.n, 1024,
 				 BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING, val8);
+		} else if (strcmp(*argv, "mcast_querier") == 0) {
+			NEXT_ARG();
+			if (get_u8(&val8, *argv, 0))
+				invarg("invalid mcast_querier", *argv);
+			addattr8(&req.n, 1024,
+				 BRIDGE_VLANDB_GOPTS_MCAST_QUERIER, val8);
 		} else if (strcmp(*argv, "mcast_igmp_version") == 0) {
 			NEXT_ARG();
 			if (get_u8(&val8, *argv, 0))
@@ -831,6 +838,11 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_snooping", "mcast_snooping %u ",
 			   rta_getattr_u8(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER];
+		print_uint(PRINT_ANY, "mcast_querier", "mcast_querier %u ",
+			   rta_getattr_u8(vattr));
+	}
 	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION]) {
 		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION];
 		print_uint(PRINT_ANY, "mcast_igmp_version",
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index eeceb309d219..76d2fa09d5bc 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -160,6 +160,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR VID " [ "
 .B mcast_snooping
 .IR MULTICAST_SNOOPING " ] [ "
+.B mcast_querier
+.IR MULTICAST_QUERIER " ] [ "
 .B mcast_igmp_version
 .IR IGMP_VERSION " ] [ "
 .B mcast_mld_version
@@ -951,6 +953,14 @@ turn multicast snooping for VLAN entry with VLAN ID on
 or off
 .RI ( MULTICAST_SNOOPING " == 0). Default is on. "
 
+.TP
+.BI mcast_querier " MULTICAST_QUERIER "
+enable
+.RI ( MULTICAST_QUERIER " > 0) "
+or disable
+.RI ( MULTICAST_QUERIER " == 0) "
+IGMP/MLD querier, ie sending of multicast queries by the bridge. Default is disabled.
+
 .TP
 .BI mcast_igmp_version " IGMP_VERSION "
 set the IGMP version. Default is 2.
-- 
2.31.1

