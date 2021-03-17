Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70E433E420
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhCQA6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230394AbhCQA5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA83C64FB2;
        Wed, 17 Mar 2021 00:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942643;
        bh=JKy01XnkOhs0NojHS5kfHMLe1XdiJ4ykRPzETY1oIzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPnYbVI3liRXotA0xhuzKQtK13MJ9mQyTuk1U+AXEI7+RSRZ+eVrp4UyZ2dt2K8g/
         3dQ8kEl/AgyrS0dWDQaYTg0QQPf+JAStJpsPPEhhLLAOrYqW+lgfMgZvSktVjN3xci
         6/NKnGWYWy4zDVGwUBRXz6tsstOZsJUFWakoby1pzhhvsYX1KxuA8G1QWtMfHq/Y9i
         bWgVz8QnUPh8kCOXDrLmKjx8skrBvpqDZoaWQOsxvAj5Yt0hH94lrX+j0lxDDMsmPj
         z2BrZVA4Bq3Gcg3JaHy0DHFftugoP/3OwH8tPcHVgB8Te2PstGMS4uBE+jkLOacaln
         8RullL3m0HjGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 23/54] net: wan: fix error return code of uhdlc_init()
Date:   Tue, 16 Mar 2021 20:56:22 -0400
Message-Id: <20210317005654.724862-23-sashal@kernel.org>
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

[ Upstream commit 62765d39553cfd1ad340124fe1e280450e8c89e2 ]

When priv->rx_skbuff or priv->tx_skbuff is NULL, no error return code of
uhdlc_init() is assigned.
To fix this bug, ret is assigned with -ENOMEM in these cases.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index dca97cd7c4e7..7eac6a3e1cde 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -204,14 +204,18 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 	priv->rx_skbuff = kcalloc(priv->rx_ring_size,
 				  sizeof(*priv->rx_skbuff),
 				  GFP_KERNEL);
-	if (!priv->rx_skbuff)
+	if (!priv->rx_skbuff) {
+		ret = -ENOMEM;
 		goto free_ucc_pram;
+	}
 
 	priv->tx_skbuff = kcalloc(priv->tx_ring_size,
 				  sizeof(*priv->tx_skbuff),
 				  GFP_KERNEL);
-	if (!priv->tx_skbuff)
+	if (!priv->tx_skbuff) {
+		ret = -ENOMEM;
 		goto free_rx_skbuff;
+	}
 
 	priv->skb_curtx = 0;
 	priv->skb_dirtytx = 0;
-- 
2.30.1

