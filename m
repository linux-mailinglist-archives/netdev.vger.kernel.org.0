Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4DF459FB68
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237624AbiHXNbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiHXNbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:31:08 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F71274BAC
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:31:07 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-3375488624aso430854877b3.3
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=w2b8e9hO7/gpS1qYIlZoa+enOVX2XnWjFsj+OhWz5S0=;
        b=esZVALWvxHVhLdoaoHFAAxaNC7U1EqPSg8jNxvsKB+w8lYsaCdm9fq/bf4W2se/HHn
         We0THSi7sq+npYRWYm7abNfVjyAtIRI7YAffV0F4+DdSIMY8V0k5mCE8/HXKdxoKaxbt
         XhLI/UiSdMN1QY25FdZ5dWFQMzBzsKG1g+d5U+ob+g2JZZSm2ZHjWsao2bQDPXOCsJ4Q
         4T8X6ZPeqVE5GfcjTnqx0rJp3TBla6B9sr/P3MosAw2A5OCz6uyIvLGl5zouKGVju6EC
         6g7fHctAtw0WZPSujBsc9E0fzOdTwf11faQCiLzLSBcpR/x+hv0ULGmi+M9fEbRsWPK7
         uydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=w2b8e9hO7/gpS1qYIlZoa+enOVX2XnWjFsj+OhWz5S0=;
        b=8PKt81bymx+FjjDFsemwizehvgvUfk4yNji7U0Hzy3O8zS3nQEW/dNtoNs8gIMesNb
         q+X01B0WCyvvfcy57P2zGZJ5eo/u+rZEpFMvmu7AMvtaeflACm7nGypny6p9w/BR+VSs
         jw8Xd712YynogvwlwfwFtnzqnT4G5TaFZi1CayOXmcuEVeiTrs4e7sH1ixtVyaG+TXFh
         wRb8V396HlRzTWWDQJBOn7RDSNyrUlrF8ciJr8hICZkMP5s/zMefhfzDxlFrwhZO3Nsl
         ghsk8a2VIx2wL9mkynrYicsFIqV4iYUk/uDq5ty6JoaTksYe8OxLR2oaujVOiy0dcvy7
         b8pQ==
X-Gm-Message-State: ACgBeo0cUHgRV9LMRtar7fCL1a/IjTEBjkzAU3sEbxKyEV4B6OdhBaeg
        9Z9P9MH4u7z2mCnK2gKlW4tPRQQqw60FrGOJbUTprQ==
X-Google-Smtp-Source: AA6agR7qwrg3dKyo6HjbXmNHYvni+LXXavSrEOfsr6D8aekioQPGAP4dL6tu9zepeQQbL7syGRM8IJI5h/KUI3lnfeM=
X-Received: by 2002:a0d:c7c3:0:b0:31e:9622:c4f6 with SMTP id
 j186-20020a0dc7c3000000b0031e9622c4f6mr31190064ywd.144.1661347863538; Wed, 24
 Aug 2022 06:31:03 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c98a7f05ac744f53@google.com> <000000000000734fe705acb9f3a2@google.com>
 <a142d63c-7810-40ff-9c24-7160c63bafebn@googlegroups.com>
