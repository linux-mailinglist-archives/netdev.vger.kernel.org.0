Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F6D519588
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 04:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344074AbiEDCmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344007AbiEDCmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:42:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625CE1FA78
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651631950; x=1683167950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6E80Hv12hRGPIBPTXwt26s/R2OTUyBVRk2P4nNTUbjg=;
  b=Jus/j8pZyL03Vvz6RXAlkPUlWRNfmFKC+6o3KHnvKkN5j+jpDyMnxwW9
   tOSJI/MVMrIOyOlcWxHNwwQJzqSHQ88HFw4Qzg2g2gvfiCWj3ndWNTOwX
   MPXs7waiwrJmuKkx5uVLS+HuyTtLxzdf73LDD/P89jJQ4eGJ50IPduodm
   iapCmY3XBVPtRrvQyi2kIRcvX1C6MmQItrQShdh+6LveT+nqlCWTgXvlC
   l0vR/z5Vw7gCU/YLWzEUXpSuaH7eWyu0uRiUMXcunRPLs9Q4uaSLlq/6I
   dByXc1N2bnyjWzIngrRQHUnaEc9rTX6Ad1YanmztVNwMP8nO9CRDk0g/W
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267799841"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267799841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="584493378"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.20.240])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:07 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 05/13] selftests: mptcp: support MPTCP_PM_CMD_ANNOUNCE
Date:   Tue,  3 May 2022 19:38:53 -0700
Message-Id: <20220504023901.277012-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504023901.277012-1-mathew.j.martineau@linux.intel.com>
References: <20220504023901.277012-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

This change updates the "pm_nl_ctl" testing sample with an "ann"
(announce) option to support the newly added netlink interface command
MPTCP_PM_CMD_ANNOUNCE to issue ADD_ADDR advertisements over the
chosen MPTCP connection.

E.g. ./pm_nl_ctl ann 192.168.122.75 token 823274047 id 25 dev enp1s0

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 131 ++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index a75a68ad652e..0ef35c3f6419 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -6,6 +6,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <limits.h>
 
 #include <sys/socket.h>
 #include <sys/types.h>
@@ -26,6 +27,7 @@ static void syntax(char *argv[])
 {
 	fprintf(stderr, "%s add|get|set|del|flush|dump|accept [<args>]\n", argv[0]);
 	fprintf(stderr, "\tadd [flags signal|subflow|backup|fullmesh] [id <nr>] [dev <name>] <ip>\n");
+	fprintf(stderr, "\tann <local-ip> id <local-id> token <token> [port <local-port>] [dev <name>]\n");
 	fprintf(stderr, "\tdel <id> [<ip>]\n");
 	fprintf(stderr, "\tget <id>\n");
 	fprintf(stderr, "\tset [<ip>] [id <nr>] flags [no]backup|[no]fullmesh [port <nr>]\n");
@@ -170,6 +172,133 @@ static int resolve_mptcp_pm_netlink(int fd)
 	return genl_parse_getfamily((void *)data);
 }
 
