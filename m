Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0914A2B8738
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 23:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgKRWGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 17:06:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbgKRWGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 17:06:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605737176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NdjeARxGuLTeRkhnnivxFdfoRVbvyIFUDejtLn+aBXk=;
        b=Kj+rspu1cbJC6uj2LEePAyRdp7FoJ0WvLfduRNh7u7KH7jR7glVwf9I6glz0TVraE6E9IK
        RCUsDhcXWDrvF8vp8+X7u6EYARVbBfRi8S/p3T3sGJxOMwe0Ev9Co4FJQelZ4p3h85Kqz7
        ePUkW/jREPjbCg3pr73MGrMyzUjDLEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-6P_4UpxaP4SfaOehq43F4w-1; Wed, 18 Nov 2020 17:06:14 -0500
X-MC-Unique: 6P_4UpxaP4SfaOehq43F4w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F20C89CCC0;
        Wed, 18 Nov 2020 22:06:13 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-97.ams2.redhat.com [10.36.112.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AACA160C05;
        Wed, 18 Nov 2020 22:06:11 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next] mptcp: update rtx timeout only if required.
Date:   Wed, 18 Nov 2020 23:05:34 +0100
Message-Id: <1a72039f112cae048c44d398ffa14e0a1432db3d.1605737083.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We must start the retransmission timer only there are
pending data in the rtx queue.
Otherwise we can hit a WARN_ON in mptcp_reset_timer(),
as syzbot demonstrated.

Reported-and-tested-by: syzbot+42aa53dafb66a07e5a24@syzkaller.appspotmail.com
Fixes: d9ca1de8c0cd ("mptcp: move page frag allocation in mptcp_sendmsg()")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 8df013daea88..aeda4357de9a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1261,11 +1261,12 @@ static void mptcp_push_pending(struct sock *sk, unsigned int flags)
 		mptcp_push_release(sk, ssk, &info);
 
 out:
-	/* start the timer, if it's not pending */
-	if (!mptcp_timer_pending(sk))
-		mptcp_reset_timer(sk);
-	if (copied)
+	if (copied) {
+		/* start the timer, if it's not pending */
+		if (!mptcp_timer_pending(sk))
+			mptcp_reset_timer(sk);
 		__mptcp_check_send_data_fin(sk);
+	}
 }
 
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
-- 
2.26.2

