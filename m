Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00F53B75E4
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 17:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhF2Pxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 11:53:54 -0400
Received: from relay.sw.ru ([185.231.240.75]:37984 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233946AbhF2Pxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 11:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=Lz4cS1gl+Pxt+jJ3Fm07nbykceefDjWfmLkQXWPMy4I=; b=OmQ5+TmEhWx4
        BdfuYVwRN76AeqEwoX2Xl8Us0Qpq8oMivwe6wlLb3h49jpPltNwwVD/gqySXCq78ObM5GX2XFHduN
        z+a98aE/zMSW7LFX3l2/RNhj95kSo8IgtKm+/VU2FqtVf/1iZ0/PKIjNasFx1eRXGMDgsxbikGvSZ
        jO4q4=;
Received: from [192.168.15.46] (helo=mikhalitsyn-laptop.sw.ru)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lXx4Q-002CfC-TK; Tue, 29 Jun 2021 18:51:19 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: [PATCHv4 iproute2] ip route: ignore ENOENT during save if RT_TABLE_MAIN is being dumped
Date:   Tue, 29 Jun 2021 18:51:15 +0300
Message-Id: <20210629155116.23464-1-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We started to use in-kernel filtering feature which allows to get only needed
tables (see iproute_dump_filter()). From the kernel side it's implemented in
net/ipv4/fib_frontend.c (inet_dump_fib), net/ipv6/ip6_fib.c (inet6_dump_fib).
The problem here is that behaviour of "ip route save" was changed after
c7e6371bc ("ip route: Add protocol, table id and device to dump request").
If filters are used, then kernel returns ENOENT error if requested table is absent,
but in newly created net namespace even RT_TABLE_MAIN table doesn't exist.
It is really allocated, for instance, after issuing "ip l set lo up".

Reproducer is fairly simple:
$ unshare -n ip route save > dump
Error: ipv4: FIB table does not exist.
Dump terminated

Expected result here is to get empty dump file (as it was before this change).

v2: reworked, so, now it takes into account NLMSGERR_ATTR_MSG
(see nl_dump_ext_ack_done() function). We want to suppress error messages
in stderr about absent FIB table from kernel too.

v3: reworked to make code clearer. Introduced rtnl_suppressed_errors(),
rtnl_suppress_error() helpers. User may suppress up to 3 errors (may be
easily extened by changing SUPPRESS_ERRORS_INIT macro).

v4: reworked, rtnl_dump_filter_errhndlr() was introduced. Thanks
to Stephen Hemminger for comments and suggestions

Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 include/libnetlink.h | 32 +++++++++++++++++++++++++
 ip/iproute.c         | 15 +++++++++++-
 lib/libnetlink.c     | 56 +++++++++++++++++++++++++++++++++++---------
 3 files changed, 91 insertions(+), 12 deletions(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index b9073a6a..4545e5e5 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -104,6 +104,27 @@ struct rtnl_ctrl_data {
 
 typedef int (*rtnl_filter_t)(struct nlmsghdr *n, void *);
 
+/**
+ * rtnl error handler called from
+ * 	rtnl_dump_done()
+ * 	rtnl_dump_error()
+ *
+ * Return value is a bitmask of the following values:
+ * RTNL_LET_NLERR
+ * 	error handled as usual
+ * RTNL_SUPPRESS_NLMSG_DONE_NLERR
+ * 	error in nlmsg_type == NLMSG_DONE will be suppressed
+ * RTNL_SUPPRESS_NLMSG_ERROR_NLERR
+ * 	error in nlmsg_type == NLMSG_ERROR will be suppressed
+ * 	and nlmsg will be skipped
+ * RTNL_SUPPRESS_NLERR - suppress error in both previous cases
+ */
+#define RTNL_LET_NLERR				0x01
+#define RTNL_SUPPRESS_NLMSG_DONE_NLERR		0x02
+#define RTNL_SUPPRESS_NLMSG_ERROR_NLERR		0x04
+#define RTNL_SUPPRESS_NLERR			0x06
+typedef int (*rtnl_err_hndlr_t)(struct nlmsghdr *n, void *);
+
 typedef int (*rtnl_listen_filter_t)(struct rtnl_ctrl_data *,
 				    struct nlmsghdr *n, void *);
 
@@ -113,6 +134,8 @@ typedef int (*nl_ext_ack_fn_t)(const char *errmsg, uint32_t off,
 struct rtnl_dump_filter_arg {
 	rtnl_filter_t filter;
 	void *arg1;
+	rtnl_err_hndlr_t errhndlr;
+	void *arg2;
 	__u16 nc_flags;
 };
 
@@ -121,6 +144,15 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
 			void *arg, __u16 nc_flags);
 #define rtnl_dump_filter(rth, filter, arg) \
 	rtnl_dump_filter_nc(rth, filter, arg, 0)
+int rtnl_dump_filter_errhndlr_nc(struct rtnl_handle *rth,
+				 rtnl_filter_t filter,
+				 void *arg1,
+				 rtnl_err_hndlr_t errhndlr,
+				 void *arg2,
+				 __u16 nc_flags);
+#define rtnl_dump_filter_errhndlr(rth, filter, farg, errhndlr, earg) \
+	rtnl_dump_filter_errhndlr_nc(rth, filter, farg, errhndlr, earg, 0)
+
 int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	      struct nlmsghdr **answer)
 	__attribute__((warn_unused_result));
diff --git a/ip/iproute.c b/ip/iproute.c
index 5853f026..e45f0bea 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1727,6 +1727,18 @@ static int iproute_flush(int family, rtnl_filter_t filter_fn)
 	}
 }
 
