Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0535270AB
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 12:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiENK2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 06:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiENK2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 06:28:00 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89C33917B;
        Sat, 14 May 2022 03:27:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VD6nQif_1652524074;
Received: from localhost.localdomain(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VD6nQif_1652524074)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 14 May 2022 18:27:54 +0800
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v2 2/2] net/smc: rdma write inline if qp has sufficient inline space
Date:   Sat, 14 May 2022 18:27:39 +0800
Message-Id: <20220514102739.41252-3-guangguan.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220514102739.41252-1-guangguan.wang@linux.alibaba.com>
References: <20220514102739.41252-1-guangguan.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rdma write with inline flag when sending small packages,
whose length is shorter than the qp's max_inline_data, can
help reducing latency.

In my test environment, which are 2 VMs running on the same
physical host and whose NICs(ConnectX-4Lx) are working on
SR-IOV mode, qperf shows 0.5us-0.7us improvement in latency.

Test command:
server: smc_run taskset -c 1 qperf
client: smc_run taskset -c 1 qperf <server ip> -oo \
		msg_size:1:2K:*2 -t 30 -vu tcp_lat

The results shown below:
msgsize     before       after
1B          11.2 us      10.6 us (-0.6 us)
2B          11.2 us      10.7 us (-0.5 us)
4B          11.3 us      10.7 us (-0.6 us)
8B          11.2 us      10.6 us (-0.6 us)
16B         11.3 us      10.7 us (-0.6 us)
32B         11.3 us      10.6 us (-0.7 us)
64B         11.2 us      11.2 us (0 us)
128B        11.2 us      11.2 us (0 us)
256B        11.2 us      11.2 us (0 us)
512B        11.4 us      11.3 us (-0.1 us)
1KB         11.4 us      11.5 us (0.1 us)
2KB         11.5 us      11.5 us (0 us)

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
---
 net/smc/smc_tx.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 98ca9229fe87..805a546e8c04 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -391,12 +391,20 @@ static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
 	int rc;
 
 	for (dstchunk = 0; dstchunk < 2; dstchunk++) {
-		struct ib_sge *sge =
-			wr_rdma_buf->wr_tx_rdma[dstchunk].wr.sg_list;
+		struct ib_rdma_wr *wr = &wr_rdma_buf->wr_tx_rdma[dstchunk];
+		struct ib_sge *sge = wr->wr.sg_list;
+		u64 base_addr = dma_addr;
+
+		if (dst_len < link->qp_attr.cap.max_inline_data) {
+			base_addr = (uintptr_t)conn->sndbuf_desc->cpu_addr;
+			wr->wr.send_flags |= IB_SEND_INLINE;
+		} else {
+			wr->wr.send_flags &= ~IB_SEND_INLINE;
+		}
 
 		num_sges = 0;
 		for (srcchunk = 0; srcchunk < 2; srcchunk++) {
-			sge[srcchunk].addr = dma_addr + src_off;
+			sge[srcchunk].addr = base_addr + src_off;
 			sge[srcchunk].length = src_len;
 			num_sges++;
 
@@ -410,8 +418,7 @@ static int smcr_tx_rdma_writes(struct smc_connection *conn, size_t len,
 			src_len = dst_len - src_len; /* remainder */
 			src_len_sum += src_len;
 		}
-		rc = smc_tx_rdma_write(conn, dst_off, num_sges,
-				       &wr_rdma_buf->wr_tx_rdma[dstchunk]);
+		rc = smc_tx_rdma_write(conn, dst_off, num_sges, wr);
 		if (rc)
 			return rc;
 		if (dst_len_sum == len)
-- 
2.24.3 (Apple Git-128)

