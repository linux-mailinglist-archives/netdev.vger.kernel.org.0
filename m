Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9454D857A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbiCNMyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiCNMyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:54:01 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C492DA;
        Mon, 14 Mar 2022 05:52:45 -0700 (PDT)
Received: from [192.168.55.80] (unknown [182.2.71.250])
        by gnuweeb.org (Postfix) with ESMTPSA id DA17B7E2D8;
        Mon, 14 Mar 2022 12:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1647262364;
        bh=QP9qO2FBwMZ+3k7m4lRYIB4s3BYrNYzFDH5sYdG3TcA=;
        h=Date:From:To:Cc:Subject:From;
        b=YZuePdMFS8buq4NhNmYpWNGPftWC5GA/hDeKsRppbPS9c9JhqfjpYvvvvHd1lrjw/
         sH3eIEuDWtiUAmIemOCsU0MxBJIQRhGVjnDtjpKi7D4CzXByvRCi8cB+eFXy9z72Q8
         oZF/nXH0d+kfGy70MHc7DazuNlJhNC8kpNIWJI6btOl0UHA3MUGBSoJnZJKQFp9TWB
         qNsHdGy8HvxX8qUYvlUIuuOoYLHdHa0SB0GnQPf6ihi2V53/POnNmPUUMuNsPZsHxo
         6UIJdpug1pIrXtUmvdzW0Vs7MQrFXWxcTshHT6eD/L6aiswJy+Bp+RmBIMHb0zJDv/
         DLQByjAO671qQ==
Message-ID: <1f1488c8-6c63-db0a-b0f9-159a1ec8b5cd@gnuweeb.org>
Date:   Mon, 14 Mar 2022 19:52:36 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        stable@vger.kernel.org
Subject: [LOCKDEP SPLAT 5.17-rc8] WARNING: possible circular locking
 dependency detected (at: rtw_ops_config+0x27/0xd0 | at:
 ieee80211_mgd_probe_ap+0x114/0x150)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello,

I got the following lockdep splat in 5.17-rc8. I don't have the reproducer
for this. I will send a follow up if I can find something useful.

