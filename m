Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE02EE677
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbhAGUAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:00:54 -0500
Received: from mx3.wp.pl ([212.77.101.10]:60394 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbhAGUAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:00:54 -0500
Received: (wp-smtpd smtp.wp.pl 13924 invoked from network); 7 Jan 2021 21:00:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1610049601; bh=NgbMh0m43MYpr91iTt+EFOiOpt8PqVAKWWyc5OK+tqQ=;
          h=From:To:Cc:Subject;
          b=UaKxvar/soBKEhK/Mm2Lf7Wez8k4pgb431usFig+JoQW32SID7lxmJisz618EOZRi
           iZPmn/q3OVP+3QHpiRW9YxrAwj7la+Dlhs/SD+U+yOrSqP1b9ZqpsOTXOTNUj+t+VS
           GcRsu3wvuo7mkswlPrQje/JoabCXUDl2YygtmU2Q=
Received: from riviera.nat.student.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 7 Jan 2021 21:00:01 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] net: dsa: lantiq_gswip: Exclude RMII from modes that report 1 GbE
Date:   Thu,  7 Jan 2021 20:58:18 +0100
Message-Id: <20210107195818.3878-1-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 5a0a3badca511e65b2a69a466e678978
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [sdOE]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exclude RMII from modes that report 1 GbE support. Reduced MII supports
up to 100 MbE.

Fixes: 14fceff ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/dsa/lantiq_gswip.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 4b36d89bec06..662e68a0e7e6 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1436,11 +1436,12 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, Pause);
 	phylink_set(mask, Asym_Pause);
 
-	/* With the exclusion of MII and Reverse MII, we support Gigabit,
-	 * including Half duplex
+	/* With the exclusion of MII, Reverse MII and Reduced MII, we
+	 * support Gigabit, including Half duplex
 	 */
 	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII) {
+	    state->interface != PHY_INTERFACE_MODE_REVMII &&
+	    state->interface != PHY_INTERFACE_MODE_RMII) {
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseT_Half);
 	}
-- 
2.20.1

