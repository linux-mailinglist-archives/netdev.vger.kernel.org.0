Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1FB3A24B3
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbfH2SZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729682AbfH2SQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:16:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77A72339E;
        Thu, 29 Aug 2019 18:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102574;
        bh=wwLT04ucao1A/pITO8we/sXkEb1zHES9zE1FmmJgyPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwP6LGPv+1X2sxjUZPXIi7EyoA9wWSNZo8sS/Tp8Gnamgc04dtRqmYbwZAJMUQqjH
         iijVLfgccCwi4h4LTXHOWlK495yFIrhO1+pNQXU6LMCtBkCaiYxMmyDZrn2afV4jU4
         C3Wm7wiSKq/0wo0nMpFQ4DdSrDF3rCADxwLYHPMY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 20/45] net: myri10ge: fix memory leaks
Date:   Thu, 29 Aug 2019 14:15:20 -0400
Message-Id: <20190829181547.8280-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 20fb7c7a39b5c719e2e619673b5f5729ee7d2306 ]

In myri10ge_probe(), myri10ge_alloc_slices() is invoked to allocate slices
related structures. Later on, myri10ge_request_irq() is used to get an irq.
However, if this process fails, the allocated slices related structures are
not deallocated, leading to memory leaks. To fix this issue, revise the
target label of the goto statement to 'abort_with_slices'.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index b2d2ec8c11e2d..6789eed78ff70 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3922,7 +3922,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * setup (if available). */
 	status = myri10ge_request_irq(mgp);
 	if (status != 0)
-		goto abort_with_firmware;
+		goto abort_with_slices;
 	myri10ge_free_irq(mgp);
 
 	/* Save configuration space to be restored if the
-- 
2.20.1

