Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB90A683388
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjAaROd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjAaROE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:14:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F7C4EE7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWmNysdKy5XBLJKg1ZgGP/kmHqIJ71ALVgjTNQkhEyA=;
        b=U6HP3oxh9lM5iXWYTpQhMgp0WXcXCycmOGq9DRQvwPvdIVEH3/+DMmD7Yr9VW2hLRP7hqK
        uxkqtH5TmKVpiNaCtJOq4A3pTLah6BxD4uf9qTBVjm+POGT38f6aTvJbbbuI5dFi07bNZO
        8Q735X/rTwacjE8pMq4GsvWkclxovRQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-VxkkmzVWMheOSBd-0_2EiQ-1; Tue, 31 Jan 2023 12:12:54 -0500
X-MC-Unique: VxkkmzVWMheOSBd-0_2EiQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 723443C1068D;
        Tue, 31 Jan 2023 17:12:53 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57159140EBF4;
        Tue, 31 Jan 2023 17:12:52 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 12/13] rxrpc: Change rx_packet tracepoint to display securityIndex not type twice
Date:   Tue, 31 Jan 2023 17:12:26 +0000
Message-Id: <20230131171227.3912130-13-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the rx_packet tracepoint to display the securityIndex from the
packet header instead of displaying the type in numeric form.  There's no
need for the latter, as the display of the type in symbolic form will fall
back automatically to displaying the hex value if no symbol is available.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 include/trace/events/rxrpc.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index b6adec9111e1..d7bb4acf4580 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -752,9 +752,8 @@ TRACE_EVENT(rxrpc_rx_packet,
 		      __entry->hdr.epoch, __entry->hdr.cid,
 		      __entry->hdr.callNumber, __entry->hdr.serviceId,
 		      __entry->hdr.serial, __entry->hdr.seq,
-		      __entry->hdr.type, __entry->hdr.flags,
-		      __entry->hdr.type <= 15 ?
-		      __print_symbolic(__entry->hdr.type, rxrpc_pkts) : "?UNK")
+		      __entry->hdr.securityIndex, __entry->hdr.flags,
+		      __print_symbolic(__entry->hdr.type, rxrpc_pkts))
 	    );
 
 TRACE_EVENT(rxrpc_rx_done,

