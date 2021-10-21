Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257EA4361D8
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhJUMka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:40:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231138AbhJUMkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yYLGkQsNsgBUFsGjRdMzLFPWPWHahKiW0zK6GQ9fG54=;
        b=J4wclVYhsBSUfrxi5k4LlQazXEMzUhZ5HV0ddPXW+0GHi1DaiPZRPmMPqQTDZTLBgLybyA
        gslYi6gyPY9OAbJbrZGu5QETjCbcWJrSP154ACnaywZt2IE8l5wJ4W4e7TQuNQtygbG/wH
        MWSx5ZRrK4N71kaM/t9BZpoVrezvI4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-C5lCnJmbPbOOVKbRZ4My3g-1; Thu, 21 Oct 2021 08:38:03 -0400
X-MC-Unique: C5lCnJmbPbOOVKbRZ4My3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AE5A8066EF;
        Thu, 21 Oct 2021 12:38:02 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D2665FC22;
        Thu, 21 Oct 2021 12:38:01 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 07/10] vsock/loopback: implement copy_peercred()
Date:   Thu, 21 Oct 2021 16:37:11 +0400
Message-Id: <20211021123714.1125384-8-marcandre.lureau@redhat.com>
In-Reply-To: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
---
 net/vmw_vsock/vsock_loopback.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 169a8cf65b39..59317baa4e5c 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -41,6 +41,12 @@ static int vsock_loopback_send_pkt(struct virtio_vsock_pkt *pkt)
 	return len;
 }
 
+static void vsock_loopback_copy_peercred(struct sock *sk, struct virtio_vsock_pkt *pkt)
+{
+	/* on vsock loopback, set both peers by swaping the creds */
+	sock_swap_peercred(sk, sk_vsock(pkt->vsk));
+}
+
 static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 {
 	struct vsock_loopback *vsock = &the_vsock_loopback;
@@ -110,6 +116,7 @@ static struct virtio_transport loopback_transport = {
 	},
 
 	.send_pkt = vsock_loopback_send_pkt,
+	.copy_peercred = vsock_loopback_copy_peercred,
 };
 
 static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
-- 
2.33.0.721.g106298f7f9

