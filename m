Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E7F25648D
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 05:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgH2DnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 23:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgH2DnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 23:43:02 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D576C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 20:43:02 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id g6so441360pjl.0
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 20:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yb+JN8cTwOlEak148GYOUdG7ck2blK6IFFOkWyKngdY=;
        b=KjrTAIHYRHLT433sUoA7c4o12z0A2ZZLDAjnhLzVsumCptqFMiVaBic0ZoN1nOu//D
         iM6p6M9L5HiARWPh7hGO8vsnYjbQLaVext/ajU8RonJH/pJtM/T4pQEguGbVXZAZk+1X
         pJp3fDSq2oZjNGvV/Fzp9kjpPpT5i3AVhEZnI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yb+JN8cTwOlEak148GYOUdG7ck2blK6IFFOkWyKngdY=;
        b=PaUBrAKVFMw+FST7PzmhR8XsTWNkhoY0Uw3+oybqubs9tMhBDF9RgRpbRXhSr35qq/
         fKkzAR9IC82/QGPTs6bBpT8YDhKAaKsEVMoxWvehuUhle4bAgWiU46YIGsFD3S3NodT7
         3HS/6d28FeZ4F3kQDRkXpq1lXbkC1KWRw/QWMATtjDRKtqZ8+QX0PvhRMNRKqAJHrtP3
         WEbECekdECKnwiuRTbFUAqDkuTCxhQAKNNwRsSd+j1UZGnoRaE76+3FQdg4skm3a2fOI
         +dGCkEwMb/N5G8mETLGi9iIu3x0x5736heLI4vxfyrKIAfMSyhylDKJrA6UK8J2xTvU+
         jUMQ==
X-Gm-Message-State: AOAM531Rod6xkYEb/bhPohgzEguB2ZHlcho4asOCHb45jlUsPZvX8QaW
        MrEUsWJwlOPAVrXBDaDzn57ckw==
X-Google-Smtp-Source: ABdhPJzb3AACZeQAbBszx2sDDLHsT+IVVduJk1fPuZPKBubPuZqkLIUg5amJ07vbO55hhLrKYKlAog==
X-Received: by 2002:a17:902:b7cc:: with SMTP id v12mr1483689plz.105.1598672581651;
        Fri, 28 Aug 2020 20:43:01 -0700 (PDT)
Received: from tetra-01.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id n5sm883459pgt.24.2020.08.28.20.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 20:43:01 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Subject: [PATCH iproute2 net-next v2] iplink: add support for protodown reason
Date:   Fri, 28 Aug 2020 20:42:56 -0700
Message-Id: <20200829034256.47225-1-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This patch adds support for recently
added link IFLA_PROTO_DOWN_REASON attribute.
IFLA_PROTO_DOWN_REASON enumerates reasons
for the already existing IFLA_PROTO_DOWN link
attribute.

$ cat /etc/iproute2/protodown_reasons.d/r.conf
0 mlag
1 evpn
2 vrrp
3 psecurity

$ ip link set dev vx10 protodown on protodown_reason vrrp on
$ip link show dev vx10
14: vx10: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
DEFAULT group default qlen 1000
    link/ether f2:32:28:b8:35:ff brd ff:ff:ff:ff:ff:ff protodown on
protodown_reason <vrrp>
$ip -p -j link show dev vx10
[ {
	<snip>
        "proto_down": true,
        "proto_down_reason": [ "vrrp" ]
} ]
$ip link set dev vx10 protodown_reason mlag on
$ip link show dev vx10
14: vx10: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
DEFAULT group default qlen 1000
    link/ether f2:32:28:b8:35:ff brd ff:ff:ff:ff:ff:ff protodown on
protodown_reason <mlag,vrrp>
$ip -p -j link show dev vx10
[ {
	<snip>
        "proto_down": true,
        "protodown_reason": [ "mlag","vrrp" ]
} ]

$ip -p -j link show dev vx10
$ip link set dev vx10 protodown off protodown_reason vrrp off
Error: Cannot clear protodown, active reasons.
$ip link set dev vx10 protodown off protodown_reason mlag off
$

Note: for somereason the json and non-json key for protodown
are different (protodown and proto_down). I have kept the
same for protodown reason for consistency (protodown_reason and
proto_down_reason).

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
v2 - address comments from David Ahern

 include/rt_names.h    |  3 ++
 ip/ipaddress.c        | 46 +++++++++++++++++++---
 ip/iplink.c           | 23 +++++++++++
 lib/rt_names.c        | 92 +++++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in | 10 +++++
 5 files changed, 169 insertions(+), 5 deletions(-)

