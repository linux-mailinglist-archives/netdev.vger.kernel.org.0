Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B5B4361D0
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhJUMj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:39:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29553 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231691AbhJUMjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6l+08CBeZ4Q34iVDW/NFpiH9RVFZMt8Y2tQalSwKD4=;
        b=aEohp86bVQSAX8msoqD/fHtibn8Wx49ZTahw+0nzkx2Bs4tcyEWWPM8MfzLbyGyyR07f3H
        F14Es5ws1bMdW/M0NxXSt+N+n37eikpfy30riIcvRtOifEBlUd/52dsefxV5PUjPPce40o
        yEIJTJ3QqciVUd0cFmyE4T602N4rdyE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-rMmHVjQXN9WkP-Qv8W_TMg-1; Thu, 21 Oct 2021 08:37:34 -0400
X-MC-Unique: rMmHVjQXN9WkP-Qv8W_TMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D82BA104ED3F;
        Thu, 21 Oct 2021 12:37:32 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 885665C1D5;
        Thu, 21 Oct 2021 12:37:31 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 03/10] vsock: owner field is specific to VMCI
Date:   Thu, 21 Oct 2021 16:37:07 +0400
Message-Id: <20211021123714.1125384-4-marcandre.lureau@redhat.com>
In-Reply-To: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This field isn't used by other transports.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/net/af_vsock.h   | 2 ++
 net/vmw_vsock/af_vsock.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index ab207677e0a8..e626d9484bc5 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -41,7 +41,9 @@ struct vsock_sock {
 					 * cached peer?
 					 */
 	u32 cached_peer;  /* Context ID of last dgram destination check. */
+#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
 	const struct cred *owner;
+#endif
 	/* Rest are SOCK_STREAM only. */
 	long connect_timeout;
 	/* Listening socket that this came from. */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index e2c0cfb334d2..1925682a942a 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -761,7 +761,9 @@ static struct sock *__vsock_create(struct net *net,
 	psk = parent ? vsock_sk(parent) : NULL;
 	if (parent) {
 		vsk->trusted = psk->trusted;
+#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
 		vsk->owner = get_cred(psk->owner);
+#endif
 		vsk->connect_timeout = psk->connect_timeout;
 		vsk->buffer_size = psk->buffer_size;
 		vsk->buffer_min_size = psk->buffer_min_size;
@@ -769,7 +771,9 @@ static struct sock *__vsock_create(struct net *net,
 		security_sk_clone(parent, sk);
 	} else {
 		vsk->trusted = ns_capable_noaudit(&init_user_ns, CAP_NET_ADMIN);
+#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
 		vsk->owner = get_current_cred();
+#endif
 		vsk->connect_timeout = VSOCK_DEFAULT_CONNECT_TIMEOUT;
 		vsk->buffer_size = VSOCK_DEFAULT_BUFFER_SIZE;
 		vsk->buffer_min_size = VSOCK_DEFAULT_BUFFER_MIN_SIZE;
@@ -833,7 +837,9 @@ static void vsock_sk_destruct(struct sock *sk)
 	vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
 	vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY);
 
+#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
 	put_cred(vsk->owner);
+#endif
 }
 
 static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
-- 
2.33.0.721.g106298f7f9

