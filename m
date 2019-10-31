Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75577EAECE
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfJaLXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:23:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5662 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726552AbfJaLXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 07:23:00 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ED3026EA62EC6D320A4D;
        Thu, 31 Oct 2019 19:22:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 19:22:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Guojia Liao <liaoguojia@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/9] net: hns3: cleanup a format-truncation warning
Date:   Thu, 31 Oct 2019 19:23:20 +0800
Message-ID: <1572521004-36126-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
References: <1572521004-36126-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

In hns3_nic_init_irq(), when '*_int_idx' has more than 9 digits
and the length of netdev's name is IFNAMSIZ, the total length
of final name will be bigger the HNAE3_INT_NAME_LEN - 1, even
though '*_int_idx' will never have such large value, but the
compiler gives a format-truncation warning for this case.

So this patch just enlarges the length to avoid this warning.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 23478ee..45f5916 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -575,7 +575,8 @@ struct hnae3_ae_algo {
 	const struct pci_device_id *pdev_id_table;
 };
 
-#define HNAE3_INT_NAME_LEN        (IFNAMSIZ + 16)
+#define HNAE3_INT_NAME_EXT_LEN    32	 /* Max extra information length */
+#define HNAE3_INT_NAME_LEN        (IFNAMSIZ + HNAE3_INT_NAME_EXT_LEN)
 #define HNAE3_ITR_COUNTDOWN_START 100
 
 struct hnae3_tc_info {
-- 
2.7.4

