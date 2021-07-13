Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3AB3C7212
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 16:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbhGMOYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 10:24:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236947AbhGMOYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 10:24:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186114;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yFfdGC6Oeg7LSbwIRyyh03s9uKTlbokVcLTyEfN1qik=;
        b=hAOvqlEpDln2YCCseYjaly9jDXnipoNQjCv/ZwiO+fx9gv1EZCfhAk+2lDPTCO479kPwym
        7UQ62KRGyQPyhTKA/UyXlDfpXrguMmwfTNqUAvdKFkrmCo0tAXmjHH399tNn2OQAZtKC0Z
        zH7Fv+NjMeEZpA9lnIKrsxCxId594Gw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-39ZiHma5NcGFt2WbLMkZig-1; Tue, 13 Jul 2021 10:21:53 -0400
X-MC-Unique: 39ZiHma5NcGFt2WbLMkZig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 253231800D41;
        Tue, 13 Jul 2021 14:21:52 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-18.ams2.redhat.com [10.36.115.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A672A5C1C5;
        Tue, 13 Jul 2021 14:21:49 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH v3 1/3] sfc: fix lack of XDP TX queues - error XDP TX failed (-22)
Date:   Tue, 13 Jul 2021 16:21:27 +0200
Message-Id: <20210713142129.17077-2-ihuguet@redhat.com>
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

Fixes: e26ca4b53582 sfc: reduce the number of requested xdp ev queues

The buggy commit intended to allocate less channels for XDP in order to
be more unlikely to reach the limit of 32 channels of the driver.

The idea was to use each IRQ/eventqeue for more XDP TX queues than
before, calculating which is the maximum number of TX queues that one
event queue can handle. For example, in EF10 each event queue could
handle up to 8 queues, better than the 4 they were handling before the
change. This way, it would have to allocate half of channels than before
for XDP TX.

The problem is that the TX queues are also contained inside the channel
structs, and there are only 4 queues per channel. Reducing the number of
channels means also reducing the number of queues, resulting in not
having the desired number of 1 queue per CPU.

This leads to getting errors on XDP_TX and XDP_REDIRECT if they're
executed from a high numbered CPU, because there only exist queues for
the low half of CPUs, actually. If XDP_TX/REDIRECT is executed in a low
numbered CPU, the error doesn't happen. This is the error in the logs
(repeated many times, even rate limited):
sfc 0000:5e:00.0 ens3f0np0: XDP TX failed (-22)

This errors happens in function efx_xdp_tx_buffers, where it expects to
have a dedicated XDP TX queue per CPU.

Reverting the change makes again more likely to reach the limit of 32
channels in machines with many CPUs. If this happen, no XDP_TX/REDIRECT
will be possible at all, and we will have this log error messages:

At interface probe:
sfc 0000:5e:00.0: Insufficient resources for 12 XDP event queues (24 other channels, max 32)

At every subsequent XDP_TX/REDIRECT failure, rate limited:
sfc 0000:5e:00.0 ens3f0np0: XDP TX failed (-22)

However, without reverting the change, it makes the user to think that
everything is OK at probe time, but later it fails in an unpredictable
way, depending on the CPU that handles the packet.

It is better to restore the predictable behaviour. If the user sees the
error message at probe time, he/she can try to configure the best way it
fits his/her needs. At least, he/she will have 2 options:
- Accept that XDP_TX/REDIRECT is not available (he/she may not need it)
- Load sfc module with modparam 'rss_cpus' with a lower number, thus
  creating less normal RX queues/channels, letting more free resources
  for XDP, with some performance penalty.

Anyway, let the calculation of maximum TX queues that can be handled by
a single event queue, and use it only if it's less than the number of TX
queues per channel. This doesn't happen in practice, but could happen if
some constant values are tweaked in the future, such us
EFX_MAX_TXQ_PER_CHANNEL, EFX_MAX_EVQ_SIZE or EFX_MAX_DMAQ_SIZE.

Related mailing list thread:
https://lore.kernel.org/bpf/20201215104327.2be76156@carbon/

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index a3ca406a3561..5b71f8a03a6d 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -152,6 +152,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	 * maximum size.
 	 */
 	tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
+	tx_per_ev = min(tx_per_ev, EFX_MAX_TXQ_PER_CHANNEL);
 	n_xdp_tx = num_possible_cpus();
 	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
 
@@ -181,7 +182,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		efx->xdp_tx_queue_count = 0;
 	} else {
 		efx->n_xdp_channels = n_xdp_ev;
-		efx->xdp_tx_per_channel = EFX_MAX_TXQ_PER_CHANNEL;
+		efx->xdp_tx_per_channel = tx_per_ev;
 		efx->xdp_tx_queue_count = n_xdp_tx;
 		n_channels += n_xdp_ev;
 		netif_dbg(efx, drv, efx->net_dev,
-- 
2.31.1

