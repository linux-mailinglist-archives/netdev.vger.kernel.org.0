Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326DD4361E0
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhJUMk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:40:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231550AbhJUMkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lZ3V8Nu0/x56ViCtDuyQGZJtbSCLKoN9sbTI1RoP0GU=;
        b=BiXEATgmp5mi4k/hEgM9Z2EaJ0iYLiR0ulCNahQnIjdLyqyt+bn2kJEFhgZlNOH3xWHUCs
        rGiNCJTEvnpzlV6RrJoFlJCSsn5HA4yob88N4b1TrOMILHRICUCVFbm+Kru7ObcVfZ+PAx
        Qbx3lGJOASsOK24xNHt2/TuM05s0qh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-ipFr8KmROiuMXMfm-naHdg-1; Thu, 21 Oct 2021 08:38:24 -0400
X-MC-Unique: ipFr8KmROiuMXMfm-naHdg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F5191926DA8;
        Thu, 21 Oct 2021 12:38:23 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 258071346F;
        Thu, 21 Oct 2021 12:38:21 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 10/10] vsock/virtio: clear peer creds on connect
Date:   Thu, 21 Oct 2021 16:37:14 +0400
Message-Id: <20211021123714.1125384-11-marcandre.lureau@redhat.com>
In-Reply-To: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since providing foreign creds wouldn't make much sense over VIRTIO,
let's clear the socket peer credentials on connect.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 4f7c99dfd16c..705789272a0f 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -449,6 +449,26 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 
 static bool virtio_transport_seqpacket_allow(u32 remote_cid);
 
+static int transport_connect(struct vsock_sock *vsk)
+{
+	struct sock *sk;
+	int ret;
+
+	ret = virtio_transport_connect(vsk);
+	if (ret < 0) {
+		return ret;
+	}
+
+	/* clear creds, as we can't provide foreign creds */
+	sk = sk_vsock(vsk);
+	put_pid(sk->sk_peer_pid);
+	sk->sk_peer_pid = NULL;
+	put_cred(sk->sk_peer_cred);
+	sk->sk_peer_cred = NULL;
+
+	return ret;
+}
+
 static struct virtio_transport virtio_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
@@ -458,7 +478,7 @@ static struct virtio_transport virtio_transport = {
 		.init                     = virtio_transport_do_socket_init,
 		.destruct                 = virtio_transport_destruct,
 		.release                  = virtio_transport_release,
-		.connect                  = virtio_transport_connect,
+		.connect                  = transport_connect,
 		.shutdown                 = virtio_transport_shutdown,
 		.cancel_pkt               = virtio_transport_cancel_pkt,
 
-- 
2.33.0.721.g106298f7f9

