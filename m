Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB543BCF7E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhGFLag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234279AbhGFL1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:27:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B92A261C75;
        Tue,  6 Jul 2021 11:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570401;
        bh=n4e4i6b7pu+S+LOQhnplVOflen9SPRukJwk4NQNpG+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXtWmcqD9oPfW8Mx3Vpcw3UQVzp5fTOIwBMboFw1PDHWcBLP8ta28dphnQlUUo+xD
         iQtDumeXo2GRP4kBQ0+6T171boNTty1z0P8GK1juEPXKPgvdZAs448uO52SCoJTSA5
         hFxKOg0k59zsYnyZTqT/gsD3Ybvu9uZ2h7x0gTVu5Qzfg2gwytM/8C5tPlfe4Q5UL8
         uYh0tflCK1QAooyynIkJ8AdBdDYUrJxEJWQEFGcdbzbk5yfRRMZPf/ko3IvUgp2Npm
         LOewSXt3slE4M8GkpX516QS4SZ+j+/fXafvdYKPe67Cm0duqh0ncPPIkof9JzJ7jKp
         DLb+cXIiAFeOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 071/160] net: bcmgenet: check return value after calling platform_get_resource()
Date:   Tue,  6 Jul 2021 07:16:57 -0400
Message-Id: <20210706111827.2060499-71-sashal@kernel.org>
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

[ Upstream commit 74325bf0104573c6dfce42837139aeef3f34be76 ]

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index 5335244e4577..89d16c587bb7 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -423,6 +423,10 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
 	int id, ret;
 
 	pres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!pres) {
+		dev_err(&pdev->dev, "Invalid resource\n");
+		return -EINVAL;
+	}
 	memset(&res, 0, sizeof(res));
 	memset(&ppd, 0, sizeof(ppd));
 
-- 
2.30.2

