Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A3748582A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242891AbiAES0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242890AbiAES02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:26:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC94FC061245;
        Wed,  5 Jan 2022 10:26:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B9E161899;
        Wed,  5 Jan 2022 18:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D05EC36AE0;
        Wed,  5 Jan 2022 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641407186;
        bh=8Rh8+9kEcw2RkgbbTKDwnxgNPZN6KjYhzQ4LulQYlI8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CKGRX3KDi7O5SWP21eFGrSVbESaze1Rrg0ae72infu6yO57lj2Ddp2a0wC0twWD+C
         teuKBy5rH5zD4nrbcapMXqj1Pci+o4LWAcO4OZtXo/UE/hq/4BHc4D/15PvC7juJn0
         +V9Tinwwgam7VJdNtHLJp/MoYdyhQsdmAH58BU/zEwnkRGd0955mgcFHkhPHn0Yjfl
         K/QAamnfji1qyDYS9ZVG76CaP8/ZpmFc/Us/O6xT5py5Zge0nB0P1/xPuzxPID8tkD
         zYD3MHToD24F3JxNJBFBRV1DD/cLwzqhjNBnezp6IxXyTbMyE+O+s+JZEvq5VJsyad
         X3HXLhLL2txRw==
Date:   Wed, 5 Jan 2022 10:26:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        alexandr.lobakin@intel.com, dumazet@google.com,
        brian King <brking@linux.vnet.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        netdev <netdev@vger.kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>
Subject: Re: [5.16.0-rc5][ppc][net] kernel oops when hotplug remove of vNIC
 interface
