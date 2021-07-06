Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CCF3BCCA6
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbhGFLTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232602AbhGFLSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A5CC61C65;
        Tue,  6 Jul 2021 11:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570164;
        bh=MxpmsvX3W1vcxQasWIF3eGPQbrJPaNF6TfazWO/1bBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAE28fa3sePtuGM/MfikzbY5ggEvyNhaz69BH5psJnCru4N916+8PCsthVCTvyHwv
         TqeeEsWlS9LRH9r7QpstNRAWFbh/rxZQRybSOW3st+7hbjMQ5BY1YOVzclW2LSvqeL
         l9UG7bkh0+ssb4fCsgy2KMsOpAiNn1W7GjKwsG6vypKlE5DR0YKKltZ747U4FeL6XJ
         Hb/73YOvyPOjlidm6ZDw/LLJR3AMvMS4gVWIRGVRxsi7sDmj/l6HhgzeUm3Ksrgtxb
         rWSZL97t3mJmIYVsP6xS9487pEWpqVVaXcvmzemmY2T2AkwkHr35/j1ZKNycM+jYNg
         3za6r/m1AmJXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 085/189] net: mvpp2: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:12:25 -0400
Message-Id: <20210706111409.2058071-85-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index d39c7639cdba..f1010fe14096 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7387,6 +7387,10 @@ static int mvpp2_probe(struct platform_device *pdev)
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

