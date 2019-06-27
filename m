Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AED857619
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfF0AfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbfF0AfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:35:08 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AA9221851;
        Thu, 27 Jun 2019 00:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595707;
        bh=7MJO6Excqhusv+9ayIA4sVvGO1xUp3SpW948fpqsnB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QP7QE3j/ShFjJyYMldF/06wVt3jR2zN6/ccPHZD29HCGP3o31ANQaz2UfvVlzzADV
         ngaV01xfzuaCR/2+PMe+umUnQ0E2uH6NHPkVsiUQaRS1yECzt7oFF2okal7nHqdDDt
         0gGHZImB6+55rrVbBeUx0OFe2Ufx0TT3awP+XTbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 87/95] net: lio_core: fix potential sign-extension overflow on large shift
Date:   Wed, 26 Jun 2019 20:30:12 -0400
Message-Id: <20190627003021.19867-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 9476274093a0e79b905f4cd6cf6d149f65e02c17 ]

Left shifting the signed int value 1 by 31 bits has undefined behaviour
and the shift amount oq_no can be as much as 63.  Fix this by using
BIT_ULL(oq_no) instead.

Addresses-Coverity: ("Bad shift operation")
Fixes: f21fb3ed364b ("Add support of Cavium Liquidio ethernet adapters")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index 1c50c10b5a16..d7e805749a5b 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -964,7 +964,7 @@ static void liquidio_schedule_droq_pkt_handlers(struct octeon_device *oct)
 
 			if (droq->ops.poll_mode) {
 				droq->ops.napi_fn(droq);
-				oct_priv->napi_mask |= (1 << oq_no);
+				oct_priv->napi_mask |= BIT_ULL(oq_no);
 			} else {
 				tasklet_schedule(&oct_priv->droq_tasklet);
 			}
-- 
2.20.1

