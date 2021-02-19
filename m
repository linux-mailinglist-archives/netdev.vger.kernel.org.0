Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B836131FFFA
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 21:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBSUpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 15:45:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBSUpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 15:45:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613767438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pT+Jfgtemjj7VdsDpxppXMVhS7H2+K2fU+9FiBgqSE0=;
        b=XcCsJTeMu4B/cJZ/0lwQAkw6azr/jTUZzdj6jKnS74RWnoRrsFT7h3UYtiir/cNHTWbtlp
        66nDhIHFMb8WMyqr8usfval5Ofkj8CY/l3Axe5Lh0j32qZxJqXfg8tETvkw6AJeT+urFvJ
        CaepTa7d5fCcvDHodTRGYFr6TXkFJlI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-yW8Ih4G1PbaaXPRtOy816Q-1; Fri, 19 Feb 2021 15:43:56 -0500
X-MC-Unique: yW8Ih4G1PbaaXPRtOy816Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3591B801975;
        Fri, 19 Feb 2021 20:43:54 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-79.ams2.redhat.com [10.36.112.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 878345C1BB;
        Fri, 19 Feb 2021 20:43:52 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, mptcp@lists.01.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] mptcp: add support for port based endpoint
Date:   Fri, 19 Feb 2021 21:42:55 +0100
Message-Id: <868cfad6ab2fbd7f4b2ac6522b3ec62fce858fed.1613767061.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The feature is supported by the kernel since 5.11-net-next,
let's allow user-space to use it.

Just parse and dump an additional, per endpoint, u16 attribute

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 ip/ipmptcp.c        | 16 ++++++++++++++--
 man/man8/ip-mptcp.8 |  8 ++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index e1ffafb3..5f659b59 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -17,7 +17,7 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
-		"				      [ FLAG-LIST ]\n"
+		"				      [ port NR ] [ FLAG-LIST ]\n"
 		"	ip mptcp endpoint delete id ID\n"
 		"	ip mptcp endpoint show [ id ID ]\n"
 		"	ip mptcp endpoint flush\n"
@@ -97,6 +97,7 @@ static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n,
 	bool id_set = false;
 	__u32 index = 0;
 	__u32 flags = 0;
+	__u16 port = 0;
 	__u8 id = 0;
 
 	ll_init_map(&rth);
@@ -123,6 +124,10 @@ static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n,
 			if (!index)
 				invarg("device does not exist\n", ifname);
 
+		} else if (matches(*argv, "port") == 0) {
+			NEXT_ARG();
+			if (get_u16(&port, *argv, 0))
+				invarg("expected port", *argv);
 		} else if (get_addr(&address, *argv, AF_UNSPEC) == 0) {
 			addr_set = true;
 		} else {
@@ -145,6 +150,8 @@ static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n,
 		addattr32(n, MPTCP_BUFLEN, MPTCP_PM_ADDR_ATTR_FLAGS, flags);
 	if (index)
 		addattr32(n, MPTCP_BUFLEN, MPTCP_PM_ADDR_ATTR_IF_IDX, index);
+	if (port)
+		addattr16(n, MPTCP_BUFLEN, MPTCP_PM_ADDR_ATTR_PORT, port);
 	if (addr_set) {
 		int type;
 
@@ -181,8 +188,8 @@ static int print_mptcp_addrinfo(struct rtattr *addrinfo)
 	__u8 family = AF_UNSPEC, addr_attr_type;
 	const char *ifname;
 	unsigned int flags;
+	__u16 id, port;
 	int index;
-	__u16 id;
 
 	parse_rtattr_nested(tb, MPTCP_PM_ADDR_ATTR_MAX, addrinfo);
 
@@ -196,6 +203,11 @@ static int print_mptcp_addrinfo(struct rtattr *addrinfo)
 		print_string(PRINT_ANY, "address", "%s ",
 			     format_host_rta(family, tb[addr_attr_type]));
 	}
+	if (tb[MPTCP_PM_ADDR_ATTR_PORT]) {
+		port = rta_getattr_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]);
+		if (port)
+			print_uint(PRINT_ANY, "port", "port %u ", port);
+	}
 	if (tb[MPTCP_PM_ADDR_ATTR_ID]) {
 		id = rta_getattr_u8(tb[MPTCP_PM_ADDR_ATTR_ID]);
 		print_uint(PRINT_ANY, "id", "id %u ", id);
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index ef8409ea..98cb93b9 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -20,6 +20,8 @@ ip-mptcp \- MPTCP path manager configuration
 .ti -8
 .BR "ip mptcp endpoint add "
 .IR IFADDR
+.RB "[ " port
+.IR PORT " ]"
 .RB "[ " dev
 .IR IFNAME " ]"
 .RB "[ " id
@@ -87,6 +89,12 @@ ip mptcp endpoint flush	flush all existing MPTCP endpoints
 .TE
 
 .TP
+.IR PORT
+When a port number is specified, incoming MPTCP subflows for already
+established MPTCP sockets will be accepted on the specified port, regardless
+the original listener port accepting the first MPTCP subflow and/or
+this peer being actually on the client side.
+
 .IR ID
 is a unique numeric identifier for the given endpoint
 
-- 
2.26.2

