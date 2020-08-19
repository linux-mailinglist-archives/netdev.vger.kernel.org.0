Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4794C24A625
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 20:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgHSSqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 14:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHSSqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 14:46:47 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CA2C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 11:46:47 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id c191so16082710qkb.4
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 11:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rCqQmppEJew4i8r4gWOUd7cBcs7dzyNEFoiuJZehTfg=;
        b=Hv9vwZlF8HLU7emgGl5pqYDfe1An+uiCYrldZVCjcRpab2Ls1iq3fPBocEKfYC0w/r
         ys6CpYkU53DxL1rxGWArt9egMIuAuO7jxdaUxvN18Fju1UbRWa7t0ttL3kgF6R5zi18/
         uWaCqb96TxOhnuQlhTWLAqqqP9ey8e+rf8+HV2rTT+II8QRmQocEewVspNH9Abn0NYmX
         4/an2oUJU5bSRZf7ZDEPXACcmXaTyalrQ8lWhPUHB4XRePU3CRhYqh8jRYTTBLLQTx3H
         2iWnpbleGHhGJaKC6T1aquFw5ntslIRkOmf+QPxHdzR9vwFnId/KUfY9BPeGrpammbgs
         TYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rCqQmppEJew4i8r4gWOUd7cBcs7dzyNEFoiuJZehTfg=;
        b=KN0D2QfjhQzX+Q8aplt1zJ2JyiBlZnyR5z5mbT2rLCJskaC9CY/s/2LHXiZxVMCgaK
         MYrcQ6qRtwkOpNXa6iFPjRun921/awYGqTfjtUr/j19HESBtAfJMi0J8+W6XUiULoLvJ
         0Hn5CSRo5K3dd25Utf9wBKMALBWPmPCWE6lgIfU8OntMU6dWJnQOuU6L7wdrWECjloyK
         Ii41/MHC5FbcOGzo2vS8uDKCu72TxImlBBsWAhbr/boha1cHOCoVnel05p6MFjNOQZ5r
         5hjsmbgaaOuJahMqTO2YO9Yh5QKq1kKS6/1She/30CorXNmm/B9+j52tdAv4A7iyWCgw
         ORGw==
X-Gm-Message-State: AOAM533210eNyo04u5dZna4FpfWRzICP1WBshlmyMFwHqeONYyZhzdxJ
        uJHi5hVcRIDunoxliYxix/E8PB2Ppd0dKxRjnr/nxtRn49Bfia7Pdy3fKryYGqUnuyeGDg3YXaA
        xsMWzRbLHzs/L0KLQhFfWd+tzKbmGCyIc/zFGu9xfnG405LeyeP7KxsRkTxZODw==
X-Google-Smtp-Source: ABdhPJwd7wMsvhfIYmxB1hnz53eQXz7IsGYJGWv1uIHRpUkuPaRAA6lTb1cHxjG8KSRkgoiKUwhej+anxAc=
X-Received: by 2002:ad4:51c8:: with SMTP id p8mr24887524qvq.31.1597862805247;
 Wed, 19 Aug 2020 11:46:45 -0700 (PDT)
Date:   Wed, 19 Aug 2020 11:46:35 -0700
Message-Id: <20200819184635.2022232-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH iproute2-next v2] iproute2: ss: add support to expose various
 inet sockopts
From:   Wei Wang <weiwan@google.com>
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Mahesh Bandewar <maheshb@google.com>, Wei Wang <weiwan@google.com>
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

 include/uapi/linux/inet_diag.h | 18 ++++++++++++++
 misc/ss.c                      | 43 ++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

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

