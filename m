Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8E0292DF
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389797AbfEXIVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:21:22 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:38322 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389486AbfEXIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:38 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4C1BEC012B;
        Fri, 24 May 2019 08:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686024; bh=lP9VtY1lOtTGY8SLm7ZmOqQsMGMeNGZTGbRQHkPnYhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=el7VWUldLIUp39bZa5tRJgQLcsG+czbTfwOt4MjW4hkn53xTo0DaWTy1DT0Pokqsz
         QzPUf48gpHnG/S22NTAAWH+8aSkZTOGxnqKovZJEQr//1123ru12fGHCUqrs0ldGmE
         QLLTV6znUjdipoKGxV+nivWFd2q66+wjyzXCtbu6tYbSefisTJxRno+31e9xH1UAw/
         +Oy0ToguJwVQQGiU8R+zTIErgJvCaExlprYUelR3hNeKhCJdJT8XVMNE08RSiv1TTq
         2vXKRP6g/UInVDflApTK4pIwYIs5NzWUG62qif5EASkfZR+KkJ5FxZacwVpJOB/a9/
         YWb9u2Qhagl1A==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id D6443A0254;
        Fri, 24 May 2019 08:20:37 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id BC7F73FAFC;
        Fri, 24 May 2019 10:20:35 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 06/18] net: ethernet: stmmac: dwmac-sun8i: Enable control of loopback
Date:   Fri, 24 May 2019 10:20:14 +0200
Message-Id: <79822b628dd5d8f94ceada4436b9681a84e4c45f.1558685827.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

This patch enable use of set_mac_loopback in dwmac-sun8i

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index ba124a4da793..3c7b779dcd4e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -986,6 +986,18 @@ static void sun8i_dwmac_exit(struct platform_device *pdev, void *priv)
 		regulator_disable(gmac->regulator);
 }
 
+static void sun8i_dwmac_set_mac_loopback(void __iomem *ioaddr, bool enable)
+{
+	u32 value = readl(ioaddr + EMAC_BASIC_CTL0);
+
+	if (enable)
+		value |= EMAC_LOOPBACK;
+	else
+		value &= ~EMAC_LOOPBACK;
+
+	writel(value, ioaddr + EMAC_BASIC_CTL0);
+}
+
 static const struct stmmac_ops sun8i_dwmac_ops = {
 	.core_init = sun8i_dwmac_core_init,
 	.set_mac = sun8i_dwmac_set_mac,
@@ -995,6 +1007,7 @@ static const struct stmmac_ops sun8i_dwmac_ops = {
 	.flow_ctrl = sun8i_dwmac_flow_ctrl,
 	.set_umac_addr = sun8i_dwmac_set_umac_addr,
 	.get_umac_addr = sun8i_dwmac_get_umac_addr,
+	.set_mac_loopback = sun8i_dwmac_set_mac_loopback,
 };
 
 static struct mac_device_info *sun8i_dwmac_setup(void *ppriv)
-- 
2.7.4

