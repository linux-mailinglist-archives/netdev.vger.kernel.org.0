Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C2E3F33D2
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 20:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbhHTSbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 14:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238667AbhHTSbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 14:31:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D6F61242;
        Fri, 20 Aug 2021 18:30:32 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mH9Hi-006G2t-TC; Fri, 20 Aug 2021 19:30:31 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     netdev@vger.kernel.org
Cc:     kernel-team@android.com, linux-kernel@vger.kernel.org,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: [PATCH net] stmmac: Revert "stmmac: align RX buffers"
Date:   Fri, 20 Aug 2021 19:30:02 +0100
Message-Id: <20210820183002.457226-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, kernel-team@android.com, linux-kernel@vger.kernel.org, mcroce@linux.microsoft.com, kuba@kernel.org, davem@davemloft.net, eric.dumazet@gmail.com, peppe.cavallaro@st.com, alexandre.torgue@foss.st.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit a955318fe67e ("stmmac: align RX buffers"),
which breaks at least one platform (Nvidia Jetson-X1), causing
packet corruption. This is 100% reproducible, and reverting
the patch results in a working system again.

Given that it is "only" a performance optimisation, let's
return to a known working configuration until we can have a
good understanding of what is happening here.

Cc: Matteo Croce <mcroce@linux.microsoft.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Link: https://lore.kernel.org/netdev/871r71azjw.wl-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index fcdb1d20389b..43eead726886 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -339,9 +339,9 @@ static inline bool stmmac_xdp_is_enabled(struct stmmac_priv *priv)
 static inline unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
 {
 	if (stmmac_xdp_is_enabled(priv))
-		return XDP_PACKET_HEADROOM + NET_IP_ALIGN;
+		return XDP_PACKET_HEADROOM;
 
-	return NET_SKB_PAD + NET_IP_ALIGN;
+	return 0;
 }
 
 void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue);
-- 
2.30.2

