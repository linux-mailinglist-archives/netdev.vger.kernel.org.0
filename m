Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7F9C94FF
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbfJBXh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:16479 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729221AbfJBXhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862640"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:24 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 43/45] selftests: mptcp: add accept/getpeer checks
Date:   Wed,  2 Oct 2019 16:36:53 -0700
Message-Id: <20191002233655.24323-44-mathew.j.martineau@linux.intel.com>
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

Check that the result coming from accept matches that of getpeername.
For initiator side, check getpeername matches address passed to connect().

At this time, kernel returns the address of the first subflow in the list.
Right now, we do not yet implement fate-sharing, i.e. if the original
subflow goes away, the result of getpeername would change.

There are different ways to fix that.  One would be to copy the quadruple
from the first subflow socket to the mptcp socket.

If we do that, this test should catch a possible bug (such as accidental
reversal of saddr/daddr).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 107 ++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 32a1630b7fa3..8df2b1b24695 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -49,6 +49,21 @@ static const char *getxinfo_strerr(int err)
 	return gai_strerror(err);
 }
 
+static void xgetnameinfo(const struct sockaddr *addr, socklen_t addrlen,
+			 char *host, socklen_t hostlen,
+			 char *serv, socklen_t servlen)
+{
+	int flags = NI_NUMERICHOST | NI_NUMERICSERV;
+	int err = getnameinfo(addr, addrlen, host, hostlen, serv, servlen, flags);
+
+	if (err) {
+		const char *errstr = getxinfo_strerr(err);
+
+		fprintf(stderr, "Fatal: getnameinfo: %s\n", errstr);
+		exit(1);
+	}
+}
+
 static void xgetaddrinfo(const char *node, const char *service,
 			 const struct addrinfo *hints,
 			 struct addrinfo **res)
@@ -285,6 +300,94 @@ static int copyfd_io(int infd, int peerfd, int outfd)
 	return 0;
 }
 
+static void check_sockaddr(int pf, struct sockaddr_storage *ss,
+			   socklen_t salen)
+{
+	char addr[INET6_ADDRSTRLEN];
+	char serv[INET6_ADDRSTRLEN];
+	struct sockaddr_in6 *sin6;
+	struct sockaddr_in *sin;
+	int wanted_size = 0;
+
+	switch (pf) {
+	case AF_INET:
+		wanted_size = sizeof(*sin);
+		sin = (void *)ss;
+		if (!sin->sin_port)
+			fprintf(stderr, "accept: something wrong: ip connection from port 0");
+		break;
+	case AF_INET6:
+		wanted_size = sizeof(*sin6);
+		sin6 = (void *)ss;
+		if (!sin6->sin6_port)
+			fprintf(stderr, "accept: something wrong: ipv6 connection from port 0");
+		break;
+	default:
+		fprintf(stderr, "accept: Unknown pf %d, salen %u\n", pf, salen);
+		return;
+	}
+
+	if (salen != wanted_size)
+		fprintf(stderr, "accept: size mismatch, got %d expected %d\n",
+				(int)salen, wanted_size);
+
+	if (ss->ss_family != pf)
+		fprintf(stderr, "accept: pf mismatch, expect %d, ss_family is %d\n",
+				(int)ss->ss_family, pf);
+}
+
+static void check_getpeername(int fd, struct sockaddr_storage *ss, socklen_t salen)
+{
+	struct sockaddr_storage peerss;
+	socklen_t peersalen = sizeof(peerss);
+
+	if (getpeername(fd, (struct sockaddr *)&peerss, &peersalen)) {
+		perror("getpeername");
+		return;
+	}
+
+	if (peersalen != salen) {
+		fprintf(stderr, "%s: %d vs %d\n", __func__, peersalen, salen);
+		return;
+	}
+
+	if (memcmp(ss, &peerss, peersalen)) {
+		char a[INET6_ADDRSTRLEN];
+		char b[INET6_ADDRSTRLEN];
+		char c[INET6_ADDRSTRLEN];
+		char d[INET6_ADDRSTRLEN];
+
+		xgetnameinfo((struct sockaddr *)ss, salen,
+			     a, sizeof(a), b, sizeof(b));
+
+		xgetnameinfo((struct sockaddr *)&peerss, peersalen,
+			     c, sizeof(c), d, sizeof(d));
+
+		fprintf(stderr, "%s: memcmp failure: accept %s vs peername %s, %s vs %s salen %d vs %d\n",
+			__func__, a, c, b, d, peersalen, salen);
+	}
+}
+
+static void check_getpeername_connect(int fd)
+{
+	struct sockaddr_storage ss;
+	socklen_t salen = sizeof(ss);
+	char a[INET6_ADDRSTRLEN];
+	char b[INET6_ADDRSTRLEN];
+
+	if (!getpeername(fd, (struct sockaddr *)&ss, &salen)) {
+		perror("getpeername");
+		return;
+	}
+
+	xgetnameinfo((struct sockaddr *)&ss, salen,
+		     a, sizeof(a), b, sizeof(b));
+
+	if (strcmp(cfg_host, a) || strcmp(cfg_port, b))
+		fprintf(stderr, "%s: %s vs %s, %s vs %s\n", __func__,
+			cfg_host, a, cfg_port, b);
+}
+
 int main_loop_s(int listensock)
 {
 	struct sockaddr_storage ss;
@@ -308,6 +411,9 @@ int main_loop_s(int listensock)
 	salen = sizeof(ss);
 	remotesock = accept(listensock, (struct sockaddr *)&ss, &salen);
 	if (remotesock >= 0) {
+		check_sockaddr(pf, &ss, salen);
+		check_getpeername(remotesock, &ss, salen);
+
 		copyfd_io(0, remotesock, 1);
 		return 0;
 	}
@@ -342,6 +448,7 @@ int main_loop(void)
 	if (fd < 0)
 		return 2;
 
+	check_getpeername_connect(fd);
 	return copyfd_io(0, fd, 1);
 }
 
-- 
2.23.0

