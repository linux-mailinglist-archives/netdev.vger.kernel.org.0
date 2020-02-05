Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB82153C04
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 00:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgBEXjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 18:39:54 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42358 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727149AbgBEXjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 18:39:54 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1izUGs-0005bp-AZ; Thu, 06 Feb 2020 00:39:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net] mptcp: fix use-after-free for ipv6
Date:   Thu,  6 Feb 2020 00:39:37 +0100
Message-Id: <20200205233937.30596-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turns out that when we accept a new subflow, the newly created
inet_sk(tcp_sk)->pinet6 points at the ipv6_pinfo structure of the
listener socket.

This wasn't caught by the selftest because it closes the accepted fd
before the listening one.

adding a close(listenfd) after accept returns is enough:
 BUG: KASAN: use-after-free in inet6_getname+0x6ba/0x790
 Read of size 1 at addr ffff88810e310866 by task mptcp_connect/2518
 Call Trace:
  inet6_getname+0x6ba/0x790
  __sys_getpeername+0x10b/0x250
  __x64_sys_getpeername+0x6f/0xb0

also alter test program to exercise this.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c                          | 36 +++++++++++++++++--
 .../selftests/net/mptcp/mptcp_connect.c       |  9 +++++
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 353f2d16b986..73780b4cb108 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -24,6 +24,13 @@
 
 #define MPTCP_SAME_STATE TCP_MAX_STATES
 
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+struct mptcp6_sock {
+	struct mptcp_sock msk;
+	struct ipv6_pinfo np;
+};
+#endif
+
 /* If msk has an initial subflow socket, and the MP_CAPABLE handshake has not
  * completed yet or has failed, return the subflow socket.
  * Otherwise return NULL.
@@ -627,6 +634,30 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 	inet_sk(msk)->inet_rcv_saddr = inet_sk(ssk)->inet_rcv_saddr;
 }
 
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static struct ipv6_pinfo *mptcp_inet6_sk(const struct sock *sk)
+{
+	unsigned int offset = sizeof(struct mptcp6_sock) - sizeof(struct ipv6_pinfo);
+
+	return (struct ipv6_pinfo *)(((u8 *)sk) + offset);
+}
+#endif
+
+struct sock *mptcp_sk_clone_lock(const struct sock *sk)
+{
+	struct sock *nsk = sk_clone_lock(sk, GFP_ATOMIC);
+
+	if (!nsk)
+		return NULL;
+
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	if (nsk->sk_family == AF_INET6)
+		inet_sk(nsk)->pinet6 = mptcp_inet6_sk(nsk);
+#endif
+
+	return nsk;
+}
+
 static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 				 bool kern)
 {
@@ -657,7 +688,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		lock_sock(sk);
 
 		local_bh_disable();
-		new_mptcp_sock = sk_clone_lock(sk, GFP_ATOMIC);
+		new_mptcp_sock = mptcp_sk_clone_lock(sk);
 		if (!new_mptcp_sock) {
 			*err = -ENOBUFS;
 			local_bh_enable();
@@ -1206,8 +1237,7 @@ int mptcp_proto_v6_init(void)
 	strcpy(mptcp_v6_prot.name, "MPTCPv6");
 	mptcp_v6_prot.slab = NULL;
 	mptcp_v6_prot.destroy = mptcp_v6_destroy;
-	mptcp_v6_prot.obj_size = sizeof(struct mptcp_sock) +
-				 sizeof(struct ipv6_pinfo);
+	mptcp_v6_prot.obj_size = sizeof(struct mptcp6_sock);
 
 	err = proto_register(&mptcp_v6_prot, 1);
 	if (err)
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index a3dccd816ae4..99579c0223c1 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -634,6 +634,14 @@ static void check_getpeername_connect(int fd)
 			cfg_host, a, cfg_port, b);
 }
 
+static void maybe_close(int fd)
+{
+	unsigned int r = rand();
+
+	if (r & 1)
+		close(fd);
+}
+
 int main_loop_s(int listensock)
 {
 	struct sockaddr_storage ss;
@@ -657,6 +665,7 @@ int main_loop_s(int listensock)
 	salen = sizeof(ss);
 	remotesock = accept(listensock, (struct sockaddr *)&ss, &salen);
 	if (remotesock >= 0) {
+		maybe_close(listensock);
 		check_sockaddr(pf, &ss, salen);
 		check_getpeername(remotesock, &ss, salen);
 
-- 
2.24.1

