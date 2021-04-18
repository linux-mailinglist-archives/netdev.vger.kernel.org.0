Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AE33634F9
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbhDRMDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhDRMDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 08:03:37 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E9EC061760
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:08 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o21-20020a1c4d150000b029012e52898006so6921447wmh.0
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 05:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EpHY1MbAXhUL60YiE+86B1HjUYTVmOkAbHwqH2hSAgQ=;
        b=P+mDJEhy8rVpLdF6TRuTvH+n5zRyT9uhAAip+UN2ZVPcxFhwwK66DA5NRGd1fWz2h1
         ahJtmC5XRkIPmbI9+Qa109XKDN9QHxXSMmpw3xU3z/VTvSirngLL3rzAjClNK0NaoCdC
         HXuXJWpIKanq2kPcGLjRvoETycaYxbfRSFORqXIlwSpcsA/QBYI1CG8eAgkH7OwAD0x2
         jfUp2vd9sfbJgEBxYL7GKX3m7ZKwJiVBSsfQxDAFZiTnZH5i56dzeCq7G/waLXA0+vRp
         3peeNy0O3uJy+Qbb6nQPmN2dAQepN/jCxKrqVOIhIlg1WsPo4Dzmz59nFkWzMoJTZXjo
         zKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EpHY1MbAXhUL60YiE+86B1HjUYTVmOkAbHwqH2hSAgQ=;
        b=mARNM63B4Z/eYmGYsWUCaXdCpe5pz0Aw8WJEI/Wxi4vkFhMUYeEednXYYyRts72LNf
         ABVn8ziWqO/J2ohlI0zMDfHLJn+A5HAYGRGInOorcJVW79aePKUWIrw0gga9xMXrcKqw
         6lzzCzqHzJq2VQsRQdxh+/MrOFzP1pL+ZgZR/EEwtZyY7SQZ4EinW0ndo8FAhCYAxdXg
         S/5SPI/EeKRSMMa/6BY8Xw/xTGttXI+pKEw6uuRCGplac3SNxTqnItHDcT6fuuB7dwL4
         2XtiXuA39M+NrPYb21nmsTl/bZRnqd+YkA6jXcynE2fFI6V0UnCsiFrf0qjx2M9JsW8z
         oD6w==
X-Gm-Message-State: AOAM532M15wpVmdMO+VfHX7KCfZ6Y3netTbVIXXo6w14PPGW91vZOh/k
        Z75RQrCLnBCnvXFRuoQMAZOtBtHMvo8UbR9B
X-Google-Smtp-Source: ABdhPJxmh4IHvz+rq6ZvviumLM5rB+lLgH1WvASRbyX93T1uFxto1s0vv9S/foMOavEAl5dbe52tyw==
X-Received: by 2002:a1c:c918:: with SMTP id f24mr17158729wmb.12.1618747387111;
        Sun, 18 Apr 2021 05:03:07 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x25sm16584763wmj.34.2021.04.18.05.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 05:03:06 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 6/6] bridge: monitor: add support for vlan monitoring
Date:   Sun, 18 Apr 2021 15:01:37 +0300
Message-Id: <20210418120137.2605522-7-razor@blackwall.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418120137.2605522-1-razor@blackwall.org>
References: <20210418120137.2605522-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for vlan activity monitoring, we display vlan notifications on
vlan add/del/options change. The man page and help are also updated
accordingly.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/br_common.h |  2 +-
 bridge/mdb.c       |  2 +-
 bridge/monitor.c   | 19 ++++++++++++++++++-
 bridge/vlan.c      | 15 +++++++++++++--
 man/man8/bridge.8  |  4 ++--
 5 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index 43870546ff28..b9adafd98dea 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -12,7 +12,7 @@ int print_mdb_mon(struct nlmsghdr *n, void *arg);
 int print_fdb(struct nlmsghdr *n, void *arg);
 void print_stp_state(__u8 state);
 int parse_stp_state(const char *arg);
-int print_vlan_rtm(struct nlmsghdr *n, void *arg);
+int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor);
 
 int do_fdb(int argc, char **argv);
 int do_mdb(int argc, char **argv);
diff --git a/bridge/mdb.c b/bridge/mdb.c
index ef89258bc5c3..b427d878677f 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -16,9 +16,9 @@
 #include <arpa/inet.h>
 
 #include "libnetlink.h"
+#include "utils.h"
 #include "br_common.h"
 #include "rt_names.h"
-#include "utils.h"
 #include "json_print.h"
 
 #ifndef MDBA_RTA
