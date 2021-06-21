Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE0D3AE31A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhFUG2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:28:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:7372 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFUG2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 02:28:51 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G7fZn6Zg9z70qM;
        Mon, 21 Jun 2021 14:22:25 +0800 (CST)
Received: from dggpeml500016.china.huawei.com (7.185.36.70) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 21 Jun 2021 14:26:22 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml500016.china.huawei.com (7.185.36.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 21 Jun 2021 14:26:22 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <arei.gonglei@huawei.com>, "Longpeng(Mike)" <longpeng2@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Jorgen Hansen" <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "Andra Paraschiv" <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        David Brazdil <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        lixianming <lixianming5@huawei.com>
Subject: [PATCH v2] vsock: notify server to shutdown when client has pending signal
Date:   Mon, 21 Jun 2021 14:26:01 +0800
Message-ID: <20210621062601.1473-1-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500016.china.huawei.com (7.185.36.70)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The client's sk_state will be set to TCP_ESTABLISHED if the server
replay the client's connect request.

However, if the client has pending signal, its sk_state will be set
to TCP_CLOSE without notify the server, so the server will hold the
corrupt connection.

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
		return true; *return at here, the server cannot notice the connection is corrupt*

So the client should notify the peer in this case.

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Norbert Slusarek <nslusarek@gmx.net>
Cc: Andra Paraschiv <andraprs@amazon.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Alexander Popov <alex.popov@linux.com>
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lkml.org/lkml/2021/5/17/418
Signed-off-by: lixianming <lixianming5@huawei.com>
Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 92a72f0..ae11311 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1369,7 +1369,7 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 
 		if (signal_pending(current)) {
 			err = sock_intr_errno(timeout);
-			sk->sk_state = TCP_CLOSE;
+			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
 			goto out_wait;
-- 
1.8.3.1

