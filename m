Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319064FBAE0
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244457AbiDKL30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbiDKL3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:29:25 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4ACE0427D8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 04:27:11 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 7B44A3202A5;
        Mon, 11 Apr 2022 12:27:10 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1ndsCM-0004aw-8U; Mon, 11 Apr 2022 12:27:10 +0100
Subject: [PATCH net-next 1/3] sfc: efx_default_channel_type APIs can be
 static
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 11 Apr 2022 12:27:10 +0100
Message-ID: <164967643010.17602.5885843065565588345.stgit@palantir17.mph.net>
In-Reply-To: <164967635861.17602.16525009567130361754.stgit@palantir17.mph.net>
References: <164967635861.17602.16525009567130361754.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This means we can remove them from efx_channel.h and avoid
naming conflicts later.
efx_channel_dummy_op_void() cannot be static as it is
used in ef100_nic.c.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx_channels.c |   52 +++++++++++++++++--------------
 drivers/net/ethernet/sfc/efx_channels.h |    4 --
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 377df8b7f015..eec80b024195 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -51,28 +51,7 @@ MODULE_PARM_DESC(irq_adapt_high_thresh,
  */
 static int napi_weight = 64;
 
-/***************
- * Housekeeping
- ***************/
-
-int efx_channel_dummy_op_int(struct efx_channel *channel)
-{
-	return 0;
-}
-
-void efx_channel_dummy_op_void(struct efx_channel *channel)
-{
-}
-
-static const struct efx_channel_type efx_default_channel_type = {
-	.pre_probe		= efx_channel_dummy_op_int,
-	.post_remove		= efx_channel_dummy_op_void,
-	.get_name		= efx_get_channel_name,
-	.copy			= efx_copy_channel,
-	.want_txqs		= efx_default_channel_want_txqs,
-	.keep_eventq		= false,
-	.want_pio		= true,
-};
+static const struct efx_channel_type efx_default_channel_type;
 
 /*************
  * INTERRUPTS
@@ -619,6 +598,7 @@ void efx_fini_channels(struct efx_nic *efx)
 /* Allocate and initialise a channel structure, copying parameters
  * (but not resources) from an old channel structure.
  */
+static
 struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel)
 {
 	struct efx_rx_queue *rx_queue;
@@ -696,7 +676,8 @@ static int efx_probe_channel(struct efx_channel *channel)
 	return rc;
 }
 
-void efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len)
+static void efx_get_channel_name(struct efx_channel *channel, char *buf,
+				 size_t len)
 {
 	struct efx_nic *efx = channel->efx;
 	const char *type;
@@ -1004,7 +985,7 @@ int efx_set_channels(struct efx_nic *efx)
 	return netif_set_real_num_rx_queues(efx->net_dev, efx->n_rx_channels);
 }
 
-bool efx_default_channel_want_txqs(struct efx_channel *channel)
+static bool efx_default_channel_want_txqs(struct efx_channel *channel)
 {
 	return channel->channel - channel->efx->tx_channel_offset <
 		channel->efx->n_tx_channels;
@@ -1362,3 +1343,26 @@ void efx_fini_napi(struct efx_nic *efx)
 	efx_for_each_channel(channel, efx)
 		efx_fini_napi_channel(channel);
 }
+
+/***************
+ * Housekeeping
+ ***************/
+
+static int efx_channel_dummy_op_int(struct efx_channel *channel)
+{
+	return 0;
+}
+
+void efx_channel_dummy_op_void(struct efx_channel *channel)
+{
+}
+
+static const struct efx_channel_type efx_default_channel_type = {
+	.pre_probe		= efx_channel_dummy_op_int,
+	.post_remove		= efx_channel_dummy_op_void,
+	.get_name		= efx_get_channel_name,
+	.copy			= efx_copy_channel,
+	.want_txqs		= efx_default_channel_want_txqs,
+	.keep_eventq		= false,
+	.want_pio		= true,
+};
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/efx_channels.h
index d77ec1f77fb1..64abb99a56b8 100644
--- a/drivers/net/ethernet/sfc/efx_channels.h
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -32,16 +32,13 @@ void efx_fini_eventq(struct efx_channel *channel);
 void efx_remove_eventq(struct efx_channel *channel);
 
 int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries);
-void efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len);
 void efx_set_channel_names(struct efx_nic *efx);
 int efx_init_channels(struct efx_nic *efx);
 int efx_probe_channels(struct efx_nic *efx);
 int efx_set_channels(struct efx_nic *efx);
-bool efx_default_channel_want_txqs(struct efx_channel *channel);
 void efx_remove_channel(struct efx_channel *channel);
 void efx_remove_channels(struct efx_nic *efx);
 void efx_fini_channels(struct efx_nic *efx);
-struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel);
 void efx_start_channels(struct efx_nic *efx);
 void efx_stop_channels(struct efx_nic *efx);
 
@@ -50,7 +47,6 @@ void efx_init_napi(struct efx_nic *efx);
 void efx_fini_napi_channel(struct efx_channel *channel);
 void efx_fini_napi(struct efx_nic *efx);
 
-int efx_channel_dummy_op_int(struct efx_channel *channel);
 void efx_channel_dummy_op_void(struct efx_channel *channel);
 
 #endif

