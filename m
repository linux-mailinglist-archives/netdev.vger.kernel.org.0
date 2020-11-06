Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07792A9BA7
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgKFSPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:15:17 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16362 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgKFSPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 13:15:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa592b20001>; Fri, 06 Nov 2020 10:15:14 -0800
Received: from reg-r-vrt-018-180.nvidia.com (10.124.1.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Fri, 6 Nov 2020 18:15:15 +0000
References: <1604654056-24654-1-git-send-email-wenxu@ucloud.cn> <1604654056-24654-2-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <wenxu@ucloud.cn>
CC:     <kuba@kernel.org>, <marcelo.leitner@gmail.com>,
        <dcaratti@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 net-next 2/2] net/sched: act_frag: add implict packet fragment support.
In-Reply-To: <1604654056-24654-2-git-send-email-wenxu@ucloud.cn>
Date:   Fri, 6 Nov 2020 20:15:12 +0200
Message-ID: <ygnhlffewdvz.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604686514; bh=E98LBWdrLy+UERHWB/m5d/FB80VMBtYCuGsHTPc3aYI=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=kL2oKCaLTVdD9Lr6MzIQ+AZEFH4ow3EW0lF4KErqEvA/3ulhevEUGtdUcpOzvtzFu
         MQGMYt131PF2UtCyZEks2ZlJWtXz4yV/YBlMnfOu5mCeDwF+MMFQ+sZjgCcsT1F6P3
         GPmHlRVCNtfTJi+mj4t04mYUCBdYef+KZN9JCyl+LAcmQ4Aloaw/YvCuLSwz88UwK8
         RsYiLtNN9cu7fmrKG0RaPSwAotndH5FknCpV6og0EwvPe3t4GgjgktxC5mhOVh7juu
         Vn56yuGFdtQMn56eoinS9hlEuKZyLuFCp/lHIRAvvF9xOVR9AFjEscKJAxSShUJi4I
         BNCxQCtx7U4SQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 06 Nov 2020 at 11:14, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Currently kernel tc subsystem can do conntrack in act_ct. But when several
> fragment packets go through the act_ct, function tcf_ct_handle_fragments
> will defrag the packets to a big one. But the last action will redirect
> mirred to a device which maybe lead the reassembly big packet over the mtu
> of target device.
>
> This patch add support for a xmit hook to mirred, that gets executed before
> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> The frag xmit hook maybe reused by other modules.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v2: Fix the crash for act_frag module without load
> v3: modify the kconfig describe and put tcf_xmit_hook_is_enabled
> in the tcf_dev_queue_xmit, and xchg atomic for tcf_xmit_hook
> v4: using skb_protocol and fix line length exceeds 80 columns
>

Hi wenxu,

With you patches applied I get following warnings when running some of
our CT tests:

[  550.183105] #############################
[  550.184266] ## TEST test-ct-nat-tcp.sh ##
[  550.185448] #############################
[  551.195494] :test: Fedora 32 (Thirty Two)
[  551.198730] :test: Linux c-237-12-1-009 5.10.0-rc1+
[  551.240834] :test: NIC enp0s8f0 FW 16.28.2006 PCI 0000:00:08.0 DEVICE 0x1017 ConnectX-5
[  551.273669] :test: Flow steering mode for enp0s8f0 is dmfs
[  551.275449] :test: Flow steering mode for enp0s8f1 is dmfs
[  551.394256] mlx5_core 0000:00:08.2 enp0s8f0v0: Link up
[  551.499484] mlx5_core 0000:00:08.3 enp0s8f0v1: Link up
[  551.507950] :test: unbind vfs of enp0s8f0
[  552.150367] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s8f0v1: link becomes ready
[  554.016485] :test: Change enp0s8f0 eswitch (0000:00:08.0) mode to switchdev
[  554.061589] :test: unbind vfs of enp0s8f0
[  554.080874] :test: bind vfs of enp0s8f0
[  554.091882] mlx5_core 0000:00:08.2: firmware version: 16.28.2006
[  554.358663] mlx5_core 0000:00:08.2: Rate limit: 127 rates are supported, range: 0Mbps to 97656Mbps
[  554.379635] mlx5_core 0000:00:08.2: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  554.491159] mlx5_core 0000:00:08.2: Supported tc offload range - chains: 1, prios: 1
[  554.529531] mlx5_core 0000:00:08.3: firmware version: 16.28.2006
[  554.547950] mlx5_core 0000:00:08.2 enp0s8f0v0: renamed from eth2
[  554.804482] mlx5_core 0000:00:08.3: Rate limit: 127 rates are supported, range: 0Mbps to 97656Mbps
[  554.829599] mlx5_core 0000:00:08.3: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  554.937838] mlx5_core 0000:00:08.3: Supported tc offload range - chains: 1, prios: 1
[  554.987058] mlx5_core 0000:00:08.3 enp0s8f0v1: renamed from eth2
[  556.075683] :test: Test CT nat tcp
[  556.269658] mlx5_core 0000:00:08.2 enp0s8f0v0: Link up
[  556.273890] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s8f0v0: link becomes ready
[  556.397755] mlx5_core 0000:00:08.3 enp0s8f0v1: Link up
[  557.333042] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s8f0v1: link becomes ready
[  558.471852] skb len=7292 headroom=78 headlen=1500 tailroom=0
               mac=(64,14) net=(78,20) trans=98
               shinfo(txflags=0 nr_frags=4 gso(size=1448 type=1 segs=5))
               csum(0x100062 ip_summed=3 complete_sw=0 valid=0 level=0)
               hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=3 iif=14
