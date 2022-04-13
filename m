Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53704FF485
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiDMKSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbiDMKSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:18:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C99DC4BFC0
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 03:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649844990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uYhtOyCqLPQb8ZNiEUNP5JqgsDoqYOBvlHSfSfuPAWQ=;
        b=bE24tTU46bdOHpSg4mVoDvFAP78th6BXiZv4464UbY5OrlBuxJE1lNinXTvFDv9+kvoHBH
        Wt/b4n/B8hhU6LvUmnaS4fD75i9TaYLEkrrv9icksJzabM2WRD3fb55VzpJSlEUBEhXuZp
        +Su712PirsAkx+XB1uQEbEdCVaU6cZ4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-47rtHhcFPf6Fnr4rk0PFxg-1; Wed, 13 Apr 2022 06:16:27 -0400
X-MC-Unique: 47rtHhcFPf6Fnr4rk0PFxg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C1403820F68;
        Wed, 13 Apr 2022 10:16:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75CBF9D7E;
        Wed, 13 Apr 2022 10:16:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Restore removed timer deletion
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Date:   Wed, 13 Apr 2022 11:16:25 +0100
Message-ID: <164984498582.2000115.4023190177137486137.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent patch[1] from Eric Dumazet flipped the order in which the
keepalive timer and the keepalive worker were cancelled in order to fix a
syzbot reported issue[2].  Unfortunately, this enables the mirror image bug
whereby the timer races with rxrpc_exit_net(), restarting the worker after
it has been cancelled:

	CPU 1		CPU 2
	===============	=====================
			if (rxnet->live)
			<INTERRUPT>
	rxnet->live = false;
 	cancel_work_sync(&rxnet->peer_keepalive_work);
			rxrpc_queue_work(&rxnet->peer_keepalive_work);
	del_timer_sync(&rxnet->peer_keepalive_timer);

Fix this by restoring the removed del_timer_sync() so that we try to remove
the timer twice.  If the timer runs again, it should see ->live == false
and not restart the worker.

Fixes: 1946014ca3b1 ("rxrpc: fix a race in rxrpc_exit_net()")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric Dumazet <edumazet@google.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20220404183439.3537837-1-eric.dumazet@gmail.com/ [1]
Link: https://syzkaller.appspot.com/bug?extid=724378c4bb58f703b09a [2]
---

 net/rxrpc/net_ns.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index f15d6942da45..cc7e30733feb 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -113,7 +113,9 @@ static __net_exit void rxrpc_exit_net(struct net *net)
 	struct rxrpc_net *rxnet = rxrpc_net(net);
 
 	rxnet->live = false;
+	del_timer_sync(&rxnet->peer_keepalive_timer);
 	cancel_work_sync(&rxnet->peer_keepalive_work);
+	/* Remove the timer again as the worker may have restarted it. */
 	del_timer_sync(&rxnet->peer_keepalive_timer);
 	rxrpc_destroy_all_calls(rxnet);
 	rxrpc_destroy_all_connections(rxnet);


