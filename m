Return-Path: <netdev+bounces-1508-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E956FE0BF
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:48:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81CCE2814DB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEEC14ABF;
	Wed, 10 May 2023 14:47:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DB8111B9
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:47:56 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B678CE7E;
	Wed, 10 May 2023 07:47:53 -0700 (PDT)
Received: from dggpemm100003.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QGchT74PCzsRGV;
	Wed, 10 May 2023 22:23:37 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm100003.china.huawei.com (7.185.36.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 22:25:30 +0800
Received: from huawei.com (10.175.104.170) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 10 May
 2023 22:25:30 +0800
From: Zhuang Shengen <zhuangshengen@huawei.com>
To: <sgarzare@redhat.com>
CC: <virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<arei.gonglei@huawei.com>, <longpeng2@huawei.com>, <jianjay.zhou@huawei.com>
Subject: [PATCH] vsock: bugfix port residue in server
Date: Wed, 10 May 2023 22:25:02 +0800
Message-ID: <20230510142502.2293109-1-zhuangshengen@huawei.com>
X-Mailer: git-send-email 2.23.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.104.170]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When client and server establish a connection through vsock,
the client send a request to the server to initiate the connection,
then start a timer to wait for the server's response. When the server's
RESPONSE message arrives, the timer also times out and exits. The
server's RESPONSE message is processed first, and the connection is
established. However, the client's timer also times out, the original
processing logic of the client is to directly set the state of this vsock
to CLOSE and return ETIMEDOUT, User will release the port. It will not
notify the server when the port is released, causing the server port remain

when client's vsock_connect timeout，it should check sk state is
ESTABLISHED or not. if sk state is ESTABLISHED, it means the connection
is established, the client should not set the sk state to CLOSE

Note: I encountered this issue on kernel-4.18, which can be fixed by
this patch. Then I checked the latest code in the community
and found similar issue.

Signed-off-by: Zhuang Shengen <zhuangshengen@huawei.com>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 413407bb646c..efb8a0937a13 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1462,7 +1462,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 			vsock_transport_cancel_pkt(vsk);
 			vsock_remove_connected(vsk);
 			goto out_wait;
-		} else if (timeout == 0) {
+		} else if ((sk->sk_state != TCP_ESTABLISHED) && (timeout == 0)) {
 			err = -ETIMEDOUT;
 			sk->sk_state = TCP_CLOSE;
 			sock->state = SS_UNCONNECTED;
-- 
2.27.0


