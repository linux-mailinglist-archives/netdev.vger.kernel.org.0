Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5960D405553
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358776AbhIINJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357890AbhIINFS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:05:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B5E61465;
        Thu,  9 Sep 2021 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188814;
        bh=9v5KXetP0jHSalqwz0z7Olnkt5XTLcj/fwIRehqg2Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pkg+oXvNnq6FqF/STV7PDmixzfqgq0mbcFnWXNWZ86ODt6EQGt8FxWMHChq9VsQMw
         oYGspSwfta4CPNs74bIWTlTiVHXHEr3jmNTfcBeLrnMJoWstkEW+lsp4hmTYL5qLkM
         uufqVcnVwKF+8btTm+12c/RSgcYVk5XXh1dbysWgcxCgJpIaFGRSBYbX8kLYCaPmyI
         i4/C0cJZJGWAMP1WfKshgSgXd9FNUZ36mNaEQyOOZ0WxvuTVIqeGo0SMlHo9nrZqBY
         0YXcgUx+GjXHloUdACmLjLGdD3+8mFg2VYmn9jiuCdxmSlu5Fnjvcbc+kMjEsIi0nJ
         +ghZPBwXAU8Cw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 59/59] net: w5100: check return value after calling platform_get_resource()
Date:   Thu,  9 Sep 2021 07:59:00 -0400
Message-Id: <20210909115900.149795-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
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
index 2bdfb39215e9..87610d8b3462 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -1059,6 +1059,8 @@ static int w5100_mmio_probe(struct platform_device *pdev)
 		mac_addr = data->mac_addr;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
 	if (resource_size(mem) < W5100_BUS_DIRECT_SIZE)
 		ops = &w5100_mmio_indirect_ops;
 	else
-- 
2.30.2

