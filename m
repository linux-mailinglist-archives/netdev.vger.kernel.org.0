Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0BE183684
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 17:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgCLQsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 12:48:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:38730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgCLQsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 12:48:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 63EB0ADEB;
        Thu, 12 Mar 2020 16:48:15 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 15D97E0C79; Thu, 12 Mar 2020 17:48:14 +0100 (CET)
Date:   Thu, 12 Mar 2020 17:48:14 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] net: sched: make newly activated qdiscs visible
Message-ID: <20200312164814.GO8012@unicorn.suse.cz>
References: <20200310165335.88715-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310165335.88715-1-jwi@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 05:53:35PM +0100, Julian Wiedmann wrote:
> In their .attach callback, mq[prio] only add the qdiscs of the currently
> active TX queues to the device's qdisc hash list.
> If a user later increases the number of active TX queues, their qdiscs
> are not visible via eg. 'tc qdisc show'.
> 
> Add a hook to netif_set_real_num_tx_queues() that walks all active
> TX queues and adds those which are missing to the hash list.
> 
> CC: Eric Dumazet <edumazet@google.com>
> CC: Jamal Hadi Salim <jhs@mojatatu.com>
> CC: Cong Wang <xiyou.wangcong@gmail.com>
> CC: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> ---

I started seeing the stack trace below consistently on boot with
(patched) net-next today and checking latest changes brought my
attention to commit 4cda75275f9f ("net: sched: make newly activated
qdiscs visible") (this patch) because it added the call of
dev_qdisc_set_real_num_tx_queues() to netif_set_real_num_tx_queues().
After reverting the commit, the same machine boots without any issue.

Michal

[   40.579142] BUG: kernel NULL pointer dereference, address: 0000000000000400
[   40.586922] #PF: supervisor read access in kernel mode
[   40.592668] #PF: error_code(0x0000) - not-present page
[   40.598405] PGD 0 P4D 0 
[   40.601234] Oops: 0000 [#1] PREEMPT SMP PTI
[   40.605909] CPU: 18 PID: 1681 Comm: wickedd Tainted: G            E     5.6.0-rc3-ethnl.50-default #1
[   40.616205] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.R3.27.D685.1305151734 05/15/2013
[   40.627377] RIP: 0010:qdisc_hash_add.part.22+0x2e/0x90
[   40.633115] Code: 00 55 53 89 f5 48 89 fb e8 2f 9b fb ff 85 c0 74 44 48 8b 43 40 48 8b 08 69 43 38 47 86 c8 61 c1 e8 1c 48 83 e8 80 48 8d 14 c1 <48> 8b 04 c1 48 8d 4b 28 48 89 53 30 48 89 43 28 48 85 c0 48 89 0a
[   40.654080] RSP: 0018:ffffb879864934d8 EFLAGS: 00010203
[   40.659914] RAX: 0000000000000080 RBX: ffffffffb8328d80 RCX: 0000000000000000
[   40.667882] RDX: 0000000000000400 RSI: 0000000000000000 RDI: ffffffffb831faa0
[   40.675849] RBP: 0000000000000000 R08: ffffa0752c8b9088 R09: ffffa0752c8b9208
[   40.683816] R10: 0000000000000006 R11: 0000000000000000 R12: ffffa0752d734000
[   40.691783] R13: 0000000000000008 R14: 0000000000000000 R15: ffffa07113c18000
[   40.699750] FS:  00007f94548e5880(0000) GS:ffffa0752e980000(0000) knlGS:0000000000000000
[   40.708782] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.715189] CR2: 0000000000000400 CR3: 000000082b6ae006 CR4: 00000000001606e0
[   40.723156] Call Trace:
[   40.725888]  dev_qdisc_set_real_num_tx_queues+0x61/0x90
[   40.731725]  netif_set_real_num_tx_queues+0x94/0x1d0
[   40.737286]  __igb_open+0x19a/0x5d0 [igb]
[   40.741767]  __dev_open+0xbb/0x150
[   40.745567]  __dev_change_flags+0x157/0x1a0
[   40.750240]  dev_change_flags+0x23/0x60
[   40.754524]  do_setlink+0x301/0xe50
[   40.758420]  ? __nla_reserve+0x38/0x50
[   40.762609]  ? __nla_validate_parse+0x41/0x880
[   40.767569]  ? nla_put+0x2f/0x40
[   40.771167]  ? inet6_fill_ifla6_attrs+0x429/0x450
[   40.776417]  ? __nla_reserve+0x38/0x50
[   40.780603]  __rtnl_newlink+0x544/0x8d0
[   40.784887]  ? rtnl_dump_ifinfo+0x40b/0x560
[   40.789559]  ? __nla_reserve+0x38/0x50
[   40.793744]  ? __nla_put+0xc/0x20
[   40.797445]  ? nla_put+0x2f/0x40
[   40.801054]  ? fib_nexthop_info+0xde/0x1c0
[   40.805639]  ? kmem_cache_alloc_trace+0x1e0/0x5a0
[   40.810896]  ? __local_bh_enable_ip+0x47/0x80
[   40.815762]  rtnl_newlink+0x47/0x70
[   40.819659]  ? ns_capable_common+0x27/0x50
[   40.824234]  rtnetlink_rcv_msg+0x125/0x320
[   40.828809]  ? kmem_cache_alloc_node_trace+0x241/0x5b0
[   40.834546]  ? rtnl_calcit.isra.34+0x110/0x110
[   40.839511]  netlink_rcv_skb+0x4a/0x110
[   40.843793]  netlink_unicast+0x18e/0x250
[   40.848165]  netlink_sendmsg+0x2f2/0x410
[   40.852551]  sock_sendmsg+0x5b/0x60
[   40.856449]  ____sys_sendmsg+0x1e2/0x240
[   40.860829]  ? copy_msghdr_from_user+0xc5/0x130
[   40.865891]  ___sys_sendmsg+0x88/0xd0
[   40.869982]  ? preempt_count_sub+0x43/0x50
[   40.874558]  ? _raw_spin_unlock+0x16/0x30
[   40.879037]  ? do_wp_page+0x164/0x540
[   40.883127]  ? handle_pte_fault+0x521/0xda0
[   40.887799]  ? __handle_mm_fault+0x4e0/0x600
[   40.892568]  ? __sys_sendmsg+0x4e/0x80
[   40.896757]  __sys_sendmsg+0x4e/0x80
[   40.900756]  do_syscall_64+0x5a/0x1c0
[   40.904846]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   40.910486] RIP: 0033:0x7f9453dd8c47
[   40.914477] Code: 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 80 00 00 00 00 8b 05 ea fb 2b 00 48 63 d2 48 63 ff 85 c0 75 18 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 59 f3 c3 0f 1f 80 00 00 00 00 53 48 89 f3 48
[   40.935445] RSP: 002b:00007fffe72e6cb8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[   40.943901] RAX: ffffffffffffffda RBX: 000055df06f8dde0 RCX: 00007f9453dd8c47
[   40.951870] RDX: 0000000000000000 RSI: 00007fffe72e6cf0 RDI: 0000000000000006
[   40.959835] RBP: 000055df070d4c70 R08: 000055df070d4c70 R09: 000055df0703ae40
[   40.967800] R10: 0000000000000152 R11: 0000000000000246 R12: 000055df0702a330
[   40.975768] R13: 00007fffe72e6cf0 R14: 00007fffe72e6e40 R15: 000055df070211e0
[   40.983744] Modules linked in: br_netfilter(E) bridge(E) stp(E) llc(E) iscsi_ibft(E) iscsi_boot_sysfs(E) sunrpc(E) intel_rapl_msr(E) intel_rapl_common(E) sb_edac(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) crct10dif_pclmul(E) ixgbe(E) sfc(E) crc32_pclmul(E) crc32c_intel(E) ghash_clmulni_intel(E) xfrm_algo(E) iTCO_wdt(E) ipmi_ssif(E) aesni_intel(E) igb(E) libphy(E) iTCO_vendor_support(E) crypto_simd(E) joydev(E) mdio(E) mtd(E) cryptd(E) ptp(E) glue_helper(E) ioatdma(E) pps_core(E) ipmi_si(E) pcspkr(E) lpc_ich(E) dca(E) i2c_i801(E) ipmi_devintf(E) ipmi_msghandler(E) button(E) hid_generic(E) usbhid(E) mgag200(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) drm_vram_helper(E) drm_ttm_helper(E) ttm(E) ehci_pci(E) ehci_hcd(E) sr_mod(E) drm(E) cdrom(E) i2c_algo_bit(E) usbcore(E) isci(E) libsas(E) scsi_transport_sas(E) wmi(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E)
[   41.076818] CR2: 0000000000000400
[   41.076867] ---[ end trace c1af668e054f361a ]---
