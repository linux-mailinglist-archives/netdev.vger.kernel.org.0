Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A696B1190BB
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfLJTep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:34:45 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:44108 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbfLJTeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:34:08 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 426DFC0BAB;
        Tue, 10 Dec 2019 19:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576006448; bh=vCs44WsolU5VcZ1RjvraNJ29UNvGkT8Makvl4mwtSgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Ku9NxyetEALpDuGj9KjeXbHuofEbbAA11Lq8tx+orJPXVgu9iqvfoXZlhe+LxSsGk
         8Y4KzGMeZXofkeJNcFMutWgyn4cy/ZyHunRGKEZrxIs9FvSwAPtWKHmoTTm7oBqDHN
         Lnct2AzSXSMTQwRhUI2yJLFs0XBSmLxQ1NhfRumXXIjmwa1zr6JZIxIkDbwnsan7V/
         aL4mEgD9rzxnYzRfJPsM06A3kU2J0YpjshLsBKJ4/63LCuWLNtDE4HxX0LwESwS5Tz
         bHvQ6Yx6uDUiGgsndUTBYdwWHgQUVvj5TydNo/7OICkVK+2LYc/rFwdzYyEik4to9S
         s3zbNPEL29hvA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id EA865A0096;
        Tue, 10 Dec 2019 19:34:05 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 4/8] net: stmmac: Only the last buffer has the FCS field
Date:   Tue, 10 Dec 2019 20:33:56 +0100
Message-Id: <bc4689a359d189c8ed1573aa6eecd81756a3277c.1576005975.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576005975.git.Jose.Abreu@synopsys.com>
References: <cover.1576005975.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576005975.git.Jose.Abreu@synopsys.com>
References: <cover.1576005975.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only the last received buffer contains the FCS field. Check for end of
packet before trying to strip the FCS field.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2ebac89049ed..8c191e4d35d0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3644,8 +3644,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		 * feature is always disabled and packets need to be
 		 * stripped manually.
 		 */
-		if (unlikely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
-		    unlikely(status != llc_snap)) {
+		if (likely(!(status & rx_not_ls)) &&
+		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
+		     unlikely(status != llc_snap))) {
 			if (buf2_len)
 				buf2_len -= ETH_FCS_LEN;
 			else
-- 
2.7.4