+int announce_addr(int fd, int pm_family, int argc, char *argv[])
+{
+	char data[NLMSG_ALIGN(sizeof(struct nlmsghdr)) +
+		  NLMSG_ALIGN(sizeof(struct genlmsghdr)) +
+		  1024];
+	u_int32_t flags = MPTCP_PM_ADDR_FLAG_SIGNAL;
+	u_int32_t token = UINT_MAX;
+	struct rtattr *rta, *addr;
+	u_int32_t id = UINT_MAX;
+	struct nlmsghdr *nh;
+	u_int16_t family;
+	int addr_start;
+	int off = 0;
+	int arg;
+
+	memset(data, 0, sizeof(data));
+	nh = (void *)data;
+	off = init_genl_req(data, pm_family, MPTCP_PM_CMD_ANNOUNCE,
+			    MPTCP_PM_VER);
+
+	if (argc < 7)
+		syntax(argv);
+
+	/* local-ip header */
+	addr_start = off;
+	addr = (void *)(data + off);
+	addr->rta_type = NLA_F_NESTED | MPTCP_PM_ATTR_ADDR;
+	addr->rta_len = RTA_LENGTH(0);
+	off += NLMSG_ALIGN(addr->rta_len);
+
+	/* local-ip data */
+	/* record addr type */
+	rta = (void *)(data + off);
+	if (inet_pton(AF_INET, argv[2], RTA_DATA(rta))) {
+		family = AF_INET;
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR4;
+		rta->rta_len = RTA_LENGTH(4);
+	} else if (inet_pton(AF_INET6, argv[2], RTA_DATA(rta))) {
+		family = AF_INET6;
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR6;
+		rta->rta_len = RTA_LENGTH(16);
+	} else
+		error(1, errno, "can't parse ip %s", argv[2]);
+	off += NLMSG_ALIGN(rta->rta_len);
+
+	/* addr family */
+	rta = (void *)(data + off);
+	rta->rta_type = MPTCP_PM_ADDR_ATTR_FAMILY;
+	rta->rta_len = RTA_LENGTH(2);
+	memcpy(RTA_DATA(rta), &family, 2);
+	off += NLMSG_ALIGN(rta->rta_len);
+
+	for (arg = 3; arg < argc; arg++) {
+		if (!strcmp(argv[arg], "id")) {
+			/* local-id */
+			if (++arg >= argc)
+				error(1, 0, " missing id value");
+
+			id = atoi(argv[arg]);
+			rta = (void *)(data + off);
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_ID;
+			rta->rta_len = RTA_LENGTH(1);
+			memcpy(RTA_DATA(rta), &id, 1);
+			off += NLMSG_ALIGN(rta->rta_len);
+		} else if (!strcmp(argv[arg], "dev")) {
+			/* for the if_index */
+			int32_t ifindex;
+
+			if (++arg >= argc)
+				error(1, 0, " missing dev name");
+
+			ifindex = if_nametoindex(argv[arg]);
+			if (!ifindex)
+				error(1, errno, "unknown device %s", argv[arg]);
+
+			rta = (void *)(data + off);
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_IF_IDX;
+			rta->rta_len = RTA_LENGTH(4);
+			memcpy(RTA_DATA(rta), &ifindex, 4);
+			off += NLMSG_ALIGN(rta->rta_len);
+		} else if (!strcmp(argv[arg], "port")) {
+			/* local-port (optional) */
+			u_int16_t port;
+
+			if (++arg >= argc)
+				error(1, 0, " missing port value");
+
+			port = atoi(argv[arg]);
+			rta = (void *)(data + off);
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_PORT;
+			rta->rta_len = RTA_LENGTH(2);
+			memcpy(RTA_DATA(rta), &port, 2);
+			off += NLMSG_ALIGN(rta->rta_len);
+		} else if (!strcmp(argv[arg], "token")) {
+			/* MPTCP connection token */
+			if (++arg >= argc)
+				error(1, 0, " missing token value");
+
+			token = atoi(argv[arg]);
+		} else
+			error(1, 0, "unknown keyword %s", argv[arg]);
+	}
+
+	/* addr flags */
+	rta = (void *)(data + off);
+	rta->rta_type = MPTCP_PM_ADDR_ATTR_FLAGS;
+	rta->rta_len = RTA_LENGTH(4);
+	memcpy(RTA_DATA(rta), &flags, 4);
+	off += NLMSG_ALIGN(rta->rta_len);
+
+	addr->rta_len = off - addr_start;
+
+	if (id == UINT_MAX || token == UINT_MAX)
+		error(1, 0, " missing mandatory inputs");
+
+	/* token */
+	rta = (void *)(data + off);
+	rta->rta_type = MPTCP_PM_ATTR_TOKEN;
+	rta->rta_len = RTA_LENGTH(4);
+	memcpy(RTA_DATA(rta), &token, 4);
+	off += NLMSG_ALIGN(rta->rta_len);
+
+	do_nl_req(fd, nh, off, 0);
+
+	return 0;
+}
+
 int add_addr(int fd, int pm_family, int argc, char *argv[])
 {
 	char data[NLMSG_ALIGN(sizeof(struct nlmsghdr)) +
@@ -786,6 +915,8 @@ int main(int argc, char *argv[])
 
 	if (!strcmp(argv[1], "add"))
 		return add_addr(fd, pm_family, argc, argv);
+	else if (!strcmp(argv[1], "ann"))
+		return announce_addr(fd, pm_family, argc, argv);
 	else if (!strcmp(argv[1], "del"))
 		return del_addr(fd, pm_family, argc, argv);
 	else if (!strcmp(argv[1], "flush"))
-- 
2.36.0

