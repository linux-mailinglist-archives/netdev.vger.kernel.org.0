Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510D252F0FC
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351879AbiETQqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351874AbiETQqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:46:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6B7833E85
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653065191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZT+Pp/rgwJQvb+XnEfZU3tY8Kab2QsTGc7eFhS0bwE=;
        b=Tgs/b0TQ3gIW87sB5hJuHseUJ6Gw1pxiCVg1DVqCK3mMWPgfZeVJOi2oU4Egdip/q0ooM8
        xdW23/AKWw3s/PNzaWnixH6jVeuykyZQ4Jp2j+/EI1096u3Thy+kfvYR2h21fiA2COJm4J
        N+uV3X1x+Y4OP0TMiz4N0lkSQ1xUz9A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-6GmGvhkiNH2n5WbVsv4q-w-1; Fri, 20 May 2022 12:46:28 -0400
X-MC-Unique: 6GmGvhkiNH2n5WbVsv4q-w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54289800B21;
        Fri, 20 May 2022 16:46:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7FAB2026D6A;
        Fri, 20 May 2022 16:46:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 5/7] rxrpc: Return an error to sendmsg if call failed
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 20 May 2022 17:46:27 +0100
Message-ID: <165306518708.34989.16913481087340338132.stgit@warthog.procyon.org.uk>
In-Reply-To: <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk>
References: <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If at the end of rxrpc sendmsg() or rxrpc_kernel_send_data() the call that
was being given data was aborted remotely or otherwise failed, return an
error rather than returning the amount of data buffered for transmission.

The call (presumably) did not complete, so there's not much point
continuing with it.  AF_RXRPC considers it "complete" and so will be
unwilling to do anything else with it - and won't send a notification for
it, deeming the return from sendmsg sufficient.

Not returning an error causes afs to incorrectly handle a StoreData
operation that gets interrupted by a change of address due to NAT
reconfiguration.

This doesn't normally affect most operations since their request parameters
tend to fit into a single UDP packet and afs_make_call() returns before the
server responds; StoreData is different as it involves transmission of a
lot of data.

This can be triggered on a client by doing something like:

	dd if=/dev/zero of=/afs/example.com/foo bs=1M count=512

at one prompt, and then changing the network address at another prompt,
e.g.:

	ifconfig enp6s0 inet 192.168.6.2 && route add 192.168.6.1 dev enp6s0

Tracing packets on an Auristor fileserver looks something like:

192.168.6.1 -> 192.168.6.3  RX 107 ACK Idle  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
192.168.6.3 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(64538) (64538)
192.168.6.3 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(64538) (64538)
192.168.6.1 -> 192.168.6.3  RX 107 ACK Idle  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
<ARP exchange for 192.168.6.2>
192.168.6.2 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(0) (0)
192.168.6.2 -> 192.168.6.1  AFS (RX) 1482 FS Request: Unknown(0) (0)
192.168.6.1 -> 192.168.6.2  RX 107 ACK Exceeds Window  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
192.168.6.1 -> 192.168.6.2  RX 74 ABORT  Seq: 0  Call: 4  Source Port: 7000  Destination Port: 7001
192.168.6.1 -> 192.168.6.2  RX 74 ABORT  Seq: 29321  Call: 4  Source Port: 7000  Destination Port: 7001

The Auristor fileserver logs code -453 (RXGEN_SS_UNMARSHAL), but the abort
code received by kafs is -5 (RX_PROTOCOL_ERROR) as the rx layer sees the
condition and generates an abort first and the unmarshal error is a
consequence of that at the application layer.

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2021-December/004810.html # v1
---

 net/rxrpc/sendmsg.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index af8ad6c30b9f..1d38e279e2ef 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -444,6 +444,12 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 success:
 	ret = copied;
+	if (READ_ONCE(call->state) == RXRPC_CALL_COMPLETE) {
+		read_lock_bh(&call->state_lock);
+		if (call->error < 0)
+			ret = call->error;
+		read_unlock_bh(&call->state_lock);
+	}
 out:
 	call->tx_pending = skb;
 	_leave(" = %d", ret);


