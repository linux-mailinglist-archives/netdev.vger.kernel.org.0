Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAAC2810AB
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbgJBKkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 06:40:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbgJBKkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 06:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601635205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=feUdseSmCaw/fcpaZPYQzD3oFiZbEy6o4GMETibwx2Y=;
        b=Yi3QjD1bcxNSkjt8pEAvm6YsRyUVAy9jSbc3/gFLmqbVgF20Fh+H/ml0SFeSzIIug6OW94
        tikAK6yUOpfPQXpnRez7Mc0d+u1C36JjS8ULQ9oXLtBn3Z21veL8MAzFlYpbbq0rX59Lcu
        Zkoa7ahwAfZDZiM9MmHb7G37SQVThSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-X3MJidXTOXK6-XIVYbyIpA-1; Fri, 02 Oct 2020 06:40:01 -0400
X-MC-Unique: X3MJidXTOXK6-XIVYbyIpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7104F1019625;
        Fri,  2 Oct 2020 10:40:00 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-189.ams2.redhat.com [10.36.113.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 915577EB7C;
        Fri,  2 Oct 2020 10:39:58 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, mptcp@lists.01.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] tcp: fix syn cookied MPTCP request socket leak
Date:   Fri,  2 Oct 2020 12:39:44 +0200
Message-Id: <867cc806e4dfeb200e84b37addff2e2847f44c0e.1601635086.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a syn-cookies request socket don't pass MPTCP-level
validation done in syn_recv_sock(), we need to release
it immediately, or it will be leaked.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/89
Fixes: 9466a1ccebbe ("mptcp: enable JOIN requests even if cookies are in use")
Reported-and-tested-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/syncookies.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index f0794f0232ba..e03756631541 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -214,7 +214,7 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 		sock_rps_save_rxhash(child, skb);
 
 		if (rsk_drop_req(req)) {
-			refcount_set(&req->rsk_refcnt, 2);
+			reqsk_put(req);
 			return child;
 		}
 
-- 
2.26.2

