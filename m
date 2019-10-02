Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D955C94FB
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbfJBXhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:16479 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729207AbfJBXhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862639"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:24 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 42/45] selftests: mptcp: extend mptcp_connect tool for ipv6 family
Date:   Wed,  2 Oct 2019 16:36:52 -0700
Message-Id: <20191002233655.24323-43-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

At this time socket() will fail when requesting an ipv6 mptcp socket.
This is ok for now, as the test script won't request ipv6 tests yet.

Tested with a tcp <-> tcp connection.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testing/selftests/net/mptcp/mptcp_connect.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index cac71f0ac8f8..32a1630b7fa3 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -32,11 +32,11 @@ static int  poll_timeout;
 static const char *cfg_host;
 static const char *cfg_port	= "12000";
 static int cfg_sock_proto	= IPPROTO_MPTCP;
-
+static int pf = AF_INET;
 
 static void die_usage(void)
 {
-	fprintf(stderr, "Usage: mptcp_connect [-s MPTCP|TCP] [-p port] "
+	fprintf(stderr, "Usage: mptcp_connect [ -6 ] [-s MPTCP|TCP] [-p port] "
 		"[ -l ] [ -t timeout ] connect_address\n");
 	exit(1);
 }
@@ -74,12 +74,13 @@ static int sock_listen_mptcp(const char * const listenaddr,
 		.ai_flags = AI_PASSIVE | AI_NUMERICHOST
 	};
 
-	hints.ai_family = AF_INET;
+	hints.ai_family = pf;
 
 	struct addrinfo *a, *addr;
 	int one = 1;
 
 	xgetaddrinfo(listenaddr, port, &hints, &addr);
+	hints.ai_family = pf;
 
 	for (a = addr; a; a = a->ai_next) {
 		sock = socket(a->ai_family, a->ai_socktype, cfg_sock_proto);
@@ -124,7 +125,7 @@ static int sock_connect_mptcp(const char * const remoteaddr,
 	struct addrinfo *a, *addr;
 	int sock = -1;
 
-	hints.ai_family = AF_INET;
+	hints.ai_family = pf;
 
 	xgetaddrinfo(remoteaddr, port, &hints, &addr);
 	for (a = addr; a; a = a->ai_next) {
@@ -362,7 +363,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "lp:s:ht:")) != -1) {
+	while ((c = getopt(argc, argv, "6lp:s:ht:")) != -1) {
 		switch (c) {
 		case 'l':
 			listen_mode = true;
@@ -376,6 +377,9 @@ static void parse_opts(int argc, char **argv)
 		case 'h':
 			die_usage();
 			break;
+		case '6':
+			pf = AF_INET6;
+			break;
 		case 't':
 			poll_timeout = atoi(optarg) * 1000;
 			if (poll_timeout <= 0)
@@ -387,6 +391,9 @@ static void parse_opts(int argc, char **argv)
 	if (optind + 1 != argc)
 		die_usage();
 	cfg_host = argv[optind];
+
+	if (strchr(cfg_host, ':'))
+		pf = AF_INET6;
 }
 
 int main(int argc, char *argv[])
-- 
2.23.0

