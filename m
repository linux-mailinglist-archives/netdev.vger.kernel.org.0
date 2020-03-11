Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB92181364
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 09:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgCKIiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 04:38:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:50122 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbgCKIiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 04:38:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 043B3B1BB;
        Wed, 11 Mar 2020 08:38:01 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, oss-drivers@netronome.com
Subject: [PATCH 4/7] nfp: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 09:37:42 +0100
Message-Id: <20200311083745.17328-5-tiwai@suse.de>
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
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index 8fde6c1f681b..cc311989e3d7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -616,7 +616,7 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 	if (bar->iomem) {
 		int pf;
 
-		msg += snprintf(msg, end - msg,	"0.0: General/MSI-X SRAM, ");
+		msg += scnprintf(msg, end - msg,	"0.0: General/MSI-X SRAM, ");
 		atomic_inc(&bar->refcnt);
 		bars_free--;
 
@@ -661,7 +661,7 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 
 	/* Configure, and lock, BAR0.1 for PCIe XPB (MSI-X PBA) */
 	bar = &nfp->bar[1];
-	msg += snprintf(msg, end - msg, "0.1: PCIe XPB/MSI-X PBA, ");
+	msg += scnprintf(msg, end - msg, "0.1: PCIe XPB/MSI-X PBA, ");
 	atomic_inc(&bar->refcnt);
 	bars_free--;
 
@@ -680,7 +680,7 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 		bar->iomem = ioremap(nfp_bar_resource_start(bar),
 					     nfp_bar_resource_len(bar));
 		if (bar->iomem) {
-			msg += snprintf(msg, end - msg,
+			msg += scnprintf(msg, end - msg,
 					"0.%d: Explicit%d, ", 4 + i, i);
 			atomic_inc(&bar->refcnt);
 			bars_free--;
-- 
2.16.4

