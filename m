Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8F1531ECB
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiEWWrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiEWWrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:47:47 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C7252B0B;
        Mon, 23 May 2022 15:47:45 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id w10so14065594vsa.4;
        Mon, 23 May 2022 15:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A2BhwQefVVP8UoX6IY08n5jPD6eRGj93qA/P48KIUR8=;
        b=OeLi52mYlhDM7AWo5ZVAQ8hpvWwlr6xVjp8d7eeH2PkBr5a0xRtWUmCK3DQBIVO+H0
         jx9GukC2S6IrEQeXklmBdUBvU2jL78tx+7eDfxwn83b7GhaE0ISMCEtQTssUmk6GjRbj
         dzj1vwYfEWhxpEVK3PZ5svnt7BIC75htD8ZQyCfznBbjasCwhMVkXLLDr6VqaXLKp6rU
         NV/MGPkpMK/XxKDluaEeDKkF6rqVHu/zWzmZeVorC4R29d0DAXx7EvbEeK02BX0QK7J5
         MRTTExC0W3o2QrIYcP3npROMtbYn7PAp4nZ9sS6/qr2HzrBiqzlEZwouYunjKpqQuImW
         dcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A2BhwQefVVP8UoX6IY08n5jPD6eRGj93qA/P48KIUR8=;
        b=0jO9MM6qcvG0sOrs0YMLeysSsy8FDeG36OYFrEOHOAxwXT1vR5xh325Q8ll9ouO6Rz
         qfxlfh05yQtjk6wVc9XRxNoCtxfgRFSEYT8Ydu7wgYaA0yjB+doFcmUt1QqJQNvYELe7
         X5XXHRs/5KMIPOyprgXkLQM1MKb61hiNb7fmtAYp5MnmPbzUi+HJwrSayBgVMcou8Cnu
         xSFrtNg99lGnWmhPSVz/zCC4u35+6+bi3U8MGp75CoP3z9c1B0K1Sg9W2kbXG2HYF8Zr
         Eas8U+x+MHH3OorOG2oIX+LmQzEA3XPPNsLWK+l6FWJPoLSnwXRbvUTkFh/T/u56i1KE
         GOXQ==
X-Gm-Message-State: AOAM530uZZuFY3pKSLKt+yuEwbwdIluXrOTwgDbAkXwjrtSxesa8CMOT
        c0mROPSeD3q0lyz4uVObUJX2Mb0bVuzgVG7zPOU=
X-Google-Smtp-Source: ABdhPJx6CUm21SYtYvx/Sh+APMqkvXeGo/uWx/pnl6NczuPOL78svXkBoKhfZyHIj9EyWs6Oi1rC2pkdtAT6LcVG97o=
X-Received: by 2002:a67:e0d5:0:b0:337:b2f4:afe0 with SMTP id
 m21-20020a67e0d5000000b00337b2f4afe0mr3007679vsl.11.1653346064205; Mon, 23
 May 2022 15:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
 <20220517180420.87954-1-tadeusz.struk@linaro.org> <7949d722-86e8-8122-e607-4b09944b76ae@linaro.org>
