Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573A82F64E4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbhANPjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:39:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727450AbhANPjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 10:39:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610638667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rwpPQnb6bpC3fbI7HBl78lqcSSYOnnVl0UIkufcRa8Y=;
        b=S1TtWr8XrsfFSLI6OZA3VwReTwAUYcaeALmR8VV3d+KmRbcCnzl0osGBIGenO37bKxB7uA
        gbtDlMjgde2thVc1Ade+8InNDxeSiDCe2ADCTqXtnynSSO9enSuHD5VCJB9PQpuAAqHTam
        F1mZnySHIcQfiCUPH9xY5/IOm/gBth8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-AhdnPPBqNkGrssKqwsaJ_A-1; Thu, 14 Jan 2021 10:37:45 -0500
X-MC-Unique: AhdnPPBqNkGrssKqwsaJ_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74DC2190A7A1;
        Thu, 14 Jan 2021 15:37:44 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-2.ams2.redhat.com [10.36.115.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C13B5D9E2;
        Thu, 14 Jan 2021 15:37:42 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] mptcp: fix locking in mptcp_disconnect()
Date:   Thu, 14 Jan 2021 16:37:37 +0100
Message-Id: <f818e82b58a556feeb71dcccc8bf1c87aafc6175.1610638176.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_disconnect() expects the caller acquires the sock lock,
but mptcp_disconnect() is not doing that. Add the missing
required lock.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: 76e2a55d1625 ("mptcp: better msk-level shutdown.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 81faeff8f3bb..f998a077c7dd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2646,8 +2646,13 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	__mptcp_flush_join_list(msk);
-	mptcp_for_each_subflow(msk, subflow)
-		tcp_disconnect(mptcp_subflow_tcp_sock(subflow), flags);
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		lock_sock(ssk);
+		tcp_disconnect(ssk, flags);
+		release_sock(ssk);
+	}
 	return 0;
 }
 
-- 
2.26.2

