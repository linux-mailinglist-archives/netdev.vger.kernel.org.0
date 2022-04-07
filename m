Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657394F717D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 03:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238299AbiDGBdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 21:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242153AbiDGBcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 21:32:07 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FE81C3916;
        Wed,  6 Apr 2022 18:27:09 -0700 (PDT)
Received: from [192.168.223.80] (unknown [114.10.20.104])
        by gnuweeb.org (Postfix) with ESMTPSA id 15BDC7E312;
        Thu,  7 Apr 2022 01:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649294829;
        bh=v3T6p4psoRPO+Fltr9gR2aL5jdiorS3XukHDVJFHNvE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sIvCgU16yu2eilHnNgbtqH5Mzv1AGuySgXuPDiXhVk4KgZbDwDXPw5sswyLAiwyKB
         xfI7ccp9M1AYUjlSczO1oyNg5FkYx/oeQuGElfteHNUGaX7yqz34cSNeX+w1Cvt5Qc
         kqF4XVOwEax5rxButE93zwPOiM7uTq9V2JZKjE3B8zsHEHg1HW57b6CmGyr/RtmUBl
         oNTCzeHftFH1EJGlNxK8jaG38FQ6YJQg8abjOHCdH9F38ulC2xwuIYeOIzN4VmiK6R
         yN/jjcFyD8lwW+hXae1OhcuY+Ix7kE6S7SFWbO79zaG9lFotfooEfpabkcbrzkkvbu
         ks/SmM80t1cUg==
Message-ID: <875af62c-363e-3fc3-9c38-dcf8b3071c99@gnuweeb.org>
Date:   Thu, 7 Apr 2022 08:26:59 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [Linux 5.18-rc1] WARNING: possible circular locking dependency
 detected at (rtw_ops_config, ieee80211_mgd_probe_ap)
Content-Language: en-US
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>
References: <2565e500-0e2f-c688-19e0-d241e4e7e031@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <2565e500-0e2f-c688-19e0-d241e4e7e031@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Got another call trace, but still the same deadlock scenario.

[21860.955645] ======================================================
[21860.955646] WARNING: possible circular locking dependency detected
[21860.955646] 5.18.0-rc1-superb-owl-dirty #6 Tainted: G        W
[21860.955647] ------------------------------------------------------
[21860.955648] wpa_supplicant/762 is trying to acquire lock:
[21860.955649] ffff8881158d8198 (&rtwdev->mutex){+.+.}-{3:3}, at: rtw_ops_config (drivers/net/wireless/realtek/rtw88/mac80211.c:80) rtw88_core
[21860.955657]
                but task is already holding lock:
[21860.955657] ffff8881158d2988 (&local->iflist_mtx){+.+.}-{3:3}, at: ieee80211_offchannel_stop_vifs (net/mac80211/offchannel.c:?) mac80211
[21860.955680]
                which lock already depends on the new lock.

[21860.955681]
                the existing dependency chain (in reverse order) is:
[21860.955681]
                -> #1 (&local->iflist_mtx){+.+.}-{3:3}:
[21860.955683] lock_acquire (kernel/locking/lockdep.c:5641)
[21860.955686] __mutex_lock_common (kernel/locking/mutex.c:600)
[21860.955689] mutex_lock_nested (kernel/locking/mutex.c:733 kernel/locking/mutex.c:785)
[21860.955690] ieee80211_iterate_interfaces (net/mac80211/util.c:815) mac80211
[21860.955705] rtw_fw_c2h_cmd_handle (./include/net/mac80211.h:? drivers/net/wireless/realtek/rtw88/fw.c:177 drivers/net/wireless/realtek/rtw88/fw.c:243) rtw88_core
[21860.955709] rtw_c2h_work (./include/linux/netdevice.h:3710 drivers/net/wireless/realtek/rtw88/main.c:274) rtw88_core
[21860.955712] process_one_work (kernel/workqueue.c:2294)
[21860.955714] worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
[21860.955716] kthread (kernel/kthread.c:377)
[21860.955718] ret_from_fork (??:?)
[21860.955719]
                -> #0 (&rtwdev->mutex){+.+.}-{3:3}:
