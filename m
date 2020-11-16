Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850CA2B403B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgKPJsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:48:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728707AbgKPJst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:48:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605520128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DnJ/uwt5Bp38ow2VBTEajAAQvQucJRWYZN6o48o7Q7w=;
        b=TtXcJhxiH4DTFTQnMT0aofZ26RDM02YPYC8N4rHqAtd1gIWroojP5BbYn6bjuzMmb8QhSI
        qPH7PYP/4+fpnbjb9vy1DRMcBwVfpcloQZD5P3VaJKxj6EYLmGMdFC1rshV8MZg64s5O3m
        JN9Lf/Px4T34TUMCAuPQo3OBw+b2UIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-S1yPCtuNNpao2O4Sc1jN_A-1; Mon, 16 Nov 2020 04:48:46 -0500
X-MC-Unique: S1yPCtuNNpao2O4Sc1jN_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E10FB80EFBD;
        Mon, 16 Nov 2020 09:48:44 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9AB11002D41;
        Mon, 16 Nov 2020 09:48:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 10/13] mptcp: try to push pending data on snd una updates
Date:   Mon, 16 Nov 2020 10:48:11 +0100
Message-Id: <4904fdfcf76b73394a731ae7a7e32b2a2407c7b4.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
References: <cover.1605458224.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch we may end-up with unsent data
in the write buffer. If such buffer is full, the writer
will block for unlimited time.

We need to trigger the MPTCP xmit path even for the
subflow rx path, on MPTCP snd_una updates.

Keep things simple and just schedule the work queue if
needed.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9b30c4b39159..821daa922ca3 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -725,6 +725,7 @@ void mptcp_data_acked(struct sock *sk)
 	mptcp_reset_timer(sk);
 
 	if ((!test_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags) ||
+	     mptcp_send_head(sk) ||
 	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)))
 		mptcp_schedule_work(sk);
 }
@@ -1840,6 +1841,8 @@ static void mptcp_worker(struct work_struct *work)
 		__mptcp_close_subflow(msk);
 
 	__mptcp_move_skbs(msk);
+	if (mptcp_send_head(sk))
+		mptcp_push_pending(sk, 0);
 
 	if (msk->pm.status)
 		pm_work(msk);
-- 
2.26.2

