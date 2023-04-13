Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910CE6E0EFF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjDMNk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbjDMNjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:39:55 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CCECC39
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:37:16 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id u13so15465157ybu.5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681392991; x=1683984991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H15P0TrhKruU9mg7/GZWeh+u70X4p/YOp70eA1qaQxI=;
        b=3POn3EMWccVmnVynl/mp44nRqATNw7iAPfaVxyMGoSKqc2Sr6zlplvRIG6g4vnCFzU
         W2gDDDe23hsw+Ct9obcRWN0ZyzSQA72TQuEUugxJ6y0Im1sOQdsJhFlLirVeLFx74Lxg
         CNXtQS3jxH0EYnvAjtpJNy6lDzC6GFSIZELwM15eLVez8vO7bN+OrUBOBhXsBYsWL6zI
         QWeqC3AyJaNENGVjAnJOfunoudoRljfwIw2aRDZwJ5IgvwhT/MprjOHEEH+TrZ1j7apX
         7N+GWck33YM+NwxfKleAaqQJaWnUqJThNxlJDCXSN2ND7W6Nx95JZTmBBqQn6GbJWY9o
         xOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681392991; x=1683984991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H15P0TrhKruU9mg7/GZWeh+u70X4p/YOp70eA1qaQxI=;
        b=YD8GtWmXDoLiVX30pK1KQLcP555n4AUcg1pb4mnzVob4Grbl9tLj+tBSXcJhD80tks
         r8HtSrh2LMplBFpZ7XJX6fq/mt8+6K1fEfEP902rm5W+I8dT7RNHM576HM6ubI6Uvl+x
         bN1b78KRYFQZtOlcjyE/EgzsGBX/FeR65UKL4hlaZ1vUZwZa73gn+2ZSpzYa+wVKXt/8
         gEROm8s9EzX/E3Yz3/78Hr+GUYLMqJyGtbB0rMR2IWXaUQHYNOVbe1Zsf4YQL7GKzMMD
         Tsc9NxMAdxCn9BCtDr8B6bflK0t/C/gShOh8y3lAHbIoAaAexOcbXpxOzZxztVjYKq/X
         1/Sw==
X-Gm-Message-State: AAQBX9fgTddtK0eVkIRwe6JfLUiNUTRxrAQwnPtwWGI1g8fc4fVw0SSs
        fwVSgR3mQ7EVKRrwUpVhJYJsI3U7S077mkV9nHLzZw==
X-Google-Smtp-Source: AKy350ZTpbMwdEfIkwoJxIFYhSXI/YMROpcfCRkH+N7YSRatn2POhzv1F36p9PlcAgAD0k+x6Z3wus9ah83BVonB7wU=
X-Received: by 2002:a25:d7ce:0:b0:b8f:52bd:54cb with SMTP id
 o197-20020a25d7ce000000b00b8f52bd54cbmr1149207ybg.2.1681392991565; Thu, 13
 Apr 2023 06:36:31 -0700 (PDT)
