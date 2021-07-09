Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D163C23C7
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 14:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhGIM6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 08:58:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26223 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229671AbhGIM6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 08:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625835365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KnBrqqkjyyVhduPJxEqm+VtXVQ2YzzCLWcOyOy05cvc=;
        b=YKBfU9K8FxnB4nM5vXKs5hm+SLiBWynDDPaTSEYKR2Ej8YNNf4NcoGon7jYutXggVxuooG
        L07OlcrVUaF3LyhMu1BnEak3Mee8OO6niWTVc9bPwVZACgyGoh8YtvY5vGGWNrJusaxj5h
        NStHvoqMgZ+rjoI2oUXfS9NIcgm7PRg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-lcZvSJDZOFqEkr3C9eE3vQ-1; Fri, 09 Jul 2021 08:56:01 -0400
X-MC-Unique: lcZvSJDZOFqEkr3C9eE3vQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 391C281840A;
        Fri,  9 Jul 2021 12:56:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-113-77.ams2.redhat.com [10.36.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B36D2369A;
        Fri,  9 Jul 2021 12:55:54 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        ihuguet@redhat.com
Subject: [PATCH v2 3/3] sfc: add logs explaining XDP_TX/REDIRECT is not available
Date:   Fri,  9 Jul 2021 14:55:20 +0200
Message-Id: <20210709125520.39001-4-ihuguet@redhat.com>
In-Reply-To: <20210709125520.39001-1-ihuguet@redhat.com>
References: <20210707081642.95365-1-ihuguet@redhat.com>
 <20210709125520.39001-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If it's not possible to allocate enough channels for XDP, XDP_TX and
XDP_REDIRECT don't work. However, only a message saying that not enough
channels were available was shown, but not saying what are the
consequences in that case. The user didn't know if he/she can use XDP
or not, if the performance is reduced, or what.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index e25c8f9d9ff4..b51957e1a7de 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -170,6 +170,8 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		netif_err(efx, drv, efx->net_dev,
 			  "Insufficient resources for %d XDP event queues (%d other channels, max %d)\n",
 			  n_xdp_ev, n_channels, max_channels);
+		netif_err(efx, drv, efx->net_dev,
+			  "XDP_TX and XDP_REDIRECT will not work on this interface");
 		efx->n_xdp_channels = 0;
 		efx->xdp_tx_per_channel = 0;
 		efx->xdp_tx_queue_count = 0;
@@ -177,6 +179,8 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		netif_err(efx, drv, efx->net_dev,
 			  "Insufficient resources for %d XDP TX queues (%d other channels, max VIs %d)\n",
 			  n_xdp_tx, n_channels, efx->max_vis);
+		netif_err(efx, drv, efx->net_dev,
+			  "XDP_TX and XDP_REDIRECT will not work on this interface");
 		efx->n_xdp_channels = 0;
 		efx->xdp_tx_per_channel = 0;
 		efx->xdp_tx_queue_count = 0;
-- 
2.31.1

