Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2A35A96BB
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiIAM1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbiIAM1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:27:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAB312854B
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662035210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ktasy/sEA81Y05abLwyFqQvcTxn1i+/4USQhNLHaRD4=;
        b=d++j4zBw9jDLdqr10aQHYosJALLCSe+Wv1JWZmJSGflKz6ce6ODDzag8UlV8OJBF2xnbX5
        EpbDff9kmImk28REDNpaIGZXOy5dYeFMjCajNDFXS8RjnS7VCoK4FPQ78hA1i9cVE9q7CC
        iR9gaS8NDv8qnM6/33RNVqSnF9wd75I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-t7qBHGvcMkOWVS1oSKhZdg-1; Thu, 01 Sep 2022 08:26:47 -0400
X-MC-Unique: t7qBHGvcMkOWVS1oSKhZdg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26A933C10231;
        Thu,  1 Sep 2022 12:26:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B5AC18ECC;
        Thu,  1 Sep 2022 12:26:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net v3 3/6] rxrpc: Fix local destruction being repeated
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Sep 2022 13:26:46 +0100
Message-ID: <166203520602.271364.15674429893825893165.stgit@warthog.procyon.org.uk>
In-Reply-To: <166203518656.271364.567426359603115318.stgit@warthog.procyon.org.uk>
References: <166203518656.271364.567426359603115318.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the local processor work item for the rxrpc local endpoint gets requeued
by an event (such as an incoming packet) between it getting scheduled for
destruction and the UDP socket being closed, the rxrpc_local_destroyer()
function can get run twice.  The second time it can hang because it can end
up waiting for cleanup events that will never happen.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/local_object.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 79bb02eb67b2..38ea98ff426b 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -406,6 +406,9 @@ static void rxrpc_local_processor(struct work_struct *work)
 		container_of(work, struct rxrpc_local, processor);
 	bool again;
 
+	if (local->dead)
+		return;
+
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
 			  refcount_read(&local->ref), NULL);
 


