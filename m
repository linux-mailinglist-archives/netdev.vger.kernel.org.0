Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E79479E75
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbhLRXzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:55:25 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25552 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbhLRXyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=RT9YbsVtdR4GzUV4QohWzyGBC/fSE3abgungjw0gKpI=;
        b=DI2HiQJ/zFWwPLhZv+3T3Rl+KuFLuimYbfKdO+q6+UnCb3EfqWCEZoGGKbAowvAnB4bi
        GRCDd0FRQl5EkyFRKcAQZbdGeXQHhoMYZng524VREnBd7U/zyCFWzxusrnM5j/C0lRjqz2
        m/rMxD3xza4bl0bYTByPnfU5z+zT2HOmW9eGNDiVkZrOMXeMbYU84okzxmVUYUSigLVKRS
        dRCTLS5Ma2rZcdk3YVoRHdIya2pzWZrqilQOcakp0/Khmerpw7g1dMCO/wYcdna7H/7VAc
        WPyb0LSSUoeogwdKMexKnR+i3mt9TrQF0pIx6W30QZLVt09eLDB+n2sCsCe76lUg==
Received: by filterdrecv-7bf5c69d5-p7gjg with SMTP id filterdrecv-7bf5c69d5-p7gjg-1-61BE74A8-19
        2021-12-18 23:54:16.810393089 +0000 UTC m=+1581803.434338992
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-0 (SG)
        with ESMTP
        id Zo3TXZV0SyWEp2hsODIFTg
        Sat, 18 Dec 2021 23:54:16.680 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 96FCC700F5D; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 07/23] wilc1000: increment tx_dropped stat counter on tx
 packet drop
Date:   Sat, 18 Dec 2021 23:54:17 +0000 (UTC)
Message-Id: <20211218235404.3963475-8-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvED=2FzcavR1sH7nYvL?=
 =?us-ascii?Q?46KWWXmyIJ8qnkI45lXgEPjy7Xft66PMj7o6uG1?=
 =?us-ascii?Q?hrNLoSTcAe0=2F27A0i6YO161kES7Da+vJppqnTna?=
 =?us-ascii?Q?=2FPbmrsX=2FuaGwHsxvNBR8OsE33HBX3tNamvEFvyg?=
 =?us-ascii?Q?=2FO1dqF0iR0Ze4uLMdzmUwDyOauD3dsAgcF5fRX?=
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

Packet drops are important events so we should remember to count them.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index a9bfd71b0e667..b85ceda8409e6 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -202,7 +202,10 @@ static void wilc_wlan_tx_packet_done(struct txq_entry_t *tqe, int status)
 
 static void wilc_wlan_txq_drop_net_pkt(struct txq_entry_t *tqe)
 {
-	struct wilc *wilc = tqe->vif->wilc;
+	struct wilc_vif *vif = tqe->vif;
+	struct wilc *wilc = vif->wilc;
+
+	vif->ndev->stats.tx_dropped++;
 
 	wilc_wlan_txq_remove(wilc, tqe->q_num, tqe);
 	wilc_wlan_tx_packet_done(tqe, 1);
-- 
2.25.1

