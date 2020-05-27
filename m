Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7427A1E3B15
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbgE0H5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 03:57:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38464 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387663AbgE0H5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 03:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590566227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5F/o7OGwvhTxyKAdmFEBVbFxDhCXeuX/gkHyEAGjn5o=;
        b=ZtsZGbobsNTF7aG4fRDZMG5tIz5D01s8qvtWTs5t59hwf+Rqvzdy9fxQWqH0onQZ8G/l5G
        1pqWZxy2+eDSE5jTCa85IdLdDO4amVddEuWfjnY/T1C8OR7+DZpedeJl2xSnQGbPuK+ONY
        51Aogl5VP39as12WM481W5kwbTSmeSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-JqPXZLUmPgCJ4ZQEMQYfdw-1; Wed, 27 May 2020 03:57:03 -0400
X-MC-Unique: JqPXZLUmPgCJ4ZQEMQYfdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B72B4107ACF2;
        Wed, 27 May 2020 07:57:01 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-178.ams2.redhat.com [10.36.113.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE4E81A7DB;
        Wed, 27 May 2020 07:56:56 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     George Zhang <georgezhang@vmware.com>,
        Andy King <acking@vmware.com>,
        Dexuan Cui <decui@microsoft.com>,
        Dmitry Torokhov <dtor@vmware.com>, netdev@vger.kernel.org,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] vsock: fix timeout in vsock_accept()
Date:   Wed, 27 May 2020 09:56:55 +0200
Message-Id: <20200527075655.69889-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The accept(2) is an "input" socket interface, so we should use
SO_RCVTIMEO instead of SO_SNDTIMEO to set the timeout.

So this patch replace sock_sndtimeo() with sock_rcvtimeo() to
use the right timeout in the vsock_accept().

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index a5f28708e0e7..626bf9044418 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1408,7 +1408,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 	/* Wait for children sockets to appear; these are the new sockets
 	 * created upon connection establishment.
 	 */
-	timeout = sock_sndtimeo(listener, flags & O_NONBLOCK);
+	timeout = sock_rcvtimeo(listener, flags & O_NONBLOCK);
 	prepare_to_wait(sk_sleep(listener), &wait, TASK_INTERRUPTIBLE);
 
 	while ((connected = vsock_dequeue_accept(listener)) == NULL &&
-- 
2.25.4