<4>[   93.549746][    T8]
<4>[   93.551216][    T8] ======================================================
<4>[   93.552707][    T8] WARNING: possible circular locking dependency detected
<4>[   93.554195][    T8] 5.17.0-rc8-superb-owl-00001-g09688c0166e7 #2 Not tainted
<4>[   93.555878][    T8] ------------------------------------------------------
<4>[   93.557667][    T8] kworker/u16:0/8 is trying to acquire lock:
<4>[   93.559459][    T8] ffff888167aa8170 (&rtwdev->mutex){+.+.}-{3:3}, at: rtw_ops_config+0x27/0xd0 [rtw88_core]
<4>[   93.561248][    T8]
<4>[   93.561248][    T8] but task is already holding lock:
<4>[   93.564694][    T8] ffff888167aa2988 (&local->iflist_mtx){+.+.}-{3:3}, at: ieee80211_mgd_probe_ap+0x114/0x150 [mac80211]
<4>[   93.566425][    T8]
<4>[   93.566425][    T8] which lock already depends on the new lock.
<4>[   93.566425][    T8]
<4>[   93.571410][    T8]
<4>[   93.571410][    T8] the existing dependency chain (in reverse order) is:
<4>[   93.574576][    T8]
<4>[   93.574576][    T8] -> #1 (&local->iflist_mtx){+.+.}-{3:3}:
<4>[   93.577669][    T8]        lock_acquire+0xc0/0x190
<4>[   93.579207][    T8]        __mutex_lock_common+0xab/0xe20
<4>[   93.580726][    T8]        mutex_lock_nested+0x1c/0x30
<4>[   93.582196][    T8]        ieee80211_iterate_interfaces+0x2a/0x50 [mac80211]
<4>[   93.583681][    T8]        rtw_fw_c2h_cmd_handle+0x16e/0x1b0 [rtw88_core]
<4>[   93.585152][    T8]        rtw_c2h_work+0x49/0x70 [rtw88_core]
<4>[   93.586601][    T8]        process_one_work+0x299/0x410
<4>[   93.588012][    T8]        worker_thread+0x240/0x440
<4>[   93.589413][    T8]        kthread+0xef/0x110
<4>[   93.590817][    T8]        ret_from_fork+0x1f/0x30
<4>[   93.592222][    T8]
<4>[   93.592222][    T8] -> #0 (&rtwdev->mutex){+.+.}-{3:3}:
<4>[   93.594901][    T8]        validate_chain+0x16d8/0x2800
<4>[   93.596202][    T8]        __lock_acquire+0x910/0xbf0
<4>[   93.597473][    T8]        lock_acquire+0xc0/0x190
<4>[   93.598716][    T8]        __mutex_lock_common+0xab/0xe20
<4>[   93.599952][    T8]        mutex_lock_nested+0x1c/0x30
<4>[   93.601187][    T8]        rtw_ops_config+0x27/0xd0 [rtw88_core]
<4>[   93.602429][    T8]        ieee80211_hw_config+0x32b/0x3a0 [mac80211]
<4>[   93.603691][    T8]        ieee80211_recalc_ps+0x128/0x1f0 [mac80211]
<4>[   93.604942][    T8]        ieee80211_mgd_probe_ap+0x120/0x150 [mac80211]
<4>[   93.606196][    T8]        process_one_work+0x299/0x410
<4>[   93.607470][    T8]        worker_thread+0x240/0x440
<4>[   93.608732][    T8]        kthread+0xef/0x110
<4>[   93.610008][    T8]        ret_from_fork+0x1f/0x30
<4>[   93.611309][    T8]
<4>[   93.611309][    T8] other info that might help us debug this:
<4>[   93.611309][    T8]
<4>[   93.615150][    T8]  Possible unsafe locking scenario:
<4>[   93.615150][    T8]
<4>[   93.617743][    T8]        CPU0                    CPU1
<4>[   93.619014][    T8]        ----                    ----
<4>[   93.620289][    T8]   lock(&local->iflist_mtx);
<4>[   93.621556][    T8]                                lock(&rtwdev->mutex);
<4>[   93.622855][    T8]                                lock(&local->iflist_mtx);
<4>[   93.624149][    T8]   lock(&rtwdev->mutex);
<4>[   93.625423][    T8]
<4>[   93.625423][    T8]  *** DEADLOCK ***
<4>[   93.625423][    T8]
<4>[   93.629231][    T8] 4 locks held by kworker/u16:0/8:
<4>[   93.630516][    T8]  #0: ffff888165fb3938 ((wq_completion)phy0){+.+.}-{0:0}, at: process_one_work+0x241/0x410
<4>[   93.631845][    T8]  #1: ffffc9000016fe70 ((work_completion)(&ifmgd->monitor_work)){+.+.}-{0:0}, at: process_one_work+0x267/0x410
<4>[   93.633174][    T8]  #2: ffff888168b0cd00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_mgd_probe_ap+0x2e/0x150 [mac80211]
<4>[   93.634550][    T8]  #3: ffff888167aa2988 (&local->iflist_mtx){+.+.}-{3:3}, at: ieee80211_mgd_probe_ap+0x114/0x150 [mac80211]
<4>[   93.635943][    T8]
<4>[   93.635943][    T8] stack backtrace:
<4>[   93.638685][    T8] CPU: 5 PID: 8 Comm: kworker/u16:0 Not tainted 5.17.0-rc8-superb-owl-00001-g09688c0166e7 #2 c0022b89d38a680ae1699c58d0b58d598bc94d78
<4>[   93.640140][    T8] Hardware name: HP HP Laptop 14s-dq2xxx/87FD, BIOS F.15 09/15/2021
<4>[   93.640141][    T8] Workqueue: phy0 ieee80211_sta_monitor_work [mac80211]
<4>[   93.640156][    T8] Call Trace:
<4>[   93.640157][    T8]  <TASK>
<4>[   93.640159][    T8]  dump_stack_lvl+0x5d/0x78
<4>[   93.640161][    T8]  print_circular_bug+0x5cb/0x5d0
<4>[   93.640163][    T8]  ? ret_from_fork+0x1f/0x30
<4>[   93.640164][    T8]  ? stack_trace_save+0x3a/0x50
<4>[   93.640166][    T8]  ? save_trace+0x3d/0x2c0
<4>[   93.640168][    T8]  ? __bfs+0x115/0x200
<4>[   93.640169][    T8]  check_noncircular+0xd5/0xe0
<4>[   93.640170][    T8]  ? rcu_read_lock_sched_held+0x34/0x70
<4>[   93.640173][    T8]  ? trace_pelt_cfs_tp+0x28/0xc0
<4>[   93.640175][    T8]  validate_chain+0x16d8/0x2800
<4>[   93.640176][    T8]  ? rcu_read_lock_sched_held+0x34/0x70
<4>[   93.640179][    T8]  ? lockdep_unlock+0x60/0xd0
<4>[   93.662452][    T8]  ? validate_chain+0x7f2/0x2800
<4>[   93.663783][    T8]  __lock_acquire+0x910/0xbf0
<4>[   93.665091][    T8]  lock_acquire+0xc0/0x190
<4>[   93.666402][    T8]  ? rtw_ops_config+0x27/0xd0 [rtw88_core a449d5db60ca04d68f4e53b03937ed71ebf1d2c4]
<4>[   93.667734][    T8]  ? rtw_ops_config+0x27/0xd0 [rtw88_core a449d5db60ca04d68f4e53b03937ed71ebf1d2c4]
<4>[   93.669088][    T8]  __mutex_lock_common+0xab/0xe20
<4>[   93.670423][    T8]  ? rtw_ops_config+0x27/0xd0 [rtw88_core a449d5db60ca04d68f4e53b03937ed71ebf1d2c4]
<4>[   93.671779][    T8]  ? lock_is_held_type+0xe2/0x140
<4>[   93.673118][    T8]  ? rtw_ops_config+0x27/0xd0 [rtw88_core a449d5db60ca04d68f4e53b03937ed71ebf1d2c4]
<4>[   93.674480][    T8]  mutex_lock_nested+0x1c/0x30
<4>[   93.675854][    T8]  rtw_ops_config+0x27/0xd0 [rtw88_core a449d5db60ca04d68f4e53b03937ed71ebf1d2c4]
<4>[   93.677260][    T8]  ieee80211_hw_config+0x32b/0x3a0 [mac80211 43fac5b3b5afe755bbfeab9090be9cf8c1dc014f]
<4>[   93.678708][    T8]  ieee80211_recalc_ps+0x128/0x1f0 [mac80211 43fac5b3b5afe755bbfeab9090be9cf8c1dc014f]
<4>[   93.680147][    T8]  ieee80211_mgd_probe_ap+0x120/0x150 [mac80211 43fac5b3b5afe755bbfeab9090be9cf8c1dc014f]
<4>[   93.681607][    T8]  process_one_work+0x299/0x410
<4>[   93.683051][    T8]  worker_thread+0x240/0x440
<4>[   93.684512][    T8]  ? worker_clr_flags+0x40/0x40
<4>[   93.685957][    T8]  kthread+0xef/0x110
<4>[   93.687400][    T8]  ? kthread_blkcg+0x30/0x30
<4>[   93.688827][    T8]  ret_from_fork+0x1f/0x30
<4>[   93.690272][    T8]  </TASK>


-- 
Ammar Faizi

