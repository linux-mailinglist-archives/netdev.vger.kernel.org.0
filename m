Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9E05110E6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbiD0GML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiD0GMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:12:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D501766F80;
        Tue, 26 Apr 2022 23:08:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8938FB824AE;
        Wed, 27 Apr 2022 06:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABABC385A7;
        Wed, 27 Apr 2022 06:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651039735;
        bh=7ULIaADIULJlgwsFYyufxG72ioz1krpbL4jBoA5aDl4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=C9FK281PD+Q7OcQ+U86fQ9iKGyIpavHQfNeB29Cqb9z/cp1+jPFYff4H4W4RGJF2C
         8ac6Va3dQTR3HtpLlpJ3bOBwscKCBqfYio4ebeHd+f6C3kwchpq3vnejczXeI2U6Rc
         Vy8ohbevei5srWiLHhUxLft04KBCoHB3WzxmJplU8sPvkAm4zqDTx5V9y6aeiJ8RHq
         T9B17yU8k6YenxwHdaYj2HbTVJ7MADlzVT+2R6NvpJE1k1vUYAveGV8ApaewnCQ/1c
         OBcwO6AyOfhedkax9A2lCVkxOqrSQvMQdS3bJSkVhX36IMf7H+ahObR/5EjFD+DZs6
         Lbnwgy4oSvQrA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     quic_wgong@quicinc.com, briannorris@chromium.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] ath10k: skip ath10k_halt during suspend for driver state RESTARTING
References: <20220426221859.v2.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
Date:   Wed, 27 Apr 2022 09:08:49 +0300
In-Reply-To: <20220426221859.v2.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
        (Abhishek Kumar's message of "Tue, 26 Apr 2022 22:19:55 +0000")
Message-ID: <87wnfbf47i.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> Double free crash is observed when FW recovery(caused by wmi
> timeout/crash) is followed by immediate suspend event. The FW recovery
> is triggered by ath10k_core_restart() which calls driver clean up via
> ath10k_halt(). When the suspend event occurs between the FW recovery,
> the restart worker thread is put into frozen state until suspend completes.
> The suspend event triggers ath10k_stop() which again triggers ath10k_halt()
> The double invocation of ath10k_halt() causes ath10k_htt_rx_free() to be
> called twice(Note: ath10k_htt_rx_alloc was not called by restart worker
> thread because of its frozen state), causing the crash.
>
> To fix this, during the suspend flow, skip call to ath10k_halt() in
> ath10k_stop() when the current driver state is ATH10K_STATE_RESTARTING.
> Also, for driver state ATH10K_STATE_RESTARTING, call
> ath10k_wait_for_suspend() in ath10k_stop(). This is because call to
> ath10k_wait_for_suspend() is skipped later in
> [ath10k_halt() > ath10k_core_stop()] for the driver state
> ATH10K_STATE_RESTARTING.
>
> The frozen restart worker thread will be cancelled during resume when the
> device comes out of suspend.
>
> Below is the crash stack for reference:
>
> [  428.469167] ------------[ cut here ]------------
> [  428.469180] kernel BUG at mm/slub.c:4150!
> [  428.469193] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> [  428.469219] Workqueue: events_unbound async_run_entry_fn
> [  428.469230] RIP: 0010:kfree+0x319/0x31b
> [  428.469241] RSP: 0018:ffffa1fac015fc30 EFLAGS: 00010246
> [  428.469247] RAX: ffffedb10419d108 RBX: ffff8c05262b0000
> [  428.469252] RDX: ffff8c04a8c07000 RSI: 0000000000000000
> [  428.469256] RBP: ffffa1fac015fc78 R08: 0000000000000000
> [  428.469276] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  428.469285] Call Trace:
> [  428.469295]  ? dma_free_attrs+0x5f/0x7d
> [  428.469320]  ath10k_core_stop+0x5b/0x6f
> [  428.469336]  ath10k_halt+0x126/0x177
> [  428.469352]  ath10k_stop+0x41/0x7e
> [  428.469387]  drv_stop+0x88/0x10e
> [  428.469410]  __ieee80211_suspend+0x297/0x411
> [  428.469441]  rdev_suspend+0x6e/0xd0
> [  428.469462]  wiphy_suspend+0xb1/0x105
> [  428.469483]  ? name_show+0x2d/0x2d
> [  428.469490]  dpm_run_callback+0x8c/0x126
> [  428.469511]  ? name_show+0x2d/0x2d
> [  428.469517]  __device_suspend+0x2e7/0x41b
> [  428.469523]  async_suspend+0x1f/0x93
> [  428.469529]  async_run_entry_fn+0x3d/0xd1
> [  428.469535]  process_one_work+0x1b1/0x329
> [  428.469541]  worker_thread+0x213/0x372
> [  428.469547]  kthread+0x150/0x15f
> [  428.469552]  ? pr_cont_work+0x58/0x58
> [  428.469558]  ? kthread_blkcg+0x31/0x31
>
> Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
> Co-developed-by: Wen Gong <quic_wgong@quicinc.com>
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> ---
>
> Changes in v2:
> - Fixed typo, replaced ath11k by ath10k in the comments.
> - Adjusted the position of my S-O-B tag.
> - Added the Tested-on tag.
>
>  drivers/net/wireless/ath/ath10k/mac.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index d804e19a742a..e9c1f11fef0a 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5345,8 +5345,22 @@ static void ath10k_stop(struct ieee80211_hw *hw)
>  
>  	mutex_lock(&ar->conf_mutex);
>  	if (ar->state != ATH10K_STATE_OFF) {
> -		if (!ar->hw_rfkill_on)
> -			ath10k_halt(ar);
> +		if (!ar->hw_rfkill_on) {
> +			/* If the current driver state is RESTARTING but not yet
> +			 * fully RESTARTED because of incoming suspend event,
> +			 * then ath10k_halt is already called via
> +			 * ath10k_core_restart and should not be called here.
> +			 */
> +			if (ar->state != ATH10K_STATE_RESTARTING)
> +				ath10k_halt(ar);
> +			else
> +				/* Suspending here, because when in RESTARTING
> +				 * state, ath10k_core_stop skips
> +				 * ath10k_wait_for_suspend.
> +				 */
> +				ath10k_wait_for_suspend(ar,
> +							WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
> +		}

I'm nitpicking but I prefer to use parenthesis with function names, so I
changed the comments. Also there was one ath10k-check warning:

drivers/net/wireless/ath/ath10k/mac.c:5360: line length of 91 exceeds 90 columns

In the pending branch I changed it to:

			if (ar->state != ATH10K_STATE_RESTARTING) {
				ath10k_halt(ar);
			} else {
				/* Suspending here, because when in RESTARTING
				 * state, ath10k_core_stop() skips
				 * ath10k_wait_for_suspend().
				 */
				opt = WMI_PDEV_SUSPEND_AND_DISABLE_INTR;
				ath10k_wait_for_suspend(ar, opt);
			}

Not really pretty but I prefer to keep ath10k warning free.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
