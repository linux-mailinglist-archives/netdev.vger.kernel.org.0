Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9E2A2404
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbfH2SUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730268AbfH2SR4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:17:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FECB2339E;
        Thu, 29 Aug 2019 18:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102675;
        bh=WvX0U4icaaEEXMxXwS+pXS/PsVEOeUNZ91BSFI8Xez0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liiaSk/qZPqhSEtXcaMwDc/aBvT0CogHszdDHF/qkDQLhlAdthCDa7x2CtmKx14fr
         gJvZGwxB4LegtuKobu24JPLu+/Q3fzb0hb0zSV1n2RX2rBJPqNxtNQ+dVL/XoRn3+i
         xw0QuFAuFeSC1V8pgsDTkvV3dr2M0B5+uonC9TJc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tho Vu <tho.vu.wh@rvc.renesas.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/16] ravb: Fix use-after-free ravb_tstamp_skb
Date:   Thu, 29 Aug 2019 14:17:29 -0400
Message-Id: <20190829181736.9040-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181736.9040-1-sashal@kernel.org>
References: <20190829181736.9040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tho Vu <tho.vu.wh@rvc.renesas.com>

[ Upstream commit cfef46d692efd852a0da6803f920cc756eea2855 ]

When a Tx timestamp is requested, a pointer to the skb is stored in the
ravb_tstamp_skb struct. This was done without an skb_get. There exists
the possibility that the skb could be freed by ravb_tx_free (when
ravb_tx_free is called from ravb_start_xmit) before the timestamp was
processed, leading to a use-after-free bug.

Use skb_get when filling a ravb_tstamp_skb struct, and add appropriate
frees/consumes when a ravb_tstamp_skb struct is freed.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Tho Vu <tho.vu.wh@rvc.renesas.com>
Signed-off-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 480883a7a3e5e..545cb6262cffd 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1,6 +1,6 @@
 /* Renesas Ethernet AVB device driver
  *
- * Copyright (C) 2014-2015 Renesas Electronics Corporation
+ * Copyright (C) 2014-2019 Renesas Electronics Corporation
  * Copyright (C) 2015 Renesas Solutions Corp.
  * Copyright (C) 2015-2016 Cogent Embedded, Inc. <source@cogentembedded.com>
  *
@@ -512,7 +512,10 @@ static void ravb_get_tx_tstamp(struct net_device *ndev)
 			kfree(ts_skb);
 			if (tag == tfa_tag) {
 				skb_tstamp_tx(skb, &shhwtstamps);
+				dev_consume_skb_any(skb);
 				break;
+			} else {
+				dev_kfree_skb_any(skb);
 			}
 		}
 		ravb_modify(ndev, TCCR, TCCR_TFR, TCCR_TFR);
@@ -1537,7 +1540,7 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 					 DMA_TO_DEVICE);
 			goto unmap;
 		}
-		ts_skb->skb = skb;
+		ts_skb->skb = skb_get(skb);
 		ts_skb->tag = priv->ts_skb_tag++;
 		priv->ts_skb_tag &= 0x3ff;
 		list_add_tail(&ts_skb->list, &priv->ts_skb_list);
@@ -1665,6 +1668,7 @@ static int ravb_close(struct net_device *ndev)
 	/* Clear the timestamp list */
 	list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
 		list_del(&ts_skb->list);
+		kfree_skb(ts_skb->skb);
 		kfree(ts_skb);
 	}
 
-- 
2.20.1