[21860.955721] validate_chain (kernel/locking/lockdep.c:? kernel/locking/lockdep.c:3188 kernel/locking/lockdep.c:3803)
[21860.955722] __lock_acquire (kernel/locking/lockdep.c:5029)
[21860.955724] lock_acquire (kernel/locking/lockdep.c:5641)
[21860.955725] __mutex_lock_common (kernel/locking/mutex.c:600)
[21860.955727] mutex_lock_nested (kernel/locking/mutex.c:733 kernel/locking/mutex.c:785)
[21860.955729] rtw_ops_config (drivers/net/wireless/realtek/rtw88/mac80211.c:80) rtw88_core
[21860.955732] ieee80211_hw_config (util.c:?) mac80211
[21860.955747] ieee80211_offchannel_stop_vifs (./arch/x86/include/asm/bitops.h:207 ./include/asm-generic/bitops/instrumented-non-atomic.h:135 ./include/net/mac80211.h:2664 net/mac80211/offchannel.c:46 net/mac80211/offchannel.c:127) mac80211
[21860.955761] __ieee80211_start_scan (debugfs_sta.c:?) mac80211
[21860.955775] ieee80211_request_scan (mesh.c:?) mac80211
[21860.955790] cfg80211_scan (net/wireless/rdev-ops.h:439 net/wireless/scan.c:901) cfg80211
[21860.955808] nl80211_trigger_scan (net/wireless/nl80211.c:?) cfg80211
[21860.955822] genl_rcv_msg (net/netlink/genetlink.c:731 net/netlink/genetlink.c:775 net/netlink/genetlink.c:792)
[21860.955824] netlink_rcv_skb (net/netlink/af_netlink.c:2497)
[21860.955825] genl_rcv (net/netlink/genetlink.c:804)
[21860.955826] netlink_unicast (net/netlink/af_netlink.c:1320 net/netlink/af_netlink.c:1345)
[21860.955827] netlink_sendmsg (net/netlink/af_netlink.c:1921)
[21860.955828] ____sys_sendmsg+0x13a/0x1c0
[21860.955831] __sys_sendmsg (net/socket.c:2467 net/socket.c:2496)
[21860.955832] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[21860.955834] entry_SYSCALL_64_after_hwframe (??:?)
[21860.955835]
                other info that might help us debug this:

[21860.955836]  Possible unsafe locking scenario:

[21860.955837]        CPU0                    CPU1
[21860.955837]        ----                    ----
[21860.955838]   lock(&local->iflist_mtx);
[21860.955839]                                lock(&rtwdev->mutex);
[21860.955840]                                lock(&local->iflist_mtx);
[21860.955841]   lock(&rtwdev->mutex);
[21860.955842]
                  *** DEADLOCK ***

[21860.955843] 4 locks held by wpa_supplicant/762:
[21860.955844]  #0: ffffffff82cc94b0 (cb_lock){++++}-{3:3}, at: genl_rcv (net/netlink/genetlink.c:803)
[21860.955846]  #1: ffff8881158d0728 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_pre_doit (./include/net/cfg80211.h:?) cfg80211
[21860.955861]  #2: ffff8881158d2aa8 (&local->mtx){+.+.}-{3:3}, at: ieee80211_request_scan (mesh.c:?) mac80211
[21860.955877]  #3: ffff8881158d2988 (&local->iflist_mtx){+.+.}-{3:3}, at: ieee80211_offchannel_stop_vifs (net/mac80211/offchannel.c:?) mac80211
[21860.955893]
                stack backtrace:
