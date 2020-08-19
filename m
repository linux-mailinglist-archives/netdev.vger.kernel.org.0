Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F38324A84B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgHSVOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgHSVOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:14:50 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F2EC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 14:14:50 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a6so2154456pjd.1
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 14:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WtpjoRG99P2WIQ2XdHPRtMjdR4vaEZTnoR9fLjcLVZY=;
        b=SDdcusZPVnL7MEx7p8HdTS0vmEwS3oWDb1L2qjU26LSHN3MJXZgmRB5MElDnNK3Ej3
         /BoBWkv3jLkpYcnGwILZQnM5g11lL4aYAwHGG5mv5iI8VKTtEBYHoCi4kQVui9S4bIWC
         d1ZpY35inMAnnWE2UOgQ7zePnlg42a9F760Y0BgHQiyaEqTSZfcA8x/ptSddcvCnLQDZ
         MmW/hlhHbdeNSNCs+clg9fBf04FE2q9PQP70YbjyGotJuFSz4a/MF/ZDvEEQ1SEzBGWK
         GWvoPcXKRh1WeMXp/S2M84QA2C3iPLmorhCE+HJT1FfEFRuuAbt2OaP8cLHzB/CSI3fZ
         IB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WtpjoRG99P2WIQ2XdHPRtMjdR4vaEZTnoR9fLjcLVZY=;
        b=jgJM+ze0xiWSfNM9IwM/YSRbT+IN6iWUU3n1LikMec+cNrRWdcKd0mGepW1d0teg41
         EwO/dXe13/KcgXmqY289IIYBxxfjW3N1lzSC2yQKnrhNXWw5IT0cACUftn0sZyXdAFGP
         Gx0wMUmWm2yQp2WvW55PMmV8PyXMZw03Cw2Bmv0FyS62J1cdKGi6VYzIl+sjzU65gWRD
         opAXpkycd+j0p0gN9hW5Ex1SGrY4fAYUxc2NkljVFqzhItC+Zrm3rjx3MmZAq1xiZt6G
         ttilpzkxDhBz6yfVEFms0DO0CxzWqXyekuzoZ4/WemCyG8ChrIbFXglOPcMgBQrmgmA9
         7z3A==
X-Gm-Message-State: AOAM5329gbu5GsG52xRkX/8gJJUFnEFBpaAQIbFiMXU4gfAla+1HQQ2g
        s6hrMXkjEghX2OiYvt/mn5+VszgqZ1c4ylZGNWd/ea55jG1OABcJ6cy2Qgku6zHyom2bv9tyj/q
        vQdIAXo82AOHgjkhRuXPIGX1MLD4b+o0cSm/Vf0mwzCRXt4jyhu2+dVvUi5Xqdw==
X-Google-Smtp-Source: ABdhPJxOjZ/Oc4R2du7afMPya5A2m3zyaAo7NBY+CHmfrvF1gyeztFxxlCnqCMvo3GZ1mKQNd1Eb3dRCiCQ=
X-Received: by 2002:a05:6a00:15cb:: with SMTP id o11mr20520199pfu.263.1597871689265;
 Wed, 19 Aug 2020 14:14:49 -0700 (PDT)
Date:   Wed, 19 Aug 2020 14:13:54 -0700
Message-Id: <20200819211354.2049295-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH iproute2-next v3] iproute2: ss: add support to expose various
 inet sockopts
From:   Wei Wang <weiwan@google.com>
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Mahesh Bandewar <maheshb@google.com>,
        Roman Mashak <mrv@mojatatu.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support to expose the following inet socket options:
-- recverr
-- is_icsk
-- freebind
-- hdrincl
-- mc_loop
-- transparent
-- mc_all
-- nodefrag
-- bind_address_no_port
-- recverr_rfc4884
-- defer_connect
with the option --inet-sockopt. The individual option is only shown
when set.

Signed-off-by: Wei Wang <weiwan@google.com>
---
v1->v2:
- Change the output to only display sockopts that are set.

v2->v3:
- Add manpage modification

 include/uapi/linux/inet_diag.h | 18 ++++++++++++++
 man/man8/ss.8                  |  3 +++
 misc/ss.c                      | 43 ++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index cd83b4f8..ed1c3153 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -160,6 +160,7 @@ enum {
 	INET_DIAG_ULP_INFO,
 	INET_DIAG_SK_BPF_STORAGES,
 	INET_DIAG_CGROUP_ID,
+	INET_DIAG_SOCKOPT,
 	__INET_DIAG_MAX,
 };
 
@@ -183,6 +184,23 @@ struct inet_diag_meminfo {
 	__u32	idiag_tmem;
 };
 
