Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C710A404DE2
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245510AbhIIMHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236506AbhIIMCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:02:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B022615E0;
        Thu,  9 Sep 2021 11:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187992;
        bh=NCxLR79vOFEL/5e0BQOkAXYhuTh3N8prrKjcQ0ciQMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsIODibEsnh8TYsKQKXxZP+oDMLr3AaQ1BC6q4aGYss9qKfPcbH38nnlhXzJeqkal
         jj0qRcv+9BxDQuO+7NbIShj3A4ogTnZKqdH36W8ceAhpVDvUU9PA+LzQQO42jUQImU
         1M2FTzflNjc8OiZvNrnHr9lSipo0LEBpxEmnw/BwMjvCr+zwREzn5H42f8gC9yMAG9
         g2LUjSlfxkLSUREQB4mJy4EFPoce3K4z7znABeAi6svlh//b5FTAULZoLFfat5mzvh
         V2+6ONYIyD7Za9MyHK8ctE147WI9Iu+BXfDq6z17B0Rpnxfi6ENKHQ72CRvWybDa0z
         QG1EUcOs4e7fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 251/252] net: w5100: check return value after calling platform_get_resource()
Date:   Thu,  9 Sep 2021 07:41:05 -0400
Message-Id: <20210909114106.141462-251-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index 811815f8cd3b..f974e70a82e8 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1047,6 +1047,8 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 		mac_addr = data->mac_addr;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
 	if (resource_size(mem) < W5100_BUS_DIRECT_SIZE)
 		ops = &w5100_mmio_indirect_ops;
 	else
-- 
2.30.2

