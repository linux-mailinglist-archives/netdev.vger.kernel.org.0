Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADBB4EBCA2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 10:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244278AbiC3IXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 04:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244264AbiC3IW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 04:22:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 047BB30F79
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648628471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qQwtpv4LSJs4oYZkfG+yHqo4mCAyzu9Mqm5FcRavI60=;
        b=EobXktrW0+gkWzx8tiaOBo7h9Vugaosu9pBImxeEgKAHo3ifFWXYJs0b/mhdt8E19tT/WG
        dASw+oRJDkOnT/i2Ij0fuI94mLraD55uQLHnqU20WDIOn1nR0g2l2x3nqrFFYD6Ne7N/UL
        j/h1n+u/Zw2UpvhDyciHjmu+ElM7Oak=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-qz63oN9hMCCk3vbMmhF4qQ-1; Wed, 30 Mar 2022 04:21:07 -0400
X-MC-Unique: qz63oN9hMCCk3vbMmhF4qQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CE40100BAB1;
        Wed, 30 Mar 2022 08:20:56 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD8612166B3F;
        Wed, 30 Mar 2022 08:20:49 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id B64E21C021C; Wed, 30 Mar 2022 10:20:46 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        asavkov@redhat.com, Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        dsahern@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] net: make tcp keepalive timer upper bound
Date:   Wed, 30 Mar 2022 10:20:46 +0200
Message-Id: <20220330082046.3512424-3-asavkov@redhat.com>
In-Reply-To: <20220330082046.3512424-1-asavkov@redhat.com>
References: <87zglcfmcv.ffs@tglx>
 <20220330082046.3512424-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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

