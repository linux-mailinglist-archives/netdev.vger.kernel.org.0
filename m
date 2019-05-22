Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C3426FDF
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731130AbfEVT7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730034AbfEVTXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:23:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C39E21473;
        Wed, 22 May 2019 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553002;
        bh=QePx1IMak/j1YkCE6t2wjbBLa/k4asf6AK8gETWFaGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiJfk4gRAVwwrliMb2Oi9lMvlMrZQX76LLW24yzHfWatDX2Cfy7iABclH8c1w9ztS
         8usCGbkGLPNEWPTejB5s4gkgucqt5QQPloH7NV3KLAEpzR9tquKtW8qImsiW1u7Rod
         NZmUKdubpKu5nbRKo2JhCJhIKOIvMo5uJrpyD7W0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 070/375] net: hns3: fix for TX clean num when cleaning TX BD
Date:   Wed, 22 May 2019 15:16:10 -0400
Message-Id: <20190522192115.22666-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 63380a1ae4ced8aef67659ff9547c69ef8b9613a ]

hns3_desc_unused() returns how many BD have been cleaned, but new
buffer has not been attached to them. The register of
HNS3_RING_RX_RING_FBDNUM_REG returns how many BD need allocating new
buffer to or need to cleaned. So the remaining BD need to be clean
is HNS3_RING_RX_RING_FBDNUM_REG - hns3_desc_unused().

Also, new buffer can not attach to the pending BD when the last BD is
not handled, because memcpy has not been done on the first pending BD.

This patch fixes by subtracting the pending BD num from unused_count
after 'HNS3_RING_RX_RING_FBDNUM_REG - unused_count' is used to calculate
the BD bum need to be clean.

Fixes: e55970950556 ("net: hns3: Add handling of GRO Pkts not fully RX'ed in NAPI poll")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 162cb9afa0e70..0208efe282775 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2705,7 +2705,7 @@ int hns3_clean_rx_ring(
 #define RCB_NOF_ALLOC_RX_BUFF_ONCE 16
 	struct net_device *netdev = ring->tqp->handle->kinfo.netdev;
 	int recv_pkts, recv_bds, clean_count, err;
-	int unused_count = hns3_desc_unused(ring) - ring->pending_buf;
+	int unused_count = hns3_desc_unused(ring);
 	struct sk_buff *skb = ring->skb;
 	int num;
 
@@ -2714,6 +2714,7 @@ int hns3_clean_rx_ring(
 
 	recv_pkts = 0, recv_bds = 0, clean_count = 0;
 	num -= unused_count;
+	unused_count -= ring->pending_buf;
 
 	while (recv_pkts < budget && recv_bds < num) {
 		/* Reuse or realloc buffers */
-- 
2.20.1

