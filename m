Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B481B3BCF81
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhGFLaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234337AbhGFL1W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:27:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01D2061C4E;
        Tue,  6 Jul 2021 11:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570402;
        bh=CYAbfmDVnAb7v0z9aCH0ChSgS3VgrANnaGLBfKOz9js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZVg4v79/bs/xRglf4F7LQRssHGUwX6cyXvQ3Q7Q0IcNSyxKn1zUWzL/RAm04Za25
         SosWvhurC2MFcfCzY4H01FKn0KJQelQHlfRbCxvgkS4XBxhsWB/YMrhU92I1GbOpti
         KmSdKFaLfI1AUFz2SR1JhnN75P0HpZsxZ6wfNz+lV3M/OjzKBU88tVEIuOR+J19n9c
         F62rHx9t4J51niiwALEoSAXOUb6vVa9/dgP2u6LyiEFd791uLrTaYzOMDL3umqwAuF
         2DXkbM/0BhKk1nPl+W6tmeTzNd1POCEeYV60llbq4ncWTd12RVNdDSBmYbkL5Yj1pe
         v54VvtwysDIhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 072/160] net: mvpp2: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:16:58 -0400
Message-Id: <20210706111827.2060499-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 6c81e4f175ac..bd6670960d23 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7388,6 +7388,10 @@ static int mvpp2_probe(struct platform_device *pdev)
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

