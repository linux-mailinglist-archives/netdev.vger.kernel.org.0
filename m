Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAD4362192
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 15:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbhDPOAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 10:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbhDPOAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 10:00:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D858C061574
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 06:59:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lXP0Y-0003Rh-PB; Fri, 16 Apr 2021 15:59:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.linux.dev>, dsahern@gmail.com,
        stephen@networkplumber.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH iproute2] mptcp: add support for event monitoring
Date:   Fri, 16 Apr 2021 15:59:30 +0200
Message-Id: <20210416135930.9480-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds iproute2 support for mptcp event monitoring, e.g. creation,
establishment, address announcements from the peer, subflow establishment
and so on.

While the kernel-generated events are primarily aimed at mptcpd (e.g. for
subflow management), this is also useful for debugging.

This adds print support for the existing events.

Sample output of 'ip mptcp monitor':
[       CREATED] token=83f3a692 remid=0 locid=0 saddr4=10.0.1.2 daddr4=10.0.1.1 sport=58710 dport=10011
[   ESTABLISHED] token=83f3a692 remid=0 locid=0 saddr4=10.0.1.2 daddr4=10.0.1.1 sport=58710 dport=10011
[SF_ESTABLISHED] token=83f3a692 remid=0 locid=1 saddr4=10.0.2.2 daddr4=10.0.1.1 sport=40195 dport=10011 backup=0
[        CLOSED] token=83f3a692

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libgenl.h          |   1 +
 include/uapi/linux/mptcp.h |   2 +
 ip/ipmptcp.c               | 113 +++++++++++++++++++++++++++++++++++++
 lib/libgenl.c              |  66 ++++++++++++++++++++++
 man/man8/ip-mptcp.8        |   8 +++
 5 files changed, 190 insertions(+)

diff --git a/include/libgenl.h b/include/libgenl.h
index 656493a2c3c4..97281cc1103f 100644
--- a/include/libgenl.h
+++ b/include/libgenl.h
@@ -21,6 +21,7 @@ struct {								\
 	},								\
 }
 
+int genl_add_mcast_grp(struct rtnl_handle *grth, __u16 genl_family, const char *group);
 int genl_resolve_family(struct rtnl_handle *grth, const char *family);
 int genl_init_handle(struct rtnl_handle *grth, const char *family,
 		     int *genl_family);
diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index c3e40165ad4b..d7d47802bc98 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -174,6 +174,8 @@ enum mptcp_event_attr {
 	MPTCP_ATTR_FLAGS,	/* u16 */
 	MPTCP_ATTR_TIMEOUT,	/* u32 */
 	MPTCP_ATTR_IF_IDX,	/* s32 */
+	MPTCP_ATTR_RESET_REASON,/* u32 */
+	MPTCP_ATTR_RESET_FLAGS, /* u32 */
 
 	__MPTCP_ATTR_AFTER_LAST
 };
diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index e1ffafb3c658..fa8481069124 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -23,6 +23,7 @@ static void usage(void)
 		"	ip mptcp endpoint flush\n"
 		"	ip mptcp limits set [ subflows NR ] [ add_addr_accepted NR ]\n"
 		"	ip mptcp limits show\n"
+		"	ip mptcp monitor\n"
 		"FLAG-LIST := [ FLAG-LIST ] FLAG\n"
 		"FLAG  := [ signal | subflow | backup ]\n");
 
@@ -385,6 +386,110 @@ static int mptcp_limit_get_set(int argc, char **argv, int cmd)
 	return 0;
 }
 
