Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30152FCF01
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389121AbhATLQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:16:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387749AbhATKm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:42:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611139281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5AnNqYhd4KFsBvi/PyepAne0Mx/FqErybM6LGHv8Wng=;
        b=crcegfN/at/N9yL0Vh5wZfs2lqq1K2I121WIx7s4n/nJnPfHrAMg87Z91Ui0yYm2pIjguv
        C0FAUlx4VppPlGbIE12CxQU7snxeILcTS5tPhDO55zLAzgxhPo6P58H1XpOJaSmuwLuwYE
        02Qtjpt+UuxqwNTSUjXww3wR+5AqBtQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-EEqqxeTcNPy-dX6dLciNTA-1; Wed, 20 Jan 2021 05:41:19 -0500
X-MC-Unique: EEqqxeTcNPy-dX6dLciNTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C37C8066E9;
        Wed, 20 Jan 2021 10:41:18 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-164.ams2.redhat.com [10.36.115.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 456B660C6A;
        Wed, 20 Jan 2021 10:41:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next 4/5] mptcp: schedule work for better snd subflow selection
Date:   Wed, 20 Jan 2021 11:40:39 +0100
Message-Id: <e7f46d333c945ad75cf18d6cef9c7ffaf02f9f2c.1610991949.git.pabeni@redhat.com>
In-Reply-To: <cover.1610991949.git.pabeni@redhat.com>
References: <cover.1610991949.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise the packet scheduler policy will not be
enforced when pushing pending data at MPTCP-level
ack reception time.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e741201acc98f..8cb582eee2862 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2242,6 +2242,7 @@ static void mptcp_worker(struct work_struct *work)
 	if (unlikely(state == TCP_CLOSE))
 		goto unlock;
 
+	mptcp_push_pending(sk, 0);
 	mptcp_check_data_fin_ack(sk);
 	__mptcp_flush_join_list(msk);
 
@@ -2899,10 +2900,14 @@ void __mptcp_check_push(struct sock *sk, struct sock *ssk)
 	if (!mptcp_send_head(sk))
 		return;
 
-	if (!sock_owned_by_user(sk))
-		__mptcp_subflow_push_pending(sk, ssk);
-	else
+	if (!sock_owned_by_user(sk)) {
+		if (mptcp_subflow_get_send(mptcp_sk(sk)) == ssk)
+			__mptcp_subflow_push_pending(sk, ssk);
+		else
+			mptcp_schedule_work(sk);
+	} else {
 		set_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags);
+	}
 }
 
 #define MPTCP_DEFERRED_ALL (TCPF_WRITE_TIMER_DEFERRED)
-- 
2.26.2

