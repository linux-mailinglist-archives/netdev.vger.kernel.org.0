Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5346448BB
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiLFQHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiLFQGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:06:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDE0BC03
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ZZUM4hRQWwL0ArwwcTJwT8ehiB7UX/Wr5YZI17NOK0=;
        b=A8NNfPyK2uc0EX9OLNxYdCLkz0EtKNNhYxaFlCJrExQ2Va7kUFpSSXiA/Vby6qmKTFoAI8
        bI/+UWnnHwlqU8W29gPODDtJPCfVRbM/nVQrurDSTF/U7/Uzpg0+fDDwbM2E3XGLGFMlzf
        VnrlgTYrftwAbgIXM7OJuMIMQZfA7fQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-E27LNqXzNgyhSyr0AYHCrw-1; Tue, 06 Dec 2022 11:02:27 -0500
X-MC-Unique: E27LNqXzNgyhSyr0AYHCrw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EF083C01DFB;
        Tue,  6 Dec 2022 16:02:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C820B2166B26;
        Tue,  6 Dec 2022 16:02:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 27/32] rxrpc: Make the local endpoint hold a ref on a
 connected call
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Dec 2022 16:02:25 +0000
Message-ID: <167034254511.1105287.9817497591703679657.stgit@warthog.procyon.org.uk>
In-Reply-To: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
References: <167034231605.1105287.1693064952174322878.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the local endpoint and it's I/O thread hold a reference on a connected
call until that call is disconnected.  Without this, we're reliant on
either the AF_RXRPC socket to hold a ref (which is dropped when the call is
released) or a queued work item to hold a ref (the work item is being
replaced with the I/O thread).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    2 ++
 net/rxrpc/conn_client.c      |    4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 4d5eb08025c0..81182efca327 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -257,6 +257,7 @@
 	E_(rxrpc_client_to_idle,		"->Idle")
 
 #define rxrpc_call_traces \
+	EM(rxrpc_call_get_io_thread,		"GET iothread") \
 	EM(rxrpc_call_get_input,		"GET input   ") \
 	EM(rxrpc_call_get_kernel_service,	"GET krnl-srv") \
 	EM(rxrpc_call_get_notify_socket,	"GET notify  ") \
@@ -269,6 +270,7 @@
 	EM(rxrpc_call_new_prealloc_service,	"NEW prealloc") \
 	EM(rxrpc_call_put_discard_prealloc,	"PUT disc-pre") \
 	EM(rxrpc_call_put_discard_error,	"PUT disc-err") \
+	EM(rxrpc_call_put_io_thread,		"PUT iothread") \
 	EM(rxrpc_call_put_input,		"PUT input   ") \
 	EM(rxrpc_call_put_kernel,		"PUT kernel  ") \
 	EM(rxrpc_call_put_poke,			"PUT poke    ") \
diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 8e3e0ffa4417..26b0ad38f91b 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -718,8 +718,11 @@ int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
 
 	rxrpc_discard_expired_client_conns(&rxnet->client_conn_reaper);
 
+	rxrpc_get_call(call, rxrpc_call_get_io_thread);
+
 	bundle = rxrpc_prep_call(call, gfp);
 	if (IS_ERR(bundle)) {
+		rxrpc_put_call(call, rxrpc_call_get_io_thread);
 		ret = PTR_ERR(bundle);
 		goto out;
 	}
@@ -902,6 +905,7 @@ void rxrpc_disconnect_client_call(struct rxrpc_bundle *bundle, struct rxrpc_call
 
 out:
 	spin_unlock(&bundle->channel_lock);
+	rxrpc_put_call(call, rxrpc_call_put_io_thread);
 	_leave("");
 	return;
 }


