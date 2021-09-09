Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05841405092
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344462AbhIIM2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352954AbhIIMXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D6B861AD0;
        Thu,  9 Sep 2021 11:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188275;
        bh=CwGKRGNc/U1V19QPn06J7yQ2a8YzQXoQz4TbJHXJcP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g/pSb6Vbsw9Vdhya52EV1KQKp+fev8OQuT9KqGQGjsPoD1hnr7Y85ANl01uCPLIhG
         E8qVm1y4gsTYUX97YEaDazQFfx/9qMZeBvmcd71qk0pbi7ifFYXUZcZZWMYjE2z5bd
         iMFdVOi5drj0VNAwK1yMiwvncP/zEuIZ0iC5gHw/nAQ9bjzVMOMX8r22GGiIYxmytR
         ANun7ZSp9nCgDzAiwqoS0C/+VDQEH6oV7BjWLVU7vbW5Keiig7uRdSKuK7cZtT/ybI
         s+4RhKlSLKGOK9+8X/jlJNdqIHO4CvL/Jtm8s9GV1aqmznKW7eEyzXhFE5U8NIaoAv
         +9oGZcaFeRqpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 218/219] net: w5100: check return value after calling platform_get_resource()
Date:   Thu,  9 Sep 2021 07:46:34 -0400
Message-Id: <20210909114635.143983-218-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index ec5db481c9cd..15e13d6dc5db 100644
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

