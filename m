Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF7B1EC95D
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgFCGVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:21:00 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:60556 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725836AbgFCGU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 02:20:59 -0400
X-IronPort-AV: E=Sophos;i="5.73,467,1583164800"; 
   d="scan'208";a="93732122"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 03 Jun 2020 14:20:54 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 7472C4CDFAC5;
        Wed,  3 Jun 2020 14:20:52 +0800 (CST)
Received: from fnst.localdomain (10.167.226.155) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Wed, 3 Jun 2020 14:20:51 +0800
Date:   Wed, 3 Jun 2020 14:20:44 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Brenden Blanco <bblanco@gmail.com>, <karsten.elfenbein@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: BUG: kernel NULL pointer dereference in
 __cgroup_bpf_run_filter_skb
Message-ID: <20200603062044.GC5344@fnst.localdomain>
References: <20200530074608.GA60664@fnst.localdomain>
 <CAH9hs-JGVYAPqAjx24Qj0J9agFn4Lexn0E_mr48PEyeD0WB9jg@mail.gmail.com>
 <CAADnVQ+wsYhmiEty4NXjj8gOFxt8dc-bQUGwRBPYoYGRFg7NrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAADnVQ+wsYhmiEty4NXjj8gOFxt8dc-bQUGwRBPYoYGRFg7NrQ@mail.gmail.com>
