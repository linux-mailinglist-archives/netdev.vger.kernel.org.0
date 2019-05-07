Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EBF15C35
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfEGFfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:35:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbfEGFfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:35:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C90F206A3;
        Tue,  7 May 2019 05:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207350;
        bh=FN/ycQ0u4c5F1wG10t4zwA7W/xvnp6ssKa7Bc4d+Tro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMK+3YBIoLT6T0hbBWVNz9oKYTOwkZZl8vpMVupU3k1V/3VzsiE/sjfpc5YQRINaR
         GrUkGg47llbxDDsuewVmdND6DQsq4ozNt9qHnWt+vB4RAp5OX0v1TFk0Pp7Tv3Az//
         HxjcJleDH17UlQW3pCLUY9MsTwnv1iAWkgdoqadQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 98/99] net: mvpp2: fix validate for PPv2.1
Date:   Tue,  7 May 2019 01:32:32 -0400
Message-Id: <20190507053235.29900-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

[ Upstream commit 8b318f30ab4ef9bbc1241e6f8c1db366dbd347f2 ]

The Phylink validate function is the Marvell PPv2 driver makes a check
on the GoP id. This is valid an has to be done when using PPv2.2 engines
but makes no sense when using PPv2.1. The check done when using an RGMII
interface makes sure the GoP id is not 0, but this breaks PPv2.1. Fixes
it.

Fixes: 0fb628f0f250 ("net: mvpp2: fix phylink handling of invalid PHY modes")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 931beac3359d..70031e2b2294 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4370,7 +4370,7 @@ static void mvpp2_phylink_validate(struct net_device *dev,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (port->gop_id == 0)
+		if (port->priv->hw_version == MVPP22 && port->gop_id == 0)
 			goto empty_set;
 		break;
 	default:
-- 
2.20.1

