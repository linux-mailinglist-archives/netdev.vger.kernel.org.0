Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595D76C99CE
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 05:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbjC0DBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 23:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjC0DBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 23:01:31 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144DD4EDA;
        Sun, 26 Mar 2023 20:01:30 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t10so29921089edd.12;
        Sun, 26 Mar 2023 20:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679886088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4GDymRNkOjJsSOA045LY2BxPvnP/qlaatdo8SbJ1ag=;
        b=BeqgldFIF9KNNqp3xkPobO47Au0GuRWs6O550fC5qZUX6rZj2jI5nLtid7pbD79K7A
         GShLM0THnmXOoczuzis8P0HfzYVn55NFPP0ibx2SNXZwGJcYO6RjJzCWVyAI1JHsBjt8
         L9Vj9K/6+V+W/iAgrrv+x/ePlp9wPAdHeHglgkTl9LY982zb5XevQlcsb427BLgNrhq4
         pLxeyjosXtLlLnrkTl3QzvvW2HdPoFCb+6TzWtaXY6iL+VsC/CEfE7KxJ1SuRZz/2nKp
         TOa0WDBuONPadPy073GjGrQDdhA6lsCNvjGkHcBo/W9DshUHNAz0cr9XUIq3HiPfUXGR
         8vwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679886088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4GDymRNkOjJsSOA045LY2BxPvnP/qlaatdo8SbJ1ag=;
        b=eCHEZHM+XXsukv9yjknFHo3BfU2iPdxEM5cQd604UfiCLJZpnMjxwVknemVaioOc4J
         Xm8Wj7Gd2t8ht+weoVFHZjYZOGGY102PWTe7H2zo2HdbLDvQLtgh1liYyEw/n7WNvKUW
         9vG0ANdrU9Ib03xPE6WCdQkw576m2TKDeC8qDK0x5gY+F4egIKOY2qiitFbne0uZJGv+
         j42bufLVvqdbtQPlNNCiAsnUvIYmLRjSE7TFjHorPsqEnIE8hb0EoFZshD+UJXZnVtf/
         3ETGsIIcm/eVPSCoCORrvgEZtHvUuA9gXM8ieCfxry8qlKoqnP2bTPzWgGTca6Q6+o32
         Tbwg==
X-Gm-Message-State: AAQBX9dw2oVlfDyWEA+q3Ym1hTmGLgvsFYseyn69l7xcTEBuyBwwP2H8
        S9c6mFZaauXZYwd681UR5ro2rES28drJLthdgC8=
X-Google-Smtp-Source: AKy350Y4tsa4GkxwUruZFX5WMh1p6Mk7SPuaQ6mvh29LEOaYwSB6NmzCCKdBR7ylAyeZQ3VFM6+5LIh0W3O0fwdwxkA=
X-Received: by 2002:a17:906:eda6:b0:8dd:70a:3a76 with SMTP id
 sa6-20020a170906eda600b008dd070a3a76mr5140850ejb.11.1679886088494; Sun, 26
 Mar 2023 20:01:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230308220756.587317-1-jjh@daedalian.us>
