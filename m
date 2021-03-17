Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FA633E4FB
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhCQBBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232416AbhCQA7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BB2E64F9F;
        Wed, 17 Mar 2021 00:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942776;
        bh=fyZ1ZSaaU2VAVPJMoW4W66mZdGkVec3swcOb/IRYutE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUir1GwOwA9v3qMfb3+zQzicZpa9quxYFhiHJZhbB3LToPTHyJdt1rAhCogrNnMtj
         9ue+9UwidSrD/l3RwR//I/Ww1/OdS5i0/PWMW/CmPAsH/PYKfXQ16jJSqx2kzmzRsJ
         fVg3aHUox3eeD+hVSmGp0gqCKHqJ/ZRceEOGansj14YnSPm4cvUMHAoykMk5mxxYuo
         h98OBXWtayG2hef6niPNofBhlQMVnQ6AMy75rcrtL5HlpoC/I8JW7L5MROPybXe/HF
         smScaNq1myRcHc4RqgFpPTU61vYsFjxiuL4q//1r0GaDhMWA8y7t4DxlJm+HNcwKDU
         XjEQ2CYzc03lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/21] net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()
Date:   Tue, 16 Mar 2021 20:59:11 -0400
Message-Id: <20210317005920.726931-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005920.726931-1-sashal@kernel.org>
References: <20210317005920.726931-1-sashal@kernel.org>
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
index af832929ae28..5ddc09e9b5a6 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1812,8 +1812,10 @@ static int hns_nic_clear_all_rx_fetch(struct net_device *ndev)
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

