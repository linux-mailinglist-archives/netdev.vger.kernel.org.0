Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229F13BE432
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 10:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhGGITo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 04:19:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbhGGITn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 04:19:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625645822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=19cd+Ogknu9bdS1TqGvcT1juMK52/0jcS9t79NYhcGk=;
        b=KDKo0R96AdWMtIGZckeHT3y+aS7RDwKqQoM41NJnxfM7VAegYCvx/4Wzag3YQ2XOd//949
        8k2G0Dc/eMHvtjcBt9yJjozSVDlw5AODcsbf/X6rQFvHsM5LkEAJrkgAiqL5EFrRWcWdWo
        WQHJ4BBxFXgzRKdJGAHdOwL62cjfxjA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-z1KePE7DNICh5_HhXhib6Q-1; Wed, 07 Jul 2021 04:17:01 -0400
X-MC-Unique: z1KePE7DNICh5_HhXhib6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AEB5802921;
        Wed,  7 Jul 2021 08:16:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-155.ams2.redhat.com [10.36.112.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2D065D9F0;
        Wed,  7 Jul 2021 08:16:55 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ihuguet@redhat.com
Subject: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev queues"
Date:   Wed,  7 Jul 2021 10:16:40 +0200
Message-Id: <20210707081642.95365-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

However, without reverting the patch, it makes the user to think that
everything is OK at probe time, but later it fails in an unpredictable
way, depending on the CPU that handles the packet.

It is better to restore the predictable behaviour. If the user sees the
error message at probe time, he/she can try to configure the best way it
fits his needs. At least, he/she will have 2 options:
- Accept that XDP_TX/REDIRECT is not available (he/she may not need it)
- Load sfc module with modparam 'rss_cpus' with a lower number, thus
  creating less normal RX queues/channels, letting more free resources
  for XDP, with some performance penalty.

Related mailing list thread:
https://lore.kernel.org/bpf/20201215104327.2be76156@carbon/

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index a3ca406a3561..4fa5d675b6d4 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -17,7 +17,6 @@
 #include "rx_common.h"
 #include "nic.h"
 #include "sriov.h"
-#include "workarounds.h"
 
 /* This is the first interrupt mode to try out of:
  * 0 => MSI-X
@@ -138,7 +137,6 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 {
 	unsigned int n_channels = parallelism;
 	int vec_count;
-	int tx_per_ev;
 	int n_xdp_tx;
 	int n_xdp_ev;
 
@@ -151,9 +149,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	 * multiple tx queues, assuming tx and ev queues are both
 	 * maximum size.
 	 */
-	tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
+
 	n_xdp_tx = num_possible_cpus();
-	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
+	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
 
 	vec_count = pci_msix_vec_count(efx->pci_dev);
 	if (vec_count < 0)
-- 
2.31.1

