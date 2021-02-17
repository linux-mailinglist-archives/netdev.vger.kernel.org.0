Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F05831E2C5
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbhBQWtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbhBQWrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 17:47:51 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D155C06178A;
        Wed, 17 Feb 2021 14:47:09 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u11so118420plg.13;
        Wed, 17 Feb 2021 14:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Fcdb04V+fBPSZF/9QZvFn1c+w46Z155nAjFAvh/wzo0=;
        b=cr+IqtepVDo5ZZ93m4Gsp00kdZtF6z7HPHB8IbmJQLF/eUTjR4qIOTjENs05S/zkj8
         kWmUJ2PLAvPQuYOGEjP2R1KSzcQSxQfU2/ddTgY34Hn/UmbGHyUIOBhqGc45kxcFsBcR
         bQbzpKcFFmErqeKsUY9hA+Tn3T0yuTtLduB6cxpqMy5XCsnIcfAzKgD/CFo5A+AOthVt
         y8mJizP9xVhJOLEabxD1w74v+wgZfohzEpy2Alp40yv9BN05uQwCQ0/KT4i1xc10kN0F
         HzWUDnWP/Hoiy25Ksvyt2k+NTAhjy1eHYwMr8kReRo+xDolHCyDFqUMEi0YiunMmasDb
         mTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Fcdb04V+fBPSZF/9QZvFn1c+w46Z155nAjFAvh/wzo0=;
        b=QK2a7ZRcVHVQwjonjDAC8tuPQ1+5QyaOxAQr2nqSrYbcqcCOF0CMt3FCmqh/0eHdU7
         1XYy57HQmfqFX/s416+gaDYMvPsptKhN286jWAabp2hkp0GmWwlCmxHHpfBMT/7kQ3Cw
         K6fIB5UBZ1C16cxAYCF36NUpeF37w9h3gPOxkNU1uPn/pXVoDOcrgTDOBdNLA2B0usF4
         Q8uxBIu7gAlBTZ9yTUxr1SnV3RYiqsxsWAw8fqw4Oa1mXOSqLmFgpYPCEIaZXxRzCrik
         MqF59GF+A+ntCYx6fCxs6TjnXkm/YzkJ9R7mvJ93Y24B1HEC0odTJkm4tTAJkA/8EEzB
         QsAg==
X-Gm-Message-State: AOAM531H4jTMuhB8nCYXdp25Rg/y9s4xQu5X21+ShkXeRcJCuY3vGu03
        WXF4TqFA3ofHqEfm36Rfyp0gjbzmRVayZfcQuFM=
X-Google-Smtp-Source: ABdhPJyWPOIuaZT4SHAxmahg012hbD1nGkIk3nf4D6eEre74vQkrgV1EMUGat8SvZVGHzzt6xPkO/8mZ4K9sYEeTn9o=
X-Received: by 2002:a17:90a:cb13:: with SMTP id z19mr1048174pjt.52.1613602029200;
 Wed, 17 Feb 2021 14:47:09 -0800 (PST)
