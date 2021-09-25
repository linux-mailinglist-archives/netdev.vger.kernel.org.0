Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FEE4181B1
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 13:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244687AbhIYLnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 07:43:02 -0400
Received: from mail.kotidze.in ([185.117.119.164]:35226 "EHLO mail.kotidze.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238011AbhIYLnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 07:43:00 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Sep 2021 07:43:00 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vodka.home.kg;
        s=vodka; t=1632569546;
        bh=AiokuuoBMYrFsZjowcjSkgFl0nTv/A+t/ymFZiuMMpY=;
        h=Date:From:To:Subject:From;
        b=mJOpugoE20yMbCbH4pjoL2vpLkE2x0E/EYPz3BRwl+n+HohvxfeyU277TUNd2EfgQ
         NnoomdHeYP2yA1Fe2/Jcf30pomCZvKWu3ZLFuIVhym84CyNCnCu2px5LUhX+X690Me
         FJWUpANTkuxVmU0kHH0GO5uHI+kZkcuvYGN2FYnw=
Date:   Sat, 25 Sep 2021 14:32:16 +0300
From:   k@vodka.home.kg
Message-ID: <1110422272.20210925143216@vodka.home.kg>
To:     Felix Fietkau <nbd@openwrt.org>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org
Subject: [MEDIATEK ETHERNET DRIVER] initialization failure on low ram systems
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi !

I'm using openwrt 21.02 kernel 5.4.143 on Tp-link c6u device
It's MT7621DAT based board with 128 MB RAM :
https://openwrt.org/toh/hwdata/tp-link/tp-link_archer_c6u_v1_eu
https://wikidevi.wi-cat.ru/MediaTek_MT7621

I found that sometimes during network restart when mediatek chip gets reini=
tialized
kernel memory allocation fails and switch ports become unusable (some or al=
l)
leading to loss of ethernet access to the router
ethtool reports no link

Here is the kernel log :

[10389.945893] netifd: page allocation failure: order:8, mode:0x40dc0(GFP_K=
ERNEL|__GFP_COMP|__GFP_ZERO), nodemask=3D(null),cpuset=3D/,mems_allowed=3D0
[10389.958689] CPU: 1 PID: 20444 Comm: netifd Not tainted 5.4.143 #0
[10389.964763] Stack : 00000008 80082090 00000000 00000000 80730000 80738c9=
c 80737960 86815b7c
[10389.973104]         808f0000 80784da3 806b7a74 806b7a74 00000001 0000000=
1 86815b20 00000007
[10389.981438]         00000000 00000000 80930000 00000000 30232033 000018a=
1 2e352064 34312e34
[10389.989771]         00000000 00000204 00000000 000ea0e1 80000000 807a000=
0 00000000 00040dc0
[10389.998104]         807a0000 00000201 00000240 00040dc0 00000000 80381e0=
8 00000004 808f0004
[10390.006439]         ...
[10390.008879] Call Trace:
[10390.011344] [<8000b68c>] show_stack+0x30/0x100
[10390.015800] [<805f1254>] dump_stack+0xa4/0xdc
[10390.020167] [<80170c90>] warn_alloc+0xc0/0x138
[10390.024602] [<80171af4>] __alloc_pages_nodemask+0xdec/0xeb8
[10390.030161] [<8014bfb8>] kmalloc_order+0x2c/0x70
[10390.034778] [<8040807c>] mtk_open+0x158/0x804
[10390.039127] [<8045d5e4>] __dev_open+0xf4/0x188
[10390.043559] [<8045da44>] __dev_change_flags+0x18c/0x1e4
[10390.048768] [<8045dac4>] dev_change_flags+0x28/0x70
[10390.053637] [<8048a364>] dev_ifsioc+0x2ac/0x34c
[10390.058155] [<8048a5f0>] dev_ioctl+0xd4/0x3f8
[10390.062510] [<804304ec>] sock_ioctl+0x354/0x4bc
[10390.067040] [<801adbb4>] do_vfs_ioctl+0xb8/0x7c0
[10390.071645] [<801ae30c>] ksys_ioctl+0x50/0xb4
[10390.076000] [<80014598>] syscall_common+0x34/0x58
[10390.080969] Mem-Info:
[10390.083314] active_anon:6858 inactive_anon:6892 isolated_anon:32
[10390.083314]  active_file:733 inactive_file:741 isolated_file:1
[10390.083314]  unevictable:2 dirty:0 writeback:0 unstable:0
[10390.083314]  slab_reclaimable:921 slab_unreclaimable:5251
[10390.083314]  mapped:1082 shmem:0 pagetables:215 bounce:0
[10390.083314]  free:3817 free_pcp:32 free_cma:0
[10390.115576] Node 0 active_anon:27432kB inactive_anon:27848kB active_file=
:2988kB inactive_file:3468kB unevictable:8kB isolated(anon):128kB isolated(=
file):4kB mapped:4776kB dirty:0kB writeback:0kB shmem:0kB writeback_tmp:0kB=
 unstable:0kB all_unreclaimable? no
[10390.138417] Normal free:13876kB min:13312kB low:14336kB high:15360kB act=
ive_anon:27432kB inactive_anon:27760kB active_file:2808kB inactive_file:350=
8kB unevictable:8kB writepending:0kB present:131072kB managed:121444kB mloc=
ked:8kB kernel_stack:1064kB pagetables:860kB bounce:0kB free_pcp:76kB local=
_pcp:0kB free_cma:0kB


I traced where alloc fails and found 1 MB memory allocation=20

mtk_eth_soc.c  mtk_open()
err =3D mtk_start_dma(eth); // err=3D-ENOMEM
err =3D mtk_dma_init(eth); // err=3D-ENOMEM
err =3D mtk_init_fq_dma(eth); // err=3D-ENOMEM
eth->scratch_head =3D kcalloc(cnt, MTK_QDMA_PAGE_SIZE, GFP_KERNEL); // cnt=
=3D512, MT_QDMA_PAGE_SIZE=3D2048. allocating 1 MB, *FAILS HERE*


To reproduce I put the system to memory pressure condition using
screen nice -n 10 stress --vm 1 --vm-bytes 71000000
and then restart the chip : /etc/init.d/network restart
Even after killing stress network restart often does not help to restore LA=
N access

From=20my point of view it's not a good idea to allocate large contiguous m=
emory pieces in linux kernel
on low RAM systems which most of the routers are. Free kernel memory may be=
come fragmented.
I tried decreaseing MTK_DMA_SIZE from 512 to 128 and it helped but not 100%
MTK_DMA_SIZE=3D64 makes network unstable