[  558.486166] dev name=enp0s8f0_1 feat=0x0x0002010000116c13
[  558.487124] skb linear:   00000000: 45 00 1c 7c 94 ca 40 00 40 06 6d a1 07 07 07 01
[  558.488470] skb linear:   00000010: 07 07 07 02 b9 42 13 89 7a 20 ea 81 fd 01 29 3e
[  558.489824] skb linear:   00000020: 80 18 01 f6 38 7f 00 00 01 01 08 0a 44 e2 8a ea
[  558.491180] skb linear:   00000030: 78 8a d7 32 08 00 00 00 34 35 36 37 38 39 30 31
[  558.492537] skb linear:   00000040: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
[  558.493888] skb linear:   00000050: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
[  558.495241] skb linear:   00000060: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
[  558.496584] skb linear:   00000070: 30 31 32 33 34 35 36 37 38 39 30 31 32 33 34 35
[  558.498042] skb linear:   00000080: 36 37 38 39 30 31 32 33 34 35 36 37 38 39 30 31
[  558.499471] skb linear:   00000090: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
[  558.500915] skb linear:   000000a0: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
[  558.502355] skb linear:   000000b0: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
[  558.503772] skb linear:   000000c0: 30 31 32 33 34 35 36 37 38 39 30 31 32 33 34 35
[  558.505188] skb linear:   000000d0: 36 37 38 39 30 31 32 33 34 35 36 37 38 39 30 31
[  558.506609] skb linear:   000000e0: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
[  558.508035] skb linear:   000000f0: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
[  558.509464] skb linear:   00000100: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
[  558.510925] ------------[ cut here ]------------
[  558.511817] mlx5_core: caps=(0x0002010000116c13, 0x0000000000000000)
[  558.513008] WARNING: CPU: 0 PID: 0 at net/core/dev.c:3192 skb_warn_bad_offload+0x72/0xe0
[  558.514525] Modules linked in: act_mirred act_ct act_frag nf_flow_table cls_flower act_gact sch_ingress openvswitch nsh nf_conncount mlx5_ib mlx5_core mlxfw pci_hyperv_intf ptp pps_core nfsv3 nfs_acl rpcrdma rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser ib_umad rdma_cm ib_ipoib iw_cm ib_cm xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_filter iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g
race nfs_ssc fscache ib_uverbs ib_core rfkill overlay iTCO_wdt iTCO_vendor_support kvm_intel kvm irqbypass virtio_net i2c_i801 crc32_pclmul net_failover ghash_clmulni_intel pcspkr lpc_ich i2c_smbus failover mfd_core sunrpc sch_fq_codel drm i2c_core ip_tables crc32c_intel serio_raw [last unloaded: mlxfw]
[  558.527278] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-rc1+ #12
[  558.528431] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  558.530434] RIP: 0010:skb_warn_bad_offload+0x72/0xe0
[  558.531377] Code: 8d 95 c8 00 00 00 48 8d 88 e8 01 00 00 48 85 c0 48 c7 c0 18 3f 12 82 48 0f 44 c8 4c 89 e6 48 c7 c7 7f 0e 31 82 e8 b4 65 1a 00 <0f> 0b 5b 5d 41 5c c3 80 7d 00 00 49 c7 c4 b3 81 28 82 74 ac be 25
[  558.534683] RSP: 0018:ffffc90000003768 EFLAGS: 00010286
[  558.535672] RAX: 0000000000000000 RBX: ffff888104b4a900 RCX: 000000000000083f
[  558.536970] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 000000000000083f
[  558.538268] RBP: ffff888132900000 R08: ffffffff82621c28 R09: 0000000000013ffb
[  558.539569] R10: 00000000ffffc000 R11: 3fffffffffffffff R12: ffffffffa0a03723
[  558.540855] R13: ffffc90000003829 R14: 0000000000000000 R15: ffffc90000003828
[  558.542162] FS:  0000000000000000(0000) GS:ffff8882f5800000(0000) knlGS:0000000000000000
[  558.543670] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  558.544742] CR2: 00007f3985fad780 CR3: 000000016c9cc006 CR4: 0000000000770ef0
[  558.546040] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  558.547335] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  558.548621] PKRU: 55555554
[  558.549212] Call Trace:
[  558.549790]  <IRQ>
[  558.550260]  skb_checksum_help+0x10a/0x120
[  558.551078]  ip_do_fragment+0x300/0x500
[  558.551844]  ? tcf_frag_dst_get_mtu+0x10/0x10 [act_frag]
[  558.552848]  ? fl_mask_lookup+0x164/0x4b0 [cls_flower]
[  558.553820]  tcf_fragment+0x1a8/0x410 [act_frag]
[  558.554722]  ? dst_discard_out+0x10/0x10
[  558.555501]  ? dst_dev_put+0x60/0x60
[  558.556227]  tcf_mirred_act+0x41f/0x457 [act_mirred]
[  558.557180]  tcf_action_exec+0x75/0x120
[  558.557951]  fl_classify+0x1c6/0x1d0 [cls_flower]
[  558.558856]  __tcf_classify+0x52/0x100
[  558.559601]  tcf_classify_ingress+0x65/0x140
[  558.560433]  __netif_receive_skb_core+0x742/0xf10
[  558.561349]  ? inet_gro_complete+0xa0/0xd0
[  558.564649]  __netif_receive_skb_list_core+0xfa/0x200
[  558.565609]  netif_receive_skb_list_internal+0x19f/0x2c0
[  558.566633]  ? mlx5e_handle_rx_cqe_mpwrq_rep+0x158/0x200 [mlx5_core]
[  558.567798]  napi_complete_done+0x6f/0x180
[  558.568633]  mlx5e_napi_poll+0x13b/0x600 [mlx5_core]
[  558.569591]  ? mlx5e_completion_event+0x3c/0x40 [mlx5_core]
[  558.570643]  net_rx_action+0x130/0x3a0
[  558.571406]  ? atomic_notifier_call_chain+0x54/0x70
[  558.572340]  __do_softirq+0xc5/0x283
[  558.573081]  asm_call_irq_on_stack+0xf/0x20
[  558.573878]  </IRQ>
[  558.574353]  do_softirq_own_stack+0x37/0x40
[  558.575157]  irq_exit_rcu+0x9c/0xd0
[  558.575851]  common_interrupt+0x74/0x130
[  558.576607]  asm_common_interrupt+0x1e/0x40
[  558.577418] RIP: 0010:native_safe_halt+0xe/0x10
[  558.578277] Code: 02 20 48 8b 00 a8 08 75 c4 e9 7b ff ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d cc 01 55 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d bc 01 55 00 f4 c3 cc cc 0f 1f 44 00
[  558.581470] RSP: 0018:ffffffff82403eb8 EFLAGS: 00000202
[  558.583946] RAX: ffff8882f582c900 RBX: 0000000000000000 RCX: ffff8882f582c900
[  558.585147] RDX: 00000000000ca6ea RSI: 7fffff7dff2b52f5 RDI: 0000000000000086
[  558.586360] RBP: ffffffff82413940 R08: 000000cd42e4dffb R09: 00000082704a9c8a
[  558.587556] R10: 00000000000302ee R11: 0000000000000000 R12: 0000000000000000
[  558.588756] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  558.590118]  default_idle+0xa/0x10
[  558.590769]  default_idle_call+0x38/0xb0
[  558.591494]  do_idle+0x1f7/0x270
[  558.592126]  cpu_startup_entry+0x19/0x20
[  558.592857]  start_kernel+0x511/0x533
[  558.603117]  secondary_startup_64_no_verify+0xa6/0xab
[  558.604021] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-rc1+ #12
[  558.605119] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  558.606961] Call Trace:
[  558.607462]  <IRQ>
[  558.607903]  dump_stack+0x6b/0x83
[  558.608529]  __warn.cold+0x24/0x75
[  558.609177]  ? skb_warn_bad_offload+0x72/0xe0
[  558.609959]  report_bug+0x9a/0xc0
[  558.610581]  handle_bug+0x35/0x80
[  558.611212]  exc_invalid_op+0x14/0x70
[  558.611893]  asm_exc_invalid_op+0x12/0x20
[  558.612618] RIP: 0010:skb_warn_bad_offload+0x72/0xe0
[  558.613486] Code: 8d 95 c8 00 00 00 48 8d 88 e8 01 00 00 48 85 c0 48 c7 c0 18 3f 12 82 48 0f 44 c8 4c 89 e6 48 c7 c7 7f 0e 31 82 e8 b4 65 1a 00 <0f> 0b 5b 5d 41 5c c3 80 7d 00 00 49 c7 c4 b3 81 28 82 74 ac be 25
[  558.616519] RSP: 0018:ffffc90000003768 EFLAGS: 00010286
[  558.617431] RAX: 0000000000000000 RBX: ffff888104b4a900 RCX: 000000000000083f
[  558.618619] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 000000000000083f
[  558.619857] RBP: ffff888132900000 R08: ffffffff82621c28 R09: 0000000000013ffb
[  558.621100] R10: 00000000ffffc000 R11: 3fffffffffffffff R12: ffffffffa0a03723
[  558.622361] R13: ffffc90000003829 R14: 0000000000000000 R15: ffffc90000003828
[  558.623617]  ? skb_warn_bad_offload+0x72/0xe0
[  558.624439]  skb_checksum_help+0x10a/0x120
[  558.625222]  ip_do_fragment+0x300/0x500
[  558.625958]  ? tcf_frag_dst_get_mtu+0x10/0x10 [act_frag]
[  558.626928]  ? fl_mask_lookup+0x164/0x4b0 [cls_flower]
[  558.627866]  tcf_fragment+0x1a8/0x410 [act_frag]
[  558.628725]  ? dst_discard_out+0x10/0x10
[  558.629486]  ? dst_dev_put+0x60/0x60
[  558.630191]  tcf_mirred_act+0x41f/0x457 [act_mirred]
[  558.631128]  tcf_action_exec+0x75/0x120
[  558.631884]  fl_classify+0x1c6/0x1d0 [cls_flower]
[  558.632772]  __tcf_classify+0x52/0x100
[  558.633516]  tcf_classify_ingress+0x65/0x140
[  558.634344]  __netif_receive_skb_core+0x742/0xf10
[  558.635235]  ? inet_gro_complete+0xa0/0xd0
[  558.636019]  __netif_receive_skb_list_core+0xfa/0x200
[  558.636965]  netif_receive_skb_list_internal+0x19f/0x2c0
[  558.637969]  ? mlx5e_handle_rx_cqe_mpwrq_rep+0x158/0x200 [mlx5_core]
[  558.639129]  napi_complete_done+0x6f/0x180
[  558.639934]  mlx5e_napi_poll+0x13b/0x600 [mlx5_core]
[  558.640877]  ? mlx5e_completion_event+0x3c/0x40 [mlx5_core]
[  558.641900]  net_rx_action+0x130/0x3a0
[  558.642630]  ? atomic_notifier_call_chain+0x54/0x70
[  558.643543]  __do_softirq+0xc5/0x283
[  558.644261]  asm_call_irq_on_stack+0xf/0x20
[  558.645061]  </IRQ>
[  558.645541]  do_softirq_own_stack+0x37/0x40
[  558.646357]  irq_exit_rcu+0x9c/0xd0
[  558.647053]  common_interrupt+0x74/0x130
[  558.647816]  asm_common_interrupt+0x1e/0x40
[  558.648627] RIP: 0010:native_safe_halt+0xe/0x10
[  558.649498] Code: 02 20 48 8b 00 a8 08 75 c4 e9 7b ff ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d cc 01 55 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d bc 01 55 00 f4 c3 cc cc 0f 1f 44 00
[  558.652723] RSP: 0018:ffffffff82403eb8 EFLAGS: 00000202
[  558.653764] RAX: ffff8882f582c900 RBX: 0000000000000000 RCX: ffff8882f582c900
[  558.655116] RDX: 00000000000ca6ea RSI: 7fffff7dff2b52f5 RDI: 0000000000000086
[  558.656387] RBP: ffffffff82413940 R08: 000000cd42e4dffb R09: 00000082704a9c8a
[  558.657670] R10: 00000000000302ee R11: 0000000000000000 R12: 0000000000000000
[  558.658939] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  558.660205]  default_idle+0xa/0x10
[  558.660878]  default_idle_call+0x38/0xb0
[  558.661643]  do_idle+0x1f7/0x270
[  558.662298]  cpu_startup_entry+0x19/0x20
[  558.663066]  start_kernel+0x511/0x533
[  558.663787]  secondary_startup_64_no_verify+0xa6/0xab
[  558.664746] ---[ end trace 1643bf725be8b62e ]---
[  558.665713] skb len=7292 headroom=78 headlen=1500 tailroom=0
               mac=(64,14) net=(78,20) trans=98
               shinfo(txflags=0 nr_frags=4 gso(size=1448 type=1 segs=5))
               csum(0x100062 ip_summed=3 complete_sw=0 valid=0 level=0)
               hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=3 iif=14
