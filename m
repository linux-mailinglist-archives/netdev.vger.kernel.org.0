Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A19F3BE434
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 10:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhGGITx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 04:19:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhGGITx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 04:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625645832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AH8+qU/Qk2ZD3toq2Bni7BQkSLoZvZC7btng1e/jRFo=;
        b=OxozQLnHc6UXAjTH4l7BaFoNhmD2udQ/2olOj/dPIUi99jHIShGbWjW8eVZLfEijYBRH5y
        KjootguJMc0JZaB2JWReiP6FVg/cewehh8lTjfyljIRxUrWMOusENLzg2fbp/zufjryvMK
        5xKnm82qka0HST3GCafyfE9VTFeHBRk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-I5fXroH0ONK-KSRgdJyozw-1; Wed, 07 Jul 2021 04:17:09 -0400
X-MC-Unique: I5fXroH0ONK-KSRgdJyozw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AB8D800050;
        Wed,  7 Jul 2021 08:17:07 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-155.ams2.redhat.com [10.36.112.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 138605D9F0;
        Wed,  7 Jul 2021 08:17:01 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ihuguet@redhat.com
Subject: [PATCH 2/3] sfc: revert "adjust efx->xdp_tx_queue_count with the real number of initialized queues"
Date:   Wed,  7 Jul 2021 10:16:41 +0200
Message-Id: <20210707081642.95365-2-ihuguet@redhat.com>
In-Reply-To: <20210707081642.95365-1-ihuguet@redhat.com>
References: <20210707081642.95365-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 4fa5d675b6d4..a4a626e9cd9a 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -912,8 +912,6 @@ int efx_set_channels(struct efx_nic *efx)
 			}
 		}
 	}
-	if (xdp_queue_number)
-		efx->xdp_tx_queue_count = xdp_queue_number;
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
-- 
2.31.1

