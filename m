Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BBE4AA4DB
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 01:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378645AbiBEADv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 19:03:51 -0500
Received: from mga17.intel.com ([192.55.52.151]:46963 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378635AbiBEADt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 19:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644019429; x=1675555429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AiNXi+YXK/fgKe9VxlpeIZQQe5v4YvinATJ7nfInLIw=;
  b=StZrIwOLYp9EUwtIyc50Lro+SLbm4AeKPtFuDWPa9EXdc3yhpKGpc/Yg
   RR6c1roE4ijGlr86cjhpTJZXwNBzryyMcVQt0LCisc7ceRmqIKShzto0s
   1nB3SAOql2NGc5fkOkEI7ACPKu7AwcSJOuw/4Fcrkt5tN0DyZXPHXEecA
   eXVEHJYYiqZ4Ve9ufZaSPbC8RotspigJdBNUEfXniRBg7EdMfAN/Z/v1R
   EDbB5V55ofOre0Aepf+9/9jYVu4Udar3u8jSum3mVPf6vOBtYGIHULQxN
   WGRTBiK/XcfGsO5/xIfdS7bh4bjnRqIHpUIfWIXJbDYMQzWJf2/PslXUH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="229115096"
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="229115096"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,344,1635231600"; 
   d="scan'208";a="770097526"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.231.200])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 16:03:45 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/9] selftests: mptcp: add the id argument for set_flags
Date:   Fri,  4 Feb 2022 16:03:35 -0800
Message-Id: <20220205000337.187292-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
References: <20220205000337.187292-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added the id argument for setting the address flags in
pm_nl_ctl.

Usage:

    pm_nl_ctl set id 1 flags backup

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 63 ++++++++++++-------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 2a57462764d0..22a5ec1e128e 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -28,7 +28,7 @@ static void syntax(char *argv[])
 	fprintf(stderr, "\tadd [flags signal|subflow|backup|fullmesh] [id <nr>] [dev <name>] <ip>\n");
 	fprintf(stderr, "\tdel <id> [<ip>]\n");
 	fprintf(stderr, "\tget <id>\n");
-	fprintf(stderr, "\tset <ip> [flags backup|nobackup|fullmesh|nofullmesh] [port <nr>]\n");
+	fprintf(stderr, "\tset [<ip>] [id <nr>] flags [no]backup|[no]fullmesh [port <nr>]\n");
 	fprintf(stderr, "\tflush\n");
 	fprintf(stderr, "\tdump\n");
 	fprintf(stderr, "\tlimits [<rcv addr max> <subflow max>]\n");
@@ -657,8 +657,10 @@ int set_flags(int fd, int pm_family, int argc, char *argv[])
 	u_int32_t flags = 0;
 	u_int16_t family;
 	int nest_start;
+	int use_id = 0;
+	u_int8_t id;
 	int off = 0;
-	int arg;
+	int arg = 2;
 
 	memset(data, 0, sizeof(data));
 	nh = (void *)data;
@@ -674,29 +676,45 @@ int set_flags(int fd, int pm_family, int argc, char *argv[])
 	nest->rta_len = RTA_LENGTH(0);
 	off += NLMSG_ALIGN(nest->rta_len);
 
-	/* addr data */
-	rta = (void *)(data + off);
-	if (inet_pton(AF_INET, argv[2], RTA_DATA(rta))) {
-		family = AF_INET;
-		rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR4;
-		rta->rta_len = RTA_LENGTH(4);
-	} else if (inet_pton(AF_INET6, argv[2], RTA_DATA(rta))) {
-		family = AF_INET6;
-		rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR6;
-		rta->rta_len = RTA_LENGTH(16);
+	if (!strcmp(argv[arg], "id")) {
+		if (++arg >= argc)
+			error(1, 0, " missing id value");
+
+		use_id = 1;
+		id = atoi(argv[arg]);
+		rta = (void *)(data + off);
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_ID;
+		rta->rta_len = RTA_LENGTH(1);
+		memcpy(RTA_DATA(rta), &id, 1);
+		off += NLMSG_ALIGN(rta->rta_len);
 	} else {
-		error(1, errno, "can't parse ip %s", argv[2]);
+		/* addr data */
+		rta = (void *)(data + off);
+		if (inet_pton(AF_INET, argv[arg], RTA_DATA(rta))) {
+			family = AF_INET;
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR4;
+			rta->rta_len = RTA_LENGTH(4);
+		} else if (inet_pton(AF_INET6, argv[arg], RTA_DATA(rta))) {
+			family = AF_INET6;
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR6;
+			rta->rta_len = RTA_LENGTH(16);
+		} else {
+			error(1, errno, "can't parse ip %s", argv[arg]);
+		}
+		off += NLMSG_ALIGN(rta->rta_len);
+
+		/* family */
+		rta = (void *)(data + off);
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_FAMILY;
+		rta->rta_len = RTA_LENGTH(2);
+		memcpy(RTA_DATA(rta), &family, 2);
+		off += NLMSG_ALIGN(rta->rta_len);
 	}
-	off += NLMSG_ALIGN(rta->rta_len);
 
-	/* family */
-	rta = (void *)(data + off);
-	rta->rta_type = MPTCP_PM_ADDR_ATTR_FAMILY;
-	rta->rta_len = RTA_LENGTH(2);
-	memcpy(RTA_DATA(rta), &family, 2);
-	off += NLMSG_ALIGN(rta->rta_len);
+	if (++arg >= argc)
+		error(1, 0, " missing flags keyword");
 
-	for (arg = 3; arg < argc; arg++) {
+	for (; arg < argc; arg++) {
 		if (!strcmp(argv[arg], "flags")) {
 			char *tok, *str;
 
@@ -724,6 +742,9 @@ int set_flags(int fd, int pm_family, int argc, char *argv[])
 		} else if (!strcmp(argv[arg], "port")) {
 			u_int16_t port;
 
+			if (use_id)
+				error(1, 0, " port can't be used with id");
+
 			if (++arg >= argc)
 				error(1, 0, " missing port value");
 
-- 
2.35.1

