Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88DE456698
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfFZKXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:23:42 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7143 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFZKXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:23:42 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d1347af0011>; Wed, 26 Jun 2019 03:23:43 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 26 Jun 2019 03:23:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 26 Jun 2019 03:23:41 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL106.nvidia.com
 (172.18.146.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Jun
 2019 10:23:40 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Jun
 2019 10:23:39 +0000
Received: from hqnvemgw02.nvidia.com (172.16.227.111) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 26 Jun 2019 10:23:39 +0000
Received: from moonraker.nvidia.com (Not Verified[10.21.132.148]) by hqnvemgw02.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5d1347aa0001>; Wed, 26 Jun 2019 03:23:40 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 1/2] net: stmmac: Fix possible deadlock when disabling EEE support
Date:   Wed, 26 Jun 2019 11:23:21 +0100
Message-ID: <20190626102322.18821-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561544623; bh=XV4Kw+o6xd8IYqvSK/9uERa+dJc4XymhGYNfc+d+goU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:Content-Type;
        b=QgNbpMdWNBdmAFB65WGi5i9RqkIFGw4WozzpNghEsZe1f6z222Lmh7NHFPob4tc24
         2bz2UfTUfaHxPQixd3zqEW4tX5YMMYdfG5v0wrPoJ+IgLqHwYkXOg4CRYoI/5/49cs
         BU1UpHhAE5YEtwB+47eX39nfXGCsbTmhZcg+abYxkzqkKmQJDbsYVIIAcsb6YTUylh
         ILbRIZk89eRzgNOWGNJYi2RLwqptqFYjV26p1ZSJ4IOk3l8qEdrhRBb79KAw78L84W
         R4ZrXmKugOogIkXVdfGf23TK59/A65HmL7wPxHrG+IwjT9tLbqo6LuxPBZxRo/ENTR
         fHWXqDjlnlo/Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When stmmac_eee_init() is called to disable EEE support, then the timer
for EEE support is stopped and we return from the function. Prior to
stopping the timer, a mutex was acquired but in this case it is never
released and so could cause a deadlock. Fix this by releasing the mutex
prior to returning from stmmax_eee_init() when stopping the EEE timer.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b628c697cee9..6c6c6ec3c781 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -402,6 +402,7 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 		netdev_dbg(priv->dev, "disable EEE\n");
 		del_timer_sync(&priv->eee_ctrl_timer);
 		stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
+		mutex_unlock(&priv->lock);
 		return false;
 	}
 
-- 
1.9.1