MIME-Version: 1.0
References: <20210217035844.53746-1-xiyou.wangcong@gmail.com> <c24360ab-f4b3-db61-4c83-9fb941520304@iogearbox.net>
In-Reply-To: <c24360ab-f4b3-db61-4c83-9fb941520304@iogearbox.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 17 Feb 2021 14:46:57 -0800
Message-ID: <CAM_iQpX1GLG5SW7z5GRTntXTj0-Zvh84BKaOV_5r1akx9rGEOg@mail.gmail.com>
Subject: Re: [Patch bpf-next] bpf: clear per_cpu pointers in bpf_prog_clone_create()
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 2:01 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 2/17/21 4:58 AM, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Pretty much similar to commit 1336c662474e
> > ("bpf: Clear per_cpu pointers during bpf_prog_realloc") we also need to
> > clear these two percpu pointers in bpf_prog_clone_create(), otherwise
> > would get a double free:
> >
> >   BUG: kernel NULL pointer dereference, address: 0000000000000000
> >   #PF: supervisor read access in kernel mode
> >   #PF: error_code(0x0000) - not-present page
> >   PGD 0 P4D 0
> >   Oops: 0000 [#1] SMP PTI
> >   CPU: 13 PID: 8140 Comm: kworker/13:247 Kdump: loaded Tainted: G=E2=80=
=86        W=E2=80=86  OE
> >  5.11.0-rc4.bm.1-amd64+ #1
> >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 =
04/01/2014
> >   test_bpf: #1 TXA
> >   Workqueue: events bpf_prog_free_deferred
> >   RIP: 0010:percpu_ref_get_many.constprop.97+0x42/0xf0
> >   Code: [...]
> >   RSP: 0018:ffffa6bce1f9bda0 EFLAGS: 00010002
> >   RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000021dfc7b
> >   RDX: ffffffffae2eeb90 RSI: 867f92637e338da5 RDI: 0000000000000046
> >   RBP: ffffa6bce1f9bda8 R08: 0000000000000000 R09: 0000000000000001
> >   R10: 0000000000000046 R11: 0000000000000000 R12: 0000000000000280
> >   R13: 0000000000000000 R14: 0000000000000000 R15: ffff9b5f3ffdedc0
> >   FS:=E2=80=86  0000000000000000(0000) GS:ffff9b5f2fb40000(0000) knlGS:=
0000000000000000
> >   CS:=E2=80=86  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   CR2: 0000000000000000 CR3: 000000027c36c002 CR4: 00000000003706e0
> >   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >   Call Trace:
> >   refill_obj_stock+0x5e/0xd0
> >   free_percpu+0xee/0x550
> >   __bpf_prog_free+0x4d/0x60
> >   process_one_work+0x26a/0x590
> >   worker_thread+0x3c/0x390
> >   ? process_one_work+0x590/0x590
> >   kthread+0x130/0x150
> >   ? kthread_park+0x80/0x80
> >   ret_from_fork+0x1f/0x30
> >
> > This bug is 100% reproducible with test_kmod.sh.
> >
> > Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> > Fixes: 700d4796ef59 ("bpf: Optimize program stats")
> > Fixes: ca06f55b9002 ("bpf: Add per-program recursion prevention mechani=
sm")
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >   kernel/bpf/core.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index 0ae015ad1e05..b0c11532e535 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -1103,6 +1103,8 @@ static struct bpf_prog *bpf_prog_clone_create(str=
uct bpf_prog *fp_other,
> >                * this still needs to be adapted.
> >                */
> >               memcpy(fp, fp_other, fp_other->pages * PAGE_SIZE);
> > +             fp_other->stats =3D NULL;
> > +             fp_other->active =3D NULL;
> >       }
> >
> >       return fp;
> >
>
> This is not correct. I presume if you enable blinding and stats, then thi=
s will still

Well, at least I ran all BPF selftests and found no crash. (Before my patch=
, the
crash happened 100%.)

> crash. The proper way to fix it is to NULL these pointers in bpf_prog_clo=
ne_free()
> since the clone can be promoted as the actual prog and the prog ptr relea=
sed instead.
>

Not sure if I understand your point, but what I cleared is fp_other,
which is the original, not the clone. And of course, the original would
be overriden:

        tmp =3D bpf_jit_blind_constants(prog);
        if (IS_ERR(tmp))
                return orig_prog;
        if (tmp !=3D prog) {
                tmp_blinded =3D true;
                prog =3D tmp;  // <=3D=3D=3D HERE
        }

I think this is precisely why the crash does not happen after my patch.

However, it does seem to me patching bpf_prog_clone_free() is better,
as there would be no assumption on using the original. All I want to
say here is that both ways could fix the crash, which one is better is
arguable.

Thanks.
