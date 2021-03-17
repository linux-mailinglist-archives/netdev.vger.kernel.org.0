Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D420B33E4EE
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhCQBAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhCQA7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBD4364FBC;
        Wed, 17 Mar 2021 00:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942750;
        bh=UwteTIvtz0sz7yz6zNFbrqtuV5n3YUzbwKmK4nWPcpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LV+t5LRBYfwp8UqwNtHf71Zz/EjsxFSQwG4aObCUUDfJ877nDH6gjOnIGk8vVbptJ
         oBCJdbuEAr1Ru9kJ3mLN9JayjFeSSUi6B6kaNxav5D8FaFJaG0ROi4JP2x9HrD/Mox
         WYqSnMI4IlzEI+EV0jVwazq4V9NEmG4fbKEdwmaQ61INCVI0J0qzVbLojZAquJE0Q5
         Vv6xJMUnWfoxT/2WJs13fdR4yKqg6OQzwsFzhGv81qscmgw1qBBh9+mUNRF0QnqXbO
         G/PcuWLVaH1etZ7RS8bNk2AXDS++RJe/jvl530hIl3sNZPD++GXOxuKW6kySiSKwrr
         IQauEShnlLp6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/23] atm: idt77252: fix null-ptr-dereference
Date:   Tue, 16 Mar 2021 20:58:42 -0400
Message-Id: <20210317005850.726479-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
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
index 0a67487c0b1d..a2ecb4190f78 100644
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
@@ -336,7 +336,7 @@ static int idt77105_stop(struct atm_dev *dev)
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

