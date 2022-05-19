Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A483C52D6C0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240481AbiESPDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240320AbiESPC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:02:57 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD7CEC322
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:01:49 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id u30so9601234lfm.9
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g2iR/GvonzPEkGcOKxVcDjAfsuXSBx9Hn0L+1eWPrSQ=;
        b=HYAMB4AH5gGz4FKZpC2Pc3mwADJ6aR5PiQjCis0N7SlAr8kC+vXCm5Hzs+VdDUuUx8
         GtWWXgWyQi9xlLdHQ5SmUrcWRoNb1kVvTwaLJNIaTqno1NCCvCSnr+6tA1XCiZLZbNi1
         7iV10GDmU+Oz5id5Bf6XxNnO7W+IAVjq1mTWw3jRs6eTeBfRu2v1rXL/FxyUL7BlQMhl
         y+WChPaYFAr/Rl1/11pqisqSbS9p2yR+ofZ0NreKNON8BDBtcMK7cJZErvyT5TrVGnVl
         Geig/30uhj0y4d2AU/Mk/BMB639SSrkn93FwJPGkscb/NPyxchmNnzmTvwl7hyDiBec0
         qiiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g2iR/GvonzPEkGcOKxVcDjAfsuXSBx9Hn0L+1eWPrSQ=;
        b=i3jYFfkKlbXqu8t2OIbBBQ2xz1caaTrFTT+Vmc2POSj5obFCBzb4ZYUMpCzyagFWtn
         ygVXyBZmJqUwnblqiold83nqBx9Y076OfjEstQJLAHEAXMvxYsFGVh1vB12eJ8iwmWhG
         BiVA38D6N+WOp4lew8WHGz2Ucij6s4nNFbzFhzcM7uo2n6MCcdY0J70xVLG+3PEwbMte
         IXkFlZVB+/g8xhaxeX5FSgRKfaGvh8idWZ0t/Rir/WXQZ3TJz3OSAfpQAcOwfx2gKipV
         LKxxHw7pDa4zxC/Z2uC0Zce26jgQdAgbgwbhhMnrfjBKugiZCucFJ+oC2zTv+KGif/L/
         PGKA==
X-Gm-Message-State: AOAM530iXblRuteEwJrvNyFaSsF04lVOCrdsvG2P7/MpOMATMK3nDrGg
        6A15NjjEIVp4srhAgVH/6q5cAAg/JKPR7XG/XSUcrw==
X-Google-Smtp-Source: ABdhPJxw0Qbv9d+Xa7jvzrMcSnlYgfnl0FJGdgzk2/rToRD69bZ1rlXMTUlSZqgE16jOYnli1h1X36nomx5EWTFTuhk=
X-Received: by 2002:a05:6512:114d:b0:473:b1ba:e589 with SMTP id
 m13-20020a056512114d00b00473b1bae589mr3804418lfg.206.1652972506965; Thu, 19
 May 2022 08:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000367c2205d2549cb9@google.com> <0000000000009fa8ee05d60428f1@google.com>
 <CAOMGZ=E9Gmv6Fb_pi4p9RhQ_MvJVYs_6rkf37XfG0DYEMFNbNA@mail.gmail.com>
In-Reply-To: <CAOMGZ=E9Gmv6Fb_pi4p9RhQ_MvJVYs_6rkf37XfG0DYEMFNbNA@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 19 May 2022 17:01:35 +0200
Message-ID: <CACT4Y+biE2wCBcD6Z4vdVfKRpJMsRWYGjCjiiC+Ho2D91Qv-Qg@mail.gmail.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in __bpf_prog_put
To:     Vegard Nossum <vegard.nossum@gmail.com>
Cc:     syzbot <syzbot+5027de09e0964fd78ce1@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, "David S. Miller" <davem@davemloft.net>,
        fgheet255t@gmail.com, hawk@kernel.org, jakub@cloudflare.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lmb@cloudflare.com, Linux Netdev List <netdev@vger.kernel.org>,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 at 12:42, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
> On Thu, 20 Jan 2022 at 15:17, syzbot
> <syzbot+5027de09e0964fd78ce1@syzkaller.appspotmail.com> wrote:
> >
> > syzbot suspects this issue was fixed by commit:
> >
> > commit 218d747a4142f281a256687bb513a135c905867b
> > Author: John Fastabend <john.fastabend@gmail.com>
> > Date:   Tue Jan 4 21:46:45 2022 +0000
> >
> >     bpf, sockmap: Fix double bpf_prog_put on error case in map_link
>
> I can confirm the above commit fixes the issue, but it references a
> slightly different report. Looks like the only difference is
> __bpf_prog_put instead of bpf_prog_put:
>
> KASAN: vmalloc-out-of-bounds Read in __bpf_prog_put
> KASAN: vmalloc-out-of-bounds Read in bpf_prog_put
>
> However, looking at the stack traces for the two bugs shows that
> __bpf_prog_put() is really the location for both reports, see:
>
> https://syzkaller.appspot.com/bug?id=797cd651dd0d9bd921e4fa51b792f5afdc3f390f
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:450 mm/kasan/report.c:450
>  __bpf_prog_put.constprop.0+0x1dd/0x220 kernel/bpf/syscall.c:1812
> kernel/bpf/syscall.c:1812
>  bpf_prog_put kernel/bpf/syscall.c:1829 [inline]
>  bpf_prog_put kernel/bpf/syscall.c:1829 [inline] kernel/bpf/syscall.c:1837
>
> vs.
>
> https://syzkaller.appspot.com/bug?extid=bb73e71cf4b8fd376a4f
>  kasan_report+0x19a/0x1f0 mm/kasan/report.c:450 mm/kasan/report.c:450
>  __bpf_prog_put kernel/bpf/syscall.c:1812 [inline]
>  __bpf_prog_put kernel/bpf/syscall.c:1812 [inline] kernel/bpf/syscall.c:1829
>  bpf_prog_put+0x8c/0x4f0 kernel/bpf/syscall.c:1829 kernel/bpf/syscall.c:1829
>
> Looks to me like the compiler's inlining decision caused syzbot to see
> __bpf_prog_put() instead of bpf_prog_put(), but I can't tell if it's
> because it got inlined or because of the .constprop.0 suffix... I
> guess syzbot skips the [inline] entries when deciding which function
> to report the bug in?

Not sure if you are still interested in this or not...
But, yes, it's inline frames that are a problem, ".constprop.0" should
be stripped.
syzkaller parses non-symbolized kernel output w/o inlined frames to
extract the title. This was a very early decision, not sure if it's
the right one or not. On the other hand using inline frames can cause
attribution to all the common one-liners.
Now it's somewhat hard to change b/c if we change it, new crashes will
be parsed differently and it will cause a storm of duplicates for
already reported bugs.


> In any case:
>
> #syz dup: KASAN: vmalloc-out-of-bounds Read in bpf_prog_put
>
> Vegard
