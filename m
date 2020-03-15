Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C49185B85
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 10:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgCOJfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 05:35:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:57100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgCOJfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 05:35:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A1B44AC84;
        Sun, 15 Mar 2020 09:35:07 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, oss-drivers@netronome.com
Subject: [PATCH v2 3/6] net: nfp: Use scnprintf() for avoiding potential buffer overflow
Date:   Sun, 15 Mar 2020 10:35:00 +0100
Message-Id: <20200315093503.8558-4-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200315093503.8558-1-tiwai@suse.de>
References: <20200315093503.8558-1-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Reviewed-by: Simon Horman <simon.horman@netronome.com>
Cc: "David S . Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: oss-drivers@netronome.com
To: netdev@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: Align the remaining lines to the open parenthesis

 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index 8fde6c1f681b..a486008eb80a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -616,7 +616,7 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 	if (bar->iomem) {
 		int pf;
 
-		msg += snprintf(msg, end - msg,	"0.0: General/MSI-X SRAM, ");
+		msg += scnprintf(msg, end - msg, "0.0: General/MSI-X SRAM, ");
 		atomic_inc(&bar->refcnt);
 		bars_free--;
 
@@ -661,7 +661,7 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 
 	/* Configure, and lock, BAR0.1 for PCIe XPB (MSI-X PBA) */
 	bar = &nfp->bar[1];
-	msg += snprintf(msg, end - msg, "0.1: PCIe XPB/MSI-X PBA, ");
+	msg += scnprintf(msg, end - msg, "0.1: PCIe XPB/MSI-X PBA, ");
 	atomic_inc(&bar->refcnt);
 	bars_free--;
 
@@ -680,8 +680,8 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
 		bar->iomem = ioremap(nfp_bar_resource_start(bar),
 					     nfp_bar_resource_len(bar));
 		if (bar->iomem) {
-			msg += snprintf(msg, end - msg,
-					"0.%d: Explicit%d, ", 4 + i, i);
+			msg += scnprintf(msg, end - msg,
+					 "0.%d: Explicit%d, ", 4 + i, i);
 			atomic_inc(&bar->refcnt);
 			bars_free--;
 
-- 
2.16.4

