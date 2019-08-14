Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90CE8C754
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbfHNCRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729369AbfHNCRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E944214DA;
        Wed, 14 Aug 2019 02:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749041;
        bh=pbuP1J8T8FvzcH2KFLUs35UB1Eb4K9GOfx+pIrHLNFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSm4MswH5btd+9JJJGb8CDCXW0CLmAhZhgZUHjF+xcvobb9mSye+YRtunhPqFDP99
         shBVIjeqb4Vilzrz9TSAA9Bjvfa+X8oIS9um3OFEZCwBJT1m+4CpngRFVrgs7M6wfh
         xqrha1toQXWgi9sBv29lN+l0yvSW5dW4BGGuaBq4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 56/68] net: hisilicon: fix hip04-xmit never return TX_BUSY
Date:   Tue, 13 Aug 2019 22:15:34 -0400
Message-Id: <20190814021548.16001-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

[ Upstream commit f2243b82785942be519016067ee6c55a063bbfe2 ]

TX_DESC_NUM is 256, in tx_count, the maximum value of
mod(TX_DESC_NUM - 1) is 254, the variable "count" in
the hip04_mac_start_xmit function is never equal to
(TX_DESC_NUM - 1), so hip04_mac_start_xmit never
return NETDEV_TX_BUSY.

tx_count is modified to mod(TX_DESC_NUM) so that
the maximum value of tx_count can reach
(TX_DESC_NUM - 1), then hip04_mac_start_xmit can reurn
NETDEV_TX_BUSY.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 57c0afa25f9fb..fe3b1637fd5f4 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -185,7 +185,7 @@ struct hip04_priv {
 
 static inline unsigned int tx_count(unsigned int head, unsigned int tail)
 {
-	return (head - tail) % (TX_DESC_NUM - 1);
+	return (head - tail) % TX_DESC_NUM;
 }
 
 static void hip04_config_port(struct net_device *ndev, u32 speed, u32 duplex)
-- 
2.20.1

