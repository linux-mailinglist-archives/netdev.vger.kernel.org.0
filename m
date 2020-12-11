Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00112D6C73
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393494AbgLKAUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394095AbgLKAT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 19:19:57 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9DDC0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 16:19:06 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id s11so8859771ljp.4
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 16:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=yZTJBhlr2RCzGQyEaOBXmrIb1weFwQLAqATlxl6cgWg=;
        b=SIVc2UvUdcGolvbUMTnODs8gXJw20s2jsA+JV6KRVtzMF4PTWh5jcp22jW46yo60Uu
         /hJg5dA0XKqU27w/9/QaMRJ06c/UpHTUYB4EmQdfWIEOkw9MAs6ljXPXQsmWFbxIJWWW
         OGwD6TJI1HinHCX3R0NrPWBzdZstKeGnjzz6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=yZTJBhlr2RCzGQyEaOBXmrIb1weFwQLAqATlxl6cgWg=;
        b=tgkhSVMy0z1IumntXTH8D5zCuILffW5uu3usUN0E/KnGbljBcIJPJigASdr5cV7WOv
         zLWOLY6YsPLmE3HDLNeUCXg6lBgzzejmpvFFItkmQqfScUiNi0u9S0HmBY7b+Tj1ORvw
         4hr5LAR7HnhzDvrDA+P/IsWc4IoAa3TPKVPovofc3vpwCyYp4Xg3POSQlMOty+T8UjhO
         yjYDwwd+1rolpRAg7CeHRWe8+eh9XQrPtdZspYEV63WE602LeZURdA0OO0+jXlA3Q+y8
         dP4mpj9EDkJ4rGXZzFg9pOWVl5fwoW0JpEwJ5kcpvguM/Vlna83blwq4762F+lTACnK/
         KzYA==
X-Gm-Message-State: AOAM531zZgzVPlUzFmD9gqP7BvqfdQWABwdsKrJNESRLm65OBf+f0auX
        iXIshbF3V7vnY5SeAo4JT36KRd5HbRs9qymDZHvv7g0x5vF94g==
X-Google-Smtp-Source: ABdhPJxtNzZXaaxyRSIz2N12wxgp3iQNoThJgrneB1JWhHcAhn1tu6/ijsA0SHenqGKCNN44YK3DT4SivvbXuPQ16C0=
X-Received: by 2002:a2e:910f:: with SMTP id m15mr3857562ljg.467.1607645944466;
 Thu, 10 Dec 2020 16:19:04 -0800 (PST)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Thu, 10 Dec 2020 16:18:53 -0800
Message-ID: <CABWYdi0+PRk8h-Az=b3GqNDO=m6RZgqDL27tgwo3yMK_05OLAw@mail.gmail.com>
Subject: [PATCH net-next] sfc: backport XDP EV queue sharing from the
 out-of-tree driver
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Queue sharing behaviour already exists in the out-of-tree sfc driver,
available under xdp_alloc_tx_resources module parameter.

This avoids the following issue on machines with many cpus:

Insufficient resources for 12 XDP event queues (24 other channels, max 32)

Which in turn triggers EINVAL on XDP processing:

sfc 0000:86:00.0 ext0: XDP TX failed (-22)

Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c
b/drivers/net/ethernet/sfc/efx_channels.c
index a4a626e9cd9a..1bfeee283ea9 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -17,6 +17,7 @@
 #include "rx_common.h"
 #include "nic.h"
 #include "sriov.h"
+#include "workarounds.h"

 /* This is the first interrupt mode to try out of:
  * 0 => MSI-X
@@ -137,6 +138,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 {
  unsigned int n_channels = parallelism;
  int vec_count;
+ int tx_per_ev;
  int n_xdp_tx;
  int n_xdp_ev;

@@ -149,9 +151,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
  * multiple tx queues, assuming tx and ev queues are both
  * maximum size.
  */
-
+ tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
  n_xdp_tx = num_possible_cpus();
- n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
+ n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);

  vec_count = pci_msix_vec_count(efx->pci_dev);
  if (vec_count < 0)
--
2.29.2
