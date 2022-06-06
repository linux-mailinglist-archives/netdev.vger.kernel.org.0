Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F168153EC2C
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiFFKaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 06:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiFFK37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 06:29:59 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401A423BC1B;
        Mon,  6 Jun 2022 03:29:57 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654511395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fqKI9UkF2+yfUdVqeBfOSRIhlj7SDS8UhuuUFgDR/Kw=;
        b=Oija4rI7zM5tReOOPz/OYGXKVcR52YzPzW18Iy21ere9xttB1QntmFxKU1RNo9P5lLqzfs
        J8TbJ29pcIIbgp7++yYwuihRNo3YGlJQvNo7WMItwkR9shnNVr32hKx56mEcL3FFw92Bly
        dh593KGsqAtaTVHJqGD3bs9LZRY04zw=
Date:   Mon, 06 Jun 2022 10:29:54 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Yajun Deng" <yajun.deng@linux.dev>
Message-ID: <27b8035a0f9b1ea7cb370e0a346c224d@linux.dev>
Subject: Re: [PATCH] net/mlx5: Add affinity for each irq
To:     "Shay Drory" <shayd@nvidia.com>, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <0338001c-4a8c-bf28-b857-42e1bc775ea0@nvidia.com>
References: <0338001c-4a8c-bf28-b857-42e1bc775ea0@nvidia.com>
 <20220606071351.3550997-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

June 6, 2022 4:31 PM, "Shay Drory" <shayd@nvidia.com> wrote:=0A=0A> On 6/=
6/2022 10:13, Yajun Deng wrote:=0A> =0A>> The mlx5 would allocate no less=
 than one irq for per cpu, we can bond each=0A>> irq to a cpu to improve =
interrupt performance.=0A> =0A> The maximum number of affinity set is har=
d coded to 4. in case nvec > 4 * (num_CPUs)[1]=0A> we will hit the follow=
ing WARN[2].=0A> Also, we hit an oops following this WARN...=0A> =0A> [1]=
=0A> mlx5 support up to 2K MSIX (depends on the HW). e.g.: if we max out =
mlx5 MSIX capability,=0A> we will cross this limit on any machine, at lea=
st that I know of.=0A> =0A=0AOh, I didn't expect so many MSIX. Thank you!=
=0A> [2]=0A> =0A> This is a machine with 10 CPUs and 350 MSIX=0A> =0A> [ =
1.633436] ------------[ cut here ]------------=0A> [ 1.633437] WARNING: C=
PU: 2 PID: 194 at kernel/irq/affinity.c:443=0A> irq_create_affinity_masks=
+0x175/0x270=0A> [ 1.633467] Modules linked in: mlx5_core(+)=0A> [ 1.6334=
74] CPU: 2 PID: 194 Comm: systemd-modules Not tainted 5.18.0+ #1=0A> [ 1.=
633480] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=0A> rel-=
1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014=0A> [ 1.633483] RIP: =
0010:irq_create_affinity_masks+0x175/0x270=0A> [ 1.633492] Code: 5c 41 5d=
 41 5e 41 5f c3 48 c7 46 20 90 6d 19 81 48 c7 c0 90 6d 19 81 8b 34 24 4c=
=0A> 89 ef ff d0 41 83 7d 08 04 0f 86 de fe ff ff <0f> 0b 45 31 f6 eb c5 =
45 8b 5d 00 8b 34 24 43 8d 04=0A> 1f 42 8d 0c 1e=0A> [ 1.633497] RSP: 001=
8:ffff88810716bac0 EFLAGS: 00010202=0A> [ 1.633501] RAX: 000000000000000a=
 RBX: 0000000000000001 RCX: 0000000000000200=0A> [ 1.633504] RDX: fffffff=
