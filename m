Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C99E62C46F
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbiKPQay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbiKPQ3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:29:25 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA96B7E2
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 08:23:36 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso1843788wmo.1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 08:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TGqq6aQ7ZABE0Da5sqyheFL7eGFTlYjj+eXlfJbfp0w=;
        b=gn9ZdOvVO/oW9ndJbD3R1czLku3UPkr8qIPv/ER+aeVgV97zJA6oDl4uWWcFHvrCEU
         amwAunZ52L+uS+vwzb6Y+8i5c2aUkiPs+d7gtjEp1lhGzh1YjuBc0+fQt58iItx+znbR
         xBpXxqVFt2+PPXVfuXGb+1JmMYAr51r6pL+psAIrtwhwYKKNfZnam3xcoCVoDko7IJ0S
         dIgxaJy/e5OBrxez0TTjiEQ+BL9gvDbI6rVdHYMsIypYkYCjlIUpl+wTy5R6bmHGh0Kn
         uu7BKborJ7+oDHTFPnKUlWQFikYkjhZ5dDTo8thxNSdYvleQvESydbP0VGkwp6DagIbw
         99XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TGqq6aQ7ZABE0Da5sqyheFL7eGFTlYjj+eXlfJbfp0w=;
        b=D5WyKeF4rgQ8FrG221kpQcqaFb44mKS3LAon5jIZyniEK6nNC3xAJj/ZpbUMeuDRr5
         n1Tc690keoFMJciVW8kYmItMTODatnvLf4y+B1hLaFE5gvSut2jQccySd7oI0lO+Jpjl
         3JfIl+BFkoxCDOJTxpHbiZbbGCL+2g3ej6VtQLkN7qUlDUh6btqvfdjHenIT3XDSWCWr
         z+G9kYygplIas/xJ+Vr3fSxQAOwsDnfd+ubS+5tk1eeXGV9+gum093TacCidKsN1Kq+1
         FefoDGnQOnjke7TtbA2GLhyPIa5vm+u7nYTK1a0NqT8hcS5nicb3+BnJqipgs5LwyIkn
         rWtQ==
X-Gm-Message-State: ANoB5pm0Iy6Sw1lKcVrduRtwDkNDH4IqSWVK7BtSYL2KzgozcNvdIIqF
        URpy19rQbcJjYWmDcFX2NjkyVt4X5wOEW4F+5nZNV1FROs0=
X-Google-Smtp-Source: AA0mqf7T0i1pKTtMcAQqiB+n67AYYhJRfVmLxz6OxYnG1c4hyfj2bWlSsFP0uhHWjloNfR9J1RYWWg9R9r2qPIOvkxU=
X-Received: by 2002:a05:600c:1e89:b0:3cf:ecdb:bcb7 with SMTP id
 be9-20020a05600c1e8900b003cfecdbbcb7mr2524389wmb.180.1668615815109; Wed, 16
 Nov 2022 08:23:35 -0800 (PST)
MIME-Version: 1.0
References: <20221114233514.1913116-1-jeroendb@google.com> <20221114233514.1913116-3-jeroendb@google.com>
 <Y3RyUn8RLzyA6bGF@x130.lan>
In-Reply-To: <Y3RyUn8RLzyA6bGF@x130.lan>
From:   Jeroen de Borst <jeroendb@google.com>
Date:   Wed, 16 Nov 2022 08:23:23 -0800
Message-ID: <CAErkTsQALv3NL2jvFY1xgaXsWCPtavZP1UTgDcqo-YBdQCyjzQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/2] gve: Handle alternate miss completions
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saeed,

Thanks for your review. I like the suggestion, but
__test_and_clear_bit is for unsigned longs, comptag is a short.

Jeroen


