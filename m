Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D8165BED4
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 12:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbjACLUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 06:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237380AbjACLUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 06:20:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9349F02D
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 03:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672744786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NkddgytNs2/vIILulyjwF6upM+5Y4dsKEYeC8Vg92Tg=;
        b=bodCH1HWHWbdtEmb3czqWfUVVAmgo/grhbza998HCsu0DfLIclrN70qMKNla5ES3mAUt+P
        VSHHhnXmZLYZ2FQNQOol5xl2SIpMuBq54gq+6NajJIW8/TG4BpQUS2OOA2+XGTntxllpPS
        2ebPgd0lvpmtZthgDz2SzYcj3Q3r2+Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-nM9oNBrjM--UE2LR6tPtzQ-1; Tue, 03 Jan 2023 06:19:41 -0500
X-MC-Unique: nM9oNBrjM--UE2LR6tPtzQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E624C101A521;
        Tue,  3 Jan 2023 11:19:40 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C3E12026D4B;
        Tue,  3 Jan 2023 11:19:38 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        slipper <slipper.alive@gmail.com>
Subject: [PATCH net] net/ulp: prevent ULP without clone op from entering the LISTEN status
Date:   Tue,  3 Jan 2023 12:19:17 +0100
Message-Id: <4b80c3d1dbe3d0ab072f80450c202d9bc88b4b03.1672740602.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an ULP-enabled socket enters the LISTEN status, the listener ULP data
pointer is copied inside the child/accepted sockets by sk_clone_lock().

The relevant ULP can take care of de-duplicating the context pointer via
the clone() operation, but only MPTCP and SMC implement such op.

Other ULPs may end-up with a double-free at socket disposal time.

We can't simply clear the ULP data at clone time, as TLS replaces the
socket ops with custom ones assuming a valid TLS ULP context is
available.

Instead completely prevent clone-less ULP sockets from entering the
LISTEN status.

Fixes: 734942cc4ea6 ("tcp: ULP infrastructure")
Reported-by: slipper <slipper.alive@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/inet_connection_sock.c | 14 ++++++++++++++
 net/ipv4/tcp_ulp.c              |  4 ++++
 2 files changed, 18 insertions(+)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 848ffc3e0239..d1f837579398 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1200,12 +1200,26 @@ void inet_csk_prepare_forced_close(struct sock *sk)
 }
 EXPORT_SYMBOL(inet_csk_prepare_forced_close);
 
+static int inet_ulp_can_listen(const struct sock *sk)
+{
+	const struct inet_connection_sock *icsk = inet_csk(sk);
+
+	if (icsk->icsk_ulp_ops && !icsk->icsk_ulp_ops->clone)
+		return -EINVAL;
+
+	return 0;
+}
+
 int inet_csk_listen_start(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_sock *inet = inet_sk(sk);
 	int err;
 
+	err = inet_ulp_can_listen(sk);
+	if (unlikely(err))
+		return err;
+
 	reqsk_queue_alloc(&icsk->icsk_accept_queue);
 
 	sk->sk_ack_backlog = 0;
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 9ae50b1bd844..05b6077b9f2c 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -139,6 +139,10 @@ static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
 	if (sk->sk_socket)
 		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 
+	err = -EINVAL;
+	if (!ulp_ops->clone && sk->sk_state == TCP_LISTEN)
+		goto out_err;
+
 	err = ulp_ops->init(sk);
 	if (err)
 		goto out_err;
-- 
2.38.1

