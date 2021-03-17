Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9B233E4A8
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhCQBAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhCQA6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98F2E64FE3;
        Wed, 17 Mar 2021 00:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942705;
        bh=5rv8c7kyMAxRJg+yYsF27054nnZTHkRMZa1i7Aw+PRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqNizwQonB1vTVOfVd2xtg1oLlf57qtQVZxk7qcxrWzRGT6LMlNT6yU2v66UIDaAz
         +ULc3iHR8eowaIQYhT/Z4d9h+ui5PEiDA5iURmigl3vq+NCLJtL0m2WxNvF6We45YJ
         SGyj6kbCcPbTwLj8uhi4QbhRxyplTFi/m3qfQ53Wo0DDYpQlrN2LdketpIi3xLKFMs
         HGHPsWkoIUFJX6n8t79GuFKbzOhhhX8lH4rU3HtWViro7z3YRMI6XeGTDDiIDyk07v
         c7XLuVrJYrLnbo3J97IilCcQalqQFuBuTtgA1NMK/bcAN3vuOjdGFUXQZn6GsGM8ei
         72NNnhhS7bNOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 18/37] net: wan: fix error return code of uhdlc_init()
Date:   Tue, 16 Mar 2021 20:57:43 -0400
Message-Id: <20210317005802.725825-18-sashal@kernel.org>
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
index 4ad0a0c33d85..034eb6535ab7 100644
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

