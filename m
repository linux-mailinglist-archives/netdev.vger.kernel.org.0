Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26D831FDF1
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBSRh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:37:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229612AbhBSRhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 12:37:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613756158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QRN3sSAOk5ZNxdqFBGqCGbTF/wNoyi9FpXgYt39Qzhg=;
        b=bkJdOVdwg9V0169QwP7ExZ/othgKBiRrCQMQt6x9nQQBCpuiZka8AhM1Bg9hxSS7yi8uY0
        8r6B8+OBHThqBrr+PqSbnZf0gEwlpLOBcDqG7n8JdCTaxLOiwp8nMCPvgz0vhE/azSJJeR
        T1JSifZk4hNzfEhHuw8etQ3QMi8J1t0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-j4Mi5YWrOSiDaUHDJZGLig-1; Fri, 19 Feb 2021 12:35:54 -0500
X-MC-Unique: j4Mi5YWrOSiDaUHDJZGLig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D62171020C21;
        Fri, 19 Feb 2021 17:35:52 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-85.ams2.redhat.com [10.36.115.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70DAC1971D;
        Fri, 19 Feb 2021 17:35:51 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 1/4] mptcp: fix DATA_FIN processing for orphaned sockets
Date:   Fri, 19 Feb 2021 18:35:37 +0100
Message-Id: <ccbb84358b0bf0dac5b616f15244062e7cac32bb.1613755058.git.pabeni@redhat.com>
In-Reply-To: <cover.1613755058.git.pabeni@redhat.com>
References: <cover.1613755058.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we move orphaned msk sockets directly from FIN_WAIT2
state to CLOSE, with the rationale that incoming additional
data could be just dropped by the TCP stack/TW sockets.

Anyhow we miss sending MPTCP-level ack on incoming DATA_FIN,
and that may hang the peers.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 06da6ad31c87..78bd4bed07ac 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2291,13 +2291,12 @@ static void mptcp_worker(struct work_struct *work)
 	__mptcp_check_send_data_fin(sk);
 	mptcp_check_data_fin(sk);
 
-	/* if the msk data is completely acked, or the socket timedout,
-	 * there is no point in keeping around an orphaned sk
+	/* There is no point in keeping around an orphaned sk timedout or
+	 * closed, but we need the msk around to reply to incoming DATA_FIN,
+	 * even if it is orphaned and in FIN_WAIT2 state
 	 */
 	if (sock_flag(sk, SOCK_DEAD) &&
-	    (mptcp_check_close_timeout(sk) ||
-	    (state != sk->sk_state &&
-	    ((1 << inet_sk_state_load(sk)) & (TCPF_CLOSE | TCPF_FIN_WAIT2))))) {
+	    (mptcp_check_close_timeout(sk) || sk->sk_state == TCP_CLOSE)) {
 		inet_sk_state_store(sk, TCP_CLOSE);
 		__mptcp_destroy_sock(sk);
 		goto unlock;
-- 
2.26.2

