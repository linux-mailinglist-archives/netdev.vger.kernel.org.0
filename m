Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E5523393
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242909AbiEKNAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbiEKNAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:00:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E1DB229FE4
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652273998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SCuXT9FV6HOivawro9yOENh0xL3OaDu+y09TBzyK1bQ=;
        b=Zzqm8q4o5XpLSOxzxYoqrScnO8kpg5e78uOYNGqps+rL/lZ/J5AAjcZ+pM5SF8mfSWS6Er
        RPYtQUMi6ufTfRclTYvCwV1zxp8GcpnoNhHs+t443DhiiiTeYO+1pQQHXJJkdl8tw5kttM
        v9PV/4MP1vL/QJmqpLDaF0aXVbrLIq0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-i7A-WqYjOeS0_GdBE9v1Vw-1; Wed, 11 May 2022 08:59:54 -0400
X-MC-Unique: i7A-WqYjOeS0_GdBE9v1Vw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 748F5803B42;
        Wed, 11 May 2022 12:59:53 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25255438EE3;
        Wed, 11 May 2022 12:59:50 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        amaftei@solarflare.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>
Subject: [PATCH net 2/2] sfc: do not initialize non existing queues with efx_separate_tx_channels
Date:   Wed, 11 May 2022 14:59:41 +0200
Message-Id: <20220511125941.55812-3-ihuguet@redhat.com>
In-Reply-To: <20220511125941.55812-1-ihuguet@redhat.com>
References: <20220511125941.55812-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If efx_separate_tx_channels is used, some error messages and backtraces
are shown in the logs (see below). This is because during channels
start, all queues in the channels are init asumming that they exist, but
they might not if efx_separate_tx_channels is used: some channels only
have RX queues and others only have TX queues.

Avoid that by checking if the channel has TX, RX or both queues.
However, even with this patch the NIC is unusable when using
efx_separate_tx_channels, so there are more problems that I've not
identified. These messages are still shown at probe time many times:
 sfc 0000:03:00.0 (unnamed net_device) (uninitialized): MC command 0x92 inlen 8 failed rc=-71 (raw=0) arg=0
 sfc 0000:03:00.0 (unnamed net_device) (uninitialized): failed to link VI 4294967295 to PIO buffer 1 (-71)

Those messages were also shown before these patch.

And then this other message and backtrace were also shown many times,
but now they're not:
 sfc 0000:03:00.0 ens6f0np0: MC command 0x82 inlen 544 failed rc=-22 (raw=0) arg=0
 ------------[ cut here ]------------
 netdevice: ens6f0np0: failed to initialise TXQ -1
 WARNING: CPU: 1 PID: 626 at drivers/net/ethernet/sfc/ef10.c:2393 efx_ef10_tx_init+0x201/0x300 [sfc]
 [...] stripped
 RIP: 0010:efx_ef10_tx_init+0x201/0x300 [sfc]
 [...] stripped
 Call Trace:
  efx_init_tx_queue+0xaa/0xf0 [sfc]
  efx_start_channels+0x49/0x120 [sfc]
  efx_start_all+0x1f8/0x430 [sfc]
  efx_net_open+0x5a/0xe0 [sfc]
  __dev_open+0xd0/0x190
  __dev_change_flags+0x1b3/0x220
  dev_change_flags+0x21/0x60
 [...]

At remove time, these messages were shown. Now they're neither shown:
 sfc 0000:03:00.0 ens6f0np0: failed to flush 10 queues
 sfc 0000:03:00.0 ens6f0np0: failed to flush queues

Fixes: 7ec3de426014 ("sfc: move datapath management code")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index da2db6791907..b6b960e2021c 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -1139,17 +1139,21 @@ void efx_start_channels(struct efx_nic *efx)
 	struct efx_channel *channel;
 
 	efx_for_each_channel_rev(channel, efx) {
-		efx_for_each_channel_tx_queue(tx_queue, channel) {
-			efx_init_tx_queue(tx_queue);
-			atomic_inc(&efx->active_queues);
+		if (channel->channel >= efx->tx_channel_offset) {
+			efx_for_each_channel_tx_queue(tx_queue, channel) {
+				efx_init_tx_queue(tx_queue);
+				atomic_inc(&efx->active_queues);
+			}
 		}
 
-		efx_for_each_channel_rx_queue(rx_queue, channel) {
-			efx_init_rx_queue(rx_queue);
-			atomic_inc(&efx->active_queues);
-			efx_stop_eventq(channel);
-			efx_fast_push_rx_descriptors(rx_queue, false);
-			efx_start_eventq(channel);
+		if (channel->channel < efx->n_rx_channels) {
+			efx_for_each_channel_rx_queue(rx_queue, channel) {
+				efx_init_rx_queue(rx_queue);
+				atomic_inc(&efx->active_queues);
+				efx_stop_eventq(channel);
+				efx_fast_push_rx_descriptors(rx_queue, false);
+				efx_start_eventq(channel);
+			}
 		}
 
 		WARN_ON(channel->rx_pkt_n_frags);
-- 
2.34.1

