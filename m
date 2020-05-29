Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5361E8257
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgE2PoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:44:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40189 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727999AbgE2PoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:44:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590767053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EJzoQCGf3gj3i2w4aCrFG+qmTAW4YNGEnvSifCYpi9A=;
        b=JlN2OsWV9BbtyQ3ti89dv+4SH52JuBfkqGUg9P624RGi7K0dqS/Co1jLXuUAjyMpgu5iFJ
        UqbHTKst8L3ae5YpUEFgHv0mCk4pV8nNycd2XUzri/6QZ1llfVJewQeJBIVLuBn2eofcJN
        edMZoaQ39Bn6EDy+KxvhNGwMVXG7Bpo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-RYRNEa_SOIS3pfRMCVgb2w-1; Fri, 29 May 2020 11:44:08 -0400
X-MC-Unique: RYRNEa_SOIS3pfRMCVgb2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BD5C835B40;
        Fri, 29 May 2020 15:44:07 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-94.ams2.redhat.com [10.36.114.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 071117A8C0;
        Fri, 29 May 2020 15:44:05 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/3] mptcp: fix race between MP_JOIN and close
Date:   Fri, 29 May 2020 17:43:30 +0200
Message-Id: <bfd9f8f6fc4d6eb84012d8e04c48d974ed7080ea.1590766645.git.pabeni@redhat.com>
In-Reply-To: <cover.1590766645.git.pabeni@redhat.com>
References: <cover.1590766645.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a MP_JOIN subflow completes the 3whs while another
CPU is closing the master msk, we can hit the
following race:

CPU1                                    CPU2

close()
 mptcp_close
                                        subflow_syn_recv_sock
                                         mptcp_token_get_sock
                                         mptcp_finish_join
                                          inet_sk_state_load
  mptcp_token_destroy
  inet_sk_state_store(TCP_CLOSE)
  __mptcp_flush_join_list()
                                          mptcp_sock_graft
                                          list_add_tail
  sk_common_release
   sock_orphan()
 <socket free>

The MP_JOIN socket will be leaked. Additionally we can hit
UaF for the msk 'struct socket' referenced via the 'conn'
field.

This change try to address the issue introducing some
synchronization between the MP_JOIN 3whs and mptcp_close
via the join_list spinlock. If we detect the msk is closing
the MP_JOIN socket is closed, too.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8959a74f707d..35bdfb4f3eae 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1266,8 +1266,12 @@ static void mptcp_close(struct sock *sk, long timeout)
 	mptcp_token_destroy(msk->token);
 	inet_sk_state_store(sk, TCP_CLOSE);
 
-	__mptcp_flush_join_list(msk);
-
+	/* be sure to always acquire the join list lock, to sync vs
+	 * mptcp_finish_join().
+	 */
+	spin_lock_bh(&msk->join_list_lock);
+	list_splice_tail_init(&msk->join_list, &msk->conn_list);
+	spin_unlock_bh(&msk->join_list_lock);
 	list_splice_init(&msk->conn_list, &conn_list);
 
 	data_fin_tx_seq = msk->write_seq;
@@ -1623,22 +1627,30 @@ bool mptcp_finish_join(struct sock *sk)
 	if (!msk->pm.server_side)
 		return true;
 
-	/* passive connection, attach to msk socket */
+	if (!mptcp_pm_allow_new_subflow(msk))
+		return false;
+
+	/* active connections are already on conn_list, and we can't acquire
+	 * msk lock here.
+	 * use the join list lock as synchronization point and double-check
+	 * msk status to avoid racing with mptcp_close()
+	 */
+	spin_lock_bh(&msk->join_list_lock);
+	ret = inet_sk_state_load(parent) == TCP_ESTABLISHED;
+	if (ret && !WARN_ON_ONCE(!list_empty(&subflow->node)))
+		list_add_tail(&subflow->node, &msk->join_list);
+	spin_unlock_bh(&msk->join_list_lock);
+	if (!ret)
+		return false;
+
+	/* attach to msk socket only after we are sure he will deal with us
+	 * at close time
+	 */
 	parent_sock = READ_ONCE(parent->sk_socket);
 	if (parent_sock && !sk->sk_socket)
 		mptcp_sock_graft(sk, parent_sock);
-
-	ret = mptcp_pm_allow_new_subflow(msk);
-	if (ret) {
-		subflow->map_seq = msk->ack_seq;
-
-		/* active connections are already on conn_list */
-		spin_lock_bh(&msk->join_list_lock);
-		if (!WARN_ON_ONCE(!list_empty(&subflow->node)))
-			list_add_tail(&subflow->node, &msk->join_list);
-		spin_unlock_bh(&msk->join_list_lock);
-	}
-	return ret;
+	subflow->map_seq = msk->ack_seq;
+	return true;
 }
 
 bool mptcp_sk_is_subflow(const struct sock *sk)
-- 
2.21.3