X-Originating-IP: [10.167.226.155]
X-ClientProxiedBy: G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) To
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204)
X-yoursite-MailScanner-ID: 7472C4CDFAC5.AF644
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 03:17:18PM -0700, Alexei Starovoitov wrote:
>On Tue, Jun 2, 2020 at 2:46 PM Brenden Blanco <bblanco@gmail.com> wrote:
>>
>> On Sat, May 30, 2020 at 12:51 AM Lu Fengqi <lufq.fnst@cn.fujitsu.com> wrote:
>> >
>> > Hello,
>> >
>> > I encountered a reproducible NULL pointer dereference using the mainline
>> > kernel v5.7-rc7-44-g75caf310d16c(which also happened multiple times on
>> > 5.6.14). The machine is installed with archlinux, used as a kubernetes
>> > v1.18.3 node, and uses calico v3.13.2 as a cni plugin. I use kdump/crash
>> > to see the value of the bpf_prog pointer in cgroup.bpf is 0x0 or 0x800.
>> >
>> > I am not sure whether this is caused by kernel bpf or calico? If you need
>> > me to provide more information, please let me know. Any suggestions are
>> > very helpful.
>>
>> I encountered a similar set of crashes. I was able to workaround it by
>> disabling the systemd IPAddressDeny feature until the number of
>> bpf-progs in use by systemd reached 0 (via lsof inspection). I hit the
>> crash in kernels 5.4.43 through 5.7.
>>
>> [40188.268677] BUG: kernel NULL pointer dereference, address: 0000000000000010
>> [40188.268736] #PF: supervisor read access in kernel mode
>> [40188.268773] #PF: error_code(0x0000) - not-present page
>> [40188.268819] PGD 0 P4D 0
>> [40188.268842] Oops: 0000 [#1] SMP PTI
>> [40188.268871] CPU: 7 PID: 2834 Comm: nfsd Tainted: P           OE
>> 5.4.43-1-lts #1
>> [40188.268915] Hardware name: Supermicro Super Server/X10SRi-F, BIOS
>> 3.2 11/22/2019
>> [40188.268970] RIP: 0010:__cgroup_bpf_run_filter_skb+0x155/0x1d0
>> [40188.269013] Code: 48 8b 4c 24 08 4c 01 ab c8 00 00 00 48 89 4b 18
>> 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 31 c0 c3 c3 48 8b 86 38
>> 06 00 00 <48> 8b 78 10 4c 8d 70 10 48 85 ff 74 5f 31 ed 49 8b 46 08 65
>> 48 89
>> [40188.269115] RSP: 0018:ffffb0c581cf3918 EFLAGS: 00010246
>> [40188.269153] RAX: 0000000000000000 RBX: ffff8e32156bfae0 RCX: 0000000000000048
>> [40188.269202] RDX: 0000000000000000 RSI: ffff8e31f9d1e000 RDI: ffff8e31f9bc8940
>> [40188.269250] RBP: ffff8e31f9bc8940 R08: ffff8e3215c74a40 R09: 0000000000000001
>> [40188.269299] R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
>> [40188.269348] R13: 0000000000000000 R14: 000000000000e400 R15: 0000000000000001
>> [40188.269391] FS:  0000000000000000(0000) GS:ffff8e321fbc0000(0000)
>> knlGS:0000000000000000
>> [40188.269446] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [40188.269481] CR2: 0000000000000010 CR3: 0000000271c0a001 CR4: 00000000001606e0
>> [40188.269530] Call Trace:
>> [40188.269559]  ip6_finish_output+0x68/0xa0
>> [40188.269587]  ip6_output+0x6e/0x130
>> [40188.269615]  ? __ip6_finish_output+0x110/0x110
>> [40188.269648]  ip6_xmit+0x2cf/0x5e0
>> [40188.269675]  ? ipv6_anycast_cleanup+0x50/0x50
>> [40188.269711]  inet6_csk_xmit+0xb6/0x100
>> [40188.269742]  __tcp_transmit_skb+0x4ff/0xb10
>> [40188.269776]  tcp_write_xmit+0x517/0x1030
>> [40188.269807]  __tcp_push_pending_frames+0x32/0xf0
>> [40188.269843]  do_tcp_sendpages+0x5fa/0x630
>> [40188.269875]  tcp_sendpage+0x48/0x80
>> [40188.269904]  inet_sendpage+0x52/0x90
>> [40188.269931]  kernel_sendpage+0x1a/0x30
>> [40188.269989]  svc_send_common+0x136/0x150 [sunrpc]
>> [40188.270044]  svc_sendto+0xd7/0x240 [sunrpc]
>> [40188.270096]  svc_tcp_sendto+0x36/0x50 [sunrpc]
>> [40188.271531]  svc_send+0x7b/0x150 [sunrpc]
>> [40188.272961]  nfsd+0xe3/0x140 [nfsd]
>> [40188.274381]  ? nfsd_destroy+0x50/0x50 [nfsd]
>> [40188.275785]  kthread+0x117/0x130
>> [40188.277166]  ? __kthread_bind_mask+0x60/0x60
>> [40188.278520]  ret_from_fork+0x35/0x40
>> [40188.279820] Modules linked in: netconsole veth macvlan xt_nat
>> xt_MASQUERADE nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo
>> iptable_nat rpcsec_gss_krb5 nls_iso8859_1 nls_cp437 vfat fat 8021q
>> garp mrp twofish_generic twofish_avx_x86_64 twofish_x86_64_3way
>> twofish_x86_64 twofish_common intel_rapl_msr intel_rapl_common
>> algif_skcipher af_alg zfs(POE) sb_edac x86_pkg_temp_thermal
>> intel_powerclamp iTCO_wdt zunicode(POE) ipmi_ssif zavl(POE)
>> iTCO_vendor_support icp(POE) coretemp kvm_intel kvm irqbypass
>> zcommon(POE) znvpair(POE) intel_cstate spl(OE) intel_uncore zlua(POE)
>> intel_rapl_perf ast drm_vram_helper pcspkr ttm ixgbe drm_kms_helper
>> i2c_i801 joydev mei_me syscopyarea sysfillrect sysimgblt igb libphy
>> fb_sys_fops mousedev ioatdma i2c_algo_bit mdio input_leds lpc_ich mei
>> dca ipmi_si ipmi_devintf ipmi_msghandler evdev mac_hid
>> acpi_power_meter ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt ipt_REJECT
>> nf_reject_ipv4 xt_multiport br_netfilter bridge stp llc xt_limit
>> xt_addrtype xt_tcpudp xt_physdev
>> [40188.279868]  xt_conntrack ip6table_filter ip6_tables
>> nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat
>> nf_conntrack_ftp nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c
>> iptable_filter nfsd sha256_ssse3 drm sha1_ssse3 auth_rpcgss nfs_acl
>> lockd grace agpgart sunrpc ip_tables x_tables ext4 crc32c_generic
>> crc16 mbcache jbd2 raid1 md_mod hid_generic usbhid hid sd_mod dm_crypt
>> dm_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
>> ahci aesni_intel libahci xhci_pci crypto_simd libata xhci_hcd cryptd
>> glue_helper scsi_mod ehci_pci ehci_hcd wmi
>> [40188.300047] CR2: 0000000000000010
>> [40188.301739] ---[ end trace 44ac77af42fe7195 ]---
>>
>> I also hit an interesting (related?) warning on one of the iterations
>> during boot.
>>
>> [ 8891.070041] ------------[ cut here ]------------
>> [ 8891.070093] percpu ref (cgroup_bpf_release_fn) <= 0 (-1) after
>> switching to atomic
>> [ 8891.070117] WARNING: CPU: 7 PID: 54 at lib/percpu-refcount.c:160
>> percpu_ref_switch_to_atomic_rcu+0x12f/0x140
>> [ 8891.070178] Modules linked in: netconsole veth macvlan xt_nat
>> xt_MASQUERADE nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo
>> iptable_nat nls_iso8859_1 nls_cp437 vfat fat 8021q garp mrp
>> twofish_generic twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64
>> twofish_common algif_skcipher af_alg intel_rapl_msr intel_rapl_common
>> zfs(POE) zunicode(POE) zavl(POE) iTCO_wdt icp(POE) iTCO_vendor_support
>> ipmi_ssif sb_edac x86_pkg_temp_thermal zcommon(POE) intel_powerclamp
>> znvpair(POE) kvm_intel spl(OE) zlua(POE) kvm irqbypass ast
>> intel_cstate intel_uncore drm_vram_helper ttm intel_rapl_perf pcspkr
>> drm_kms_helper i2c_i801 syscopyarea joydev lpc_ich sysfillrect
>> mousedev input_leds ixgbe sysimgblt fb_sys_fops mei_me igb mei libphy
>> ioatdma i2c_algo_bit mdio dca ipmi_si acpi_power_meter ipmi_devintf
>> ipmi_msghandler evdev mac_hid ip6t_REJECT nf_reject_ipv6 xt_hl ip6t_rt
>> ipt_REJECT nf_reject_ipv4 xt_multiport br_netfilter bridge stp llc
>> xt_limit xt_addrtype xt_tcpudp xt_physdev xt_conntrack ip6table_filter
>> [ 8891.070220]  ip6_tables nf_conntrack_netbios_ns
>> nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack
>> nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_filter nfsd
>> sha256_ssse3 drm sha1_ssse3 nfs_acl lockd auth_rpcgss grace sunrpc
>> agpgart ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2
>> raid1 hid_generic usbhid hid md_mod sd_mod dm_crypt dm_mod
>> crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ahci
>> libahci aesni_intel libata crypto_simd cryptd xhci_pci glue_helper
>> ehci_pci xhci_hcd scsi_mod ehci_hcd wmi [last unloaded: coretemp]
>> [ 8891.070664] CPU: 7 PID: 54 Comm: ksoftirqd/7 Tainted: P
>> OE     5.4.43-1-lts #1
>> [ 8891.070691] Hardware name: Supermicro Super Server/X10SRi-F, BIOS
>> 3.2 11/22/2019
>> [ 8891.070721] RIP: 0010:percpu_ref_switch_to_atomic_rcu+0x12f/0x140
>> [ 8891.070745] Code: eb 99 80 3d 33 da eb 00 00 0f 85 4d ff ff ff 48
>> 8b 55 d8 48 8b 75 e8 48 c7 c7 20 1c 50 8a c6 05 17 da eb 00 01 e8 0f
>> 4c c3 ff <0f> 0b e9 2b ff ff ff 0f 0b eb a2 90 90 90 90 90 90 8d 8c 16
>> ef be
>> [ 8891.070812] RSP: 0018:ffffbf72c027fe00 EFLAGS: 00010286
>> [ 8891.070833] RAX: 0000000000000000 RBX: 8000000000000002 RCX: 0000000000000000
>> [ 8891.070857] RDX: 0000000000000046 RSI: ffffffff8acd7b46 RDI: 0000000000000246
>> [ 8891.070885] RBP: ffffa0b458b1f8e8 R08: 000008161d131aa4 R09: 0000000000000046
>> [ 8891.070913] R10: 0000000080000007 R11: ffffffff8acd7b2b R12: 00003ebe60014fc8
>> [ 8891.070938] R13: ffffa0b45fbeb350 R14: ffffa0b45b953c00 R15: ffffa0b45b953c00
>> [ 8891.070968] FS:  0000000000000000(0000) GS:ffffa0b45fbc0000(0000)
>> knlGS:0000000000000000
>> [ 8891.071001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [ 8891.071025] CR2: 00007fae6b351e10 CR3: 000000082b21c005 CR4: 00000000001606e0
>> [ 8891.071058] Call Trace:
>> [ 8891.071075]  rcu_core+0x1ba/0x4e0
>> [ 8891.071093]  __do_softirq+0xe9/0x2dc
>> [ 8891.071110]  run_ksoftirqd+0x26/0x40
>> [ 8891.072222]  smpboot_thread_fn+0xc5/0x160
>> [ 8891.073320]  ? smpboot_unregister_percpu_thread+0x60/0x60
>> [ 8891.074423]  kthread+0x117/0x130
>> [ 8891.075542]  ? __kthread_bind_mask+0x60/0x60
>> [ 8891.076672]  ret_from_fork+0x35/0x40
>> [ 8891.077815] ---[ end trace 727b9af96c86f011 ]---
>
>Thanks for the reporting.
>We've seen very similar stack trace due to out of order cgroup destroy.
>But it was fixed in
>commit e10360f815ca ("bpf: cgroup: prevent out-of-order release of cgroup bpf")
>Sounds like it wasn't fixed completely?

Yes, I also found this patch and confirmed that it has indeed been applied.

>If somebody can reproduce could you please
>revert both the fix e10360f815ca and offending
>commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from
>cgroup itself")
>and see whether it reproduces ?

I will revert these commits on the upstream kernel, once I capture the issue
again I will send it here.

>It will help us narrow down the problem.

-- 
Thanks,
Lu


