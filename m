Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EC83EF574
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 00:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhHQWIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 18:08:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:12969 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235566AbhHQWIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 18:08:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="301788861"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="301788861"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 15:07:33 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="573058346"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.9.45])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 15:07:33 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@xiaomi.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 4/6] selftests: mptcp: set and print the fullmesh flag
Date:   Tue, 17 Aug 2021 15:07:25 -0700
Message-Id: <20210817220727.192198-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
References: <20210817220727.192198-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@xiaomi.com>

This patch dealt with the MPTCP_PM_ADDR_FLAG_FULLMESH flag in add_addr()
and print_addr(), to set and print out the fullmesh flag.

Signed-off-by: Geliang Tang <geliangtang@xiaomi.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 115decfdc1ef..354784512748 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -25,7 +25,7 @@
 static void syntax(char *argv[])
 {
 	fprintf(stderr, "%s add|get|set|del|flush|dump|accept [<args>]\n", argv[0]);
-	fprintf(stderr, "\tadd [flags signal|subflow|backup] [id <nr>] [dev <name>] <ip>\n");
+	fprintf(stderr, "\tadd [flags signal|subflow|backup|fullmesh] [id <nr>] [dev <name>] <ip>\n");
 	fprintf(stderr, "\tdel <id> [<ip>]\n");
 	fprintf(stderr, "\tget <id>\n");
 	fprintf(stderr, "\tset <ip> [flags backup|nobackup]\n");
@@ -236,11 +236,18 @@ int add_addr(int fd, int pm_family, int argc, char *argv[])
 					flags |= MPTCP_PM_ADDR_FLAG_SIGNAL;
 				else if (!strcmp(tok, "backup"))
 					flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+				else if (!strcmp(tok, "fullmesh"))
+					flags |= MPTCP_PM_ADDR_FLAG_FULLMESH;
 				else
 					error(1, errno,
 					      "unknown flag %s", argv[arg]);
 			}
 
+			if (flags & MPTCP_PM_ADDR_FLAG_SIGNAL &&
+			    flags & MPTCP_PM_ADDR_FLAG_FULLMESH) {
+				error(1, errno, "error flag fullmesh");
+			}
+
 			rta = (void *)(data + off);
 			rta->rta_type = MPTCP_PM_ADDR_ATTR_FLAGS;
 			rta->rta_len = RTA_LENGTH(4);
@@ -422,6 +429,13 @@ static void print_addr(struct rtattr *attrs, int len)
 					printf(",");
 			}
 
+			if (flags & MPTCP_PM_ADDR_FLAG_FULLMESH) {
+				printf("fullmesh");
+				flags &= ~MPTCP_PM_ADDR_FLAG_FULLMESH;
+				if (flags)
+					printf(",");
+			}
+
 			/* bump unknown flags, if any */
 			if (flags)
 				printf("0x%x", flags);
-- 
2.33.0

