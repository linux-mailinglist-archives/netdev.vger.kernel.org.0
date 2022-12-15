Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A433C64DE75
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiLOQVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiLOQVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:21:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6218B33C15
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671121228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zoj83DN64Ehz4LavQQ0Tm2bmeHjk0PoDaKJLK2+UpVE=;
        b=QxEg1mNt6MM5wy9czid/OqR1m7BpVK6QD09/H37jxEJIVxY/7FSkhRg+GQRHI04kiXlqxm
        kL0/F31tce7QRA14/xFovwUiviaSWke7gIDIUbvdoXkf8ybwq0fCsrlc3n8jKSGGjRTjfd
        RBq/wPJPQI7HQMMpCgij5HnzNQsvO8Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-V9UT019RMKirgO4WV_JlNA-1; Thu, 15 Dec 2022 11:20:08 -0500
X-MC-Unique: V9UT019RMKirgO4WV_JlNA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBD2D3C10234;
        Thu, 15 Dec 2022 16:20:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B6B214171C0;
        Thu, 15 Dec 2022 16:20:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 3/9] rxrpc: Fix NULL deref in rxrpc_unuse_local()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com,
        syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 16:20:04 +0000
Message-ID: <167112120461.152641.4382655800014753084.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix rxrpc_unuse_local() to get the debug_id *after* checking to see if
local is NULL.

Fixes: a2cf3264f331 ("rxrpc: Fold __rxrpc_unuse_local() into rxrpc_unuse_local()")
Reported-by: syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/local_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 44222923c0d1..24ee585d9aaf 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -357,10 +357,11 @@ struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local,
  */
 void rxrpc_unuse_local(struct rxrpc_local *local, enum rxrpc_local_trace why)
 {
-	unsigned int debug_id = local->debug_id;
+	unsigned int debug_id;
 	int r, u;
 
 	if (local) {
+		debug_id = local->debug_id;
 		r = refcount_read(&local->ref);
 		u = atomic_dec_return(&local->active_users);
 		trace_rxrpc_local(debug_id, why, r, u);


