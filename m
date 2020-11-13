Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B247C2B15CC
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 07:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKMGPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 01:15:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7532 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgKMGPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 01:15:00 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CXSqV3MzgzhjjS;
        Fri, 13 Nov 2020 14:14:46 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 13 Nov 2020 14:14:55 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <shshaikh@marvell.com>, <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] qlcnic: fix error return code in qlcnic_83xx_restart_hw()
Date:   Fri, 13 Nov 2020 14:16:26 +0800
Message-ID: <1605248186-16013-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 3ced0a88cd4c ("qlcnic: Add support to run firmware POST")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index b8af59f..d2c1907 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -2231,7 +2231,8 @@ static int qlcnic_83xx_restart_hw(struct qlcnic_adapter *adapter)
 
 	/* Boot either flash image or firmware image from host file system */
 	if (qlcnic_load_fw_file == 1) {
-		if (qlcnic_83xx_load_fw_image_from_host(adapter))
+		err = qlcnic_83xx_load_fw_image_from_host(adapter);
+		if (err)
 			return err;
 	} else {
 		QLC_SHARED_REG_WR32(adapter, QLCNIC_FW_IMG_VALID,
-- 
2.9.5

