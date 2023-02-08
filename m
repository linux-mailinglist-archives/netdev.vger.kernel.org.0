Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9705468ECD8
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjBHK3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjBHK2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:28:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B2F46716
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675852083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8H/UOjisVXBilIHmQJZBTMReWmL632uxgSQLNraANrg=;
        b=TX894pYjshvu5/A/ea5xPGgQO5EYvKPmVEYPcDcxy/+i3VvtEuVzs4J5CudOhIrqNYyLdp
        Cok9L3uvHMCAkV3l3RzWJLP5atdc273zrrqLHFW8u8/JIxD1RclHLygcKH7ARvDqW+DBxl
        /QImXrQHDxUX5XBtYauW8tav0h975PM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-89VE2ZaEMQWKDxwI5X3Y8Q-1; Wed, 08 Feb 2023 05:27:57 -0500
X-MC-Unique: 89VE2ZaEMQWKDxwI5X3Y8Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D97085A588;
        Wed,  8 Feb 2023 10:27:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D21B2026D4B;
        Wed,  8 Feb 2023 10:27:56 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] rxrpc: Fix overwaking on call poking
Date:   Wed,  8 Feb 2023 10:27:48 +0000
Message-Id: <20230208102750.18107-3-dhowells@redhat.com>
In-Reply-To: <20230208102750.18107-1-dhowells@redhat.com>
References: <20230208102750.18107-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an rxrpc call is given a poke, it will get woken up unconditionally,
even if there's already a poke pending (for which there will have been a
wake) or if the call refcount has gone to 0.

Fix this by only waking the call if it is still referenced and if it
doesn't already have a poke pending.

Fixes: 15f661dc95da ("rxrpc: Implement a mechanism to send an event notification to a call")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 net/rxrpc/call_object.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 6eaffb0d8fdc..e9f1f49d18c2 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -54,12 +54,14 @@ void rxrpc_poke_call(struct rxrpc_call *call, enum rxrpc_call_poke_trace what)
 		spin_lock_bh(&local->lock);
 		busy = !list_empty(&call->attend_link);
 		trace_rxrpc_poke_call(call, busy, what);
+		if (!busy && !rxrpc_try_get_call(call, rxrpc_call_get_poke))
+			busy = true;
 		if (!busy) {
-			rxrpc_get_call(call, rxrpc_call_get_poke);
 			list_add_tail(&call->attend_link, &local->call_attend_q);
 		}
 		spin_unlock_bh(&local->lock);
-		rxrpc_wake_up_io_thread(local);
+		if (!busy)
+			rxrpc_wake_up_io_thread(local);
 	}
 }
 