In-Reply-To: <20230308220756.587317-1-jjh@daedalian.us>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Mon, 27 Mar 2023 11:00:52 +0800
Message-ID: <CAL+tcoCMCq0y6ktXTUdjCuoX+Z+UCNxchEN3jGn9o-zRY4EZSA@mail.gmail.com>
Subject: Re: [PATCH net v3] ixgbe: Panic during XDP_TX with > 64 CPUs
To:     John Hickey <jjh@daedalian.us>
Cc:     anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 6:22=E2=80=AFAM John Hickey <jjh@daedalian.us> wrote=
:
>
> In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
> (4fe815850bdc), support was added to allow XDP programs to run on systems
> with more than 64 CPUs by locking the XDP TX rings and indexing them
> using cpu % 64 (IXGBE_MAX_XDP_QS).
>
> Upon trying this out patch via the Intel 5.18.6 out of tree driver
> on a system with more than 64 cores, the kernel paniced with an
> array-index-out-of-bounds at the return in ixgbe_determine_xdp_ring in
> ixgbe.h, which means ixgbe_determine_xdp_q_idx was just returning the
> cpu instead of cpu % IXGBE_MAX_XDP_QS.  An example splat:
>
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  UBSAN: array-index-out-of-bounds in
>  /var/lib/dkms/ixgbe/5.18.6+focal-1/build/src/ixgbe.h:1147:26
>  index 65 is out of range for type 'ixgbe_ring *[64]'
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  BUG: kernel NULL pointer dereference, address: 0000000000000058
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] SMP NOPTI
>  CPU: 65 PID: 408 Comm: ksoftirqd/65
>  Tainted: G          IOE     5.15.0-48-generic #54~20.04.1-Ubuntu
>  Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 2.5.4 01/13/2020
>  RIP: 0010:ixgbe_xmit_xdp_ring+0x1b/0x1c0 [ixgbe]
>  Code: 3b 52 d4 cf e9 42 f2 ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 55 b9
>  00 00 00 00 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 <44> 0f b7
>  47 58 0f b7 47 5a 0f b7 57 54 44 0f b7 76 08 66 41 39 c0
>  RSP: 0018:ffffbc3fcd88fcb0 EFLAGS: 00010282
>  RAX: ffff92a253260980 RBX: ffffbc3fe68b00a0 RCX: 0000000000000000
>  RDX: ffff928b5f659000 RSI: ffff928b5f659000 RDI: 0000000000000000
>  RBP: ffffbc3fcd88fce0 R08: ffff92b9dfc20580 R09: 0000000000000001
>  R10: 3d3d3d3d3d3d3d3d R11: 3d3d3d3d3d3d3d3d R12: 0000000000000000
>  R13: ffff928b2f0fa8c0 R14: ffff928b9be20050 R15: 000000000000003c
>  FS:  0000000000000000(0000) GS:ffff92b9dfc00000(0000)
>  knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000058 CR3: 000000011dd6a002 CR4: 00000000007706e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  PKRU: 55555554
>  Call Trace:
>   <TASK>
>   ixgbe_poll+0x103e/0x1280 [ixgbe]
>   ? sched_clock_cpu+0x12/0xe0
>   __napi_poll+0x30/0x160
>   net_rx_action+0x11c/0x270
>   __do_softirq+0xda/0x2ee
>   run_ksoftirqd+0x2f/0x50
>   smpboot_thread_fn+0xb7/0x150
>   ? sort_range+0x30/0x30
>   kthread+0x127/0x150
>   ? set_kthread_struct+0x50/0x50
>   ret_from_fork+0x1f/0x30
>   </TASK>
>
> I think this is how it happens:
>
> Upon loading the first XDP program on a system with more than 64 CPUs,
> ixgbe_xdp_locking_key is incremented in ixgbe_xdp_setup.  However,
> immediately after this, the rings are reconfigured by ixgbe_setup_tc.
> ixgbe_setup_tc calls ixgbe_clear_interrupt_scheme which calls
> ixgbe_free_q_vectors which calls ixgbe_free_q_vector in a loop.
> ixgbe_free_q_vector decrements ixgbe_xdp_locking_key once per call if
> it is non-zero.  Commenting out the decrement in ixgbe_free_q_vector
> stopped my system from panicing.
>
> I suspect to make the original patch work, I would need to load an XDP
> program and then replace it in order to get ixgbe_xdp_locking_key back
> above 0 since ixgbe_setup_tc is only called when transitioning between
> XDP and non-XDP ring configurations, while ixgbe_xdp_locking_key is
> incremented every time ixgbe_xdp_setup is called.
>
> Also, ixgbe_setup_tc can be called via ethtool --set-channels, so this
> becomes another path to decrement ixgbe_xdp_locking_key to 0 on systems
> with greater than 64 CPUs.
>
> For this patch, I have changed static_branch_inc to static_branch_enable
> in ixgbe_setup_xdp.  We weren't counting references.  The
> ixgbe_xdp_locking_key only protects code in the XDP_TX path, which is
> not run when an XDP program is loaded.  The other condition for setting
> it on is the number of CPUs, which I assume is static.
>
> Fixes: 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
> Signed-off-by: John Hickey <jjh@daedalian.us>
> ---
> v1 -> v2:
>         Added Fixes and net tag.  No code changes.
> v2 -> v3:
>         Added splat.  Slight clarification as to why ixgbe_xdp_locking_ke=
y
>         is not turned off.  Based on feedback from Maciej Fijalkowski.
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 3 ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
>  2 files changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/e=
thernet/intel/ixgbe/ixgbe_lib.c
> index f8156fe4b1dc..0ee943db3dc9 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> @@ -1035,9 +1035,6 @@ static void ixgbe_free_q_vector(struct ixgbe_adapte=
r *adapter, int v_idx)
>         adapter->q_vector[v_idx] =3D NULL;
>         __netif_napi_del(&q_vector->napi);
>
> -       if (static_key_enabled(&ixgbe_xdp_locking_key))
> -               static_branch_dec(&ixgbe_xdp_locking_key);
> -

Seems like you still didn't add another pair (enable VS disable)
static_branch_disable() to switch off this static key as Maciej
Fijalkowski suggested on top of your 1st patch.

Since we use this static key indicating that we switch it on at the
very beginning, we also need to switch it off in turn as its life
cycle comes to an end.

For me, I would recommend to use _inc/_dec to control the whole thing
even though it's relatively more complicated to balance the uses of
the inc and dec pairs.

Never mind, enable/disable can work well if maintainers don't have
opinions on this.

Thanks,
Jason

>         /*
>          * after a call to __netif_napi_del() napi may still be used and
>          * ixgbe_get_stats64() might access the rings on this vector,
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/=
ethernet/intel/ixgbe/ixgbe_main.c
> index ab8370c413f3..cd2fb72c67be 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -10283,7 +10283,7 @@ static int ixgbe_xdp_setup(struct net_device *dev=
, struct bpf_prog *prog)
>         if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
>                 return -ENOMEM;
>         else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
> -               static_branch_inc(&ixgbe_xdp_locking_key);
> +               static_branch_enable(&ixgbe_xdp_locking_key);
>
>         old_prog =3D xchg(&adapter->xdp_prog, prog);
>         need_reset =3D (!!prog !=3D !!old_prog);
> --
> 2.37.2
>
