Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8897218C284
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 22:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgCSVqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 17:46:43 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25505 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727102AbgCSVqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 17:46:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584654401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qb8XlgVTtjSbLUpAWpl/SSyVtuJqK+Yx4DWYw4SmJeA=;
        b=P3xnz356PkBdEWZ7mxRrtZssfNSKnenTm5qbLx8F0TDp4zw3fxutU7yWzVRoNeXI5B1LGz
        2xzLWuqq2PJvJog8ICOi8tykRtB2ccDV/o/zSY8lbUrd5R64P03r2KGHVCWPGRZYsBXC4H
        Vc13EA4JvTVjlrmfHKq6C/3bUhTUaDo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-dnb4iA3jNpKqcJq7Dwa7Sg-1; Thu, 19 Mar 2020 17:46:40 -0400
X-MC-Unique: dnb4iA3jNpKqcJq7Dwa7Sg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACDAE100550D;
        Thu, 19 Mar 2020 21:46:38 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42D525D9CA;
        Thu, 19 Mar 2020 21:46:34 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH net-next] net: mptcp: don't hang in mptcp_sendmsg() after TCP fallback
Date:   Thu, 19 Mar 2020 22:45:37 +0100
Message-Id: <9a7cd34e2d8688364297d700bfd8aea60c3a6c7f.1584653622.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it's still possible for packetdrill to hang in mptcp_sendmsg(), when the
MPTCP socket falls back to regular TCP (e.g. after receiving unsupported
flags/version during the three-way handshake). Adjust MPTCP socket state
earlier, to ensure correct functionality of mptcp_sendmsg() even in case
of TCP fallback.

Fixes: 767d3ded5fb8 ("net: mptcp: don't hang before sending 'MP capable w=
ith data'")
Fixes: 1954b86016cf ("mptcp: Check connection state before attempting sen=
d")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/protocol.c | 4 ----
 net/mptcp/subflow.c  | 6 ++++++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e959104832ef..92d5382e71f4 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1055,10 +1055,6 @@ void mptcp_finish_connect(struct sock *ssk)
 	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
 	WRITE_ONCE(msk->ack_seq, ack_seq);
 	WRITE_ONCE(msk->can_ack, 1);
-	if (inet_sk_state_load(sk) !=3D TCP_ESTABLISHED) {
-		inet_sk_state_store(sk, TCP_ESTABLISHED);
-		sk->sk_state_change(sk);
-	}
 }
=20
 static void mptcp_sock_graft(struct sock *sk, struct socket *parent)
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 052d72a1d3a2..06b9075333c5 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -109,9 +109,15 @@ static void subflow_v6_init_req(struct request_sock =
*req,
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff=
 *skb)
 {
 	struct mptcp_subflow_context *subflow =3D mptcp_subflow_ctx(sk);
+	struct sock *parent =3D subflow->conn;
=20
 	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
=20
+	if (inet_sk_state_load(parent) !=3D TCP_ESTABLISHED) {
+		inet_sk_state_store(parent, TCP_ESTABLISHED);
+		parent->sk_state_change(parent);
+	}
+
 	if (!subflow->conn_finished) {
 		pr_debug("subflow=3D%p, remote_key=3D%llu", mptcp_subflow_ctx(sk),
 			 subflow->remote_key);
--=20
2.24.1

