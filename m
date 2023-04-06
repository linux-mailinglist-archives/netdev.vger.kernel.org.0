Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0089F6D92A0
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbjDFJ0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbjDFJ0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:26:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17FF35FEC;
        Thu,  6 Apr 2023 02:26:12 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net,v2] uapi: linux: restore IPPROTO_MAX to 256 and add IPPROTO_UAPI_MAX
Date:   Thu,  6 Apr 2023 11:25:58 +0200
Message-Id: <20230406092558.459491-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPPROTO_MAX used to be 256, but with the introduction of IPPROTO_MPTCP
definition, IPPROTO_MAX was bumped to 263.

IPPROTO_MPTCP definition is used for the socket interface from
userspace (ie. uAPI). It is never used in the layer 4 protocol field of
IP headers.

IPPROTO_* definitions are used anywhere in the kernel as well as in
userspace to set the layer 4 protocol field in IP headers as well as
for uAPI.

At least in Netfilter, there is code in userspace that relies on
IPPROTO_MAX (not inclusive) to check for the maximum layer 4 protocol.

This patch restores IPPROTO_MAX to 256 for the maximum protocol number
in the IP headers, and it adds a new IPPROTO_UAPI_MAX for the maximum
protocol number for uAPI.

Update kernel code to use IPPROTO_UAPI_MAX for inet_diag (mptcp
registers one for this) and the inet{4,6}_create() IP socket API.

Fixes: faf391c3826c ("tcp: Define IPPROTO_MPTCP")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Add IPPROTO_UAPI_MAX so mptcp socket API does not break.

 include/uapi/linux/in.h | 3 ++-
 net/ipv4/af_inet.c      | 2 +-
 net/ipv4/inet_diag.c    | 8 ++++----
 net/ipv6/af_inet6.c     | 2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 4b7f2df66b99..58ca09438bf0 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -80,10 +80,11 @@ enum {
   IPPROTO_ETHERNET = 143,	/* Ethernet-within-IPv6 Encapsulation	*/
 #define IPPROTO_ETHERNET	IPPROTO_ETHERNET
   IPPROTO_RAW = 255,		/* Raw IP packets			*/
+  IPPROTO_MAX,
 #define IPPROTO_RAW		IPPROTO_RAW
   IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
 #define IPPROTO_MPTCP		IPPROTO_MPTCP
-  IPPROTO_MAX
+  IPPROTO_UAPI_MAX
 };
 #endif
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8db6747f892f..4a9061da8983 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -252,7 +252,7 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
 	int try_loading_module = 0;
 	int err;
 
-	if (protocol < 0 || protocol >= IPPROTO_MAX)
+	if (protocol < 0 || protocol >= IPPROTO_UAPI_MAX)
 		return -EINVAL;
 
 	sock->state = SS_UNCONNECTED;
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index b812eb36f0e3..0723bef44827 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -52,7 +52,7 @@ static DEFINE_MUTEX(inet_diag_table_mutex);
 
 static const struct inet_diag_handler *inet_diag_lock_handler(int proto)
 {
-	if (proto < 0 || proto >= IPPROTO_MAX) {
+	if (proto < 0 || proto >= IPPROTO_UAPI_MAX) {
 		mutex_lock(&inet_diag_table_mutex);
 		return ERR_PTR(-ENOENT);
 	}
@@ -1413,7 +1413,7 @@ int inet_diag_register(const struct inet_diag_handler *h)
 	const __u16 type = h->idiag_type;
 	int err = -EINVAL;
 
-	if (type >= IPPROTO_MAX)
+	if (type >= IPPROTO_UAPI_MAX)
 		goto out;
 
 	mutex_lock(&inet_diag_table_mutex);
@@ -1432,7 +1432,7 @@ void inet_diag_unregister(const struct inet_diag_handler *h)
 {
 	const __u16 type = h->idiag_type;
 
-	if (type >= IPPROTO_MAX)
+	if (type >= IPPROTO_UAPI_MAX)
 		return;
 
 	mutex_lock(&inet_diag_table_mutex);
@@ -1443,7 +1443,7 @@ EXPORT_SYMBOL_GPL(inet_diag_unregister);
 
 static int __init inet_diag_init(void)
 {
-	const int inet_diag_table_size = (IPPROTO_MAX *
+	const int inet_diag_table_size = (IPPROTO_UAPI_MAX *
 					  sizeof(struct inet_diag_handler *));
 	int err = -ENOMEM;
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 38689bedfce7..64d5c803f070 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -128,7 +128,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	int try_loading_module = 0;
 	int err;
 
-	if (protocol < 0 || protocol >= IPPROTO_MAX)
+	if (protocol < 0 || protocol >= IPPROTO_UAPI_MAX)
 		return -EINVAL;
 
 	/* Look for the requested type/protocol pair. */
-- 
2.30.2

