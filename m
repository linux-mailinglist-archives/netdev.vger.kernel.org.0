Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84500210E0C
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgGAOwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:52:55 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:38732 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731596AbgGAOwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:52:53 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 44294600CE;
        Wed,  1 Jul 2020 14:52:52 +0000 (UTC)
Received: from us4-mdac16-33.ut7.mdlocal (unknown [10.7.66.150])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 42E69200A4;
        Wed,  1 Jul 2020 14:52:52 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D11C722005C;
        Wed,  1 Jul 2020 14:52:51 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8386E700082;
        Wed,  1 Jul 2020 14:52:51 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:52:46 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 04/15] sfc: move modparam 'rss_cpus' out of common
 channel code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <d1e57b7b-d7e2-eae9-d805-606a77b4ce53@solarflare.com>
Date:   Wed, 1 Jul 2020 15:52:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-0.007800-8.000000-10
X-TMASE-MatchedRID: EApzmY5DLHO4WGh1vUSL//3HILfxLV/9+LidURF+DB3Ib96UUXRrm1uq
        YpIDwN0+28G4m+3NScjEaiEZ/VWDnShwCmnYdDTlqJSK+HSPY+/pVMb1xnESMnAal2A1DQmscij
        MZrr2iZ2t2gtuWr1LmmbpUJbxMF84FJAZ9GWS7vTJ/bVh4iw9hr7DirSpOYvI0SxMhOhuA0Qcvv
        sM78SKaAE2DjEevfnaJkB8cahV/fllJTodqNqEzp4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTtwpV/tq9491hiY3ueKeP+1UijIvpqc/ci9ckK+X+OjjDEGC60g511tyHam1Q91gB85cnr
        hLdD4qBhnruAGz2uODz1musxJP9W1hjlsqLrnBN85uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwv
        JjiAfi8C+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.007800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615172-vMMtzH77Pns4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of exposing this old module parameter on the new driver (thus
 having to keep it forever after for compatibility), let's confine it
 to the old one; if we find later that we need the feature, we ought
 to support it properly, with ethtool set-channels.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 3 +++
 drivers/net/ethernet/sfc/efx_channels.c | 4 +---
 drivers/net/ethernet/sfc/efx_channels.h | 1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 9e0dbf8648ee..f4173f855438 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -68,6 +68,9 @@ module_param(interrupt_mode, uint, 0444);
 MODULE_PARM_DESC(interrupt_mode,
 		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
 
+module_param(rss_cpus, uint, 0444);
+MODULE_PARM_DESC(rss_cpus, "Number of CPUs to use for Receive-Side Scaling");
+
 /*
  * Use separate channels for TX and RX events
  *
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index e93bc37e6a7a..6e6dfe8e5ce1 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -32,9 +32,7 @@ unsigned int interrupt_mode = EFX_INT_MODE_MSIX;
  * Cards without MSI-X will only target one CPU via legacy or MSI interrupt.
  * The default (0) means to assign an interrupt to each core.
  */
-static unsigned int rss_cpus;
-module_param(rss_cpus, uint, 0444);
-MODULE_PARM_DESC(rss_cpus, "Number of CPUs to use for Receive-Side Scaling");
+unsigned int rss_cpus;
 
 static unsigned int irq_adapt_low_thresh = 8000;
 module_param(irq_adapt_low_thresh, uint, 0644);
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/efx_channels.h
index c9f0f4d0caa9..05a84ddec7fa 100644
--- a/drivers/net/ethernet/sfc/efx_channels.h
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -12,6 +12,7 @@
 #define EFX_CHANNELS_H
 
 extern unsigned int interrupt_mode;
+extern unsigned int rss_cpus;
 
 int efx_probe_interrupts(struct efx_nic *efx);
 void efx_remove_interrupts(struct efx_nic *efx);

