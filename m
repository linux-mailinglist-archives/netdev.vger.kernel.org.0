Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10D41EE6D0
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 16:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgFDOmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 10:42:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40374 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729025AbgFDOmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 10:42:14 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4F5EC658B41324ED289F;
        Thu,  4 Jun 2020 22:42:11 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 4 Jun 2020
 22:42:04 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <yuehaibing@huawei.com>, <weiyongjun1@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH] sunrpc: need delete xprt->timer in xs_destroy
Date:   Thu, 4 Jun 2020 22:49:10 +0800
Message-ID: <20200604144910.133756-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If RPC use udp as it's transport protocol, transport->connect_worker
will call xs_udp_setup_socket.
xs_udp_setup_socket
  sock = xs_create_sock
  if (IS_ERR(sock))
    goto out;
  out:
    xprt_unlock_connect
      xprt_schedule_autodisconnect
        mod_timer
          internal_add_timer  -->insert xprt->timer to base timer list

xs_destroy
  cancel_delayed_work_sync(&transport->connect_worker)
  xs_xprt_free(xprt)           -->free xprt

Thus use-after-free will happen.

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 net/sunrpc/xprtsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 845d0be805ec..c796808e7f7a 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1242,6 +1242,7 @@ static void xs_destroy(struct rpc_xprt *xprt)
 	dprintk("RPC:       xs_destroy xprt %p\n", xprt);

 	cancel_delayed_work_sync(&transport->connect_worker);
+	del_timer_sync(&xprt->timer);
 	xs_close(xprt);
 	cancel_work_sync(&transport->recv_worker);
 	cancel_work_sync(&transport->error_worker);
--
2.26.0.106.g9fadedd