[21860.955894] CPU: 6 PID: 762 Comm: wpa_supplicant Tainted: G        W         5.18.0-rc1-superb-owl-dirty #6 ae19ca04b7ff4055c7991137cdc0ddedc2ff43e3
[21860.955896] Hardware name: HP HP Laptop 14s-dq2xxx/87FD, BIOS F.15 09/15/2021
[21860.955897] Call Trace:
[21860.955898]  <TASK>
[21860.955899] dump_stack_lvl (lib/dump_stack.c:107)
[21860.955902] print_circular_bug (lib/dump_stack.c:? kernel/locking/lockdep.c:2023)
[21860.955904] ? stack_trace_save (kernel/stacktrace.c:123)
[21860.955906] ? save_trace (kernel/locking/lockdep.c:551)
[21860.955907] ? __bfs (kernel/locking/lockdep.c:1760)
[21860.955909] check_noncircular (kernel/locking/lockdep.c:?)
[21860.955912] validate_chain (kernel/locking/lockdep.c:? kernel/locking/lockdep.c:3188 kernel/locking/lockdep.c:3803)
[21860.955914] ? stack_trace_save (kernel/stacktrace.c:123)
[21860.955916] ? save_trace (kernel/locking/lockdep.c:551)
[21860.955917] ? add_lock_to_list (./include/linux/rculist.h:? ./include/linux/rculist.h:128 kernel/locking/lockdep.c:1405)
[21860.955920] ? __lock_acquire (kernel/locking/lockdep.c:5029)
[21860.955922] ? lock_is_held_type (kernel/locking/lockdep.c:? kernel/locking/lockdep.c:5685)
[21860.955923] __lock_acquire (kernel/locking/lockdep.c:5029)
[21860.955925] lock_acquire (kernel/locking/lockdep.c:5641)
[21860.955927] ? rtw_ops_config (drivers/net/wireless/realtek/rtw88/mac80211.c:80) rtw88_core
[21860.955932] ? rtw_ops_config (drivers/net/wireless/realtek/rtw88/mac80211.c:80) rtw88_core
[21860.955935] __mutex_lock_common (kernel/locking/mutex.c:600)
[21860.955937] ? rtw_ops_config (drivers/net/wireless/realtek/rtw88/mac80211.c:80) rtw88_core
[21860.955941] ? lock_is_held_type (kernel/locking/lockdep.c:? kernel/locking/lockdep.c:5685)
[21860.955942] ? rtw_ops_config (drivers/net/wireless/realtek/rtw88/mac80211.c:80) rtw88_core
[21860.955946] mutex_lock_nested (kernel/locking/mutex.c:733 kernel/locking/mutex.c:785)
[21860.955948] rtw_ops_config (drivers/net/wireless/realtek/rtw88/mac80211.c:80) rtw88_core
[21860.955952] ieee80211_hw_config (util.c:?) mac80211
[21860.955967] ieee80211_offchannel_stop_vifs (./arch/x86/include/asm/bitops.h:207 ./include/asm-generic/bitops/instrumented-non-atomic.h:135 ./include/net/mac80211.h:2664 net/mac80211/offchannel.c:46 net/mac80211/offchannel.c:127) mac80211
[21860.955982] __ieee80211_start_scan (debugfs_sta.c:?) mac80211
[21860.955997] ieee80211_request_scan (mesh.c:?) mac80211
[21860.956012] cfg80211_scan (net/wireless/rdev-ops.h:439 net/wireless/scan.c:901) cfg80211
[21860.956026] nl80211_trigger_scan (net/wireless/nl80211.c:?) cfg80211
[21860.956041] ? nl80211_update_mesh_config (net/wireless/nl80211.c:8556) cfg80211
[21860.956055] genl_rcv_msg (net/netlink/genetlink.c:731 net/netlink/genetlink.c:775 net/netlink/genetlink.c:792)
[21860.956056] ? nl80211_update_mesh_config (net/wireless/nl80211.c:8556) cfg80211
[21860.956071] ? genl_bind (net/netlink/genetlink.c:781)
[21860.956073] netlink_rcv_skb (net/netlink/af_netlink.c:2497)
[21860.956074] genl_rcv (net/netlink/genetlink.c:804)
[21860.956076] netlink_unicast (net/netlink/af_netlink.c:1320 net/netlink/af_netlink.c:1345)
[21860.956077] netlink_sendmsg (net/netlink/af_netlink.c:1921)
[21860.956079] ____sys_sendmsg+0x13a/0x1c0
[21860.956081] ? __import_iovec (./include/linux/err.h:36 lib/iov_iter.c:1949)
[21860.956083] __sys_sendmsg (net/socket.c:2467 net/socket.c:2496)
[21860.956085] ? __lock_acquire (kernel/locking/lockdep.c:5029)
[21860.956087] ? lock_release (kernel/locking/lockdep.c:? kernel/locking/lockdep.c:5663)
[21860.956089] ? lock_is_held_type (kernel/locking/lockdep.c:? kernel/locking/lockdep.c:5685)
[21860.956091] ? syscall_enter_from_user_mode (kernel/entry/common.c:109 kernel/entry/common.c:109)
[21860.956092] ? syscall_enter_from_user_mode (kernel/entry/common.c:109 kernel/entry/common.c:109)
[21860.956093] ? lockdep_hardirqs_on (kernel/locking/lockdep.c:4356)
[21860.956094] ? syscall_enter_from_user_mode (kernel/entry/common.c:109 kernel/entry/common.c:109)
[21860.956095] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
[21860.956097] entry_SYSCALL_64_after_hwframe (??:?)
[21860.956099] RIP: 0033:0x7fe7a3526427
[21860.956101] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
All code
========
    0: 0f 00                 (bad)
    2: f7 d8                 neg    %eax
    4: 64 89 02              mov    %eax,%fs:(%rdx)
    7: 48 c7 c0 ff ff ff ff  mov    $0xffffffffffffffff,%rax
    e: eb b9                 jmp    0xffffffffffffffc9
   10: 0f 1f 00              nopl   (%rax)
   13: f3 0f 1e fa           endbr64
   17: 64 8b 04 25 18 00 00  mov    %fs:0x18,%eax
   1e: 00
   1f: 85 c0                 test   %eax,%eax
   21: 75 10                 jne    0x33
   23: b8 2e 00 00 00        mov    $0x2e,%eax
   28: 0f 05                 syscall
   2a:*  48 3d 00 f0 ff ff     cmp    $0xfffffffffffff000,%rax   <-- trapping instruction
   30: 77 51                 ja     0x83
   32: c3                    ret
   33: 48 83 ec 28           sub    $0x28,%rsp
   37: 89 54 24 1c           mov    %edx,0x1c(%rsp)
   3b: 48 89 74 24 10        mov    %rsi,0x10(%rsp)

