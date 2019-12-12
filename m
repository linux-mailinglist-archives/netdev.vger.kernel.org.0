Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1E11D2F1
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbfLLQ6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:58:46 -0500
Received: from mx2.cyber.ee ([193.40.6.72]:46704 "EHLO mx2.cyber.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729260AbfLLQ6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 11:58:46 -0500
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
From:   Meelis Roos <mroos@linux.ee>
Subject: UBSAN: Undefined behaviour in drivers/net/wireless/ath/ath5k/base.c
 (two lines)
Message-ID: <0992ebdc-54a6-3451-86af-7d94ed3cf9cf@linux.ee>
Date:   Thu, 12 Dec 2019 18:58:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I added a AR5005G to a laptop toget WiFI and got UBSAN warnings with todays git kernel.

Relevant parts of dmesg (anything wireless or ath5k related + the UBSAN warnings themselves):

[   24.407902] cfg80211: Loading compiled-in X.509 certificates for regulatory database
[   24.426476] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[...]
[   25.075174] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[   25.082956] cfg80211: failed to load regulatory.d
[...]
[   31.285760] ath5k 0000:06:04.0: registered as 'phy0'
[   32.058128] ath: EEPROM regdomain: 0x63
[   32.058130] ath: EEPROM indicates we should expect a direct regpair map
[   32.058134] ath: Country alpha2 being used: 00
[   32.058135] ath: Regpair used: 0x63
[   32.058256] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   32.058554] ath5k: phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
[   32.339426] ath5k 0000:06:04.0 wlp6s4: renamed from wlan0
[   45.651817] ================================================================================
[   45.654340] UBSAN: Undefined behaviour in drivers/net/wireless/ath/ath5k/base.c:498:16
[   45.656882] load of value 225 is not a valid value for type '_Bool'
[   45.659422] CPU: 0 PID: 340 Comm: NetworkManager Not tainted 5.5.0-rc1-00027-gae4b064e2a61 #4
[   45.662014] Hardware name: QCI             00000000000000000               /EF6                             , BIOS Q3B81 10/11/2005
[   45.667286] Call Trace:
[   45.669906]  dump_stack+0x16/0x19
[   45.672508]  ubsan_epilogue+0x8/0x20
[   45.675114]  __ubsan_handle_load_invalid_value.cold+0x43/0x48
[   45.677786]  ? ieee80211_wake_queues_by_reason+0x85/0xa0 [mac80211]
[   45.680441]  ? __internal_add_timer+0x14/0x50
[   45.683081]  ath5k_vif_iter.cold+0x43/0x48 [ath5k]
[   45.685722]  ath5k_update_bssid_mask_and_opmode+0x52/0x140 [ath5k]
[   45.688390]  ath5k_add_interface+0x198/0x250 [ath5k]
[   45.691061]  ? ath5k_start+0xeb/0x120 [ath5k]
[   45.693680]  drv_add_interface+0x34/0x70 [mac80211]
[   45.696265]  ieee80211_do_open+0x13d/0x980 [mac80211]
[   45.698844]  ieee80211_open+0x41/0x50 [mac80211]
[   45.701382]  __dev_open+0xb6/0x150
[   45.703920]  __dev_change_flags+0x182/0x200
[   45.706482]  dev_change_flags+0x28/0x60
[   45.709032]  do_setlink+0x281/0x980
[   45.711519]  ? rtnl_is_locked+0xd/0x20
[   45.713957]  ? netdev_master_upper_dev_get+0xf/0x90
[   45.716374]  ? __nla_parse+0x2d/0x40
[   45.718760]  __rtnl_newlink+0x5f5/0x960
[   45.721120]  ? __nla_reserve+0x20/0xd0
[   45.723443]  ? nla_put+0x32/0x60
[   45.725743]  ? __kmalloc_track_caller+0xe7/0x270
[   45.728060]  ? pskb_expand_head+0x59/0x460
[   45.730379]  ? skb_free_head+0x25/0x30
[   45.732680]  ? sk_filter_trim_cap+0x33/0x210
[   45.735001]  ? __netlink_sendskb+0x37/0x50
[   45.737335]  ? apparmor_task_free+0xc0/0xc0
[   45.739665]  ? security_capable+0x3f/0x60
[   45.741985]  ? kmem_cache_alloc+0xc7/0x230
[   45.744299]  ? rtnl_newlink+0x24/0x60
[   45.746616]  rtnl_newlink+0x39/0x60
[   45.748890]  ? __rtnl_newlink+0x960/0x960
[   45.751160]  rtnetlink_rcv_msg+0x2bf/0x3e0
[   45.753428]  ? rtnl_calcit+0x100/0x100
[   45.755680]  netlink_rcv_skb+0x76/0xf0
[   45.757929]  ? rtnl_calcit+0x100/0x100
[   45.760167]  rtnetlink_rcv+0xd/0x10
[   45.762318]  netlink_unicast+0x19d/0x280
[   45.764378]  ? __check_object_size+0x104/0x11d
[   45.766437]  netlink_sendmsg+0x20f/0x470
[   45.768434]  ? netlink_unicast+0x280/0x280
[   45.770390]  sock_sendmsg+0x75/0x90
[   45.772290]  ____sys_sendmsg+0x1ea/0x240
[   45.774149]  ___sys_sendmsg+0x66/0xa0
[   45.775930]  ? addrconf_sysctl_forward+0xe5/0x240
[   45.777700]  ? dev_forward_change+0x140/0x140
[   45.779474]  ? sysctl_head_finish+0x11/0x30
[   45.781256]  ? proc_sys_call_handler+0xf8/0x1c0
[   45.783041]  ? proc_sys_call_handler+0x1c0/0x1c0
[   45.784790]  ? __fget_light+0x52/0x60
[   45.786514]  ? __fdget+0xd/0x10
[   45.788195]  __sys_sendmsg+0x4b/0x90
[   45.789876]  sys_socketcall+0x3af/0x450
[   45.791532]  ? exit_to_usermode_loop+0x76/0xb0
[   45.793190]  do_fast_syscall_32+0x95/0x270
[   45.794831]  entry_SYSENTER_32+0xa5/0xf7
[   45.796461] EIP: 0xb7ee19a9
[   45.798073] Code: 5d c3 8d b4 26 00 00 00 00 b8 00 09 3d 00 eb b4 8b 04 24 c3 8b 14 24 c3 8b 1c 24 c3 8b 34 24 c3 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90 8d 76
[   45.801678] EAX: ffffffda EBX: 00000010 ECX: bf8041a0 EDX: 00000000
[   45.803543] ESI: b7711000 EDI: 020948c8 EBP: 020948c8 ESP: bf804190
[   45.805422] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000282
[   45.807320] ================================================================================
[   45.935535] ================================================================================
[   45.937514] UBSAN: Undefined behaviour in drivers/net/wireless/ath/ath5k/base.c:489:16
[   45.939532] load of value 8 is not a valid value for type '_Bool'
[   45.941557] CPU: 0 PID: 55 Comm: kworker/u2:2 Not tainted 5.5.0-rc1-00027-gae4b064e2a61 #4
[   45.943638] Hardware name: QCI             00000000000000000               /EF6                             , BIOS Q3B81 10/11/2005
[   45.947971] Workqueue: phy0 ieee80211_reconfig_filter [mac80211]
[   45.950165] Call Trace:
[   45.952352]  dump_stack+0x16/0x19
[   45.954528]  ubsan_epilogue+0x8/0x20
[   45.956700]  __ubsan_handle_load_invalid_value.cold+0x43/0x48
[   45.958930]  ath5k_vif_iter.cold+0xd/0x48 [ath5k]
[   45.961182]  ? ath5k_remove_padding+0xa0/0xa0 [ath5k]
[   45.963457]  __iterate_interfaces+0x72/0x110 [mac80211]
[   45.965743]  ? ath5k_remove_padding+0xa0/0xa0 [ath5k]
[   45.968046]  ieee80211_iterate_active_interfaces_atomic+0x15/0x20 [mac80211]
[   45.970405]  ath5k_configure_filter+0x10d/0x1a0 [ath5k]
[   45.972764]  ? __switch_to_asm+0x27/0x50
[   45.975120]  ? __switch_to_asm+0x33/0x50
[   45.977438]  ? __switch_to_asm+0x27/0x50
[   45.979749]  ? ath5k_set_key+0x160/0x160 [ath5k]
[   45.982095]  ieee80211_configure_filter+0x123/0x1a0 [mac80211]
[   45.984451]  ieee80211_reconfig_filter+0xd/0x10 [mac80211]
[   45.986827]  process_one_work+0x134/0x2b0
[   45.989198]  worker_thread+0x13e/0x390
[   45.991557]  kthread+0xcd/0x100
[   45.993909]  ? process_one_work+0x2b0/0x2b0
[   45.996271]  ? kthread_unpark+0x70/0x70
[   45.998620]  ret_from_fork+0x2e/0x38
[   46.000968] ================================================================================

-- 
Meelis Roos <mroos@linux.ee>
