Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F22A308325
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhA2BTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:19:45 -0500
Received: from mga07.intel.com ([134.134.136.100]:6819 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhA2BTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 20:19:41 -0500
IronPort-SDR: vcAkEXEqSt1ry+VMtxPWjljVNA+ssYAyHrg67HJHIc6RSGGV/IqNxykpVQpR99J9bqMpSJypy3
 rO3KId2XUPiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="244430179"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="244430179"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
IronPort-SDR: 0RclHJQ/E/cOenQJ4IXOyk/N8yCIJ69TIuUfZvpiC8RTypLSnQrsFRPGDrlHMX0rM2iG0MvOg7
 ohiBEZ8dezDQ==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="505538340"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.96.46])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 17:11:23 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 13/16] selftests: mptcp: add port argument for pm_nl_ctl
Date:   Thu, 28 Jan 2021 17:11:12 -0800
Message-Id: <20210129011115.133953-14-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
References: <20210129011115.133953-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch adds a new argument for pm_nl_ctl tool. We can use it like
this:

 # pm_nl_ctl add 10.0.2.1 flags signal port 10100
 # pm_nl_ctl dump
 id 1 flags signal 10.0.2.1 10100

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index abc269e96a07..7b4167f3f9a2 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -177,8 +177,8 @@ int add_addr(int fd, int pm_family, int argc, char *argv[])
 		  1024];
 	struct rtattr *rta, *nest;
 	struct nlmsghdr *nh;
+	u_int32_t flags = 0;
 	u_int16_t family;
-	u_int32_t flags;
 	int nest_start;
 	u_int8_t id;
 	int off = 0;
@@ -224,7 +224,6 @@ int add_addr(int fd, int pm_family, int argc, char *argv[])
 			char *tok, *str;
 
 			/* flags */
-			flags = 0;
 			if (++arg >= argc)
 				error(1, 0, " missing flags value");
 
@@ -272,6 +271,20 @@ int add_addr(int fd, int pm_family, int argc, char *argv[])
 			rta->rta_len = RTA_LENGTH(4);
 			memcpy(RTA_DATA(rta), &ifindex, 4);
 			off += NLMSG_ALIGN(rta->rta_len);
+		} else if (!strcmp(argv[arg], "port")) {
+			u_int16_t port;
+
+			if (++arg >= argc)
+				error(1, 0, " missing port value");
+			if (!(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
+				error(1, 0, " flags must be signal when using port");
+
+			port = atoi(argv[arg]);
+			rta = (void *)(data + off);
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_PORT;
+			rta->rta_len = RTA_LENGTH(2);
+			memcpy(RTA_DATA(rta), &port, 2);
+			off += NLMSG_ALIGN(rta->rta_len);
 		} else
 			error(1, 0, "unknown keyword %s", argv[arg]);
 	}
@@ -324,6 +337,7 @@ int del_addr(int fd, int pm_family, int argc, char *argv[])
 static void print_addr(struct rtattr *attrs, int len)
 {
 	uint16_t family = 0;
+	uint16_t port = 0;
 	char str[1024];
 	uint32_t flags;
 	uint8_t id;
@@ -331,12 +345,16 @@ static void print_addr(struct rtattr *attrs, int len)
 	while (RTA_OK(attrs, len)) {
 		if (attrs->rta_type == MPTCP_PM_ADDR_ATTR_FAMILY)
 			memcpy(&family, RTA_DATA(attrs), 2);
+		if (attrs->rta_type == MPTCP_PM_ADDR_ATTR_PORT)
+			memcpy(&port, RTA_DATA(attrs), 2);
 		if (attrs->rta_type == MPTCP_PM_ADDR_ATTR_ADDR4) {
 			if (family != AF_INET)
 				error(1, errno, "wrong IP (v4) for family %d",
 				      family);
 			inet_ntop(AF_INET, RTA_DATA(attrs), str, sizeof(str));
 			printf("%s", str);
+			if (port)
+				printf(" %d", port);
 		}
 		if (attrs->rta_type == MPTCP_PM_ADDR_ATTR_ADDR6) {
 			if (family != AF_INET6)
@@ -344,6 +362,8 @@ static void print_addr(struct rtattr *attrs, int len)
 				      family);
 			inet_ntop(AF_INET6, RTA_DATA(attrs), str, sizeof(str));
 			printf("%s", str);
+			if (port)
+				printf(" %d", port);
 		}
 		if (attrs->rta_type == MPTCP_PM_ADDR_ATTR_ID) {
 			memcpy(&id, RTA_DATA(attrs), 1);
-- 
2.30.0

