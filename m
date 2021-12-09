Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5183F46E535
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhLIJOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:14:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230047AbhLIJOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:14:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639041037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yMhgdjQ8UHQnydBZapgt50RHTeVqcO41f2l/oc9YUvM=;
        b=d7mfdayjmY7LT+OVtf6yfsFTdDPxlEPYKV/J1hjJtoOImiFpQyRPb8ZWEf3/xTjAC/kUJy
        4xxayNbbDNzLRkBPSwBIzmXqcHM1LEUQddNOMiURDJy769rfEFPEHwgV00ku91ACYtwAT1
        1wdo2hEAh5eOFMkIsjdmH/DOGzCioEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-M3UOfBpVMXy79Y-cBhkeAQ-1; Thu, 09 Dec 2021 04:10:36 -0500
X-MC-Unique: M3UOfBpVMXy79Y-cBhkeAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DE25192CC40;
        Thu,  9 Dec 2021 09:10:35 +0000 (UTC)
Received: from dcaratti.station (unknown [10.40.193.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2E2119729;
        Thu,  9 Dec 2021 09:10:33 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrea Claudi <aclaudi@redhat.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH iproute2-next] mptcp: add support for changing the backup flag
Date:   Thu,  9 Dec 2021 10:10:27 +0100
Message-Id: <cb2ddffb2211d6fdde7a8bf81879a3a83c620f00.1639039948.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux supports 'MPTCP_PM_CMD_SET_FLAGS' since v5.12, and this control has
recently been extended to allow setting flags for a given endpoint id.
Although there is no use for changing 'signal' or 'subflow' flags, it can
be helpful to set/clear the backup bit on existing endpoints: add the 'ip
mptcp endpoint change <...>' command for this purpose.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/158
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 ip/ipmptcp.c        | 20 ++++++++++++++++----
 man/man8/ip-mptcp.8 | 14 ++++++++++++++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index 857004446aa3..7fb48a420a6b 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -25,6 +25,7 @@ static void usage(void)
 		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
 		"				      [ port NR ] [ FLAG-LIST ]\n"
 		"	ip mptcp endpoint delete id ID\n"
+		"	ip mptcp endpoint change id ID [ backup | nobackup ]\n"
 		"	ip mptcp endpoint show [ id ID ]\n"
 		"	ip mptcp endpoint flush\n"
 		"	ip mptcp limits set [ subflows NR ] [ add_addr_accepted NR ]\n"
@@ -45,6 +46,8 @@ static int genl_family = -1;
 	GENL_REQUEST(_req, MPTCP_BUFLEN, genl_family, 0,	\
 		     MPTCP_PM_VER, _cmd, _flags)
 
+#define MPTCP_PM_ADDR_FLAG_NOBACKUP 0x0
+
 /* Mapping from argument to address flag mask */
 static const struct {
 	const char *name;
@@ -53,6 +56,7 @@ static const struct {
 	{ "signal",		MPTCP_PM_ADDR_FLAG_SIGNAL },
 	{ "subflow",		MPTCP_PM_ADDR_FLAG_SUBFLOW },
 	{ "backup",		MPTCP_PM_ADDR_FLAG_BACKUP },
+	{ "nobackup",		MPTCP_PM_ADDR_FLAG_NOBACKUP }
 };
 
 static void print_mptcp_addr_flags(unsigned int flags)
@@ -95,9 +99,9 @@ static int get_flags(const char *arg, __u32 *flags)
 	return -1;
 }
 
-static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n,
-			 bool adding)
+static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n, int cmd)
 {
+	bool adding = cmd == MPTCP_PM_CMD_ADD_ADDR;
 	struct rtattr *attr_addr;
 	bool addr_set = false;
 	inet_prefix address;
@@ -110,6 +114,11 @@ static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n,
 	ll_init_map(&rth);
 	while (argc > 0) {
 		if (get_flags(*argv, &flags) == 0) {
+			/* allow changing the 'backup' flag only */
+			if (cmd == MPTCP_PM_CMD_SET_FLAGS &&
+			    (flags & ~MPTCP_PM_ADDR_FLAG_BACKUP))
+				invarg("invalid flags\n", *argv);
+
 		} else if (matches(*argv, "id") == 0) {
 			NEXT_ARG();
 
@@ -182,7 +191,7 @@ static int mptcp_addr_modify(int argc, char **argv, int cmd)
 	MPTCP_REQUEST(req, cmd, NLM_F_REQUEST);
 	int ret;
 
-	ret = mptcp_parse_opt(argc, argv, &req.n, cmd == MPTCP_PM_CMD_ADD_ADDR);
+	ret = mptcp_parse_opt(argc, argv, &req.n, cmd);
 	if (ret)
 		return ret;
 
@@ -298,7 +307,7 @@ static int mptcp_addr_show(int argc, char **argv)
 	if (argc <= 0)
 		return mptcp_addr_dump();
 
-	ret = mptcp_parse_opt(argc, argv, &req.n, false);
+	ret = mptcp_parse_opt(argc, argv, &req.n, MPTCP_PM_CMD_GET_ADDR);
 	if (ret)
 		return ret;
 
@@ -534,6 +543,9 @@ int do_mptcp(int argc, char **argv)
 		if (matches(*argv, "add") == 0)
 			return mptcp_addr_modify(argc-1, argv+1,
 						 MPTCP_PM_CMD_ADD_ADDR);
+		if (matches(*argv, "change") == 0)
+			return mptcp_addr_modify(argc-1, argv+1,
+						 MPTCP_PM_CMD_SET_FLAGS);
 		if (matches(*argv, "delete") == 0)
 			return mptcp_addr_modify(argc-1, argv+1,
 						 MPTCP_PM_CMD_DEL_ADDR);
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index 22335b6129ae..574cb60dc7c0 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -34,6 +34,13 @@ ip-mptcp \- MPTCP path manager configuration
 .BR "ip mptcp endpoint del id "
 .I ID
 
+.ti -8
+.BR "ip mptcp endpoint change id "
+.I ID
+.RB "[ "
+.I BACKUP-OPT
+.RB "] "
+
 .ti -8
 .BR "ip mptcp endpoint show "
 .RB "[ " id
@@ -55,6 +62,13 @@ ip-mptcp \- MPTCP path manager configuration
 .B backup
 .RB  "]"
 
+.ti -8
+.IR BACKUP-OPT " := ["
+.B backup
+.RB "|"
+.B nobackup
+.RB  "]"
+
 .ti -8
 .BR "ip mptcp limits set "
 .RB "[ "
-- 
2.31.1

