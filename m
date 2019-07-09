Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DAE62EEC
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfGIDbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:31:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51596 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727296AbfGIDbe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:31:34 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9B84A78089B3A568715F;
        Tue,  9 Jul 2019 11:31:29 +0800 (CST)
Received: from huawei.com (10.67.189.167) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 11:31:21 +0800
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
To:     <davem@davemloft.net>, <robh+dt@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <mark.rutland@arm.com>, <dingtianhong@huawei.com>,
        <xiaojiangfeng@huawei.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <leeyou.li@huawei.com>,
        <nixiaoming@huawei.com>, <jianping.liu@huawei.com>,
        <xiekunxun@huawei.com>
Subject: [PATCH v2 04/10] net: hisilicon: HI13X1_GMAX skip write LOCAL_PAGE_REG
Date:   Tue, 9 Jul 2019 11:31:05 +0800
Message-ID: <1562643071-46811-5-git-send-email-xiaojiangfeng@huawei.com>
X-Mailer: git-send-email 1.8.5.6
In-Reply-To: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
References: <1562643071-46811-1-git-send-email-xiaojiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.167]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI13X1_GMAC changed the offsets and bitmaps for
GE_TX_LOCAL_PAGE_REG registers in the same peripheral
device on different models of the hip04_eth. With the
default configuration, HI13X1_GMAC can also work without
any writes to the GE_TX_LOCAL_PAGE_REG register.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index d8f0619..fe61b01 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -308,8 +308,10 @@ static void hip04_config_fifo(struct hip04_priv *priv)
 	val |= GE_RX_STRIP_PAD | GE_RX_PAD_EN;
 	writel_relaxed(val, priv->base + GE_RECV_CONTROL_REG);
 
+#ifndef CONFIG_HI13X1_GMAC
 	val = GE_AUTO_NEG_CTL;
 	writel_relaxed(val, priv->base + GE_TX_LOCAL_PAGE_REG);
+#endif
 }
 
 static void hip04_mac_enable(struct net_device *ndev)
-- 
1.8.5.6

