Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6564B51C06A
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377195AbiEENV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbiEENV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:21:56 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09C612D1F5
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 06:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651756696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZYBN09igH8LtCAZWzaFJ4ayRRE7BNTVPZW2OM3YADI=;
        b=N3EFql2UWSuUO0yWrbgfQ7Ve9XbpFjg8ysgD5mZxuokOndUrMMzcBJYY1nqrBmIF4jXbqn
        SbeaKiTpeRjX5/km8enlxk9AKGBV7s+or3/vmjeJ8FSCh5J98lyVFPugZwp9HRoz3/pVkn
        kzpN84WfTwGEfAOHI8P/8j2EErfCPo8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-Vc_JEwU5P8Oa5jz7d530gA-1; Thu, 05 May 2022 09:18:15 -0400
X-MC-Unique: Vc_JEwU5P8Oa5jz7d530gA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5355C185A79C;
        Thu,  5 May 2022 13:18:14 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 159057AE3;
        Thu,  5 May 2022 13:18:14 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 105471C0242; Thu,  5 May 2022 15:18:13 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v5 2/2] net: make tcp keepalive timer upper bound
Date:   Thu,  5 May 2022 15:18:11 +0200
Message-Id: <20220505131811.3744503-3-asavkov@redhat.com>
In-Reply-To: <20220505131811.3744503-1-asavkov@redhat.com>
References: <87zgkwjtq2.ffs@tglx>
 <20220505131811.3744503-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
This adds minimal overhead as keepalive timers are never re-armed and
are usually quite long.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1e5b53c2bb26..bb2dbfb6f5b5 100644
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

