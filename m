Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41633646531
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiLGXgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiLGXgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:36:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025058AAE4
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:36:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 948DDB8218F
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 23:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D7BC433C1;
        Wed,  7 Dec 2022 23:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670456195;
        bh=atdfWN2kc5BmwgBTd3SabIgE4g64/G+cR2OJqY2A5bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GOUskRgdE+7VYGxhyQFXfLm8cmWdKrwA8OpyeZuacr9AWWenq/eArPBHeGD9wquuv
         N9U+cz8YhFi1RZSmZHRJD/Rr3XQGBt2Q4YzoB7lV0DXVYTx1YflcIfCjYHbyXZ1ltk
         lsxKb8xWBd4LyJevRNppqT3GTREKnFqHZKoIL/jpcffc8uI6e5vIrfLWsW8bUnp63u
         vbFgH8j+Uv16XASjfdMNjwxQWa5YfcBj3Bq+7BkN5WCuosf2JnxhhALBJCDm0Dbt8v
         FkgzGEJl8sJScDjlq/dv0s+hgXYJ4UlUkIdgSUPD0ZHdZeL/vjdTZbtqQxhCHhSw7Q
         Bv8ZFBl3x8ukw==
Date:   Wed, 7 Dec 2022 15:36:33 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com, leon@kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next v2 09/15] ice: protect init and calibrating
 check in ice_ptp_request_ts
Message-ID: <Y5Ejgb2P2f/PX0ym@x130>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
 <20221207210937.1099650-10-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207210937.1099650-10-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Dec 13:09, Tony Nguyen wrote:
>From: Jacob Keller <jacob.e.keller@intel.com>
>
>When requesting a new timestamp, the ice_ptp_request_ts function does not
>hold the Tx tracker lock while checking init and calibrating. This means
>that we might issue a new timestamp request just after the Tx timestamp
>tracker starts being deinitialized. This could lead to incorrect access of
>the timestamp structures. Correct this by moving the init and calibrating
>checks under the lock, and updating the flows which modify these fields to
>use the lock.
>
>Note that we do not need to hold the lock while checking for tx->init in
>ice_ptp_tstamp_tx. This is because the teardown function will use
>synchronize_irq after clearing the flag to ensure that the threaded

FYI: couldn't find any ice_ptp_tstamp_tx(), and if it's running in xmit
path sofritrq then sync_irq won't help you.

>interrupt completes. Either a) the tx->init flag will be cleared before the
>ice_ptp_tx_tstamp function starts, thus it will exit immediately, or b) the
>threaded interrupt will be executing and the synchronize_irq will wait
>until the threaded interrupt has completed at which point we know the init
>field has definitely been set and new interrupts will not execute the Tx
>timestamp thread function.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
>Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_ptp.c | 36 ++++++++++++++++++++----
> drivers/net/ethernet/intel/ice/ice_ptp.h |  2 +-
> 2 files changed, 32 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
>index 0282ccc55819..481492d84e0e 100644
>--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
>+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
>@@ -599,6 +599,23 @@ static u64 ice_ptp_extend_40b_ts(struct ice_pf *pf, u64 in_tstamp)
> 				     (in_tstamp >> 8) & mask);
> }
>
>+/**
>+ * ice_ptp_is_tx_tracker_up - Check if Tx tracker is ready for new timestamps
>+ * @tx: the PTP Tx timestamp tracker to check
>+ *
>+ * Check that a given PTP Tx timestamp tracker is up, i.e. that it is ready
>+ * to accept new timestamp requests.
>+ *
>+ * Assumes the tx->lock spinlock is already held.
>+ */
>+static bool
>+ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
>+{
>+	lockdep_assert_held(&tx->lock);
>+
>+	return tx->init && !tx->calibrating;
>+}
>+
> /**
>  * ice_ptp_tx_tstamp - Process Tx timestamps for a port
>  * @tx: the PTP Tx timestamp tracker
>@@ -788,10 +805,10 @@ ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
> 		return -ENOMEM;
> 	}
>
>-	spin_lock_init(&tx->lock);
>-
> 	tx->init = 1;
>
>+	spin_lock_init(&tx->lock);
>+

this change is pointless. 

> 	return 0;
> }
>
>@@ -833,7 +850,9 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
> static void
> ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
> {
>+	spin_lock(&tx->lock);
> 	tx->init = 0;
>+	spin_unlock(&tx->lock);
>
> 	/* wait for potentially outstanding interrupt to complete */
> 	synchronize_irq(pf->msix_entries[pf->oicr_idx].vector);
>@@ -1327,7 +1346,9 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
> 	kthread_cancel_delayed_work_sync(&ptp_port->ov_work);
>
> 	/* temporarily disable Tx timestamps while calibrating PHY offset */
>+	spin_lock(&ptp_port->tx.lock);
> 	ptp_port->tx.calibrating = true;
>+	spin_unlock(&ptp_port->tx.lock);
> 	ptp_port->tx_fifo_busy_cnt = 0;
>
> 	/* Start the PHY timer in Vernier mode */
>@@ -1336,7 +1357,9 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
> 		goto out_unlock;
>
> 	/* Enable Tx timestamps right away */
>+	spin_lock(&ptp_port->tx.lock);
> 	ptp_port->tx.calibrating = false;
>+	spin_unlock(&ptp_port->tx.lock);
>
> 	kthread_queue_delayed_work(pf->ptp.kworker, &ptp_port->ov_work, 0);
>
>@@ -2330,11 +2353,14 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
> {
> 	u8 idx;
>
>-	/* Check if this tracker is initialized */
>-	if (!tx->init || tx->calibrating)
>+	spin_lock(&tx->lock);
>+
>+	/* Check that this tracker is accepting new timestamp requests */
>+	if (!ice_ptp_is_tx_tracker_up(tx)) {
>+		spin_unlock(&tx->lock);
> 		return -1;
>+	}
>
>-	spin_lock(&tx->lock);
> 	/* Find and set the first available index */
> 	idx = find_first_zero_bit(tx->in_use, tx->len);
> 	if (idx < tx->len) {
>diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
>index 5052fc41bed3..0bfafaaab6c7 100644
>--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
>+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
>@@ -110,7 +110,7 @@ struct ice_tx_tstamp {
>
> /**
>  * struct ice_ptp_tx - Tracking structure for all Tx timestamp requests on a port
>- * @lock: lock to prevent concurrent write to in_use bitmap
>+ * @lock: lock to prevent concurrent access to fields of this struct
>  * @tstamps: array of len to store outstanding requests
>  * @in_use: bitmap of len to indicate which slots are in use
>  * @block: which memory block (quad or port) the timestamps are captured in
>-- 
>2.35.1
>
