Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A12E1F88C5
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 14:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgFNMiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 08:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgFNMh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 08:37:58 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D97C05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 05:37:57 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id p18so9518311eds.7
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 05:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IHgzua80S34TWKldv7RkGeMPlAuNAz7i8WaQZ8Sf0jA=;
        b=uF6V1Ns3G/m1mA3x9CuLRGuHVmldYV/QvD4ERcQciRJAJbwF8XGx5pv69j3jwmOP5U
         R2gi/ahKT3EZPpluTsASqEtZ2eEWvv+nkC6+AahGUIXmwgKUlfvRrY3KJDKxrDERnxvG
         z0g5fSWsO6MtQYMAA7aD4gMYDAFBgLRTI8Mmpg2MdINahLnROxU4ae0sNCsLs4zBn92l
         L7YwkpaHtcB85JP4SvMlptNrqyxPYPt3MpTQs+qPpTc+X/pU/wge7Et+of71lOUmF7dh
         QKY4v6r3KJfPJ6mqP2iCPw1Lu1UOfxZ0y8LHQRDZah7lm4d0wfq7F1i3k9Sa1vqKh3R4
         pWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IHgzua80S34TWKldv7RkGeMPlAuNAz7i8WaQZ8Sf0jA=;
        b=FlSkok7kiiTY7hRNsxH8KRR3AHqEpU84ze2FkRhLMsK6jNu88e+0rSojYDNfpOVql6
         aNlZmY3V466NTxn/02sYq90B7nkZsfvrqOxUA7k2ZxtnmOhYVOJSS/LSAaL9eqPtngqh
         FsnBaiG8b6hieGBOnUZxq7zRJ1Rrjbb6CdE9WQIsJupVAmnkZmN9pE1heHpWy0jOISle
         ncSYXJT7UVZSEMB23sZx/TxxJoqbViofBTeGEkSQg1E9rIwKj9A4Iqg3iVa42x830E91
         y4hqCXBLJG4zOAnqErkh1X9ecFD4oFKdVIsZZMsiK26sExJhiI0KDJYMJ5FOK6uu5MON
         kAoA==
X-Gm-Message-State: AOAM5320lVMZAnbD03/yt4GJc4nfMQl++j3CPNqiS3UHp2cxKxZoCZBl
        lQ6BQU9hJzT3+4mnAuTf2FRkhdhREomYiJbzo0vvGZB2
X-Google-Smtp-Source: ABdhPJwaoFFMQaO9rUQ8y4voeJF2J4BLdfseOD1Rb+RTDEth5Xvs1HWaUNunBDbq66V61o5GOSnoDm3mREMciVsE5Uw=
X-Received: by 2002:a05:6402:13ca:: with SMTP id a10mr20088608edx.224.1592138275384;
 Sun, 14 Jun 2020 05:37:55 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>
Date:   Sun, 14 Jun 2020 14:37:44 +0200
Message-ID: <CAMtihapJKityT=urbrx2yq-csRQ4u7Vcosrf0NzUZtrHfmN0cQ@mail.gmail.com>
Subject: BUG: kernel NULL pointer dereference in __cgroup_bpf_run_filter_skb
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I found on the archive that this bug I encountered also happened to
others. I too have a very similar stacktrace. The issue I'm
experiencing is:

Whenever I fully boot my cluster, in some time, the host crashes with
the __cgroup_bpf_run_filter_skb NULL pointer dereference. This has
been sporadic enough before not to cause real issues. However, as of
lately, the bug is triggered much more frequently. I've changed my
server hardware so I could capture serial output in order to get the
trace. This trace looked very similar as reported by Lu Fengqi. As it
currently stands, I cannot run the cluster as it's almost instantly
crashing the host.

My system is as follows:

