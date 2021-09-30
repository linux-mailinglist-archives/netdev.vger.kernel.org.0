Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92AE41D0E6
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 03:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346064AbhI3BLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 21:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhI3BLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 21:11:17 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC8EC06161C;
        Wed, 29 Sep 2021 18:09:35 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id z5so9518443ybj.2;
        Wed, 29 Sep 2021 18:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rgiH3IvJ0OAlzs0PgaVGNLl0L1GHKN5qFR99u9Ydudw=;
        b=bs/Qb5uB4Mqyl5axF8F6TDCBLMnyTolsL+pvK1pljdfm48KUf5TV6tmqacSd5kORc6
         73eYJ7damYlJ6XCjOYgIW0dF24keAiVGTBkaeW4zBRmM2vxxltLoJYWbH2gV8Skld8FR
         O65Th1OxH5iU1smRv7IgOmjgm87SnOOoip2KtT8LCYZJNpRjzcX59dGT8wv1mx1Nfgwl
         3aKWQeBHGVXM5GokfAG1LD4RUPEg2IDXW8Qy9CCdF6u/7+8M1C/6ReCmP89NeG1oq+Os
         lu5suyiRA8nnAP4+4cHMwefDjJ1sp7FnJgT0Vk7FiL4sCYeYpWwPbpvJ7Jeoi4cZUGt8
         1wzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rgiH3IvJ0OAlzs0PgaVGNLl0L1GHKN5qFR99u9Ydudw=;
        b=ZDC/NjMCaVbJPr/r3jjJJ6PxKyyHLOfu7UnkW1Bo1Mpo71kbjjDJogZ0Zb+VMmu8Mr
         nBFLg6vmoNBobduwO5kLHGo6b2MvuHHYKRjMpkJDITbGlGY/vu6WvXT4dm7g6DN++r5y
         BAH1bU7GYr7/3VLj7jfhRv3y9wY/mI4if5JyvGeih725B6Ru4+CU7/5A/gPtqNXczDld
         fJUpbOuyQwlgEhLKgoFUGq2Rlso+cPNb8CXZu/fl47p5jPyM/jDNxbBUJZav4EnAs+S7
         ZYGGhYh2DZ46Hb6o2s7df24qeq8BM2TEgp3pVjI5tJvd9OdhsMo/7IkYg7Chv8CRq8uy
         wvuA==
X-Gm-Message-State: AOAM532UxJX1h6YRXn1sqwapX1vUc7xrvPBP9KyXuu5gr3/PdeqL/nyH
        B1adSHQkmE21k0apLEoHrGTpBD21ytjs69SXT0IolXy0Zw==
X-Google-Smtp-Source: ABdhPJw8uATfqAs57aGBG1bzmfaJR9fhg2uvx7XqJbJm3uD8vqs/AVfeqLIcwONnmiPuEO8i0C5xy+zTkejoC4tH8C0=
X-Received: by 2002:a5b:88a:: with SMTP id e10mr3512204ybq.467.1632964174622;
 Wed, 29 Sep 2021 18:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
 <20210929235910.1765396-5-jevburton.kernel@gmail.com> <1c148ba0-0b74-2d48-c94b-3e7ea42e8238@gmail.com>
In-Reply-To: <1c148ba0-0b74-2d48-c94b-3e7ea42e8238@gmail.com>
From:   Joe Burton <jevburton.kernel@gmail.com>
Date:   Wed, 29 Sep 2021 18:09:23 -0700
Message-ID: <CAN22Dihw1r9WP5JcecyE-3Y==ghVJT5ivRFGTR2bsboxLD2JEw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/13] bpf: Define a few bpf_link_ops for BPF_TRACE_MAP
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good catch, applied both changes. The expectation is to remove only
one
 program. Theoretically an app could link the same program to the same
map
twice, twice, in which case close()ing one link should not detach both
programs.

I opted to also apply the _safe() suffix mostly as a matter of convention.

-       struct bpf_map_trace_prog *cur_prog;
+       struct bpf_map_trace_prog *cur_prog, *tmp;
        struct bpf_map_trace_progs *progs;

        progs = map_trace_link->map->trace_progs;
        mutex_lock(&progs->mutex);
