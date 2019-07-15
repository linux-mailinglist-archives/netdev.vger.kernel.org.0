Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A2969791
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbfGONxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731655AbfGONxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:53:17 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 986862083D;
        Mon, 15 Jul 2019 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198796;
        bh=ZS4MvdM/r9M4Le0sl0cNakU0pgxIbT+CEWmRmxv3uD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVbqjiiEFsvEwB+wlkdPJ3+vecoXSA5QQfueWLVx9esei+c7dmmZquAhWmY3ohm3B
         lyz01TlJGIGEz5qxVLZar+oh+egv5xw/hLAgNckuRcCUtppP0AB6/YwN+T5aYDlZEl
         dx98OKVkyb+5G7BO2lorwrqX6NW4EQeWyPbrTVbM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 105/249] net: hns3: fix for dereferencing before null checking
Date:   Mon, 15 Jul 2019 09:44:30 -0400
Message-Id: <20190715134655.4076-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 757188005f905664b0186b88cf26a7e844190a63 ]

The netdev is dereferenced before null checking in the function
hns3_setup_tc.

This patch moves the dereferencing after the null checking.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5611b990ac34..d18ad7b48a31 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1514,12 +1514,12 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 {
 	struct tc_mqprio_qopt_offload *mqprio_qopt = type_data;
-	struct hnae3_handle *h = hns3_get_handle(netdev);
-	struct hnae3_knic_private_info *kinfo = &h->kinfo;
 	u8 *prio_tc = mqprio_qopt->qopt.prio_tc_map;
+	struct hnae3_knic_private_info *kinfo;
 	u8 tc = mqprio_qopt->qopt.num_tc;
 	u16 mode = mqprio_qopt->mode;
 	u8 hw = mqprio_qopt->qopt.hw;
+	struct hnae3_handle *h;
 
 	if (!((hw == TC_MQPRIO_HW_OFFLOAD_TCS &&
 	       mode == TC_MQPRIO_MODE_CHANNEL) || (!hw && tc == 0)))
@@ -1531,6 +1531,9 @@ static int hns3_setup_tc(struct net_device *netdev, void *type_data)
 	if (!netdev)
 		return -EINVAL;
 
+	h = hns3_get_handle(netdev);
+	kinfo = &h->kinfo;
+
 	return (kinfo->dcb_ops && kinfo->dcb_ops->setup_tc) ?
 		kinfo->dcb_ops->setup_tc(h, tc, prio_tc) : -EOPNOTSUPP;
 }
-- 
2.20.1

