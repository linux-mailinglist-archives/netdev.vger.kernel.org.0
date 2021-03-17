Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC4833E37D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhCQA4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230343AbhCQA4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81DF564F97;
        Wed, 17 Mar 2021 00:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942571;
        bh=LMlAkPh0AFAChpebs9ayhYBjTS7ZxN6DVOA23qX1478=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvwccTn30YWgztbuZkXoSdtb0RYrM1I5PVrAxI4U405gIdvYnY5sA/b0VNEtaCfrn
         OgFtIU/MmtsxBVhVsNud9SwlI4rHsKu534J5uep3veozHt8ngoSilvKMCPTu0nWGTr
         Vi887xXbl4q4ywcR6Cd3IFdlfjaaseI4gQW8VxT6mWJ5KsBX8jb3eV6A0WD3P92+iI
         MREk+sqhzgrhBbsYH3FsyrDxqanxklxf39lyredDL1rXkG4VdxaVpo74uZsWgwOACc
         w/vrwlCLPiKHZlnlxFl5l5jEMVnwxSeOiEEXSNzIJgIqGP7q9P3rGWBa6ybgRJVqy8
         mgtoXHCn04Nww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 28/61] atm: idt77252: fix null-ptr-dereference
Date:   Tue, 16 Mar 2021 20:55:02 -0400
Message-Id: <20210317005536.724046-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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

