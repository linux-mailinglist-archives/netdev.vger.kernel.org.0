Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC6D405484
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356984AbhIIM7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349533AbhIIMvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:51:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3B1E613BD;
        Thu,  9 Sep 2021 11:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188645;
        bh=QF6wCS71/GyPFqKLTaD984ITltx47FzIXEJWlJH2qzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asm8hCgZ+JLuMT6+MCZTdjMKiMDASQq/Ki5J+vUU+PcYh+YyMOmcNqOHnFgxizvjI
         rPVjsGZvj5YTcvoI2SCv/EXjyzvX9rDo1J/wTFlI2hixXW5FOTFKGhCOvMJVtws8Jt
         RrsGzg/ky+VPZFF3vLS6IXRdtxKNXm3faJyhHmi4YyphFvLFSG+Ou9DjMYJvFxiDAi
         qSQaHV6zPkIrH7Ud4KkDOjCrHP9DLJmXbcKcTre6mPiA+91p/41wDN1PljeFt0pynH
         NHHyMB7t5ueoTNgZv5eHay7Vo8GNJLX7eu1pg2hyl1hboZVnrzmU1a5Ye/7mX09JFj
         8Drnt1a146lIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 109/109] net: w5100: check return value after calling platform_get_resource()
Date:   Thu,  9 Sep 2021 07:55:06 -0400
Message-Id: <20210909115507.147917-109-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a39ff4a47f3e1da3b036817ef436b1a9be10783a ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wiznet/w5100.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index bede1ff289c5..a65b7291e12a 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1052,6 +1052,8 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 		mac_addr = data->mac_addr;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
 	if (resource_size(mem) < W5100_BUS_DIRECT_SIZE)
 		ops = &w5100_mmio_indirect_ops;
 	else
-- 
2.30.2