f82605000 RSI: ffffffff82605000 RDI: 0000000000000000=0A> [ 1.633507] RBP=
: ffff88810716bbd0 R08: 000000000000000a R09: ffffffff82604fc0=0A> [ 1.63=
3510] R10: 0000000000000008 R11: 000ffffffffff000 R12: 0000000000000000=
=0A> [ 1.633513] R13: ffff88810716bbd0 R14: 0000000000000160 R15: 0000000=
000000160=0A> [ 1.633516] FS: 00007f8d72994b80(0000) GS:ffff88852c900000(=
0000) knlGS:0000000000000000=0A> [ 1.633525] CS: 0010 DS: 0000 ES: 0000 C=
R0: 0000000080050033=0A> [ 1.633528] CR2: 00007f8d73ba4490 CR3: 000000010=
3fce001 CR4: 0000000000370ea0=0A> [ 1.633531] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000=0A> [ 1.633534] DR3: 0000000000000=
000 DR6: 00000000fffe0ff0 DR7: 0000000000000400=0A> [ 1.633536] Call Trac=
e:=0A> [ 1.633549] <TASK>=0A> [ 1.633553] __pci_enable_msix_range+0x2b9/0=
x4c0=0A> [ 1.633572] pci_alloc_irq_vectors_affinity+0xa5/0x100=0A> [ 1.63=
3579] mlx5_irq_table_create.cold+0x6d/0x22f [mlx5_core]=0A> [ 1.634032] ?=
 probe_one+0x1aa/0x280 [mlx5_core]=0A> [ 1.634193] ? pci_device_probe+0xa=
