Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C81E45E51D
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358042AbhKZCja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358035AbhKZChZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 403EC61154;
        Fri, 26 Nov 2021 02:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893981;
        bh=piOZS4uQyRTzoGpGHSQIH//j7MIIDUazFnwEm9dvQVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/lNeUpKKHYGQuAEtjhxh4n7I+IKQ4cBCGyoie9dp/iutvl8IbIgaauxYtkK+X8ev
         VouTNlH/nPKWg7AEapAUmoN+Tq6aU4oBMmONJM9gFs4ilWeEfP0b7hn6/Vjg2VLKnq
         wnaVMXuOP6br/DcNw/ocK7dO9rif3k0KuuQfHzWHK0LZhbRATLyLYGm3pORXyXiFSt
         zM6A8VbxchAxIPr3uCc6NVi6bKRJ9CaHsd1iLuBA68E0zNba5nWZGt8sQPzj31MW4f
         y4nae1F3NpEQcH+kkwI0jstXdWeMjdbqBwXW2NRD7khZ2BT2fuzL4NInBdWD7tfzI7
         UD76L0BUk3/0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, kuba@kernel.org, lipeng321@huawei.com,
        huangguangbin2@huawei.com, shenyang39@huawei.com,
        zhengyongjun3@huawei.com, liuyonglong@huawei.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 29/39] ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
Date:   Thu, 25 Nov 2021 21:31:46 -0500
Message-Id: <20211126023156.441292-29-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
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
index 23d9cbf262c32..740850b64aff5 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -400,6 +400,10 @@ static void hns_dsaf_ge_srst_by_port(struct dsaf_device *dsaf_dev, u32 port,
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

