Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDE6517549
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380831AbiEBRGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 13:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348506AbiEBRGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 13:06:31 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FF1218F
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 10:02:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so13238916pjf.0
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 10:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=mV1xvwZ0Hb92BiYxZkk5VRKr2jXhGJ2gLZeXoflIIoE=;
        b=fp528TSVpn74cGGQ5pe9dKbEH2Rn9RbFh1Zi6xA7J+zciVgn44wR8stv7XLdF0xMWt
         LeiyesGCkcSdutcxcJaT19lhYfRsBWMfOXYPYvRIe24UCGi+cv32XU5osr6iR3MaS0RJ
         2dKy45SvHsBuGM6QdhuTur/2j7Og0vbJULS8qbb9B4IM+/J6EjSfso0JBj7aKMf42TNv
         lGjsBkiHkwf84YlxlRav0/Vyzew3hKPGIeKzIIdVWGnYlfRUtfCajIj7B7z1h3dxyq4w
         sd5KGgjOuSvZPto5JLdiyRu89w4mKtkO+b5E2Wg45iFQFWVMTISgaECI5IfxpvLMbjzH
         Rajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mV1xvwZ0Hb92BiYxZkk5VRKr2jXhGJ2gLZeXoflIIoE=;
        b=yYmcP+SFgN3yQ1kxHHicVbw+OUqT6y8h4NWQq95lb93tj9ioevGE7JTIpt2k031tYe
         VvSDZ01PHucAU9ILmb6yeyOxYpkt9Z8X+YX8RR4B5ahg1F9eDkV+dbka2l6Jnlb0v2ON
         YAtWF3Tjfan7+Uck6BNsspX5BSz79LLh40s34V1VlT4tISCuyl8qgc7/tTdfsRRGgv41
         NhbnXp1CoHuDFesXV/R3sGqoYmWvdwleTyxSP4HyKgy7F8sfNwn/QJ7FRfvpdWKP7yr+
         vYZOOyTQ5IFE0vQ4FJrppUi4JATl4tPgB8D/Ph4AUCmiWu3k6XfhzvObk0WqwKgdo0VH
         iFQA==
X-Gm-Message-State: AOAM531zVGcKTOiYbtbxWcvNH9v81ejRJU64QBpjImHqgcYvbLJFD023
        h3tLfMrGoSElMMFdSqZ1MxM=
X-Google-Smtp-Source: ABdhPJzs9AfQHgp3d9KHD38p1hOvVmZIygGZn3tBT9ymmppUcqfaC5zQ7u+9Z3GBAW8Pi8l1sfH+gQ==
X-Received: by 2002:a17:902:82c2:b0:15c:ea48:c1eb with SMTP id u2-20020a17090282c200b0015cea48c1ebmr12457403plz.123.1651510979317;
        Mon, 02 May 2022 10:02:59 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id z24-20020a63d018000000b003c14af50629sm11408274pgf.65.2022.05.02.10.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 10:02:57 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        bhutchings@solarflare.com, smhodgson@solarflare.com
Cc:     ap420073@gmail.com
Subject: [PATCH net] net: sfc: fix memory leak due to ptp channel
Date:   Mon,  2 May 2022 17:02:32 +0000
Message-Id: <20220502170232.4351-1-ap420073@gmail.com>
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
There are some values, they are related to ring buffer size.
a. efx->rxq_entries
 - This is a global value of rx queue size.
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
So, about 3K ring buffers will be overwritten to the array.
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
 drivers/net/ethernet/sfc/efx_channels.c |  7 ++++++-
 drivers/net/ethernet/sfc/ptp.c          | 13 ++++++++++++-
 drivers/net/ethernet/sfc/ptp.h          |  1 +
 3 files changed, 19 insertions(+), 2 deletions(-)

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
index f0ef515e2ade..2cf714f92655 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -45,6 +45,7 @@
 #include "farch_regs.h"
 #include "tx.h"
 #include "nic.h" /* indirectly includes ptp.h */
+#include "efx_channels.h"
 
 /* Maximum number of events expected to make up a PTP event */
 #define	MAX_EVENT_FRAGS			3
@@ -541,6 +542,11 @@ struct efx_channel *efx_ptp_channel(struct efx_nic *efx)
 	return efx->ptp_data ? efx->ptp_data->channel : NULL;
 }
 
+void efx_ptp_update_channel(struct efx_nic *efx, struct efx_channel *channel)
+{
+	efx->ptp_data->channel = channel;
+}
+
 static u32 last_sync_timestamp_major(struct efx_nic *efx)
 {
 	struct efx_channel *channel = efx_ptp_channel(efx);
@@ -1443,6 +1449,11 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
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
@@ -2176,7 +2187,7 @@ static const struct efx_channel_type efx_ptp_channel_type = {
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

