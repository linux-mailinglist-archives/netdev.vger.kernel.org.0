Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4639034F554
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhCaAJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:09:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:14825 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhCaAJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:09:05 -0400
IronPort-SDR: qfsojPmtdWmpbr2xx/rdCgbNsie4AbSX5hDxuGC7AnNkh8DuvX49Lcre/LdJyIxxTRXGDSYEji
 an9tzJnMT56Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277058944"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="277058944"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
IronPort-SDR: ZhY/kRe+zKxh2m6NDhj0c17+FX+32e2RFsIeheopsjY+KN+qyJ5d7Gw1sj80IMA1HFGnd0X31i
 5qJ1yXjm+g7g==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="378682561"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.25.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 17:09:02 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/6] selftests: mptcp: add addr argument for del_addr
Date:   Tue, 30 Mar 2021 17:08:55 -0700
Message-Id: <20210331000856.117636-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
References: <20210331000856.117636-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

For the id 0 address, different MPTCP connections could be using
different IP addresses for id 0.

This patch added an extra argument IP address for del_addr when
using id 0.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 34 +++++++++++++++++--
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 7b4167f3f9a2..115decfdc1ef 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -26,7 +26,7 @@ static void syntax(char *argv[])
 {
 	fprintf(stderr, "%s add|get|set|del|flush|dump|accept [<args>]\n", argv[0]);
 	fprintf(stderr, "\tadd [flags signal|subflow|backup] [id <nr>] [dev <name>] <ip>\n");
-	fprintf(stderr, "\tdel <id>\n");
+	fprintf(stderr, "\tdel <id> [<ip>]\n");
 	fprintf(stderr, "\tget <id>\n");
 	fprintf(stderr, "\tset <ip> [flags backup|nobackup]\n");
 	fprintf(stderr, "\tflush\n");
@@ -301,6 +301,7 @@ int del_addr(int fd, int pm_family, int argc, char *argv[])
 		  1024];
 	struct rtattr *rta, *nest;
 	struct nlmsghdr *nh;
+	u_int16_t family;
 	int nest_start;
 	u_int8_t id;
 	int off = 0;
@@ -310,11 +311,14 @@ int del_addr(int fd, int pm_family, int argc, char *argv[])
 	off = init_genl_req(data, pm_family, MPTCP_PM_CMD_DEL_ADDR,
 			    MPTCP_PM_VER);
 
-	/* the only argument is the address id */
-	if (argc != 3)
+	/* the only argument is the address id (nonzero) */
+	if (argc != 3 && argc != 4)
 		syntax(argv);
 
 	id = atoi(argv[2]);
+	/* zero id with the IP address */
+	if (!id && argc != 4)
+		syntax(argv);
 
 	nest_start = off;
 	nest = (void *)(data + off);
@@ -328,6 +332,30 @@ int del_addr(int fd, int pm_family, int argc, char *argv[])
 	rta->rta_len = RTA_LENGTH(1);
 	memcpy(RTA_DATA(rta), &id, 1);
 	off += NLMSG_ALIGN(rta->rta_len);
+
+	if (!id) {
+		/* addr data */
+		rta = (void *)(data + off);
+		if (inet_pton(AF_INET, argv[3], RTA_DATA(rta))) {
+			family = AF_INET;
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR4;
+			rta->rta_len = RTA_LENGTH(4);
+		} else if (inet_pton(AF_INET6, argv[3], RTA_DATA(rta))) {
+			family = AF_INET6;
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR6;
+			rta->rta_len = RTA_LENGTH(16);
+		} else {
+			error(1, errno, "can't parse ip %s", argv[3]);
+		}
+		off += NLMSG_ALIGN(rta->rta_len);
+
+		/* family */
+		rta = (void *)(data + off);
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_FAMILY;
+		rta->rta_len = RTA_LENGTH(2);
+		memcpy(RTA_DATA(rta), &family, 2);
+		off += NLMSG_ALIGN(rta->rta_len);
+	}
 	nest->rta_len = off - nest_start;
 
 	do_nl_req(fd, nh, off, 0);
-- 
2.31.1

