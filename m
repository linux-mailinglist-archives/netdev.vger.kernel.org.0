Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB3152F9F0
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 10:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346827AbiEUIDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 04:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346407AbiEUIDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 04:03:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CE785537F
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 01:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653120190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9f3Ov+Z2Vuq0fPwMO6gi/TL300cbGhsqiELARmaeZY=;
        b=ebEPGFc4XF9XDIW9vjvWP37EwC27XQkjDy0LSbnKsKWSYDmulbvCDMeHyvCJlMVlPzb+Er
        MEVk8QF7qNO/9Eq1jjftGxCaVvQlM3yn/v7kxMSLBegDDuMZTYMtDPNJJPg0JFpFEnrjLQ
        2f1cavLbzP899ezpHs4cslis67d8uCY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-9h3NaaCzODmHytXIBz3_0Q-1; Sat, 21 May 2022 04:03:06 -0400
X-MC-Unique: 9h3NaaCzODmHytXIBz3_0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 555A5803B22;
        Sat, 21 May 2022 08:03:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F73C40E6A47;
        Sat, 21 May 2022 08:03:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/5] rxrpc: Fix listen() setting the bar too high for the
 prealloc rings
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Sat, 21 May 2022 09:03:04 +0100
Message-ID: <165312018496.246773.14967839975718988287.stgit@warthog.procyon.org.uk>
In-Reply-To: <165312017819.246773.14440495192028707532.stgit@warthog.procyon.org.uk>
References: <165312017819.246773.14440495192028707532.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AF_RXRPC's listen() handler lets you set the backlog up to 32 (if you bump
up the sysctl), but whilst the preallocation circular buffers have 32 slots
in them, one of them has to be a dead slot because we're using CIRC_CNT().

This means that listen(rxrpc_sock, 32) will cause an oops when the socket
is closed because rxrpc_service_prealloc_one() allocated one too many calls
and rxrpc_discard_prealloc() won't then be able to get rid of them because
it'll think the ring is empty.  rxrpc_release_calls_on_socket() then tries
to abort them, but oopses because call->peer isn't yet set.

Fix this by setting the maximum backlog to RXRPC_BACKLOG_MAX - 1 to match
the ring capacity.

 BUG: kernel NULL pointer dereference, address: 0000000000000086
 ...
 RIP: 0010:rxrpc_send_abort_packet+0x73/0x240 [rxrpc]
 Call Trace:
  <TASK>
  ? __wake_up_common_lock+0x7a/0x90
  ? rxrpc_notify_socket+0x8e/0x140 [rxrpc]
  ? rxrpc_abort_call+0x4c/0x60 [rxrpc]
  rxrpc_release_calls_on_socket+0x107/0x1a0 [rxrpc]
  rxrpc_release+0xc9/0x1c0 [rxrpc]
  __sock_release+0x37/0xa0
  sock_close+0x11/0x20
  __fput+0x89/0x240
  task_work_run+0x59/0x90
  do_exit+0x319/0xaa0

Fixes: 00e907127e6f ("rxrpc: Preallocate peers, conns and calls for incoming service requests")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Link: https://lists.infradead.org/pipermail/linux-afs/2022-March/005079.html
---

 net/rxrpc/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/sysctl.c b/net/rxrpc/sysctl.c
index 540351d6a5f4..555e0910786b 100644
--- a/net/rxrpc/sysctl.c
+++ b/net/rxrpc/sysctl.c
@@ -12,7 +12,7 @@
 
 static struct ctl_table_header *rxrpc_sysctl_reg_table;
 static const unsigned int four = 4;
-static const unsigned int thirtytwo = 32;
+static const unsigned int max_backlog = RXRPC_BACKLOG_MAX - 1;
 static const unsigned int n_65535 = 65535;
 static const unsigned int n_max_acks = RXRPC_RXTX_BUFF_SIZE - 1;
 static const unsigned long one_jiffy = 1;
@@ -89,7 +89,7 @@ static struct ctl_table rxrpc_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (void *)&four,
-		.extra2		= (void *)&thirtytwo,
+		.extra2		= (void *)&max_backlog,
 	},
 	{
 		.procname	= "rx_window_size",


