Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AAF3BCC70
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhGFLTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232444AbhGFLSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F36B61C68;
        Tue,  6 Jul 2021 11:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570162;
        bh=lBjcw4sOunxgl3Hqp9I4bME8z73756FTDxGKXLgCxdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXFQyYjrCES16KnMJcidpaZDFQgdTEiERjMYPD6UfnN4P0rGA/9gKKZabCcKtEyrZ
         +91TRVVQA0xXuoGJGFXk+mhY0sXopjURjZxAS0lSWlr1Qr9t9XGYtf97LvomoMEN/G
         XVh7cHt0OpnMp1IONLjkJjZ2CFmUa067dUKkekCBl8wk7OEY4ifVQIAAliPL2+4Xvu
         CF9Ryz0qKia0k1ccww4JHwDHKVkTgwMPfhwwoAYiqMPMBfi7sBNNf4SKchyUGjcK7g
         KWEMGxR0nVh1TwM8tKabnrPcAdK5iBgYrTds2mlFluDZpiu5CBE8Huul7owMxz/b/+
         w/hmVPFea+ULw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 083/189] net: mscc: ocelot: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:12:23 -0400
Message-Id: <20210706111409.2058071-83-sashal@kernel.org>
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

