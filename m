Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547512D40A1
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgLILFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:05:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730095AbgLILFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607511827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WYRysws0TVI2xZ6UC70r9YQQdVKCmNKdp1AGbqKyMf8=;
        b=Hf/D1ddZquqE3SDS+EURY3ZzsLYL9RPYTng3hjo82peoGRxjBlB3jjVrLLX+dt6MVsauBs
        KPeKbS9xBkbMJ1FePnPhb7vF3gtvEumHhlfaS2iPuHwjzkecM+OHrrU/Ghye6XJmv0k+rm
        jM+3j1vFvVin877OKstZ2RcrHsWLDPY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-BOz5lJVcNOaBGBC87oyWRA-1; Wed, 09 Dec 2020 06:03:45 -0500
X-MC-Unique: BOz5lJVcNOaBGBC87oyWRA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0D60180A086;
        Wed,  9 Dec 2020 11:03:44 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-45.ams2.redhat.com [10.36.112.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 883E919C78;
        Wed,  9 Dec 2020 11:03:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next 2/3] mptcp: plug subflow context memory leak
Date:   Wed,  9 Dec 2020 12:03:30 +0100
Message-Id: <ab23e78a6e23b159b7ae3a21b3cdae39f836a092.1607508810.git.pabeni@redhat.com>
In-Reply-To: <cover.1607508810.git.pabeni@redhat.com>
References: <cover.1607508810.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a MPTCP listener socket is closed with unaccepted
children pending, the ULP release callback will be invoked,
but nobody will call into __mptcp_close_ssk() on the
corresponding subflow.

As a consequence, at ULP release time, the 'disposable' flag
will be cleared and the subflow context memory will be leaked.

This change addresses the issue always freeing the context if
the subflow is still in the accept queue at ULP release time.

Additionally, this fixes an incorrect code reference in the
related comment.

Note: this fix leverages the changes introduced by the previous
commit.

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 9b5a966b0041..fefcaf497938 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1339,9 +1339,10 @@ static void subflow_ulp_release(struct sock *ssk)
 	sk = ctx->conn;
 	if (sk) {
 		/* if the msk has been orphaned, keep the ctx
-		 * alive, will be freed by mptcp_done()
+		 * alive, will be freed by __mptcp_close_ssk(),
+		 * when the subflow is still unaccepted
 		 */
-		release = ctx->disposable;
+		release = ctx->disposable || list_empty(&ctx->node);
 		sock_put(sk);
 	}
 
-- 
2.26.2

