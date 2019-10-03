Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50E7CAAF0
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731549AbfJCRZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:25:40 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36635 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390881AbfJCRVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:21:50 -0400
Received: by mail-qt1-f195.google.com with SMTP id o12so4699988qtf.3;
        Thu, 03 Oct 2019 10:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h5Rim9i4R2dtqePdDLpMCbY7rNwA6OH+nyEYI7LKahs=;
        b=face39Zit5ry5Kv5MEk6wx4lT9nUPV/Qw7+B489XY4veUQ8Vg1354MpUcaarHInvO1
         aEzb6pTQwv9J9IvU8iaZzbfOuYaNy9AWHG5qsRqVP2rR54qVMbGeueL2E/3PgqTc4MXR
         ERYhWFZjcnZZ/O7s7ZxeaayQozjcO04gBOE/16ykGd3/zHrsTlW8iQme/sniIEngN3iJ
         03xPKJsMjHyvHH9hSqX25xoaOz2boH7cgLVicayHXn2As2h41G5rhsna0OLOKET9aJLB
         qSvFRZlxtr6FK0tcZQp0sH5NOthVXZtUhKxno5yWREXFDOzZpgs27BgDPFKAdTCJ1bIO
         jpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h5Rim9i4R2dtqePdDLpMCbY7rNwA6OH+nyEYI7LKahs=;
        b=I4EpVSL9YNC+Lu7aJw9cSEOw36qC7eK7ZkKES5NcoXXjnXeyNKqUUKml1dtLwsHEtK
         IYYEBqMZGMSx4y9IR9jrhT8sxzj12ZtxaYxIzfldrJczoAKB4izga/LishtIiW2tlMp2
         2w3RmI/LnFv/eV5bDd1Qh+lbc6tTQam6XIp5y4Ews41WAAQJ4lwaEYVVwL99hH3ayB21
         ANrxuO6FNHy3NHY8lFM75YUz3HPLiANPtBGDMQX/7wMOCn6PyVIeEFwZMv7ooffcXPmp
         8rOwY5kjEfIJRFVvzWeVsk4qMZhiLR+aQ3Wtle2s0h5ubX6jhbihycF87+chumURS/QJ
         kZKA==
X-Gm-Message-State: APjAAAXg17UfeBrmBIhZAm6pUQIM1AcQ85PC45jWAlbAKCSukqrZB0nt
        ZSC0pmgDCd1UXZs8RBB/eTZfASEXc/nnj3jOjKFODxGSUbE=
X-Google-Smtp-Source: APXvYqz4TrdMivyXDTK0GQ13yFmR3JItdHh5McZQkymTQsopcQ3vLgBQWOsNamCBOfIzbAPoIMHO57B910EUdBEE4mk=
X-Received: by 2002:aed:2726:: with SMTP id n35mr10864628qtd.171.1570123309206;
 Thu, 03 Oct 2019 10:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <20191003014153.GA13156@paulmck-ThinkPad-P72> <20191003014310.13262-6-paulmck@kernel.org>
In-Reply-To: <20191003014310.13262-6-paulmck@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 10:21:38 -0700
Message-ID: <CAEf4BzaBuktutCZr2ZUC6b-XK_JJ7prWZmO-5Yew2tVp5DxbBA@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 6/9] bpf/cgroup: Replace rcu_swap_protected()
 with rcu_replace()
To:     paulmck@kernel.org
Cc:     rcu@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, jiangshanlai@gmail.com,
        dipankar@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Ziljstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, dhowells@redhat.com,
        Eric Dumazet <edumazet@google.com>, fweisbec@gmail.com,
        oleg@redhat.com, Joel Fernandes <joel@joelfernandes.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 6:45 PM <paulmck@kernel.org> wrote:
>
> From: "Paul E. McKenney" <paulmck@kernel.org>
>
> This commit replaces the use of rcu_swap_protected() with the more
> intuitively appealing rcu_replace() as a step towards removing
> rcu_swap_protected().
>
> Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> Cc: <netdev@vger.kernel.org>
> Cc: <bpf@vger.kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/cgroup.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index ddd8add..06a0657 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -180,8 +180,8 @@ static void activate_effective_progs(struct cgroup *cgrp,
>                                      enum bpf_attach_type type,
>                                      struct bpf_prog_array *old_array)
>  {
> -       rcu_swap_protected(cgrp->bpf.effective[type], old_array,
> -                          lockdep_is_held(&cgroup_mutex));
> +       old_array = rcu_replace(cgrp->bpf.effective[type], old_array,
> +                               lockdep_is_held(&cgroup_mutex));
>         /* free prog array after grace period, since __cgroup_bpf_run_*()
>          * might be still walking the array
>          */
> --
> 2.9.5
>
