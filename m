Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8C3B3296
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhFXPam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:30:42 -0400
Received: from relay.sw.ru ([185.231.240.75]:36862 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232324AbhFXPaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 11:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=fGjOOmRLPO/+lBFaEUN0jNT/PuYBTnlfM3LRVpAZ5ZI=; b=hIUQV6r1XEvJ
        bkDrzblm3njafb3EwGDja/gMuig/QDatMJyMAiaCtzBIrhBfUwjs16STV174n7IT1CHrYvGfALez+
        fGGQi6/epCHGug/daxuPmG3PSW3bKhJIXyj2T9U6b3mQd3jYdvAiFxxVAa5SgRJV2BS+5LR2jjcgb
        i6XN4=;
Received: from [192.168.15.23] (helo=mikhalitsyn-laptop.lan)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lW8KP-001ivU-DM; Thu, 24 Jun 2021 18:28:18 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: [PATCHv2 iproute2] ip route: ignore ENOENT during save if RT_TABLE_MAIN is being dumped
Date:   Thu, 24 Jun 2021 18:28:12 +0300
Message-Id: <20210624152812.29031-1-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622150330.28014-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210622150330.28014-1-alexander.mikhalitsyn@virtuozzo.com>
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

Fixes: c7e6371bc ("ip route: Add protocol, table id and device to dump request")
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 include/libnetlink.h |  5 +++++
 ip/iproute.c         |  8 +++++++-
 lib/libnetlink.c     | 31 ++++++++++++++++++++++++++-----
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index b9073a6a..93c22a09 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -121,6 +121,11 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
 			void *arg, __u16 nc_flags);
 #define rtnl_dump_filter(rth, filter, arg) \
 	rtnl_dump_filter_nc(rth, filter, arg, 0)
+int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
+		     rtnl_filter_t filter,
+		     void *arg1, __u16 nc_flags, const int *errnos);
+#define rtnl_dump_filter_suppress_rtnl_errmsg(rth, filter, arg, errnos) \
+	rtnl_dump_filter_suppress_rtnl_errmsg_nc(rth, filter, arg, 0, errnos)
 int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
 	      struct nlmsghdr **answer)
 	__attribute__((warn_unused_result));
diff --git a/ip/iproute.c b/ip/iproute.c
index 5853f026..796d6d17 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1734,6 +1734,8 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
 	char *od = NULL;
 	unsigned int mark = 0;
 	rtnl_filter_t filter_fn;
+	/* last 0 is array trailing */
+	int suppress_rtnl_errnos[2] = { 0, 0 };
 
 	if (action == IPROUTE_SAVE) {
 		if (save_route_prep())
@@ -1939,7 +1941,11 @@ static int iproute_list_flush_or_save(int argc, char **argv, int action)
 
 	new_json_obj(json);
 
-	if (rtnl_dump_filter(&rth, filter_fn, stdout) < 0) {
+	if (filter.tb == RT_TABLE_MAIN)
+		suppress_rtnl_errnos[0] = ENOENT;
+
+	if (rtnl_dump_filter_suppress_rtnl_errmsg(&rth, filter_fn, stdout,
+						  suppress_rtnl_errnos) < 0) {
 		fprintf(stderr, "Dump terminated\n");
 		return -2;
 	}
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index c958aa57..310203c2 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -673,7 +673,7 @@ int rtnl_dump_request_n(struct rtnl_handle *rth, struct nlmsghdr *n)
 	return sendmsg(rth->fd, &msg, 0);
 }
 
-static int rtnl_dump_done(struct nlmsghdr *h)
+static int rtnl_dump_done(struct nlmsghdr *h, const int *errnos)
 {
 	int len = *(int *)NLMSG_DATA(h);
 
@@ -683,11 +683,19 @@ static int rtnl_dump_done(struct nlmsghdr *h)
 	}
 
 	if (len < 0) {
+		errno = -len;
+
+		while (errnos && *errnos) {
+			if (errno == *errnos)
+				return 0;
+
+			errnos++;
+		}
+
 		/* check for any messages returned from kernel */
 		if (nl_dump_ext_ack_done(h, len))
 			return len;
 
-		errno = -len;
 		switch (errno) {
 		case ENOENT:
 		case EOPNOTSUPP:
@@ -789,7 +797,8 @@ static int rtnl_recvmsg(int fd, struct msghdr *msg, char **answer)
 }
 
 static int rtnl_dump_filter_l(struct rtnl_handle *rth,
-			      const struct rtnl_dump_filter_arg *arg)
+			      const struct rtnl_dump_filter_arg *arg,
+			      const int *errnos)
 {
 	struct sockaddr_nl nladdr;
 	struct iovec iov;
@@ -834,7 +843,7 @@ static int rtnl_dump_filter_l(struct rtnl_handle *rth,
 					dump_intr = 1;
 
 				if (h->nlmsg_type == NLMSG_DONE) {
-					err = rtnl_dump_done(h);
+					err = rtnl_dump_done(h, errnos);
 					if (err < 0) {
 						free(buf);
 						return -1;
@@ -891,7 +900,19 @@ int rtnl_dump_filter_nc(struct rtnl_handle *rth,
 		{ .filter = NULL,   .arg1 = NULL, .nc_flags = 0, },
 	};
 
-	return rtnl_dump_filter_l(rth, a);
+	return rtnl_dump_filter_l(rth, a, NULL);
+}
+
+int rtnl_dump_filter_suppress_rtnl_errmsg_nc(struct rtnl_handle *rth,
+		     rtnl_filter_t filter,
+		     void *arg1, __u16 nc_flags, const int *errnos)
+{
+	const struct rtnl_dump_filter_arg a[2] = {
+		{ .filter = filter, .arg1 = arg1, .nc_flags = nc_flags, },
+		{ .filter = NULL,   .arg1 = NULL, .nc_flags = 0, },
+	};
+
+	return rtnl_dump_filter_l(rth, a, errnos);
 }
 
 static void rtnl_talk_error(struct nlmsghdr *h, struct nlmsgerr *err,
-- 
2.31.1

