Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5864E5122
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 12:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243839AbiCWLSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 07:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243811AbiCWLSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 07:18:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A69878934
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 04:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648034213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=64vXsH3fzVmHQBxBaDFf3fKZQaMn2NWM0yDzy2WT0eI=;
        b=UDISra8mNFdpPvukEASOBv2orQ+wXxHQm7bgvNG5AUv8IYSGp2yTv8s6m03jkjznrFzQOR
        42OagFLFlw91y0oDqlKy7xlY+kbPHxPUL1diyEkXMIgT2aNA1kuU6QmBHsEdr0BSQ8o9Z3
        lssZhpuqT+qzvEXmr+CmUj9z7oqiCbI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-BqOhvVqsP-WrLb3GVeScjw-1; Wed, 23 Mar 2022 07:16:50 -0400
X-MC-Unique: BqOhvVqsP-WrLb3GVeScjw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 328A91C00B84;
        Wed, 23 Mar 2022 11:16:50 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C0E92024CB6;
        Wed, 23 Mar 2022 11:16:46 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 5FF1C1C02A6; Wed, 23 Mar 2022 12:16:45 +0100 (CET)
From:   Artem Savkov <asavkov@redhat.com>
To:     tglx@linutronix.de, jpoimboe@redhat.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH 2/2] net: make tcp keepalive timer upper bound
Date:   Wed, 23 Mar 2022 12:16:42 +0100
Message-Id: <20220323111642.2517885-3-asavkov@redhat.com>
In-Reply-To: <20220323111642.2517885-1-asavkov@redhat.com>
References: <20220323111642.2517885-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure TCP keepalive timer does not expire late. Switching to upper
bound timers means it can fire off early but in case of keepalive
tcp_keepalive_timer() handler checks elapsed time and resets the timer
if it was triggered early. This results in timer "cascading" to a
higher precision and being just a couple of milliseconds off it's
original mark.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index fc2a985f6064..a8fea958960b 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -564,7 +564,7 @@ void inet_csk_init_xmit_timers(struct sock *sk,
 
 	timer_setup(&icsk->icsk_retransmit_timer, retransmit_handler, 0);
 	timer_setup(&icsk->icsk_delack_timer, delack_handler, 0);
-	timer_setup(&sk->sk_timer, keepalive_handler, 0);
+	timer_setup(&sk->sk_timer, keepalive_handler, TIMER_UPPER_BOUND);
 	icsk->icsk_pending = icsk->icsk_ack.pending = 0;
 }
 EXPORT_SYMBOL(inet_csk_init_xmit_timers);
-- 
2.34.1

