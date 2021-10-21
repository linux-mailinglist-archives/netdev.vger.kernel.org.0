Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB38E4361D4
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhJUMkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:40:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230349AbhJUMkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:40:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsfspR8ZEWmBnaKu/w2MzUpVUlKGPyAuxvlrmOkq9T0=;
        b=VNMChwq2TAaNI75HgvT4WognEEMdP2YaIv0Odmi9CmsGEAjT7ZNyd19vNoPadXvNY6UjWX
        XeSgctmjRlqzsWSI/8dUohm/1FHAYleE1PVpuUv001bBUlPFX6HkTmNdoLaOXbViIt3bUn
        im53baY8jG9x5xNLxQ0REsK9ephCD9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-prZdgGaNPuWIYbpSLZ_bBw-1; Thu, 21 Oct 2021 08:37:47 -0400
X-MC-Unique: prZdgGaNPuWIYbpSLZ_bBw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C312B8066EF;
        Thu, 21 Oct 2021 12:37:45 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E180100164A;
        Thu, 21 Oct 2021 12:37:41 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 05/10] virtio/vsock: add copy_peercred() to virtio_transport
Date:   Thu, 21 Oct 2021 16:37:09 +0400
Message-Id: <20211021123714.1125384-6-marcandre.lureau@redhat.com>
In-Reply-To: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 include/linux/virtio_vsock.h            | 2 ++
 net/vmw_vsock/virtio_transport_common.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 35d7eedb5e8e..2445bece9216 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -69,6 +69,8 @@ struct virtio_transport {
 
 	/* Takes ownership of the packet */
 	int (*send_pkt)(struct virtio_vsock_pkt *pkt);
+	/* Set peercreds on socket created after listen recv */
+	void (*copy_peercred)(struct sock *sk, struct virtio_vsock_pkt *pkt);
 };
 
 ssize_t
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 59ee1be5a6dd..611d25e80723 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1194,6 +1194,15 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
 		return -ENOMEM;
 	}
 
+	if (t->copy_peercred) {
+		t->copy_peercred(child, pkt);
+	} else {
+		put_pid(child->sk_peer_pid);
+		child->sk_peer_pid = NULL;
+		put_cred(child->sk_peer_cred);
+		child->sk_peer_cred = NULL;
+	}
+
 	sk_acceptq_added(sk);
 
 	lock_sock_nested(child, SINGLE_DEPTH_NESTING);
-- 
2.33.0.721.g106298f7f9

