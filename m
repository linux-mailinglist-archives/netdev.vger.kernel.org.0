Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49D425D3C2
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbgIDIgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:36:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51080 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726575AbgIDIgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 04:36:38 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CBC1ED791DD3FCF43916;
        Fri,  4 Sep 2020 16:36:35 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Sep 2020 16:36:27 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net v1 1/2] hinic: bump up the timeout of SET_FUNC_STATE cmd
Date:   Fri, 4 Sep 2020 16:37:28 +0800
Message-ID: <20200904083729.1923-2-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904083729.1923-1-luobin9@huawei.com>
References: <20200904083729.1923-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We free memory regardless of the return value of SET_FUNC_STATE
cmd in hinic_close function to avoid memory leak and this cmd may
timeout when fw is busy with handling other cmds, so we bump up the
timeout of this cmd to ensure it won't return failure.

Fixes: 00e57a6d4ad3 ("net-next/hinic: Add Tx operation")
Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c    | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index c6ce5966284c..0d56c6ceccd9 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -47,6 +47,8 @@
 
 #define MGMT_MSG_TIMEOUT                5000
 
+#define SET_FUNC_PORT_MBOX_TIMEOUT	30000
+
 #define SET_FUNC_PORT_MGMT_TIMEOUT	25000
 
 #define mgmt_to_pfhwdev(pf_mgmt)        \
@@ -361,16 +363,20 @@ int hinic_msg_to_mgmt(struct hinic_pf_to_mgmt *pf_to_mgmt,
 		return -EINVAL;
 	}
 
-	if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
-		timeout = SET_FUNC_PORT_MGMT_TIMEOUT;
+	if (HINIC_IS_VF(hwif)) {
+		if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
+			timeout = SET_FUNC_PORT_MBOX_TIMEOUT;
 
-	if (HINIC_IS_VF(hwif))
 		return hinic_mbox_to_pf(pf_to_mgmt->hwdev, mod, cmd, buf_in,
-					in_size, buf_out, out_size, 0);
-	else
+					in_size, buf_out, out_size, timeout);
+	} else {
+		if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
+			timeout = SET_FUNC_PORT_MGMT_TIMEOUT;
+
 		return msg_to_mgmt_sync(pf_to_mgmt, mod, cmd, buf_in, in_size,
 				buf_out, out_size, MGMT_DIRECT_SEND,
 				MSG_NOT_RESP, timeout);
+	}
 }
 
 static void recv_mgmt_msg_work_handler(struct work_struct *work)
-- 
2.17.1

