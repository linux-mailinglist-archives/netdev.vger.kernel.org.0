Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7450D459DF3
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhKWI3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:29:17 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:8990 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhKWI3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:29:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UxuxLHL_1637655956;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UxuxLHL_1637655956)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 23 Nov 2021 16:25:57 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net 2/2] net/smc: Ensure the active closing peer first closes clcsock
Date:   Tue, 23 Nov 2021 16:25:18 +0800
Message-Id: <20211123082515.65956-3-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211123082515.65956-1-tonylu@linux.alibaba.com>
References: <20211123082515.65956-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The side that actively closed socket, it's clcsock doesn't enter
TIME_WAIT state, but the passive side does it. It should show the same
behavior as TCP sockets.

Consider this, when client actively closes the socket, the clcsock in
server enters TIME_WAIT state, which means the address is occupied and
won't be reused before TIME_WAIT dismissing. If we restarted server, the
service would be unavailable for a long time.

To solve this issue, shutdown the clcsock in [A], perform the TCP active
close progress first, before the passive closed side closing it. So that
the actively closed side enters TIME_WAIT, not the passive one.

Client                                            |  Server
close() // client actively close                  |
  smc_release()                                   |
      smc_close_active() // PEERCLOSEWAIT1        |
          smc_close_final() // abort or closed = 1|
              smc_cdc_get_slot_and_msg_send()     |
          [A]                                     |
                                                  |smc_cdc_msg_recv_action() // ACTIVE
                                                  |  queue_work(smc_close_wq, &conn->close_work)
                                                  |    smc_close_passive_work() // PROCESSABORT or APPCLOSEWAIT1
                                                  |      smc_close_passive_abort_received() // only in abort
                                                  |
                                                  |close() // server recv zero, close
                                                  |  smc_release() // PROCESSABORT or APPCLOSEWAIT1
                                                  |    smc_close_active()
                                                  |      smc_close_abort() or smc_close_final() // CLOSED
                                                  |        smc_cdc_get_slot_and_msg_send() // abort or closed = 1
smc_cdc_msg_recv_action()                         |    smc_clcsock_release()
  queue_work(smc_close_wq, &conn->close_work)     |      sock_release(tcp) // actively close clc, enter TIME_WAIT
    smc_close_passive_work() // PEERCLOSEWAIT1    |    smc_conn_free()
      smc_close_passive_abort_received() // CLOSED|
      smc_conn_free()                             |
      smc_clcsock_release()                       |
        sock_release(tcp) // passive close clc    |

Link: https://www.spinics.net/lists/netdev/msg780407.html
Fixes: b38d732477e4 ("smc: socket closing and linkgroup cleanup")
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_close.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 9b235fbb089a..3715d2f5ad55 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -228,6 +228,12 @@ int smc_close_active(struct smc_sock *smc)
 			/* send close request */
 			rc = smc_close_final(conn);
 			sk->sk_state = SMC_PEERCLOSEWAIT1;
+
+			/* actively shutdown clcsock before peer close it,
+			 * prevent peer from entering TIME_WAIT state.
+			 */
+			if (smc->clcsock && smc->clcsock->sk)
+				rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		} else {
 			/* peer event has changed the state */
 			goto again;
-- 
2.32.0.3.g01195cf9f

