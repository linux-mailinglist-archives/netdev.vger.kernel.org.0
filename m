Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72271FDAB7
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgFRBE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:04:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6276 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgFRBEz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:04:55 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 81848D0D06543749C19B;
        Thu, 18 Jun 2020 09:04:54 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.203.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 18 Jun 2020 09:04:44 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <netdev@vger.kernel.org>, <linyunsheng@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH 4/5] net: hns3: replace disable_irq by IRQ_NOAUTOEN flag
Date:   Thu, 18 Jun 2020 13:02:10 +1200
Message-ID: <20200618010211.75840-5-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
References: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.203.42]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

disable_irq() after request_irq() is still risk as there is a chance irq
can come after request_irq() and before disable_irq().
this should be done by IRQ_NOAUTOEN flag.

Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 3cd2216e49b9..1330820152fa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -8,6 +8,7 @@
 #include <linux/cpu_rmap.h>
 #endif
 #include <linux/if_vlan.h>
+#include <linux/irq.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/module.h>
@@ -154,6 +155,7 @@ static int hns3_nic_init_irq(struct hns3_nic_priv *priv)
 
 		tqp_vectors->name[HNAE3_INT_NAME_LEN - 1] = '\0';
 
+		irq_set_status_flags(tqp_vectors->vector_irq, IRQ_NOAUTOEN);
 		ret = request_irq(tqp_vectors->vector_irq, hns3_irq_handle, 0,
 				  tqp_vectors->name, tqp_vectors);
 		if (ret) {
@@ -163,8 +165,6 @@ static int hns3_nic_init_irq(struct hns3_nic_priv *priv)
 			return ret;
 		}
 
-		disable_irq(tqp_vectors->vector_irq);
-
 		irq_set_affinity_hint(tqp_vectors->vector_irq,
 				      &tqp_vectors->affinity_mask);
 
-- 
2.23.0


