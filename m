Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55924181369
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 09:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgCKIiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 04:38:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:50160 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbgCKIiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 04:38:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12102B1C0;
        Wed, 11 Mar 2020 08:38:02 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, oss-drivers@netronome.com
Subject: [PATCH 5/7] ionic: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 09:37:43 +0100
Message-Id: <20200311083745.17328-6-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200311083745.17328-1-tiwai@suse.de>
References: <20200311083745.17328-1-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: oss-drivers@netronome.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c |  2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c           | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index cc311989e3d7..7d518999250d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -616,7 +616,7 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 	if (bar->iomem) {
 		int pf;
 
-		msg += scnprintf(msg, end - msg,	"0.0: General/MSI-X SRAM, ");
+		msg += scnprintf(msg, end - msg, "0.0: General/MSI-X SRAM, ");
 		atomic_inc(&bar->refcnt);
 		bars_free--;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index c2f5b691e0fa..09c776191edd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -948,18 +948,18 @@ static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode)
 	int i;
 #define REMAIN(__x) (sizeof(buf) - (__x))
 
-	i = snprintf(buf, sizeof(buf), "rx_mode 0x%04x -> 0x%04x:",
+	i = scnprintf(buf, sizeof(buf), "rx_mode 0x%04x -> 0x%04x:",
 		     lif->rx_mode, rx_mode);
 	if (rx_mode & IONIC_RX_MODE_F_UNICAST)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_UNICAST");
 	if (rx_mode & IONIC_RX_MODE_F_MULTICAST)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_MULTICAST");
 	if (rx_mode & IONIC_RX_MODE_F_BROADCAST)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_BROADCAST");
 	if (rx_mode & IONIC_RX_MODE_F_PROMISC)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_PROMISC");
 	if (rx_mode & IONIC_RX_MODE_F_ALLMULTI)
-		i += snprintf(&buf[i], REMAIN(i), " RX_MODE_F_ALLMULTI");
+		i += scnprintf(&buf[i], REMAIN(i), " RX_MODE_F_ALLMULTI");
 	netdev_dbg(lif->netdev, "lif%d %s\n", lif->index, buf);
 
 	err = ionic_adminq_post_wait(lif, &ctx);
-- 
2.16.4