Message-ID: <20220105102625.2738186e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <63380c22-a163-2664-62be-2cf401065e73@linux.vnet.ibm.com>
References: <63380c22-a163-2664-62be-2cf401065e73@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jan 2022 13:56:53 +0530 Abdul Haleem wrote:
> Greeting's
>=20
> Mainline kernel 5.16.0-rc5 panics when DLPAR ADD of vNIC device on my=20
> Powerpc LPAR
>=20
> Perform below dlpar commands in a loop from linux OS
>=20
> drmgr -r -c slot -s U9080.HEX.134C488-V1-C3 -w 5 -d 1
> drmgr -a -c slot -s U9080.HEX.134C488-V1-C3 -w 5 -d 1
>=20
> after 7th iteration, the kernel panics with below messages
>=20
> console messages:
> [102056] ibmvnic 30000003 env3: Sending CRQ: 801e000864000000=20
> 0060000000000000
> <intr> ibmvnic 30000003 env3: Handling CRQ: 809e000800000000=20
> 0000000000000000
> [102056] ibmvnic 30000003 env3: Disabling tx_scrq[0] irq
> [102056] ibmvnic 30000003 env3: Disabling tx_scrq[1] irq
> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[0] irq
> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[1] irq
> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[2] irq
> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[3] irq
> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[4] irq
> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[5] irq
> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[6] irq
> [102056] ibmvnic 30000003 env3: Disabling rx_scrq[7] irq
> [102056] ibmvnic 30000003 env3: Replenished 8 pools
> Kernel attempted to read user page (10) - exploit attempt? (uid: 0)
> BUG: Kernel NULL pointer dereference on read at 0x00000010
> Faulting instruction address: 0xc000000000a3c840
> Oops: Kernel access of bad area, sig: 11 [#1]
> LE PAGE_SIZE=3D64K MMU=3DRadix SMP NR_CPUS=3D2048 NUMA pSeries
> Modules linked in: bridge stp llc ib_core rpadlpar_io rpaphp nfnetlink=20
> tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag=20
> bonding rfkill ibmvnic sunrpc pseries_rng xts vmx_crypto gf128mul=20
> sch_fq_codel binfmt_misc ip_tables ext4 mbcache jbd2 dm_service_time=20
> sd_mod t10_pi sg ibmvfc scsi_transport_fc ibmveth dm_multipath dm_mirror=
=20
> dm_region_hash dm_log dm_mod fuse
> CPU: 9 PID: 102056 Comm: kworker/9:2 Kdump: loaded Not tainted=20
> 5.16.0-rc5-autotest-g6441998e2e37 #1
> Workqueue: events_long __ibmvnic_reset [ibmvnic]
> NIP:=C2=A0 c000000000a3c840 LR: c0080000029b5378 CTR: c000000000a3c820
> REGS: c0000000548e37e0 TRAP: 0300=C2=A0=C2=A0 Not tainted=20
> (5.16.0-rc5-autotest-g6441998e2e37)
> MSR:=C2=A0 8000000000009033 <SF,EE,ME,IR,DR,RI,LE>=C2=A0 CR: 28248484=C2=
=A0 XER: 00000004
> CFAR: c0080000029bdd24 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0
> GPR00: c0080000029b55d0 c0000000548e3a80 c0000000028f0200 0000000000000000
> GPR04: c000000c7d1a7e00 fffffffffffffff6 0000000000000027 c000000c7d1a7e08
> GPR08: 0000000000000023 0000000000000000 0000000000000010 c0080000029bdd10
> GPR12: c000000000a3c820 c000000c7fca6680 0000000000000000 c000000133016bf8
> GPR16: 00000000000003fe 0000000000001000 0000000000000002 0000000000000008
> GPR20: c000000133016eb0 0000000000000000 0000000000000000 0000000000000003
> GPR24: c000000133016000 c000000133017168 0000000020000000 c000000133016a00
> GPR28: 0000000000000006 c000000133016a00 0000000000000001 c000000133016000
> NIP [c000000000a3c840] napi_enable+0x20/0xc0
> LR [c0080000029b5378] __ibmvnic_open+0xf0/0x430 [ibmvnic]
> Call Trace:
> [c0000000548e3a80] [0000000000000006] 0x6 (unreliable)
> [c0000000548e3ab0] [c0080000029b55d0] __ibmvnic_open+0x348/0x430 [ibmvnic]
> [c0000000548e3b40] [c0080000029bcc28] __ibmvnic_reset+0x500/0xdf0 [ibmvni=
c]
> [c0000000548e3c60] [c000000000176228] process_one_work+0x288/0x570
> [c0000000548e3d00] [c000000000176588] worker_thread+0x78/0x660
> [c0000000548e3da0] [c0000000001822f0] kthread+0x1c0/0x1d0
> [c0000000548e3e10] [c00000000000cf64] ret_from_kernel_thread+0x5c/0x64
> Instruction dump:
> 7d2948f8 792307e0 4e800020 60000000 3c4c01eb 384239e0 f821ffd1 39430010
> 38a0fff6 e92d1100 f9210028 39200000 <e9030010> f9010020 60420000 e9210020
> ---[ end trace 5f8033b08fd27706 ]---
> radix-mmu: Page sizes from device-tree:
>=20
> the fault instruction points to
>=20
> [root@ltcden11-lp1 boot]# gdb -batch=20
> vmlinuz-5.16.0-rc5-autotest-g6441998e2e37 -ex 'list *(0xc000000000a3c840)'
> 0xc000000000a3c840 is in napi_enable (net/core/dev.c:6966).
> 6961=C2=A0=C2=A0=C2=A0 void napi_enable(struct napi_struct *n)
> 6962=C2=A0=C2=A0=C2=A0 {
> 6963=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 unsigned long val, new;
> 6964
> 6965=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 do {
> 6966=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 val =3D READ=
_ONCE(n->state);

If n is NULL here that's gotta be a driver problem.

Adding Dany & Suka.

> 6967=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 BUG_ON(!test=
_bit(NAPI_STATE_SCHED, &val));
> 6968
> 6969=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 new =3D val =
& ~(NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC);
> 6970=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 if (n->dev->=
threaded && n->thread)
>=20

