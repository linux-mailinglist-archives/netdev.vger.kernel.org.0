Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED95845E62A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 04:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359636AbhKZCtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357773AbhKZCqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:46:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A00DF61362;
        Fri, 26 Nov 2021 02:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894213;
        bh=5SOFaKiPx/RxzRvgcrSjUTsv8ONihe1jO7rS2815JN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Niql/Gw6pc4EHhU817vp6cbgl53j15zc+/x+4QIzuhtfaZ4JLoRXTh73DVYF0oqSa
         WTbkeZwgEzb0vFeucCqE5SUO8DN09kIEDXZg8dqBapNzI+iY6dtEDyzEk0Z1yEciIq
         RuFpIDLlXZBExzu/35b1jdSU5q4GW6yxzUw/lTO/zuYjz4DJjyOzzRmsyPzn9fYAAm
         CDW5cZDmWNY0TIDIE39j9DMfpbsAjIOj6a7y49RRJjWv6NbsZb6ps/zkm7pXP69q1B
         eFbMcZ9ghnyebSqPE1NcFRfQzRD9/3Uc1uWabI0GatuBNPUBxF2H8rgN2P4goZFe/Q
         GeVjcng/2O7FA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Teng Qi <starmiku1207184332@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, kuba@kernel.org, lipeng321@huawei.com,
        huangguangbin2@huawei.com, tanhuazhong@huawei.com,
        shenyang39@huawei.com, zhengyongjun3@huawei.com,
        liuyonglong@huawei.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 6/8] ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
Date:   Thu, 25 Nov 2021 21:36:38 -0500
Message-Id: <20211126023640.443271-6-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023640.443271-1-sashal@kernel.org>
References: <20211126023640.443271-1-sashal@kernel.org>
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
index 67accce1d33d0..e89a62c6f2301 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -312,6 +312,10 @@ static void hns_dsaf_ge_srst_by_port(struct dsaf_device *dsaf_dev, u32 port,
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

