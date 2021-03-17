Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4E933E5E7
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhCQBUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbhCQBAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 21:00:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23A2764FAB;
        Wed, 17 Mar 2021 01:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942801;
        bh=0gKLLVIRJWhIHFvivJy0eQKipnuQ6vBS+4w/XlrwzBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruJxBe0zw1m5lLid717QzuGTFGKOSahymjy/ypQjzk6yBEJH+gi7yInksC2OL8CYE
         uKDXmHpzMBd8p02AxrWpJGO2Q5GZ2WtRC6UR5oABqwCLXfp2Yw+Ir/rJoDMILIEXh1
         tWiYehmq4gmNOaMGpdIhoG56kRWBD5hDihPEPTZuM9ipTfBeC1BVCkjzj2oQgY5NEZ
         w73I+/KkMYTzgDe40jP48qasGX6yw1Fn4yi0443AUn305yLNLEcpnVSvmBEkDpC59M
         UsfJvZ//zK3e4bw5++T49COYdHD9CKpyAO8SXP3v2ycF7+nNTo5StcTpAhlqnf54ut
         R4ophIZmM78kQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/16] atm: uPD98402: fix incorrect allocation
Date:   Tue, 16 Mar 2021 20:59:42 -0400
Message-Id: <20210317005948.727250-11-sashal@kernel.org>
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

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 3153724fc084d8ef640c611f269ddfb576d1dcb1 ]

dev->dev_data is set in zatm.c, calling zatm_start() will overwrite this
dev->dev_data in uPD98402_start() and a subsequent PRIV(dev)->lock
(i.e dev->phy_data->lock) will result in a null-ptr-dereference.

I believe this is a typo and what it actually want to do is to allocate
phy_data instead of dev_data.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/uPD98402.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/uPD98402.c b/drivers/atm/uPD98402.c
index 5120a96b3a89..b2f4e8df1591 100644
--- a/drivers/atm/uPD98402.c
+++ b/drivers/atm/uPD98402.c
@@ -210,7 +210,7 @@ static void uPD98402_int(struct atm_dev *dev)
 static int uPD98402_start(struct atm_dev *dev)
 {
 	DPRINTK("phy_start\n");
-	if (!(dev->dev_data = kmalloc(sizeof(struct uPD98402_priv),GFP_KERNEL)))
+	if (!(dev->phy_data = kmalloc(sizeof(struct uPD98402_priv),GFP_KERNEL)))
 		return -ENOMEM;
 	spin_lock_init(&PRIV(dev)->lock);
 	memset(&PRIV(dev)->sonet_stats,0,sizeof(struct k_sonet_stats));
-- 
2.30.1

