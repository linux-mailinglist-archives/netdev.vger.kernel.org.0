Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE4439C4A
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhJYRCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234244AbhJYRC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E74BD61002;
        Mon, 25 Oct 2021 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181204;
        bh=bH0mUMW9hR/R/aLe0E7cyxVLgQRHz/PhydPW/eavJ9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vho3MLECQVWQinGt6U75DTtwWkFKTHxGHUfdd7YEsWdHG7ZHxjgLX1+23QxzY4T08
         6UlIvVxCYRcRc1zEgk2GWFB1izjURqtRjYgDUDl/FtjC5scIGntr+dv0nd/vO6Sg/P
         TdSG46rIagjSw1lACl+7l8IbWcI06g9S4dBidBZEnGYPqXqj/8Qg3RLhP+YXB0f4FM
         FCdJ2CldwHIFVXZwxjD/+2KR3nIQBnk0iNmGYMHwMk7I4GrLyN75d/sn0xGUzKeRam
         mD72ksxmuRSx2V3fKvYSefZzeVn+PkqEErHrNTPI7eycemJAWWQBcP356jUARqZSNF
         GkHDzIyg6j7pQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 08/18] net: mscc: ocelot: Add of_node_put() before goto
Date:   Mon, 25 Oct 2021 12:59:21 -0400
Message-Id: <20211025165939.1393655-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025165939.1393655-1-sashal@kernel.org>
References: <20211025165939.1393655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit d1a7b9e4696584ce05c12567762c18a866837a85 ]

Fix following coccicheck warning:
./drivers/net/ethernet/mscc/ocelot_vsc7514.c:946:1-33: WARNING: Function
for_each_available_child_of_node should have of_node_put() before goto.

Early exits from for_each_available_child_of_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4bd7e9d9ec61..03cfa0dc7bf9 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -972,6 +972,7 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 		target = ocelot_regmap_init(ocelot, res);
 		if (IS_ERR(target)) {
 			err = PTR_ERR(target);
+			of_node_put(portnp);
 			goto out_teardown;
 		}
 
-- 
2.33.0