MIME-Version: 1.0
References: <ZDfbCsDa6oLKzsed@pr0lnx>
In-Reply-To: <ZDfbCsDa6oLKzsed@pr0lnx>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 13 Apr 2023 09:36:20 -0400
Message-ID: <CAM0EoMnTMqEHvB0UXakMf6iBwb45prb+W5xKKVRwaX3q=awBVw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: sched: sch_qfq: prevent slab-out-of-bounds in qfq_activate_agg
To:     Gwangun Jung <exsociety@gmail.com>
Cc:     pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 6:35=E2=80=AFAM Gwangun Jung <exsociety@gmail.com> =
wrote:
>
> If the TCA_QFQ_LMAX value is not offered through nlattr, lmax is determin=
ed by the MTU value of the network device.
> The MTU of the loopback device can be set up to 2^31-1.
> As a result, it is possible to have an lmax value that exceeds QFQ_MIN_LM=
AX.
>
> Due to the invalid lmax value, an index is generated that exceeds the QFQ=
_MAX_INDEX(=3D24) value, causing out-of-bounds read/write errors.
>
> The following reports a oob access:
>
> [   84.582666] BUG: KASAN: slab-out-of-bounds in qfq_activate_agg.constpr=
op.0 (net/sched/sch_qfq.c:1027 net/sched/sch_qfq.c:1060 net/sched/sch_qfq.c=
:1313)
> [   84.583267] Read of size 4 at addr ffff88810f676948 by task ping/301
> [   84.583686]
> [   84.583797] CPU: 3 PID: 301 Comm: ping Not tainted 6.3.0-rc5 #1
> [   84.584164] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.15.0-1 04/01/2014
> [   84.584644] Call Trace:
> [   84.584787]  <TASK>
> [   84.584906] dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
> [   84.585108] print_report (mm/kasan/report.c:320 mm/kasan/report.c:430)
> [   84.585570] kasan_report (mm/kasan/report.c:538)
> [   84.585988] qfq_activate_agg.constprop.0 (net/sched/sch_qfq.c:1027 net=
/sched/sch_qfq.c:1060 net/sched/sch_qfq.c:1313)
> [   84.586599] qfq_enqueue (net/sched/sch_qfq.c:1255)
> [   84.587607] dev_qdisc_enqueue (net/core/dev.c:3776)
> [   84.587749] __dev_queue_xmit (./include/net/sch_generic.h:186 net/core=
/dev.c:3865 net/core/dev.c:4212)
> [   84.588763] ip_finish_output2 (./include/net/neighbour.h:546 net/ipv4/=
ip_output.c:228)
> [   84.589460] ip_output (net/ipv4/ip_output.c:430)
> [   84.590132] ip_push_pending_frames (./include/net/dst.h:444 net/ipv4/i=
p_output.c:126 net/ipv4/ip_output.c:1586 net/ipv4/ip_output.c:1606)
> [   84.590285] raw_sendmsg (net/ipv4/raw.c:649)
> [   84.591960] sock_sendmsg (net/socket.c:724 net/socket.c:747)
> [   84.592084] __sys_sendto (net/socket.c:2142)
> [   84.593306] __x64_sys_sendto (net/socket.c:2150)
> [   84.593779] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/c=
ommon.c:80)
> [   84.593902] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:=
120)
> [   84.594070] RIP: 0033:0x7fe568032066
> [   84.594192] Code: 0e 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0=
f 1f 00 41 89 ca 64 8b 04 25 18 00 00 00 85 c09[ 84.594796] RSP: 002b:00007=
ffce388b4e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   84.595047] RAX: ffffffffffffffda RBX: 00007ffce388cc70 RCX: 00007fe56=
8032066
> [   84.595281] RDX: 0000000000000040 RSI: 00005605fdad6d10 RDI: 000000000=
0000003
> [   84.595515] RBP: 00005605fdad6d10 R08: 00007ffce388eeec R09: 000000000=
0000010
> [   84.595749] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000=
0000040
> [   84.595984] R13: 00007ffce388cc30 R14: 00007ffce388b4f0 R15: 0000001d0=
0000001
> [   84.596218]  </TASK>
> [   84.596295]
> [   84.596351] Allocated by task 291:
> [   84.596467] kasan_save_stack (mm/kasan/common.c:46)
> [   84.596597] kasan_set_track (mm/kasan/common.c:52)
> [   84.596725] __kasan_kmalloc (mm/kasan/common.c:384)
> [   84.596852] __kmalloc_node (./include/linux/kasan.h:196 mm/slab_common=
.c:967 mm/slab_common.c:974)
> [   84.596979] qdisc_alloc (./include/linux/slab.h:610 ./include/linux/sl=
ab.h:731 net/sched/sch_generic.c:938)
> [   84.597100] qdisc_create (net/sched/sch_api.c:1244)
> [   84.597222] tc_modify_qdisc (net/sched/sch_api.c:1680)
> [   84.597357] rtnetlink_rcv_msg (net/core/rtnetlink.c:6174)
> [   84.597495] netlink_rcv_skb (net/netlink/af_netlink.c:2574)
> [   84.597627] netlink_unicast (net/netlink/af_netlink.c:1340 net/netlink=
/af_netlink.c:1365)
> [   84.597759] netlink_sendmsg (net/netlink/af_netlink.c:1942)
> [   84.597891] sock_sendmsg (net/socket.c:724 net/socket.c:747)
> [   84.598016] ____sys_sendmsg (net/socket.c:2501)
> [   84.598147] ___sys_sendmsg (net/socket.c:2557)
> [   84.598275] __sys_sendmsg (./include/linux/file.h:31 net/socket.c:2586=
)
> [   84.598399] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/c=
ommon.c:80)
> [   84.598520] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:=
120)
> [   84.598688]
> [   84.598744] The buggy address belongs to the object at ffff88810f67400=
0
> [   84.598744]  which belongs to the cache kmalloc-8k of size 8192
> [   84.599135] The buggy address is located 2664 bytes to the right of
> [   84.599135]  allocated 7904-byte region [ffff88810f674000, ffff88810f6=
75ee0)
> [   84.599544]
> [   84.599598] The buggy address belongs to the physical page:
> [   84.599777] page:00000000e638567f refcount:1 mapcount:0 mapping:000000=
0000000000 index:0x0 pfn:0x10f670
> [   84.600074] head:00000000e638567f order:3 entire_mapcount:0 nr_pages_m=
apped:0 pincount:0
> [   84.600330] flags: 0x200000000010200(slab|head|node=3D0|zone=3D2)
> [   84.600517] raw: 0200000000010200 ffff888100043180 dead000000000122 00=
00000000000000
> [   84.600764] raw: 0000000000000000 0000000080020002 00000001ffffffff 00=
00000000000000
> [   84.601009] page dumped because: kasan: bad access detected
> [   84.601187]
> [   84.601241] Memory state around the buggy address:
> [   84.601396]  ffff88810f676800: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.601620]  ffff88810f676880: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.601845] >ffff88810f676900: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.602069]                                               ^
> [   84.602243]  ffff88810f676980: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.602468]  ffff88810f676a00: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
> [   84.602693] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   84.602924] Disabling lock debugging due to kernel taint
>
> Fixes: 3015f3d2a3cd ("pkt_sched: enable QFQ to support TSO/GSO")
> Reported-by: Gwangun Jung <exsociety@gmail.com>
> Signed-off-by: Gwangun Jung <exsociety@gmail.com>
> ---
>  net/sched/sch_qfq.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
> index cf5ebe43b3b4..02098a02943e 100644
> --- a/net/sched/sch_qfq.c
> +++ b/net/sched/sch_qfq.c
> @@ -421,15 +421,16 @@ static int qfq_change_class(struct Qdisc *sch, u32 =
classid, u32 parentid,
>         } else
>                 weight =3D 1;
>
> -       if (tb[TCA_QFQ_LMAX]) {
> +       if (tb[TCA_QFQ_LMAX])
>                 lmax =3D nla_get_u32(tb[TCA_QFQ_LMAX]);
> -               if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT))=
 {
> -                       pr_notice("qfq: invalid max length %u\n", lmax);
> -                       return -EINVAL;
> -               }
> -       } else
> +       else
>                 lmax =3D psched_mtu(qdisc_dev(sch));
>
> +       if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
> +               pr_notice("qfq: invalid max length %u\n", lmax);
> +               return -EINVAL;
> +       }
> +
>         inv_w =3D ONE_FP / weight;
>         weight =3D ONE_FP / inv_w;
>

Acked-by: Jamal Hadi Salim<jhs@mojatatu.com>

cheers,
jamal
