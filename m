Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DFC3C23C6
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 14:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhGIM6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 08:58:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229671AbhGIM6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 08:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625835358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cGDwobnrbpLC4pDhNpbm4TIrRgFq4Gv1yUsaX2+7VxU=;
        b=A+R8KTH0/vRcQMtCOzO0c5DuGtd9nSg+BkoAvYF13uwcMCgVwYQlzwTx6LHpYybyVDc4Mv
        WeTRjUEMZoS9lvo8JXK/MJ+sktNWjDAP5TMUpEiwgZzzh3O6M5vMTt3AEKA/hdodCB5uXz
        sC+oKA/GoCLus+ID4V4zbUq4zxok8vI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-MWlt0K4lMXmnMPLMFF4HeQ-1; Fri, 09 Jul 2021 08:55:55 -0400
X-MC-Unique: MWlt0K4lMXmnMPLMFF4HeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6235E100C671;
        Fri,  9 Jul 2021 12:55:53 +0000 (UTC)
Received: from localhost.localdomain (ovpn-113-77.ams2.redhat.com [10.36.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5017D369A;
        Fri,  9 Jul 2021 12:55:48 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        ihuguet@redhat.com
Subject: [PATCH v2 2/3] sfc: revert "adjust efx->xdp_tx_queue_count with the real number of initialized queues"
Date:   Fri,  9 Jul 2021 14:55:19 +0200
Message-Id: <20210709125520.39001-3-ihuguet@redhat.com>
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

This reverts commit 99ba0ea616aa ("sfc: adjust efx->xdp_tx_queue_count
with the real number of initialized queues"). It intended to fix a
problem caused by a round up when calculating the number of XDP channels
and queues.

However, that was not the real problem. The real problem was that the
number of XDP TX queues created had been reduced to half in
commit e26ca4b53582 ("sfc: reduce the number of requested xdp ev queues"),
but the variable xdp_tx_queue_count had remained the same.

After reverting that commit in the previous patch of this series, this
also can be reverted since the error doesn't actually exist.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 5b71f8a03a6d..e25c8f9d9ff4 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -915,8 +915,6 @@ int efx_set_channels(struct efx_nic *efx)
 			}
 		}
 	}
-	if (xdp_queue_number)
-		efx->xdp_tx_queue_count = xdp_queue_number;
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
-- 
2.31.1

