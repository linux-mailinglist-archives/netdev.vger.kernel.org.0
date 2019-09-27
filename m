Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517DDC0319
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfI0KOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:14:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:56910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbfI0KOx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:14:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 993D8AE99;
        Fri, 27 Sep 2019 10:14:51 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/17] staging: qlge: Fix irq masking in INTx mode
Date:   Fri, 27 Sep 2019 19:11:55 +0900
Message-Id: <20190927101210.23856-2-bpoirier@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190927101210.23856-1-bpoirier@suse.com>
References: <20190927101210.23856-1-bpoirier@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tracing the driver operation reveals that the INTR_EN_EN bit (per-queue
interrupt control) does not immediately prevent rx completion interrupts
when the device is operating in INTx mode. This leads to interrupts being
raised while napi is scheduled/running. Those interrupts are ignored by
qlge_isr() and falsely reported as IRQ_NONE thanks to the irq_cnt scheme.
This in turn can cause frames to loiter in the receive queue until a later
frame leads to another rx interrupt that will schedule napi.

Use the INTR_EN_EI bit (master interrupt control) instead.

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/staging/qlge/qlge_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 6cae33072496..d7b64d360ea8 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3366,6 +3366,7 @@ static void ql_enable_msix(struct ql_adapter *qdev)
 		}
 	}
 	qlge_irq_type = LEG_IRQ;
+	set_bit(QL_LEGACY_ENABLED, &qdev->flags);
 	netif_printk(qdev, ifup, KERN_DEBUG, qdev->ndev,
 		     "Running with legacy interrupts.\n");
 }
@@ -3509,6 +3510,16 @@ static void ql_resolve_queues_to_irqs(struct ql_adapter *qdev)
 		intr_context->intr_dis_mask =
 		    INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
 		    INTR_EN_TYPE_DISABLE;
+		if (test_bit(QL_LEGACY_ENABLED, &qdev->flags)) {
+			/* Experience shows that when using INTx interrupts,
+			 * the device does not always auto-mask INTR_EN_EN.
+			 * Moreover, masking INTR_EN_EN manually does not
+			 * immediately prevent interrupt generation.
+			 */
+			intr_context->intr_en_mask |= INTR_EN_EI << 16 |
+				INTR_EN_EI;
+			intr_context->intr_dis_mask |= INTR_EN_EI << 16;
+		}
 		intr_context->intr_read_mask =
 		    INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK | INTR_EN_TYPE_READ;
 		/*
-- 
2.23.0

