Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12E15F802C
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJGVjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiJGVjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:39:40 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB40E85
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 14:39:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d24so5664888pls.4
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 14:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y3GVIVAxpMC/VnvFXwEMfwYlp9ueZhYknYrdLAirqlQ=;
        b=YCYdesFSWl3TBBzu9F3NZFzbTzkw8Cd/2GtZLkYwG//aCVv9mcG/9eBTJQx9a3/uzl
         MGvNbvpjTM0/8ucETvsQo3Y6Uo7xXW6K6UAyow5lZzvNQ//SmhoKY8Tu4lbOhrcXnOsy
         2w1Z2yPlseZw6m8gV6a0EpAMq0xwPHnwfLgS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3GVIVAxpMC/VnvFXwEMfwYlp9ueZhYknYrdLAirqlQ=;
        b=EG9Is6j2tGiTcWnT98JX2brtObeceiYjJYWlxMmLUpNUDW0mwovRxNGUa/kvihXY7h
         d1hbaeIlduQKz8vOV3jn1/DMvOX6NpaCT4LSi12k5eFUpHygHNHc/A0XNxOCAtDGJUbS
         2m3/g+zNpLX81DUOjYD6im5VXphKo70MqUgBHIWmiP3wGCAolxkfvKVjiqTRwD+FYq0T
         Hty9HRFgC3zRAlhdTPMK2LzvpHVbWsoJwjrgLr5a9uxzRoQfACV/I6NKbpysWEtGGqiJ
         JT8OWi2V0esU5VAPhkahJOgX6Jqj3mMhY96TWJvStLpIsxVyc6JrSXJ6PtsEE08TW7sv
         2BTA==
X-Gm-Message-State: ACrzQf3drZ301/+nwP5/Tuj2wB4d9bokC8Q5F0wIotYWiwYdUyZ9ewgK
        naA1BI/iqU350qYbq29ojoemqA==
X-Google-Smtp-Source: AMsMyM6/lTafg+rb5cud9MMRvCMsoKqjewZRYjWiYreiHgG3mxPfZcTUeNMIVwuQKq2qm+OQdJC0QQ==
X-Received: by 2002:a17:90b:1648:b0:20b:f0ae:2169 with SMTP id il8-20020a17090b164800b0020bf0ae2169mr3552539pjb.173.1665178777793;
        Fri, 07 Oct 2022 14:39:37 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id m24-20020a17090a7f9800b001f2fa09786asm2012655pjl.19.2022.10.07.14.39.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Oct 2022 14:39:37 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [next-queue v4 2/4] i40e: Record number TXes cleaned during NAPI
Date:   Fri,  7 Oct 2022 14:38:41 -0700
Message-Id: <1665178723-52902-3-git-send-email-jdamato@fastly.com>
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

Update i40e_clean_tx_irq to take an out parameter (tx_cleaned) which stores
the number TXs cleaned.

No XDP related TX code is touched. Care has been taken to avoid changing
the control flow of i40e_clean_tx_irq and i40e_napi_poll.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b97c95f..274de1c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -923,11 +923,13 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
  * @vsi: the VSI we care about
  * @tx_ring: Tx ring to clean
  * @napi_budget: Used to determine if we are in netpoll
+ * @tx_cleaned: Out parameter set to the number of TXes cleaned
  *
  * Returns true if there's any budget left (e.g. the clean is finished)
  **/
 static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
-			      struct i40e_ring *tx_ring, int napi_budget)
+			      struct i40e_ring *tx_ring, int napi_budget,
+			      unsigned int *tx_cleaned)
 {
 	int i = tx_ring->next_to_clean;
 	struct i40e_tx_buffer *tx_buf;
@@ -1048,6 +1050,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 		}
 	}
 
+	*tx_cleaned = total_packets;
 	return !!budget;
 }
 
@@ -2689,10 +2692,12 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 			       container_of(napi, struct i40e_q_vector, napi);
 	struct i40e_vsi *vsi = q_vector->vsi;
 	struct i40e_ring *ring;
+	bool tx_clean_complete = true;
 	bool clean_complete = true;
 	bool arm_wb = false;
 	int budget_per_ring;
 	int work_done = 0;
+	unsigned int tx_cleaned = 0;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state)) {
 		napi_complete(napi);
@@ -2705,10 +2710,10 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	i40e_for_each_ring(ring, q_vector->tx) {
 		bool wd = ring->xsk_pool ?
 			  i40e_clean_xdp_tx_irq(vsi, ring) :
-			  i40e_clean_tx_irq(vsi, ring, budget);
+			  i40e_clean_tx_irq(vsi, ring, budget, &tx_cleaned);
 
 		if (!wd) {
-			clean_complete = false;
+			clean_complete = tx_clean_complete = false;
 			continue;
 		}
 		arm_wb |= ring->arm_wb;
-- 
2.7.4

