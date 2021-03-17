Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B639633E5E9
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhCQBU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231961AbhCQBAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 21:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 404FC64FAE;
        Wed, 17 Mar 2021 01:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942803;
        bh=796XK1fpdEtnF+BeXuqvdxkJ3JhwrCxFlzAY/6NgDkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCCGzWT/sS5W1puWTH7DVNog1sLsBjp7Nv3jc6xB12L1pig4oVEp19dWIqBR2wXlZ
         p7WjXyOYIm2/WQz+ufP/cHkv8XXZIypC9H3T4bn4FzB2ps/uSD6f/rVl2t4cwTGx0X
         IIJJZ9DhJR0px/DHsRD4+bpaWknUbkvZlY3z6QbAdFzkoGWty4GfsmqgY5v2e0B5Hg
         pm1MY2gY0q6ri8Mfz5i61vxx43uyf8SASy6KEIKVUYaF+CrYWKvdLtB1kz4Ra7RkiW
         L2mkUjOERiHqsgyKBblvA0EBxqDO4ILLq9kaEQQPFgkWwFNFYoMhRsi734YwDiGASr
         wd7toUXj4SXPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/16] atm: idt77252: fix null-ptr-dereference
Date:   Tue, 16 Mar 2021 20:59:43 -0400
Message-Id: <20210317005948.727250-12-sashal@kernel.org>
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

[ Upstream commit 4416e98594dc04590ebc498fc4e530009535c511 ]

this one is similar to the phy_data allocation fix in uPD98402, the
driver allocate the idt77105_priv and store to dev_data but later
dereference using dev->dev_data, which will cause null-ptr-dereference.

fix this issue by changing dev_data to phy_data so that PRIV(dev) can
work correctly.

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/idt77105.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
index feb023d7eebd..40644670cff2 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -261,7 +261,7 @@ static int idt77105_start(struct atm_dev *dev)
 {
 	unsigned long flags;
 
-	if (!(dev->dev_data = kmalloc(sizeof(struct idt77105_priv),GFP_KERNEL)))
+	if (!(dev->phy_data = kmalloc(sizeof(struct idt77105_priv),GFP_KERNEL)))
 		return -ENOMEM;
 	PRIV(dev)->dev = dev;
 	spin_lock_irqsave(&idt77105_priv_lock, flags);
@@ -338,7 +338,7 @@ static int idt77105_stop(struct atm_dev *dev)
                 else
                     idt77105_all = walk->next;
 	        dev->phy = NULL;
-                dev->dev_data = NULL;
+                dev->phy_data = NULL;
                 kfree(walk);
                 break;
             }
-- 
2.30.1

