Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB813FB75B
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 15:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhH3N4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 09:56:07 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15271 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236907AbhH3Nz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 09:55:59 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GysJL4h4mz7tbF;
        Mon, 30 Aug 2021 21:54:42 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 21:55:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 30 Aug 2021 21:55:02 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/4] net: hns3: clean up a type mismatch warning
Date:   Mon, 30 Aug 2021 21:51:07 +0800
Message-ID: <1630331469-13707-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630331469-13707-1-git-send-email-huangguangbin2@huawei.com>
References: <1630331469-13707-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

abs() returns signed long, which could not convert the type
as unsigned, and it may cause a mismatch type warning from
static tools. To fix it, this patch uses an variable to save
the abs()'s result and does a explicit conversion.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 0315d8312af3..2ce5302c5956 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -10,7 +10,14 @@
 
 static u16 hclge_errno_to_resp(int errno)
 {
-	return abs(errno);
+	int resp = abs(errno);
+
+	/* The status for pf to vf msg cmd is u16, constrainted by HW.
+	 * We need to keep the same type with it.
+	 * The intput errno is the stander error code, it's safely to
+	 * use a u16 to store the abs(errno).
+	 */
+	return (u16)resp;
 }
 
 /* hclge_gen_resp_to_vf: used to generate a synchronous response to VF when PF
-- 
2.8.1

