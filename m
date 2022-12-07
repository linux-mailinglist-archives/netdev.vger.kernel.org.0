Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36F16463F4
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 23:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiLGWTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 17:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLGWTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 17:19:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC1D62E94
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 14:19:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39C83B8218E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 22:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C88C433C1;
        Wed,  7 Dec 2022 22:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670451573;
        bh=wYaRBqtoDtrMb8oFMZ4/e/GsAA3HkOtRdo3suSnd6yY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LNDmPpyMOGWLKeeZ6cbCfvVeA45dkHYxBsSfiBnsC7X7t35LOK52lVjQXVyF/Ua2u
         eP066Zt27Mtm06Sdq9bO5lJXlBR/uAuf3B1UTp+vVo395yFeQyDDWJUY2cdUlwTLcm
         TJDRWSGk92HhOyt9sHxEtviiyf09ZayinXyd/2X67ddfSsKOx2M9nQpooPvUpfa1kj
         Q4+Fh++uI7B+w2908uoqTGE+iFjnzybQxppo56nkt6iCumsEGDrqJ5lnXjJ+QLlMNr
         SWTPSu6osuJqdbsHcUI+xnbbVjEErRy4OXENg9COcLEwFMRs4QnWpxPC/OtDdJgOWY
         sqO8L0MXfTMXA==
Date:   Wed, 7 Dec 2022 14:19:30 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 1/4] ice: Create a separate kthread to handle ptp
 extts work
Message-ID: <Y5ERcnar+H+xtYYC@x130>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207211040.1099708-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Dec 13:10, Tony Nguyen wrote:
>From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
>
>ice_ptp_extts_work() and ice_ptp_periodic_work() are both scheduled on
>the same kthread_worker pf.ptp.kworker. But, ice_ptp_periodic_work()
>sends messages to AQ and waits for responses. This causes
>ice_ptp_extts_work() to be blocked while waiting to be scheduled. This
>causes problems with the reading of the incoming signal timestamps,
>which disrupts a 100 Hz signal.
>

Sounds like an optimization rather than a bug fix, unless you explain what
the symptoms are and how critical this patch is.

code LGTM, although i find it wasteful to create a kthread per device event
type, but i can't think of a better way.

>Create an additional kthread_worker pf.ptp.kworker_extts to service only
>ice_ptp_extts_work() as soon as possible.
>
>Fixes: 77a781155a65 ("ice: enable receive hardware timestamping")
>Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
>Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
>Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_main.c |  5 ++++-
> drivers/net/ethernet/intel/ice/ice_ptp.c  | 15 ++++++++++++++-
> drivers/net/ethernet/intel/ice/ice_ptp.h  |  2 ++
> 3 files changed, 20 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
>index ca2898467dcb..d0f14e73e8da 100644
>--- a/drivers/net/ethernet/intel/ice/ice_main.c
>+++ b/drivers/net/ethernet/intel/ice/ice_main.c
>@@ -3106,7 +3106,10 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
> 						     GLTSYN_STAT_EVENT1_M |
> 						     GLTSYN_STAT_EVENT2_M);
> 		ena_mask &= ~PFINT_OICR_TSYN_EVNT_M;
>-		kthread_queue_work(pf->ptp.kworker, &pf->ptp.extts_work);
>+
>+		if (pf->ptp.kworker_extts)
>+			kthread_queue_work(pf->ptp.kworker_extts,
>+					   &pf->ptp.extts_work);
> 	}
>
> #define ICE_AUX_CRIT_ERR (PFINT_OICR_PE_CRITERR_M | PFINT_OICR_HMC_ERR_M | PFINT_OICR_PE_PUSH_M)
>diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
>index 0f668468d141..f9e20622ad9f 100644
>--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
>+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
>@@ -2604,7 +2604,7 @@ static int ice_ptp_init_owner(struct ice_pf *pf)
>  */
> static int ice_ptp_init_work(struct ice_pf *pf, struct ice_ptp *ptp)
> {
>-	struct kthread_worker *kworker;
>+	struct kthread_worker *kworker, *kworker_extts;
>
> 	/* Initialize work functions */
> 	kthread_init_delayed_work(&ptp->work, ice_ptp_periodic_work);
>@@ -2620,6 +2620,13 @@ static int ice_ptp_init_work(struct ice_pf *pf, struct ice_ptp *ptp)
>
> 	ptp->kworker = kworker;
>
>+	kworker_extts = kthread_create_worker(0, "ice-ptp-extts-%s",
>+					      dev_name(ice_pf_to_dev(pf)));
>+	if (IS_ERR(kworker_extts))
>+		return PTR_ERR(kworker_extts);
>+
>+	ptp->kworker_extts = kworker_extts;
>+
> 	/* Start periodic work going */
> 	kthread_queue_delayed_work(ptp->kworker, &ptp->work, 0);
>
>@@ -2719,11 +2726,17 @@ void ice_ptp_release(struct ice_pf *pf)
>
> 	ice_ptp_port_phy_stop(&pf->ptp.port);
> 	mutex_destroy(&pf->ptp.port.ps_lock);
>+
> 	if (pf->ptp.kworker) {
> 		kthread_destroy_worker(pf->ptp.kworker);
> 		pf->ptp.kworker = NULL;
> 	}
>
>+	if (pf->ptp.kworker_extts) {
>+		kthread_destroy_worker(pf->ptp.kworker_extts);
>+		pf->ptp.kworker_extts = NULL;
>+	}
>+
> 	if (!pf->ptp.clock)
> 		return;
>
>diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
>index 028349295b71..c63ad2c9af4c 100644
>--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
>+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
>@@ -165,6 +165,7 @@ struct ice_ptp_port {
>  * @ext_ts_chan: the external timestamp channel in use
>  * @ext_ts_irq: the external timestamp IRQ in use
>  * @kworker: kwork thread for handling periodic work
>+ * @kworker_extts: kworker thread for handling extts work
>  * @perout_channels: periodic output data
>  * @info: structure defining PTP hardware capabilities
>  * @clock: pointer to registered PTP clock device
>@@ -186,6 +187,7 @@ struct ice_ptp {
> 	u8 ext_ts_chan;
> 	u8 ext_ts_irq;
> 	struct kthread_worker *kworker;
>+	struct kthread_worker *kworker_extts;
> 	struct ice_perout_channel perout_channels[GLTSYN_TGT_H_IDX_MAX];
> 	struct ptp_clock_info info;
> 	struct ptp_clock *clock;
>-- 
>2.35.1
>
