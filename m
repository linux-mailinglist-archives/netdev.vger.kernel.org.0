Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64AF241226
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 23:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgHJVOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 17:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgHJVOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 17:14:39 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24779C061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 14:14:39 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p8so5628806pgn.13
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 14:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dyzTDSmjuU43dohT+z0cKDNvE6qSJ6KqmzcBH1YJ7SE=;
        b=M1zIW0RPrumQEarqgm+SwiqiylsWTX7EDMWrXh53o8PJCFtcXkbHhjFunKUlIkIK4G
         Y4xA3Qz5j0+1XUw0DzYyctdfkaxZrUFlg1+0CSn1TlI/pI1GcjSUo+MEW4HeNMfDfeyR
         OknP33ejTsltyZc8JqUFbx3uUNGPXTGdxD3xM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dyzTDSmjuU43dohT+z0cKDNvE6qSJ6KqmzcBH1YJ7SE=;
        b=R690IRc3EG4n6VR+nxJDyM9MD/O/EDHSKFFk5cALDHYDDyTKTqnMTiib07C+ZBL88Z
         iY9qoc/YPef+70ZU8TipIv4xpbPnO/TUMvPqh1D/pYljFJ75iwAucbGwpHaGhr0Eiero
         /VOjTkS0Thd0FZ/yJcVmkr0dhI41efWi8BnygbE4HbZh9GcW+GCFToP7c2Eqzr+pPZmk
         MdYeYYJIFd6xUpcMx1UdNBggYPSZOQa/qnEwvkCCeyFUuKy0WW007mQuZKbWbG1nhaeQ
         Vd0U2C8/rmI3KlS3noyK00+0hCC3M6JgVX+EoEZAvi2/z32XFU5pwgPAiBDgvlVIjYlW
         Qr9w==
X-Gm-Message-State: AOAM53115Y9jrHlgiC+Aoxhtr9e1AEuy0mVEszjSOs9zrP8WUql2wC/J
        qXuj32kOeV1XQdGowAqaMc3LCCz3vKsFxjBdDvbfKM/GXx6SZ6rd
X-Google-Smtp-Source: ABdhPJxDhBejdPBMAzUaU1PSh5WhbdbmC/aF208bfh3ji7m4FDjYx3+NSwio/ci9yZrkJeklh6HZgHCIbhcnyMQoG1w=
X-Received: by 2002:aa7:80d6:: with SMTP id a22mr3007184pfn.275.1597094077981;
 Mon, 10 Aug 2020 14:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAKxSbF052NVLz_-BkbKcyBb2nKPHMz82EBcV0EoUP1Fc_DkVjA@mail.gmail.com>
In-Reply-To: <CAKxSbF052NVLz_-BkbKcyBb2nKPHMz82EBcV0EoUP1Fc_DkVjA@mail.gmail.com>
From:   Alex Forster <aforster@cloudflare.com>
Date:   Mon, 10 Aug 2020 16:14:26 -0500
Message-ID: <CAKxSbF01cLpZem2GFaUaifh0S-5WYViZemTicAg7FCHOnh6kug@mail.gmail.com>
Subject: Re: Page fault in skb_gso_transport_seglen
To:     Network Development <netdev@vger.kernel.org>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

We've recently started using AF_XDP on pairs of veth interfaces, and
at the same time we've started seeing a rare page fault in
net/core/skbuff.c at skb_gso_transport_seglen. I mention AF_XDP
because it seems that the veth_poll code path is only taken when an
XDP program is attached. So far, we've seen the crash on both 5.4.14
and 5.4.53. Does anybody have any insight into this issue?

Console output below.

Alex Forster

--

