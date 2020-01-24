Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C614884F
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390725AbgAXO2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:28:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405252AbgAXOVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FAD722527;
        Fri, 24 Jan 2020 14:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875675;
        bh=HBA1Sa1kde/HIZp5KczSgbLs5nHBQhTe0PfASzgy8o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Udm9SezInktJBRBlRc2GLTsuwj4hmiu2SOpXLIqFPZ/dlXbcECeZwnlRRL+uBoMR7
         A1C8cVJAnUgVuHuOuLWnTzdekIgsg4Aw+TS1tts82z0TcVJQLH1WkHs022l5gQRLZs
         YKtVv+hbYJ9cvaDmp2CEgrH0oqu271HFQG4InnYs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonglong Liu <liuyonglong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 53/56] net: hns: fix soft lockup when there is not enough memory
Date:   Fri, 24 Jan 2020 09:20:09 -0500
Message-Id: <20200124142012.29752-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 49edd6a2c456150870ddcef5b7ed11b21d849e13 ]

When there is not enough memory and napi_alloc_skb() return NULL,
the HNS driver will print error message, and than try again, if
the memory is not enough for a while, huge error message and the
retry operation will cause soft lockup.

When napi_alloc_skb() return NULL because of no memory, we can
get a warn_alloc() call trace, so this patch deletes the error
message. We already use polling mode to handle irq, but the
retry operation will render the polling weight inactive, this
patch just return budget when the rx is not completed to avoid
dead loop.

Fixes: 36eedfde1a36 ("net: hns: Optimize hns_nic_common_poll for better performance")
Fixes: b5996f11ea54 ("net: add Hisilicon Network Subsystem basic ethernet support")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 7f8cf809e02b5..024b08fafd3b2 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -569,7 +569,6 @@ static int hns_nic_poll_rx_skb(struct hns_nic_ring_data *ring_data,
 	skb = *out_skb = napi_alloc_skb(&ring_data->napi,
 					HNS_RX_HEAD_SIZE);
 	if (unlikely(!skb)) {
-		netdev_err(ndev, "alloc rx skb fail\n");
 		ring->stats.sw_err_cnt++;
 		return -ENOMEM;
 	}
@@ -1060,7 +1059,6 @@ static int hns_nic_common_poll(struct napi_struct *napi, int budget)
 		container_of(napi, struct hns_nic_ring_data, napi);
 	struct hnae_ring *ring = ring_data->ring;
 
-try_again:
 	clean_complete += ring_data->poll_one(
 				ring_data, budget - clean_complete,
 				ring_data->ex_process);
@@ -1070,7 +1068,7 @@ try_again:
 			napi_complete(napi);
 			ring->q->handle->dev->ops->toggle_ring_irq(ring, 0);
 		} else {
-			goto try_again;
+			return budget;
 		}
 	}
 
-- 
2.20.1

