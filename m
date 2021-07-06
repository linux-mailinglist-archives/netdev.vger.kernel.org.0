Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3093BD1BB
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238819AbhGFLkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237546AbhGFLgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 793F361F13;
        Tue,  6 Jul 2021 11:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570912;
        bh=/1DxIzdu2I8YZvbwJmOdwa9XWLbV5hRbsdG2ft7UI1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fy9D6Nu8dyE/uZSO/ptrH50VxzgfJvNwUXS86YMsGGMrjt3svtXaOD/V1JJZQEBaa
         rdqofGtiU/3Uk/TmiC2p6OJNvP9/7QhLpWdVDTbzn75kJhP469jcQKU+viOw29eeKD
         hnZwey8WVY+xCAcdLyjZirO2a0MJqIoOFB+v/j4NC7FugGiFIcD3IRKoHBe2KmZmb7
         i7IFivsFzZCRDarlOZUyQOWlUtsGRC/1ur6T0SkoXG2QXj0xZA+gYBsLdTd51Qt3Ic
         Lx2A1vr/WFgCLHxVG7Dq1SI48Kobl+2MB4f//QqvQ5w3uSP3QPSTryKf3KPQ97vits
         +QpBdAKtTNpJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        David Brazdil <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        lixianming <lixianming5@huawei.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 34/45] vsock: notify server to shutdown when client has pending signal
Date:   Tue,  6 Jul 2021 07:27:38 -0400
Message-Id: <20210706112749.2065541-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112749.2065541-1-sashal@kernel.org>
References: <20210706112749.2065541-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Longpeng(Mike)" <longpeng2@huawei.com>

[ Upstream commit c7ff9cff70601ea19245d997bb977344663434c7 ]

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
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ae85a5e5648b..02a171916dd2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1232,7 +1232,7 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 
 		if (signal_pending(current)) {
 			err = sock_intr_errno(timeout);
-			sk->sk_state = TCP_CLOSE;
+			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
 			vsock_transport_cancel_pkt(vsk);
 			goto out_wait;
-- 
2.30.2

