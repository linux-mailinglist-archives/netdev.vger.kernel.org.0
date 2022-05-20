Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34CE52F0C2
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351697AbiETQeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351679AbiETQd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D06BC17DDDE
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653064437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xh8dSPuYVd16pGU1eOSrw4RK/14MRTLIpBGTzg2s4yA=;
        b=C8hneLfVjPQsqMpazwWy0fFyi333INe70Bcd64z38WvFLGBGvpkpUAF5/KdXIVJUKjN7iU
        xjfpuPJF89p6CZ8oHRsmCRkI8S4pH8gzx9ShGZrFECLI9RWGLhbEyqAWqPspyLD07fOzOJ
        4XDHOwm0HUgly2LeZ0n3ALowyitwjjg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-fVkM-cp3MCaa2tfU-oRKuw-1; Fri, 20 May 2022 12:33:51 -0400
X-MC-Unique: fVkM-cp3MCaa2tfU-oRKuw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CFF4101A52C;
        Fri, 20 May 2022 16:33:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 730AC1410DD5;
        Fri, 20 May 2022 16:33:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/6] rxrpc: Enable IPv6 checksums on transport socket
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 17:33:48 +0100
Message-ID: <165306442878.34086.2437731947506679099.stgit@warthog.procyon.org.uk>
In-Reply-To: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
References: <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AF_RXRPC doesn't currently enable IPv6 UDP Tx checksums on the transport
socket it opens and the checksums in the packets it generates end up 0.

It probably should also enable IPv6 UDP Rx checksums and IPv4 UDP
checksums.  The latter only seem to be applied if the socket family is
AF_INET and don't seem to apply if it's AF_INET6.  IPv4 packets from an
IPv6 socket seem to have checksums anyway.

What seems to have happened is that the inet_inv_convert_csum() call didn't
get converted to the appropriate udp_port_cfg parameters - and
udp_sock_create() disables checksums unless explicitly told not too.

Fix this by enabling the three udp_port_cfg checksum options.

Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: Vadim Fedorenko <vfedorenko@novek.ru>
cc: David S. Miller <davem@davemloft.net>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/local_object.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index a4111408ffd0..6a1611b0e303 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -117,6 +117,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 	       local, srx->transport_type, srx->transport.family);
 
 	udp_conf.family = srx->transport.family;
+	udp_conf.use_udp_checksums = true;
 	if (udp_conf.family == AF_INET) {
 		udp_conf.local_ip = srx->transport.sin.sin_addr;
 		udp_conf.local_udp_port = srx->transport.sin.sin_port;
@@ -124,6 +125,8 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 	} else {
 		udp_conf.local_ip6 = srx->transport.sin6.sin6_addr;
 		udp_conf.local_udp_port = srx->transport.sin6.sin6_port;
+		udp_conf.use_udp6_tx_checksums = true;
+		udp_conf.use_udp6_rx_checksums = true;
 #endif
 	}
 	ret = udp_sock_create(net, &udp_conf, &local->socket);