+static const char * const event_to_str[] = {
+	[MPTCP_EVENT_CREATED] = "CREATED",
+	[MPTCP_EVENT_ESTABLISHED] = "ESTABLISHED",
+	[MPTCP_EVENT_CLOSED] = "CLOSED",
+	[MPTCP_EVENT_ANNOUNCED] = "ANNOUNCED",
+	[MPTCP_EVENT_REMOVED] = "REMOVED",
+	[MPTCP_EVENT_SUB_ESTABLISHED] = "SF_ESTABLISHED",
+	[MPTCP_EVENT_SUB_CLOSED] = "SF_CLOSED",
+	[MPTCP_EVENT_SUB_PRIORITY] = "SF_PRIO",
+};
+
+static void print_addr(const char *key, int af, struct rtattr *value)
+{
+	void *data = RTA_DATA(value);
+	char str[INET6_ADDRSTRLEN];
+
+	if (inet_ntop(af, data, str, sizeof(str)))
+		printf(" %s=%s", key, str);
+}
+
+static int mptcp_monitor_msg(struct rtnl_ctrl_data *ctrl,
+			     struct nlmsghdr *n, void *arg)
+{
+	const struct genlmsghdr *ghdr = NLMSG_DATA(n);
+	struct rtattr *tb[MPTCP_ATTR_MAX + 1];
+	int len = n->nlmsg_len;
+
+	len -= NLMSG_LENGTH(GENL_HDRLEN);
+	if (len < 0)
+		return -1;
+
+	if (n->nlmsg_type != genl_family)
+		return 0;
+
+	if (timestamp)
+		print_timestamp(stdout);
+
+	if (ghdr->cmd >= ARRAY_SIZE(event_to_str)) {
+		printf("[UNKNOWN %u]\n", ghdr->cmd);
+		goto out;
+	}
+
+	if (event_to_str[ghdr->cmd] == NULL) {
+		printf("[UNKNOWN %u]\n", ghdr->cmd);
+		goto out;
+	}
+
+	printf("[%14s]", event_to_str[ghdr->cmd]);
+
+	parse_rtattr(tb, MPTCP_ATTR_MAX, (void *) ghdr + GENL_HDRLEN, len);
+
+	printf(" token=%08x", rta_getattr_u32(tb[MPTCP_ATTR_TOKEN]));
+
+	if (tb[MPTCP_ATTR_REM_ID])
+		printf(" remid=%u", rta_getattr_u8(tb[MPTCP_ATTR_REM_ID]));
+	if (tb[MPTCP_ATTR_LOC_ID])
+		printf(" locid=%u", rta_getattr_u8(tb[MPTCP_ATTR_LOC_ID]));
+
+	if (tb[MPTCP_ATTR_SADDR4])
+		print_addr("saddr4", AF_INET, tb[MPTCP_ATTR_SADDR4]);
+	if (tb[MPTCP_ATTR_DADDR4])
+		print_addr("daddr4", AF_INET, tb[MPTCP_ATTR_DADDR4]);
+	if (tb[MPTCP_ATTR_SADDR6])
+		print_addr("saddr6", AF_INET6, tb[MPTCP_ATTR_SADDR6]);
+	if (tb[MPTCP_ATTR_DADDR6])
+		print_addr("daddr6", AF_INET6, tb[MPTCP_ATTR_DADDR6]);
+	if (tb[MPTCP_ATTR_SPORT])
+		printf(" sport=%u", rta_getattr_be16(tb[MPTCP_ATTR_SPORT]));
+	if (tb[MPTCP_ATTR_DPORT])
+		printf(" dport=%u", rta_getattr_be16(tb[MPTCP_ATTR_DPORT]));
+	if (tb[MPTCP_ATTR_BACKUP])
+		printf(" backup=%d", rta_getattr_u8(tb[MPTCP_ATTR_BACKUP]));
+	if (tb[MPTCP_ATTR_ERROR])
+		printf(" error=%d", rta_getattr_u8(tb[MPTCP_ATTR_ERROR]));
+	if (tb[MPTCP_ATTR_FLAGS])
+		printf(" flags=%x", rta_getattr_u16(tb[MPTCP_ATTR_FLAGS]));
+	if (tb[MPTCP_ATTR_TIMEOUT])
+		printf(" timeout=%u", rta_getattr_u32(tb[MPTCP_ATTR_TIMEOUT]));
+	if (tb[MPTCP_ATTR_IF_IDX])
+		printf(" ifindex=%d", rta_getattr_s32(tb[MPTCP_ATTR_IF_IDX]));
+	if (tb[MPTCP_ATTR_RESET_REASON])
+		printf(" reset_reason=%u", rta_getattr_u32(tb[MPTCP_ATTR_RESET_REASON]));
+	if (tb[MPTCP_ATTR_RESET_FLAGS])
+		printf(" reset_flags=0x%x", rta_getattr_u32(tb[MPTCP_ATTR_RESET_FLAGS]));
+
+	puts("");
+out:
+	fflush(stdout);
+	return 0;
+}
+
+static int mptcp_monitor(void)
+{
+	if (genl_add_mcast_grp(&genl_rth, genl_family, MPTCP_PM_EV_GRP_NAME) < 0) {
+		perror("can't subscribe to mptcp events");
+		return 1;
+	}
+
+	if (rtnl_listen(&genl_rth, mptcp_monitor_msg, stdout) < 0)
+		return 2;
+
+	return 0;
+}
+
 int do_mptcp(int argc, char **argv)
 {
 	if (argc == 0)
@@ -429,6 +534,14 @@ int do_mptcp(int argc, char **argv)
 						   MPTCP_PM_CMD_GET_LIMITS);
 	}
 
