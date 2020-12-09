Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668002D409F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbgLILFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:05:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730276AbgLILFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:05:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607511829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vX/GEa5LkEasf8ePL37UaPn1sCbO4jCR1KoS38zKeAg=;
        b=aXijdIHr6MzMF4/zcHcKYTtBJqb+Mk3xk9n38KXZ8zriJMWwnrdhg4Iu2ehaJzYERN5fDT
        YmkHdVO9UYCTzevx4oUe/hQ+GpgSnD9O/3KIMFyR4bfqtfVVOGNUvbsWtQflbN1du75Xvz
        fUtjSvGm59wXDu01eVns7RSzr+fUyYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-acYpaiTmPhKJimAituROaQ-1; Wed, 09 Dec 2020 06:03:47 -0500
X-MC-Unique: acYpaiTmPhKJimAituROaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 433E7107ACE3;
        Wed,  9 Dec 2020 11:03:46 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-45.ams2.redhat.com [10.36.112.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1194819C78;
        Wed,  9 Dec 2020 11:03:44 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net-next 3/3] mptcp: be careful on subflows shutdown
Date:   Wed,  9 Dec 2020 12:03:31 +0100
Message-Id: <e270b6f2ab71aa7ce8bf8f7836636332062d78cd.1607508810.git.pabeni@redhat.com>
In-Reply-To: <cover.1607508810.git.pabeni@redhat.com>
References: <cover.1607508810.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the workqueue disposes of the msk, the subflows can still
receive some data from the peer after __mptcp_close_ssk()
completes.

The above could trigger a race between the msk receive path and the
msk destruction. Acquiring the mptcp_data_lock() in __mptcp_destroy_sock()
will not save the day: the rx path could be reached even after msk
destruction completes.

Instead use the subflow 'disposable' flag to prevent entering
the msk receive path after __mptcp_close_ssk().

Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4e29dcf17ecd..2540d82742ac 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -701,6 +701,13 @@ void mptcp_data_ready(struct sock *sk, struct sock *ssk)
 	int sk_rbuf, ssk_rbuf;
 	bool wake;
 
+	/* The peer can send data while we are shutting down this
+	 * subflow at msk destruction time, but we must avoid enqueuing
+	 * more data to the msk receive queue
+	 */
+	if (unlikely(subflow->disposable))
+		return;
+
 	/* move_skbs_to_msk below can legitly clear the data_avail flag,
 	 * but we will need later to properly woke the reader, cache its
 	 * value
@@ -2119,6 +2126,8 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		sock_orphan(ssk);
 	}
 
+	subflow->disposable = 1;
+
 	/* if ssk hit tcp_done(), tcp_cleanup_ulp() cleared the related ops
 	 * the ssk has been already destroyed, we just need to release the
 	 * reference owned by msk;
@@ -2126,8 +2135,7 @@ void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	if (!inet_csk(ssk)->icsk_ulp_ops) {
 		kfree_rcu(subflow, rcu);
 	} else {
-		/* otherwise ask tcp do dispose of ssk and subflow ctx */
-		subflow->disposable = 1;
+		/* otherwise tcp will dispose of the ssk and subflow ctx */
 		__tcp_close(ssk, 0);
 
 		/* close acquired an extra ref */
-- 
2.26.2

