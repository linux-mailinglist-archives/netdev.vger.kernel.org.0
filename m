Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751F24361D2
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhJUMkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:40:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231755AbhJUMj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ZhOVxJom5XEifrrroJYIeqiSKqYh7Pqxg6wfpLtvBA=;
        b=ADqGaluhVD++w4OCzl4GqBiz3H5g0ohncJH1aBfVsmdCI03I997gYGbk7aPklgdMe6m4T/
        RymAbJqjD7uhdT0IqoYRF0LOeZAS1mgX3ERp1H5Ad5TtDG0qBljV335C3BfD5+DmeqheDy
        vqSwFIfhSuBy8Xv+OreJcCRu9ZFw+fc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-O2CjlmAOOXu0SSquHHgTJA-1; Thu, 21 Oct 2021 08:37:39 -0400
X-MC-Unique: O2CjlmAOOXu0SSquHHgTJA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C93B1926DA0;
        Thu, 21 Oct 2021 12:37:38 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B32C1346F;
        Thu, 21 Oct 2021 12:37:36 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 04/10] sock: add sock_swap_peercred
Date:   Thu, 21 Oct 2021 16:37:08 +0400
Message-Id: <20211021123714.1125384-5-marcandre.lureau@redhat.com>
In-Reply-To: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/net/sock.h |  3 +++
 net/core/sock.c    | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index d6877df26200..635d270c3a65 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1822,6 +1822,9 @@ void sock_init_peercred(struct sock *sk);
 /* Copy peer credentials from peersk */
 void sock_copy_peercred(struct sock *sk, struct sock *peersk);
 
+/* Swap socket credentials */
+void sock_swap_peercred(struct sock *sk, struct sock *peersk);
+
 /*
  * Socket reference counting postulates.
  *
diff --git a/net/core/sock.c b/net/core/sock.c
index f6b2662824df..365b63afa915 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3239,6 +3239,30 @@ void sock_copy_peercred(struct sock *sk, struct sock *peersk)
 }
 EXPORT_SYMBOL(sock_copy_peercred);
 
+void sock_swap_peercred(struct sock *sk, struct sock *peersk)
+{
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	if (sk < peersk) {
+		spin_lock(&sk->sk_peer_lock);
+		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock(&peersk->sk_peer_lock);
+		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	}
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
+	sk->sk_peer_pid  = peersk->sk_peer_pid;
+	sk->sk_peer_cred = peersk->sk_peer_cred;
+	peersk->sk_peer_pid = old_pid;
+	peersk->sk_peer_cred = old_cred;
+
+	spin_unlock(&sk->sk_peer_lock);
+	spin_unlock(&peersk->sk_peer_lock);
+}
+EXPORT_SYMBOL(sock_swap_peercred);
+
 void lock_sock_nested(struct sock *sk, int subclass)
 {
 	/* The sk_lock has mutex_lock() semantics here. */
-- 
2.33.0.721.g106298f7f9