On Tue, Nov 15, 2022 at 9:17 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On 14 Nov 15:35, Jeroen de Borst wrote:
> >The virtual NIC has 2 ways of indicating a miss-path
> >completion. This handles the alternate.
> >
> >Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> >Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >---
> > drivers/net/ethernet/google/gve/gve_adminq.h   |  4 +++-
> > drivers/net/ethernet/google/gve/gve_desc_dqo.h |  5 +++++
> > drivers/net/ethernet/google/gve/gve_tx_dqo.c   | 18 ++++++++++++------
> > 3 files changed, 20 insertions(+), 7 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
> >index b9ee8be73f96..cf29662e6ad1 100644
> >--- a/drivers/net/ethernet/google/gve/gve_adminq.h
> >+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
> >@@ -154,6 +154,7 @@ enum gve_driver_capbility {
> >       gve_driver_capability_gqi_rda = 1,
> >       gve_driver_capability_dqo_qpl = 2, /* reserved for future use */
> >       gve_driver_capability_dqo_rda = 3,
> >+      gve_driver_capability_alt_miss_compl = 4,
> > };
> >
> > #define GVE_CAP1(a) BIT((int)a)
> >@@ -164,7 +165,8 @@ enum gve_driver_capbility {
> > #define GVE_DRIVER_CAPABILITY_FLAGS1 \
> >       (GVE_CAP1(gve_driver_capability_gqi_qpl) | \
> >        GVE_CAP1(gve_driver_capability_gqi_rda) | \
> >-       GVE_CAP1(gve_driver_capability_dqo_rda))
> >+       GVE_CAP1(gve_driver_capability_dqo_rda) | \
> >+       GVE_CAP1(gve_driver_capability_alt_miss_compl))
> >
> > #define GVE_DRIVER_CAPABILITY_FLAGS2 0x0
> > #define GVE_DRIVER_CAPABILITY_FLAGS3 0x0
> >diff --git a/drivers/net/ethernet/google/gve/gve_desc_dqo.h b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
> >index e8fe9adef7f2..f79cd0591110 100644
> >--- a/drivers/net/ethernet/google/gve/gve_desc_dqo.h
> >+++ b/drivers/net/ethernet/google/gve/gve_desc_dqo.h
> >@@ -176,6 +176,11 @@ static_assert(sizeof(struct gve_tx_compl_desc) == 8);
> > #define GVE_COMPL_TYPE_DQO_MISS 0x1 /* Miss path completion */
> > #define GVE_COMPL_TYPE_DQO_REINJECTION 0x3 /* Re-injection completion */
> >
> >+/* The most significant bit in the completion tag can change the completion
> >+ * type from packet completion to miss path completion.
> >+ */
> >+#define GVE_ALT_MISS_COMPL_BIT BIT(15)
> >+
> > /* Descriptor to post buffers to HW on buffer queue. */
> > struct gve_rx_desc_dqo {
> >       __le16 buf_id; /* ID returned in Rx completion descriptor */
> >diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> >index 588d64819ed5..762915c6063b 100644
> >--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> >+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> >@@ -953,12 +953,18 @@ int gve_clean_tx_done_dqo(struct gve_priv *priv, struct gve_tx_ring *tx,
> >                       atomic_set_release(&tx->dqo_compl.hw_tx_head, tx_head);
> >               } else if (type == GVE_COMPL_TYPE_DQO_PKT) {
> >                       u16 compl_tag = le16_to_cpu(compl_desc->completion_tag);
> >-
> >-                      gve_handle_packet_completion(priv, tx, !!napi,
> >-                                                   compl_tag,
> >-                                                   &pkt_compl_bytes,
> >-                                                   &pkt_compl_pkts,
> >-                                                   /*is_reinjection=*/false);
> >+                      if (compl_tag & GVE_ALT_MISS_COMPL_BIT) {
> >+                              compl_tag &= ~GVE_ALT_MISS_COMPL_BIT;
>
> nit: __test_and_clear_bit() and reduce to oneline. also you can drop the
> braces in the if else statements once you squashed the two lines.
>
> >+                              gve_handle_miss_completion(priv, tx, compl_tag,
> >+                                                         &miss_compl_bytes,
> >+                                                         &miss_compl_pkts);
> >+                      } else {
> >+                              gve_handle_packet_completion(priv, tx, !!napi,
> >+                                                           compl_tag,
> >+                                                           &pkt_compl_bytes,
> >+                                                           &pkt_compl_pkts,
> >+                                                           /*is_reinjection=*/false);
> >+                      }
> >               } else if (type == GVE_COMPL_TYPE_DQO_MISS) {
> >                       u16 compl_tag = le16_to_cpu(compl_desc->completion_tag);
> >
> >--
> >2.38.1.431.g37b22c650d-goog
> >
