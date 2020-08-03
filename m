Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424C123AAA8
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgHCQlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:41:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbgHCQlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596472868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pvdPcJYkWLDIhPmfwUUpKeDuw1pNYJIpojPPdqZwuro=;
        b=c1zkIZpSt8uC0JGFVCI5l/OjU4iynJICFsMLdfu2vgzttRJNzIArMoUFfQD0WgsmlriNOO
        maS733MfGmtiUg9Oq2cEUDHK35eIzOWbkwLGpKNnXz4beXBiU3vY40gy1HV/wT9vi3uAVH
        cOYEW0iCdnKqiyGxThFCBue3RFRgdJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-VKsEgLJ4OwmLsPWcz228zg-1; Mon, 03 Aug 2020 12:41:06 -0400
X-MC-Unique: VKsEgLJ4OwmLsPWcz228zg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34D8E18C63C0;
        Mon,  3 Aug 2020 16:41:05 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 193881002397;
        Mon,  3 Aug 2020 16:41:03 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: fix bogus sendmsg() return code under pressure
Date:   Mon,  3 Aug 2020 18:40:39 +0200
Message-Id: <365d4a854cbfabbd93be7b0331e4c5d3eb1334b8.1596472748.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of memory pressure, mptcp_sendmsg() may call
sk_stream_wait_memory() after succesfully xmitting some
bytes. If the latter fails we currently return to the
user-space the error code, ignoring the succeful xmit.

Address the issue always checking for the xmitted bytes
before mptcp_sendmsg() completes.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c0abe738e7d3..a761d3c613bb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -880,7 +880,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	mptcp_set_timeout(sk, ssk);
 	if (copied) {
-		ret = copied;
 		tcp_push(ssk, msg->msg_flags, mss_now, tcp_sk(ssk)->nonagle,
 			 size_goal);
 
@@ -893,7 +892,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	release_sock(ssk);
 out:
 	release_sock(sk);
-	return ret;
+	return copied ? : ret;
 }
 
 static void mptcp_wait_data(struct sock *sk, long *timeo)
-- 
2.26.2

