Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81136644DC9
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 22:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLFVKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 16:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiLFVKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 16:10:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAA645EE8
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 13:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670360981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Mg/aljGGcMt80PkX9YRGQwr9D0oTsL3rosvPBvPONg=;
        b=h98siZh8RydOMPIpjB6AhddP53m6QCrEP5Z1CyowhgKLZVWfWwq7BVaNpdUOAxydZUwzvU
        b1sgD3HbP6aCoOyYravTObkUokK/71xykWiQFBmp3jhKEkun8cYh6cb2uD7ArAovVhMVru
        HHM8zXgEqbsW8jNJP4vIutUXL+SRmpk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-g9MP2WCfPemP_Y7cm7HAgA-1; Tue, 06 Dec 2022 16:09:35 -0500
X-MC-Unique: g9MP2WCfPemP_Y7cm7HAgA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74B76185A794;
        Tue,  6 Dec 2022 21:09:34 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15DF42166B26;
        Tue,  6 Dec 2022 21:09:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000229f1505ef2b6159@google.com>
References: <000000000000229f1505ef2b6159@google.com>
To:     syzbot <syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in rxrpc_lookup_local
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1265525.1670360970.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 06 Dec 2022 21:09:30 +0000
Message-ID: <1265526.1670360970@warthog.procyon.org.uk>
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

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next=
.git master

rxrpc: Fix NULL deref in rxrpc_unuse_local()

Fix rxrpc_unuse_local() to get the debug_id *after* checking to see if
local is NULL.

Fixes: a2cf3264f331 ("rxrpc: Fold __rxrpc_unuse_local() into rxrpc_unuse_l=
ocal()")
Reported-by: syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 net/rxrpc/local_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 44222923c0d1..24ee585d9aaf 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -357,10 +357,11 @@ struct rxrpc_local *rxrpc_use_local(struct rxrpc_loc=
al *local,
  */
 void rxrpc_unuse_local(struct rxrpc_local *local, enum rxrpc_local_trace =
why)
 {
-	unsigned int debug_id =3D local->debug_id;
+	unsigned int debug_id;
 	int r, u;
 =

 	if (local) {
+		debug_id =3D local->debug_id;
 		r =3D refcount_read(&local->ref);
 		u =3D atomic_dec_return(&local->active_users);
 		trace_rxrpc_local(debug_id, why, r, u);