+	if (matches(*argv, "monitor") == 0) {
+		NEXT_ARG_FWD();
+		if (argc == 0)
+			return mptcp_monitor();
+
+		goto unknown;
+	}
+
 unknown:
 	fprintf(stderr, "Command \"%s\" is unknown, try \"ip mptcp help\".\n",
 		*argv);
diff --git a/lib/libgenl.c b/lib/libgenl.c
index f2ce698fc711..4c51d47af46b 100644
--- a/lib/libgenl.c
+++ b/lib/libgenl.c
@@ -67,6 +67,72 @@ int genl_resolve_family(struct rtnl_handle *grth, const char *family)
 	return fnum;
 }
 
+static int genl_parse_grps(struct rtattr *attr, const char *name, unsigned int *id)
+{
+	const struct rtattr *pos;
+
+	rtattr_for_each_nested(pos, attr) {
+		struct rtattr *tb[CTRL_ATTR_MCAST_GRP_MAX + 1];
+
+		parse_rtattr_nested(tb, CTRL_ATTR_MCAST_GRP_MAX, pos);
+
+		if (tb[CTRL_ATTR_MCAST_GRP_NAME] && tb[CTRL_ATTR_MCAST_GRP_ID]) {
+			if (strcmp(name, rta_getattr_str(tb[CTRL_ATTR_MCAST_GRP_NAME])) == 0) {
+				*id = rta_getattr_u32(tb[CTRL_ATTR_MCAST_GRP_ID]);
+				return 0;
+			}
+		}
+	}
+
+	return -1;
+}
+
+int genl_add_mcast_grp(struct rtnl_handle *grth, __u16 fnum, const char *group)
+{
+	GENL_REQUEST(req, 1024, GENL_ID_CTRL, 0, 0, CTRL_CMD_GETFAMILY,
+		     NLM_F_REQUEST);
+	struct rtattr *tb[CTRL_ATTR_MAX + 1];
+	struct nlmsghdr *answer = NULL;
+	struct genlmsghdr *ghdr;
+	struct rtattr *attrs;
+	int len, ret = -1;
+	unsigned int id;
+
+	addattr16(&req.n, sizeof(req), CTRL_ATTR_FAMILY_ID, fnum);
+
+	if (rtnl_talk(grth, &req.n, &answer) < 0) {
+		fprintf(stderr, "Error talking to the kernel\n");
+		return -2;
+	}
+
+	ghdr = NLMSG_DATA(answer);
+	len = answer->nlmsg_len;
+
+	if (answer->nlmsg_type != GENL_ID_CTRL)
+		goto err_free;
+
+	len -= NLMSG_LENGTH(GENL_HDRLEN);
+	if (len < 0)
+		goto err_free;
+
+	attrs = (struct rtattr *) ((char *) ghdr + GENL_HDRLEN);
+	parse_rtattr(tb, CTRL_ATTR_MAX, attrs, len);
+
+	if (tb[CTRL_ATTR_MCAST_GROUPS] == NULL) {
+		fprintf(stderr, "Missing mcast groups TLV\n");
+		goto err_free;
+	}
+
+	if (genl_parse_grps(tb[CTRL_ATTR_MCAST_GROUPS], group, &id) < 0)
+		goto err_free;
+
+	ret = rtnl_add_nl_group(grth, id);
+
+err_free:
+	free(answer);
+	return ret;
+}
+
 int genl_init_handle(struct rtnl_handle *grth, const char *family,
 		     int *genl_family)
 {
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index ef8409ea4a24..b02cf03e757d 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -65,6 +65,9 @@ ip-mptcp \- MPTCP path manager configuration
 .ti -8
 .BR "ip mptcp limits show"
 
+.ti -8
+.BR "ip mptcp monitor"
+
 .SH DESCRIPTION
 
 MPTCP is a transport protocol built on top of TCP that allows TCP
@@ -137,5 +140,10 @@ each accepted ADD_ADDR option, respecting the
 .IR SUBFLOW_NR
 limit.
 
+.sp
+.PP
+.B monitor
+displays creation and deletion of MPTCP connections as well as addition or removal of remote addresses and subflows.
+
 .SH AUTHOR
 Original Manpage by Paolo Abeni <pabeni@redhat.com>
-- 
2.26.3

