Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31B551422B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 08:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354393AbiD2GJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 02:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354390AbiD2GJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 02:09:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7D34ECE8;
        Thu, 28 Apr 2022 23:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 068CAB832F0;
        Fri, 29 Apr 2022 06:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E366C385A4;
        Fri, 29 Apr 2022 06:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651212387;
        bh=fOZngMG49/S1ZUbL+kjMvqWelI1jEAECMwdZnFHw9TU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MuLgH2GKjhHaruwXrCbfflfbNBwxhByXKZD6oQ6xVjO0lmNTt05+Zm8ijLu+BwdWq
         2v0p/q0BdxXmfareGn7NIhUKsuCwyHoq8PCFnno+pJHkVDoR8v7d0NHwzBxzsAlMtF
         ox3jOfrT7lH0bpqjnCwC9P53D14nbU7g93bND5vvxLsxDO7hbXRj7Ki9hMvjLB/kgt
         NXkt1bnpkBUKbUeuZEhQPm5ZItADBe1a+FEyNVvWSFdZOuiN0cWF5IvtO66QJ2REnM
         XNtGzUbvl7Z1xYU/4zV9EfjDaQ8HyhS7netxXDUkjJ+fgBbcfYfc0fBjx7cGK1nUi5
         kDc4KH+NXrqTQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] ath10k: skip ath10k_halt during suspend for driver
 state
 RESTARTING
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220426221859.v2.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
References: <20220426221859.v2.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     quic_wgong@quicinc.com, kuabhs@chromium.org,
        briannorris@chromium.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165121238072.2322.15176530222754995177.kvalo@kernel.org>
Date:   Fri, 29 Apr 2022 06:06:25 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> wrote:

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
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

b72a4aff947b ath10k: skip ath10k_halt during suspend for driver state RESTARTING

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220426221859.v2.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

