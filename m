Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A793D3ACC64
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhFRNiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:38:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48778 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233974AbhFRNiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624023356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KFwIb7IPOZRbP1IQ9mV70O4nT0A/GjnYdmBaTej5bMs=;
        b=OtXPGHi93k4blZndryJDUl/FOCz+P2EaC/6Zcx+IYAmim04WcfRnqlk28ITz19vPDhB5/h
        flrE7PV3Z/DiBeCCOoUOqJafa9eMB5yGupguA/N2ptaYJpimlIKVDpyPZN7hyVTeHKaF+i
        LTLFDW6BUdRtdnQ0CzqzYX6NeCkDBl8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-12QN6s9jMYqyi6bKQyOXnw-1; Fri, 18 Jun 2021 09:35:55 -0400
X-MC-Unique: 12QN6s9jMYqyi6bKQyOXnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B98A8100C666;
        Fri, 18 Jun 2021 13:35:53 +0000 (UTC)
Received: from steredhat.lan (ovpn-115-127.ams2.redhat.com [10.36.115.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B17261000324;
        Fri, 18 Jun 2021 13:35:47 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] vsock/virtio: remove redundant `copy_failed` variable
Date:   Fri, 18 Jun 2021 15:35:26 +0200
Message-Id: <20210618133526.300347-4-sgarzare@redhat.com>
In-Reply-To: <20210618133526.300347-1-sgarzare@redhat.com>
References: <20210618133526.300347-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When memcpy_to_msg() fails in virtio_transport_seqpacket_do_dequeue(),
we already set `dequeued_len` with the negative error value returned
by memcpy_to_msg().

So we can directly check `dequeued_len` value instead of using a
dedicated flag variable to skip the copy path for the rest of
fragments.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 23704a6bc437..f014ccfdd9c2 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -413,7 +413,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 	struct virtio_vsock_pkt *pkt;
 	int dequeued_len = 0;
 	size_t user_buf_len = msg_data_left(msg);
-	bool copy_failed = false;
 	bool msg_ready = false;
 
 	spin_lock_bh(&vvs->rx_lock);
@@ -426,7 +425,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 	while (!msg_ready) {
 		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
 
-		if (!copy_failed) {
+		if (dequeued_len >= 0) {
 			size_t pkt_len;
 			size_t bytes_to_copy;
 
@@ -443,11 +442,9 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 
 				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
 				if (err) {
-					/* Copy of message failed, set flag to skip
-					 * copy path for rest of fragments. Rest of
+					/* Copy of message failed. Rest of
 					 * fragments will be freed without copy.
 					 */
-					copy_failed = true;
 					dequeued_len = err;
 				} else {
 					user_buf_len -= bytes_to_copy;
-- 
2.31.1

