Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EB31EF7E6
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgFEM3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:29:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgFEMZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 08:25:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F17072075B;
        Fri,  5 Jun 2020 12:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359945;
        bh=pLoF6CctGEQJ++vNC1sEPzcqQMNSpnwUdvyBSVNNa/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viD7xH2llsmyz3vCEfzjxxucc9KKYU3dixjNeBDFKWKNPbaCZYRUVCjb1SEES2SVJ
         cqwKfi6ckI8BRSM7MOxUeDhHpic765XX4gfsxGddDrTx8sROe/102bWh5KakRbxCiw
         fsFUwOEfgedxEPQI+hoSpNEgSAH8dPkV5z40zISY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 04/14] net: stmmac: enable timestamp snapshot for required PTP packets in dwmac v5.10a
Date:   Fri,  5 Jun 2020 08:25:30 -0400
Message-Id: <20200605122540.2882539-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122540.2882539-1-sashal@kernel.org>
References: <20200605122540.2882539-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit f2fb6b6275eba9d312957ca44c487bd780da6169 ]

For rx filter 'HWTSTAMP_FILTER_PTP_V2_EVENT', it should be
PTP v2/802.AS1, any layer, any kind of event packet, but HW only
take timestamp snapshot for below PTP message: sync, Pdelay_req,
Pdelay_resp.

Then it causes below issue when test E2E case:
ptp4l[2479.534]: port 1: received DELAY_REQ without timestamp
ptp4l[2481.423]: port 1: received DELAY_REQ without timestamp
ptp4l[2481.758]: port 1: received DELAY_REQ without timestamp
ptp4l[2483.524]: port 1: received DELAY_REQ without timestamp
ptp4l[2484.233]: port 1: received DELAY_REQ without timestamp
ptp4l[2485.750]: port 1: received DELAY_REQ without timestamp
ptp4l[2486.888]: port 1: received DELAY_REQ without timestamp
ptp4l[2487.265]: port 1: received DELAY_REQ without timestamp
ptp4l[2487.316]: port 1: received DELAY_REQ without timestamp

Timestamp snapshot dependency on register bits in received path:
SNAPTYPSEL TSMSTRENA TSEVNTENA 	PTP_Messages
01         x         0          SYNC, Follow_Up, Delay_Req,
                                Delay_Resp, Pdelay_Req, Pdelay_Resp,
                                Pdelay_Resp_Follow_Up
01         0         1          SYNC, Pdelay_Req, Pdelay_Resp

For dwmac v5.10a, enabling all events by setting register
DWC_EQOS_TIME_STAMPING[SNAPTYPSEL] to 2’b01, clearing bit [TSEVNTENA]
to 0’b0, which can support all required events.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1623516efb17..982be75fde83 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -630,7 +630,8 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
 			ptp_v2 = PTP_TCR_TSVER2ENA;
 			snap_type_sel = PTP_TCR_SNAPTYPSEL_1;
-			ts_event_en = PTP_TCR_TSEVNTENA;
+			if (priv->synopsys_id != DWMAC_CORE_5_10)
+				ts_event_en = PTP_TCR_TSEVNTENA;
 			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
 			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
 			ptp_over_ethernet = PTP_TCR_TSIPENA;
-- 
2.25.1

