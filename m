Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E2E519F9D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 14:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349680AbiEDMhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 08:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349760AbiEDMh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 08:37:27 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884BE393C2
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 05:33:51 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id a191so1060682pge.2
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 05:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=59JAx/+w145DjsffiWqvkZWOVGjA4VcA9/VKW0w5Gt0=;
        b=jdfcZO/3qo6p39+43s2M3ORLGQkBjo85VTdCB5sC8RHVPd9CW3o3p3FVN/oQuFmy4/
         8+Skpnp2aDNKbGn6TiZvbT74DMsjPr7cfsqcM6aOLOhEeUtG3/h7itkdm/ssSvTLPoXE
         ikpaX80LCgrGtmLgHw5YryW4a0K8Z0NfM0OuTEixcvW+/FrBBGmnBuOxi14l5dyuENBH
         fDsFXAcLnmABfOc9TYXJfyyIgIhGGnrbyxAfEg7K6KnXIlbyZMwmeKL4QTJnHqDUF6u1
         Zvc/rFo3oohJNCw9BruPTDzh2jo7KFLdZvb6BsdocnfY0zemTTf1THYC2FfLBvY+wTMz
         m84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=59JAx/+w145DjsffiWqvkZWOVGjA4VcA9/VKW0w5Gt0=;
        b=yXmP2rRCVWtt5TOoZt7qYEzFYEYuOaqwhiaipRc1MqRPju2huoU1yt2+dYXiGgA0Up
         1O0SFqcwAYa0fRDMOeinuHIVvTZoHHSxX/8s9MRcDanDeGw3eWAUkvNgu43q9PkZgi9p
         8eNS6ME+srwi35l4r5RdmP6p6q0YBBjRD8DOJHhlnK5UnXyZIZ4gPk0AVIduERpYaxbx
         Z/jTVcUd4ifmwHB0rdeLdUHjmYhfTYlRBuEgWtDkzn3rPApTjuPMvTcYUi9YboU1Tbw4
         5w43jPA9pqzKTjOsjKH0nZRLciy4n5FmBzumgnEJBzg3FgVuZStKl8ywSkdIb+4C4CTa
         zmqw==
X-Gm-Message-State: AOAM531P8Ez6wY7xfPVJvQNRKX6r7EdOkj1tMCBo16VqPBySjTfMFlC7
        vUplkJ9J3hxB3kTNuytVSuT5CnDfcHc=
X-Google-Smtp-Source: ABdhPJwI3uvEe2gODX4Of6mZc+Ua20j9ymQhRH6Gu5iNBngQDMXR+uwzLAxRR877S4b8pEOQWICHpw==
X-Received: by 2002:a63:3144:0:b0:3c1:457c:bc18 with SMTP id x65-20020a633144000000b003c1457cbc18mr17840689pgx.582.1651667630918;
        Wed, 04 May 2022 05:33:50 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id u7-20020a170902a60700b0015e8d4eb2cesm8220058plq.280.2022.05.04.05.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 05:33:50 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v2] net: sfc: fix memory leak due to ptp channel
Date:   Wed,  4 May 2022 12:32:27 +0000
Message-Id: <20220504123227.19434-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It fixes memory leak in ring buffer change logic.

When ring buffer size is changed(ethtool -G eth0 rx 4096), sfc driver
works like below.
1. stop all channels and remove ring buffers.
2. allocates new buffer array.
3. allocates rx buffers.
4. start channels.

While the above steps are working, it skips some steps if the channel
doesn't have a ->copy callback function.
Due to ptp channel doesn't have ->copy callback, these above steps are
skipped for ptp channel.
It eventually makes some problems.
a. ptp channel's ring buffer size is not changed, it works only
   1024(default).
b. memory leak.

The reason for memory leak is to use the wrong ring buffer values.
There are some values, which is related to ring buffer size.
a. efx->rxq_entries
 - This is global value of rx queue size.
b. rx_queue->ptr_mask
 - used for access ring buffer as circular ring.
 - roundup_pow_of_two(efx->rxq_entries) - 1
c. rx_queue->max_fill
 - efx->rxq_entries - EFX_RXD_HEAD_ROOM

These all values should be based on ring buffer size consistently.
But ptp channel's values are not.
a. efx->rxq_entries
 - This is global(for sfc) value, always new ring buffer size.
b. rx_queue->ptr_mask
 - This is always 1023(default).
c. rx_queue->max_fill
 - This is new ring buffer size - EFX_RXD_HEAD_ROOM.

Let's assume we set 4096 for rx ring buffer,

                      normal channel     ptp channel
efx->rxq_entries      4096               4096
rx_queue->ptr_mask    4095               1023
rx_queue->max_fill    4086               4086

