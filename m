Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6DD1B0E43
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgDTOZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:25:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22070 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728371AbgDTOZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:25:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587392753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VG3UnYDWS56mPr1FEozJ2ptXoPK5XjpgyvQFRmK7VZA=;
        b=Y7Dlm2bo3ftrq3wzsOAiDADgwI9/tVWNm3VW7Ll0yu8CAIlWNJWY9cYriqmocvFb2hjEQn
        VJT8/yOJbByLfqYMlWXbcBADAezYeW0HDZZeECj1Z09xPw4m2ApACmpq8qCH95HBrZcWTs
        GY0arsF7YzPB79Ka6dhUnGZ5Oc/N9ro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-k1CeYkUEOGCWFjYV84zhTg-1; Mon, 20 Apr 2020 10:25:51 -0400
X-MC-Unique: k1CeYkUEOGCWFjYV84zhTg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BAF66B478;
        Mon, 20 Apr 2020 14:25:37 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-142.ams2.redhat.com [10.36.114.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3853A289AE;
        Mon, 20 Apr 2020 14:25:34 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 1/3] mptcp: handle mptcp listener destruction via rcu
Date:   Mon, 20 Apr 2020 16:25:04 +0200
Message-Id: <3acf989202f0bf82d974611d0fda7052de8d6ec3.1587389294.git.pabeni@redhat.com>
In-Reply-To: <cover.1587389294.git.pabeni@redhat.com>
References: <cover.1587389294.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Following splat can occur during self test:

 BUG: KASAN: use-after-free in subflow_data_ready+0x156/0x160
 Read of size 8 at addr ffff888100c35c28 by task mptcp_connect/4808

  subflow_data_ready+0x156/0x160
  tcp_child_process+0x6a3/0xb30
  tcp_v4_rcv+0x2231/0x3730
  ip_protocol_deliver_rcu+0x5c/0x860
  ip_local_deliver_finish+0x220/0x360
  ip_local_deliver+0x1c8/0x4e0
  ip_rcv_finish+0x1da/0x2f0
  ip_rcv+0xd0/0x3c0
  __netif_receive_skb_one_core+0xf5/0x160
  __netif_receive_skb+0x27/0x1c0
  process_backlog+0x21e/0x780
  net_rx_action+0x35f/0xe90
  do_softirq+0x4c/0x50
  [..]

This occurs when accessing subflow_ctx->conn.

Problem is that tcp_child_process() calls listen sockets'
sk_data_ready() notification, but it doesn't hold the listener
lock.  Another cpu calling close() on the listener will then cause
transition of refcount to 0.

Fixes: 58b09919626bf ("mptcp: create msk early")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b2d2193453bc..d275c1e827fe 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1391,6 +1391,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk, =
struct request_sock *req)
 		msk->ack_seq =3D ack_seq;
 	}
=20
+	sock_reset_flag(nsk, SOCK_RCU_FREE);
 	/* will be fully established after successful MPC subflow creation */
 	inet_sk_state_store(nsk, TCP_SYN_RECV);
 	bh_unlock_sock(nsk);
@@ -1792,6 +1793,8 @@ static int mptcp_listen(struct socket *sock, int ba=
cklog)
 		goto unlock;
 	}
=20
+	sock_set_flag(sock->sk, SOCK_RCU_FREE);
+
 	err =3D ssock->ops->listen(ssock, backlog);
 	inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
 	if (!err)
--=20
2.21.1

