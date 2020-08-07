Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C844223F1A2
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHGREU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:04:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54895 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725934AbgHGRES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 13:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596819857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4jiebjQMCHL5q7sFiHi0ZROqQsL6fAmukPAiJsUgjkw=;
        b=LFjmCBM1qOoKnuyHXlTnNCljWvTEnOyWVXdHvtdBorhADUdXD3dh8rN53FJWKZENhPGgIl
        TkInQPZOJNq9q5L8OXShajivcHQ/RF/GAL0rvxFYDKdLb4m1D01juE6tvXCyxS4ci2ljsF
        rZ8ORpU92x61diZndFIIJ4RizLsxNUs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-DTzIrgftPGaRw4IhVkc_LA-1; Fri, 07 Aug 2020 13:04:14 -0400
X-MC-Unique: DTzIrgftPGaRw4IhVkc_LA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDFDD106B242;
        Fri,  7 Aug 2020 17:04:13 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-201.ams2.redhat.com [10.36.113.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F1DE726A3;
        Fri,  7 Aug 2020 17:04:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: fix warn at shutdown time for unaccepted msk sockets
Date:   Fri,  7 Aug 2020 19:03:53 +0200
Message-Id: <2458c1210f1a164c615e3aa3b9613b085a6c8326.1596819537.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit b93df08ccda3 ("mptcp: explicitly track the fully
established status"), the status of unaccepted mptcp closed in
mptcp_sock_destruct() changes from TCP_SYN_RECV to TCP_ESTABLISHED.

As a result mptcp_sock_destruct() does not perform the proper
cleanup and inet_sock_destruct() will later emit a warn.

Address the issue updating the condition tested in mptcp_sock_destruct().
Also update the related comment.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/66
Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Fixes: b93df08ccda3 ("mptcp: explicitly track the fully established status")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 96f4f2fe50ad..e8cac2655c82 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -423,12 +423,12 @@ static void mptcp_sock_destruct(struct sock *sk)
 	 * also remove the mptcp socket, via
 	 * sock_put(ctx->conn).
 	 *
-	 * Problem is that the mptcp socket will not be in
-	 * SYN_RECV state and doesn't have SOCK_DEAD flag.
+	 * Problem is that the mptcp socket will be in
+	 * ESTABLISHED state and will not have the SOCK_DEAD flag.
 	 * Both result in warnings from inet_sock_destruct.
 	 */
 
-	if (sk->sk_state == TCP_SYN_RECV) {
+	if (sk->sk_state == TCP_ESTABLISHED) {
 		sk->sk_state = TCP_CLOSE;
 		WARN_ON_ONCE(sk->sk_socket);
 		sock_orphan(sk);
-- 
2.26.2