In-Reply-To: <7949d722-86e8-8122-e607-4b09944b76ae@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 15:47:32 -0700
Message-ID: <CAEf4BzaD1Z6uOZwbquPYWB0_Z0+CkEKiXQ6zS2imiSHpTgX3pg@mail.gmail.com>
Subject: Re: [PATCH v4] bpf: Fix KASAN use-after-free Read in compute_effective_progs
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 2:36 PM Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>
> On 5/17/22 11:04, Tadeusz Struk wrote:
> > Syzbot found a Use After Free bug in compute_effective_progs().
> > The reproducer creates a number of BPF links, and causes a fault
> > injected alloc to fail, while calling bpf_link_detach on them.
> > Link detach triggers the link to be freed by bpf_link_free(),
> > which calls __cgroup_bpf_detach() and update_effective_progs().
> > If the memory allocation in this function fails, the function restores
> > the pointer to the bpf_cgroup_link on the cgroup list, but the memory
> > gets freed just after it returns. After this, every subsequent call to
> > update_effective_progs() causes this already deallocated pointer to be
> > dereferenced in prog_list_length(), and triggers KASAN UAF error.
> >
> > To fix this issue don't preserve the pointer to the prog or link in the
> > list, but remove it and replace it with a dummy prog without shrinking
> > the table. The subsequent call to __cgroup_bpf_detach() or
> > __cgroup_bpf_detach() will correct it.
> >
> > Cc: "Alexei Starovoitov" <ast@kernel.org>
> > Cc: "Daniel Borkmann" <daniel@iogearbox.net>
> > Cc: "Andrii Nakryiko" <andrii@kernel.org>
> > Cc: "Martin KaFai Lau" <kafai@fb.com>
> > Cc: "Song Liu" <songliubraving@fb.com>
> > Cc: "Yonghong Song" <yhs@fb.com>
> > Cc: "John Fastabend" <john.fastabend@gmail.com>
> > Cc: "KP Singh" <kpsingh@kernel.org>
> > Cc: <netdev@vger.kernel.org>
> > Cc: <bpf@vger.kernel.org>
> > Cc: <stable@vger.kernel.org>
> > Cc: <linux-kernel@vger.kernel.org>
> >
> > Link: https://syzkaller.appspot.com/bug?id=8ebf179a95c2a2670f7cf1ba62429ec044369db4
> > Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
> > Reported-by: <syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com>
> > Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> > ---
> > v2: Add a fall back path that removes a prog from the effective progs
> >      table in case detach fails to allocate memory in compute_effective_progs().
> >
> > v3: Implement the fallback in a separate function purge_effective_progs
> >
> > v4: Changed purge_effective_progs() to manipulate the array in a similar way
> >      how replace_effective_prog() does it.
> > ---
> >   kernel/bpf/cgroup.c | 68 +++++++++++++++++++++++++++++++++++++++------
> >   1 file changed, 60 insertions(+), 8 deletions(-)
> >
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 128028efda64..6f1a6160c99e 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -681,6 +681,60 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
> >       return ERR_PTR(-ENOENT);
> >   }
> >
> > +/**
> > + * purge_effective_progs() - After compute_effective_progs fails to alloc new
> > + *                           cgrp->bpf.inactive table we can recover by
> > + *                           recomputing the array in place.
> > + *
> > + * @cgrp: The cgroup which descendants to travers
> > + * @prog: A program to detach or NULL
> > + * @link: A link to detach or NULL
> > + * @atype: Type of detach operation
> > + */
> > +static void purge_effective_progs(struct cgroup *cgrp, struct bpf_prog *prog,
> > +                               struct bpf_cgroup_link *link,
> > +                               enum cgroup_bpf_attach_type atype)
> > +{
> > +     struct cgroup_subsys_state *css;
> > +     struct bpf_prog_array *progs;
> > +     struct bpf_prog_list *pl;
> > +     struct list_head *head;
> > +     struct cgroup *cg;
> > +     int pos;
> > +
> > +     /* recompute effective prog array in place */
> > +     css_for_each_descendant_pre(css, &cgrp->self) {
> > +             struct cgroup *desc = container_of(css, struct cgroup, self);
> > +
> > +             if (percpu_ref_is_zero(&desc->bpf.refcnt))
> > +                     continue;
> > +
> > +             /* find position of link or prog in effective progs array */
> > +             for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
> > +                     if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
> > +                             continue;
> > +
> > +                     head = &cg->bpf.progs[atype];
> > +                     list_for_each_entry(pl, head, node) {
> > +                             if (!prog_list_prog(pl))
> > +                                     continue;
> > +                             if (pl->prog == prog && pl->link == link)
> > +                                     goto found;
> > +                             pos++;
> > +                     }
> > +             }
> > +found:
> > +             BUG_ON(!cg);
> > +             progs = rcu_dereference_protected(
> > +                             desc->bpf.effective[atype],
> > +                             lockdep_is_held(&cgroup_mutex));
> > +
> > +             /* Remove the program from the array */
> > +             WARN_ONCE(bpf_prog_array_delete_safe_at(progs, pos),
> > +                       "Failed to purge a prog from array at index %d", pos);
> > +     }
> > +}
> > +
> >   /**
> >    * __cgroup_bpf_detach() - Detach the program or link from a cgroup, and
> >    *                         propagate the change to descendants
> > @@ -723,8 +777,12 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >       pl->link = NULL;
> >
> >       err = update_effective_progs(cgrp, atype);
> > -     if (err)
> > -             goto cleanup;
> > +     if (err) {
> > +             /* If update affective array failed replace the prog with a dummy prog*/
> > +             pl->prog = old_prog;
> > +             pl->link = link;
> > +             purge_effective_progs(cgrp, old_prog, link, atype);
> > +     }
> >
> >       /* now can actually delete it from this cgroup list */
> >       list_del(&pl->node);
> > @@ -736,12 +794,6 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> >               bpf_prog_put(old_prog);
> >       static_branch_dec(&cgroup_bpf_enabled_key[atype]);
> >       return 0;
> > -
> > -cleanup:
> > -     /* restore back prog or link */
> > -     pl->prog = old_prog;
> > -     pl->link = link;
> > -     return err;
> >   }
> >
> >   static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>
> Hi Andrii,
> Do you have any more feedback? Does it look better to you now?

Hi, this is on my TODO list, but I need a bit more focused time to
think all this through and I haven't managed to get it in last week.
I'm worried about the percpu_ref_is_zero(&desc->bpf.refcnt) portion
and whether it can cause some skew in the calculated array index, I
need to look at this a bit more in depth. Sorry for the delay.

> --
> Thanks,
> Tadeusz
