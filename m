Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F084FE621
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357885AbiDLQpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357837AbiDLQpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:45:21 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B03B5AA7D
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:42:54 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id j21so19635434qta.0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 09:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/xj1JAOHRTccsN1PMLkAoN8xFX0TYfJvn+wqBumxkh4=;
        b=h6ngWg7b6HXqt0/qPKjIS+p3sN6F82znJPyR8yClX2PARyJmVyx9OVjcpfRdgubt+J
         sXsMTSgopIocaisFPcHhFFugHraqGJ9CEQ0lU25PGyXPkKlqBQJ3H6pju7rxPwn0cTHB
         w/QgkTnxKCFPqDhe6ZKoewILuS47plREja25d2j3thi2F+64ilSZFRQXP3TyJKaMSYR1
         KpvRZ5hoBfEv+wyUMOgtpcYM1jITFO5sF3M0RS6Zp4i7xPV1A/btO1vxLa2UxGr1Xqcp
         BqHif//iuhPD74S+PFWkurwTqAydHrF/oa3ob8H1gEA5CnGw6fAJTwtvj9rgjasYxiWS
         xKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/xj1JAOHRTccsN1PMLkAoN8xFX0TYfJvn+wqBumxkh4=;
        b=Ahe7B5GLnOFauuPUJzVuG0wcEvwVl8teDLLYPj4fcxDuyGu9kM9LpDL0x4LWoSNAvH
         99qn8KVNBk6SKaBBx80lVGu5YPCRIzqNHMOsMUlaIgM7QGCq/o2yOiCVC9/Tz1If4p66
         8EKpj3u8+TVI19cpYMUQblVUVPgHTT5Y+i0xLSH4F81ygaHxa52eckyBP4HRLNc70KU0
         kpYGE/x5S7w/vbGC4LoYU6pddl29itaF517S/9QR60MttbvPf2tmbygBsbvl6xl21JB9
         0NqPq6ufOiBUSlCGVNBRtKSF86cQfbeQxOeBC1ngjYS9xgy9ZAqHv61nE0Q+X+WtS3pT
         2jFw==
X-Gm-Message-State: AOAM533Fo5TkC3YlLO77kN/ME8qud8gau4X6nYim4Qgi2WW7QHELi0sl
        gfoRPYymZQm5+Y6Ksq9G2UpuyM5qbKy5y6nMksvDQQ==
X-Google-Smtp-Source: ABdhPJyD7Wp3KyEPpt/CRfiqmL1gXKHoQVQeNSHoYfQrYtNLZfLCwFd7mvIX36y5V9VTuX80Rbw4cnkxCR/jetzduyg=
X-Received: by 2002:ac8:6a18:0:b0:2ed:10e7:e0aa with SMTP id
 t24-20020ac86a18000000b002ed10e7e0aamr4073612qtr.570.1649781773053; Tue, 12
 Apr 2022 09:42:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223112.1204582-1-sdf@google.com> <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com>
 <87fsmmp1pi.fsf@cloudflare.com> <20220412011938.usu6wzwc2ayydiq2@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20220412011938.usu6wzwc2ayydiq2@kafai-mbp.dhcp.thefacebook.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 12 Apr 2022 09:42:41 -0700
Message-ID: <CAKH8qBtMU2V3RpQBBCmaZyh1A-oB1ggc9sgF9KXWgPPp++iNhQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
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

On Mon, Apr 11, 2022 at 6:19 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Sat, Apr 09, 2022 at 07:04:05PM +0200, Jakub Sitnicki wrote:
> > >> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> > >> index 6c661b4df9fa..d42516e86b3a 100644
> > >> --- a/include/linux/bpf-cgroup-defs.h
> > >> +++ b/include/linux/bpf-cgroup-defs.h
> > >> @@ -10,7 +10,9 @@
> > >>
> > >>  struct bpf_prog_array;
> > >>
> > >> -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> > >> +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> > >> + */
> > >> +#define CGROUP_LSM_NUM 10
> > > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > > a static 211 (and potentially growing in the future) is not good either.
> > > I currently do not have a better idea also. :/
> > >
> > > Have you thought about other dynamic schemes or they would be too slow ?
> >
> > As long as we're talking ideas - how about a 2-level lookup?
> >
> > L1: 0..255 -> { 0..31, -1 }, where -1 is inactive cgroup_bp_attach_type
> > L2: 0..31 -> struct bpf_prog_array * for cgroup->bpf.effective[],
> >              struct hlist_head [^1]  for cgroup->bpf.progs[],
> >              u32                     for cgroup->bpf.flags[],
> >
> > This way we could have 32 distinct _active_ attachment types for each
> > cgroup instance, to be shared among regular cgroup attach types and BPF
> > LSM attach types.
> >
> > It is 9 extra slots in comparison to today, so if anyone has cgroups
> > that make use of all available attach types at the same time, we don't
> > break their setup.
> >
> > The L1 lookup table would still a few slots for new cgroup [^2] or LSM
> > hooks:
> >
> >   256 - 23 (cgroup attach types) - 211 (LSM hooks) = 22
> >
> > Memory bloat:
> >
> >  +256 B - L1 lookup table
> Does L1 need to be per cgroup ?
>
> or different cgroups usually have a very different active(/effective) set ?

I'm assuming the suggestion is to have it per cgroup. Otherwise, if it's
global, it's close to whatever I'm proposing in the original patch. As I
mentioned in the commit message, in theory, all cgroup_bpf can be managed
the way I propose to manage 10 lsm slots if we get to the point where
10 slots is not enough.

I've played with this mode a bit and it looks a bit complicated :-( Since it's
per cgroup, we have to be careful to preserve this mapping during
cgroup_bpf_inherit.
I'll see what I can do, but I'll most likely revert to my initial
version for now (I'll also include list_head->hlist_head conversion
patch, very nice idea).



> >  + 72 B - extra effective[] slots
> >  + 72 B - extra progs[] slots
> >  + 36 B - extra flags[] slots
> >  -184 B - savings from switching to hlist_head
> >  ------
> >  +252 B per cgroup instance
> >
> > Total cgroup_bpf{} size change - 720 B -> 968 B.
> >
> > WDYT?
> >
> > [^1] It looks like we can easily switch from cgroup->bpf.progs[] from
> >      list_head to hlist_head and save some bytes!
> >
> >      We only access the list tail in __cgroup_bpf_attach(). We can
> >      either iterate over the list and eat the cost there or push the new
> >      prog onto the front.
> >
> >      I think we treat cgroup->bpf.progs[] everywhere like an unordered
> >      set. Except for __cgroup_bpf_query, where the user might notice the
> >      order change in the BPF_PROG_QUERY dump.
> >
> > [^2] Unrelated, but we would like to propose a
> >      CGROUP_INET[46]_POST_CONNECT hook in the near future to make it
> >      easier to bind UDP sockets to 4-tuple without creating conflicts:
> >
> >      https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-connectx/ebpf_connect4
> >
> > [...]
