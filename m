Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C219B249166
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 01:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgHRXRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 19:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgHRXR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 19:17:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB82C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 16:17:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j37so13003596pgi.16
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 16:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=l1/3JmeNi5/R/8h4ieYVberc46GmmVxUuW9x6dmt91Y=;
        b=eY3dFl7qOMCO+MuBJwz+oLGdlwdMx5//s/n8ABWfFZZTX5GZ45FQetT5ktoCGDQaHy
         5T8pg88p8wUXxDXz6qnaAVPC6Xc5fAiOlSsJ7k2lO9wiDnZ7CVBjT/nlhEtbxjlsSKht
         Dp3S5sovDxkBx3e55VJHtDDsNybD9NtfVS+57zEh80dntmG/k//so00G6tCLef6CO2Ay
         E2E3ajRLUKfPgoWLPklZjBOaVR3BynSMt/ifagbzoPPew4nGe0uKf+WUj+L0mRc/DrqH
         NYOPQwv/WWELgtkmgg7gYQneTExNJAOgooFR80nbzn9ruMFkoyEtGp9+GwL9cZb5An1T
         G29A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=l1/3JmeNi5/R/8h4ieYVberc46GmmVxUuW9x6dmt91Y=;
        b=iDmhU+gWAko9Qp+0w8OdVuA58GIUqjpLo/n504TNRjPl2AqRz2HuhF5NHmYnU1hdZu
         TL6U5Hxu9A+6lIkiSxYkxYeAOqFsILmwxG6SZHjhalvhL/yO1/eOYLNDpfGVzHvJaqVF
         HHXMhsphAHP9n3b/SgvFJMpHUAEdSU7qyWbWK8fh12+pJ9uKtEYOLKnG7/AvCkBx0j6Z
         fQVB7Q9nL2jgPBMH08KZeUZf/ePP1BCP8NyQTte3gAZ1nmuDWD4dPW87AHo1MXdOEtbE
         PQQGWOPJU4ha/ovnuJUMsdMLg4qtTyNYQw5OTxIg0WDpg9P6Hv6lROsBD/Zl8daKIhtZ
         T4Qw==
X-Gm-Message-State: AOAM533G2PX0a1EJ5ADEGSQYQDYNLzEY1Hv5+IdhI92Hx3Nl2TdR5hpk
        eR6uFAQRIgJcVlQi0VWXsD6SGNrTQ9OK3/xhMpbFfIp5QhI8RkqtD5HvNPhPeeT0UacXcBtMghZ
        bKNOEHzBHe+oy1IQO3+ETVPL9OJeK0VeEIBUcGSFTj1NLhbVHyvP6wKqC7UFK5g==
X-Google-Smtp-Source: ABdhPJzXzNs6SVIrWPXFCRdyCvP8p4lzFOS4bNH1MRUJH9qeEmgSEkEDuC32lq+OkJcpZia4Wstkw+QQCt8=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a17:90a:1e65:: with SMTP id
 w92mr1672828pjw.187.1597792648573; Tue, 18 Aug 2020 16:17:28 -0700 (PDT)
Date:   Tue, 18 Aug 2020 16:17:19 -0700
Message-Id: <20200818231719.1813482-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH iproute2-next] iproute2: ss: add support to expose various
 inet sockopts
From:   Wei Wang <weiwan@google.com>
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Wei Wang <weiwan@google.com>, Mahesh Bandewar <maheshb@google.com>
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
with the option --inet-sockopt.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 include/uapi/linux/inet_diag.h | 18 ++++++++++++++++++
 misc/ss.c                      | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

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
diff --git a/misc/ss.c b/misc/ss.c
index e5565725..52d8a730 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -114,6 +114,7 @@ static int sctp_ino;
 static int show_tipcinfo;
 static int show_tos;
 static int show_cgroup;
+static int show_inet_sockopt;
 int oneline;
 
 enum col_id {
@@ -3333,6 +3334,30 @@ static int inet_show_sock(struct nlmsghdr *nlh,
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
+			out("recverr: %d, ", sockopt->recverr);
+			out("is_icsk: %d, ", sockopt->is_icsk);
+			out("freebind: %d, ", sockopt->freebind);
+			out("hdrincl: %d, ", sockopt->hdrincl);
+			out("mc_loop: %d, ", sockopt->mc_loop);
+			out("transparent: %d, ", sockopt->transparent);
+			out("mc_all: %d, ", sockopt->mc_all);
+			out("nodefrag: %d, ", sockopt->nodefrag);
+			out("bind_addr_no_port: %d, ", sockopt->bind_address_no_port);
+			out("recverr_rfc4884: %d, ", sockopt->recverr_rfc4884);
+			out("defer_connect: %d", sockopt->defer_connect);
+			out(")");
+		}
+	}
+
 	if (show_mem || (show_tcpinfo && s->type != IPPROTO_UDP)) {
 		if (!oneline)
 			out("\n\t");
@@ -5210,6 +5235,7 @@ static void _usage(FILE *dest)
 "   -K, --kill          forcibly close sockets, display what was closed\n"
 "   -H, --no-header     Suppress header line\n"
 "   -O, --oneline       socket's data printed on a single line\n"
+"       --inet-sockopt  show various inet socket options\n"
 "\n"
 "   -A, --query=QUERY, --socket=QUERY\n"
 "       QUERY := {all|inet|tcp|mptcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink|vsock_stream|vsock_dgram|tipc}[,QUERY]\n"
@@ -5299,6 +5325,8 @@ static int scan_state(const char *state)
 
 #define OPT_CGROUP 261
 
+#define OPT_INET_SOCKOPT 262
+
 static const struct option long_opts[] = {
 	{ "numeric", 0, 0, 'n' },
 	{ "resolve", 0, 0, 'r' },
@@ -5341,6 +5369,7 @@ static const struct option long_opts[] = {
 	{ "xdp", 0, 0, OPT_XDPSOCK},
 	{ "mptcp", 0, 0, 'M' },
 	{ "oneline", 0, 0, 'O' },
+	{ "inet-sockopt", 0, 0, OPT_INET_SOCKOPT },
 	{ 0 }
 
 };
@@ -5539,6 +5568,9 @@ int main(int argc, char *argv[])
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

