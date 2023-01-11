Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE4C665775
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjAKJaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238450AbjAKJ14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:27:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1917EB842
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673429183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fu3+2gqiFfpnQkaPLzaH9RXxIbJi3CW3mSFCWwgyxMM=;
        b=PJaPLO+2YasW+VGJQ12mQWC5cvhvkdD9xlWJKB/0mHIv68eAbVBT43spJkFH8++wVdK1A3
        ZLl5elgeTzWQ2lsH387LG6m7IaC0BIbw4c93WXRtGInqdRkXPIZG8nj0lNquGZjPyl3h3W
        EoV5CiTYQWJmO9oxUX7eEmpkRNS4ynE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-WQZIGurGM3SxT2Y4--osVQ-1; Wed, 11 Jan 2023 04:26:20 -0500
X-MC-Unique: WQZIGurGM3SxT2Y4--osVQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BF7680234E;
        Wed, 11 Jan 2023 09:26:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF4F943FB8;
        Wed, 11 Jan 2023 09:26:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <00000000000024d6fc05f1d9b858@google.com>
References: <00000000000024d6fc05f1d9b858@google.com>
To:     syzbot <syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] kernel BUG in rxrpc_put_call
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2263419.1673429178.1@warthog.procyon.org.uk>
Date:   Wed, 11 Jan 2023 09:26:18 +0000
Message-ID: <2263420.1673429178@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 3ded5a24627c..f3c9f0201c15 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -294,7 +294,7 @@ static void rxrpc_put_call_slot(struct rxrpc_call *call)
 static int rxrpc_connect_call(struct rxrpc_call *call, gfp_t gfp)
 {
 	struct rxrpc_local *local = call->local;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	_enter("{%d,%lx},", call->debug_id, call->user_call_ID);
 

