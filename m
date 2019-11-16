Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BCEFEFF2
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfKPQCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:02:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731097AbfKPPw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:52:59 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5528B214DE;
        Sat, 16 Nov 2019 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919578;
        bh=QI1gw+r06sE5VELa9ZX/A+y3EYDXLyXaTUSzj6BhIYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXZ/80a+7GATXZNYsC2UW8gfMuu7ZCKjgckjeVJsB6wYMzDsQtCa0Tqj5IcEtRiRt
         kz3REDv/u7meYoUTdG12PGxJGAs3zyQ0lYQM4/qz3ATM0gMkecTYhNlEZ4a6CM2oJE
         bygJxuFg2aX0vQ8YsugA7RQf3+FjyLt/2/uAd3qk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Mason <jdmason@kudzu.us>,
        "Gerd W . Haeussler" <gerd.haeussler@cesys-it.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-ntb@googlegroups.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 70/99] ntb_netdev: fix sleep time mismatch
Date:   Sat, 16 Nov 2019 10:50:33 -0500
Message-Id: <20191116155103.10971-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Mason <jdmason@kudzu.us>

[ Upstream commit a861594b1b7ffd630f335b351c4e9f938feadb8e ]

The tx_time should be in usecs (according to the comment above the
variable), but the setting of the timer during the rearming is done in
msecs.  Change it to match the expected units.

Fixes: e74bfeedad08 ("NTB: Add flow control to the ntb_netdev")
Suggested-by: Gerd W. Haeussler <gerd.haeussler@cesys-it.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ntb_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index a9acf71568555..03009f1becddc 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -236,7 +236,7 @@ static void ntb_netdev_tx_timer(unsigned long data)
 	struct ntb_netdev *dev = netdev_priv(ndev);
 
 	if (ntb_transport_tx_free_entry(dev->qp) < tx_stop) {
-		mod_timer(&dev->tx_timer, jiffies + msecs_to_jiffies(tx_time));
+		mod_timer(&dev->tx_timer, jiffies + usecs_to_jiffies(tx_time));
 	} else {
 		/* Make sure anybody stopping the queue after this sees the new
 		 * value of ntb_transport_tx_free_entry()
-- 
2.20.1

