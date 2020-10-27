Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277A329C037
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1817033AbgJ0RM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 13:12:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1785149AbgJ0O7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 10:59:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603810784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DmouFhWdVOl7EXhsYHcY5059mglYicevex/ysXBRMkw=;
        b=KGIoMdqfRjpM322OJVPt+H5BeZy28quxKMdQGaNccOxJEfk9RivMbAtRai6INqx3iVVswj
        WIEH5St4jMbemxuFH0K45oX9upj6uKVxs5QIvNjQ3syZoEhr3Eo8KR8iwZ7CMmqdFQWmyF
        MrMRZ/c/kcpIJ/MaZ0rBxkqtW044SJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-D0Ahy2h5Mq-ov21Ih-zN6A-1; Tue, 27 Oct 2020 10:59:42 -0400
X-MC-Unique: D0Ahy2h5Mq-ov21Ih-zN6A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0797010A0BAF;
        Tue, 27 Oct 2020 14:59:29 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-61.ams2.redhat.com [10.36.114.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F15155577D;
        Tue, 27 Oct 2020 14:59:27 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: add missing memory scheduling in the rx path
Date:   Tue, 27 Oct 2020 15:59:14 +0100
Message-Id: <f6143a6193a083574f11b00dbf7b5ad151bc4ff4.1603810630.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When moving the skbs from the subflow into the msk receive
queue, we must schedule there the required amount of memory.

Try to borrow the required memory from the subflow, if needed,
so that we leverage the existing TCP heuristic.

Fixes: 6771bfd9ee24 ("mptcp: update mptcp ack sequence from work queue")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 185dacb39781..e7419fd15d84 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -274,6 +274,15 @@ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 	skb_ext_reset(skb);
 	skb_orphan(skb);
 
+	/* try to fetch required memory from subflow */
+	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
+		if (ssk->sk_forward_alloc < skb->truesize)
+			goto drop;
+		__sk_mem_reclaim(ssk, skb->truesize);
+		if (!sk_rmem_schedule(sk, skb, skb->truesize))
+			goto drop;
+	}
+
 	/* the skb map_seq accounts for the skb offset:
 	 * mptcp_subflow_get_mapped_dsn() is based on the current tp->copied_seq
 	 * value
@@ -301,6 +310,7 @@ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 	 * will retransmit as needed, if needed.
 	 */
 	MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_DUPDATA);
+drop:
 	mptcp_drop(sk, skb);
 	return false;
 }
-- 
2.26.2

