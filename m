Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689AC45E5C5
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358495AbhKZCpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:45:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358624AbhKZCnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:43:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 016FB6124F;
        Fri, 26 Nov 2021 02:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894115;
        bh=jQPu9rhvGIraQsQ6jlWHUTdOCeN+CBV12qqiq1oMJNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0LRZgB3KlcoxtTT1911+5L/JJFpOEhfrJL6zlZY5+omuiWRHnsa/hz5XG7zA5nrU
         Jk8YrjkgocOD/aC45C67gKgB+vHw5wZHKfY+k3mS1qv+p2yZwzLtZ1PfWvqKO7ZMV2
         HgBCgVEfzJW9dSyzMFKzfKeG/ZyhnoUiwpFT5f86+L67K4ScpraJFB/OrTRIfLy3zN
         k/6fFblPAjDnTRNYVSxvxfSvgbc3t8W2f72xLwxXTxGHST4ZyjM8TQxPS1F2pF8ekS
         miKggwrgALNTIAIuSshFduvjFd/ENnGD+u103Hj8qo3BJqKF2MIHyaOJwBCQKwuaLo
         jAwcOcNEmbypw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, kuba@kernel.org, lipeng321@huawei.com,
        huangguangbin2@huawei.com, liuyonglong@huawei.com,
        zhengyongjun3@huawei.com, shenyang39@huawei.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/19] ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
Date:   Thu, 25 Nov 2021 21:34:44 -0500
Message-Id: <20211126023448.442529-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
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
index ed3829ae4ef1b..580199fdd0c22 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -398,6 +398,10 @@ static void hns_dsaf_ge_srst_by_port(struct dsaf_device *dsaf_dev, u32 port,
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

