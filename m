Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F703BD1E0
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbhGFLke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236304AbhGFLfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B64F461E0F;
        Tue,  6 Jul 2021 11:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570603;
        bh=pAh9sS9KTHjr0pvKpZxLQ/hvbf6Z1ptRKk+fyiUulUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuNVkmJfy+fIwe3NJsKPy/agBwcWS6B3nLyCyYMnoi7PDEeAg0lWJj7DIaVtnjpY7
         uXwBXxkRk+gCY2WK5nWd4EFg0jMas3ZLX0YRMOLrOcG8RiK2VY83y3LvgYTkCKRetO
         LKiyKUk9WmIM1jnp0y2dELcSo6l4RULF/pUdDIpshOAbgXtZbdp+Z9LotR8ikKFWmU
         KQ2sKXsUJA4njAW4UvNLSB8LEYRG+2/q+Hwp1hGxaVRbTyu6nzHuhIx0YBozO3VOHB
         YkxxciQUg2mGaEJmENP9fIx4+X+BMT5JiLHY9hamHsvJf8eLWYg3y3MMt2FCGeMlrs
         6dXSSh/px7gPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 062/137] net: mscc: ocelot: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:20:48 -0400
Message-Id: <20210706112203.2062605-62-sashal@kernel.org>
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

[ Upstream commit f1fe19c2cb3fdc92a614cf330ced1613f8f1a681 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index ebbaf6817ec8..7026523f886c 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1214,6 +1214,11 @@ static int seville_probe(struct platform_device *pdev)
 	felix->info = &seville_info_vsc9953;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -EINVAL;
+		dev_err(&pdev->dev, "Invalid resource\n");
+		goto err_alloc_felix;
+	}
 	felix->switch_base = res->start;
 
 	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
-- 
2.30.2

