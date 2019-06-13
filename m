Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 198C44445A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbfFMQg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:36:27 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33794 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730690AbfFMHe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 03:34:26 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2019 03:34:24 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 28A7CE245A;
        Thu, 13 Jun 2019 17:26:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1560410766; bh=TlAqb
        Y+Y/Nk/xinv0oXwaBI/JgLTGJM+BcFsiZMUIdQ=; b=Qn9jJjdyaCFzRtnqLQMMs
        JDk+MyoVg/uUEz1xEpBXdnOkHBx6mmXDdKJhhu6qWku736ZiMF7+2Kyl6g29CYWA
        K73l6Huu3jnUvOPjqZ0Rlxiehsar1dZ7UGCuEMUQk0uygn0tDtbAlFe8dvdw2a27
        vd7/gyWCxjjRrP9IFauusg=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NE5pbgZEfpVu; Thu, 13 Jun 2019 17:26:06 +1000 (AEST)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id AB2F3E492F;
        Thu, 13 Jun 2019 17:26:05 +1000 (AEST)
Received: from build.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id C04DAE245A;
        Thu, 13 Jun 2019 17:26:03 +1000 (AEST)
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     dsahern@gmail.com, jon.maloy@ericsson.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [iproute2-next v4] tipc: support interface name when activating UDP bearer
Date:   Thu, 13 Jun 2019 14:25:53 +0700
Message-Id: <20190613072553.20747-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for indicating interface name has an ip address in parallel
with specifying ip address when activating UDP bearer.
This liberates the user from keeping track of the current ip address
for each device.

Old command syntax:
$tipc bearer enable media udp name NAME localip IP

New command syntax:
$tipc bearer enable media udp name NAME [localip IP|dev DEVICE]

v2:
    - Removed initial value for fd
    - Fixed the returning value for cmd_bearer_validate_and_get_addr
      to make its consistent with using: zero or non-zero
v3:
    - Switch to use helper 'get_ifname' to retrieve interface name

v4:
    - Replace legacy SIOCGIFADDR using by netlink

Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 tipc/bearer.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 84 insertions(+), 5 deletions(-)

diff --git a/tipc/bearer.c b/tipc/bearer.c
index 1f3a4d44441e..367ec8a2630f 100644
--- a/tipc/bearer.c
+++ b/tipc/bearer.c
@@ -19,10 +19,12 @@
 #include <linux/tipc_netlink.h>
 #include <linux/tipc.h>
 #include <linux/genetlink.h>
+#include <linux/if.h>
 
 #include <libmnl/libmnl.h>
 #include <sys/socket.h>
 
+#include "utils.h"
 #include "cmdl.h"
 #include "msg.h"
 #include "bearer.h"
@@ -68,7 +70,7 @@ static void cmd_bearer_enable_l2_help(struct cmdl *cmdl, char *media)
 static void cmd_bearer_enable_udp_help(struct cmdl *cmdl, char *media)
 {
 	fprintf(stderr,
-		"Usage: %s bearer enable [OPTIONS] media %s name NAME localip IP [UDP OPTIONS]\n\n"
+		"Usage: %s bearer enable [OPTIONS] media %s name NAME [localip IP|device DEVICE] [UDP OPTIONS]\n\n"
 		"OPTIONS\n"
 		" domain DOMAIN		- Discovery domain\n"
 		" priority PRIORITY	- Bearer priority\n\n"
@@ -119,6 +121,71 @@ static int generate_multicast(short af, char *buf, int bufsize)
 	return 0;
 }
 
+static struct ifreq ifr;
+static int nl_dump_addr_filter(struct nlmsghdr *nlh, void *arg)
+{
+	struct ifaddrmsg *ifa = NLMSG_DATA(nlh);
+	char *r_addr = (char *)arg;
+	int len = nlh->nlmsg_len;
+	struct rtattr *addr_attr;
+
+	if (ifr.ifr_ifindex != ifa->ifa_index)
+		return 0;
+
+	if (strlen(r_addr) > 0)
+		return 1;
+
+	addr_attr = parse_rtattr_one(IFA_ADDRESS, IFA_RTA(ifa),
+				     len - NLMSG_LENGTH(sizeof(*ifa)));
+	if (!addr_attr)
+		return 0;
+
+	if (ifa->ifa_family == AF_INET) {
+		struct sockaddr_in ip4addr;
+		memcpy(&ip4addr.sin_addr, RTA_DATA(addr_attr),
+		       sizeof(struct in_addr));
+		if (inet_ntop(AF_INET, &ip4addr.sin_addr, r_addr,
+			      INET_ADDRSTRLEN) == NULL)
+			return 0;
+	} else if (ifa->ifa_family == AF_INET6) {
+		struct sockaddr_in6 ip6addr;
+		memcpy(&ip6addr.sin6_addr, RTA_DATA(addr_attr),
+		       sizeof(struct in6_addr));
+		if (inet_ntop(AF_INET6, &ip6addr.sin6_addr, r_addr,
+			      INET6_ADDRSTRLEN) == NULL)
+			return 0;
+	}
+	return 1;
+}
+
+static int cmd_bearer_validate_and_get_addr(const char *name, char *r_addr)
+{
+	struct rtnl_handle rth = { .fd = -1 };
+
+	memset(&ifr, 0, sizeof(ifr));
+	if (!name || !r_addr || get_ifname(ifr.ifr_name, name))
+		return 0;
+
+	ifr.ifr_ifindex = ll_name_to_index(ifr.ifr_name);
+	if (!ifr.ifr_ifindex)
+		return 0;
+
+	/* remove from cache */
+	ll_drop_by_index(ifr.ifr_ifindex);
+
+	if (rtnl_open(&rth, 0) < 0)
+		return 0;
+
+	if (rtnl_addrdump_req(&rth, AF_UNSPEC, 0) < 0)
+		return 0;
+
+	if (rtnl_dump_filter(&rth, nl_dump_addr_filter, r_addr) < 0)
+		return 0;
+
+	rtnl_close(&rth);
+	return 1;
+}
+
 static int nl_add_udp_enable_opts(struct nlmsghdr *nlh, struct opt *opts,
 				  struct cmdl *cmdl)
 {
@@ -136,13 +203,25 @@ static int nl_add_udp_enable_opts(struct nlmsghdr *nlh, struct opt *opts,
 		.ai_family = AF_UNSPEC,
 		.ai_socktype = SOCK_DGRAM
 	};
+	char addr[INET6_ADDRSTRLEN] = {0};
 
-	if (!(opt = get_opt(opts, "localip"))) {
-		fprintf(stderr, "error, udp bearer localip missing\n");
-		cmd_bearer_enable_udp_help(cmdl, "udp");
+	opt = get_opt(opts, "device");
+	if (opt && !cmd_bearer_validate_and_get_addr(opt->val, addr)) {
+		fprintf(stderr, "error, no device name available\n");
 		return -EINVAL;
 	}
-	locip = opt->val;
+
+	if (strlen(addr) > 0) {
+		locip = addr;
+	} else {
+		opt = get_opt(opts, "localip");
+		if (!opt) {
+			fprintf(stderr, "error, udp bearer localip/device missing\n");
+			cmd_bearer_enable_udp_help(cmdl, "udp");
+			return -EINVAL;
+		}
+		locip = opt->val;
+	}
 
 	if ((opt = get_opt(opts, "remoteip")))
 		remip = opt->val;
-- 
2.17.1

