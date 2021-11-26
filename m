Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C10A45E5FA
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358845AbhKZCqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:46:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358066AbhKZCoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:44:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94BAD6127C;
        Fri, 26 Nov 2021 02:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894156;
        bh=Iokm/SNzArLy8vmKwe3r8JvvcOce6eT2Gwe1tVP9WSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QvhcQhFvi56ow+7xYBQ0g3if+1sVvQlqQXoIMAUpTHtKD+Ax8u4bP1LGg+6kyMd+w
         K5dlmTA/3HFvKSQudSToAH7e7txc/YmgouskXDEs5Xj5WB38kzewoZ+Dp4cdbTiNHG
         qof/9rtS5n1gdJWJKgJ54VUs8+OtwGp4rppfGWWIeaToEgilIbP4kknYUUaRUtnhpA
         t7ZkIGxl/94c7mNv0tot25+dh3em7Hip400CQX/sksuGIp7JsC1RVKNicfzChp3cfT
         b9bp1crSsxCyK4Xsqx7X4f0iFM2LZB/bJt51k6c8CvXUL9cRsKszk64x9zNnvEjJhk
         W1fcnHiNiqHiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, kuba@kernel.org, huangguangbin2@huawei.com,
        lipeng321@huawei.com, tanhuazhong@huawei.com,
        shenyang39@huawei.com, zhengyongjun3@huawei.com,
        liuyonglong@huawei.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/15] ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
Date:   Thu, 25 Nov 2021 21:35:30 -0500
Message-Id: <20211126023533.442895-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023533.442895-1-sashal@kernel.org>
References: <20211126023533.442895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Teng Qi <starmiku1207184332@gmail.com>

[ Upstream commit a66998e0fbf213d47d02813b9679426129d0d114 ]

The if statement:
  if (port >= DSAF_GE_NUM)
        return;

limits the value of port less than DSAF_GE_NUM (i.e., 8).
However, if the value of port is 6 or 7, an array overflow could occur:
  port_rst_off = dsaf_dev->mac_cb[port]->port_rst_off;

because the length of dsaf_dev->mac_cb is DSAF_MAX_PORT_NUM (i.e., 6).

To fix this possible array overflow, we first check port and if it is
greater than or equal to DSAF_MAX_PORT_NUM, the function returns.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index 16294cd3c9545..4ceacb1c154dc 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -402,6 +402,10 @@ static void hns_dsaf_ge_srst_by_port(struct dsaf_device *dsaf_dev, u32 port,
 		return;
 
 	if (!HNS_DSAF_IS_DEBUG(dsaf_dev)) {
+		/* DSAF_MAX_PORT_NUM is 6, but DSAF_GE_NUM is 8.
+		   We need check to prevent array overflow */
+		if (port >= DSAF_MAX_PORT_NUM)
+			return;
 		reg_val_1  = 0x1 << port;
 		port_rst_off = dsaf_dev->mac_cb[port]->port_rst_off;
 		/* there is difference between V1 and V2 in register.*/
-- 
2.33.0

