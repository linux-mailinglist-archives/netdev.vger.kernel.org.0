Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7EC3174D0
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhBJX5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbhBJX5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 18:57:35 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3B6C061756;
        Wed, 10 Feb 2021 15:56:55 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d184so3875838ybf.1;
        Wed, 10 Feb 2021 15:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NlBU/EA5O5TjlAdnlvz/LDwHm49DsW41/c60GtVRT74=;
        b=pJPqASHZnFoxFqibBPjdXo/RgSRVRvHlFmNeu59Ca28kVCrYAcdIswfPWmlqQNjVLP
         I185P4VWBPPnru9fZ0q3PeaQieE8i3c7frpGkW4/d9Yh3ugOV5+Jdn5eWXb+b4YIZEKO
         vb5GEUu1DzI2c5PWg+YXMEb95BHKCYZ25cE5+f1Pk9o8psw0WpNHI+RsJajvPzea5t1o
         LrN4L9QfVXCEJcQchrpX5ATT4wgA1gM1UJJFK51dlpTAfjMInADIHPVBPkH+uaRmxFs+
         RTX27vJbvhPBgc0QJyiL/bG6zoLfils4qn0z17w1DhAVgBf5Zx/PnTKTcKaH/rKRUDnI
         fvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NlBU/EA5O5TjlAdnlvz/LDwHm49DsW41/c60GtVRT74=;
        b=paWhb5r8QoVYsWOTwuXV7nivSbrMRlgsnJ5FA5cirN+PziUKryg9RSWzQnrO97fv7j
         XXfo6KLjF/sTPkxbIt6xFbpyZRIF7zLeEd1/5b8JZ3gMFPkzmO3+90gLhkrjiKjtAFGX
         Mo18ug28hRmukYRzGHzXTrw4leYnDUuz+vZ0lKPOObPFhwK+cmMmNDyr7XIUNjJ2lVmz
         nKVt41SEvevRkfGYPnFeu1GT9qKpmbhCdrbIahRjCWuH3lI0LhiukzMxiaVTsCJbtbMP
         iGeWJQsnyuVMC8CZF9c6lA01y6aSmq9zWx9rQ5K2bcXpPJ39eLjhbzq4dJ25hUmAJbLw
         e8VQ==
X-Gm-Message-State: AOAM530lHc60mpYuiIBOgVMrMVgtLh8w7HcaHdU88tEPIWfaKl4kkufK
        lMCuEcF9xpo0OtZ+5c4govxAI+6jxKPUOUiiFeQ=
X-Google-Smtp-Source: ABdhPJyFeixNmcUyYnl1vhiuD7S3q9Q222OT+Ynk7lyXjN0oeCH0nvjq2ltCBFS2rgAF2/1eyQOqym4KkYcqqXn/q18=
X-Received: by 2002:a25:9882:: with SMTP id l2mr7298911ybo.425.1613001414729;
 Wed, 10 Feb 2021 15:56:54 -0800 (PST)
MIME-Version: 1.0
References: <20210209112701.3341724-1-elver@google.com> <20210210055937.4c2gfs5utfeytoeg@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210210055937.4c2gfs5utfeytoeg@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 15:56:44 -0800
Message-ID: <CAEf4BzaO+cR3b-TKb6BBsj1_gmAbWuq1JriGU7C8qMuiHz-5Gg@mail.gmail.com>
Subject: Re: [PATCH] bpf_lru_list: Read double-checked variable once without lock
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Marco Elver <elver@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kasan-dev@googlegroups.com,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot+3536db46dfa58c573458@syzkaller.appspotmail.com,
        syzbot+516acdb03d3e27d91bcd@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 10:00 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Feb 09, 2021 at 12:27:01PM +0100, Marco Elver wrote:
> > For double-checked locking in bpf_common_lru_push_free(), node->type is
> > read outside the critical section and then re-checked under the lock.
> > However, concurrent writes to node->type result in data races.
> >
> > For example, the following concurrent access was observed by KCSAN:
> >
> >   write to 0xffff88801521bc22 of 1 bytes by task 10038 on cpu 1:
> >    __bpf_lru_node_move_in        kernel/bpf/bpf_lru_list.c:91
> >    __local_list_flush            kernel/bpf/bpf_lru_list.c:298
> >    ...
> >   read to 0xffff88801521bc22 of 1 bytes by task 10043 on cpu 0:
> >    bpf_common_lru_push_free      kernel/bpf/bpf_lru_list.c:507
> >    bpf_lru_push_free             kernel/bpf/bpf_lru_list.c:555
> >    ...
> >
> > Fix the data races where node->type is read outside the critical section
> > (for double-checked locking) by marking the access with READ_ONCE() as
> > well as ensuring the variable is only accessed once.
> >
> > Reported-by: syzbot+3536db46dfa58c573458@syzkaller.appspotmail.com
> > Reported-by: syzbot+516acdb03d3e27d91bcd@syzkaller.appspotmail.com
> > Signed-off-by: Marco Elver <elver@google.com>
> > ---
> > Detailed reports:
> >       https://groups.google.com/g/syzkaller-upstream-moderation/c/PwsoQ7bfi8k/m/NH9Ni2WxAQAJ
> >       https://groups.google.com/g/syzkaller-upstream-moderation/c/-fXQO9ehxSM/m/RmQEcI2oAQAJ
> > ---
> >  kernel/bpf/bpf_lru_list.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
> > index 1b6b9349cb85..d99e89f113c4 100644
> > --- a/kernel/bpf/bpf_lru_list.c
> > +++ b/kernel/bpf/bpf_lru_list.c
> > @@ -502,13 +502,14 @@ struct bpf_lru_node *bpf_lru_pop_free(struct bpf_lru *lru, u32 hash)
> >  static void bpf_common_lru_push_free(struct bpf_lru *lru,
> >                                    struct bpf_lru_node *node)
> >  {
> > +     u8 node_type = READ_ONCE(node->type);
> >       unsigned long flags;
> >
> > -     if (WARN_ON_ONCE(node->type == BPF_LRU_LIST_T_FREE) ||
> > -         WARN_ON_ONCE(node->type == BPF_LRU_LOCAL_LIST_T_FREE))
> > +     if (WARN_ON_ONCE(node_type == BPF_LRU_LIST_T_FREE) ||
> > +         WARN_ON_ONCE(node_type == BPF_LRU_LOCAL_LIST_T_FREE))
> >               return;
> >
> > -     if (node->type == BPF_LRU_LOCAL_LIST_T_PENDING) {
> > +     if (node_type == BPF_LRU_LOCAL_LIST_T_PENDING) {
> I think this can be bpf-next.
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Added Fixes: 3a08c2fd7634 ("bpf: LRU List") and applied to bpf-next, thanks.