I run an Archlinux host which runs several VMs on KVM:
- 3 VMs containing 1 kubernetes-control plane and 2 kubernetes workers (br-k8s)
- 1 VM containing a fedora install which contains an LDAP server to
manage some of the infra and stores users (br-k8s)
- 1 VM containing an archlinux install that receives my ethernet
devices from which I get internet from my ISP and is tasked with
routing (br-k8s, br0, enp2s0, enp3s0)
- 1 VM containing an archlinux install for database (br-k8s, br0)
- 1 VM containing an archlinux install and a custom streaming server (br0)
- 1 VM containing an archlinux install and my mail server + nextcloud (br0)

Networking setup:
br-k8s is a dedicated bridge for kubernetes
br0 is a dedicated bridge for my old VM servers
The host only contains bridges. It does set an IP on all bridges so it
can be reached from the cluster or server network. It gives both of
its real ethernet devices (enp2s0, enp3s0) to the routing VM.

Storage setup:
All of the VMs store their data on the host in a ZFS volume. I realize
this is tainting but unfortunately I cannot separate this out as I
require its RAID feature. I let the host serve out storage from this
ZFS file system through NFS and iSCSI to the cluster.

VM specifics:
All of the VMs utilize virtio versions of their devices

[  667.020230] BUG: kernel NULL pointer dereference, address:
0000000000000010
[  667.027197] #PF: supervisor read access in kernel mode
[  667.032329] #PF: error_code(0x0000) - not-present page
[  667.037485] PGD 0 P4D 0
[  667.040035] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  667.044385] CPU: 3 PID: 26209 Comm: vhost-26199 Tainted: P
 OE     5.7.2-arch1-1 #1
