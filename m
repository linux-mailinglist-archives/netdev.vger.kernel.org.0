Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418AD3DA215
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhG2L1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:27:50 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:22118 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbhG2L1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 07:27:49 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d05 with ME
        id azTi2500F21Fzsu03zTjaB; Thu, 29 Jul 2021 13:27:44 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 29 Jul 2021 13:27:44 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, angelo@kernel-space.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] can: flexcan: Fix an uninitialized variable issue
Date:   Thu, 29 Jul 2021 13:27:42 +0200
Message-Id: <a55780a2f4c8f1895b6bcbac4d3f8312b2731079.1627557857.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If both 'clk_ipg' and 'clk_per' are NULL, we return an un-init value.
So set 'err' to 0, to return success in such a case.

Fixes: d9cead75b1c6 ("can: flexcan: add mcf5441x support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Another way to fix it is to remove the NULL checks for 'clk_ipg' and
'clk_per' that been added in commit d9cead75b1c6.

They look useless to me because 'clk_prepare_enable()' returns 0 if it is
passed a NULL pointer.
Having these explicit tests is maybe informational (i.e. these pointers
can really be NULL) or have been added to silent a compiler or a static
checker.

So, in case, I've left the tests and just fixed the un-init 'err' variable
issue.
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 54ffb796a320..7734229aa078 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -649,7 +649,7 @@ static inline void flexcan_error_irq_disable(const struct flexcan_priv *priv)
 
 static int flexcan_clks_enable(const struct flexcan_priv *priv)
 {
-	int err;
+	int err = 0;
 
 	if (priv->clk_ipg) {
 		err = clk_prepare_enable(priv->clk_ipg);
-- 
2.30.2

