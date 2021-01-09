Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973952EFC6F
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhAIAtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:49:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:32272 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbhAIAtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:49:39 -0500
IronPort-SDR: vpkqIU97gFY6cQvVRc6Mfu1w2m6wO+cedRhvCYxL20inRh9aeleqEuUBMyuYy9TIA/xFq/WfBA
 rR63nK4GIUIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="177771957"
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="177771957"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
IronPort-SDR: F1wvbQUhspGRYI7st+9azBcykq/2pPUUjfGqkUvGOfaaj/yrA/F9HmmnzFo1pJY71Bmck4B5zi
 3dUYgM8hEi1w==
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="423124503"
Received: from mjmartin-nuc02.amr.corp.intel.com ([10.251.4.171])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 16:48:09 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/8] selftests: mptcp: add set_flags command in pm_nl_ctl
Date:   Fri,  8 Jan 2021 16:48:00 -0800
Message-Id: <20210109004802.341602-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
References: <20210109004802.341602-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch added the set_flags command in pm_nl_ctl, currently we can only
set two flags: backup and nobackup. The set_flags command can be used like
this:

 # pm_nl_ctl set 10.0.0.1 flags backup
 # pm_nl_ctl set 10.0.0.1 flags nobackup

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 87 ++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index b24a2f17d415..abc269e96a07 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -24,10 +24,11 @@
 
 static void syntax(char *argv[])
 {
-	fprintf(stderr, "%s add|get|del|flush|dump|accept [<args>]\n", argv[0]);
+	fprintf(stderr, "%s add|get|set|del|flush|dump|accept [<args>]\n", argv[0]);
 	fprintf(stderr, "\tadd [flags signal|subflow|backup] [id <nr>] [dev <name>] <ip>\n");
 	fprintf(stderr, "\tdel <id>\n");
 	fprintf(stderr, "\tget <id>\n");
+	fprintf(stderr, "\tset <ip> [flags backup|nobackup]\n");
 	fprintf(stderr, "\tflush\n");
 	fprintf(stderr, "\tdump\n");
 	fprintf(stderr, "\tlimits [<rcv addr max> <subflow max>]\n");
@@ -584,6 +585,88 @@ int get_set_limits(int fd, int pm_family, int argc, char *argv[])
 	return 0;
 }
 
+int set_flags(int fd, int pm_family, int argc, char *argv[])
+{
+	char data[NLMSG_ALIGN(sizeof(struct nlmsghdr)) +
+		  NLMSG_ALIGN(sizeof(struct genlmsghdr)) +
+		  1024];
+	struct rtattr *rta, *nest;
+	struct nlmsghdr *nh;
+	u_int32_t flags = 0;
+	u_int16_t family;
+	int nest_start;
+	int off = 0;
+	int arg;
+
+	memset(data, 0, sizeof(data));
+	nh = (void *)data;
+	off = init_genl_req(data, pm_family, MPTCP_PM_CMD_SET_FLAGS,
+			    MPTCP_PM_VER);
+
+	if (argc < 3)
+		syntax(argv);
+
+	nest_start = off;
+	nest = (void *)(data + off);
+	nest->rta_type = NLA_F_NESTED | MPTCP_PM_ATTR_ADDR;
+	nest->rta_len = RTA_LENGTH(0);
+	off += NLMSG_ALIGN(nest->rta_len);
+
+	/* addr data */
+	rta = (void *)(data + off);
+	if (inet_pton(AF_INET, argv[2], RTA_DATA(rta))) {
+		family = AF_INET;
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR4;
+		rta->rta_len = RTA_LENGTH(4);
+	} else if (inet_pton(AF_INET6, argv[2], RTA_DATA(rta))) {
+		family = AF_INET6;
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR6;
+		rta->rta_len = RTA_LENGTH(16);
+	} else {
+		error(1, errno, "can't parse ip %s", argv[2]);
+	}
+	off += NLMSG_ALIGN(rta->rta_len);
+
+	/* family */
+	rta = (void *)(data + off);
+	rta->rta_type = MPTCP_PM_ADDR_ATTR_FAMILY;
+	rta->rta_len = RTA_LENGTH(2);
+	memcpy(RTA_DATA(rta), &family, 2);
+	off += NLMSG_ALIGN(rta->rta_len);
+
+	for (arg = 3; arg < argc; arg++) {
+		if (!strcmp(argv[arg], "flags")) {
+			char *tok, *str;
+
+			/* flags */
+			if (++arg >= argc)
+				error(1, 0, " missing flags value");
+
+			/* do not support flag list yet */
+			for (str = argv[arg]; (tok = strtok(str, ","));
+			     str = NULL) {
+				if (!strcmp(tok, "backup"))
+					flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+				else if (strcmp(tok, "nobackup"))
+					error(1, errno,
+					      "unknown flag %s", argv[arg]);
+			}
+
+			rta = (void *)(data + off);
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_FLAGS;
+			rta->rta_len = RTA_LENGTH(4);
+			memcpy(RTA_DATA(rta), &flags, 4);
+			off += NLMSG_ALIGN(rta->rta_len);
+		} else {
+			error(1, 0, "unknown keyword %s", argv[arg]);
+		}
+	}
+	nest->rta_len = off - nest_start;
+
+	do_nl_req(fd, nh, off, 0);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int fd, pm_family;
@@ -609,6 +692,8 @@ int main(int argc, char *argv[])
 		return dump_addrs(fd, pm_family, argc, argv);
 	else if (!strcmp(argv[1], "limits"))
 		return get_set_limits(fd, pm_family, argc, argv);
+	else if (!strcmp(argv[1], "set"))
+		return set_flags(fd, pm_family, argc, argv);
 
 	fprintf(stderr, "unknown sub-command: %s", argv[1]);
 	syntax(argv);
-- 
2.30.0

