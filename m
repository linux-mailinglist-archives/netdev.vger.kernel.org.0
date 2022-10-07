Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534A85F802D
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJGVjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiJGVjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:39:41 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC42E8C
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 14:39:39 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id b5so5719216pgb.6
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 14:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UYcP5d4aVc4DITBtO91mYOhK66gC9vjutv9fpNeGoEE=;
        b=pT0mtqDkL/bP+4d+lqvFN2dJQDnjGK14Rqw0b7yhQGYYDv5bwcCIhxZt/BY2mkZigD
         wKYZy5oX6XkX9i4Obo0Pr+o/bK9OGWRHzhREVTKgN3wP85Bz72SIflioIeB6rFbn2Mso
         KrpzPq9Y1n9WPZ7efNFIHhx1cfNeN1OnkPsRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UYcP5d4aVc4DITBtO91mYOhK66gC9vjutv9fpNeGoEE=;
        b=QhAK1K/35hD7thxjkP663XqfjOOgfMSZeHq03+uiOeT14Wf9MLQBOi4k9/T1cqpDi6
         VyLpaC2LajW+O+Fk5dGakSfWb4iHKIeix87BjBEYjQhy5ILSVFXbaLoo75WbYOaLlmGj
         gACnq2NQ4VC/4p92DkVT0IsCuEqxxpHidt0ShZf2Q+Y5dChQKKHLHTXR5mii08OMEpNL
         k8CSiFg2k14mZ0rKcBWGQmzmWF6VX+dPQXWKByQ6RY9pFdBRCXiOeuhBTwxr4LVbjGna
         B1EeU9NjSg/7IEKEg9jUCgyj9um2r1yPLMBBJL7B7MgfEHaa7Fq/vS+nnh5kACOUJZRf
         Vx9A==
X-Gm-Message-State: ACrzQf2eZxV8palveAdMQ4om3YGNGOpL4cqXSPc/rgqDBzrKW00UdETA
        ocrDHnhu8xPQ3X1kQklCDmXrDQ==
X-Google-Smtp-Source: AMsMyM7SgX9AMYL0vd3xtRxUfxWspnAMPI59qKWwlBPrnOOSJU5qX01Y/y02OzY8zAeUL8dxBnnk7w==
X-Received: by 2002:a63:6cca:0:b0:43c:7998:8a78 with SMTP id h193-20020a636cca000000b0043c79988a78mr6207622pgc.600.1665178779014;
        Fri, 07 Oct 2022 14:39:39 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id m24-20020a17090a7f9800b001f2fa09786asm2012655pjl.19.2022.10.07.14.39.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Oct 2022 14:39:38 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [next-queue v4 3/4] i40e: Record number of RXes cleaned during NAPI
Date:   Fri,  7 Oct 2022 14:38:42 -0700
Message-Id: <1665178723-52902-4-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1665178723-52902-1-git-send-email-jdamato@fastly.com>
References: <1665178723-52902-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust i40e_clean_rx_irq to accept an out parameter which records the number of
RX packets cleaned.

No XDP related code is modified and care has been taken to avoid changing
control flow.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 274de1c..5901e58 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2425,6 +2425,7 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
  * i40e_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @rx_ring: rx descriptor ring to transact packets on
  * @budget: Total limit on number of packets to process
+ * @rx_cleaned: Out parameter of the number of packets processed
  *
  * This function provides a "bounce buffer" approach to Rx interrupt
  * processing.  The advantage to this is that on systems that have
@@ -2433,7 +2434,8 @@ static void i40e_inc_ntc(struct i40e_ring *rx_ring)
  *
  * Returns amount of work completed
  **/
-static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
+static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
+			     unsigned int *rx_cleaned)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0, frame_sz = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
@@ -2570,6 +2572,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
+	*rx_cleaned = total_rx_packets;
+
 	/* guarantee a trip back through this routine if there was a failure */
 	return failure ? budget : (int)total_rx_packets;
 }
@@ -2693,11 +2697,13 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	struct i40e_vsi *vsi = q_vector->vsi;
 	struct i40e_ring *ring;
 	bool tx_clean_complete = true;
+	bool rx_clean_complete = true;
 	bool clean_complete = true;
 	bool arm_wb = false;
 	int budget_per_ring;
 	int work_done = 0;
 	unsigned int tx_cleaned = 0;
+	unsigned int rx_cleaned = 0;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
 		napi_complete(napi);
@@ -2738,12 +2744,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	i40e_for_each_ring(ring, q_vector->rx) {
 		int cleaned = ring->xsk_pool ?
 			      i40e_clean_rx_irq_zc(ring, budget_per_ring) :
-			      i40e_clean_rx_irq(ring, budget_per_ring);
+			      i40e_clean_rx_irq(ring, budget_per_ring, &rx_cleaned);
 
 		work_done += cleaned;
 		/* if we clean as many as budgeted, we must not be done */
 		if (cleaned >= budget_per_ring)
-			clean_complete = false;
+			clean_complete = rx_clean_complete = false;
 	}
 
 	/* If work not completed, return budget and polling will return */
-- 
2.7.4

