Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CB4CE40F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfJGNpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:45:03 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:38327 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGNpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:45:03 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 48F24328F02;
        Mon,  7 Oct 2019 15:44:59 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1iHTJr-0005F9-1w; Mon, 07 Oct 2019 15:44:59 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Petr Oros <poros@redhat.com>
Subject: [PATCH iproute2] ipnetns: enable to dump nsid conversion table
Date:   Mon,  7 Oct 2019 15:44:47 +0200
Message-Id: <20191007134447.20077-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables to dump/get nsid from a netns into another netns.

Example:
$ ./test.sh
+ ip netns add foo
+ ip netns add bar
+ touch /var/run/netns/init_net
+ mount --bind /proc/1/ns/net /var/run/netns/init_net
+ ip netns set init_net 11
+ ip netns set foo 12
+ ip netns set bar 13
+ ip netns
init_net (id: 11)
bar (id: 13)
foo (id: 12)
+ ip -n foo netns set init_net 21
+ ip -n foo netns set foo 22
+ ip -n foo netns set bar 23
+ ip -n foo netns
init_net (id: 21)
bar (id: 23)
foo (id: 22)
+ ip -n bar netns set init_net 31
+ ip -n bar netns set foo 32
+ ip -n bar netns set bar 33
+ ip -n bar netns
init_net (id: 31)
bar (id: 33)
foo (id: 32)
+ ip netns list-id target-nsid 12
nsid 21 current-nsid 11 (iproute2 netns name: init_net)
nsid 22 current-nsid 12 (iproute2 netns name: foo)
nsid 23 current-nsid 13 (iproute2 netns name: bar)
+ ip -n foo netns list-id target-nsid 21
nsid 11 current-nsid 21 (iproute2 netns name: init_net)
nsid 12 current-nsid 22 (iproute2 netns name: foo)
nsid 13 current-nsid 23 (iproute2 netns name: bar)
+ ip -n bar netns list-id target-nsid 33 nsid 32
nsid 32 current-nsid 32 (iproute2 netns name: foo)
+ ip -n bar netns list-id target-nsid 31 nsid 32
nsid 12 current-nsid 32 (iproute2 netns name: foo)
+ ip netns list-id nsid 13
nsid 13 (iproute2 netns name: bar)

