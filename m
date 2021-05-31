Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346B339692C
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 23:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhEaVC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 17:02:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230032AbhEaVCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 17:02:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622494841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TVJOjpnm1EByhFidIJEbJsSj9xgDF8Hy0qPiU9qnT+Y=;
        b=f51wBpl2n4MzgSTMhR13ltCdlJLMXvQKfgHow20MmxZBjHm0NoB3CjwxPh7OOOSCMvKK6L
        okGVpi+XtfhVVYLrmCWXfbWsPhs3pzGAXwyQevoNnFX3wEqkaWFIhEvJQzGigx/0EHLXdU
        qc/UXJDsuqfnX1OG7ALXUOXVSZqHgNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-fcOP-VzsPR6cVsdjQiPI2A-1; Mon, 31 May 2021 17:00:39 -0400
X-MC-Unique: fcOP-VzsPR6cVsdjQiPI2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0091501E0;
        Mon, 31 May 2021 21:00:38 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-113-1.rdu2.redhat.com [10.10.113.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3179B16558;
        Mon, 31 May 2021 21:00:38 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     netdev@vger.kernel.org
Cc:     marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net] net: sock: fix in-kernel mark setting
Date:   Mon, 31 May 2021 17:00:30 -0400
Message-Id: <20210531210030.1462995-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the in-kernel mark setting by doing an additional
sk_dst_reset() which was introduced by commit 50254256f382 ("sock: Reset
dst when changing sk_mark via setsockopt"). The code is now shared to
avoid any further suprises when changing the socket mark value.

Fixes: 84d1c617402e ("net: sock: add sock_set_mark")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/core/sock.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 958614ea16ed..946888afef88 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -815,10 +815,18 @@ void sock_set_rcvbuf(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(sock_set_rcvbuf);
 
+static void __sock_set_mark(struct sock *sk, u32 val)
+{
+	if (val != sk->sk_mark) {
+		sk->sk_mark = val;
+		sk_dst_reset(sk);
+	}
+}
+
 void sock_set_mark(struct sock *sk, u32 val)
 {
 	lock_sock(sk);
-	sk->sk_mark = val;
+	__sock_set_mark(sk, val);
 	release_sock(sk);
 }
 EXPORT_SYMBOL(sock_set_mark);
@@ -1126,10 +1134,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 	case SO_MARK:
 		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
 			ret = -EPERM;
-		} else if (val != sk->sk_mark) {
-			sk->sk_mark = val;
-			sk_dst_reset(sk);
+			break;
 		}
+
+		__sock_set_mark(sk, val);
 		break;
 
 	case SO_RXQ_OVFL:
-- 
2.26.3

