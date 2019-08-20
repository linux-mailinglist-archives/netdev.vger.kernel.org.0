Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7524C968D2
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbfHTTBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:01:53 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:20876 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729231AbfHTTBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1566327711;
        s=strato-dkim-0002; d=fpond.eu;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=YR8nMtyph3dCF3soDhEjLugd79rphqAr6Ye8dIB6CqU=;
        b=q1mdJAyeB84VOMze6Q+rA8x0mIzz8iFpOLgo3vcSx2HSkczYni8wx3f3hKK8rYNFnM
        E1ocGOfjsdrIeI/fOPPfu8KkKyTsDx18uk24NPikmWFgHzBqYJlVW9vzXjGJN7vtK6Y9
        lIMYv3JPNk7CsjByBCedO9H0vF4UuJX5vqju4HjoBfIYj59DAr5ZTTEUlRxEDXnGf2sw
        TqSAx4iCp8GlaKIaTsqRY9PAowtsId9PZEfYo3+1zIyaKwbr7hUmf7r4jmEYMGzR8mb/
        SZXQADvSByCvFgtGpa3oJjUJrbNn06mLG4s50q8UjZ5xEP5fePJ1yG7B4KIERJ8WSbar
        tTIw==
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR8GNfd+CVsQ=="
X-RZG-CLASS-ID: mo00
Received: from groucho.site
        by smtp.strato.de (RZmta 44.26.1 DYNA|AUTH)
        with ESMTPSA id K077a3v7KJ1WNTr
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 20 Aug 2019 21:01:32 +0200 (CEST)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sergei.shtylyov@cogentembedded.com, niklas.soderlund@ragnatech.se,
        wsa@the-dreams.de, horms@verge.net.au, magnus.damm@gmail.com,
        geert@glider.be, Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v3] ravb: implement MTU change while device is up
Date:   Tue, 20 Aug 2019 21:01:26 +0200
Message-Id: <1566327686-8996-1-git-send-email-uli+renesas@fpond.eu>
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

Tested on Renesas D3 Draak and M3-W Salvator-X boards.

Signed-off-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
---

Hi!

This revision reverts the MTU change if re-opening the device fails.

CU
Uli


 drivers/net/ethernet/renesas/ravb_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index ef8f089..402bcec 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1810,12 +1810,24 @@ static int ravb_do_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 
 static int ravb_change_mtu(struct net_device *ndev, int new_mtu)
 {
+	unsigned int old_mtu = ndev->mtu;
+
 	if (netif_running(ndev))
-		return -EBUSY;
+		ravb_close(ndev);
 
 	ndev->mtu = new_mtu;
 	netdev_update_features(ndev);
 
+	if (netif_running(ndev)) {
+		int err = ravb_open(ndev);
+
+		if (err) {
+			ndev->mtu = old_mtu;
+			netdev_update_features(ndev);
+			return err;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.7.4

