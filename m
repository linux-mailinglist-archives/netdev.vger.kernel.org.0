Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEB033E4AD
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhCQBAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhCQA6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 757AC64F9B;
        Wed, 17 Mar 2021 00:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942704;
        bh=tWzXLqLFeCg+r8O7j+Mj92xWOjji27OrUSvrXL2dalE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCNU/LdPp9VlQh3IX2gaGbNHVsOT8QyDAglsSLsiO+PX6ZzyvjH2y9IMGaKDbCT4w
         dB8zJE36SNDSi1Syom+avagvpoD5KNAciF6fH3PrtgwZC484vq5LqJvV84JF8xLdH0
         tti6YXoj/FMEefAcQIwrXrnRwbeBp6xUyTBNamvQ5hUCxDtaCeGOaYfzu9B7K6RCp3
         DZMAz/q2Bq62xTHsXJ65rjJZDw+CVmzTpEuINnMfrGIZ5NowrjAoWT9LJxukqKSaOk
         68AVUiVXmT4JghZoEAb1564xK2TZ7C/uUwGdxpP0wz6d1dmX3aoXeAqgxVKSxq2p1R
         +yM63iGcSCi6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/37] net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()
Date:   Tue, 16 Mar 2021 20:57:42 -0400
Message-Id: <20210317005802.725825-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 143c253f42bad20357e7e4432087aca747c43384 ]

When hns_assemble_skb() returns NULL to skb, no error return code of
hns_nic_clear_all_rx_fetch() is assigned.
To fix this bug, ret is assigned with -ENOMEM in this case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 6d5d53cfc7ab..7516f6823090 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1677,8 +1677,10 @@ static int hns_nic_clear_all_rx_fetch(struct net_device *ndev)
 			for (j = 0; j < fetch_num; j++) {
 				/* alloc one skb and init */
 				skb = hns_assemble_skb(ndev);
-				if (!skb)
+				if (!skb) {
+					ret = -ENOMEM;
 					goto out;
+				}
 				rd = &tx_ring_data(priv, skb->queue_mapping);
 				hns_nic_net_xmit_hw(ndev, skb, rd);
 
-- 
2.30.1