diff --git a/include/rt_names.h b/include/rt_names.h
index 7afce170..990ed7f2 100644
--- a/include/rt_names.h
+++ b/include/rt_names.h
@@ -33,6 +33,9 @@ int ll_proto_a2n(unsigned short *id, const char *buf);
 const char *nl_proto_n2a(int id, char *buf, int len);
 int nl_proto_a2n(__u32 *id, const char *arg);
 
+int protodown_reason_a2n(__u32 *id, const char *arg);
+int protodown_reason_n2a(int id, char *buf, int len);
+
 extern int numeric;
 
 #endif
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index ccf67d1d..7a68fa02 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -874,6 +874,45 @@ static void print_link_event(FILE *f, __u32 event)
 	}
 }
 
+static void print_proto_down(FILE *f, struct rtattr *tb[])
+{
+	struct rtattr *preason[IFLA_PROTO_DOWN_REASON_MAX+1];
+
+	if (tb[IFLA_PROTO_DOWN]) {
+		if (rta_getattr_u8(tb[IFLA_PROTO_DOWN]))
+			print_bool(PRINT_ANY,
+				   "proto_down", " protodown on ", true);
+	}
+
+	if (tb[IFLA_PROTO_DOWN_REASON]) {
+		char buf[255];
+		__u32 reason;
+		int i, start = 1;
+
+		parse_rtattr_nested(preason, IFLA_PROTO_DOWN_REASON_MAX,
+				   tb[IFLA_PROTO_DOWN_REASON]);
+		if (!tb[IFLA_PROTO_DOWN_REASON_VALUE])
+			return;
+
+		reason = rta_getattr_u8(preason[IFLA_PROTO_DOWN_REASON_VALUE]);
+		if (!reason)
+			return;
+
+		open_json_array(PRINT_ANY,
+				is_json_context() ? "proto_down_reason" : "protodown_reason <");
+		for (i = 0; reason; i++, reason >>= 1) {
+			if (reason & 0x1) {
+				if (protodown_reason_n2a(i, buf, sizeof(buf)))
+					break;
+				print_string(PRINT_ANY, NULL,
+					     start ? "%s" : ",%s", buf);
+				start = 0;
+			}
+		}
+		close_json_array(PRINT_ANY, ">");
+	}
+}
+
 int print_linkinfo(struct nlmsghdr *n, void *arg)
 {
 	FILE *fp = (FILE *)arg;
@@ -1066,11 +1105,8 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 		print_int(PRINT_FP, NULL, " new-ifindex %d", id);
 	}
 
-	if (tb[IFLA_PROTO_DOWN]) {
-		if (rta_getattr_u8(tb[IFLA_PROTO_DOWN]))
-			print_bool(PRINT_ANY,
-				   "proto_down", " protodown on ", true);
-	}
+	if (tb[IFLA_PROTO_DOWN])
+		print_proto_down(fp, tb);
 
 	if (show_details) {
 		if (tb[IFLA_PROMISCUITY])
diff --git a/ip/iplink.c b/ip/iplink.c
index 7d4b244d..370a802d 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -105,6 +105,7 @@ void iplink_usage(void)
 		"			[ nomaster ]\n"
 		"			[ addrgenmode { eui64 | none | stable_secret | random } ]\n"
 		"			[ protodown { on | off } ]\n"
+		"			[ protodown_reason PREASON { on | off } ]\n"
 		"			[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
 		"\n"
 		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
@@ -903,6 +904,28 @@ int iplink_parse(int argc, char **argv, struct iplink_req *req, char **type)
 				return on_off("protodown", *argv);
 			addattr8(&req->n, sizeof(*req), IFLA_PROTO_DOWN,
 				 proto_down);
+		} else if (strcmp(*argv, "protodown_reason") == 0) {
+			struct rtattr *pr;
+			__u32 preason = 0, prvalue = 0, prmask = 0;
+
+			NEXT_ARG();
+			if (protodown_reason_a2n(&preason, *argv))
+				invarg("invalid protodown reason\n", *argv);
+			NEXT_ARG();
+			prmask = 1 << preason;
+			if (matches(*argv, "on") == 0)
+				prvalue |= prmask;
+			else if (matches(*argv, "off") == 0)
+				prvalue &= ~prmask;
+			else
+				return on_off("protodown_reason", *argv);
+			pr = addattr_nest(&req->n, sizeof(*req),
+					  IFLA_PROTO_DOWN_REASON | NLA_F_NESTED);
+			addattr32(&req->n, sizeof(*req),
+				  IFLA_PROTO_DOWN_REASON_MASK, prmask);
+			addattr32(&req->n, sizeof(*req),
+				  IFLA_PROTO_DOWN_REASON_VALUE, prvalue);
+			addattr_nest_end(&req->n, pr);
 		} else if (strcmp(*argv, "gso_max_size") == 0) {
 			unsigned int max_size;
 
diff --git a/lib/rt_names.c b/lib/rt_names.c
index c40d2e77..ca0680a1 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -682,3 +682,95 @@ int nl_proto_a2n(__u32 *id, const char *arg)
 	*id = res;
 	return 0;
 }
