Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4841F5225
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 12:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgFJKT4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Jun 2020 06:19:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49183 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727884AbgFJKTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 06:19:54 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-xhpYqixdPVStKHmZwwW8iw-1; Wed, 10 Jun 2020 06:19:49 -0400
X-MC-Unique: xhpYqixdPVStKHmZwwW8iw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 177BE835B42;
        Wed, 10 Jun 2020 10:19:48 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.193.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E90C5D9D3;
        Wed, 10 Jun 2020 10:19:46 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: [PATCH bpf] bpf: tcp: recv() should return 0 when the peer socket is closed
Date:   Wed, 10 Jun 2020 12:19:43 +0200
Message-Id: <26038a28c21fea5d04d4bd4744c5686d3f2e5504.1591784177.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the peer is closed, we will never get more data, so
tcp_bpf_wait_data will get stuck forever. In case we passed
MSG_DONTWAIT to recv(), we get EAGAIN but we should actually get
0.

From man 2 recv:

    RETURN VALUE

    When a stream socket peer has performed an orderly shutdown, the
    return value will be 0 (the traditional "end-of-file" return).

This patch makes tcp_bpf_wait_data always return 1 when the peer
socket has been shutdown. Either we have data available, and it would
have returned 1 anyway, or there isn't, in which case we'll call
tcp_recvmsg which does the right thing in this situation.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv4/tcp_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 2b915aafda42..7aa68f4aae6c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -245,6 +245,9 @@ static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int ret = 0;
 
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		return 1;
+
 	if (!timeo)
 		return ret;
 
-- 
2.27.0

