Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0882917D4D
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 17:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfEHP1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 11:27:46 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:32606 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfEHP1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 11:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1557329264;
        s=strato-dkim-0002; d=fpond.eu;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=PqBZE6NhWzosKKTY8fgyr23SwEQXuP4OhdOutYbtHlU=;
        b=Xk+MmxPqFdzWgL+aJwhDbNEG+nimQqAILTUL5InFoVdB7I0wxnaW1WusWEbHuGaePB
        eMmJDk3DcgiNcmXNcGYn5MOq6cbCLW2WyuPzqgQooBOtsNcqJHeJ6JNWCwiODRHjjyJ+
        ZXjAL7K6nwwoZz7EP5574o8ALg7+/Hzu58ZVz/5ubPAPDwx605H0E6zIpC6w5OEKuKvX
        nqkqkEU2hMOo1s3nKnxxT6cNyUjyrOsHPbxalt8dJedsJojhacwF8/VHjLSYc2SvF/AE
        lBDZJ1+Nx2joQmePD33AAB8azkFGWSlXbrFKtTJq10ob4vqHgHtCISCxt9ePv8u4IcPh
        jO2Q==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR82Fdd8U4C/c="
X-RZG-CLASS-ID: mo00
Received: from groucho.site
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id y08c83v48FLNUG2
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 8 May 2019 17:21:23 +0200 (CEST)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, wsa@the-dreams.de,
        horms@verge.net.au, magnus.damm@gmail.com,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH] ravb: implement MTU change while device is up
Date:   Wed,  8 May 2019 17:21:22 +0200
Message-Id: <1557328882-24307-1-git-send-email-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uses the same method as various other drivers: shut the device down,
change the MTU, then bring it back up again.

Tested on Renesas D3 Draak board.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
---
 drivers/net/ethernet/renesas/ravb_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index ef8f089..02c247c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1810,13 +1810,16 @@ static int ravb_do_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 static int ravb_change_mtu(struct net_device *ndev, int new_mtu)
 {
-	if (netif_running(ndev))
-		return -EBUSY;
+	if (!netif_running(ndev)) {
+		ndev->mtu = new_mtu;
+		netdev_update_features(ndev);
+		return 0;
+	}
 
+	ravb_close(ndev);
 	ndev->mtu = new_mtu;
-	netdev_update_features(ndev);
 
-	return 0;
+	return ravb_open(ndev);
 }
 
 static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
-- 
2.7.4

