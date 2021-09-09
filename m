Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A566E405516
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352709AbhIINHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357102AbhIIM7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:59:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6816163275;
        Thu,  9 Sep 2021 11:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188739;
        bh=2WWMFcYrSSA8Uqwsq5ULjNmvsLcSWjfaxgSajwuiT0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STMEl2X1hucP5YBH/8jtG6CGrz3tLJy2LHQ2OH31234vXD5vag9NdTNJEZhRCMaGI
         Pk5BRRS56tbZFSvitQlIuklRkjcyXSSSZ29JTgVdQb/N+SxCUgD/Xbtyq3E2ROtaYp
         V2o3eBr8P5T15Y+pZrJ7zeZ/7LJEZKWWZM7upHFsDs0ENu0S7ehnxUtP1oqbwGhYd1
         w5ien2lJdn3kj396AoLHEnS2XE43sDi3taN1ZyFViDIBkhFTChNQ8LbUr7qke5vfGp
         rLtB2j8v4NERdlSlEOxep/9bfuMdhUlaA1oP5OJtggAZIS/cXGztRK4R7M7lOmyCNi
         DQ2kpbGutTIWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 74/74] net: w5100: check return value after calling platform_get_resource()
Date:   Thu,  9 Sep 2021 07:57:26 -0400
Message-Id: <20210909115726.149004-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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
index d8ba512f166a..41040756307a 100644
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