[  667.052816] Hardware name: Gigabyte Technology Co., Ltd. To be
filled by O.E.M./990XA-UD3, BIOS FD 02/04/2013
[  667.062718] RIP: 0010:__cgroup_bpf_run_filter_skb+0xd9/0x230
[  667.068374] Code: 00 48 01 c8 48 89 43 50 41 83 ff 01 0f 84 c2 00
00 00 e8 ea ce ec ff e8 a5 15 f2 ff 44 89 fa 48 8d 84 d5 30 06 00 00
48 8b 00 <48> 8b 78 10 4c 8d 78 10 48 85 ff 0f 84
29 01 00 00 bd 01 00 00 00
[  667.087119] RSP: 0018:ffffa8570084f810 EFLAGS: 00010206
[  667.092337] RAX: 0000000000000000 RBX: ffff910577501000 RCX:
0000000000000034
[  667.099462] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000001
[  667.106594] RBP: ffff910552fc9000 R08: 0000000000000000 R09:
0000000000000001
[  667.113728] R10: 0000000000009cc2 R11: ffff9105775010d4 R12:
0000000000000014
[  667.120859] R13: 0000000000000014 R14: 0000000000000000 R15: 0000000000000000
[  667.127996] FS:  0000000000000000(0000) GS:ffff91057ecc0000(0000)
knlGS:0000000000000000
[  667.136096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  667.141832] CR2: 0000000000000010 CR3: 000000071208a000 CR4:
00000000000406e0
[  667.148957] Call Trace:
[  667.151417]  sk_filter_trim_cap+0x12f/0x270
[  667.155607]  ? tcp_v4_inbound_md5_hash+0x5e/0x170
[  667.160313]  tcp_v4_rcv+0xb53/0xdc0
[  667.163806]  ip_protocol_deliver_rcu+0x2b/0x1e0
[  667.168337]  ip_local_deliver_finish+0x55/0x70
[  667.172792]  ip_local_deliver+0x7f/0x130
[  667.176709]  ip_rcv+0x62/0x110
[  667.179769]  __netif_receive_skb_one_core+0x87/0xa0
[  667.184640]  netif_receive_skb+0x162/0x1b0
[  667.188739]  br_pass_frame_up+0xf0/0x1d0 [bridge]
[  667.193444]  br_handle_frame_finish+0x199/0x460 [bridge]
[  667.198755]  ? br_handle_frame_finish+0x460/0x460 [bridge]
[  667.204247]  br_handle_frame+0x238/0x380 [bridge]
[  667.208955]  ? br_handle_frame_finish+0x460/0x460 [bridge]
[  667.214438]  __netif_receive_skb_core+0x204/0xf30
[  667.219145]  ? translate_desc+0x7c/0x130 [vhost]
[  667.223762]  __netif_receive_skb_one_core+0x3d/0xa0
[  667.228640]  netif_receive_skb+0x162/0x1b0
[  667.232733]  tun_sendmsg+0x3a7/0x5d0 [tun]
[  667.236840]  vhost_tx_batch.constprop.0+0x65/0xf0 [vhost_net]
[  667.242577]  handle_tx_copy+0x187/0x5b0 [vhost_net]
[  667.247452]  ? vhost_dev_reset_owner+0x40/0x40 [vhost]
[  667.252597]  handle_tx+0xa5/0xe0 [vhost_net]
[  667.256870]  vhost_worker+0xb9/0x130 [vhost]
[  667.261152]  kthread+0x13e/0x160
[  667.264383]  ? __kthread_bind_mask+0x60/0x60
[  667.268672]  ret_from_fork+0x22/0x40
[  667.272243] Modules linked in: macvtap macvlan vhost_net vhost tap
vhost_iotlb tun target_core_user uio target_core_pscsi
target_core_file target_core_iblock iscsi_target_mod target_cor
e_mod raid1 dm_mod nls_iso8859_1 nls_cp437 vfat fat bridge stp llc
md_mod btrfs zfs(POE) blake2b_generic xor edac_mce_amd raid6_pq
kvm_amd ccp libcrc32c rng_core kvm irqbypass crct10dif_pc
lmul crc32_pclmul ghash_clmulni_intel mxm_wmi r8169 aesni_intel
crypto_simd cryptd realtek sp5100_tco libphy glue_helper i2c_piix4
pcspkr fam15h_power input_leds k10temp evdev mac_hid acpi
_cpufreq wmi zunicode(POE) zavl(POE) icp(POE) zcommon(POE)
znvpair(POE) spl(OE) zlua(POE) nfsd drm auth_rpcgss nfs_acl lockd
grace agpgart sunrpc ip_tables x_tables ext4 crc32c_generic crc
16 mbcache jbd2 uas usb_storage ohci_pci serio_raw atkbd libps2
crc32c_intel ehci_pci ehci_hcd ohci_hcd xhci_pci xhci_hcd i8042 serio
[  667.349213] CR2: 0000000000000010
[  667.352542] ---[ end trace 8f266956899b073b ]---
[  667.357170] RIP: 0010:__cgroup_bpf_run_filter_skb+0xd9/0x230
[  667.362828] Code: 00 48 01 c8 48 89 43 50 41 83 ff 01 0f 84 c2 00
00 00 e8 ea ce ec ff e8 a5 15 f2 ff 44 89 fa 48 8d 84 d5 30 06 00 00
48 8b 00 <48> 8b 78 10 4c 8d 78 10 48 85 ff 0f 84
29 01 00 00 bd 01 00 00 00
[  667.381566] RSP: 0018:ffffa8570084f810 EFLAGS: 00010206
[  667.386792] RAX: 0000000000000000 RBX: ffff910577501000 RCX:
0000000000000034
[  667.393916] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000001
[  667.401047] RBP: ffff910552fc9000 R08: 0000000000000000 R09:
0000000000000001
[  667.408172] R10: 0000000000009cc2 R11: ffff9105775010d4 R12:
0000000000000014
[  667.415296] R13: 0000000000000014 R14: 0000000000000000 R15:
0000000000000000
[  667.422430] FS:  0000000000000000(0000) GS:ffff91057ecc0000(0000)
knlGS:0000000000000000
[  667.430506] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  667.436245] CR2: 0000000000000010 CR3: 000000071208a000 CR4:
00000000000406e0
[  667.443367] Kernel panic - not syncing: Fatal exception in
interrupt
[  667.449725] Kernel Offset: 0x29600000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  667.460495] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---
