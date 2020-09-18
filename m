Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FBC26F268
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbgIRC6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgIRCGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F0DA23888;
        Fri, 18 Sep 2020 02:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394776;
        bh=/+pliRggyOjEy8m8uK+MrMptQUHltTkK+F/HawNYwaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1gftzftYm33zQFwLqABDEou2g6vahtYcKtp7HIo9u+wBIA4nDOOg4yJ2gOATZPKS
         yZ476RBH8wpLOHkJSwSbAytaIWhR17ILQ9FgeV0rNk0hCiJLVpaE8y3u4FddEFIY7J
         gcffAfHEBKk2C/q9RqpfKOiYWG1U7vaopMNl/ibw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 250/330] dpaa2-eth: fix error return code in setup_dpni()
Date:   Thu, 17 Sep 2020 21:59:50 -0400
Message-Id: <20200918020110.2063155-250-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 97fff7c8de1e54e5326dfeb66085796864bceb64 ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 7a248cc1055a3..7af7cc7c8669a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2654,8 +2654,10 @@ static int setup_dpni(struct fsl_mc_device *ls_dev)
 
 	priv->cls_rules = devm_kzalloc(dev, sizeof(struct dpaa2_eth_cls_rule) *
 				       dpaa2_eth_fs_count(priv), GFP_KERNEL);
-	if (!priv->cls_rules)
+	if (!priv->cls_rules) {
+		err = -ENOMEM;
 		goto close;
+	}
 
 	return 0;
 
-- 
2.25.1

