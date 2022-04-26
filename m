Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142D9510311
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 18:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352916AbiDZQVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 12:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352905AbiDZQVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 12:21:39 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E296F9F7;
        Tue, 26 Apr 2022 09:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1650989911; x=1682525911;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=32zdlqAxGpL7Dq8ks/2ZRJEQKKPp3/s5aIgIq4Gjo6c=;
  b=zB38aOHBNf7BP49Ngk0brX2nVlPfbtk9KSPa5Y7nOBSRIAlXlzarrzAh
   9m82DWOuWcZOMVqOQQIv7lVf8IVjPezOtkqH8bQZQq94fw1hscZhVtKnA
   nWjty4G6BRlTw+vk6AXRsAMM3IC4eQG5wfjXYeeNZDkfZmDpXDSvl19WZ
   k=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 26 Apr 2022 09:18:31 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 09:18:30 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 26 Apr 2022 09:18:30 -0700
Received: from [10.110.124.35] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 26 Apr
 2022 09:18:29 -0700
Message-ID: <f429219f-e5e5-6107-473f-a4566f4e7ee1@quicinc.com>
Date:   Tue, 26 Apr 2022 09:18:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] ath10k: skip ath10k_halt during suspend for driver state
 RESTARTING
Content-Language: en-US
To:     Abhishek Kumar <kuabhs@chromium.org>, <kvalo@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <briannorris@chromium.org>, <ath10k@lists.infradead.org>,
        <netdev@vger.kernel.org>, Wen Gong <quic_wgong@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220425021442.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220425021442.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/2022 7:15 PM, Abhishek Kumar wrote:
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
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> Co-developed-by: Wen Gong <quic_wgong@quicinc.com>
> Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
> ---
> 
>   drivers/net/wireless/ath/ath10k/mac.c | 18 ++++++++++++++++--
>   1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index d804e19a742a..57ba27c46371 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5345,8 +5345,22 @@ static void ath10k_stop(struct ieee80211_hw *hw)
>   
>   	mutex_lock(&ar->conf_mutex);
>   	if (ar->state != ATH10K_STATE_OFF) {
> -		if (!ar->hw_rfkill_on)
> -			ath10k_halt(ar);
> +		if (!ar->hw_rfkill_on) {
> +			/* If the current driver state is RESTARTING but not yet
> +			 * fully RESTARTED because of incoming suspend event,
> +			 * then ath11k_halt is already called via
> +			 * ath10k_core_restart and should not be called here.
> +			 */
> +			if (ar->state != ATH10K_STATE_RESTARTING)
> +				ath10k_halt(ar);
> +			else
> +				/* Suspending here, because when in RESTARTING
> +				 * state, ath11k_core_stop skips
> +				 * ath10k_wait_for_suspend.
> +				 */
> +				ath10k_wait_for_suspend(ar,
> +							WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
> +		}
>   		ar->state = ATH10K_STATE_OFF;
>   	}
>   	mutex_unlock(&ar->conf_mutex);

