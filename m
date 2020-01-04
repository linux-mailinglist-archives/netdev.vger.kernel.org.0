Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1A0130030
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgADCtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:49:42 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8671 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727320AbgADCtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:41 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 96085B51E72614567480;
        Sat,  4 Jan 2020 10:49:37 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Sat, 4 Jan 2020 10:49:28 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/8] net: hns3: replace an unsuitable variable type in hclge_inform_reset_assert_to_vf()
Date:   Sat, 4 Jan 2020 10:49:30 +0800
Message-ID: <1578106171-17238-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
References: <1578106171-17238-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In hclge_inform_reset_assert_to_vf(), variable reset_type(enum type)
will be copied into msg_data whose size is 2 bytes. Currently, hip08
is a little-endian machine, so the lower two bytes of reset_type will
be copied to msg_data. But when running on a big-endian machine,
msg_data will have a wrong value(the higher two bytes of reset_type).

So this patch modifies the type of reset_type to u16, and adds a
build check in case enum hnae3_reset_type has value larger than
U16_MAX.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h            | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ed97bd6c..6b131ab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -164,6 +164,7 @@ enum hnae3_reset_type {
 	HNAE3_IMP_RESET,
 	HNAE3_UNKNOWN_RESET,
 	HNAE3_NONE_RESET,
+	HNAE3_MAX_RESET,
 };
 
 enum hnae3_flr_state {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index f905dd3..a3c0822 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -86,10 +86,12 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 int hclge_inform_reset_assert_to_vf(struct hclge_vport *vport)
 {
 	struct hclge_dev *hdev = vport->back;
-	enum hnae3_reset_type reset_type;
+	u16 reset_type;
 	u8 msg_data[2];
 	u8 dest_vfid;
 
+	BUILD_BUG_ON(HNAE3_MAX_RESET > U16_MAX);
+
 	dest_vfid = (u8)vport->vport_id;
 
 	if (hdev->reset_type == HNAE3_FUNC_RESET)
-- 
2.7.4

