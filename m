Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A07404EBD
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345192AbhIIMNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346048AbhIIMLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48000619E9;
        Thu,  9 Sep 2021 11:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188112;
        bh=3O0lqPPUH/2D2pVU3SgtAvx6ACObZxJzsIqXDUgcDLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYpdqB2qPIt+yrUqwBG/U3pJe08lYQ8YK7gEgtqAGgjrnAPg3sqTkjXklZZWcAlHO
         ZnatxEITrNRR77TJ1gitYDvNkSIduJMNYsBZ4a9hfziH7iHlY7RQvQ1p7lUPEyNxx3
         1mHK3o5Gj/cL7LVHqOO88J8uzX787nlPksMz8ojLQS5tm8c/F6vaGoPy5/cYd3e1Ik
         3dWsqQAiApKI9yTXJkS+2eRAWbTRi6Mdo75G3ZNA2oNkNMKmsPngvnwfl3nXHaOBqd
         fl28zT/KZAQMx/U5hKt9oZxRimwPRDHGYJXey5mBDfGm0Ges0kvpoVFRxfXvp1wm/o
         8XDDk59SV+D4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 090/219] dpaa2-switch: do not enable the DPSW at probe time
Date:   Thu,  9 Sep 2021 07:44:26 -0400
Message-Id: <20210909114635.143983-90-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 58964d22cb17..e3a3499ba7a2 100644
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