4/0x140=0A> [ 1.634201] ? really_probe+0xc9/0x350=0A> [ 1.634205] ? pm_ru=
ntime_barrier+0x43/0x80=0A> [ 1.634213] ? __driver_probe_device+0x80/0x17=
0=0A> [ 1.634218] ? driver_probe_device+0x1e/0x90=0A> [ 1.634223] ? __dri=
ver_attach+0xcd/0x1b0=0A> [ 1.634226] ? __device_attach_driver+0xf0/0xf0=
=0A> [ 1.634231] ? __device_attach_driver+0xf0/0xf0=0A> [ 1.634235] ? bus=
_for_each_dev+0x77/0xc0=0A> [ 1.634243] ? bus_add_driver+0x184/0x1f0=0A> =
[ 1.634247] ? driver_register+0x8f/0xe0=0A> [ 1.634251] ? 0xffffffffa0180=
000=0A> [ 1.634256] ? init+0x62/0x1000 [mlx5_core]=0A> [ 1.634413] ? do_o=
ne_initcall+0x4a/0x1e0=0A> [ 1.634418] ? kmem_cache_alloc_trace+0x33/0x42=
0=0A> [ 1.634426] ? do_init_module+0x72/0x260=0A> [ 1.634434] ? __do_sys_=
finit_module+0xbb/0x130=0A> [ 1.634443] ? do_syscall_64+0x3d/0x90=0A> [ 1=
.634452] ? entry_SYSCALL_64_after_hwframe+0x46/0xb0=0A> [ 1.634461] </TAS=
K>=0A> [ 1.634463] ---[ end trace 0000000000000000 ]---=0A> [=1B[0;32m OK=
 =1B[0m] Finished =1B[0;1;39mudev Coldplug all Devices=1B[0m.=0A> [ 1.713=
428] Kernel panic - not syncing: stack-protector: Kernel stack is corrupt=
ed in:=0A> mlx5_irq_table_create+0x9c/0xa0 [mlx5_core]=0A> [ 1.715521] CP=
U: 2 PID: 194 Comm: systemd-modules Tainted: G W 5.18.0+ #1=0A> [ 1.71552=
4] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=0A> rel-1.13.=
0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014=0A> [ 1.715525] Call Trace=
:=0A> [ 1.715532] <TASK>=0A> [ 1.715533] dump_stack_lvl+0x34/0x44=0A> [ 1=
.715538] panic+0x100/0x255=0A> [ 1.715542] ? mlx5_irq_table_create+0x9c/0=
xa0 [mlx5_core]=0A> [ 1.715602] __stack_chk_fail+0x10/0x10=0A> [ 1.715607=
] mlx5_irq_table_create+0x9c/0xa0 [mlx5_core]=0A> [ 1.715662] ? probe_one=
+0x1aa/0x280 [mlx5_core]=0A> [ 1.715709] ? pci_device_probe+0xa4/0x140=0A=
> [ 1.715712] ? really_probe+0xc9/0x350=0A> [ 1.715715] ? pm_runtime_barr=
ier+0x43/0x80=0A> [ 1.715718] ? __driver_probe_device+0x80/0x170=0A> [ 1.=
715719] ? driver_probe_device+0x1e/0x90=0A> [ 1.715721] ? __driver_attach=
+0xcd/0x1b0=0A> [ 1.715722] ? __device_attach_driver+0xf0/0xf0=0A> [ 1.71=
5723] ? __device_attach_driver+0xf0/0xf0=0A> [ 1.715724] ? bus_for_each_d=
ev+0x77/0xc0=0A> [ 1.715727] ? bus_add_driver+0x184/0x1f0=0A> [ 1.715728]=
 ? driver_register+0x8f/0xe0=0A> [ 1.715730] ? 0xffffffffa0180000=0A> [ 1=
.715731] ? init+0x62/0x1000 [mlx5_core]=0A> [ 1.715778] ? do_one_initcall=
+0x4a/0x1e0=0A> [ 1.715781] ? kmem_cache_alloc_trace+0x33/0x420=0A> [ 1.7=
15784] ? do_init_module+0x72/0x260=0A> [ 1.715788] ? __do_sys_finit_modul=
e+0xbb/0x130=0A> [ 1.715790] ? do_syscall_64+0x3d/0x90=0A> [ 1.715792] ? =
entry_SYSCALL_64_after_hwframe+0x46/0xb0=0A> [ 1.715796] </TASK>=0A> [ 1.=
715938] Kernel Offset: disabled=0A> [ 1.732563] ---[ end Kernel panic - n=
ot syncing: stack-protector: Kernel stack is corrupted in:=0A> mlx5_irq_t=
able_create+0x9c/0xa0 [mlx5_core] ]---=0A> =0A>> Signed-off-by: Yajun Den=
g <yajun.deng@linux.dev>=0A>> ---=0A>> .../net/ethernet/mellanox/mlx5/cor=
e/pci_irq.c | 19 ++++++++++++++++++-=0A>> 1 file changed, 18 insertions(+=
), 1 deletion(-)=0A>> =0A>> diff --git a/drivers/net/ethernet/mellanox/ml=
x5/core/pci_irq.c=0A>> b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.=
c=0A>> index 662f1d55e30e..d13fc403fe78 100644=0A>> --- a/drivers/net/eth=
ernet/mellanox/mlx5/core/pci_irq.c=0A>> +++ b/drivers/net/ethernet/mellan=
ox/mlx5/core/pci_irq.c=0A>> @@ -624,11 +624,27 @@ int mlx5_irq_table_get_=
num_comp(struct mlx5_irq_table *table)=0A>> return table->pf_pool->xa_num=
_irqs.max - table->pf_pool->xa_num_irqs.min;=0A>> }=0A>>> +static void ml=
x5_calc_sets(struct irq_affinity *affd, unsigned int nvecs)=0A>> +{=0A>> =
+ int i;=0A>> +=0A>> + affd->nr_sets =3D (nvecs - 1) / num_possible_cpus(=
) + 1;=0A>> +=0A>> + for (i =3D 0; i < affd->nr_sets; i++) {=0A>> + affd-=
>set_size[i] =3D min(nvecs, num_possible_cpus());=0A>> + nvecs -=3D num_p=
ossible_cpus();=0A>> + }=0A>> +}=0A>> +=0A>> int mlx5_irq_table_create(st=
ruct mlx5_core_dev *dev)=0A>> {=0A>> int num_eqs =3D MLX5_CAP_GEN(dev, ma=
x_num_eqs) ?=0A>> MLX5_CAP_GEN(dev, max_num_eqs) :=0A>> 1 << MLX5_CAP_GEN=
(dev, log_max_eq);=0A>> + struct irq_affinity affd =3D {=0A>> + .pre_vect=
ors =3D 0,=0A>> + .calc_sets =3D mlx5_calc_sets,=0A>> + };=0A>> int total=
_vec;=0A>> int pf_vec;=0A>> int err;=0A>> @@ -644,7 +660,8 @@ int mlx5_ir=
q_table_create(struct mlx5_core_dev *dev)=0A>> total_vec +=3D MLX5_IRQ_CT=
RL_SF_MAX +=0A>> MLX5_COMP_EQS_PER_SF * mlx5_sf_max_functions(dev);=0A>>>=
 - total_vec =3D pci_alloc_irq_vectors(dev->pdev, 1, total_vec, PCI_IRQ_M=
SIX);=0A>> + total_vec =3D pci_alloc_irq_vectors_affinity(dev->pdev, 1, t=
otal_vec,=0A>> + PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &affd);=0A>> if (total_=
vec < 0)=0A>> return total_vec;=0A>> pf_vec =3D min(pf_vec, total_vec);
