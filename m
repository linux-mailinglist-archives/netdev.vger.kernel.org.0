Return-Path: <netdev+bounces-10745-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC89C730145
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98F2328145D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B72DF61;
	Wed, 14 Jun 2023 14:07:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1CEDF4E
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:07:34 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5EECD;
	Wed, 14 Jun 2023 07:07:33 -0700 (PDT)
From: Florian Kauer <florian.kauer@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1686751651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6Htu7np35GOzuU2rwqMOLnSJ2z47YfJkRbHy1TCsl0=;
	b=1+8JZxple640L2i78OWj0AT4lW7BSRG5mTek6g1HCJErHIPJWpbpZbA8770+hU+H+m0tNb
	c9BnZ8Psh4CSh/9fzNZmdOxxeQ2hs3QOXMSxanhaAq7kgy8pyfqTNpd9Pkk8zVadW2EqGg
	EHQnvyIaPn/G1d5Uws7atr6Ma3KiSfbQ8PQ6+j/C7XxECFdHZtDqNkZ7XoW90Oy36m5gGm
	NDleKInVyFDzlbfFnAK6BXpJrUyKA/ggBwhnEwJbDOWCVgZ5XKbGumlrZckJHJ+B59NqtC
	vykd4w1CGkQtniToM4Nce/jXtkl0xIgA8tz4o8zkfydewwK0vEH42Qg5/ID54w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1686751651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6Htu7np35GOzuU2rwqMOLnSJ2z47YfJkRbHy1TCsl0=;
	b=slM6BJwhD6d50c957awDJHQXUZNZ9MEQweTUaWR3uNdodBTiBsjm6mW1Cvxg+B6E0s8OkD
	9nYgz1dY/rUvzFBg==
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>,
	Malli C <mallikarjuna.chilakala@intel.com>
Cc: intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kurt@linutronix.de,
	florian.kauer@linutronix.de
Subject: [PATCH net-next 3/6] igc: Handle already enabled taprio offload for basetime 0
Date: Wed, 14 Jun 2023 16:07:11 +0200
Message-Id: <20230614140714.14443-4-florian.kauer@linutronix.de>
In-Reply-To: <20230614140714.14443-1-florian.kauer@linutronix.de>
References: <20230614140714.14443-1-florian.kauer@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Since commit e17090eb2494 ("igc: allow BaseTime 0 enrollment for Qbv")
it is possible to enable taprio offload with a basetime of 0.
However, the check if taprio offload is already enabled (and thus -EALREADY
should be returned for igc_save_qbv_schedule) still relied on
adapter->base_time > 0.

This can be reproduced as follows:

    # TAPRIO offload (flags == 0x2) and base-time = 0
    sudo tc qdisc replace dev enp1s0 parent root handle 100 stab overhead 24 taprio \
	    num_tc 1 \
	    map 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
	    queues 1@0 \
	    base-time 0 \
	    sched-entry S 01 300000 \
	    flags 0x2

    # The second call should fail with "Error: Device failed to setup taprio offload."
    # But that only happens if base-time was != 0
    sudo tc qdisc replace dev enp1s0 parent root handle 100 stab overhead 24 taprio \
	    num_tc 1 \
	    map 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
	    queues 1@0 \
	    base-time 0 \
	    sched-entry S 01 300000 \
	    flags 0x2

Fixes: e17090eb2494 ("igc: allow BaseTime 0 enrollment for Qbv")
Signed-off-by: Florian Kauer <florian.kauer@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 122158b321d5..35ace8d338a5 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6123,7 +6123,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	if (qopt->base_time < 0)
 		return -ERANGE;
 
-	if (igc_is_device_id_i225(hw) && adapter->base_time)
+	if (igc_is_device_id_i225(hw) && adapter->taprio_offload_enable)
 		return -EALREADY;
 
 	if (!validate_schedule(adapter, qopt))
-- 
2.39.2


