Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B29E1BD2ED
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 05:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD2D31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 23:29:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55650 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726551AbgD2D30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 23:29:26 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6A0E7431E02F50010AA4;
        Wed, 29 Apr 2020 11:29:24 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Wed, 29 Apr 2020 11:29:17 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <aviad.krawczyk@huawei.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] hinic: Use kmemdup instead of kzalloc and memcpy
Date:   Wed, 29 Apr 2020 11:35:28 +0800
Message-ID: <1588131328-49470-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warnings:

 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:452:17-24: WARNING opportunity for kmemdup
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c:458:23-30: WARNING opportunity for kmemdup

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index f8626df..a39cc16 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -449,18 +449,15 @@ static void recv_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
 		return;
 	}
 
-	rcv_mbox_temp = kzalloc(sizeof(*rcv_mbox_temp), GFP_KERNEL);
+	rcv_mbox_temp = kmemdup(recv_mbox, sizeof(*rcv_mbox_temp), GFP_KERNEL);
 	if (!rcv_mbox_temp)
 		return;
 
-	memcpy(rcv_mbox_temp, recv_mbox, sizeof(*rcv_mbox_temp));
-
-	rcv_mbox_temp->mbox = kzalloc(MBOX_MAX_BUF_SZ, GFP_KERNEL);
+	rcv_mbox_temp->mbox = kmemdup(recv_mbox->mbox, MBOX_MAX_BUF_SZ,
+				      GFP_KERNEL);
 	if (!rcv_mbox_temp->mbox)
 		goto err_alloc_rcv_mbox_msg;
 
-	memcpy(rcv_mbox_temp->mbox, recv_mbox->mbox, MBOX_MAX_BUF_SZ);
-
 	rcv_mbox_temp->buf_out = kzalloc(MBOX_MAX_BUF_SZ, GFP_KERNEL);
 	if (!rcv_mbox_temp->buf_out)
 		goto err_alloc_rcv_mbox_buf;
-- 
2.6.2

