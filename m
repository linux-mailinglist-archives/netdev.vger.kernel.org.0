Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C05E2A1239
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgJaAzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:55:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55872 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgJaAzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:55:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYfAZ-004RnY-2W; Sat, 31 Oct 2020 01:54:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] drivers: net: tulip: Fix set but not used with W=1
Date:   Sat, 31 Oct 2020 01:54:45 +0100
Message-Id: <20201031005445.1060112-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiled for platforms other than __i386__ or __x86_64__:

drivers/net/ethernet/dec/tulip/tulip_core.c: In function ‘tulip_init_one’:
drivers/net/ethernet/dec/tulip/tulip_core.c:1296:13: warning: variable ‘last_irq’ set but not used [-Wunused-but-set-variable]
 1296 |  static int last_irq;

Add more #if defined() to totally remove the code when not needed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/dec/tulip/tulip_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index e7b0d7de40fd..c1dcd6ca1457 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1293,7 +1293,9 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	static unsigned char last_phys_addr[ETH_ALEN] = {
 		0x00, 'L', 'i', 'n', 'u', 'x'
 	};
+#if defined(__i386__) || defined(__x86_64__)	/* Patch up x86 BIOS bug. */
 	static int last_irq;
+#endif
 	int i, irq;
 	unsigned short sum;
 	unsigned char *ee_data;
@@ -1617,7 +1619,9 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	for (i = 0; i < 6; i++)
 		last_phys_addr[i] = dev->dev_addr[i];
+#if defined(__i386__) || defined(__x86_64__)	/* Patch up x86 BIOS bug. */
 	last_irq = irq;
+#endif
 
 	/* The lower four bits are the media type. */
 	if (board_idx >= 0  &&  board_idx < MAX_UNITS) {
-- 
2.28.0

