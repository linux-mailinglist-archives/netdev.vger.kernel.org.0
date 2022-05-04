Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD9851958D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 04:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344121AbiEDCnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344055AbiEDCmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 22:42:47 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A29E192A9
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651631953; x=1683167953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WJx6/mM/n8l2odAclTKk/cB9A+sCzYiB91++g7gQTLE=;
  b=TjZa3oNj/14z7rQZndzkbFziu7zt26pnjP6s7dx6iQRahpjYHuXcfkN2
   vD0T8wHvyxcB53+hT1p69QePYWlCFBpyAmpxsJ5aLycWKzcmGX8cmyIOr
   /UcwUpHHVQ+Gw0KnIz2yJWGaB03TpQDaffyux23IVE5DYdk5xSQdg12jc
   DvyvLHwKjWMZzLY/3VpTGhpVosFe8UgbqYg77r1AECIKsMCN6vgE2qKRW
   hC/OyxOfTqbZbt//QaV4E+VQ773eVYLveopSjHVnvzZurlkPEsF3OY076
   SWN8FIIu2gwQCwZZbSTlUoYas5lr4OirZqBjpoUyYj5Z0bCfRGH21sXMo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267799854"
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="267799854"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,196,1647327600"; 
   d="scan'208";a="584493401"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.20.240])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 19:39:08 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 11/13] selftests: mptcp: capture netlink events
Date:   Tue,  3 May 2022 19:38:59 -0700
Message-Id: <20220504023901.277012-12-mathew.j.martineau@linux.intel.com>
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

This change adds to self-testing support for the MPTCP netlink interface
by capturing various MPTCP netlink events (and all their metadata)
associated with connections, subflows and address announcements.
It is used in self-testing scripts that exercise MPTCP netlink commands
to precisely validate those operations by examining the dispatched
MPTCP netlink events in response to those commands.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 164 +++++++++++++++++-
 1 file changed, 157 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 8d74fcb04929..f881d8548153 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -22,6 +22,9 @@
 #ifndef MPTCP_PM_NAME
 #define MPTCP_PM_NAME		"mptcp_pm"
 #endif
+#ifndef MPTCP_PM_EVENTS
+#define MPTCP_PM_EVENTS		"mptcp_pm_events"
+#endif
 
 static void syntax(char *argv[])
 {
@@ -37,6 +40,7 @@ static void syntax(char *argv[])
 	fprintf(stderr, "\tflush\n");
 	fprintf(stderr, "\tdump\n");
 	fprintf(stderr, "\tlimits [<rcv addr max> <subflow max>]\n");
+	fprintf(stderr, "\tevents\n");
 	exit(0);
 }
 
@@ -88,6 +92,108 @@ static void nl_error(struct nlmsghdr *nh)
 	}
 }
 
