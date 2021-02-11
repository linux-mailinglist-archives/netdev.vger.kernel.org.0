Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602B3318805
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 11:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhBKKV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 05:21:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:40986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhBKKS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 05:18:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613038660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rhogk/kmOD28gajRsMGG1ocHU7evgTnTuSlQWFIoQW8=;
        b=on0/DGg+97nD1nkvxkD4VEqz3oR9LkeQaHrptcUN0K8YljfnjFg68saLoRag5dRxWts5xM
        gcYtqhCRJfyj1qxrUcVplOvFvSQTRp245Dkbp+hx1i7zitTFMX0alfy6CbM8J1j2ZIVT3N
        SkPqcYJ4CUuD45OjfSfrPTh+cYiLMW0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ACC86AF0F;
        Thu, 11 Feb 2021 10:17:40 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 4/8] xen/netback: fix spurious event detection for common event case
Date:   Thu, 11 Feb 2021 11:16:12 +0100
Message-Id: <20210211101616.13788-5-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211101616.13788-1-jgross@suse.com>
References: <20210211101616.13788-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of a common event for rx and tx queue the event should be
regarded to be spurious if no rx and no tx requests are pending.

Unfortunately the condition for testing that is wrong causing to
decide a event being spurious if no rx OR no tx requests are
pending.

Fix that plus using local variables for rx/tx pending indicators in
order to split function calls and if condition.

Fixes: 23025393dbeb3b ("xen/netback: use lateeoi irq binding")
Signed-off-by: Juergen Gross <jgross@suse.com>
---
V2:
- new patch, fixing FreeBSD performance issue
---
 drivers/net/xen-netback/interface.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index acb786d8b1d8..e02a4fbb74de 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -162,13 +162,15 @@ irqreturn_t xenvif_interrupt(int irq, void *dev_id)
 {
 	struct xenvif_queue *queue = dev_id;
 	int old;
+	bool has_rx, has_tx;
 
 	old = atomic_fetch_or(NETBK_COMMON_EOI, &queue->eoi_pending);
 	WARN(old, "Interrupt while EOI pending\n");
 
-	/* Use bitwise or as we need to call both functions. */
-	if ((!xenvif_handle_tx_interrupt(queue) |
-	     !xenvif_handle_rx_interrupt(queue))) {
+	has_tx = xenvif_handle_tx_interrupt(queue);
+	has_rx = xenvif_handle_rx_interrupt(queue);
+
+	if (!has_rx && !has_tx) {
 		atomic_andnot(NETBK_COMMON_EOI, &queue->eoi_pending);
 		xen_irq_lateeoi(irq, XEN_EOI_FLAG_SPURIOUS);
 	}
-- 
2.26.2

