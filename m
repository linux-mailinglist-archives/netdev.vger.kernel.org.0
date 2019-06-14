Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E4F46933
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfFNUaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfFNUap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:30:45 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75B4921881;
        Fri, 14 Jun 2019 20:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544244;
        bh=EIcCMpDEGQUnzftRsw0mrGxajeXmM591lkBNsjhZTjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgMpd+8AT8lK0tDvFlDJ80PybW+R2Vvy66k5zsROlSCeQVbVGzGpFADejaSLlR6ES
         +rpASTRPcPkH5BOaj0A528s7sUvWKQ27ynQZZjGI85Vlbvmd0WzVD+yGa6ADKhBB6K
         UoJ/y8BsBYcF3LVyVTjXg6EFZQzqz/ImxGFDQwjE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonglong Liu <liuyonglong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/18] net: hns: Fix loopback test failed at copper ports
Date:   Fri, 14 Jun 2019 16:30:25 -0400
Message-Id: <20190614203037.27910-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614203037.27910-1-sashal@kernel.org>
References: <20190614203037.27910-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 2e1f164861e500f4e068a9d909bbd3fcc7841483 ]

When doing a loopback test at copper ports, the serdes loopback
and the phy loopback will fail, because of the adjust link had
not finished, and phy not ready.

Adds sleep between adjust link and test process to fix it.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index 4cd163390dcc..f38848c4f69d 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -367,6 +367,7 @@ static int __lb_setup(struct net_device *ndev,
 static int __lb_up(struct net_device *ndev,
 		   enum hnae_loop loop_mode)
 {
+#define NIC_LB_TEST_WAIT_PHY_LINK_TIME 300
 	struct hns_nic_priv *priv = netdev_priv(ndev);
 	struct hnae_handle *h = priv->ae_handle;
 	int speed, duplex;
@@ -393,6 +394,9 @@ static int __lb_up(struct net_device *ndev,
 
 	h->dev->ops->adjust_link(h, speed, duplex);
 
+	/* wait adjust link done and phy ready */
+	msleep(NIC_LB_TEST_WAIT_PHY_LINK_TIME);
+
 	return 0;
 }
 
-- 
2.20.1