diff --git a/bridge/monitor.c b/bridge/monitor.c
index 08439a60288a..88f52f52f084 100644
--- a/bridge/monitor.c
+++ b/bridge/monitor.c
@@ -31,7 +31,7 @@ static int prefix_banner;
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: bridge monitor [file | link | fdb | mdb | all]\n");
+	fprintf(stderr, "Usage: bridge monitor [file | link | fdb | mdb | vlan | all]\n");
 	exit(-1);
 }
 
@@ -67,6 +67,12 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 		print_nlmsg_timestamp(fp, n);
 		return 0;
 
+	case RTM_NEWVLAN:
+	case RTM_DELVLAN:
+		if (prefix_banner)
+			fprintf(fp, "[VLAN]");
+		return print_vlan_rtm(n, arg, true);
+
 	default:
 		return 0;
 	}
@@ -79,6 +85,7 @@ int do_monitor(int argc, char **argv)
 	int llink = 0;
 	int lneigh = 0;
 	int lmdb = 0;
+	int lvlan = 0;
 
 	rtnl_close(&rth);
 
@@ -95,8 +102,12 @@ int do_monitor(int argc, char **argv)
 		} else if (matches(*argv, "mdb") == 0) {
 			lmdb = 1;
 			groups = 0;
+		} else if (matches(*argv, "vlan") == 0) {
+			lvlan = 1;
+			groups = 0;
 		} else if (strcmp(*argv, "all") == 0) {
 			groups = ~RTMGRP_TC;
+			lvlan = 1;
 			prefix_banner = 1;
 		} else if (matches(*argv, "help") == 0) {
 			usage();
@@ -134,6 +145,12 @@ int do_monitor(int argc, char **argv)
 
 	if (rtnl_open(&rth, groups) < 0)
 		exit(1);
+
+	if (lvlan && rtnl_add_nl_group(&rth, RTNLGRP_BRVLAN) < 0) {
+		fprintf(stderr, "Failed to add bridge vlan group to list\n");
+		exit(1);
+	}
+
 	ll_init_map(&rth);
 
 	if (rtnl_listen(&rth, accept_msg, stdout) < 0)
diff --git a/bridge/vlan.c b/bridge/vlan.c
index c681e14189b8..9bb9e28d11bb 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -621,7 +621,7 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
-int print_vlan_rtm(struct nlmsghdr *n, void *arg)
+int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 {
 	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1], *a;
 	struct br_vlan_msg *bvm = NLMSG_DATA(n);
@@ -648,6 +648,12 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg)
 	if (filter_index && filter_index != bvm->ifindex)
 		return 0;
 
+	if (n->nlmsg_type == RTM_DELVLAN)
+		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
+
+	if (monitor)
+		vlan_rtm_cur_ifidx = -1;
+
 	if (vlan_rtm_cur_ifidx == -1 || vlan_rtm_cur_ifidx != bvm->ifindex) {
 		if (vlan_rtm_cur_ifidx != -1)
 			close_vlan_port();
@@ -720,6 +726,11 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
+static int print_vlan_rtm_filter(struct nlmsghdr *n, void *arg)
+{
+	return print_vlan_rtm(n, arg, false);
+}
+
 static int vlan_show(int argc, char **argv, int subject)
 {
 	char *filter_dev = NULL;
@@ -764,7 +775,7 @@ static int vlan_show(int argc, char **argv, int subject)
 			printf("\n");
 		}
 
-		ret = rtnl_dump_filter(&rth, print_vlan_rtm, &subject);
+		ret = rtnl_dump_filter(&rth, print_vlan_rtm_filter, &subject);
 		if (ret < 0) {
 			fprintf(stderr, "Dump terminated\n");
 			exit(1);
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 9c8ebac3c6aa..eec7df4383bc 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -153,7 +153,7 @@ bridge \- show / manipulate bridge addresses and devices
 .IR DEV " ]"
 
 .ti -8
-.BR "bridge monitor" " [ " all " | " neigh " | " link " | " mdb " ]"
+.BR "bridge monitor" " [ " all " | " neigh " | " link " | " mdb " | " vlan " ]"
 
 .SH OPTIONS
 
@@ -911,7 +911,7 @@ command is the first in the command line and then the object list follows:
 .I OBJECT-LIST
 is the list of object types that we want to monitor.
 It may contain
-.BR link ", " fdb ", and " mdb "."
+.BR link ", " fdb ", " vlan " and " mdb "."
 If no
 .B file
 argument is given,
-- 
2.30.2

