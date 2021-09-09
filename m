Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7967404AF4
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbhIILt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:49:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241770AbhIILrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:47:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71CF4611EF;
        Thu,  9 Sep 2021 11:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187800;
        bh=HJfAW2t0hTonjZ5FlDW4q1tk06LyhkwoiHH4zkem0bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3g60+ngxWFunZ5cN96bxkSNYKlru4Okb52qesRkio9C/IDuf6ucOX+i1kGb/nMzo
         1g7AJafyL7g2QfaXVd/AWVYjVbiT0galZGnUtgZXXroux5Za7oYRLOebjcS36LYsd5
         68BtG4sUE1/5BSQB+7p10NMv+/DkwlLLVA8MBo5g+Bq6laJPYkdcUOVs7Wu8rb1eF8
         Yo1ajdCEi/22uJzzv4Uz/pb0Fsm462DlIfMVLxovyeJzTfE+MS2KOQfHP6GzO+QyA9
         OR8ogEvoOQnkh2H+yCWtG5JRpf6lJLgds0VLxYvi7S4dBWaiUeiQrW3pc3Z/Wo/jiG
         89GOQTXkyM9ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 104/252] dpaa2-switch: do not enable the DPSW at probe time
Date:   Thu,  9 Sep 2021 07:38:38 -0400
Message-Id: <20210909114106.141462-104-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 042ad90ca7ce70f35dc5efd5b2043d2f8aceb12a ]

We should not enable the switch interfaces at probe time since this is
trigged by the open callback. Remove the call dpsw_enable() which does
exactly this.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 98cc0133c343..5ad5419e8be3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3231,12 +3231,6 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 			       &ethsw->fq[i].napi, dpaa2_switch_poll,
 			       NAPI_POLL_WEIGHT);
 
-	err = dpsw_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
-	if (err) {
-		dev_err(ethsw->dev, "dpsw_enable err %d\n", err);
-		goto err_free_netdev;
-	}
-
 	/* Setup IRQs */
 	err = dpaa2_switch_setup_irqs(sw_dev);
 	if (err)
-- 
2.30.2

