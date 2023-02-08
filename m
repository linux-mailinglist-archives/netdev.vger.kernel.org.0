Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272B968ECDC
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjBHK31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjBHK2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:28:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64ED4672C
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675852082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AIbGFXSEGrcouEuIniWxwMqD+I+3i7zmAP6fRARvEuo=;
        b=eZ89A7DBEH3V/4ue2J/8UWZfrBsfAX5tAEkVdpTxpUfxim6AHPS8dOwvgGU93kxXFjcVKQ
        fitwXOX7TFKr+njnXy5gTG0KDkJ4Sfxvbh+Vz1+oP5cvEbaJgBrQdEEPuSoaQQIfbFmkJI
        MAT4EuaxJ2aknCOEpRhJ1Qt0p4Ltrj8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-_iwab9PJNXWBQVklYDQKwA-1; Wed, 08 Feb 2023 05:28:01 -0500
X-MC-Unique: _iwab9PJNXWBQVklYDQKwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D773D8030D0;
        Wed,  8 Feb 2023 10:28:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B71542166B2B;
        Wed,  8 Feb 2023 10:27:59 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] rxrpc: Reduce unnecessary ack transmission
Date:   Wed,  8 Feb 2023 10:27:50 +0000
Message-Id: <20230208102750.18107-5-dhowells@redhat.com>
In-Reply-To: <20230208102750.18107-1-dhowells@redhat.com>
References: <20230208102750.18107-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

rxrpc_recvmsg_data() schedules an ACK to be transmitted every time at least
two packets have been consumed and any time it runs out of data and would
return -EAGAIN to the caller.  Both events may occur within a single loop,
however, and if the I/O thread is quick enough it may send duplicate ACKs.

The ACKs are sent to inform the peer that more space has been made in the
local Rx window, but the I/O thread is going to send an ACK every couple of
DATA packets anyway, so we end up sending a lot more ACKs than we really
need to.

So reduce the rate at which recvmsg() schedules ACKs, such that if the I/O
thread sends ACKs at its normal faster rate, recvmsg() won't actually
schedule ACKs until the Rx flow stops (call->rx_consumed is cleared any
time we transmit an ACK for that call, resetting the counter used by
recvmsg).

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 net/rxrpc/recvmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 50d263a6359d..76eb2b9cd936 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -137,7 +137,7 @@ static void rxrpc_rotate_rx_window(struct rxrpc_call *call)
 	/* Check to see if there's an ACK that needs sending. */
 	acked = atomic_add_return(call->rx_consumed - old_consumed,
 				  &call->ackr_nr_consumed);
-	if (acked > 2 &&
+	if (acked > 8 &&
 	    !test_and_set_bit(RXRPC_CALL_RX_IS_IDLE, &call->flags))
 		rxrpc_poke_call(call, rxrpc_call_poke_idle);
 }

