Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923713C7213
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 16:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbhGMOYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 10:24:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236758AbhGMOYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 10:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7rDwNk+cWe13Rfym2FX0WZN+aCzLrO13zSU7KYwuKGU=;
        b=dJ4o4V7+cmQGs6HHDKZxaZygeqQYznrhJH8uw8PfVsu0gj6rmNeIcnPATH3ddCXHwK2L54
        IaXZXKSwfmy6n0e9rqb1PWdzua3x4OXd5/W+uYd2q9fwBA+cTkuZrOyxIuvzMqrpk1S52u
        01GmyEQPLHU8I2inzYzQI2SU8I6m4II=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-VimhA1pLMw6_LPNNbUQ4bg-1; Tue, 13 Jul 2021 10:22:01 -0400
X-MC-Unique: VimhA1pLMw6_LPNNbUQ4bg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 811FE101F006;
        Tue, 13 Jul 2021 14:21:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-18.ams2.redhat.com [10.36.115.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAFD05C1C5;
        Tue, 13 Jul 2021 14:21:53 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH v3 2/3] sfc: ensure correct number of XDP queues
Date:   Tue, 13 Jul 2021 16:21:28 +0200
Message-Id: <20210713142129.17077-3-ihuguet@redhat.com>
In-Reply-To: <20210713142129.17077-1-ihuguet@redhat.com>
References: <20210707081642.95365-1-ihuguet@redhat.com>
 <20210713142129.17077-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 99ba0ea616aa ("sfc: adjust efx->xdp_tx_queue_count with the real
number of initialized queues") intended to fix a problem caused by a
round up when calculating the number of XDP channels and queues.
However, this was not the real problem. The real problem was that the
number of XDP TX queues had been reduced to half in
commit e26ca4b53582 ("sfc: reduce the number of requested xdp ev queues"),
but the variable xdp_tx_queue_count had remained the same.

Once the correct number of XDP TX queues is created again in the
previous patch of this series, this also can be reverted since the error
doesn't actually exist.

Only in the case that there is a bug in the code we can have different
values in xdp_queue_number and efx->xdp_tx_queue_count. Because of this,
and per Edward Cree's suggestion, I add instead a WARN_ON to catch if it
happens again in the future.

Note that the number of allocated queues can be higher than the number
of used ones due to the round up, as explained in the existing comment
in the code. That's why we also have to stop increasing xdp_queue_number
beyond efx->xdp_tx_queue_count.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 5b71f8a03a6d..bb48a139dd15 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -892,18 +892,20 @@ int efx_set_channels(struct efx_nic *efx)
 			if (efx_channel_is_xdp_tx(channel)) {
 				efx_for_each_channel_tx_queue(tx_queue, channel) {
 					tx_queue->queue = next_queue++;
-					netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
-						  channel->channel, tx_queue->label,
-						  xdp_queue_number, tx_queue->queue);
+
 					/* We may have a few left-over XDP TX
 					 * queues owing to xdp_tx_queue_count
 					 * not dividing evenly by EFX_MAX_TXQ_PER_CHANNEL.
 					 * We still allocate and probe those
 					 * TXQs, but never use them.
 					 */
-					if (xdp_queue_number < efx->xdp_tx_queue_count)
+					if (xdp_queue_number < efx->xdp_tx_queue_count) {
+						netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
+							  channel->channel, tx_queue->label,
+							  xdp_queue_number, tx_queue->queue);
 						efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
-					xdp_queue_number++;
+						xdp_queue_number++;
+					}
 				}
 			} else {
 				efx_for_each_channel_tx_queue(tx_queue, channel) {
@@ -915,8 +917,7 @@ int efx_set_channels(struct efx_nic *efx)
 			}
 		}
 	}
-	if (xdp_queue_number)
-		efx->xdp_tx_queue_count = xdp_queue_number;
+	WARN_ON(xdp_queue_number != efx->xdp_tx_queue_count);
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
-- 
2.31.1

