Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9494076F6
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbhIKNOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:14:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236320AbhIKNNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:13:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 461EE61205;
        Sat, 11 Sep 2021 13:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365947;
        bh=Sc7IrYUdW9e7DN014nitCZ8pyHwS29QuWqPj45AfNos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMFYQmu7sptqu5OLHCMSV0yMSGQbPN2jDEelHwKXymzupdKsrDk53lXFt2xaIPTKt
         Yrn8JOKxkU2rTeRLK/vDMtDiNPuGqrzMu5mzNkMjw/McSpivYViSUIZqhtK5qBcST7
         lIU3DlFR2jXFR+6sIwE9OlkKKnpqM/Q/IUzAe0IVcXB+JHkYneFqurueczHRVlP44s
         P/Bc3NpeuPyntbbM+PN/Bvy9zPXFE7FwLUkaqy2z2Mys5STHf1aTjIH5o1jIfQLNkq
         CHLPQ8P6zVlCnpe/jFFqcPsH1W4VGe85nOTU7oznt7FJY/A42L2kR3EaoDQ1XISplE
         bqm49yjm7J4WA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 28/32] ethtool: Fix an error code in cxgb2.c
Date:   Sat, 11 Sep 2021 09:11:45 -0400
Message-Id: <20210911131149.284397-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131149.284397-1-sashal@kernel.org>
References: <20210911131149.284397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 7db8263a12155c7ae4ad97e850f1e499c73765fc ]

When adapter->registered_device_map is NULL, the value of err is
uncertain, we set err to -EINVAL to avoid ambiguity.

Clean up smatch warning:
drivers/net/ethernet/chelsio/cxgb/cxgb2.c:1114 init_one() warn: missing
error code 'err'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 512da98019c6..2a28a38da036 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1107,6 +1107,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!adapter->registered_device_map) {
 		pr_err("%s: could not register any net devices\n",
 		       pci_name(pdev));
+		err = -EINVAL;
 		goto out_release_adapter_res;
 	}
 
-- 
2.30.2

