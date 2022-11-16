Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3509462B4E4
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiKPISo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238652AbiKPISG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:18:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5AFD64
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 00:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668586626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FUxSmniLD14VLHoPL3KFajG/AKabia6aRRvo1/Xox4=;
        b=hQpcj5Xj5bhq8p76i5OCbYNXq7y71gPXjvPmB1cfBfE4+stADiCEUHbjaYwWEArb/OhCpQ
        eai8ODoUXAWBJCFiLX4Grx9n7CxXGs4I0LkJ/hS94qQroOMVJGMVH2nfARmSpoBg8nE0t9
        9Q+FGvFYLGO7tQbyF3FhhH4jo3qmsjQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-D9a8XzmmPfG5YNHHKLdqnA-1; Wed, 16 Nov 2022 03:17:03 -0500
X-MC-Unique: D9a8XzmmPfG5YNHHKLdqnA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6162C3C10ED2;
        Wed, 16 Nov 2022 08:17:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D559C1912A;
        Wed, 16 Nov 2022 08:17:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 3/3] rxrpc: Fix network address validation
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 16 Nov 2022 08:16:57 +0000
Message-ID: <166858661773.2154965.17789493627949980987.stgit@warthog.procyon.org.uk>
In-Reply-To: <166858659236.2154965.18023032361364343888.stgit@warthog.procyon.org.uk>
References: <166858659236.2154965.18023032361364343888.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix network address validation on entry to uapi functions such as connect()
for AF_RXRPC.  The check for address compatibility with the transport
socket isn't correct and allows an AF_INET6 address to be given to an
AF_INET socket, resulting in an oops now that rxrpc is calling
udp_sendmsg() directly.

Sample program:

	#define _GNU_SOURCE
	#include <stdio.h>
	#include <stdlib.h>
	#include <sys/socket.h>
	#include <arpa/inet.h>
	#include <linux/rxrpc.h>
	static unsigned char ctrl[256] =
		"\x18\x00\x00\x00\x00\x00\x00\x00\x10\x01\x00\x00\x01";
	int main(void)
	{
		struct sockaddr_rxrpc srx = {
			.srx_family			= AF_RXRPC,
			.transport_type			= SOCK_DGRAM,
			.transport_len			= 28,
			.transport.sin6.sin6_family	= AF_INET6,
		};
		struct mmsghdr vec = {
			.msg_hdr.msg_control	= ctrl,
			.msg_hdr.msg_controllen	= 0x18,
		};
		int s;
		s = socket(AF_RXRPC, SOCK_DGRAM, AF_INET);
		if (s < 0) {
			perror("socket");
			exit(1);
		}
		if (connect(s, (struct sockaddr *)&srx, sizeof(srx)) < 0) {
			perror("connect");
			exit(1);
		}
		if (sendmmsg(s, &vec, 1, MSG_NOSIGNAL | MSG_MORE) < 0) {
			perror("sendmmsg");
			exit(1);
		}
		return 0;
	}

If working properly, connect() should fail with EAFNOSUPPORT.

Fixes: ed472b0c8783 ("rxrpc: Call udp_sendmsg() directly")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/af_rxrpc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 2f3991cf8715..aacdd96a9886 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -93,12 +93,11 @@ static int rxrpc_validate_address(struct rxrpc_sock *rx,
 	    srx->transport_len > len)
 		return -EINVAL;
 
-	if (srx->transport.family != rx->family &&
-	    srx->transport.family == AF_INET && rx->family != AF_INET6)
-		return -EAFNOSUPPORT;
-
 	switch (srx->transport.family) {
 	case AF_INET:
+		if (rx->family != AF_INET &&
+		    rx->family != AF_INET6)
+			return -EAFNOSUPPORT;
 		if (srx->transport_len < sizeof(struct sockaddr_in))
 			return -EINVAL;
 		tail = offsetof(struct sockaddr_rxrpc, transport.sin.__pad);
@@ -106,6 +105,8 @@ static int rxrpc_validate_address(struct rxrpc_sock *rx,
 
 #ifdef CONFIG_AF_RXRPC_IPV6
 	case AF_INET6:
+		if (rx->family != AF_INET6)
+			return -EAFNOSUPPORT;
 		if (srx->transport_len < sizeof(struct sockaddr_in6))
 			return -EINVAL;
 		tail = offsetof(struct sockaddr_rxrpc, transport) +


