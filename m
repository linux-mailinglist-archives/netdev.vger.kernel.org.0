Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE7433E41C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhCQA6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231624AbhCQA5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1F6264FAB;
        Wed, 17 Mar 2021 00:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942642;
        bh=BSr895P/4B6mnzqN/TdgGbsmYiKqVrNY3F2oEovtnLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EW18qPztyl7t/KPBg+ORD2z9WM1Hb3MdTiW3xAnIcyPXTpqF4tbC0uvSpDpfVw0eV
         RSiAypW96b1nHZtiqiGApLVVahuFzlmVIbJ9ABQ12BAArS6FwWnJIJxMs7U8DOAhdj
         jdeQ2veRTrPIfbplmzeUkAHKjItE9nX2+INhGOb7ubv5q12P/duOBHzsqZ5O3Kx6er
         1VXiBqaVWDODtB0yY4wEfK1hKY9VCMhFv0eB4yjwvF+JW/2esTRbZeqGhJfZ9P/NsY
         GkY3gJFlOFXZnPwl2ORUT8DMcIi1gs+9jKZ6ucpfqWkfaKJTbRDOcqzu6zCagdhB+W
         iLDMLTx3ZN2og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/54] net: hisilicon: hns: fix error return code of hns_nic_clear_all_rx_fetch()
Date:   Tue, 16 Mar 2021 20:56:21 -0400
Message-Id: <20210317005654.724862-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index 858cb293152a..8bce5f1510be 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1663,8 +1663,10 @@ static int hns_nic_clear_all_rx_fetch(struct net_device *ndev)
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