In-Reply-To: <a142d63c-7810-40ff-9c24-7160c63bafebn@googlegroups.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Wed, 24 Aug 2022 15:30:25 +0200
Message-ID: <CAG_fn=U=Vfv3ymNM6W++sbivieQoUuXfAxsC9SsmdtQiTjSi8g@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in ath9k_htc_rx_msg
To:     syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Cc:     ath9k-devel@qca.qualcomm.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvalo@codeaurora.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, phil@philpotter.co.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(adding back people originally CCed on the syzkaller bug.
Unfortunately it isn't possible to reply to all in Google Groups)

On Wed, Aug 24, 2022 at 3:26 PM Alexander Potapenko <glider@google.com> wro=
te:
>
>
>
> On Thursday, August 13, 2020 at 5:32:17 AM UTC+2 syzbot wrote:
>>
>> syzbot has found a reproducer for the following issue on:
>>
>> HEAD commit: ce8056d1 wip: changed copy_from_user where instrumented
>> git tree: https://github.com/google/kmsan.git master
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D12985a169000=
00
>> kernel config: https://syzkaller.appspot.com/x/.config?x=3D3afe005fb9959=
1f
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D2ca247c2d60c70=
23de7f
>> compiler: clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2=
443155a0fb245c8f17f2c1c72b6ea391e86e81)
>> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=3D1468efe2900000
>> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=3D10bb9fba900000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the com=
mit:
>> Reported-by: syzbot+2ca247...@syzkaller.appspotmail.com
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>> BUG: KMSAN: uninit-value in ath9k_htc_rx_msg+0x28f/0x1f50 drivers/net/wi=
reless/ath/ath9k/htc_hst.c:410
>> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.8.0-rc5-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 01/01/2011
>> Call Trace:
>> <IRQ>
>> __dump_stack lib/dump_stack.c:77 [inline]
>> dump_stack+0x21c/0x280 lib/dump_stack.c:118
>> kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
>> __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
>> ath9k_htc_rx_msg+0x28f/0x1f50 drivers/net/wireless/ath/ath9k/htc_hst.c:4=
10
>> ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:638 [in=
line]
>> ath9k_hif_usb_rx_cb+0x1841/0x1d10 drivers/net/wireless/ath/ath9k/hif_usb=
.c:671
>> __usb_hcd_giveback_urb+0x687/0x870 drivers/usb/core/hcd.c:1650
>> usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1716
>> dummy_timer+0xd98/0x71c0 drivers/usb/gadget/udc/dummy_hcd.c:1967
>> call_timer_fn+0x226/0x550 kernel/time/timer.c:1404
>> expire_timers+0x4fc/0x780 kernel/time/timer.c:1449
>> __run_timers+0xaf4/0xd30 kernel/time/timer.c:1773
>> run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
>> __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
>> asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
>> </IRQ>
>> __run_on_irqstack arch/x86/include/asm/irq_stack.h:23 [inline]
>> run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
>> do_softirq_own_stack+0x7c/0xa0 arch/x86/kernel/irq_64.c:77
>> invoke_softirq kernel/softirq.c:390 [inline]
>> __irq_exit_rcu+0x226/0x270 kernel/softirq.c:420
>> irq_exit_rcu+0xe/0x10 kernel/softirq.c:432
>> sysvec_apic_timer_interrupt+0x107/0x130 arch/x86/kernel/apic/apic.c:1091
>> asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.=
h:593
>> RIP: 0010:native_irq_disable arch/x86/include/asm/irqflags.h:49 [inline]
>> RIP: 0010:arch_local_irq_disable arch/x86/include/asm/irqflags.h:89 [inl=
ine]
>> RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
>> RIP: 0010:acpi_idle_do_entry drivers/acpi/processor_idle.c:525 [inline]
>> RIP: 0010:acpi_idle_enter+0x817/0xeb0 drivers/acpi/processor_idle.c:651
>> Code: 85 db 74 0a f7 d3 44 21 fb 48 85 db 74 32 4d 85 ff 75 3a 48 8b 5d =
a0 e9 0c 00 00 00 e8 12 b2 78 fb 0f 00 2d 25 15 1c 0b fb f4 <fa> eb 5a 84 c=
0 8b 7d 90 0f 45 7d 94 e8 d8 9a f4 fb e9 74 fc ff ff
>> RSP: 0018:ffff88812df93bc8 EFLAGS: 00000246
>> RAX: 0000000000000000 RBX: ffff8881dfefce70 RCX: 000000012db88000
>> RDX: ffff88812df88000 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: ffff88812df93ca0 R08: ffffffff86420acc R09: ffff88812fffa000
>> R10: 0000000000000002 R11: ffff88812df88000 R12: ffff88812df889d8
>> R13: ffff8881dfefcc64 R14: 0000000000000000 R15: 0000000000000000
>> cpuidle_enter_state+0x860/0x12b0 drivers/cpuidle/cpuidle.c:235
>> cpuidle_enter+0xe3/0x170 drivers/cpuidle/cpuidle.c:346
>> call_cpuidle kernel/sched/idle.c:126 [inline]
>> cpuidle_idle_call kernel/sched/idle.c:214 [inline]
>> do_idle+0x668/0x810 kernel/sched/idle.c:276
>> cpu_startup_entry+0x45/0x50 kernel/sched/idle.c:372
>> start_secondary+0x1bf/0x240 arch/x86/kernel/smpboot.c:268
>> secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:243
>>
>> Uninit was created at:
>> kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
>> kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
>> kmsan_alloc_page+0xc5/0x1a0 mm/kmsan/kmsan_shadow.c:293
>> __alloc_pages_nodemask+0xdf0/0x1030 mm/page_alloc.c:4889
>> __alloc_pages include/linux/gfp.h:509 [inline]
>> __alloc_pages_node include/linux/gfp.h:522 [inline]
>> alloc_pages_node include/linux/gfp.h:536 [inline]
>> __page_frag_cache_refill mm/page_alloc.c:4964 [inline]
>> page_frag_alloc+0x35b/0x880 mm/page_alloc.c:4994
>> __netdev_alloc_skb+0x2a8/0xc90 net/core/skbuff.c:451
>> __dev_alloc_skb include/linux/skbuff.h:2813 [inline]
>> ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:620 [in=
line]
>> ath9k_hif_usb_rx_cb+0xe5a/0x1d10 drivers/net/wireless/ath/ath9k/hif_usb.=
c:671
>> __usb_hcd_giveback_urb+0x687/0x870 drivers/usb/core/hcd.c:1650
>> usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1716
>> dummy_timer+0xd98/0x71c0 drivers/usb/gadget/udc/dummy_hcd.c:1967
>> call_timer_fn+0x226/0x550 kernel/time/timer.c:1404
>> expire_timers+0x4fc/0x780 kernel/time/timer.c:1449
>> __run_timers+0xaf4/0xd30 kernel/time/timer.c:1773
>> run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
>> __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>>
>
> This bug bites us quite often on syzbot: https://syzkaller.appspot.com/bu=
g?id=3D659ddf411502a2fe220c8f9be696d5a8d8db726e (17k crashes)
> The patch below by phil@philpotter.co.uk (https://syzkaller.appspot.com/t=
ext?tag=3DPatch&x=3D173dcb51d00000) seems to fix the problem, but I have no=
 idea what's going on there.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wirel=
ess/ath/ath9k/htc_hst.c
> index 510e61e97dbc..9dbfff7a388e 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -403,7 +403,7 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
>      struct htc_endpoint *endpoint;
>      __be16 *msg_id;
>
> -    if (!htc_handle || !skb)
> +    if (!htc_handle || !skb || !pskb_may_pull(skb, sizeof(struct htc_fra=
me_hdr)))
>          return;
>
>      htc_hdr =3D (struct htc_frame_hdr *) skb->data;
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
