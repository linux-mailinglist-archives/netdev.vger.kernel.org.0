Return-Path: <netdev+bounces-11251-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E12973239C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 01:28:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2946B2815A0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 23:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 769A416418;
	Thu, 15 Jun 2023 23:28:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA1C7464
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 23:28:27 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id B26392D57;
	Thu, 15 Jun 2023 16:28:02 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
	id CFA5B20FEB80; Thu, 15 Jun 2023 16:28:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CFA5B20FEB80
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
	s=default; t=1686871681;
	bh=y5V7yYuG8e/yBxteubjXicX8w1FBL0ThXqAOOQJhXdo=;
	h=From:To:Cc:Subject:Date:From;
	b=stBKByQKzI7m1IOjy7UOte9NtqAsQw8X/9BlGGKRqWUrmNT1ZSKuLJ9p/BJg1bM+u
	 V5C+XxZgkJCn/ZxEjfBMWsN+dQ0x2O4bL7+9G7KDE7LdBG5sXSuRcDD8jS0wxL3fMn
	 KuuCL9G9EV8bUR4NuI65/AdC4J5fayC1KWKp90QU=
From: longli@linuxonhyperv.com
To: "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Ajay Sharma <sharmaajay@microsoft.com>,
	Shachar Raindel <shacharr@microsoft.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linux-rdma@vger.kernel.org,
	Long Li <longli@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] net: mana: Batch ringing RX queue doorbell on receiving packets
Date: Thu, 15 Jun 2023 16:27:51 -0700
Message-Id: <1686871671-31110-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

From: Long Li <longli@microsoft.com>

It's inefficient to ring the doorbell page every time a WQE is posted to
the received queue.

Move the code for ringing doorbell page to where after we have posted all
WQEs to the receive queue during a callback from napi_poll().

Tests showed no regression in network latency benchmarks.

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index cd4d5ceb9f2d..ef1f0ce8e44d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1383,8 +1383,8 @@ static void mana_post_pkt_rxq(struct mana_rxq *rxq)
 
 	recv_buf_oob = &rxq->rx_oobs[curr_index];
 
-	err = mana_gd_post_and_ring(rxq->gdma_rq, &recv_buf_oob->wqe_req,
-				    &recv_buf_oob->wqe_inf);
+	err = mana_gd_post_work_request(rxq->gdma_rq, &recv_buf_oob->wqe_req,
+					&recv_buf_oob->wqe_inf);
 	if (WARN_ON_ONCE(err))
 		return;
 
@@ -1654,6 +1654,12 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 		mana_process_rx_cqe(rxq, cq, &comp[i]);
 	}
 
+	if (comp_read) {
+		struct gdma_context *gc = rxq->gdma_rq->gdma_dev->gdma_context;
+
+		mana_gd_wq_ring_doorbell(gc, rxq->gdma_rq);
+	}
+
 	if (rxq->xdp_flush)
 		xdp_do_flush();
 }
-- 
2.34.1


