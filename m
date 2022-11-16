Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4A162B2A1
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKPFRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKPFRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:17:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780FE2EF5E
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:17:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8B71BCE1841
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B9DC433D6;
        Wed, 16 Nov 2022 05:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668575830;
        bh=aU9IOShmdlRh85Vp7sPCcZhXnbs4XepCsoX1LqP8wEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKtZjZzlgl9mTXDDGCZWL/EhIKBseSQb/L4vqBYGWms9+6LsuOLWIyhhnsBzRvGlz
         /+GmKVS95nkmVeNeG1HMjg5arVM0NJKIv7XYyn8cJYroh9nOMldwrJnhLnGCsJHU49
         hI6GHANzAUJkx3FEdI5dFE9Py/mSj6HLAGd8LfUEiVvtCqgEEIR1rLucB1gaLfhcdR
         Hdu0/0zheSMyGjD9/IdN1p/1y4u9X+BMZ0Q2lDYM/v2GT3Yk1kJ/KhN1o7Ae4l3pNH
         wESa4cJiyhO+7CA5KrktORqqdTmB2wnkrxL/vmqdDun6IYuESIclrP6eDWLKDMOeWB
         MLYJCt3Sb2bFA==
Date:   Tue, 15 Nov 2022 21:17:06 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com
Subject: Re: [PATCH net-next v3 2/2] gve: Handle alternate miss completions
Message-ID: <Y3RyUn8RLzyA6bGF@x130.lan>
References: <20221114233514.1913116-1-jeroendb@google.com>
 <20221114233514.1913116-3-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221114233514.1913116-3-jeroendb@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Nov 15:35, Jeroen de Borst wrote:
>The virtual NIC has 2 ways of indicating a miss-path
>completion. This handles the alternate.
>
>Signed-off-by: Jeroen de Borst <jeroendb@google.com>
>Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>---
> drivers/net/ethernet/google/gve/gve_adminq.h   |  4 +++-
> drivers/net/ethernet/google/gve/gve_desc_dqo.h |  5 +++++
> drivers/net/ethernet/google/gve/gve_tx_dqo.c   | 18 ++++++++++++------
> 3 files changed, 20 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
>index b9ee8be73f96..cf29662e6ad1 100644
>--- a/drivers/net/ethernet/google/gve/gve_adminq.h
>+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
>@@ -154,6 +154,7 @@ enum gve_driver_capbility {
> 	gve_driver_capability_gqi_rda = 1,
> 	gve_driver_capability_dqo_qpl = 2, /* reserved for future use */
> 	gve_driver_capability_dqo_rda = 3,
>+	gve_driver_capability_alt_miss_compl = 4,
> };
>
> #define GVE_CAP1(a) BIT((int)a)
>@@ -164,7 +165,8 @@ enum gve_driver_capbility {
> #define GVE_DRIVER_CAPABILITY_FLAGS1 \
> 	(GVE_CAP1(gve_driver_capability_gqi_qpl) | \
> 	 GVE_CAP1(gve_driver_capability_gqi_rda) | \
>-	 GVE_CAP1(gve_driver_capability_dqo_rda))
>+	 GVE_CAP1(gve_driver_capability_dqo_rda) | \
>+	 GVE_CAP1(gve_driver_capability_alt_miss_compl))
>
> #define GVE_DRIVER_CAPABILITY_FLAGS2 0x0
> #define GVE_DRIVER_CAPABILITY_FLAGS3 0x0
>diff --git a/drivers/net/ethernet/google/gve/gve_desc_dqo.h b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
>index e8fe9adef7f2..f79cd0591110 100644
>--- a/drivers/net/ethernet/google/gve/gve_desc_dqo.h
>+++ b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
>@@ -176,6 +176,11 @@ static_assert(sizeof(struct gve_tx_compl_desc) == 8);
> #define GVE_COMPL_TYPE_DQO_MISS 0x1 /* Miss path completion */
> #define GVE_COMPL_TYPE_DQO_REINJECTION 0x3 /* Re-injection completion */
>
>+/* The most significant bit in the completion tag can change the completion
>+ * type from packet completion to miss path completion.
>+ */
>+#define GVE_ALT_MISS_COMPL_BIT BIT(15)
>+
> /* Descriptor to post buffers to HW on buffer queue. */
> struct gve_rx_desc_dqo {
> 	__le16 buf_id; /* ID returned in Rx completion descriptor */
>diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
>index 588d64819ed5..762915c6063b 100644
>--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
>+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
>@@ -953,12 +953,18 @@ int gve_clean_tx_done_dqo(struct gve_priv *priv, struct gve_tx_ring *tx,
> 			atomic_set_release(&tx->dqo_compl.hw_tx_head, tx_head);
> 		} else if (type == GVE_COMPL_TYPE_DQO_PKT) {
> 			u16 compl_tag = le16_to_cpu(compl_desc->completion_tag);
>-
>-			gve_handle_packet_completion(priv, tx, !!napi,
>-						     compl_tag,
>-						     &pkt_compl_bytes,
>-						     &pkt_compl_pkts,
>-						     /*is_reinjection=*/false);
>+			if (compl_tag & GVE_ALT_MISS_COMPL_BIT) {
>+				compl_tag &= ~GVE_ALT_MISS_COMPL_BIT;

nit: __test_and_clear_bit() and reduce to oneline. also you can drop the
braces in the if else statements once you squashed the two lines.

>+				gve_handle_miss_completion(priv, tx, compl_tag,
>+							   &miss_compl_bytes,
>+							   &miss_compl_pkts);
>+			} else {
>+				gve_handle_packet_completion(priv, tx, !!napi,
>+							     compl_tag,
>+							     &pkt_compl_bytes,
>+							     &pkt_compl_pkts,
>+							     /*is_reinjection=*/false);
>+			}
> 		} else if (type == GVE_COMPL_TYPE_DQO_MISS) {
> 			u16 compl_tag = le16_to_cpu(compl_desc->completion_tag);
>
>-- 
>2.38.1.431.g37b22c650d-goog
>