+/* INET_DIAG_SOCKOPT */
+
+struct inet_diag_sockopt {
+	__u8	recverr:1,
+		is_icsk:1,
+		freebind:1,
+		hdrincl:1,
+		mc_loop:1,
+		transparent:1,
+		mc_all:1,
+		nodefrag:1;
+	__u8	bind_address_no_port:1,
+		recverr_rfc4884:1,
+		defer_connect:1,
+		unused:5;
+};
+
 /* INET_DIAG_VEGASINFO */
 
 struct tcpvegas_info {
diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 3b2559ff..839bab38 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -379,6 +379,9 @@ Display vsock sockets (alias for -f vsock).
 .B \-\-xdp
 Display XDP sockets (alias for -f xdp).
 .TP
+.B \-\-inet-sockopt
+Display inet socket options.
+.TP
 .B \-f FAMILY, \-\-family=FAMILY
 Display sockets of type FAMILY.  Currently the following families are
 supported: unix, inet, inet6, link, netlink, vsock, xdp.
diff --git a/misc/ss.c b/misc/ss.c
index e5565725..458e381f 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -114,6 +114,7 @@ static int sctp_ino;
 static int show_tipcinfo;
 static int show_tos;
 static int show_cgroup;
+static int show_inet_sockopt;
 int oneline;
 
 enum col_id {
@@ -3333,6 +3334,41 @@ static int inet_show_sock(struct nlmsghdr *nlh,
 			out(" cgroup:%s", cg_id_to_path(rta_getattr_u64(tb[INET_DIAG_CGROUP_ID])));
 	}
 
+	if (show_inet_sockopt) {
+		if (tb[INET_DIAG_SOCKOPT] && RTA_PAYLOAD(tb[INET_DIAG_SOCKOPT]) >=
+		    sizeof(struct inet_diag_sockopt)) {
+			const struct inet_diag_sockopt *sockopt =
+					RTA_DATA(tb[INET_DIAG_SOCKOPT]);
+			if (!oneline)
+				out("\n\tinet-sockopt: (");
+			else
+				out(" inet-sockopt: (");
+			if (sockopt->recverr)
+				out(" recverr");
+			if (sockopt->is_icsk)
+				out(" is_icsk");
+			if (sockopt->freebind)
+				out(" freebind");
+			if (sockopt->hdrincl)
+				out(" hdrincl");
+			if (sockopt->mc_loop)
+				out(" mc_loop");
+			if (sockopt->transparent)
+				out(" transparent");
+			if (sockopt->mc_all)
+				out(" mc_all");
+			if (sockopt->nodefrag)
+				out(" nodefrag");
+			if (sockopt->bind_address_no_port)
+				out(" bind_addr_no_port");
+			if (sockopt->recverr_rfc4884)
+				out(" recverr_rfc4884");
+			if (sockopt->defer_connect)
+				out(" defer_connect");
+			out(")");
+		}
+	}
+
 	if (show_mem || (show_tcpinfo && s->type != IPPROTO_UDP)) {
 		if (!oneline)
 			out("\n\t");
@@ -5210,6 +5246,7 @@ static void _usage(FILE *dest)
 "   -K, --kill          forcibly close sockets, display what was closed\n"
 "   -H, --no-header     Suppress header line\n"
 "   -O, --oneline       socket's data printed on a single line\n"
+"       --inet-sockopt  show various inet socket options\n"
 "\n"
 "   -A, --query=QUERY, --socket=QUERY\n"
 "       QUERY := {all|inet|tcp|mptcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink|vsock_stream|vsock_dgram|tipc}[,QUERY]\n"
@@ -5299,6 +5336,8 @@ static int scan_state(const char *state)
 
 #define OPT_CGROUP 261
 
+#define OPT_INET_SOCKOPT 262
+
 static const struct option long_opts[] = {
 	{ "numeric", 0, 0, 'n' },
 	{ "resolve", 0, 0, 'r' },
@@ -5341,6 +5380,7 @@ static const struct option long_opts[] = {
 	{ "xdp", 0, 0, OPT_XDPSOCK},
 	{ "mptcp", 0, 0, 'M' },
 	{ "oneline", 0, 0, 'O' },
+	{ "inet-sockopt", 0, 0, OPT_INET_SOCKOPT },
 	{ 0 }
 
 };
@@ -5539,6 +5579,9 @@ int main(int argc, char *argv[])
 		case 'O':
 			oneline = 1;
 			break;
+		case OPT_INET_SOCKOPT:
+			show_inet_sockopt = 1;
+			break;
 		case 'h':
 			help();
 		case '?':
-- 
2.28.0.297.g1956fa8f8d-goog

