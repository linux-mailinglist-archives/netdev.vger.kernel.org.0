Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0AE3809EC
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 14:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhENMyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 08:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbhENMyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 08:54:11 -0400
X-Greylist: delayed 459 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 14 May 2021 05:53:00 PDT
Received: from outbound5.mail.transip.nl (outbound5.mail.transip.nl [IPv6:2a01:7c8:7c9:ca11:136:144:136:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2B7C061574;
        Fri, 14 May 2021 05:53:00 -0700 (PDT)
Received: from submission4.mail.transip.nl (unknown [10.103.8.155])
        by outbound5.mail.transip.nl (Postfix) with ESMTP id 4FhSt62j4JzHCtB;
        Fri, 14 May 2021 14:45:18 +0200 (CEST)
Received: from transip.email (unknown [10.103.8.118])
        by submission4.mail.transip.nl (Postfix) with ESMTPA id 4FhSt30ljYznTYs;
        Fri, 14 May 2021 14:45:10 +0200 (CEST)
MIME-Version: 1.0
Date:   Fri, 14 May 2021 14:45:10 +0200
From:   dave@bewaar.me
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        anapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [BUG] recursive lock in mwifiex_uninit_sw
Message-ID: <ab4d00ce52f32bd8e45ad0448a44737e@bewaar.me>
X-Sender: dave@bewaar.me
User-Agent: Webmail
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: ClueGetter at submission4.mail.transip.nl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=transip-a; d=bewaar.me; t=1620996315; h=from:subject:to:cc:date:
 mime-version:content-type;
 bh=Daxo7C8BJ0xC7g75uEADc0HoTfZJdqRTKuWOYREQ42k=;
 b=Qk0HpLX1u+qkvPHuVsDr8wxvuF2hho6/VXE7YgqrcSM6GgtxquAL4/SdAKFvSXArvcLOaZ
 SV1I6zl5AWd0BQttT2gNs/EQg5TfK6mxKWBF7Kemuxuw2s894NUQXOw4WPL50SBp8NOsGG
 uD3T84qyviMlEu2Uc+iMRTlhr769hyycHhgDjtphPwhuB4VjwbbvQJW5Mhgw9hRmL/v6FE
 J3nFo4GEkonhQi6qtgO/JRz/lbwW/iW+EkJxY2FWmHUZeW7hyV6IzTWrgUIOAIg0W9Ff6G
 3HYM29RSQY+oaAdyaVeR/MhKoYFTrdrqrZe8JAXMT1S5nv2M9orpmjTJsbextA==
X-Report-Abuse-To: abuse@transip.nl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A firmware crash of the Marvell 88W8897, which are spurious on Microsoft
Surface devices, will unload/reset the device. However this can also 
fail
in more recent kernels, which can cause more problems since the driver
does not unload. This causes programs trying to reach the network or
networking devices to hang which in turn causes a reboot/poweroff to 
hang.

This can happen on the following fedora rawhide kernels:
- 5.12.0-0.rc8.20210423git7af08140979a.193.fc35.x86_64 [1]
- 5.13.0-0.rc1.20210512git88b06399c9c7.15.fc35.x86_64 [2]

The latter seems to be more consistent in triggering this behaviour
(and crashing the firmware). If someone can give me some pointers
I would gladly help and debug this.

I know there is a set of patches for surface devices which address
these firmware crashes [3], however they have not made it upstream
yet and are not in the before mentioned kernels with this issue.

Regards,
Dave

[1]: 
https://gitlab.com/cki-project/kernel-ark/-/commit/bfe9c6281b1e9a08ad94ff76629279326a8483c1
[2]: 
https://gitlab.com/cki-project/kernel-ark/-/commit/b996c16ff61d147d9a02c74d600b4c576aea9f3a
[3]: 
https://github.com/linux-surface/linux-surface/blob/master/patches/5.12/0002-mwifiex.patch

[  440.345579] ============================================
[  440.345583] WARNING: possible recursive locking detected
[  440.345587] 5.13.0-0.rc1.20210512git88b06399c9c7.15.fc35.x86_64 #1 
Not tainted
[  440.345592] --------------------------------------------
[  440.345595] kworker/0:2/121 is trying to acquire lock:
[  440.345599] ffff9bbbc6792670 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: 
cfg80211_netdev_notifier_call+0xf8/0x5c0 [cfg80211]
[  440.345734]
                but task is already holding lock:
[  440.345737] ffff9bbbc6792670 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: 
mwifiex_uninit_sw+0x151/0x1f0 [mwifiex]
[  440.345783]
                other info that might help us debug this:
[  440.345786]  Possible unsafe locking scenario:

[  440.345788]        CPU0
[  440.345790]        ----
[  440.345792]   lock(&rdev->wiphy.mtx);
[  440.345797]   lock(&rdev->wiphy.mtx);
[  440.345801]
                 *** DEADLOCK ***

[  440.345804]  May be due to missing lock nesting notation

[  440.345806] 5 locks held by kworker/0:2/121:
[  440.345810]  #0: ffff9bbb80055148 
((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x21a/0x5e0
[  440.345825]  #1: ffffba12814b3e70 
((work_completion)(&card->work)){+.+.}-{0:0}, at: 
process_one_work+0x21a/0x5e0
[  440.345837]  #2: ffff9bbb82263258 (&dev->mutex){....}-{3:3}, at: 
pci_try_reset_function+0x3d/0x90
[  440.345852]  #3: ffffffffa11e7f90 (rtnl_mutex){+.+.}-{3:3}, at: 
mwifiex_uninit_sw+0x146/0x1f0 [mwifiex]
[  440.345879]  #4: ffff9bbbc6792670 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: 
mwifiex_uninit_sw+0x151/0x1f0 [mwifiex]
[  440.345906]
                stack backtrace:
[  440.345909] CPU: 0 PID: 121 Comm: kworker/0:2 Not tainted 
5.13.0-0.rc1.20210512git88b06399c9c7.15.fc35.x86_64 #1
[  440.345915] Hardware name: Microsoft Corporation Surface Pro/Surface 
Pro, BIOS 235.3440.768 11.16.2020
[  440.345919] Workqueue: events mwifiex_pcie_work [mwifiex_pcie]
[  440.345928] Call Trace:
[  440.345935]  dump_stack+0x7f/0xa1
[  440.345943]  __lock_acquire.cold+0x17d/0x2bf
[  440.345953]  ? lock_is_held_type+0xa7/0x120
[  440.345961]  lock_acquire+0xc4/0x3a0
[  440.345967]  ? cfg80211_netdev_notifier_call+0xf8/0x5c0 [cfg80211]
[  440.346062]  ? __bfs+0xf5/0x230
[  440.346069]  ? lock_is_held_type+0xa7/0x120
[  440.346077]  __mutex_lock+0x91/0x830
[  440.346082]  ? cfg80211_netdev_notifier_call+0xf8/0x5c0 [cfg80211]
[  440.346175]  ? __bfs+0xf5/0x230
[  440.346181]  ? cfg80211_netdev_notifier_call+0xf8/0x5c0 [cfg80211]
[  440.346270]  ? check_path.constprop.0+0x24/0x50
[  440.346278]  ? check_noncircular+0x70/0x100
[  440.346286]  ? cfg80211_netdev_notifier_call+0xf8/0x5c0 [cfg80211]
[  440.346375]  cfg80211_netdev_notifier_call+0xf8/0x5c0 [cfg80211]
[  440.346471]  ? __lock_acquire+0x3ac/0x1e10
[  440.346481]  ? lock_acquire+0xc4/0x3a0
[  440.346486]  ? lock_is_held_type+0xa7/0x120
[  440.346492]  ? find_held_lock+0x32/0x90
[  440.346499]  ? sched_clock_cpu+0xc/0xb0
[  440.346505]  ? lock_is_held_type+0xa7/0x120
[  440.346510]  ? cfg80211_register_netdevice+0x130/0x130 [cfg80211]
[  440.346604]  ? rcu_read_lock_sched_held+0x3f/0x80
[  440.346615]  notifier_call_chain+0x42/0xb0
[  440.346624]  __dev_close_many+0x62/0x100
[  440.346634]  dev_close_many+0x7b/0x110
[  440.346641]  unregister_netdevice_many+0x14b/0x760
[  440.346650]  unregister_netdevice_queue+0xab/0xf0
[  440.346658]  _cfg80211_unregister_wdev+0x170/0x210 [cfg80211]
[  440.346752]  mwifiex_del_virtual_intf+0x178/0x1a0 [mwifiex]
[  440.346778]  mwifiex_uninit_sw+0x1d5/0x1f0 [mwifiex]
[  440.346801]  mwifiex_shutdown_sw+0x5c/0x90 [mwifiex]
[  440.346822]  mwifiex_pcie_reset_prepare+0x4d/0x90 [mwifiex_pcie]
[  440.346829]  pci_dev_save_and_disable+0x29/0x50
[  440.346835]  pci_try_reset_function+0x49/0x90
[  440.346840]  process_one_work+0x2b0/0x5e0
[  440.346849]  worker_thread+0x55/0x3c0
[  440.346854]  ? process_one_work+0x5e0/0x5e0
[  440.346860]  kthread+0x13a/0x150
[  440.346865]  ? __kthread_bind_mask+0x60/0x60
[  440.346871]  ret_from_fork+0x22/0x30
