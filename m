Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134BB4F7836
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbiDGHy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242296AbiDGHyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:54:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F381E1C404B
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649317974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qQwtpv4LSJs4oYZkfG+yHqo4mCAyzu9Mqm5FcRavI60=;
        b=OQZ+GXUBZWUXvircGf9m0koalw3o9ZDYMWmfAkK7/km6mBhbRSTHpZJSfGPtZq+XbOo2vo
        4RuWAFzzfW1xXahc17B5/gCOfeljtIsejqK3bfRaUM6DD2/I8eonqDBT77c/sIMVieUM0I
        SxZZ4RCobaO4rXA73OVqyHy8wGjvHCQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-rDqrMzroPZCOxoo4cQkGGw-1; Thu, 07 Apr 2022 03:52:49 -0400
X-MC-Unique: rDqrMzroPZCOxoo4cQkGGw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08864802819;
        Thu,  7 Apr 2022 07:52:48 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25F4940D2962;
        Thu,  7 Apr 2022 07:52:45 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id E84AC1C00CD; Thu,  7 Apr 2022 09:52:43 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v4 2/2] net: make tcp keepalive timer upper bound
Date:   Thu,  7 Apr 2022 09:52:42 +0200
Message-Id: <20220407075242.118253-3-asavkov@redhat.com>
In-Reply-To: <20220407075242.118253-1-asavkov@redhat.com>
References: <871qyb35q4.ffs@tglx>
 <20220407075242.118253-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
index 1e5b53c2bb267..bb2dbfb6f5b50 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -589,7 +589,7 @@ EXPORT_SYMBOL(inet_csk_delete_keepalive_timer);
 
 void inet_csk_reset_keepalive_timer(struct sock *sk, unsigned long len)
 {
-	sk_reset_timer(sk, &sk->sk_timer, jiffies + len);
+	sk_reset_timer(sk, &sk->sk_timer, jiffies + upper_bound_timeout(len));
 }
 EXPORT_SYMBOL(inet_csk_reset_keepalive_timer);
 
-- 
2.34.1

