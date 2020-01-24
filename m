Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C311489A8
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbgAXOgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:36:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391437AbgAXOTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B04D22527;
        Fri, 24 Jan 2020 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875554;
        bh=gwglXmvrIi4VDRmJR5DkNs9Ge87mVzgPfw3jUvzxi4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5wcELfc2gYDqKxlPYmJEMV80CvZ15DNCx0lk6p04MrAwBFV2jaY7EAQ/57nRstsR
         lg6/+mpfd6xnMnhj3yl97QiFcyTYEnGXycAU/ac+OBXR2CzJoIol8EIGRhzEzHAjyQ
         MGwJGFroEBy9MLuxno1X5ITjaayPgvEjoF8EXVfo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 049/107] net: stmmac: tc: Do not setup flower filtering if RSS is enabled
Date:   Fri, 24 Jan 2020 09:17:19 -0500
Message-Id: <20200124141817.28793-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 7bd754c47dd3ad1b048c9641294b0234fcce2c58 ]

RSS, when enabled, will bypass the L3 and L4 filtering causing it not
to work. Add a check before trying to setup the filters.

Fixes: 425eabddaf0f ("net: stmmac: Implement L3/L4 Filters using TC Flower")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index f9a9a9d822333..1d135b02ea021 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -579,6 +579,10 @@ static int tc_setup_cls(struct stmmac_priv *priv,
 {
 	int ret = 0;
 
+	/* When RSS is enabled, the filtering will be bypassed */
+	if (priv->rss.enable)
+		return -EBUSY;
+
 	switch (cls->command) {
 	case FLOW_CLS_REPLACE:
 		ret = tc_add_flow(priv, cls);
-- 
2.20.1

