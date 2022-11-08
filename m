Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A967621EFF
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiKHWTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiKHWTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:19:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D373EA5
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKWpeoSLCt9caWg8myCdMi2gVDL57gtO1Zf69kLKx3w=;
        b=eK5HuNuENUzH80HxOY7iE5ysEtkUyExiEjQE1UsX4Y+7bSgBsRzPMpj64gB69FweYk2X9q
        6Gxvg0T/lI0cCY+2bBxA0KuO+sX6GRPeE5bbvRz/bcYAPSERRa70Gsk/hhYhYz2uhVLMVX
        e3QXoV2HlZA5zFQDWgfFS4LNjRZGtDQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-9NxhZp0TNlmRlWKtEIyuQw-1; Tue, 08 Nov 2022 17:18:19 -0500
X-MC-Unique: 9NxhZp0TNlmRlWKtEIyuQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A48B1C0513B;
        Tue,  8 Nov 2022 22:18:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80B3840C2140;
        Tue,  8 Nov 2022 22:18:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 04/26] rxrpc: Track highest acked serial
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:18:17 +0000
Message-ID: <166794589766.2389296.7622069710077746565.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep track of the highest DATA serial number that has been acked by the
peer for future purposes.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h |    1 +
 net/rxrpc/input.c       |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 1ad0ec5afb50..6c93a2fa9628 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -690,6 +690,7 @@ struct rxrpc_call {
 	rxrpc_seq_t		acks_lowest_nak; /* Lowest NACK in the buffer (or ==tx_hard_ack) */
 	rxrpc_seq_t		acks_lost_top;	/* tx_top at the time lost-ack ping sent */
 	rxrpc_serial_t		acks_lost_ping;	/* Serial number of probe ACK */
+	rxrpc_serial_t		acks_highest_serial; /* Highest serial number ACK'd */
 };
 
 /*
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 721d847ba92b..4ba678f0c384 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -967,6 +967,10 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 	call->acks_first_seq = first_soft_ack;
 	call->acks_prev_seq = prev_pkt;
 
+	if (buf.ack.reason != RXRPC_ACK_PING &&
+	    after(acked_serial, call->acks_highest_serial))
+		call->acks_highest_serial = acked_serial;
+
 	/* Parse rwind and mtu sizes if provided. */
 	if (buf.info.rxMTU)
 		rxrpc_input_ackinfo(call, skb, &buf.info);


