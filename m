Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6163BCF84
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhGFLan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234145AbhGFL1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:27:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91B2E61D5D;
        Tue,  6 Jul 2021 11:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570400;
        bh=lBjcw4sOunxgl3Hqp9I4bME8z73756FTDxGKXLgCxdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVzw+Juyo6FRnelOCC4cZ7akh4W2kWwQGDMZ7Y/3y1ciaG5jS95+rTZEcqGZ84TUG
         yCCcYB6DfywTff2bgwYpeL71Cbk0Y7LIo29CSH/qD/KSQhGyEQytuZZiTb2Zzgvdag
         4w9ke0NDujumUQDvTSwf+9IlDmcqwHOUsHCVkgeRP1na2XU2U5jOt98BxFP3LqEaJ7
         y8s7IqDJ1xF5yqx+rqkXyk1foLoj+jXjXRDd3/kidC2czu4jAUzgdtmShFJHQkSQVf
         4avl1Vpv0IFBBQDGzyqwbIsrkYSk36f7Gw4AQTZfrCxRH/MkQgM+tQrMXLBBOO36hV
         ZB3yqhuo1p/yA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 070/160] net: mscc: ocelot: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:16:56 -0400
Message-Id: <20210706111827.2060499-70-sashal@kernel.org>
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
index 84f93a874d50..deae923c8b7a 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1206,6 +1206,11 @@ static int seville_probe(struct platform_device *pdev)
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

