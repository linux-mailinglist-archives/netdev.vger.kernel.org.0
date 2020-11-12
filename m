Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB122B0B86
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgKLRrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 12:47:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbgKLRrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 12:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605203233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UFTuq78chKCNUrfowtXZsmiS7QwnimXACuj/pFt1OA0=;
        b=DYkK3yD0oAap724aZlKVeN2/ZfsMMjMXlVy1uoigDG97hh33mEnaVaH4tryHvT9mkbYzLA
        6i3q+HnzEXJI+6NMiMo//bMoNVYPOcB8t1mKGCypFgTJs4+0Mni5XoyWlcQU5S8+5/kjRf
        s2sI1+lv+LVFC+xGsr0alnA6iITo6jA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-qh5uOKSUPj6W1jwOuKriyQ-1; Thu, 12 Nov 2020 12:47:05 -0500
X-MC-Unique: qh5uOKSUPj6W1jwOuKriyQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 997F2186DD45;
        Thu, 12 Nov 2020 17:47:04 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1455055792;
        Thu, 12 Nov 2020 17:47:01 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 10/13] mptcp: try to push pending data on snd una updates
Date:   Thu, 12 Nov 2020 18:45:30 +0100
Message-Id: <fddd06ca7375d53a9294efa195856a2439fb106c.1605199807.git.pabeni@redhat.com>
In-Reply-To: <cover.1605199807.git.pabeni@redhat.com>
References: <cover.1605199807.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index eae457dc7061..86b4b6e2afbc 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -731,6 +731,7 @@ void mptcp_data_acked(struct sock *sk)
 	mptcp_reset_timer(sk);
 
 	if ((!test_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags) ||
+	     mptcp_send_head(sk) ||
 	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)))
 		mptcp_schedule_work(sk);
 }
@@ -1835,6 +1836,8 @@ static void mptcp_worker(struct work_struct *work)
 		__mptcp_close_subflow(msk);
 
 	__mptcp_move_skbs(msk);
+	if (mptcp_send_head(sk))
+		mptcp_push_pending(sk, 0);
 
 	if (msk->pm.status)
 		pm_work(msk);
-- 
2.26.2

