Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8FC64DE7F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiLOQWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiLOQWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:22:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2813F1400C
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671121260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2ZE/6DZVRVr0k4g4htmozCItET1RLDFrDhdFke0ZWI=;
        b=O1LVtDjp2yPEf8PWUHyC+GrbWsnYNRuYYR/cfozpmMZ3s7mwl1DlwKVnjm8vqFH+ARF42M
        61eXSEtXxExRW88/lJp64Do/qlkdsUZwoCgVS3FIake5icO6zIUSrvOgDfgHnNccbuR2cn
        yicMU3LxmLMiod8NVl50/Lrz7IKSC0g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-pjGVKDwIM8yjNHLCxGV6bA-1; Thu, 15 Dec 2022 11:20:50 -0500
X-MC-Unique: pjGVKDwIM8yjNHLCxGV6bA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28569100F922;
        Thu, 15 Dec 2022 16:20:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BF242026D76;
        Thu, 15 Dec 2022 16:20:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 8/9] rxrpc: rxperf: Fix uninitialised variable
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Dan Carpenter <error27@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 16:20:46 +0000
Message-ID: <167112124686.152641.6725080919054019135.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Dan Carpenter sayeth[1]:

  The patch 75bfdbf2fca3: "rxrpc: Implement an in-kernel rxperf server
  for testing purposes" from Nov 3, 2022, leads to the following Smatch
  static checker warning:

	net/rxrpc/rxperf.c:337 rxperf_deliver_to_call()
	error: uninitialized symbol 'ret'.

Fix this by initialising ret to 0.  The value is only used for tracing
purposes in the rxperf server.

Fixes: 75bfdbf2fca3 ("rxrpc: Implement an in-kernel rxperf server for testing purposes")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2022-December/006124.html [1]
---

 net/rxrpc/rxperf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 66f5eea291ff..d33a109e846c 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -275,7 +275,7 @@ static void rxperf_deliver_to_call(struct work_struct *work)
 	struct rxperf_call *call = container_of(work, struct rxperf_call, work);
 	enum rxperf_call_state state;
 	u32 abort_code, remote_abort = 0;
-	int ret;
+	int ret = 0;
 
 	if (call->state == RXPERF_CALL_COMPLETE)
 		return;


