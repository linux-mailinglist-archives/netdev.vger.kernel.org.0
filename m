Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9594C32C461
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346851AbhCDANd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:33 -0500
Received: from mga05.intel.com ([192.55.52.43]:12189 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1442620AbhCCPmG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:42:06 -0500
IronPort-SDR: D9OTeArAhYm1W5upTymbq7uXiNw5Xyxpp3yJ4w81IEcB5t7s7a0dhvCxAhGSbGTRhwvJBhjq0z
 jil6U005Ceng==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="272218012"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="272218012"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 07:39:07 -0800
IronPort-SDR: ATfSTsxIdKPFQ0MciTSQb9mrnUq+S5W/hYZwx2CnGa8K/W/D4vfVwTYL4Ig0dgyLvbvWw4IkKu
 5+tsY/FLAk5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="367645044"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga003.jf.intel.com with ESMTP; 03 Mar 2021 07:39:04 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     makita.toshiaki@lab.ntt.co.jp, daniel@iogearbox.net,
        ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf] veth: store queue_mapping independently of XDP prog presence
Date:   Wed,  3 Mar 2021 16:29:03 +0100
Message-Id: <20210303152903.11172-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, veth_xmit() would call the skb_record_rx_queue() only when
there is XDP program loaded on peer interface in native mode.

If peer has XDP prog in generic mode, then netif_receive_generic_xdp()
has a call to netif_get_rxqueue(skb), so for multi-queue veth it will
not be possible to grab a correct rxq.

To fix that, store queue_mapping independently of XDP prog presence on
peer interface.

Fixes: 638264dc9022 ("veth: Support per queue XDP ring")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/veth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index aa1a66ad2ce5..34e49c75db42 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -302,8 +302,7 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (rxq < rcv->real_num_rx_queues) {
 		rq = &rcv_priv->rq[rxq];
 		rcv_xdp = rcu_access_pointer(rq->xdp_prog);
-		if (rcv_xdp)
-			skb_record_rx_queue(skb, rxq);
+		skb_record_rx_queue(skb, rxq);
 	}
 
 	skb_tx_timestamp(skb);
-- 
2.20.1

