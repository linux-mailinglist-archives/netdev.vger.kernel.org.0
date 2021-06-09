Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01043A1439
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhFIMYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:24:41 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:34703 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230169AbhFIMYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 08:24:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UbrrQTa_1623241364;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UbrrQTa_1623241364)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Jun 2021 20:22:44 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org
Subject: [PATCH net] ixgbe: xsk: fix for metasize when construct skb by xdp_buff
Date:   Wed,  9 Jun 2021 20:22:44 +0800
Message-Id: <20210609122244.52647-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should copy data_meta to the skb space.  Then use __skb_pull to
correct skb->data

Fixes: d0bcacd0a1309 ("ixgbe: add AF_XDP zero-copy Rx support")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index f72d2978263b..ee88107fa57a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -204,7 +204,7 @@ static struct sk_buff *ixgbe_construct_skb_zc(struct ixgbe_ring *rx_ring,
 					      struct ixgbe_rx_buffer *bi)
 {
 	unsigned int metasize = bi->xdp->data - bi->xdp->data_meta;
-	unsigned int datasize = bi->xdp->data_end - bi->xdp->data;
+	unsigned int datasize = bi->xdp->data_end - bi->xdp->data_meta;
 	struct sk_buff *skb;
 
 	/* allocate a skb to store the frags */
@@ -214,10 +214,12 @@ static struct sk_buff *ixgbe_construct_skb_zc(struct ixgbe_ring *rx_ring,
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, bi->xdp->data - bi->xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), bi->xdp->data, datasize);
-	if (metasize)
+	skb_reserve(skb, bi->xdp->data_meta - bi->xdp->data_hard_start);
+	memcpy(__skb_put(skb, datasize), bi->xdp->data_meta, datasize);
+	if (metasize) {
+		__skb_pull(skb, metasize);
 		skb_metadata_set(skb, metasize);
+	}
 
 	xsk_buff_free(bi->xdp);
 	bi->xdp = NULL;
-- 
2.31.0

