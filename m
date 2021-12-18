Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41510479E55
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhLRXyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:31 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25692 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbhLRXy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=CGtla6DXX2NW6UxMvorEq0hg5En8baXls+s5VuU2yW4=;
        b=ZT3DPigF+8Yzg//T+tvalTQV4U/iqz+uDPUDgYectHbd8Wz+Did4jaNjpb1YGt6K8Rqc
        RgZb/DGQK7zMwVNzzNn1WsyuDe2ETacSJ/C3U/BS6wzMUpn+8ZTpISTYYc28E68DCIFgch
        0loZmI1hf2frplbHUGPDkRsLy39w8cYEvX644u8W6bX8SPEThdb11Rdx19WNdvcFNhqwBs
        znplANeHSIYiKHcS5cEobKbjl8ZVGi2DwV7Hf/Wm3GRLqpXDWCWc0hrgJNuyGz+Cg3N4ya
        4/bbiDzuadYC0gAjkbA3smcEuQQ+/cunsH09Xs9z5/lS83iE3AlIN59zjTtZB71A==
Received: by filterdrecv-75ff7b5ffb-bdt5z with SMTP id filterdrecv-75ff7b5ffb-bdt5z-1-61BE74A8-34
        2021-12-18 23:54:16.964242185 +0000 UTC m=+9336801.486918079
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-1 (SG)
        with ESMTP
        id wkYIxbwqTFmuQuj_BBAN5w
        Sat, 18 Dec 2021 23:54:16.793 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id AFA9870122E; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 14/23] wilc1000: if there is no tx packet, don't increment
 packets-sent counter
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-15-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvIzRn4xIwWHyaaa0M?=
 =?us-ascii?Q?uWcdn1anLz9y3H4r2KThLcMiVEY0EIxgr1EXfxo?=
 =?us-ascii?Q?yFPRY3oI2uiNhcfBpx5zzTshO9hQbJngtu7RCDC?=
 =?us-ascii?Q?nuKS4X2Ry+G7kFYyXUn7f4=2FyfmC6nUf=2FKrtRh6D?=
 =?us-ascii?Q?qCA9Ixs7hgwSx7OGrsjormXz7GhwIbGyW5WC2l?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Granted, this case is mostly theoretical as the queue should never be
empty in this place, and hence tqe should never be NULL, but it's
still wrong to count a packet that doesn't exist.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 6484e4ab8e159..8e8f0e1de7c4c 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -893,10 +893,10 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		u8 mgmt_ptk = 0;
 
 		tqe = wilc_wlan_txq_remove_from_head(wilc, vmm_entries_ac[i]);
-		ac_pkt_num_to_chip[vmm_entries_ac[i]]++;
 		if (!tqe)
 			break;
 
+		ac_pkt_num_to_chip[vmm_entries_ac[i]]++;
 		vif = tqe->vif;
 		if (vmm_table[i] == 0)
 			break;
-- 
2.25.1

