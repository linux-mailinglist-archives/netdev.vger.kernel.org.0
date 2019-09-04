Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 386A5A8BDB
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732683AbfIDQG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733177AbfIDQCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1042123711;
        Wed,  4 Sep 2019 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612930;
        bh=PAUG5iixFXxTPmQ6sxSR0YC0MClEKtce7SpzYuzozrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qt5YkeD7hRKbDTFY2WGIYjvbK2vBI5PLl/A1Tw0b8esIpO0KIDYE4Whmv6KKMmrnB
         T9B8HOfWMrwVA22ryRT168kVgTVCM5HXkorG/8M3kprp6F9sKbyMUOn2ZRmAuxfVjX
         94jII+8+PHsf7NyiqUyuLgRktmvRGW1tanzjmUKY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 31/36] amd-xgbe: Fix error path in xgbe_mod_init()
Date:   Wed,  4 Sep 2019 12:01:17 -0400
Message-Id: <20190904160122.4179-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit b6b4dc4c1fa7f1c99398e7dc85758049645e9588 ]

In xgbe_mod_init(), we should do cleanup if some error occurs

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: efbaa828330a ("amd-xgbe: Add support to handle device renaming")
Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index e31d9d1fb6a66..e4e632e025d31 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -487,13 +487,19 @@ static int __init xgbe_mod_init(void)
 
 	ret = xgbe_platform_init();
 	if (ret)
-		return ret;
+		goto err_platform_init;
 
 	ret = xgbe_pci_init();
 	if (ret)
-		return ret;
+		goto err_pci_init;
 
 	return 0;
+
+err_pci_init:
+	xgbe_platform_exit();
+err_platform_init:
+	unregister_netdevice_notifier(&xgbe_netdev_notifier);
+	return ret;
 }
 
 static void __exit xgbe_mod_exit(void)
-- 
2.20.1