+
+#define PROTODOWN_REASON_NUM_BITS 32
+static char *protodown_reason_tab[PROTODOWN_REASON_NUM_BITS] = {
+};
+
+static int protodown_reason_init;
+
+static void protodown_reason_initialize(void)
+{
+	struct dirent *de;
+	DIR *d;
+
+	protodown_reason_init = 1;
+
+	d = opendir(CONFDIR "/protodown_reasons.d");
+	if (!d)
+		return;
+
+	while ((de = readdir(d)) != NULL) {
+		char path[PATH_MAX];
+		size_t len;
+
+		if (*de->d_name == '.')
+			continue;
+
+		/* only consider filenames ending in '.conf' */
+		len = strlen(de->d_name);
+		if (len <= 5)
+			continue;
+		if (strcmp(de->d_name + len - 5, ".conf"))
+			continue;
+
+		snprintf(path, sizeof(path), CONFDIR "/protodown_reasons.d/%s",
+			 de->d_name);
+		rtnl_tab_initialize(path, protodown_reason_tab,
+				    PROTODOWN_REASON_NUM_BITS);
+	}
+	closedir(d);
+}
+
+int protodown_reason_n2a(int id, char *buf, int len)
+{
+	if (id < 0 || id >= PROTODOWN_REASON_NUM_BITS)
+		return -1;
+
+	if (numeric) {
+		snprintf(buf, len, "%d", id);
+		return 0;
+	}
+
+	if (!protodown_reason_init)
+		protodown_reason_initialize();
+
+	if (protodown_reason_tab[id])
+		snprintf(buf, len, "%s", protodown_reason_tab[id]);
+	else
+		snprintf(buf, len, "%d", id);
+
+	return 0;
+}
+
+int protodown_reason_a2n(__u32 *id, const char *arg)
+{
+	static char *cache;
+	static unsigned long res;
+	char *end;
+	int i;
+
+	if (cache && strcmp(cache, arg) == 0) {
+		*id = res;
+		return 0;
+	}
+
+	if (!protodown_reason_init)
+		protodown_reason_initialize();
+
+	for (i = 0; i < PROTODOWN_REASON_NUM_BITS; i++) {
+		if (protodown_reason_tab[i] &&
+		    strcmp(protodown_reason_tab[i], arg) == 0) {
+			cache = protodown_reason_tab[i];
+			res = i;
+			*id = res;
+			return 0;
+		}
+	}
+
+	res = strtoul(arg, &end, 0);
+	if (!end || end == arg || *end || res >= PROTODOWN_REASON_NUM_BITS)
+		return -1;
+	*id = res;
+	return 0;
+}
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index c6bd2c53..c1eb52c6 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -75,6 +75,9 @@ ip-link \- network device configuration
 .br
 .RB "[ " protodown " { " on " | " off " } ]"
 .br
+.RB "[ " protodown_reason
+.IR PREASON " { " on " | " off " } ]"
+.br
 .RB "[ " trailers " { " on " | " off " } ]"
 .br
 .RB "[ " txqueuelen
@@ -1917,6 +1920,13 @@ state on the device. Indicates that a protocol error has been detected
 on the port. Switch drivers can react to this error by doing a phys
 down on the switch port.
 
+.TP
+.BR "protodown_reason PREASON on " or " off"
+set
+.B PROTODOWN
+reasons on the device. protodown reason bit names can be enumerated under
+/etc/iproute2/protodown_reasons.d/. possible reasons bits 0-31
+
 .TP
 .BR "dynamic on " or " dynamic off"
 change the
-- 
2.20.1

