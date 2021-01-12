Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863B12F34ED
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392510AbhALQAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:00:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392447AbhALQAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:00:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610467160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RaGBKJaRxbpqH/rWxG6TwS7YqZeKFqoXKDauHdmaBc0=;
        b=f8TOSr/IbzBCZIrR58tpJo1ysbaExxpuq6O7MtCE2YHm56ayuymRwMefEkNdQqr+zVCOXM
        tfpcON9njCyhUffvkXEaM6mHoDDCnLndR+cfLA4cw671XueHKOTwieWp9pQ4pBL3JjONE/
        rpvJM6Y8z+k6CFCutIb9trrpEC4rz50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-OoP4vModPr-V1J7geuVelA-1; Tue, 12 Jan 2021 10:59:18 -0500
X-MC-Unique: OoP4vModPr-V1J7geuVelA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DEB618C8C00;
        Tue, 12 Jan 2021 15:59:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AC7218B42;
        Tue, 12 Jan 2021 15:59:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Call state should be read with READ_ONCE() under
 some circumstances
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Baptiste Lepers <baptiste.lepers@gmail.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com
Date:   Tue, 12 Jan 2021 15:59:15 +0000
Message-ID: <161046715522.2450566.488819910256264150.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baptiste Lepers <baptiste.lepers@gmail.com>

The call state may be changed at any time by the data-ready routine in
response to received packets, so if the call state is to be read and acted
upon several times in a function, READ_ONCE() must be used unless the call
state lock is held.

As it happens, we used READ_ONCE() to read the state a few lines above the
unmarked read in rxrpc_input_data(), so use that value rather than
re-reading it.

Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 667c44aa5a63..dc201363f2c4 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -430,7 +430,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		return;
 	}
 
-	if (call->state == RXRPC_CALL_SERVER_RECV_REQUEST) {
+	if (state == RXRPC_CALL_SERVER_RECV_REQUEST) {
 		unsigned long timo = READ_ONCE(call->next_req_timo);
 		unsigned long now, expect_req_by;
 


