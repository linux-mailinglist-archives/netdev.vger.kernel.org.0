Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1141D33E554
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhCQBC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231510AbhCQBAB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 21:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F042D64FA5;
        Wed, 17 Mar 2021 00:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942800;
        bh=z6fjfAWkHbVDLjL2M6xlYkNM70LTzfCTKgvyHQgM7V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffyHpi3YSY2dDKAbhuHJd4UBJHuKJ37aJlgRNmhhdYYT+8sfCkI+QlNMIBdT8Ka28
         z3OQ/0Natr1WjQQL7lIjH6681o7qjrk4IMZgfsHahc61qJDj3PQEBTEZJ4SBhaTrF+
         YUqjH6yrecO6p0guCdn+kbNK1HaF9PxEO4dOVrNaasuhnZU646guIHW8pJA3HGEfya
         +VI3piv7ShR/qW+nK7OFwEnyo0Lh7xNSWmSaQI4QfYbDFaJv+4vkN/RsGrsVCYgHws
         0x3PMdNbhrQhs/ymXhjvJ/C6knncOXZUxwinF46C8R7q8HMAi4MCuOHEY6CS1HabLq
         bf/z7qvNK8fcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 10/16] net: wan: fix error return code of uhdlc_init()
Date:   Tue, 16 Mar 2021 20:59:41 -0400
Message-Id: <20210317005948.727250-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005948.727250-1-sashal@kernel.org>
References: <20210317005948.727250-1-sashal@kernel.org>
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
index 87bf05a81db5..fc7d28edee07 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -169,13 +169,17 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 
 	priv->rx_skbuff = kzalloc(priv->rx_ring_size * sizeof(*priv->rx_skbuff),
 				  GFP_KERNEL);
-	if (!priv->rx_skbuff)
+	if (!priv->rx_skbuff) {
+		ret = -ENOMEM;
 		goto free_ucc_pram;
+	}
 
 	priv->tx_skbuff = kzalloc(priv->tx_ring_size * sizeof(*priv->tx_skbuff),
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

