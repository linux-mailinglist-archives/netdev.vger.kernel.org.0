Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAFA9DAC8C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502492AbfJQMoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 08:44:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388531AbfJQMoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 08:44:11 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1713D300C5A9;
        Thu, 17 Oct 2019 12:44:11 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-195.ams2.redhat.com [10.36.117.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FE075D9CA;
        Thu, 17 Oct 2019 12:44:09 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net 1/2] vsock/virtio: send a credit update when buffer size is changed
Date:   Thu, 17 Oct 2019 14:44:02 +0200
Message-Id: <20191017124403.266242-2-sgarzare@redhat.com>
In-Reply-To: <20191017124403.266242-1-sgarzare@redhat.com>
References: <20191017124403.266242-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 17 Oct 2019 12:44:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the user application set a new buffer size value, we should
update the remote peer about this change, since it uses this
information to calculate the credit available.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index a666ef8fc54e..db127a69f5c3 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -458,6 +458,9 @@ void virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val)
 		vvs->buf_size_max = val;
 	vvs->buf_size = val;
 	vvs->buf_alloc = val;
+
+	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
+					    NULL);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_set_buffer_size);
 
-- 
2.21.0

