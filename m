Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073DE4077BD
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhIKNTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 09:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236957AbhIKNRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 09:17:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BD9A61354;
        Sat, 11 Sep 2021 13:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366021;
        bh=M29a5ze1Ffe9rMjbkQ+l/WCuAVOqIQPDBjVLNaEX5OM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLm1MYCoPfAF5Bzps/muTaeybTmkgdQqR1aeQIT0e4AvjUyfuDrAYsFaEZ7+dkwVb
         9xGk2PN3n7KnJ0VUd5hduuMvbgKm9XIG09F797pVobyuRBh1UAOQtLmIOUOP5j/fBG
         QXYsFXJ8uWlcQTG6ZxNNXCK2FJ3bQTb+QmWN5dlV7C1TvsfVNB5oC37fAkm48No9Wq
         IEG4R+ZKK0KdhVmKZoRYsFZ1cd7RIAfE6+C6XEHvI9LqMXhpi1agdOSqcvSQ3xvhnS
         1EiRQbv7zNegQxecf9OSj2uoMbkpaONlEve8KYFBsv7xa15UMSgnSp9ia7dVDWY08N
         GWnQpDwsRoS5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/25] ethtool: Fix an error code in cxgb2.c
Date:   Sat, 11 Sep 2021 09:13:09 -0400
Message-Id: <20210911131312.285225-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
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
index 0e4a0f413960..c6db85fe1629 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1153,6 +1153,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!adapter->registered_device_map) {
 		pr_err("%s: could not register any net devices\n",
 		       pci_name(pdev));
+		err = -EINVAL;
 		goto out_release_adapter_res;
 	}
 
-- 
2.30.2

