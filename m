Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFFE452895
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 04:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346957AbhKPDey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 22:34:54 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:48912 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347205AbhKPDd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 22:33:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UwnkGTh_1637033457;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UwnkGTh_1637033457)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Nov 2021 11:30:58 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, guwen@linux.alibaba.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH RFC net] net/smc: Ensure the active closing peer first closes clcsock
Date:   Tue, 16 Nov 2021 11:30:12 +0800
Message-Id: <20211116033011.16658-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found an issue when replacing TCP with SMC. When the actively closed
peer called close() in userspace, the clcsock of peer doesn't enter TCP
active close progress, but the passive closed peer close it first, and
enters TIME_WAIT state. It means the behavior doesn't match what we
expected. After reading RFC7609, there is no clear description of the
order in which we close clcsock during close progress.

Consider this, an application listen and accept connections, and a client
connects the server. When client actively closes the socket, the peer's
conneciton in server enters TIME_WAIT state, which means the address
is occupied and won't be reused before TIME_WAIT dismissing. The server
will be restarted failed for EADDRINUSE. Although SO_REUSEADDR can solve
this issue, but not all the applications use it. It is very common to
restart the server process for some reasons in product environment. If
we wait for TIME_WAIT dismissing, the service will be unavailable for a
long time.

Here is a simple example to reproduce this issue. Run these commands:
  server: smc_run ./sockperf server --tcp -p 12345
  client: smc_run ./sockperf pp --tcp -m 14 -i ${SERVER_IP} -t 10 -p 12345

After client benchmark finished, a TIME_WAIT connection will show up in
the server, not the client, which will occupy the address:
  tcp        0      0 100.200.30.40:12345      100.200.30.41:53010      TIME_WAIT   -

If we restart server's sockperf, it will fail for:
  sockperf: ERROR: [fd=3] Can`t bind socket, IP to bind: 0.0.0.0:12345
   (errno=98 Address already in use)

Here is the process of closing for PeerConnAbort. We can observe this
issue both in PeerConnAbort and PeerConnClosed.

Client                                                |  Server
close() // client actively close                      |
  smc_release()                                       |
      smc_close_active() // SMC_PEERCLOSEWAIT1        |
          smc_close_final() // abort or closed = 1    |
              smc_cdc_get_slot_and_msg_send()         |
          [ A ]                                       |
                                                      |smc_cdc_msg_recv_action() // SMC_ACTIVE
                                                      |  queue_work(smc_close_wq, &conn->close_work)
                                                      |    smc_close_passive_work() // SMC_PROCESSABORT or SMC_APPCLOSEWAIT1
                                                      |      smc_close_passive_abort_received() // only in abort
                                                      |
                                                      |close() // server recv zero, close
                                                      |  smc_release() // SMC_PROCESSABORT or SMC_APPCLOSEWAIT1
                                                      |    smc_close_active()
                                                      |      smc_close_abort() or smc_close_final() // SMC_CLOSED
                                                      |        smc_cdc_get_slot_and_msg_send() // abort or closed = 1
smc_cdc_msg_recv_action()                             |    smc_clcsock_release()
  queue_work(smc_close_wq, &conn->close_work)         |      sock_release(tcp) // actively close clc, enter TIME_WAIT
    smc_close_passive_work() // SMC_PEERCLOSEWAIT1    |    smc_conn_free()
      smc_close_passive_abort_received() // SMC_CLOSED|
      smc_conn_free()                                 |
      smc_clcsock_release()                           |
        sock_release(tcp) // passive close clc        |

To solve this issue, clcsock can be shutdown before the passive closed
peer closing it, to perform the TCP active close progress first. RFC7609
said the main idea of termination flows, is to terminate the normal TCP
connection in the end [1]. But there is no possible to release clcsock
before server calling sock_release(tcp), so shutdown the clcsock in [A],
which is the only place before server closing it.

Link: https://datatracker.ietf.org/doc/html/rfc7609#section-4.8.1 [1]
Fixes: b38d732477e4 ("smc: socket closing and linkgroup cleanup")
Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/smc_close.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 0f9ffba07d26..04620b53b74a 100644
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