-       list_for_each_entry(cur_prog, &progs->progs[trace_type].list, list) {
+       list_for_each_entry_safe(cur_prog, tmp, &progs->progs[trace_type].list,
+                                list) {
                if (cur_prog->prog == link->prog) {
                        progs->length[trace_type] -= 1;
                        list_del_rcu(&cur_prog->list);
                        kfree_rcu(cur_prog, rcu);
+                       break;
                }
        }


On Wed, Sep 29, 2021 at 5:26 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 9/29/21 4:59 PM, Joe Burton wrote:
> > From: Joe Burton <jevburton@google.com>
> >
> > Define release, dealloc, and update_prog for the new tracing programs.
> > Updates are protected by a single global mutex.
> >
> > Signed-off-by: Joe Burton <jevburton@google.com>
> > ---
> >  kernel/bpf/map_trace.c | 71 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 71 insertions(+)
> >
> > diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
> > index 7776b8ccfe88..35906d59ba3c 100644
> > --- a/kernel/bpf/map_trace.c
> > +++ b/kernel/bpf/map_trace.c
> > @@ -14,6 +14,14 @@ struct bpf_map_trace_target_info {
> >  static struct list_head targets = LIST_HEAD_INIT(targets);
> >  static DEFINE_MUTEX(targets_mutex);
> >
> > +struct bpf_map_trace_link {
> > +     struct bpf_link link;
> > +     struct bpf_map *map;
> > +     struct bpf_map_trace_target_info *tinfo;
> > +};
> > +
> > +static DEFINE_MUTEX(link_mutex);
> > +
> >  int bpf_map_trace_reg_target(const struct bpf_map_trace_reg *reg_info)
> >  {
> >       struct bpf_map_trace_target_info *tinfo;
> > @@ -77,3 +85,66 @@ int bpf_map_initialize_trace_progs(struct bpf_map *map)
> >       return 0;
> >  }
> >
> > +static void bpf_map_trace_link_release(struct bpf_link *link)
> > +{
> > +     struct bpf_map_trace_link *map_trace_link =
> > +                     container_of(link, struct bpf_map_trace_link, link);
> > +     enum bpf_map_trace_type trace_type =
> > +                     map_trace_link->tinfo->reg_info->trace_type;
> > +     struct bpf_map_trace_prog *cur_prog;
> > +     struct bpf_map_trace_progs *progs;
> > +
> > +     progs = map_trace_link->map->trace_progs;
> > +     mutex_lock(&progs->mutex);
> > +     list_for_each_entry(cur_prog, &progs->progs[trace_type].list, list) {
>
> You might consider using list_for_each_entry_safe(), or ...
>
> > +             if (cur_prog->prog == link->prog) {
> > +                     progs->length[trace_type] -= 1;
> > +                     list_del_rcu(&cur_prog->list);
> > +                     kfree_rcu(cur_prog, rcu);
>
> or add a break; if you do not expect to find multiple entries.
>
> > +             }
> > +     }
> > +     mutex_unlock(&progs->mutex);
> > +     bpf_map_put_with_uref(map_trace_link->map);
> > +}
> > +
> > +static void bpf_map_trace_link_dealloc(struct bpf_link *link)
> > +{
> > +     struct bpf_map_trace_link *map_trace_link =
> > +                     container_of(link, struct bpf_map_trace_link, link);
> > +
> > +     kfree(map_trace_link);
> > +}
> > +
> > +static int bpf_map_trace_link_replace(struct bpf_link *link,
> > +                                   struct bpf_prog *new_prog,
> > +                                   struct bpf_prog *old_prog)
> > +{
> > +     int ret = 0;
> > +
> > +     mutex_lock(&link_mutex);
> > +     if (old_prog && link->prog != old_prog) {
> > +             ret = -EPERM;
> > +             goto out_unlock;
> > +     }
> > +
> > +     if (link->prog->type != new_prog->type ||
> > +         link->prog->expected_attach_type != new_prog->expected_attach_type ||
> > +         link->prog->aux->attach_btf_id != new_prog->aux->attach_btf_id) {
> > +             ret = -EINVAL;
> > +             goto out_unlock;
> > +     }
> > +
> > +     old_prog = xchg(&link->prog, new_prog);
> > +     bpf_prog_put(old_prog);
> > +
> > +out_unlock:
> > +     mutex_unlock(&link_mutex);
> > +     return ret;
> > +}
> > +
> > +static const struct bpf_link_ops bpf_map_trace_link_ops = {
> > +     .release = bpf_map_trace_link_release,
> > +     .dealloc = bpf_map_trace_link_dealloc,
> > +     .update_prog = bpf_map_trace_link_replace,
> > +};
> > +
> >
