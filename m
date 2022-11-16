Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DCF62B4E2
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiKPISg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiKPISE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:18:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE6FBD8
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 00:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668586629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UjChVR3JL0IE4M+ycBoVPEnLs7suZyUWAlBSRhFsres=;
        b=NduNC0yAiB7Ts3flqp/Al/UGUzkTj4XDLdYhdyfLR5u3GqsGfrueHzY36cW33ZcwGFe401
        VCJH+Gr/d62skQrxcaYNGfIuzLJydy4mj2P327U4L2lyOYOwGnA1nIG/hRRf+7nxIGVdmH
        zsurVp93zfBlmBVGsSbhDXXz36dcCkQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-D4sxpjaUPC-sqN_MCLADiw-1; Wed, 16 Nov 2022 03:16:52 -0500
X-MC-Unique: D4sxpjaUPC-sqN_MCLADiw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 911C9101A528;
        Wed, 16 Nov 2022 08:16:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1088140C2086;
        Wed, 16 Nov 2022 08:16:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 2/3] rxrpc: Fix oops from calling udpv6_sendmsg() on
 AF_INET socket
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 16 Nov 2022 08:16:49 +0000
Message-ID: <166858660930.2154965.8554587152080422824.stgit@warthog.procyon.org.uk>
In-Reply-To: <166858659236.2154965.18023032361364343888.stgit@warthog.procyon.org.uk>
References: <166858659236.2154965.18023032361364343888.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If rxrpc sees an IPv6 address, it assumes it can call udpv6_sendmsg() on it
- even if it got it on an IPv4 socket.  Fix do_udp_sendmsg() to give an
error in such a case.

general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
...
RIP: 0010:ipv6_addr_v4mapped include/net/ipv6.h:749 [inline]
RIP: 0010:udpv6_sendmsg+0xd0a/0x2c70 net/ipv6/udp.c:1361
...
Call Trace:
do_udp_sendmsg net/rxrpc/output.c:27 [inline]
do_udp_sendmsg net/rxrpc/output.c:21 [inline]
rxrpc_send_abort_packet+0x73b/0x860 net/rxrpc/output.c:367
rxrpc_release_calls_on_socket+0x211/0x300 net/rxrpc/call_object.c:595
rxrpc_release_sock net/rxrpc/af_rxrpc.c:886 [inline]
rxrpc_release+0x263/0x5a0 net/rxrpc/af_rxrpc.c:917
__sock_release+0xcd/0x280 net/socket.c:650
sock_close+0x18/0x20 net/socket.c:1365
__fput+0x27c/0xa90 fs/file_table.c:320
task_work_run+0x16b/0x270 kernel/task_work.c:179
exit_task_work include/linux/task_work.h:38 [inline]
do_exit+0xb35/0x2a20 kernel/exit.c:820
do_group_exit+0xd0/0x2a0 kernel/exit.c:950
__do_sys_exit_group kernel/exit.c:961 [inline]
__se_sys_exit_group kernel/exit.c:959 [inline]
__x64_sys_exit_group+0x3a/0x50 kernel/exit.c:959

Fixes: ed472b0c8783 ("rxrpc: Call udp_sendmsg() directly")
Reported-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/output.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 46432e70a16b..a2fe1a262f8a 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -18,15 +18,21 @@
 
 extern int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
 
-static ssize_t do_udp_sendmsg(struct socket *sk, struct msghdr *msg, size_t len)
+static ssize_t do_udp_sendmsg(struct socket *socket, struct msghdr *msg, size_t len)
 {
-#if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
 	struct sockaddr *sa = msg->msg_name;
+	struct sock *sk = socket->sk;
 
-	if (sa->sa_family == AF_INET6)
-		return udpv6_sendmsg(sk->sk, msg, len);
-#endif
-	return udp_sendmsg(sk->sk, msg, len);
+	if (IS_ENABLED(CONFIG_AF_RXRPC_IPV6)) {
+		if (sa->sa_family == AF_INET6) {
+			if (sk->sk_family != AF_INET6) {
+				pr_warn("AF_INET6 address on AF_INET socket\n");
+				return -ENOPROTOOPT;
+			}
+			return udpv6_sendmsg(sk, msg, len);
+		}
+	}
+	return udp_sendmsg(sk, msg, len);
 }
 
 struct rxrpc_abort_buffer {


