Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A37047B7C7
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhLUCBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:01:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34512 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbhLUCAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:00:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 251D3B8110C;
        Tue, 21 Dec 2021 02:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093B1C36B02;
        Tue, 21 Dec 2021 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052021;
        bh=Jk1YQBlTaMji3fndbedjV+Z1GQl33QbZ4mOTekrcbbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5uZls9fSPMw3788WanJyE6ClfytJQMyNqD1CHGpkQ8LThcvWjmHrICwawh3B7NKE
         IhocAShJFmF9q2XRZksj87rop3bJrM0VCh4hSgBcNB6ptGUaz8MFJVHR/fbHcPVZnD
         AKw4a9whAb6B26C/1geGqMcJGXjbJ+eNwnbP/G2Ka/oOMJ5WqjUHKyfkA8SGMKSPcf
         jOfQgJ7CHevr0jT/iqEHEiAFEpKswzVcp1k2HymzXCoH3byDlhrpwbuYGrqFkCKM9W
         HHadmZjbHRyJPIm5Y0viV7OenWs+uNQfBpglopfevenqpTl1i5vZp4lml2CZ9EH5PY
         MQwE0/gv20sBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, opendmb@gmail.com,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/14] net: bcmgenet: Fix NULL vs IS_ERR() checking
Date:   Mon, 20 Dec 2021 20:59:46 -0500
Message-Id: <20211221015952.117052-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015952.117052-1-sashal@kernel.org>
References: <20211221015952.117052-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit ab8eb798ddabddb2944401bf31ead9671cb97d95 ]

The phy_attach() function does not return NULL. It returns error pointers.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index ce569b7d3b353..e494f0e57d8ff 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -547,9 +547,9 @@ static int bcmgenet_mii_pd_init(struct bcmgenet_priv *priv)
 		 * Internal or external PHY with MDIO access
 		 */
 		phydev = phy_attach(priv->dev, phy_name, pd->phy_interface);
-		if (!phydev) {
+		if (IS_ERR(phydev)) {
 			dev_err(kdev, "failed to register PHY device\n");
-			return -ENODEV;
+			return PTR_ERR(phydev);
 		}
 	} else {
 		/*
-- 
2.34.1