CC: Petr Oros <poros@redhat.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/libnetlink.h |   5 +-
 ip/ip_common.h       |   1 +
 ip/ipnetns.c         | 115 +++++++++++++++++++++++++++++++++++++++++--
 lib/libnetlink.c     |  15 ++++--
 4 files changed, 126 insertions(+), 10 deletions(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index 311cf3fc90f8..8ebdc6d3d03e 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -71,8 +71,6 @@ int rtnl_mdbdump_req(struct rtnl_handle *rth, int family)
 	__attribute__((warn_unused_result));
 int rtnl_netconfdump_req(struct rtnl_handle *rth, int family)
 	__attribute__((warn_unused_result));
-int rtnl_nsiddump_req(struct rtnl_handle *rth, int family)
-	__attribute__((warn_unused_result));
 
 int rtnl_linkdump_req(struct rtnl_handle *rth, int fam)
 	__attribute__((warn_unused_result));
@@ -85,6 +83,9 @@ int rtnl_linkdump_req_filter_fn(struct rtnl_handle *rth, int fam,
 int rtnl_fdb_linkdump_req_filter_fn(struct rtnl_handle *rth,
 				    req_filter_fn_t filter_fn)
 	__attribute__((warn_unused_result));
+int rtnl_nsiddump_req_filter_fn(struct rtnl_handle *rth, int family,
+				req_filter_fn_t filter_fn)
+	__attribute__((warn_unused_result));
 int rtnl_statsdump_req_filter(struct rtnl_handle *rth, int fam, __u32 filt_mask)
 	__attribute__((warn_unused_result));
 int rtnl_dump_request(struct rtnl_handle *rth, int type, void *req,
diff --git a/ip/ip_common.h b/ip/ip_common.h
index cd916ec87c26..879287e3e506 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -24,6 +24,7 @@ struct link_filter {
 	int master;
 	char *kind;
 	char *slave_kind;
+	int target_nsid;
 };
 
 int get_operstate(const char *name);
diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index a883f210d7ba..20110ef0f58e 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -36,7 +36,7 @@ static int usage(void)
 		"	ip netns pids NAME\n"
 		"	ip [-all] netns exec [NAME] cmd ...\n"
 		"	ip netns monitor\n"
-		"	ip netns list-id\n"
+		"	ip netns list-id [target-nsid POSITIVE-INT] [nsid POSITIVE-INT]\n"
 		"NETNSID := auto | POSITIVE-INT\n");
 	exit(-1);
 }
@@ -46,6 +46,7 @@ static struct rtnl_handle rtnsh = { .fd = -1 };
 
 static int have_rtnl_getnsid = -1;
 static int saved_netns = -1;
+static struct link_filter filter;
 
 static int ipnetns_accept_msg(struct rtnl_ctrl_data *ctrl,
 			      struct nlmsghdr *n, void *arg)
@@ -294,7 +295,7 @@ int print_nsid(struct nlmsghdr *n, void *arg)
 	FILE *fp = (FILE *)arg;
 	struct nsid_cache *c;
 	char name[NAME_MAX];
-	int nsid;
+	int nsid, current;
 
 	if (n->nlmsg_type != RTM_NEWNSID && n->nlmsg_type != RTM_DELNSID)
 		return 0;
@@ -317,9 +318,22 @@ int print_nsid(struct nlmsghdr *n, void *arg)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
 
 	nsid = rta_getattr_u32(tb[NETNSA_NSID]);
-	print_uint(PRINT_ANY, "nsid", "nsid %u ", nsid);
+	if (nsid < 0)
+		print_string(PRINT_ANY, "nsid", "nsid %s ", "not-assigned");
+	else
+		print_uint(PRINT_ANY, "nsid", "nsid %u ", nsid);
+
+	if (tb[NETNSA_CURRENT_NSID]) {
+		current = rta_getattr_u32(tb[NETNSA_CURRENT_NSID]);
+		if (current < 0)
+			print_string(PRINT_ANY, "current-nsid",
+				     "current-nsid %s ", "not-assigned");
+		else
+			print_uint(PRINT_ANY, "current-nsid",
+				   "current-nsid %u ", current);
+	}
 
-	c = netns_map_get_by_nsid(nsid);
+	c = netns_map_get_by_nsid(tb[NETNSA_CURRENT_NSID] ? current : nsid);
 	if (c != NULL) {
 		print_string(PRINT_ANY, "name",
 			     "(iproute2 netns name: %s)", c->name);
@@ -340,15 +354,106 @@ int print_nsid(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
+static int get_netnsid_from_netnsid(int nsid)
+{
+	struct {
+		struct nlmsghdr n;
+		struct rtgenmsg g;
+		char            buf[1024];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(NLMSG_ALIGN(sizeof(struct rtgenmsg))),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = RTM_GETNSID,
+		.g.rtgen_family = AF_UNSPEC,
+	};
+	struct nlmsghdr *answer;
+	int err;
+
+	netns_nsid_socket_init();
+
+	err = addattr32(&req.n, sizeof(req), NETNSA_NSID, nsid);
+	if (err)
+		return err;
+
+	if (filter.target_nsid >= 0) {
+		err = addattr32(&req.n, sizeof(req), NETNSA_TARGET_NSID,
+				filter.target_nsid);
+		if (err)
+			return err;
+	}
+
+	if (rtnl_talk(&rtnsh, &req.n, &answer) < 0)
+		return -2;
+
+	/* Validate message and parse attributes */
+	if (answer->nlmsg_type == NLMSG_ERROR)
+		goto err_out;
+
+	new_json_obj(json);
+	err = print_nsid(answer, stdout);
+	delete_json_obj();
+err_out:
+	free(answer);
+	return err;
+}
+
+static int netns_filter_req(struct nlmsghdr *nlh, int reqlen)
+{
+	int err;
+
+	if (filter.target_nsid >= 0) {
+		err = addattr32(nlh, reqlen, NETNSA_TARGET_NSID,
+				filter.target_nsid);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int netns_list_id(int argc, char **argv)
 {
+	int nsid = -1;
+
 	if (!ipnetns_have_nsid()) {
 		fprintf(stderr,
 			"RTM_GETNSID is not supported by the kernel.\n");
 		return -ENOTSUP;
 	}
 
-	if (rtnl_nsiddump_req(&rth, AF_UNSPEC) < 0) {
+	filter.target_nsid = -1;
+	while (argc > 0) {
+		if (strcmp(*argv, "target-nsid") == 0) {
+			if (filter.target_nsid >= 0)
+				duparg("target-nsid", *argv);
+			NEXT_ARG();
+
+			if (get_integer(&filter.target_nsid, *argv, 0))
+				invarg("\"target-nsid\" value is invalid\n",
+				       *argv);
+			else if (filter.target_nsid < 0)
+				invarg("\"target-nsid\" value should be >= 0\n",
+				       argv[1]);
+		} else if (strcmp(*argv, "nsid") == 0) {
+			if (nsid >= 0)
+				duparg("nsid", *argv);
+			NEXT_ARG();
+
+			if (get_integer(&nsid, *argv, 0))
+				invarg("\"nsid\" value is invalid\n", *argv);
+			else if (nsid < 0)
+				invarg("\"nsid\" value should be >= 0\n",
+				       argv[1]);
+		} else
+			usage();
+		argc--; argv++;
+	}
+
+	if (nsid >= 0)
+		return get_netnsid_from_netnsid(nsid);
+
+	if (rtnl_nsiddump_req_filter_fn(&rth, AF_UNSPEC,
+					netns_filter_req) < 0) {
 		perror("Cannot send dump request");
 		exit(1);
 	}
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 8c490f896326..6ce8b199f441 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -438,12 +438,13 @@ int rtnl_netconfdump_req(struct rtnl_handle *rth, int family)
 	return send(rth->fd, &req, sizeof(req), 0);
 }
 
-int rtnl_nsiddump_req(struct rtnl_handle *rth, int family)
+int rtnl_nsiddump_req_filter_fn(struct rtnl_handle *rth, int family,
+				req_filter_fn_t filter_fn)
 {
 	struct {
 		struct nlmsghdr nlh;
 		struct rtgenmsg rtm;
-		char buf[0] __aligned(NLMSG_ALIGNTO);
+		char buf[1024];
 	} req = {
 		.nlh.nlmsg_len = NLMSG_LENGTH(NLMSG_ALIGN(sizeof(struct rtgenmsg))),
 		.nlh.nlmsg_type = RTM_GETNSID,
@@ -451,8 +452,16 @@ int rtnl_nsiddump_req(struct rtnl_handle *rth, int family)
 		.nlh.nlmsg_seq = rth->dump = ++rth->seq,
 		.rtm.rtgen_family = family,
 	};
+	int err;
 
-	return send(rth->fd, &req, sizeof(req), 0);
+	if (!filter_fn)
+		return -EINVAL;
+
+	err = filter_fn(&req.nlh, sizeof(req));
+	if (err)
+		return err;
+
+	return send(rth->fd, &req, req.nlh.nlmsg_len, 0);
 }
 
 static int __rtnl_linkdump_req(struct rtnl_handle *rth, int family)
-- 
2.23.0

