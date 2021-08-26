Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DD33F8860
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242663AbhHZNKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242505AbhHZNKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:17 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDBBC0613D9
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:30 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id q17so4619976edv.2
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LXoTQjT690UTi85KZOBEPTBy3nlvqPY2wCUxhhXWuoA=;
        b=TH2GLBq9ijzPCJO+Nk7BH2DkXgsoKLBJZoJ0y7/bobujYjrryzJzlTPDfTpaABX+Fq
         5Qg0RTU2bRGFwtI4sdkjDzEwkgcHN6WIvFxgvb1iwVEqX4V8O1rKQ3KDH1/7SjlERXPW
         pcYW6bJD97ht33wtHAnKPACCZflSQVYJq5MGLcySEbFtHKd1Xpf1lXgSir2pW5pCdn3l
         W2ovXC8aEtLWrNhIX5NJP9rRx4nqZfRFMSJEFuQebnIJv/YyjAh3zTwlcbGdqFB1nsZ6
         VURN6T9UAH+CHTlliSyHzSfKmpDGqqZLTAHImQjTyIiOfFFf7P7usvZSaQAQ0ThVnEoB
         d5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LXoTQjT690UTi85KZOBEPTBy3nlvqPY2wCUxhhXWuoA=;
        b=NfwdERNx6sJSVCoYOC8Avhdjc7PDtZK90jia1WX/V1woFOU21nWyvV385of6KtGzov
         VVTUSgsIKgohm2M5n5b7E6WSLA2EeBIgrNqtP1Cix46u1H4Ogz3MtvsXw9EuJdS5LxOu
         8Z1kUxM4EXWzn8QCYgRDm4L89Pfnp+DoxcDCr5GgnnQHTQUchWqL0nnGoBe1YI+lDLyg
         Wxx46YySAV3mIiaLW0js17/Sgi63PKNMX+VphW/Zic4tsIbwG5vT/7z/THSjPcadhRPw
         yKzlTBnxwK6jZ/dnNBYR5uuQbPlnUdLQQNh9TE80QOaikogonX8fvOoUH2MfAgO3M6Nr
         9uhw==
X-Gm-Message-State: AOAM530/ui2Ow1TWdCArLqm/lpxMIi8Vqi8x7fb63G+ARYWs3Y2G4PnW
        roMp/VeF6Aq0LVH+BdD+y4jxBBmzgvkz2DmG
X-Google-Smtp-Source: ABdhPJxEO0U+KfLBpqHFmakXAm2TO8K1qPTBI6baEi82MB4Op27FvczBwIEkxsQrxzz9X5tFdDxSwQ==
X-Received: by 2002:aa7:dd12:: with SMTP id i18mr4146889edv.368.1629983368701;
        Thu, 26 Aug 2021 06:09:28 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:28 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 11/17] bridge: vlan: add global mcast_membership_interval option
Date:   Thu, 26 Aug 2021 16:05:27 +0300
Message-Id: <20210826130533.149111-12-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add control and dump support for the global mcast_membership_interval
option which controls the interval after which the bridge will leave a
group if no reports have been received for it. To be consistent with the
same bridge-wide option the value is reported with USER_HZ granularity and
the same granularity is expected when setting it.
The default is 26000 (260 seconds).
Syntax:
 $ bridge vlan global set dev bridge vid 1 mcast_membership_interval 13000

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/vlan.c     | 15 +++++++++++++++
 man/man8/bridge.8 |  9 ++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index c3234a90b4fa..757c34c6497b 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -44,6 +44,7 @@ static void usage(void)
 		"                                                      [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
 		"                                                      [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
 		"                                                      [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
+		"                                                      [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
 		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
@@ -447,6 +448,14 @@ static int vlan_global_option_set(int argc, char **argv)
 			addattr64(&req.n, 1024,
 				  BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL,
 				  val64);
+		} else if (strcmp(*argv, "mcast_membership_interval") == 0) {
+			NEXT_ARG();
+			if (get_u64(&val64, *argv, 0))
+				invarg("invalid mcast_membership_interval",
+				       *argv);
+			addattr64(&req.n, 1024,
+				  BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL,
+				  val64);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -813,6 +822,12 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			   "mcast_startup_query_count %u ",
 			   rta_getattr_u32(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL]) {
+		vattr = vtb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL];
+		print_lluint(PRINT_ANY, "mcast_membership_interval",
+			     "mcast_membership_interval %llu ",
+			     rta_getattr_u64(vattr));
+	}
 	print_nl();
 	close_json_object();
 }
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 0d973a9db0e0..a026ca16f89a 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -169,7 +169,9 @@ bridge \- show / manipulate bridge addresses and devices
 .B mcast_last_member_interval
 .IR LAST_MEMBER_INTERVAL " ] [ "
 .B mcast_startup_query_count
-.IR STARTUP_QUERY_COUNT " ]"
+.IR STARTUP_QUERY_COUNT " ] [ "
+.B mcast_membership_interval
+.IR MEMBERSHIP_INTERVAL " ]"
 
 .ti -8
 .BR "bridge vlan global" " [ " show " ] [ "
@@ -964,6 +966,11 @@ after a "leave" message is received.
 .BI mcast_startup_query_count " STARTUP_QUERY_COUNT "
 set the number of queries to send during startup phase. Default is 2.
 
+.TP
+.BI mcast_membership_interval " MEMBERSHIP_INTERVAL "
+delay after which the bridge will leave a group,
+if no membership reports for this group are received.
+
 .SS bridge vlan global show - list global vlan options.
 
 This command displays the global VLAN options for each VLAN entry.
-- 
2.31.1

