Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A463BD0F0
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236066AbhGFLhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236340AbhGFLfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47C3861DFF;
        Tue,  6 Jul 2021 11:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570605;
        bh=cfuxUJR0olSoJxyDcHJY9UrvBHZyreOKRgKi4miJ58Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBZGf0LpJCeD8OvbkIPNUAHPNnfleftN+N/URTDG1ob2NY6jxSpG5yzKz+miVJcRZ
         5kQG+09cJTw9UsTCMGpZG4r+GC+Q9FJtnZOqQdcFEH0Z9huhuo17wS9P+uNqk3X3ew
         9zXa1mnWw1dXbORjBMSqfnEXR736iPG9wWKfW2mLvRFMiVBYOSg+8Z84c9UNRN2eQ4
         tlAxaR1LonsQs2LHuhQeWI2kpwvUBjPc0qoGuo/jSI4z/T+cAhowEBsR5qp19A9WPh
         zJdH26LcGQi3VUrO/3HHpV8HiyFLdRKymZYIXsCxy8BPvpJ149JxkjdGfK035Jm21S
         3eLhldbu4pQYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 064/137] net: mvpp2: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:20:50 -0400
Message-Id: <20210706112203.2062605-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0bb51a3a385790a4be20085494cf78f70dadf646 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 6aa13c9f9fc9..fa5ad61ce078 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6871,6 +6871,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 			return PTR_ERR(priv->lms_base);
 	} else {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!res) {
+			dev_err(&pdev->dev, "Invalid resource\n");
+			return -EINVAL;
+		}
 		if (has_acpi_companion(&pdev->dev)) {
 			/* In case the MDIO memory region is declared in
 			 * the ACPI, it can already appear as 'in-use'
-- 
2.30.2

