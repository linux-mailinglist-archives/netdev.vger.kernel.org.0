Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FAC40536B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353865AbhIIMv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355103AbhIIMlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84E6561BFA;
        Thu,  9 Sep 2021 11:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188504;
        bh=pfIM1sb5WYITdf6EuMAizbFU1tqBjQht/YjME59ikzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ylfzvh6RoWPEQ/gteyiFNPzy4QWw5QSAMq9BTqPiBn+xLk/zWqTwEcgFyhGyRiELw
         lsVdm0rINxrOHvwboLwsiSs1uRNwiOUE31mnwkpCoNOwR309fopfRA9gngH5LfPjg/
         y1XuxvPl4pi1hPwzNnAQOoKnQF85FBjtnzNixWdapy5ZsBP0KPWQc+6p/nJTkl+17f
         DAEtGHyjRBSyAJiE0JxV92vNsCSpKhNZS/nsVnveW6YlXhZSrSFe4cNS/vi9XicjeW
         H9GuZqlUyDsxlJVXq8wYOGYFHBFNjPGI19ixQFOHSmAjojWDLwtdNfkLZpp7OZ5BtX
         hHtgM0PEXP1jQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 175/176] net: w5100: check return value after calling platform_get_resource()
Date:   Thu,  9 Sep 2021 07:51:17 -0400
Message-Id: <20210909115118.146181-175-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index c0d181a7f83a..0b7135a3c585 100644
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

