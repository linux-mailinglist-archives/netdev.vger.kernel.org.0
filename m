Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B971537A3EA
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhEKJmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:42:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2621 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhEKJmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 05:42:52 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FfXsp1y28zPwtk;
        Tue, 11 May 2021 17:38:22 +0800 (CST)
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Tue, 11 May 2021 17:41:38 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <arei.gonglei@huawei.com>, <subo7@huawei.com>,
        "Longpeng(Mike)" <longpeng2@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Jorgen Hansen" <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "Andra Paraschiv" <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        David Brazdil <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        lixianming <lixianming5@huawei.com>
Subject: [RFC] vsock: notify server to shutdown when client has pending signal
Date:   Tue, 11 May 2021 17:41:27 +0800
Message-ID: <20210511094127.724-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The client's sk_state will be set to TCP_ESTABLISHED if the
server replay the client's connect request.
However, if the client has pending signal, its sk_state will
be set to TCP_CLOSE without notify the server, so the server
will hold the corrupt connection.

            client                        server

1. sk_state=TCP_SYN_SENT         |
2. call ->connect()              |
3. wait reply                    |
                                 | 4. sk_state=TCP_ESTABLISHED
                                 | 5. insert to connected list
                                 | 6. reply to the client
7. sk_state=TCP_ESTABLISHED      |
8. insert to connected list      |
9. *signal pending* <--------------------- the user kill client
10. sk_state=TCP_CLOSE           |
client is exiting...             |
11. call ->release()             |
     virtio_transport_close
      if (!(sk->sk_state == TCP_ESTABLISHED ||
	      sk->sk_state == TCP_CLOSING))
		return true; <------------- return at here
As a result, the server cannot notice the connection is corrupt.
So the client should notify the peer in this case.

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Norbert Slusarek <nslusarek@gmx.net>
Cc: Andra Paraschiv <andraprs@amazon.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Alexander Popov <alex.popov@linux.com>
Signed-off-by: lixianming <lixianming5@huawei.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 net/vmw_vsock/af_vsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 92a72f0..d5df908 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1368,6 +1368,7 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 		lock_sock(sk);
 
 		if (signal_pending(current)) {
+			vsock_send_shutdown(sk, SHUTDOWN_MASK);
 			err = sock_intr_errno(timeout);
 			sk->sk_state = TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
-- 
1.8.3.1