[  558.670604] dev name=enp0s8f0_1 feat=0x0x0002010000116c13
[  558.671613] skb linear:   00000000: 45 00 1c 7c 94 cf 40 00 40 06 6d 9c 07 07 07 01
[  558.673039] skb linear:   00000010: 07 07 07 02 b9 42 13 89 7a 21 06 c9 fd 01 29 3e
[  558.674473] skb linear:   00000020: 80 18 01 f6 38 7f 00 00 01 01 08 0a 44 e2 8a ea
[  558.675894] skb linear:   00000030: 78 8a d7 32 30 31 32 33 34 35 36 37 38 39 30 31
[  558.677323] skb linear:   00000040: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
[  558.678755] skb linear:   00000050: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
[  558.681051] skb linear:   00000060: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
[  558.682487] skb linear:   00000070: 30 31 32 33 34 35 36 37 38 39 30 31 32 33 34 35
[  558.683940] skb linear:   00000080: 36 37 38 39 30 31 32 33 34 35 36 37 38 39 30 31
[  558.685390] skb linear:   00000090: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
[  558.686844] skb linear:   000000a0: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
[  558.688298] skb linear:   000000b0: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
[  558.689751] skb linear:   000000c0: 30 31 32 33 34 35 36 37 38 39 30 31 32 33 34 35
[  558.691204] skb linear:   000000d0: 36 37 38 39 30 31 32 33 34 35 36 37 38 39 30 31
[  558.692657] skb linear:   000000e0: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
[  558.694101] skb linear:   000000f0: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
[  558.695523] skb linear:   00000100: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
[  558.696959] ------------[ cut here ]------------
[  558.697849] mlx5_core: caps=(0x0002010000116c13, 0x0000000000000000)
[  558.699029] WARNING: CPU: 0 PID: 9 at net/core/dev.c:3192 skb_warn_bad_offload+0x72/0xe0
[  558.700529] Modules linked in: act_mirred act_ct act_frag nf_flow_table cls_flower act_gact sch_ingress openvswitch nsh nf_conncount mlx5_ib mlx5_core mlxfw pci_hyperv_intf ptp pps_core nfsv3 nfs_acl rpcrdma rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser ib_umad rdma_cm ib_ipoib iw_cm ib_cm xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_filter iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g
race nfs_ssc fscache ib_uverbs ib_core rfkill overlay iTCO_wdt iTCO_vendor_support kvm_intel kvm irqbypass virtio_net i2c_i801 crc32_pclmul net_failover ghash_clmulni_intel pcspkr lpc_ich i2c_smbus failover mfd_core sunrpc sch_fq_codel drm i2c_core ip_tables crc32c_intel serio_raw [last unloaded: mlxfw]
[  558.713098] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G        W         5.10.0-rc1+ #12
[  558.714596] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  558.716595] RIP: 0010:skb_warn_bad_offload+0x72/0xe0
[  558.717532] Code: 8d 95 c8 00 00 00 48 8d 88 e8 01 00 00 48 85 c0 48 c7 c0 18 3f 12 82 48 0f 44 c8 4c 89 e6 48 c7 c7 7f 0e 31 82 e8 b4 65 1a 00 <0f> 0b 5b 5d 41 5c c3 80 7d 00 00 49 c7 c4 b3 81 28 82 74 ac be 25
[  558.720777] RSP: 0018:ffffc90000057658 EFLAGS: 00010282
[  558.721758] RAX: 0000000000000000 RBX: ffff888104b4b700 RCX: 0000000000000000
[  558.723049] RDX: ffff8882f5828ba0 RSI: ffff8882f5818b00 RDI: ffff8882f5818b00
[  558.724334] RBP: ffff888132900000 R08: ffffffff82621c28 R09: 0000000000013ffb
[  558.725663] R10: 00000000ffffc000 R11: 3fffffffffffffff R12: ffffffffa0a03723
[  558.726966] R13: ffffc90000057719 R14: 0000000000000000 R15: ffffc90000057718
[  558.728245] FS:  0000000000000000(0000) GS:ffff8882f5800000(0000) knlGS:0000000000000000
[  558.729740] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  558.730804] CR2: 00007f3985fad780 CR3: 000000016c9cc006 CR4: 0000000000770ef0
[  558.732088] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  558.733373] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  558.734662] PKRU: 55555554
[  558.735242] Call Trace:
[  558.735776]  skb_checksum_help+0x10a/0x120
[  558.736580]  ip_do_fragment+0x300/0x500
[  558.737342]  ? tcf_frag_dst_get_mtu+0x10/0x10 [act_frag]
[  558.738344]  ? fl_mask_lookup+0x164/0x4b0 [cls_flower]
[  558.739308]  tcf_fragment+0x1a8/0x410 [act_frag]
[  558.740197]  ? dst_discard_out+0x10/0x10
[  558.740981]  ? dst_dev_put+0x60/0x60
[  558.741693]  tcf_mirred_act+0x41f/0x457 [act_mirred]
[  558.742637]  tcf_action_exec+0x75/0x120
[  558.743402]  fl_classify+0x1c6/0x1d0 [cls_flower]
[  558.744308]  __tcf_classify+0x52/0x100
[  558.745054]  tcf_classify_ingress+0x65/0x140
[  558.745882]  __netif_receive_skb_core+0x742/0xf10
[  558.746776]  ? inet_gro_receive+0x225/0x2c0
[  558.747589]  __netif_receive_skb_list_core+0xfa/0x200
[  558.748542]  netif_receive_skb_list_internal+0x19f/0x2c0
[  558.749533]  ? napi_gro_flush+0x9c/0xf0
[  558.750299]  napi_complete_done+0x6f/0x180
[  558.751118]  mlx5e_napi_poll+0x13b/0x600 [mlx5_core]
[  558.752059]  net_rx_action+0x130/0x3a0
[  558.752806]  __do_softirq+0xc5/0x283
[  558.753524]  run_ksoftirqd+0x26/0x40
[  558.754249]  smpboot_thread_fn+0xb8/0x150
[  558.755035]  ? smpboot_register_percpu_thread+0xe0/0xe0
[  558.756019]  kthread+0x118/0x130
[  558.756673]  ? kthread_create_worker_on_cpu+0x70/0x70
[  558.757627]  ret_from_fork+0x1f/0x30
[  558.758346] CPU: 0 PID: 9 Comm: ksoftirqd/0 Tainted: G        W         5.10.0-rc1+ #12
[  558.759819] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  558.761788] Call Trace:
[  558.762318]  dump_stack+0x6b/0x83
[  558.772522]  __warn.cold+0x24/0x75
[  558.773164]  ? skb_warn_bad_offload+0x72/0xe0
[  558.773955]  report_bug+0x9a/0xc0
[  558.774581]  handle_bug+0x35/0x80
[  558.775224]  exc_invalid_op+0x14/0x70
[  558.775913]  asm_exc_invalid_op+0x12/0x20
[  558.776641] RIP: 0010:skb_warn_bad_offload+0x72/0xe0
[  558.777512] Code: 8d 95 c8 00 00 00 48 8d 88 e8 01 00 00 48 85 c0 48 c7 c0 18 3f 12 82 48 0f 44 c8 4c 89 e6 48 c7 c7 7f 0e 31 82 e8 b4 65 1a 00 <0f> 0b 5b 5d 41 5c c3 80 7d 00 00 49 c7 c4 b3 81 28 82 74 ac be 25
[  558.780535] RSP: 0018:ffffc90000057658 EFLAGS: 00010282
[  558.781447] RAX: 0000000000000000 RBX: ffff888104b4b700 RCX: 0000000000000000
[  558.782633] RDX: ffff8882f5828ba0 RSI: ffff8882f5818b00 RDI: ffff8882f5818b00
[  558.783816] RBP: ffff888132900000 R08: ffffffff82621c28 R09: 0000000000013ffb
[  558.785102] R10: 00000000ffffc000 R11: 3fffffffffffffff R12: ffffffffa0a03723
[  558.786382] R13: ffffc90000057719 R14: 0000000000000000 R15: ffffc90000057718
[  558.787665]  ? skb_warn_bad_offload+0x72/0xe0
[  558.788500]  skb_checksum_help+0x10a/0x120
[  558.789296]  ip_do_fragment+0x300/0x500
[  558.790050]  ? tcf_frag_dst_get_mtu+0x10/0x10 [act_frag]
[  558.791029]  ? fl_mask_lookup+0x164/0x4b0 [cls_flower]
[  558.791989]  tcf_fragment+0x1a8/0x410 [act_frag]
[  558.792946]  ? dst_discard_out+0x10/0x10
[  558.793718]  ? dst_dev_put+0x60/0x60
[  558.794431]  tcf_mirred_act+0x41f/0x457 [act_mirred]
[  558.795360]  tcf_action_exec+0x75/0x120
[  558.796111]  fl_classify+0x1c6/0x1d0 [cls_flower]
[  558.797001]  __tcf_classify+0x52/0x100
[  558.797736]  tcf_classify_ingress+0x65/0x140
[  558.798546]  __netif_receive_skb_core+0x742/0xf10
[  558.799429]  ? inet_gro_receive+0x225/0x2c0
[  558.800236]  __netif_receive_skb_list_core+0xfa/0x200
[  558.801169]  netif_receive_skb_list_internal+0x19f/0x2c0
[  558.802149]  ? napi_gro_flush+0x9c/0xf0
[  558.802900]  napi_complete_done+0x6f/0x180
[  558.803701]  mlx5e_napi_poll+0x13b/0x600 [mlx5_core]
[  558.804634]  net_rx_action+0x130/0x3a0
[  558.805370]  __do_softirq+0xc5/0x283
[  558.806087]  run_ksoftirqd+0x26/0x40
[  558.806799]  smpboot_thread_fn+0xb8/0x150
[  558.807574]  ? smpboot_register_percpu_thread+0xe0/0xe0
[  558.808540]  kthread+0x118/0x130
[  558.809192]  ? kthread_create_worker_on_cpu+0x70/0x70
[  558.810141]  ret_from_fork+0x1f/0x30
[  558.810858] ---[ end trace 1643bf725be8b62f ]---
[  558.812075] skb len=2948 headroom=78 headlen=1500 tailroom=0
               mac=(64,14) net=(78,20) trans=98
               shinfo(txflags=0 nr_frags=1 gso(size=1448 type=1 segs=2))
               csum(0x100062 ip_summed=3 complete_sw=0 valid=0 level=0)
               hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=3 iif=14
