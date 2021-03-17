Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5678333E4FC
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhCQBBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230475AbhCQA7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7980964F94;
        Wed, 17 Mar 2021 00:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942777;
        bh=rVIQyEFnbYpmwe2tL+21fMnvaa1ETVEjQcbRrNQkT+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On5gsGQQw7jg21x4SNmi5G4Zzwzc0lC32VEAKkVvxRcWZnNSK8Sx2Y6T0ikPBNGO6
         6rLzCJ9LoveWVRbqfdw91OpsBVT6lLn7/vt43fsHdypAI8vvcY1AVT9sbiPRTYttX7
         MmJA7+OcXbdoka+o7O1jUPCNeY4D0RLgx9aMG6wBVnbW4S4FR7laHyJVpkP4FzJWBA
         rhXS6PA98prhzkTIDvhqNhwa/Rvd6waATuArYiW0UevVhD6CQR9XfJo2GWY787k9/l
         KEHlcue5KjBmqSBXMNg4mOyvrbHJT6Fgni8+CgGw1lpK4qDk2PYZ43lksqF0Xja1Jl
         ZPQY6DkcGxqvA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 13/21] net: wan: fix error return code of uhdlc_init()
Date:   Tue, 16 Mar 2021 20:59:12 -0400
Message-Id: <20210317005920.726931-13-sashal@kernel.org>
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
index 6a26cef62193..978f642daced 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -200,13 +200,17 @@ static int uhdlc_init(struct ucc_hdlc_private *priv)
 
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

