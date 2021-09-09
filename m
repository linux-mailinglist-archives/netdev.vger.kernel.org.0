Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B45405663
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359650AbhIINTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358828AbhIINJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:09:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDA38632C5;
        Thu,  9 Sep 2021 12:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188875;
        bh=gwTZgU+vh4/6zPGmspWYrNE48AW3an6I9W51d8OLlSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMeobiHEwFI2qgg6PA0F6hcFfxfIgmkZk05MhTvdWmLqSQ+zv0YdKd4fbCOOoq/I6
         Jk+XKu8wmSry9n5eVpRquT8R4UBWE9sZGxSraXPgeIoKcHUwE/MYBvVovaCVxI7TqQ
         tep3PrIWFqYGq1uv8tZHtyUuwOwJS5yXSnrxoJ1bMXAClh3bAitt7CsejRmogC1i+a
         jgt88SLw2tQAnmjH/u+Nr3kSwyt+vkt2Vd1WGqY5/ywFvzmrFjeQWt0AfDSwPvv+ac
         Ar8m3YelTgA0B7noQRhxGDyFgwALka9fWZol7LU77a81ViKfdL3BnxWixwqra7vLR2
         XoeB6ZhuOzKBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 48/48] net: w5100: check return value after calling platform_get_resource()
Date:   Thu,  9 Sep 2021 08:00:15 -0400
Message-Id: <20210909120015.150411-48-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
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
index d2349a1bc6ba..ae357aecb1eb 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1060,6 +1060,8 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 		mac_addr = data->mac_addr;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
 	if (resource_size(mem) < W5100_BUS_DIRECT_SIZE)
 		ops = &w5100_mmio_indirect_ops;
 	else
-- 
2.30.2

