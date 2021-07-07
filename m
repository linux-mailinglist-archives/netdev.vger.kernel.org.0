Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7253BE436
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 10:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhGGIUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 04:20:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230514AbhGGIUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 04:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625645839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BTtvLsx6ADO25n70Hxd42qwOHxcOR16hmE96Se7xwfo=;
        b=cDlKdffJ8CX9SxEef+h1OipVatcd9LfhVRKungb4v/U/54tVramJNKiBMcOPQmySzqxf00
        uklebzxHa35bhRvCQdk101XmqLPS3ytAdG/ywqfguXl3b2Q/mkubRWHXuzoPqcXuyBsRhu
        WBTqBJTLlYB9VP62pyC+xmLxQj1Oqyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-xY1LzlzZPqq4TU-p0elvdA-1; Wed, 07 Jul 2021 04:17:16 -0400
X-MC-Unique: xY1LzlzZPqq4TU-p0elvdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AABFA5721D;
        Wed,  7 Jul 2021 08:17:14 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-155.ams2.redhat.com [10.36.112.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C61AB5D9F0;
        Wed,  7 Jul 2021 08:17:11 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ihuguet@redhat.com
Subject: [PATCH 3/3] sfc: add logs explaining XDP_TX/REDIRECT is not available
Date:   Wed,  7 Jul 2021 10:16:42 +0200
Message-Id: <20210707081642.95365-3-ihuguet@redhat.com>
In-Reply-To: <20210707081642.95365-1-ihuguet@redhat.com>
References: <20210707081642.95365-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index a4a626e9cd9a..3c732bbe1589 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -167,6 +167,8 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		netif_err(efx, drv, efx->net_dev,
 			  "Insufficient resources for %d XDP event queues (%d other channels, max %d)\n",
 			  n_xdp_ev, n_channels, max_channels);
+		netif_err(efx, drv, efx->net_dev,
+			  "XDP_TX and XDP_REDIRECT will not work on this interface");
 		efx->n_xdp_channels = 0;
 		efx->xdp_tx_per_channel = 0;
 		efx->xdp_tx_queue_count = 0;
@@ -174,6 +176,8 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
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

