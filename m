Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0483C188827
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgCQOyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:54:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:23584 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgCQOyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 10:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584456842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l79FaHixoWb/YEr1Un8EfF3fxqL3uRrFsnQzA6pb2vc=;
        b=EEaZu2rciKuVezwz4X5HjY21jCK9ktabJJXmOt6GKRmIbILStv6MrYXgw8bzFftuMZvJIS
        IBj+IWe2ShZ5sb50T5DntzjLZLuogJqxjdMwX4S18/e3xw0GJhnhDhtcMVNhS8moY16aMx
        QANchgavvRVvTo6whGPO51uqmZ86cDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-5dvBq50rPqa9oK0HyjNbng-1; Tue, 17 Mar 2020 10:54:00 -0400
X-MC-Unique: 5dvBq50rPqa9oK0HyjNbng-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 615ACDB5A;
        Tue, 17 Mar 2020 14:53:59 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-23.ams2.redhat.com [10.36.113.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FECF5F700;
        Tue, 17 Mar 2020 14:53:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] mptcp: move msk state update to subflow_syn_recv_sock()
Date:   Tue, 17 Mar 2020 15:53:34 +0100
Message-Id: <ca414f55f4c74190bc419815f6ac7c61313bac2a.1584456734.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 58b09919626b ("mptcp: create msk early"), the
msk socket is already available at subflow_syn_recv_sock()
time. Let's move there the state update, to mirror more
closely the first subflow state.

The above will also help multiple subflow supports.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 9 +++------
 net/mptcp/subflow.c  | 2 ++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 04c3caed92df..e959104832ef 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -861,6 +861,9 @@ struct sock *mptcp_sk_clone(const struct sock *sk, st=
ruct request_sock *req)
 		ack_seq++;
 		msk->ack_seq =3D ack_seq;
 	}
+
+	/* will be fully established after successful MPC subflow creation */
+	inet_sk_state_store(nsk, TCP_SYN_RECV);
 	bh_unlock_sock(nsk);
=20
 	/* keep a single reference */
@@ -916,10 +919,6 @@ static struct sock *mptcp_accept(struct sock *sk, in=
t flags, int *err,
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
=20
-		/* will be fully established at mptcp_stream_accept()
-		 * completion.
-		 */
-		inet_sk_state_store(new_mptcp_sock, TCP_SYN_RECV);
 		bh_unlock_sock(new_mptcp_sock);
 		local_bh_enable();
 	}
@@ -1256,8 +1255,6 @@ static int mptcp_stream_accept(struct socket *sock,=
 struct socket *newsock,
 			if (!ssk->sk_socket)
 				mptcp_sock_graft(ssk, newsock);
 		}
-
-		inet_sk_state_store(newsock->sk, TCP_ESTABLISHED);
 	}
=20
 	sock_put(ssock->sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 8434c7f5f712..052d72a1d3a2 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -234,6 +234,8 @@ static struct sock *subflow_syn_recv_sock(const struc=
t sock *sk,
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */
+			inet_sk_state_store((struct sock *)new_msk,
+					    TCP_ESTABLISHED);
 			ctx->conn =3D new_msk;
 			new_msk =3D NULL;
 		}
--=20
2.21.1

