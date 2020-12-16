Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834512DBFC0
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 12:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgLPLu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 06:50:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725806AbgLPLu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 06:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608119341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mJOqHmUb8CNA4bRlVwBmxwsPIeaQxlh4BRVnFNKIsy0=;
        b=iJ0oM/o40FubwTA4kHyhTyF4fGVvV7HXCTgFULm8LlomFqMVRULSI8ZDA32VFLPj7HwXad
        JG9QH6Edd6hHEihMtSwQxIHI956r/F31DQ9FvYgAV5PS2TB0lKjdJIfCs0kL6pF3EpS3dG
        psJs2ezHpUpog//nnwhO8QbZXUIxlBw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-iH3yOxgbMy2pDK2BHK3BJw-1; Wed, 16 Dec 2020 06:49:00 -0500
X-MC-Unique: iH3yOxgbMy2pDK2BHK3BJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECA07B812C;
        Wed, 16 Dec 2020 11:48:54 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-143.ams2.redhat.com [10.36.112.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB51F60843;
        Wed, 16 Dec 2020 11:48:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net 4/4] mptcp: fix pending data accounting
Date:   Wed, 16 Dec 2020 12:48:35 +0100
Message-Id: <500ca762741cdb005751703f89ffa374c338ae7b.1608114076.git.pabeni@redhat.com>
In-Reply-To: <cover.1608114076.git.pabeni@redhat.com>
References: <cover.1608114076.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sendmsg() needs to wait for memory, the pending data
is not updated. That causes a drift in forward memory allocation,
leading to stall and/or warnings at socket close time.

This change addresses the above issue moving the pending data
counter update inside the sendmsg() main loop.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b53a91801a6c..09b19aa2f205 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1658,6 +1658,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		frag_truesize += psize;
 		pfrag->offset += frag_truesize;
 		WRITE_ONCE(msk->write_seq, msk->write_seq + psize);
+		msk->tx_pending_data += psize;
 
 		/* charge data on mptcp pending queue to the msk socket
 		 * Note: we charge such data both to sk and ssk
@@ -1683,10 +1684,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			goto out;
 	}
 
-	if (copied) {
-		msk->tx_pending_data += copied;
+	if (copied)
 		mptcp_push_pending(sk, msg->msg_flags);
-	}
 
 out:
 	release_sock(sk);
-- 
2.26.2

