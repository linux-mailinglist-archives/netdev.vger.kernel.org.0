Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3BD11CD53
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 13:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbfLLMhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 07:37:53 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:1778 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729157AbfLLMhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 07:37:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576154272; x=1607690272;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=64i9dOS4nNgwTFfSAmSWV7jMZ71ZQlmzTwYxEKBpjQc=;
  b=YwBVWriEPo3H0XaPTyAZBKR5NqaZK4T5A778guGAwvIIbgmeZDPG2Zjf
   FWdHsZnMt0ZH5OhMXwuUEkLnRKErl7wIWfbWGzpiEGbke3qLO5nQ2HtTt
   vPafJLhUZ8I6k+GjL69v7M26/7zPVtfbUMf/v+jFpdgWelJdNTMRD2VMY
   g=;
IronPort-SDR: u48cjDvfsDaqvN8mi03+dtkm+PjjjAcd0TOEvApWEU4rNGoaDFBQwhsWz1lW0OSTr6EgStUtWO
 qWR9JC3DsDjA==
X-IronPort-AV: E=Sophos;i="5.69,305,1571702400"; 
   d="scan'208";a="4722440"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 12 Dec 2019 12:37:39 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id B8FDBA1CBF;
        Thu, 12 Dec 2019 12:37:36 +0000 (UTC)
Received: from EX13D32EUB004.ant.amazon.com (10.43.166.212) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Dec 2019 12:37:36 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D32EUB004.ant.amazon.com (10.43.166.212) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Dec 2019 12:37:35 +0000
Received: from u2f063a87eabd5f.cbg10.amazon.com (10.125.106.135) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Dec 2019 12:37:32 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     <netdev@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
CC:     Paul Durrant <pdurrant@amazon.com>,
        Juergen Gross <jgross@suse.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] xen-netback: avoid race that can lead to NULL pointer dereference
Date:   Thu, 12 Dec 2019 12:37:23 +0000
Message-ID: <20191212123723.21548-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2ac061ce97f4 ("xen/netback: cleanup init and deinit code")
introduced a problem. In function xenvif_disconnect_queue(), the value of
queue->rx_irq is zeroed *before* queue->task is stopped. Unfortunately that
task may call notify_remote_via_irq(queue->rx_irq) and calling that
function with a zero value results in a NULL pointer dereference in
evtchn_from_irq().

This patch simply re-orders things, stopping all tasks before zero-ing the
irq values, thereby avoiding the possibility of the race.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Juergen Gross <jgross@suse.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/net/xen-netback/interface.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 68dd7bb07ca6..f15ba3de6195 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -628,18 +628,6 @@ int xenvif_connect_ctrl(struct xenvif *vif, grant_ref_t ring_ref,
 
 static void xenvif_disconnect_queue(struct xenvif_queue *queue)
 {
-	if (queue->tx_irq) {
-		unbind_from_irqhandler(queue->tx_irq, queue);
-		if (queue->tx_irq == queue->rx_irq)
-			queue->rx_irq = 0;
-		queue->tx_irq = 0;
-	}
-
-	if (queue->rx_irq) {
-		unbind_from_irqhandler(queue->rx_irq, queue);
-		queue->rx_irq = 0;
-	}
-
 	if (queue->task) {
 		kthread_stop(queue->task);
 		queue->task = NULL;
@@ -655,6 +643,18 @@ static void xenvif_disconnect_queue(struct xenvif_queue *queue)
 		queue->napi.poll = NULL;
 	}
 
+	if (queue->tx_irq) {
+		unbind_from_irqhandler(queue->tx_irq, queue);
+		if (queue->tx_irq == queue->rx_irq)
+			queue->rx_irq = 0;
+		queue->tx_irq = 0;
+	}
+
+	if (queue->rx_irq) {
+		unbind_from_irqhandler(queue->rx_irq, queue);
+		queue->rx_irq = 0;
+	}
+
 	xenvif_unmap_frontend_data_rings(queue);
 }
 
-- 
2.20.1