sfc driver allocates rx ring buffers based on these values.
When it allocates ptp channel's ring buffer, 4086 ring buffers are
allocated then, these buffers are attached to the allocated array.
But ptp channel's ring buffer array size is still 1024(default)
and ptr_mask is still 1023 too.
So, 3062 ring buffers will be overwritten to the array.
This is the reason for memory leak.

Test commands:
   ethtool -G <interface name> rx 4096
   while :
   do
       ip link set <interface name> up
       ip link set <interface name> down
   done

In order to avoid this problem, it adds ->copy callback to ptp channel
type.
So that rx_queue->ptr_mask value will be updated correctly.

Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - null check for efx->ptp_data in efx_ptp_update_channel()

 drivers/net/ethernet/sfc/efx_channels.c |  7 ++++++-
 drivers/net/ethernet/sfc/ptp.c          | 14 +++++++++++++-
 drivers/net/ethernet/sfc/ptp.h          |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 377df8b7f015..40df910aa140 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -867,7 +867,9 @@ static void efx_set_xdp_channels(struct efx_nic *efx)
 
 int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 {
-	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
+	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel,
+			   *ptp_channel = efx_ptp_channel(efx);
+	struct efx_ptp_data *ptp_data = efx->ptp_data;
 	unsigned int i, next_buffer_table = 0;
 	u32 old_rxq_entries, old_txq_entries;
 	int rc, rc2;
@@ -938,6 +940,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 
 	efx_set_xdp_channels(efx);
 out:
+	efx->ptp_data = NULL;
 	/* Destroy unused channel structures */
 	for (i = 0; i < efx->n_channels; i++) {
 		channel = other_channel[i];
@@ -948,6 +951,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		}
 	}
 
+	efx->ptp_data = ptp_data;
 	rc2 = efx_soft_enable_interrupts(efx);
 	if (rc2) {
 		rc = rc ? rc : rc2;
@@ -966,6 +970,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	efx->txq_entries = old_txq_entries;
 	for (i = 0; i < efx->n_channels; i++)
 		swap(efx->channel[i], other_channel[i]);
+	efx_ptp_update_channel(efx, ptp_channel);
 	goto out;
 }
 
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index f0ef515e2ade..4625f85acab2 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -45,6 +45,7 @@
 #include "farch_regs.h"
 #include "tx.h"
 #include "nic.h" /* indirectly includes ptp.h */
+#include "efx_channels.h"
 
 /* Maximum number of events expected to make up a PTP event */
 #define	MAX_EVENT_FRAGS			3
@@ -541,6 +542,12 @@ struct efx_channel *efx_ptp_channel(struct efx_nic *efx)
 	return efx->ptp_data ? efx->ptp_data->channel : NULL;
 }
 
+void efx_ptp_update_channel(struct efx_nic *efx, struct efx_channel *channel)
+{
+	if (efx->ptp_data)
+		efx->ptp_data->channel = channel;
+}
+
 static u32 last_sync_timestamp_major(struct efx_nic *efx)
 {
 	struct efx_channel *channel = efx_ptp_channel(efx);
@@ -1443,6 +1450,11 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	int rc = 0;
 	unsigned int pos;
 
+	if (efx->ptp_data) {
+		efx->ptp_data->channel = channel;
+		return 0;
+	}
+
 	ptp = kzalloc(sizeof(struct efx_ptp_data), GFP_KERNEL);
 	efx->ptp_data = ptp;
 	if (!efx->ptp_data)
@@ -2176,7 +2188,7 @@ static const struct efx_channel_type efx_ptp_channel_type = {
 	.pre_probe		= efx_ptp_probe_channel,
 	.post_remove		= efx_ptp_remove_channel,
 	.get_name		= efx_ptp_get_channel_name,
-	/* no copy operation; there is no need to reallocate this channel */
+	.copy                   = efx_copy_channel,
 	.receive_skb		= efx_ptp_rx,
 	.want_txqs		= efx_ptp_want_txqs,
 	.keep_eventq		= false,
diff --git a/drivers/net/ethernet/sfc/ptp.h b/drivers/net/ethernet/sfc/ptp.h
index 9855e8c9e544..7b1ef7002b3f 100644
--- a/drivers/net/ethernet/sfc/ptp.h
+++ b/drivers/net/ethernet/sfc/ptp.h
@@ -16,6 +16,7 @@ struct ethtool_ts_info;
 int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel);
 void efx_ptp_defer_probe_with_channel(struct efx_nic *efx);
 struct efx_channel *efx_ptp_channel(struct efx_nic *efx);
+void efx_ptp_update_channel(struct efx_nic *efx, struct efx_channel *channel);
 void efx_ptp_remove(struct efx_nic *efx);
 int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr);
 int efx_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr);
-- 
2.17.1

