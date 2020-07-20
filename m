Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A13A225AA7
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGTJBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:01:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8334 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbgGTJBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 05:01:11 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 33C62D6F8F64A458F9B3;
        Mon, 20 Jul 2020 17:01:04 +0800 (CST)
Received: from NRM-11.huawei.com (10.175.101.78) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Jul 2020 17:00:57 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brcm80211-dev-list@cypress.com>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <kvalo@codeaurora.org>, <kuba@kernel.org>,
        <franky.lin@broadcom.com>, <wright.feng@cypress.com>
CC:     Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH net-next] brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach
Date:   Mon, 20 Jul 2020 17:33:28 +0800
Message-ID: <1595237608-66045-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.78]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When brcmf_proto_msgbuf_attach fail and msgbuf->txflow_wq != NULL,
we should destroy the workqueue.

Fixes: 05491d2ccf20 ("brcm80211: move under broadcom vendor directory")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 8bb4f1f..1bb270e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1619,6 +1619,8 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 					  BRCMF_TX_IOCTL_MAX_MSG_SIZE,
 					  msgbuf->ioctbuf,
 					  msgbuf->ioctbuf_handle);
+		if (msgbuf->txflow_wq)
+			destroy_workqueue(msgbuf->txflow_wq);
 		kfree(msgbuf);
 	}
 	return -ENOMEM;
-- 
1.8.3

