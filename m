Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A5A47DD30
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346809AbhLWBQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:21 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27316 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346234AbhLWBOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=lHfpOqhOfpDOCfOX9m8HbTSH198YL4xz6udBaxMWEhU=;
        b=He/CxrgZEFngolwjXHMJWEKjUhKIOSVokvqKUvxw4wiwguybmmU9i+segEnZplKOvvAG
        5jmo4LObHAT+dvq7TfL61pUedZuzA7xhnxG9Yn6r5PRe2IgXT7UISNbitqvuozqKZmImf7
        iimBVGIlEBTWSA5uCU57sYi2VtMP5BN//v1fvoU+KWrLQzm10T13c+t/adNTE4aITX7LTh
        B+8GmGlr0SOSWfl4f0hs8xcK6UAyYy71iptESF+BUtz7P5CBGJYLylyC15jowYBKtpqs2o
        2g12eiVTJOVDT2YOcE+QWqGq5uO6lDsiOTqBbdpHenorb0i7f8cPtSbCxQ4vuE1w==
Received: by filterdrecv-656998cfdd-gwqfx with SMTP id filterdrecv-656998cfdd-gwqfx-1-61C3CD5F-2
        2021-12-23 01:14:07.065548949 +0000 UTC m=+7955180.472261611
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-4-0 (SG)
        with ESMTP
        id jn2DgsfWQie8Tv6IdcNhoA
        Thu, 23 Dec 2021 01:14:06.899 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id DAF3270150E; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 44/50] wilc1000: don't allocate tx_buffer when zero-copy is
 available
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-45-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvCku2d01bUPHXOooM?=
 =?us-ascii?Q?P+=2FUf3qjDaNo4LbXVJ1cRCS8pJYe4aPxCLVg3LP?=
 =?us-ascii?Q?M7wKTY3qogKRr+YpQH0519OH2M8hpB720vzZf=2Fm?=
 =?us-ascii?Q?Pu4AobA4wGDAaffX3=2FAiXO+IIJ27yhXdgP2DzvZ?=
 =?us-ascii?Q?ojh7Lj0y9No0G+MjCFFtVHW2wR3c9jWsRNVyfT?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
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

If a driver supports zero-copy transmit transfers, there is no need to
have a transmit buffer.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index d96a7e2a0bd59..d46d6e8122c8d 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1604,12 +1604,12 @@ int wilc_wlan_init(struct net_device *dev)
 
 	init_q_limits(wilc);
 
-	if (!wilc->tx_buffer)
+	if (!wilc->hif_func->hif_sk_buffs_tx && !wilc->tx_buffer) {
 		wilc->tx_buffer = kmalloc(WILC_TX_BUFF_SIZE, GFP_KERNEL);
-
-	if (!wilc->tx_buffer) {
-		ret = -ENOBUFS;
-		goto fail;
+		if (!wilc->tx_buffer) {
+			ret = -ENOBUFS;
+			goto fail;
+		}
 	}
 
 	if (!wilc->rx_buffer)
-- 
2.25.1

