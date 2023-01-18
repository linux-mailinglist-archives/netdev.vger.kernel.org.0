Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65607671CE8
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjARNFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjARNFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:05:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2329B5CFFE
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 04:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674044686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z7jz2RFdo+6HyUW/ybp1QlhGJEoGiWQ4sVxjWxm/pco=;
        b=FB9xInSmwTGmBnjfH8AGjSQGkWvqsvEpz1yMxgle5kZAPtBciCHgQGu9CqhCe9n75y5FFO
        tZ86ASxDFLJFHZwiDaHAQo8Boy3jnYZfSQiltH92l50mclmfv8kQlF9i0YVu0Z29SjCmV9
        N4iFX2fB4epJzBUP7BEG2zmF0TXV5UM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-J0fJVJdHPBC9XH4M3imS6Q-1; Wed, 18 Jan 2023 07:24:43 -0500
X-MC-Unique: J0fJVJdHPBC9XH4M3imS6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEC803814596;
        Wed, 18 Jan 2023 12:24:42 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9E9640C2064;
        Wed, 18 Jan 2023 12:24:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net] net/ulp: use consistent error code when blocking ULP
Date:   Wed, 18 Jan 2023 13:24:12 +0100
Message-Id: <7bb199e7a93317fb6f8bf8b9b2dc71c18f337cde.1674042685.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The referenced commit changed the error code returned by the kernel
when preventing a non-established socket from attaching the ktls
ULP. Before to such a commit, the user-space got ENOTCONN instead
of EINVAL.

The existing self-tests depend on such error code, and the change
caused a failure:

  RUN           global.non_established ...
 tls.c:1673:non_established:Expected errno (22) == ENOTCONN (107)
 non_established: Test failed at step #3
          FAIL  global.non_established

In the unlikely event existing applications do the same, address
the issue by restoring the prior error code in the above scenario.

Note that the only other ULP performing similar checks at init
time - smc_ulp_ops - also fails with ENOTCONN when trying to attach
the ULP to a non-established socket.

Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Fixes: 2c02d41d71f9 ("net/ulp: prevent ULP without clone op from entering the LISTEN status")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/tcp_ulp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 05b6077b9f2c..2aa442128630 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -139,7 +139,7 @@ static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
 	if (sk->sk_socket)
 		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 
-	err = -EINVAL;
+	err = -ENOTCONN;
 	if (!ulp_ops->clone && sk->sk_state == TCP_LISTEN)
 		goto out_err;
 
-- 
2.39.0