[9523420.485505][ C41] BUG: unable to handle page fault for address:
ffff9d9624bbb008
[9523420.501570][ C41] #PF: supervisor read access in kernel mode
[9523420.515790][ C41] #PF: error_code(0x0000) - not-present page
[9523420.529908][ C41] PGD 3fc6a05067 P4D 3fc6a05067 PUD 3dd1316063
PMD 37bb173063 PTE 800fffdedb444060
[9523420.547282][ C41] Oops: 0000 [#1] SMP NOPTI
[9523420.559821][ C41] CPU: 41 PID: 0 Comm: swapper/41 Not tainted
5.4.14-cloudflare-2020.1.11 #2020.1.11
[9523420.577255][ C41] Hardware name: Quanta Cloud Technology Inc.
QuantaPlex T42S-2U (LBG-1G)/T42S-2U MB (Lewisburg-1G) CLX, BIOS 3B13
03/27/2019
[9523420.606287][ C41] RIP: 0010:skb_gso_transport_seglen+0x44/0xa0
[9523420.620338][ C41] Code: c0 41 83 e0 11 f6 87 81 00 00 00 20 74 30
0f b7 87 aa 00 00 00 0f b7 b7 b2 00 00 00 48 01 c1 48 29 f0 45 85 c0
48 89 c6 74 0d <0f> b6 41 0c c0 e8 04 0f b6 c0 8d 04 86 0f b7 52 04 01
d0 c3 45 85
[9523420.655663][ C41] RSP: 0018:ffffa4740d344ba0 EFLAGS: 00010202
[9523420.669556][ C41] RAX: 000000000000feda RBX: ffff9d982becc900
RCX: ffff9d9624bbaffc
[9523420.685280][ C41] RDX: ffff9d9624babec0 RSI: 000000000000feda
RDI: ffff9d982becc900
[9523420.700925][ C41] RBP: 00000000000005c4 R08: 0000000000000001
R09: 0000000000000000
[9523420.716414][ C41] R10: ffffa4740d344b1c R11: 000000001a27e1a5
R12: ffff9d982becc900
[9523420.731810][ C41] R13: ffff9d905e64a180 R14: 00000000000005c4
R15: 0000000000000007
[9523420.747112][ C41] FS: 0000000000000000(0000)
GS:ffff9db4ff440000(0000) knlGS:0000000000000000
[9523420.763476][ C41] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[9523420.777201][ C41] CR2: ffff9d9624bbb008 CR3: 00000020d908a006
CR4: 00000000007606e0
[9523420.792297][ C41] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[9523420.807259][ C41] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[9523420.822146][ C41] PKRU: 55555554
[9523420.832348][ C41] Call Trace:
[9523420.842192][ C41] <IRQ>
[9523420.851414][ C41] skb_gso_validate_network_len+0x11/0x70
[9523420.863441][ C41] __ip_finish_output+0x125/0x1c0
[9523420.874700][ C41] ip_output+0x71/0xf0
[9523420.874703][ C41] ? __ip_finish_output+0x1c0/0x1c0
[9523420.874706][ C41] ip_forward+0x36c/0x470
[9523420.874708][ C41] ? ip_defrag.cold+0x36/0x36
[9523420.874709][ C41] ip_rcv+0xbc/0xd0
[9523420.874711][ C41] ? ip_rcv_finish_core.isra.0+0x390/0x390
[9523420.874718][ C41] __netif_receive_skb_one_core+0x80/0x90
[9523420.947841][ C41] netif_receive_skb_internal+0x2f/0xa0
[9523420.947848][ C41] ? inet_gro_complete+0xbd/0xd0
[9523420.968535][ C41] ? napi_gro_complete+0xb9/0xd0
[9523420.968541][ C41] napi_gro_flush+0x97/0xe0
[9523420.987777][ C41] napi_complete_done+0xb7/0x110
[9523420.987784][ C41] veth_poll+0x6a1/0x961 [veth]
[9523421.006707][ C41] ? mlx5e_napi_poll+0x296/0x600 [mlx5_core]
[9523421.017092][ C41] net_rx_action+0x13a/0x380
[9523421.017098][ C41] __do_softirq+0xe0/0x2ca
[9523421.017103][ C41] irq_exit+0xa0/0xb0
[9523421.017107][ C41] do_IRQ+0x58/0xe0
[9523421.050218][ C41] common_interrupt+0xf/0xf
[9523421.050222][ C41] </IRQ>
[9523421.065055][ C41] RIP: 0010:cpuidle_enter_state+0xb2/0x410
[9523421.065060][ C41] Code: c5 0f 1f 44 00 00 31 ff e8 8b 9e 9d ff 80
7c 24 0b 00 74 12 9c 58 f6 c4 02 0f 85 36 03 00 00 31 ff e8 e2 a3 a2
ff fb 45 85 e4 <0f> 88 74 02 00 00 4c 2b 2c 24 49 63 cc 48 8d 04 49 48
c1 e0 05 8b
[9523421.101463][ C41] RSP: 0018:ffffa4740038be70 EFLAGS: 00000202
ORIG_RAX: ffffffffffffffdd
[9523421.101466][ C41] RAX: ffff9db4ff468d40 RBX: ffffffff950f7820
RCX: 000000000000001f
[9523421.101467][ C41] RDX: 0000000000000000 RSI: 00000000435e532a
RDI: 0000000000000000
[9523421.101467][ C41] RBP: ffffc473ff640000 R08: 0021d5801f146e3b
R09: 000000000000006c
[9523421.101468][ C41] R10: ffff9db4ff467c80 R11: ffff9db4ff467c60
R12: 0000000000000002
[9523421.101469][ C41] R13: 0021d5801f146e3b R14: 0000000000000002
R15: ffff9db4f81a0000
[9523421.101481][ C41] cpuidle_enter+0x29/0x40
[9523421.101486][ C41] do_idle+0x1b8/0x200
[9523421.101489][ C41] cpu_startup_entry+0x19/0x20
[9523421.101493][ C41] start_secondary+0x143/0x170
[9523421.101499][ C41] secondary_startup_64+0xa4/0xb0
[9523421.210110][ C41] Modules linked in: fou6 fou ip6_udp_tunnel
udp_tunnel ip6_tunnel tunnel6 algif_hash xt_length bridge
nf_tables_set nft_ct nft_counter nf_tables veth ip_gre gre ip_tunnel
xfrm_user xfrm_algo cls_bpf nfnetlink_log xt_connlimit nf_conncount
xt_hashlimit iptable_security sch_ingress md_mod ip6table_nat
ip6table_mangle ip6table_security ip6table_raw ip6table_filter
ip6_tables xt_nat iptable_nat nf_nat xt_TCPMSS xt_TPROXY
nf_tproxy_ipv6 nf_tproxy_ipv4 xt_u32 xt_connmark iptable_mangle
xt_owner xt_CT xt_socket nf_socket_ipv4 nf_socket_ipv6 iptable_raw
xt_bpf xt_tcpudp xt_comment xt_tcpmss xt_conntrack xt_mark
xt_multiport xt_set iptable_filter bpfilter ip_set_hash_netport
ip_set_hash_net ip_set_hash_ip ip_set nfnetlink xtsproxy dm_crypt
algif_skcipher af_alg dm_mod dax tun sch_fq tcp_bbr nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 8021q garp stp mrp llc skx_edac
x86_pkg_temp_thermal kvm_intel kvm irqbypass crc32_pclmul crc32c_intel
aesni_intel glue_helper crypto_simd
[9523421.210151][ C41] cryptd intel_cstate ipmi_ssif intel_uncore
mlx5_core xhci_pci mlxfw ioatdma tpm_crb intel_rapl_perf ipmi_si tls
xhci_hcd dca ipmi_devintf ipmi_msghandler tpm_tis tpm_tis_core tpm
efivarfs ip_tables x_tables
[9523421.352789][ C41] CR2: ffff9d9624bbb008


[ 3189.833790][ C13] BUG: unable to handle page fault for address:
ffff96662f800008
[ 3189.846733][ C13] #PF: supervisor read access in kernel mode
[ 3189.857963][ C13] #PF: error_code(0x0000) - not-present page
[ 3189.869020][ C13] PGD 19f1801067 P4D 19f1801067 PUD 19f1806067 PMD 0
[ 3189.880850][ C13] Oops: 0000 [#1] SMP NOPTI
[ 3189.890380][ C13] CPU: 13 PID: 0 Comm: swapper/13 Not tainted
5.4.53-cloudflare-2020.7.21 #1
[ 3189.904208][ C13] Hardware name: Quanta Cloud Technology Inc.
QuantaPlex T42S-2U (LBG-1G)/T42S-2U MB (Lewisburg-1G) CLX, BIOS 3B13
03/27/2019
[ 3189.927751][ C13] RIP: 0010:skb_gso_transport_seglen+0x44/0xa0
[ 3189.939052][ C13] Code: c0 41 83 e0 11 f6 87 81 00 00 00 20 74 30
0f b7 87 aa 00 00 00 0f b7 bf b2 00 00 00 48 01 c1 48 29 f8 45 85 c0
48 89 c6 74 0d <0f> b6 41 0c c0 e8 04 0f b6 c0 8d 04 86 0f b7 52 04 01
d0 c3 45 85
[ 3189.969406][ C13] RSP: 0018:ffffb988cce6cbb8 EFLAGS: 00010202
[ 3189.980784][ C13] RAX: 000000000000feda RBX: ffff9671323ddb00 RCX:
ffff96662f7ffffc
[ 3189.994022][ C13] RDX: ffff96662f7f0ec0 RSI: 000000000000feda RDI:
0000000000000122
[ 3190.007243][ C13] RBP: 00000000000005c4 R08: 0000000000000001 R09:
0000000000000000
[ 3190.020479][ C13] R10: ffff96a038b4c800 R11: ffff969efada8e80 R12:
ffff9671323ddb00
[ 3190.033649][ C13] R13: ffff969f0a94c300 R14: 00000000000005c4 R15:
ffff96a073d53440
[ 3190.046786][ C13] FS: 0000000000000000(0000)
GS:ffff9685bf740000(0000) knlGS:0000000000000000
[ 3190.060980][ C13] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3190.072920][ C13] CR2: ffff96662f800008 CR3: 00000015b8c26004 CR4:
00000000007606e0
[ 3190.083820][ C7] hrtimer: interrupt took 336464 ns
[ 3190.086340][ C13] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 3190.110171][ C13] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[ 3190.123483][ C13] PKRU: 55555554
[ 3190.132159][ C13] Call Trace:
[ 3190.140550][ C13] <IRQ>
[ 3190.148384][ C13] skb_gso_validate_network_len+0x11/0x70
[ 3190.159064][ C13] __ip_finish_output+0x109/0x1c0
[ 3190.168967][ C13] ip_sublist_rcv_finish+0x57/0x70
[ 3190.178975][ C13] ip_sublist_rcv+0x2aa/0x2d0
[ 3190.188450][ C13] ? ip_rcv_finish_core.constprop.0+0x390/0x390
[ 3190.199541][ C13] ip_list_rcv+0x12b/0x14f
[ 3190.208672][ C13] __netif_receive_skb_list_core+0x2a9/0x2d0
[ 3190.219361][ C13] netif_receive_skb_list_internal+0x1b5/0x2e0
[ 3190.230237][ C13] napi_complete_done+0x93/0x140
[ 3190.239908][ C13] veth_poll+0xc0/0x19f [veth]
[ 3190.249269][ C13] ? kmem_cache_free_bulk+0x2ac/0x340
[ 3190.259159][ C13] ? __kfree_skb_flush+0x2e/0x40
[ 3190.268565][ C13] net_rx_action+0x1f8/0x790
[ 3190.277504][ C13] __do_softirq+0xe1/0x2bf
[ 3190.286169][ C13] irq_exit+0x8e/0xc0
[ 3190.294390][ C13] do_IRQ+0x58/0xe0
[ 3190.302300][ C13] common_interrupt+0xf/0xf
[ 3190.310767][ C13] </IRQ>
[ 3190.317706][ C13] RIP: 0010:cpuidle_enter_state+0xf2/0x3c0
[ 3190.327268][ C13] Code: 24 0f 1f 44 00 00 31 ff e8 5b 26 9f ff 80
7c 24 0b 00 74 12 9c 58 f6 c4 02 0f 85 9f 02 00 00 31 ff e8 82 38 a4
ff fb 45 85 e4 <0f> 88 e0 01 00 00 48 8b 34 24 49 63 cc 48 8d 04 49 48
c1 e0 05 8b
[ 3190.354696][ C13] RSP: 0018:ffffb988c02abe80 EFLAGS: 00000202
ORIG_RAX: ffffffffffffffda
[ 3190.366826][ C13] RAX: ffff9685bf768d80 RBX: ffffffffafad5ce0 RCX:
000000000000001f
[ 3190.378527][ C13] RDX: 0000000000000000 RSI: 00000000435e478c RDI:
0000000000000000
[ 3190.390248][ C13] RBP: ffff9685bf773d00 R08: 000002e6b0de21e7 R09:
0000000000000006
[ 3190.402095][ C13] R10: 0000000000000033 R11: ffff9685bf767ca0 R12:
0000000000000002
[ 3190.413773][ C13] R13: ffffffffafad5da0 R14: ffffffffafad5db8 R15:
000002e6b0dddfa4
[ 3190.425416][ C13] cpuidle_enter+0x29/0x40
[ 3190.433393][ C13] do_idle+0x1c9/0x230
[ 3190.440889][ C13] cpu_startup_entry+0x19/0x20
[ 3190.449110][ C13] start_secondary+0x143/0x170
[ 3190.457199][ C13] secondary_startup_64+0xa4/0xb0
[ 3190.465413][ C13] Modules linked in: nf_tables_set nft_ct
nft_counter nf_tables veth ip_gre gre xfrm_user xfrm_algo fou6 fou
ip6_udp_tunnel udp_tunnel ip6_tunnel tunnel6 ip_tunnel cls_bpf
nfnetlink_log xt_hashlimit xt_connlimit nf_conncount
ip_set_hash_netport sch_ingress md_mod ip6table_nat ip6table_mangle
ip6table_security ip6table_raw xt_nat iptable_nat nf_nat xt_TCPMSS
xt_TPROXY nf_tproxy_ipv6 nf_tproxy_ipv4 xt_u32 xt_connmark
iptable_mangle xt_owner xt_CT xt_socket nf_socket_ipv4 nf_socket_ipv6
iptable_raw xt_bpf xt_tcpudp xt_comment xt_tcpmss xt_conntrack xt_mark
xt_multiport xt_set ip_set_hash_net ip_set_hash_ip ip_set nfnetlink
ip6table_filter ip6_tables iptable_filter xtsproxy dm_crypt
algif_skcipher af_alg dm_mod dax tun sch_fq tcp_bbr nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 8021q garp stp mrp llc ipmi_ssif
skx_edac x86_pkg_temp_thermal kvm_intel kvm irqbypass crc32_pclmul
crc32c_intel aesni_intel glue_helper crypto_simd cryptd rapl tpm_crb
mlx5_core intel_cstate
[ 3190.465457][ C13] xhci_pci ipmi_si mlxfw i2c_i801 ioatdma tpm_tis
tls i2c_core xhci_hcd intel_uncore ipmi_devintf dca tpm_tis_core
ipmi_msghandler tpm button efivarfs ip_tables x_tables [last unloaded:
kheaders]
[ 3190.609665][ C13] CR2: ffff96662f800008


Apologies to the recipients who are receiving this twice; gmail saw
the link in the original and decided to include an HTML
multipart/alternative.
