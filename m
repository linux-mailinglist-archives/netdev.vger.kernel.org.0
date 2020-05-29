Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545C31E8256
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgE2PoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:44:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56409 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726940AbgE2PoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590767051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5AD3HnP3A68DFj5y3YNpEEwK2K02DYm/1aEunRukBJ4=;
        b=D2t5xL1J6bRPTpG4Pe+pYnwr84qDRNYCMAIIAZRRNvGQA4rWr1vvSQjKZmDLPi6jzrQQe7
        ljd7Hj6fNRVmy6++8ZP7WNnVFskKhb8zeFFiM1dLO2nbZvs/aUmYbAbuI6xb9l4ZuUPWWR
        hkf1QQ6abK3mEHPOpiSbr3phwDVrqLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-sxFHK8I_MwWO1rF_wr2qTw-1; Fri, 29 May 2020 11:44:09 -0400
X-MC-Unique: sxFHK8I_MwWO1rF_wr2qTw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9A3F19057A9;
        Fri, 29 May 2020 15:44:08 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-94.ams2.redhat.com [10.36.114.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9836C7A8BA;
        Fri, 29 May 2020 15:44:07 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/3] mptcp: remove msk from the token container at destruction time.
Date:   Fri, 29 May 2020 17:43:31 +0200
Message-Id: <73105e38dc7e9153dc3b58a3c4ccc59de3a10947.1590766645.git.pabeni@redhat.com>
In-Reply-To: <cover.1590766645.git.pabeni@redhat.com>
References: <cover.1590766645.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we remote the msk from the token container only
via mptcp_close(). The MPTCP master socket can be destroyed
also via other paths (e.g. if not yet accepted, when shutting
down the listener socket). When we hit the latter scenario,
dangling msk references are left into the token container,
leading to memory corruption and/or UaF.

This change addresses the issue by moving the token removal
into the msk destructor.

Fixes: 79c0949e9a09 ("mptcp: Add key generation and token tree")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 35bdfb4f3eae..34dd0e278a82 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1263,7 +1263,6 @@ static void mptcp_close(struct sock *sk, long timeout)
 
 	lock_sock(sk);
 
-	mptcp_token_destroy(msk->token);
 	inet_sk_state_store(sk, TCP_CLOSE);
 
 	/* be sure to always acquire the join list lock, to sync vs
@@ -1461,6 +1460,7 @@ static void mptcp_destroy(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
+	mptcp_token_destroy(msk->token);
 	if (msk->cached_ext)
 		__skb_ext_put(msk->cached_ext);
 
-- 
2.21.3