[  558.816979] dev name=enp0s8f0_1 feat=0x0x0002010000116c13
[  558.817993] skb linear:   00000000: 45 00 0b 84 94 d7 40 00 40 06 7e 8c 07 07 07 01
[  558.819425] skb linear:   00000010: 07 07 07 02 b9 42 13 89 7a 20 f5 d1 fd 01 29 3e
[  558.820852] skb linear:   00000020: 80 18 01 f6 27 87 00 00 01 01 08 0a 44 e2 8c 3e
[  558.822292] skb linear:   00000030: 78 8a d8 86 36 37 38 39 30 31 32 33 34 35 36 37
[  558.823720] skb linear:   00000040: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
[  558.825158] skb linear:   00000050: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
[  558.829260] skb linear:   00000060: 30 31 32 33 34 35 36 37 38 39 30 31 32 33 34 35
[  558.833164] skb linear:   00000070: 36 37 38 39 30 31 32 33 34 35 36 37 38 39 30 31
[  558.837120] skb linear:   00000080: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
[  558.841051] skb linear:   00000090: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
[  558.842835] skb linear:   000000a0: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
[  558.844263] skb linear:   000000b0: 30 31 32 33 34 35 36 37 38 39 30 31 32 33 34 35
[  558.845689] skb linear:   000000c0: 36 37 38 39 30 31 32 33 34 35 36 37 38 39 30 31
[  558.847101] skb linear:   000000d0: 32 33 34 35 36 37 38 39 30 31 32 33 34 35 36 37
[  558.848533] skb linear:   000000e0: 38 39 30 31 32 33 34 35 36 37 38 39 30 31 32 33
[  558.849964] skb linear:   000000f0: 34 35 36 37 38 39 30 31 32 33 34 35 36 37 38 39
[  558.851381] skb linear:   00000100: 30 31 32 33 34 35 36 37 38 39 30 31 32 33 34 35
[  558.852809] ------------[ cut here ]------------
[  558.853686] mlx5_core: caps=(0x0002010000116c13, 0x0000000000000000)
[  558.854865] WARNING: CPU: 0 PID: 0 at net/core/dev.c:3192 skb_warn_bad_offload+0x72/0xe0
[  558.856371] Modules linked in: act_mirred act_ct act_frag nf_flow_table cls_flower act_gact sch_ingress openvswitch nsh nf_conncount mlx5_ib mlx5_core mlxfw pci_hyperv_intf ptp pps_core nfsv3 nfs_acl rpcrdma rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser ib_umad rdma_cm ib_ipoib iw_cm ib_cm xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_filter iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 br_netfilter bridge stp llc rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd g
race nfs_ssc fscache ib_uverbs ib_core rfkill overlay iTCO_wdt iTCO_vendor_support kvm_intel kvm irqbypass virtio_net i2c_i801 crc32_pclmul net_failover ghash_clmulni_intel pcspkr lpc_ich i2c_smbus failover mfd_core sunrpc sch_fq_codel drm i2c_core ip_tables crc32c_intel serio_raw [last unloaded: mlxfw]
[  558.868905] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.10.0-rc1+ #12
[  558.870347] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  558.872329] RIP: 0010:skb_warn_bad_offload+0x72/0xe0
[  558.873268] Code: 8d 95 c8 00 00 00 48 8d 88 e8 01 00 00 48 85 c0 48 c7 c0 18 3f 12 82 48 0f 44 c8 4c 89 e6 48 c7 c7 7f 0e 31 82 e8 b4 65 1a 00 <0f> 0b 5b 5d 41 5c c3 80 7d 00 00 49 c7 c4 b3 81 28 82 74 ac be 25
[  558.876571] RSP: 0018:ffffc90000003768 EFLAGS: 00010286
[  558.877569] RAX: 0000000000000000 RBX: ffff888104b4b700 RCX: 000000000000083f
[  558.878873] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 000000000000083f
[  558.880178] RBP: ffff888132900000 R08: ffffffff82621c28 R09: 0000000000013ffb
[  558.881481] R10: 00000000ffffc000 R11: 3fffffffffffffff R12: ffffffffa0a03723
[  558.882796] R13: ffffc90000003829 R14: 0000000000000000 R15: ffffc90000003828
[  558.884104] FS:  0000000000000000(0000) GS:ffff8882f5800000(0000) knlGS:0000000000000000
[  558.885632] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  558.886687] CR2: 00007f3985fad780 CR3: 000000016c9cc006 CR4: 0000000000770ef0
[  558.887961] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  558.889245] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  558.890531] PKRU: 55555554
[  558.891111] Call Trace:
[  558.891645]  <IRQ>
[  558.892118]  skb_checksum_help+0x10a/0x120
[  558.892925]  ip_do_fragment+0x300/0x500
[  558.893684]  ? tcf_frag_dst_get_mtu+0x10/0x10 [act_frag]
[  558.894676]  ? fl_mask_lookup+0x164/0x4b0 [cls_flower]
[  558.895650]  tcf_fragment+0x1a8/0x410 [act_frag]
[  558.896537]  ? dst_discard_out+0x10/0x10
[  558.897309]  ? dst_dev_put+0x60/0x60
[  558.898036]  tcf_mirred_act+0x41f/0x457 [act_mirred]
[  558.898973]  tcf_action_exec+0x75/0x120
[  558.899736]  fl_classify+0x1c6/0x1d0 [cls_flower]
[  558.901587]  __tcf_classify+0x52/0x100
[  558.902331]  tcf_classify_ingress+0x65/0x140
[  558.903156]  __netif_receive_skb_core+0x742/0xf10
[  558.904050]  ? inet_gro_complete+0xa0/0xd0
[  558.904843]  __netif_receive_skb_list_core+0xfa/0x200
[  558.905799]  netif_receive_skb_list_internal+0x19f/0x2c0
[  558.906798]  ? mlx5e_handle_rx_cqe_mpwrq_rep+0x158/0x200 [mlx5_core]
[  558.907951]  napi_complete_done+0x6f/0x180
[  558.908759]  mlx5e_napi_poll+0x13b/0x600 [mlx5_core]
[  558.909713]  ? mlx5e_completion_event+0x3c/0x40 [mlx5_core]
[  558.910753]  net_rx_action+0x130/0x3a0
[  558.911502]  ? atomic_notifier_call_chain+0x54/0x70
[  558.912437]  __do_softirq+0xc5/0x283
[  558.913161]  asm_call_irq_on_stack+0xf/0x20
[  558.913988]  </IRQ>
[  558.914472]  do_softirq_own_stack+0x37/0x40
[  558.915296]  irq_exit_rcu+0x9c/0xd0
[  558.916005]  common_interrupt+0x74/0x130
[  558.916781]  asm_common_interrupt+0x1e/0x40
[  558.917605] RIP: 0010:native_safe_halt+0xe/0x10
[  558.918476] Code: 02 20 48 8b 00 a8 08 75 c4 e9 7b ff ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d cc 01 55 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d bc 01 55 00 f4 c3 cc cc 0f 1f 44 00
[  558.921722] RSP: 0018:ffffffff82403eb8 EFLAGS: 00000202
[  558.922708] RAX: ffff8882f582c900 RBX: 0000000000000000 RCX: ffff8882f582c900
[  558.923989] RDX: 00000000000ca72a RSI: 7fffff7dead813b5 RDI: 0000000000000086
[  558.925272] RBP: ffffffff82413940 R08: 000000cd42e4dffb R09: 00000082704a9c8a
[  558.926561] R10: 00000000000302ee R11: 0000000000000000 R12: 0000000000000000
[  558.927836] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  558.929107]  default_idle+0xa/0x10
[  558.929812]  default_idle_call+0x38/0xb0
[  558.930581]  do_idle+0x1f7/0x270
[  558.931244]  cpu_startup_entry+0x19/0x20
[  558.932011]  start_kernel+0x511/0x533
[  558.932742]  secondary_startup_64_no_verify+0xa6/0xab
[  558.933708] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.10.0-rc1+ #12
[  558.935150] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  558.937107] Call Trace:
[  558.937642]  <IRQ>
[  558.938100]  dump_stack+0x6b/0x83
[  558.938764]  __warn.cold+0x24/0x75
[  558.939513]  ? skb_warn_bad_offload+0x72/0xe0
[  558.940342]  report_bug+0x9a/0xc0
[  558.940996]  handle_bug+0x35/0x80
[  558.941680]  exc_invalid_op+0x14/0x70
[  558.951946]  asm_exc_invalid_op+0x12/0x20
[  558.952699] RIP: 0010:skb_warn_bad_offload+0x72/0xe0
[  558.953571] Code: 8d 95 c8 00 00 00 48 8d 88 e8 01 00 00 48 85 c0 48 c7 c0 18 3f 12 82 48 0f 44 c8 4c 89 e6 48 c7 c7 7f 0e 31 82 e8 b4 65 1a 00 <0f> 0b 5b 5d 41 5c c3 80 7d 00 00 49 c7 c4 b3 81 28 82 74 ac be 25
[  558.956566] RSP: 0018:ffffc90000003768 EFLAGS: 00010286
[  558.957474] RAX: 0000000000000000 RBX: ffff888104b4b700 RCX: 000000000000083f
[  558.958653] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 000000000000083f
[  558.959836] RBP: ffff888132900000 R08: ffffffff82621c28 R09: 0000000000013ffb
[  558.961013] R10: 00000000ffffc000 R11: 3fffffffffffffff R12: ffffffffa0a03723
[  558.962194] R13: ffffc90000003829 R14: 0000000000000000 R15: ffffc90000003828
[  558.963375]  ? skb_warn_bad_offload+0x72/0xe0
[  558.964214]  skb_checksum_help+0x10a/0x120
[  558.965001]  ip_do_fragment+0x300/0x500
[  558.965747]  ? tcf_frag_dst_get_mtu+0x10/0x10 [act_frag]
[  558.966728]  ? fl_mask_lookup+0x164/0x4b0 [cls_flower]
[  558.967662]  tcf_fragment+0x1a8/0x410 [act_frag]
[  558.968524]  ? dst_discard_out+0x10/0x10
[  558.969279]  ? dst_dev_put+0x60/0x60
[  558.969986]  tcf_mirred_act+0x41f/0x457 [act_mirred]
[  558.970903]  tcf_action_exec+0x75/0x120
[  558.971646]  fl_classify+0x1c6/0x1d0 [cls_flower]
[  558.972534]  __tcf_classify+0x52/0x100
[  558.973269]  tcf_classify_ingress+0x65/0x140
[  558.974081]  __netif_receive_skb_core+0x742/0xf10
[  558.974958]  ? inet_gro_complete+0xa0/0xd0
[  558.975738]  __netif_receive_skb_list_core+0xfa/0x200
[  558.976680]  netif_receive_skb_list_internal+0x19f/0x2c0
[  558.977668]  ? mlx5e_handle_rx_cqe_mpwrq_rep+0x158/0x200 [mlx5_core]
[  558.978809]  napi_complete_done+0x6f/0x180
[  558.979594]  mlx5e_napi_poll+0x13b/0x600 [mlx5_core]
[  558.980534]  ? mlx5e_completion_event+0x3c/0x40 [mlx5_core]
[  558.981557]  net_rx_action+0x130/0x3a0
[  558.982294]  ? atomic_notifier_call_chain+0x54/0x70
[  558.983202]  __do_softirq+0xc5/0x283
[  558.983905]  asm_call_irq_on_stack+0xf/0x20
[  558.984699]  </IRQ>
[  558.985169]  do_softirq_own_stack+0x37/0x40
[  558.985967]  irq_exit_rcu+0x9c/0xd0
[  558.986661]  common_interrupt+0x74/0x130
[  558.987429]  asm_common_interrupt+0x1e/0x40
[  558.988231] RIP: 0010:native_safe_halt+0xe/0x10
[  558.989090] Code: 02 20 48 8b 00 a8 08 75 c4 e9 7b ff ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d cc 01 55 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d bc 01 55 00 f4 c3 cc cc 0f 1f 44 00
[  558.992327] RSP: 0018:ffffffff82403eb8 EFLAGS: 00000202
[  558.993284] RAX: ffff8882f582c900 RBX: 0000000000000000 RCX: ffff8882f582c900
[  558.994544] RDX: 00000000000ca72a RSI: 7fffff7dead813b5 RDI: 0000000000000086
[  558.995808] RBP: ffffffff82413940 R08: 000000cd42e4dffb R09: 00000082704a9c8a
[  558.997068] R10: 00000000000302ee R11: 0000000000000000 R12: 0000000000000000
[  558.998337] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  558.999606]  default_idle+0xa/0x10
[  559.000294]  default_idle_call+0x38/0xb0
[  559.001054]  do_idle+0x1f7/0x270
[  559.001701]  cpu_startup_entry+0x19/0x20
[  559.002462]  start_kernel+0x511/0x533
[  559.003179]  secondary_startup_64_no_verify+0xa6/0xab
[  559.004126] ---[ end trace 1643bf725be8b630 ]---
[  559.005066] skb len=2948 headroom=78 headlen=1500 tailroom=0
               mac=(64,14) net=(78,20) trans=98
               shinfo(txflags=0 nr_frags=1 gso(size=1448 type=1 segs=2))
               csum(0x100062 ip_summed=3 complete_sw=0 valid=0 level=0)
               hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=3 iif=14
[  559.009931] dev name=enp0s8f0_1 feat=0x0x0002010000116c13
[  559.010930] skb linear:   00000000: 45 00 0b 84 94 d9 40 00 40 06 7e 8a 07 07 07 01
[  559.012357] skb linear:   00000010: 07 07 07 02 b9 42 13 89 7a 21 01 21 fd 01 29 3e
[  559.013777] skb linear:   00000020: 80 10 01 f6 27 87 00 00 01 01 08 0a 44 e2 8c 3e
[  559.015206] skb linear:   00000030: 78 8a d8 86 32 33 34 35 36 37 38 39 30 31 32 33

