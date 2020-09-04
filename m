Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1E925D3BF
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgIDIgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:36:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726425AbgIDIgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 04:36:38 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CFEAAE83CAE7B35A0BC9;
        Fri,  4 Sep 2020 16:36:35 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Sep 2020 16:36:28 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net v1 2/2] hinic: bump up the timeout of UPDATE_FW cmd
Date:   Fri, 4 Sep 2020 16:37:29 +0800
Message-ID: <20200904083729.1923-3-luobin9@huawei.com>
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

Firmware erases the entire flash region which may take several
seconds before flashing, so we bump up the timeout to ensure this
cmd won't return failure.

Fixes: 5e126e7c4e52 ("hinic: add firmware update support")
Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index 0d56c6ceccd9..2ebae6cb5db5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -51,6 +51,8 @@
 
 #define SET_FUNC_PORT_MGMT_TIMEOUT	25000
 
+#define UPDATE_FW_MGMT_TIMEOUT		20000
+
 #define mgmt_to_pfhwdev(pf_mgmt)        \
 		container_of(pf_mgmt, struct hinic_pfhwdev, pf_to_mgmt)
 
@@ -372,6 +374,8 @@ int hinic_msg_to_mgmt(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	} else {
 		if (cmd == HINIC_PORT_CMD_SET_FUNC_STATE)
 			timeout = SET_FUNC_PORT_MGMT_TIMEOUT;
+		else if (cmd == HINIC_PORT_CMD_UPDATE_FW)
+			timeout = UPDATE_FW_MGMT_TIMEOUT;
 
 		return msg_to_mgmt_sync(pf_to_mgmt, mod, cmd, buf_in, in_size,
 				buf_out, out_size, MGMT_DIRECT_SEND,
-- 
2.17.1

