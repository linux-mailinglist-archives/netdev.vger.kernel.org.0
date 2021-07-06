Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9866C3BD15B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbhGFLjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237141AbhGFLf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A975F61CB9;
        Tue,  6 Jul 2021 11:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570743;
        bh=XvMzvTaAfpawkh2cCxsAHf/4onsEEAZjNGilglXmpGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pa2iST6cNGDaje/SxSVF0iKa/0IDoOechkSzVz9LYakRePnGnH2jVvRxDChZfK9Y/
         fqfHCKAqdFicStqGc9NHqPHfFO7VELU3zK6LaNNSdAZSh3rahyzURjzAULlgW1nQOn
         r+PsYaGmVqhqR9xUR0kbGnmDrloQ/UE2jyzjrLLVeiQEG+Sp/MbcXgbbm1lcLXwcPT
         X4brS1NWGYF5x5C8uBjMGX1Og/m+PgAu3vsSb/HmWUtbrhVTV4nUw/z9pzyqHJLMg1
         q5UrfZ/J9u8eimGHXhnJ+GB/eesklaom1cS9RiQdi8rsSOTKzVuQP7st2v0FnoPgq3
         I86U1pdNyfIHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 32/74] net: mvpp2: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:24:20 -0400
Message-Id: <20210706112502.2064236-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
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
index 491bcfd36ac2..d5cf9afab103 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5740,6 +5740,10 @@ static int mvpp2_probe(struct platform_device *pdev)
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