Code starting with the faulting instruction
===========================================
    0: 48 3d 00 f0 ff ff     cmp    $0xfffffffffffff000,%rax
    6: 77 51                 ja     0x59
    8: c3                    ret
    9: 48 83 ec 28           sub    $0x28,%rsp
    d: 89 54 24 1c           mov    %edx,0x1c(%rsp)
   11: 48 89 74 24 10        mov    %rsi,0x10(%rsp)
[21860.956102] RSP: 002b:00007fffe7b1bcd8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[21860.956104] RAX: ffffffffffffffda RBX: 000055924dcbc140 RCX: 00007fe7a3526427
[21860.956105] RDX: 0000000000000000 RSI: 00007fffe7b1bd10 RDI: 0000000000000006
[21860.956106] RBP: 000055924dcbc050 R08: 0000000000000004 R09: 00007fe7a3619c60
[21860.956107] R10: 00007fffe7b1bde0 R11: 0000000000000246 R12: 000055924dcedae0
[21860.956108] R13: 00007fffe7b1bd10 R14: 00007fffe7b1bde0 R15: 000055924dcc3490
[21860.956110]  </TASK>
[22119.373650] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[22119.506938] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23104.756828] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23758.396338] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23760.799553] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23761.282900] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23761.426235] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23761.836309] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23761.972956] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23762.376290] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23762.509633] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23762.919547] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23763.052922] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23763.466196] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23763.606276] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23764.019547] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23764.152875] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23764.556269] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23764.689553] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23765.092922] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23765.226242] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23765.629590] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23765.762919] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23766.166121] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23766.299535] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23766.702807] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23766.842883] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23794.528871] wlo1: Connection to AP 82:01:2d:54:34:d1 lost
[23794.852512] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[23795.052568] rtw_8822ce 0000:01:00.0: timed out to flush queue 1
[27134.467976] wlo1: authenticate with 82:01:2d:54:34:d1
[27134.468003] wlo1: bad VHT capabilities, disabling VHT
[27134.759606] wlo1: send auth to 82:01:2d:54:34:d1 (try 1/3)
[27134.762952] wlo1: authenticated
[27134.766266] wlo1: associate with 82:01:2d:54:34:d1 (try 1/3)
[27134.772858] wlo1: RX AssocResp from 82:01:2d:54:34:d1 (capab=0x431 status=0 aid=2)
[27134.773101] wlo1: associated
[27134.793181] wlo1: Limiting TX power to 0 (-128 - 0) dBm as advertised by 82:01:2d:54:34:d1
[27134.856375] IPv6: ADDRCONF(NETDEV_CHANGE): wlo1: link becomes ready


-- 
Ammar Faizi