+static int capture_events(int fd, int event_group)
+{
+	u_int8_t buffer[NLMSG_ALIGN(sizeof(struct nlmsghdr)) +
+			NLMSG_ALIGN(sizeof(struct genlmsghdr)) + 1024];
+	struct genlmsghdr *ghdr;
+	struct rtattr *attrs;
+	struct nlmsghdr *nh;
+	int ret = 0;
+	int res_len;
+	int msg_len;
+	fd_set rfds;
+
+	if (setsockopt(fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP,
+		       &event_group, sizeof(event_group)) < 0)
+		error(1, errno, "could not join the " MPTCP_PM_EVENTS " mcast group");
+
+	do {
+		FD_ZERO(&rfds);
+		FD_SET(fd, &rfds);
+		res_len = NLMSG_ALIGN(sizeof(struct nlmsghdr)) +
+		  NLMSG_ALIGN(sizeof(struct genlmsghdr)) + 1024;
+
+		ret = select(FD_SETSIZE, &rfds, NULL, NULL, NULL);
+
+		if (ret < 0)
+			error(1, ret, "error in select() on NL socket");
+
+		res_len = recv(fd, buffer, res_len, 0);
+		if (res_len < 0)
+			error(1, res_len, "error on recv() from NL socket");
+
+		nh = (struct nlmsghdr *)buffer;
+
+		for (; NLMSG_OK(nh, res_len); nh = NLMSG_NEXT(nh, res_len)) {
+			if (nh->nlmsg_type == NLMSG_ERROR)
+				error(1, NLMSG_ERROR, "received invalid NL message");
+
+			ghdr = (struct genlmsghdr *)NLMSG_DATA(nh);
+
+			if (ghdr->cmd == 0)
+				continue;
+
+			fprintf(stderr, "type:%d", ghdr->cmd);
+
+			msg_len = nh->nlmsg_len - NLMSG_LENGTH(GENL_HDRLEN);
+
+			attrs = (struct rtattr *) ((char *) ghdr + GENL_HDRLEN);
+			while (RTA_OK(attrs, msg_len)) {
+				if (attrs->rta_type == MPTCP_ATTR_TOKEN)
+					fprintf(stderr, ",token:%u", *(__u32 *)RTA_DATA(attrs));
+				else if (attrs->rta_type == MPTCP_ATTR_FAMILY)
+					fprintf(stderr, ",family:%u", *(__u16 *)RTA_DATA(attrs));
+				else if (attrs->rta_type == MPTCP_ATTR_LOC_ID)
+					fprintf(stderr, ",loc_id:%u", *(__u8 *)RTA_DATA(attrs));
+				else if (attrs->rta_type == MPTCP_ATTR_REM_ID)
+					fprintf(stderr, ",rem_id:%u", *(__u8 *)RTA_DATA(attrs));
+				else if (attrs->rta_type == MPTCP_ATTR_SADDR4) {
+					u_int32_t saddr4 = ntohl(*(__u32 *)RTA_DATA(attrs));
+
+					fprintf(stderr, ",saddr4:%u.%u.%u.%u", saddr4 >> 24,
+					       (saddr4 >> 16) & 0xFF, (saddr4 >> 8) & 0xFF,
+					       (saddr4 & 0xFF));
+				} else if (attrs->rta_type == MPTCP_ATTR_SADDR6) {
+					char buf[INET6_ADDRSTRLEN];
+
+					if (inet_ntop(AF_INET6, RTA_DATA(attrs), buf,
+						      sizeof(buf)) != NULL)
+						fprintf(stderr, ",saddr6:%s", buf);
+				} else if (attrs->rta_type == MPTCP_ATTR_DADDR4) {
+					u_int32_t daddr4 = ntohl(*(__u32 *)RTA_DATA(attrs));
+
+					fprintf(stderr, ",daddr4:%u.%u.%u.%u", daddr4 >> 24,
+					       (daddr4 >> 16) & 0xFF, (daddr4 >> 8) & 0xFF,
+					       (daddr4 & 0xFF));
+				} else if (attrs->rta_type == MPTCP_ATTR_DADDR6) {
+					char buf[INET6_ADDRSTRLEN];
+
+					if (inet_ntop(AF_INET6, RTA_DATA(attrs), buf,
+						      sizeof(buf)) != NULL)
+						fprintf(stderr, ",daddr6:%s", buf);
+				} else if (attrs->rta_type == MPTCP_ATTR_SPORT)
+					fprintf(stderr, ",sport:%u",
+						ntohs(*(__u16 *)RTA_DATA(attrs)));
+				else if (attrs->rta_type == MPTCP_ATTR_DPORT)
+					fprintf(stderr, ",dport:%u",
+						ntohs(*(__u16 *)RTA_DATA(attrs)));
+				else if (attrs->rta_type == MPTCP_ATTR_BACKUP)
+					fprintf(stderr, ",backup:%u", *(__u8 *)RTA_DATA(attrs));
+				else if (attrs->rta_type == MPTCP_ATTR_ERROR)
+					fprintf(stderr, ",error:%u", *(__u8 *)RTA_DATA(attrs));
+				else if (attrs->rta_type == MPTCP_ATTR_SERVER_SIDE)
+					fprintf(stderr, ",server_side:%u", *(__u8 *)RTA_DATA(attrs));
+
+				attrs = RTA_NEXT(attrs, msg_len);
+			}
+		}
+		fprintf(stderr, "\n");
+	} while (1);
+
+	return 0;
+}
+
 /* do a netlink command and, if max > 0, fetch the reply  */
 static int do_nl_req(int fd, struct nlmsghdr *nh, int len, int max)
 {
@@ -121,11 +227,18 @@ static int do_nl_req(int fd, struct nlmsghdr *nh, int len, int max)
 	return ret;
 }
 
