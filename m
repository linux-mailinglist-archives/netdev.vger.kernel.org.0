Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE46A3FE29D
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242634AbhIAS4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:56:55 -0400
Received: from srv4.3e8.eu ([193.25.101.238]:47516 "EHLO srv4.3e8.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244885AbhIAS4r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 14:56:47 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Sep 2021 14:56:46 EDT
Received: from localhost.localdomain (p200300c6cf00f4a0fb6150d4fe58c8c6.dip0.t-ipconnect.de [IPv6:2003:c6:cf00:f4a0:fb61:50d4:fe58:c8c6])
        (using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits))
        (No client certificate requested)
        by srv4.3e8.eu (Postfix) with ESMTPSA id 4606360073;
        Wed,  1 Sep 2021 20:50:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=3e8.eu;
        s=mail20170724; t=1630522230;
        bh=hNFM2gVEBALoJMZSA7sQrNXXty19/O76YMpg+mcb7EU=;
        h=From:To:Cc:Subject:Date:From;
        b=fMRo0d6PtADARNmlU4L2mrr5VdmxgVPtsy2UTS1VySUk/y4su3T5PHbPkYvM82lx+
         FZa1qTljlVb0ISjTRTEAqEdQla2Wpv2hEphdjuRZ7qqFVDibEJMMg2XECycDmv1tf6
         rnuJGSG0AzfHyBDkq+Swa+Q+NyA4RPfo6rWthi7pCGWMSZWMm4tqPobQj/iIXt4ShH
         YZdR19uXM5N7EzUPeGfM4f25XM29WtVD+4nO72yz9r1kkb0GBfdnksKASDNhIjqOlf
         qzVd7TvC+I9jgyzLnqd1zZiSYJHmnEMyVnaYag3jVvxnOsbO6tBuKRn8T6Za9/8Qg+
         GeAvg/ktD7ZsA==
From:   Jan Hoffmann <jan@3e8.eu>
To:     hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     Jan Hoffmann <jan@3e8.eu>, stable@vger.kernel.org
Subject: [PATCH net] net: dsa: lantiq_gswip: fix maximum frame length
Date:   Wed,  1 Sep 2021 20:49:33 +0200
Message-Id: <20210901184933.312389-1-jan@3e8.eu>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, outgoing packets larger than 1496 bytes are dropped when
tagged VLAN is used on a switch port.

Add the frame check sequence length to the value of the register
GSWIP_MAC_FLEN to fix this. This matches the lantiq_ppa vendor driver,
which uses a value consisting of 1518 bytes for the MAC frame, plus the
lengths of special tag and VLAN tags.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Hoffmann <jan@3e8.eu>
---
 drivers/net/dsa/lantiq_gswip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e78026ef6d8c..64d6dfa83122 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -843,7 +843,8 @@ static int gswip_setup(struct dsa_switch *ds)
 
 	gswip_switch_mask(priv, 0, GSWIP_MAC_CTRL_2_MLEN,
 			  GSWIP_MAC_CTRL_2p(cpu_port));
-	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8, GSWIP_MAC_FLEN);
+	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8 + ETH_FCS_LEN,
+		       GSWIP_MAC_FLEN);
 	gswip_switch_mask(priv, 0, GSWIP_BM_QUEUE_GCTRL_GL_MOD,
 			  GSWIP_BM_QUEUE_GCTRL);
 
-- 
2.33.0

