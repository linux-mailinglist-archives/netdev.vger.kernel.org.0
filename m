Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA703602F
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfFEPRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:17:36 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:29877 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbfFEPRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1559747853;
        s=strato-dkim-0002; d=fpond.eu;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=6QLl30ammr5VgUAthBs6M8MMgp7CqG1eEV3tOWy5HEY=;
        b=qoFRHxGHp53AQmgISodvVDNMSOSLUdX6M9m9eJ+Dm/dJSk9CbKFDxXNx53v7AzFEXG
        K8+CCILEv62y/kXeOAcLqRzp2lwi3mK1Jr/4/JwkIULrpCyNMOiKJVMXSs/Qhs0ytkhn
        YBb3CB8tN8QuJsvhJlnqtrw51AVEi7wAGRzuenbTbB0oa+dLFNs/9MjJBdZAhcLAj7XU
        bX4V6+b1gjB49eZgnfH7mGPSSy/QWH2uT44RgaUg0bb158djjWXJaKywl1dVXdWYM4tu
        1a1oA+UHT93iYOAwWDHtpsbRE9XRjVp4p0f3H24TDYX+7mfF4lBDzGCWbnt9tVeHo9H+
        Y7Xw==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR82VcdxqguoQ="
X-RZG-CLASS-ID: mo00
Received: from groucho.site
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id y08c83v55FEOvhb
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 5 Jun 2019 17:14:24 +0200 (CEST)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sergei.shtylyov@cogentembedded.com, niklas.soderlund@ragnatech.se,
        wsa@the-dreams.de, horms@verge.net.au, magnus.damm@gmail.com,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v2] ravb: implement MTU change while device is up
Date:   Wed,  5 Jun 2019 17:14:20 +0200
Message-Id: <1559747660-17875-1-git-send-email-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uses the same method as various other drivers: shut the device down,
change the MTU, then bring it back up again.

Tested on Renesas D3 Draak board.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---

Hi!

This revision incorporates Simon's and Sergei's suggestions, namely calling
netdev_update_features() whether the device is up or not. Thanks to
reviewers!

CU
Uli


 drivers/net/ethernet/renesas/ravb_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index ef8f089..00427e7 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1811,11 +1811,14 @@ static int ravb_do_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 static int ravb_change_mtu(struct net_device *ndev, int new_mtu)
 {
 	if (netif_running(ndev))
-		return -EBUSY;
+		ravb_close(ndev);
 
 	ndev->mtu = new_mtu;
 	netdev_update_features(ndev);
 
+	if (netif_running(ndev))
+		return ravb_open(ndev);
+
 	return 0;
 }
 
-- 
2.7.4

