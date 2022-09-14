Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A285B867A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiINKhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiINKg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:36:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309E378598
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 03:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663151817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Eu8ttPgASOk47VAK6XYV6Khu34KxbgQ+7lPjmHFMync=;
        b=WPxFt7oCI9XUoi6n4hZacJ5PnODS09Kp0SGS23is4hdTZQkUHY+m1vx3H5nEv8isluyLeV
        LVG/W8r/mHWVhT8L8dL9/18ZyECJJGD6OX+HSyhzfeqoMZ8m51qhGOnmc6cQv7fW8Msmr5
        TpGiqL+Y98KB7lRCKQuEOaJs/YdNJes=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-PJpvU6eLPeq5zLJuu_LIAg-1; Wed, 14 Sep 2022 06:36:54 -0400
X-MC-Unique: PJpvU6eLPeq5zLJuu_LIAg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5C212A59541;
        Wed, 14 Sep 2022 10:36:53 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 982EAC15BA4;
        Wed, 14 Sep 2022 10:36:51 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Subject: [PATCH net] sfc: fix TX channel offset when using legacy interrupts
Date:   Wed, 14 Sep 2022 12:36:48 +0200
Message-Id: <20220914103648.16902-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In legacy interrupt mode the tx_channel_offset was hardcoded to 1, but
that's not correct if efx_sepparate_tx_channels is false. In that case,
the offset is 0 because the tx queues are in the single existing channel
at index 0, together with the rx queue.

Without this fix, as soon as you try to send any traffic, it tries to
get the tx queues from an uninitialized channel getting these errors:
  WARNING: CPU: 1 PID: 0 at drivers/net/ethernet/sfc/tx.c:540 efx_hard_start_xmit+0x12e/0x170 [sfc]
  [...]
  RIP: 0010:efx_hard_start_xmit+0x12e/0x170 [sfc]
  [...]
  Call Trace:
   <IRQ>
   dev_hard_start_xmit+0xd7/0x230
   sch_direct_xmit+0x9f/0x360
   __dev_queue_xmit+0x890/0xa40
  [...]
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
  [...]
  RIP: 0010:efx_hard_start_xmit+0x153/0x170 [sfc]
  [...]
  Call Trace:
   <IRQ>
   dev_hard_start_xmit+0xd7/0x230
   sch_direct_xmit+0x9f/0x360
   __dev_queue_xmit+0x890/0xa40
  [...]

Fixes: c308dfd1b43e ("sfc: fix wrong tx channel offset with efx_separate_tx_channels")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 032b8c0bd788..5b4d661ab986 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -319,7 +319,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
-		efx->tx_channel_offset = 1;
+		efx->tx_channel_offset = efx_separate_tx_channels ? 1 : 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
-- 
2.34.1