+static int save_route_errhndlr(struct nlmsghdr *n, void *arg)
+{
+	int err = -*(int *)NLMSG_DATA(n);
+
+	if (n->nlmsg_type == NLMSG_DONE &&
+	    filter.tb == RT_TABLE_MAIN &&
+	    err == ENOENT)
+		return RTNL_SUPPRESS_NLMSG_DONE_NLERR;
+
+	return RTNL_LET_NLERR;
+}
+
 static int iproute_list_flush_or_save(int argc, char **argv, int action)
 {
 	int dump_family = preferred_family;
@@ -1939,7 +1951,8 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
 
 	new_json_obj(json);
 
-	if (rtnl_dump_filter(&rth, filter_fn, stdout) < 0) {
+	if (rtnl_dump_filter_errhndlr(&rth, filter_fn, stdout,
+				      save_route_errhndlr, NULL) < 0) {
 		fprintf(stderr, "Dump terminated\n");
 		return -2;
 	}
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index c958aa57..80a92e6f 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -673,7 +673,8 @@ int rtnl_dump_request_n(struct rtnl_handle *rth, struct nlmsghdr *n)
 	return sendmsg(rth->fd, &msg, 0);
 }
 
-static int rtnl_dump_done(struct nlmsghdr *h)
+static int rtnl_dump_done(struct nlmsghdr *h,
+			  const struct rtnl_dump_filter_arg *a)
 {
 	int len = *(int *)NLMSG_DATA(h);
 
@@ -683,11 +684,15 @@ static int rtnl_dump_done(struct nlmsghdr *h)
 	}
 
 	if (len < 0) {
+		errno = -len;
+
+		if (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_DONE_NLERR)
+			return 0;
+
 		/* check for any messages returned from kernel */
 		if (nl_dump_ext_ack_done(h, len))
 			return len;
 
-		errno = -len;
 		switch (errno) {
 		case ENOENT:
 		case EOPNOTSUPP:
@@ -708,8 +713,9 @@ static int rtnl_dump_done(struct nlmsghdr *h)
 	return 0;
 }
 
-static void rtnl_dump_error(const struct rtnl_handle *rth,
-			    struct nlmsghdr *h)
+static int rtnl_dump_error(const struct rtnl_handle *rth,
+			    struct nlmsghdr *h,
+			    const struct rtnl_dump_filter_arg *a)
 {
 
 	if (h->nlmsg_len < NLMSG_LENGTH(sizeof(struct nlmsgerr))) {
@@ -721,11 +727,16 @@ static void rtnl_dump_error(const struct rtnl_handle *rth,
 		if (rth->proto == NETLINK_SOCK_DIAG &&
 		    (errno == ENOENT ||
 		     errno == EOPNOTSUPP))
-			return;
+			return -1;
+
+		if (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_ERROR_NLERR)
+			return 0;
 
 		if (!(rth->flags & RTNL_HANDLE_F_SUPPRESS_NLERR))
 			perror("RTNETLINK answers");
 	}
+
+	return -1;
 }
 
 static int __rtnl_recvmsg(int fd, struct msghdr *msg, int flags)
@@ -834,7 +845,7 @@ static int rtnl_dump_filter_l(struct rtnl_handle *rth,
 					dump_intr = 1;
 
 				if (h->nlmsg_type == NLMSG_DONE) {
-					err = rtnl_dump_done(h);
+					err = rtnl_dump_done(h, a);
 					if (err < 0) {
 						free(buf);
 						return -1;
@@ -845,9 +856,13 @@ static int rtnl_dump_filter_l(struct rtnl_handle *rth,
 				}
 
 				if (h->nlmsg_type == NLMSG_ERROR) {
-					rtnl_dump_error(rth, h);
-					free(buf);
-					return -1;
+					err = rtnl_dump_error(rth, h, a);
+					if (err < 0) {
+						free(buf);
+						return -1;
+					}
+
+					goto skip_it;
 				}
 
 				if (!rth->dump_fp) {
@@ -887,8 +902,27 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
 		     void *arg1, __u16 nc_flags)
 {
 	const struct rtnl_dump_filter_arg a[2] = {
-		{ .filter = filter, .arg1 = arg1, .nc_flags = nc_flags, },
-		{ .filter = NULL,   .arg1 = NULL, .nc_flags = 0, },
+		{ .filter = filter, .arg1 = arg1,
+		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = nc_flags, },
+		{ .filter = NULL,   .arg1 = NULL,
+		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = 0, },
+	};
+
+	return rtnl_dump_filter_l(rth, a);
+}
+
+int rtnl_dump_filter_errhndlr_nc(struct rtnl_handle *rth,
+		     rtnl_filter_t filter,
+		     void *arg1,
+		     rtnl_err_hndlr_t errhndlr,
+		     void *arg2,
+		     __u16 nc_flags)
+{
+	const struct rtnl_dump_filter_arg a[2] = {
+		{ .filter = filter, .arg1 = arg1,
+		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
+		{ .filter = NULL,   .arg1 = NULL,
+		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = 0, },
 	};
 
 	return rtnl_dump_filter_l(rth, a);
-- 
2.31.1

