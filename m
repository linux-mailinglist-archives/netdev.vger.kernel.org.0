Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0F84361DC
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhJUMkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:40:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231271AbhJUMkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:40:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=grzXUPdo/5Jjzm+/mfccEoDVrjSOubRim82+tZ3lp10=;
        b=Q34CWjS5VOaM6R62qcm6bztLk7pKf2g9xPt6NJsGdtMLL1KM+atEWcFXq/csXnG2Y7sr6D
        x2xj6NHo4XXttuGTf4CwQl5PzMvzekTflU3kJlUDUqujr0YVkQ7fh+HGbuYNSRIYLt0L4h
        TudzykulkhDQtFkSz2v4QhHChyaF/RE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-B8B_d8pBOWWJLZRWvXzlhQ-1; Thu, 21 Oct 2021 08:38:18 -0400
X-MC-Unique: B8B_d8pBOWWJLZRWvXzlhQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7796BAF82;
        Thu, 21 Oct 2021 12:38:17 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 721365FC22;
        Thu, 21 Oct 2021 12:38:11 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 09/10] vhost/vsock: implement copy_peercred
Date:   Thu, 21 Oct 2021 16:37:13 +0400
Message-Id: <20211021123714.1125384-10-marcandre.lureau@redhat.com>
In-Reply-To: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the socket peercred to the vhost owner.

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 drivers/vhost/vsock.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 3067436cddfc..fb492c53631d 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -308,6 +308,27 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
 	return len;
 }
 
+static void vhost_transport_copy_peercred(struct sock *sk, struct virtio_vsock_pkt *pkt)
+{
+	struct vhost_vsock *vsock;
+
+	put_pid(sk->sk_peer_pid);
+	sk->sk_peer_pid = NULL;
+	put_cred(sk->sk_peer_cred);
+	sk->sk_peer_cred = NULL;
+
+	rcu_read_lock();
+	vsock = vhost_vsock_get(le64_to_cpu(pkt->hdr.src_cid));
+	if (!vsock)
+		goto out;
+
+	sk->sk_peer_pid = get_pid(vsock->owner_pid);
+	sk->sk_peer_cred = get_cred(vsock->owner_cred);
+
+out:
+	rcu_read_unlock();
+}
+
 static int
 vhost_transport_cancel_pkt(struct vsock_sock *vsk)
 {
@@ -474,6 +495,7 @@ static struct virtio_transport vhost_transport = {
 	},
 
 	.send_pkt = vhost_transport_send_pkt,
+	.copy_peercred = vhost_transport_copy_peercred,
 };
 
 static bool vhost_transport_seqpacket_allow(u32 remote_cid)
-- 
2.33.0.721.g106298f7f9

