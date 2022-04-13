Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E27F4FFF19
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiDMTZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiDMTZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:25:49 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2160C66C94;
        Wed, 13 Apr 2022 12:23:28 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id p21so3042262ioj.4;
        Wed, 13 Apr 2022 12:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HXQT0mqJH576CvPQOtXuaOMG3TMBM4+4Bfcrm0Rd2WM=;
        b=CivewPuCXuamdFkhM8iLAXoban5Bpu198Jt3yhhZKQ22OFilJnE4R22slI81yFVLnO
         ktbXdtKh+9BeCU0AUjpg5pBByIeJW+E/oeiz1HvluUxY+pGfRPRuFyVYz3KX7/wp4p7l
         P8O+nrTXs3KDZeRYKzHf3Fe3X3PDmR9GD0HeXwYEb806Oea4Elf/1hKl4ksIzJoARwnB
         BNcjPAKOwAmzh6zke9gCLisOB0zbcWbvEWOGFNCv5UzX0H1YN0WUvnS9EZpItx7WBlt5
         C3aEfPK614zz+RolCg+Odbt2iKr8iQNY9xGWX/qpwleuozV8VwHd3VCLxBU6Pn0byHAB
         9rGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HXQT0mqJH576CvPQOtXuaOMG3TMBM4+4Bfcrm0Rd2WM=;
        b=i8m4vtrLGwZLvzlroaQW07nK7ScD7tx3dD9BEZQ1HOPm4gdU98n+GxW5v8z/yejrP2
         YiLskoQSyfxjoYD7AaoKIKYtU3oEhyraREeMxIY0HbtRSuZfmcevWcZgDf9cwwcLSXeA
         EGyZeSk8fMzm+C/3MSd1RLU1Oh7j3a1vl4ey/h+SgQb8vGshcsJTBG5pG6Pn3uerQAow
         UfbZ978L2iIAF6uGyLYTX2r2RME8mg7TixMP8qs3b4CggorR2KNBTFGWMB3SaKEe0qlB
         CxCdwZKJjX8/ROXFWZ0VWD2QPw9ckXiinjJWq1XeqM8LFmc5D/vIiIrOzEy5NPbXH3Qv
         i1NA==
X-Gm-Message-State: AOAM530baCCxNedHNqH0AzVmKK/s67I/4qKAEZxnv5gyTldIT8dWv2T/
        wZQM30SsATU2UBCu0jo1d/cDvMdpXSANszcISXE=
X-Google-Smtp-Source: ABdhPJyMuHRTl6ksFi/1654fs2Na/QtjdBC8AmnNM13QzOXmdsTBspNPnwKVIfTu/2jPgERcWNPvYEBsjpvx7lw8HJI=
X-Received: by 2002:a6b:7d44:0:b0:64c:ab1b:a8a6 with SMTP id
 d4-20020a6b7d44000000b0064cab1ba8a6mr18149097ioq.63.1649877807505; Wed, 13
 Apr 2022 12:23:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220413183256.1819164-1-sdf@google.com>
In-Reply-To: <20220413183256.1819164-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Apr 2022 12:23:16 -0700
Message-ID: <CAEf4Bzb_-KMy7GBN_NsJCKXHfDnGTtVEZb7i4dmcN-8=cLhO+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
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

On Wed, Apr 13, 2022 at 11:33 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Commit 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros
> into functions") switched a bunch of BPF_PROG_RUN macros to inline
> routines. This changed the semantic a bit. Due to arguments expansion
> of macros, it used to be:
>
>         rcu_read_lock();
>         array = rcu_dereference(cgrp->bpf.effective[atype]);
>         ...
>
> Now, with with inline routines, we have:
>         array_rcu = rcu_dereference(cgrp->bpf.effective[atype]);
>         /* array_rcu can be kfree'd here */
>         rcu_read_lock();
>         array = rcu_dereference(array_rcu);
>

So subtle difference, wow...

But this open-coding of rcu_read_lock() seems very unfortunate as
well. Would making BPF_PROG_RUN_ARRAY back to a macro which only does
rcu lock/unlock and grabs effective array and then calls static inline
function be a viable solution?

#define BPF_PROG_RUN_ARRAY_CG_FLAGS(array_rcu, ctx, run_prog, ret_flags) \
  ({
      int ret;

      rcu_read_lock();
      ret = __BPF_PROG_RUN_ARRAY_CG_FLAGS(rcu_dereference(array_rcu), ....);
      rcu_read_unlock();
      ret;
  })


where __BPF_PROG_RUN_ARRAY_CG_FLAGS is what
BPF_PROG_RUN_ARRAY_CG_FLAGS is today but with __rcu annotation dropped
(and no internal rcu stuff)?


> I'm assuming in practice rcu subsystem isn't fast enough to trigger
> this but let's use rcu API properly: ask callers of BPF_PROG_RUN
> to manage rcu themselves.
>
> Also, rename to lower caps to not confuse with macros. Additionally,
> drop and expand BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY.
>
> See [1] for more context.
>
>   [1] https://lore.kernel.org/bpf/CAKH8qBs60fOinFdxiiQikK_q0EcVxGvNTQoWvHLEUGbgcj1UYg@mail.gmail.com/T/#u
>
> Cc: Martin KaFai Lau <kafai@fb.com>
> Fixes: 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros into functions")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  drivers/media/rc/bpf-lirc.c |  8 +++-
>  include/linux/bpf.h         | 70 ++++++-------------------------
>  kernel/bpf/cgroup.c         | 84 +++++++++++++++++++++++++++++--------
>  kernel/trace/bpf_trace.c    |  5 ++-
>  4 files changed, 90 insertions(+), 77 deletions(-)
>

[...]
