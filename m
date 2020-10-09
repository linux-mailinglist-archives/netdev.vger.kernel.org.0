Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648CA288F72
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390044AbgJIRB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:01:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389948AbgJIRBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602262897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kzGS4+nBaXR0lYkwhE+hvW/seRwTUC/kGURZZ0kHdDI=;
        b=SY7omxujSLPqZ2pb7I73UB7cRD5HRS3/7dR+ueJk6oknHPEeDGY+b1Ca3tYuSwXT1iKPzl
        8lx7G8cz/Si7U7X2i/c6c4k3ZUGkbD7l3McvQRLIrAk3f5yzrLvpfEV9iE1rVR/1v0iqUB
        W5pBHj1tnV2pmhpa0AuPBUDRLcT37GI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-10wY0ipPNEaqwY4hMszPRg-1; Fri, 09 Oct 2020 13:01:35 -0400
X-MC-Unique: 10wY0ipPNEaqwY4hMszPRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F12CB192CC4C;
        Fri,  9 Oct 2020 17:01:18 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-111.ams2.redhat.com [10.36.114.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B40AA7664F;
        Fri,  9 Oct 2020 17:01:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 2/2] mptcp: subflows garbage collection
Date:   Fri,  9 Oct 2020 19:00:01 +0200
Message-Id: <bb9a445351f06c85ae2dd2e84c9b3b8f262def98.1602262630.git.pabeni@redhat.com>
In-Reply-To: <cover.1602262630.git.pabeni@redhat.com>
References: <cover.1602262630.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The msk can close MP_JOIN subflows if the initial handshake
fails. Currently such subflows are kept alive in the
conn_list until the msk itself is closed.

Beyond the wasted memory, we could end-up sending the
DATA_FIN and the DATA_FIN ack on such socket, even after a
reset.

Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 17 +++++++++++++++++
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  |  6 ++++++
 3 files changed, 24 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5d747c6a610e..b295eb6e9580 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1383,6 +1383,20 @@ static void pm_work(struct mptcp_sock *msk)
 	spin_unlock_bh(&msk->pm.lock);
 }
 
+static void __mptcp_close_subflow(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow, *tmp;
+
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		if (inet_sk_state_load(ssk) != TCP_CLOSE)
+			continue;
+
+		__mptcp_close_ssk((struct sock *)msk, ssk, subflow, 0);
+	}
+}
+
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
@@ -1400,6 +1414,9 @@ static void mptcp_worker(struct work_struct *work)
 	mptcp_clean_una(sk);
 	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
+	if (test_and_clear_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags))
+		__mptcp_close_subflow(msk);
+
 	__mptcp_move_skbs(msk);
 
 	if (msk->pm.status)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 0a6e5b3f6ae8..0c4b8cc64dbc 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -90,6 +90,7 @@
 #define MPTCP_WORK_RTX		2
 #define MPTCP_WORK_EOF		3
 #define MPTCP_FALLBACK_DONE	4
+#define MPTCP_WORK_CLOSE_SUBFLOW 5
 
 struct mptcp_options_received {
 	u64	sndr_key;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index b1b8028730bf..80f67cb56631 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -272,9 +272,15 @@ static bool subflow_thmac_valid(struct mptcp_subflow_context *subflow)
 
 void mptcp_subflow_reset(struct sock *ssk)
 {
+	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
+	struct sock *sk = subflow->conn;
+
 	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
+	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
+	    schedule_work(&mptcp_sk(sk)->work))
+		sock_hold(sk);
 }
 
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
-- 
2.26.2

