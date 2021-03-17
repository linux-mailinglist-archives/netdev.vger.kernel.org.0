Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDA833E439
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhCQA6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231671AbhCQA53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B048264FB5;
        Wed, 17 Mar 2021 00:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942648;
        bh=LMlAkPh0AFAChpebs9ayhYBjTS7ZxN6DVOA23qX1478=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJTIFEQ/LWnAi5KGEkoO94ajWcHWlcUeO6PvXzBsmstSTUplz2WEit++cpzuVq/ai
         Ty+Ern7UAoE5Q16QM2H3y0qt2dmKlQ2VaUhOEdXEJ4KS0z8Mvbz/3jdWvCoRy1h32i
         aQtFissygBtMBi2De/zGc7Xy+kUagyG4itXeodjuaQlz8a3HTrRrD6R754iAt9ZDPY
         w9QKWTTzjHYqqdn1pVxFfu0HUpEJ+8EzxpTrUA57DlLHTQ9Iu6soEQ67b3pFZtynnB
         qZBb/jfBD2uZPn0QpJ6ctTJfkK/vgP4AFIaAVwAUYvEIOljMYtxsbEqTP2FI2Re0yE
         ru32gkK5c/NCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/54] atm: idt77252: fix null-ptr-dereference
Date:   Tue, 16 Mar 2021 20:56:26 -0400
Message-Id: <20210317005654.724862-27-sashal@kernel.org>
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
index 3c081b6171a8..bfca7b8a6f31 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -262,7 +262,7 @@ static int idt77105_start(struct atm_dev *dev)
 {
 	unsigned long flags;
 
-	if (!(dev->dev_data = kmalloc(sizeof(struct idt77105_priv),GFP_KERNEL)))
+	if (!(dev->phy_data = kmalloc(sizeof(struct idt77105_priv),GFP_KERNEL)))
 		return -ENOMEM;
 	PRIV(dev)->dev = dev;
 	spin_lock_irqsave(&idt77105_priv_lock, flags);
@@ -337,7 +337,7 @@ static int idt77105_stop(struct atm_dev *dev)
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