-static int genl_parse_getfamily(struct nlmsghdr *nlh)
+static int genl_parse_getfamily(struct nlmsghdr *nlh, int *pm_family,
+				int *events_mcast_grp)
 {
 	struct genlmsghdr *ghdr = NLMSG_DATA(nlh);
 	int len = nlh->nlmsg_len;
 	struct rtattr *attrs;
+	struct rtattr *grps;
+	struct rtattr *grp;
+	int got_events_grp;
+	int got_family;
+	int grps_len;
+	int grp_len;
 
 	if (nlh->nlmsg_type != GENL_ID_CTRL)
 		error(1, errno, "Not a controller message, len=%d type=0x%x\n",
@@ -140,9 +253,42 @@ static int genl_parse_getfamily(struct nlmsghdr *nlh)
 		error(1, errno, "Unknown controller command %d\n", ghdr->cmd);
 
 	attrs = (struct rtattr *) ((char *) ghdr + GENL_HDRLEN);
+	got_family = 0;
+	got_events_grp = 0;
+
 	while (RTA_OK(attrs, len)) {
-		if (attrs->rta_type == CTRL_ATTR_FAMILY_ID)
-			return *(__u16 *)RTA_DATA(attrs);
+		if (attrs->rta_type == CTRL_ATTR_FAMILY_ID) {
+			*pm_family = *(__u16 *)RTA_DATA(attrs);
+			got_family = 1;
+		} else if (attrs->rta_type == CTRL_ATTR_MCAST_GROUPS) {
+			grps = RTA_DATA(attrs);
+			grps_len = RTA_PAYLOAD(attrs);
+
+			while (RTA_OK(grps, grps_len)) {
+				grp = RTA_DATA(grps);
+				grp_len = RTA_PAYLOAD(grps);
+				got_events_grp = 0;
+
+				while (RTA_OK(grp, grp_len)) {
+					if (grp->rta_type == CTRL_ATTR_MCAST_GRP_ID)
+						*events_mcast_grp = *(__u32 *)RTA_DATA(grp);
+					else if (grp->rta_type == CTRL_ATTR_MCAST_GRP_NAME &&
+						 !strcmp(RTA_DATA(grp), MPTCP_PM_EVENTS))
+						got_events_grp = 1;
+
+					grp = RTA_NEXT(grp, grp_len);
+				}
+
+				if (got_events_grp)
+					break;
+
+				grps = RTA_NEXT(grps, grps_len);
+			}
+		}
+
+		if (got_family && got_events_grp)
+			return 0;
+
 		attrs = RTA_NEXT(attrs, len);
 	}
 
@@ -150,7 +296,7 @@ static int genl_parse_getfamily(struct nlmsghdr *nlh)
 	return -1;
 }
 
-static int resolve_mptcp_pm_netlink(int fd)
+static int resolve_mptcp_pm_netlink(int fd, int *pm_family, int *events_mcast_grp)
 {
 	char data[NLMSG_ALIGN(sizeof(struct nlmsghdr)) +
 		  NLMSG_ALIGN(sizeof(struct genlmsghdr)) +
@@ -172,7 +318,7 @@ static int resolve_mptcp_pm_netlink(int fd)
 	off += NLMSG_ALIGN(rta->rta_len);
 
 	do_nl_req(fd, nh, off, sizeof(data));
-	return genl_parse_getfamily((void *)data);
+	return genl_parse_getfamily((void *)data, pm_family, events_mcast_grp);
 }
 
 int dsf(int fd, int pm_family, int argc, char *argv[])
@@ -1192,7 +1338,9 @@ int set_flags(int fd, int pm_family, int argc, char *argv[])
 
 int main(int argc, char *argv[])
 {
-	int fd, pm_family;
+	int events_mcast_grp;
+	int pm_family;
+	int fd;
 
 	if (argc < 2)
 		syntax(argv);
@@ -1201,7 +1349,7 @@ int main(int argc, char *argv[])
 	if (fd == -1)
 		error(1, errno, "socket netlink");
 
-	pm_family = resolve_mptcp_pm_netlink(fd);
+	resolve_mptcp_pm_netlink(fd, &pm_family, &events_mcast_grp);
 
 	if (!strcmp(argv[1], "add"))
 		return add_addr(fd, pm_family, argc, argv);
@@ -1225,6 +1373,8 @@ int main(int argc, char *argv[])
 		return get_set_limits(fd, pm_family, argc, argv);
 	else if (!strcmp(argv[1], "set"))
 		return set_flags(fd, pm_family, argc, argv);
+	else if (!strcmp(argv[1], "events"))
+		return capture_events(fd, events_mcast_grp);
 
 	fprintf(stderr, "unknown sub-command: %s", argv[1]);
 	syntax(argv);
-- 
2.36.0

