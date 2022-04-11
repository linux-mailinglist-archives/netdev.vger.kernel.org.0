Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6039F4FC44E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 20:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349227AbiDKSrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 14:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345246AbiDKSrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 14:47:22 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEB91BEA1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 11:45:07 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id z15so7887085qtj.13
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 11:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Atzl5Qlnk4ng0dcb/L65lU+gmvOLyVa46Qnmvo9iXY=;
        b=riXB7FpX2QojH2be1u/W+nd4wjq1tPtaTIlkVyctTP3lFrGPKR5G4+2/mx3IJx1pWd
         FLap29Tf0/j8+pcCRsMfYnWsY5H9kazVpo8PR9B/0JdCX2NXRYlweIaKrFGLwzsrfZI2
         iuYG3OC8a6MyOxQLyIinWTmds/rzke1+21ojqRM3H8+JuhS7e/Dh2lvv+j3XcwyubH+k
         BR0uVJq0Hn64wTZ/6NPZHaQPI6MF8lfae9dC4tJaPcE697V0JDvquG96LulGSyH9dC67
         BlwOLfLukYWkDJ2ExLVUA0r74Zq0t2t016LPlcIDTUu0np2+Ha2bpL0nU2y8Ryc7HU/S
         qd1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Atzl5Qlnk4ng0dcb/L65lU+gmvOLyVa46Qnmvo9iXY=;
        b=lN8ZnRbs4XKSrTQTkvgJ6p1tCu8xrwh607HDWF3Jo6Jnq+Fss9D54tSCysVVYK9+rY
         kLgZNPZG+8mkkMt90/Y0ZIOG6MZM2ib2DW9DBdoTOE4IVYkP4S8jI+E/rSfzJ5ueDrAx
         uL8Hh/2YTze94gnO8qzbBpsk6W87o7GgcJRaxtKk4bIFbBLI9ySfqVOv4yRcYd46v7J1
         gvqwLgqjwaO+lw5cUNqHWFLBfkVaIn71DtGi5qUDf5/LY32t0AvqApJznVpjn38I1OEd
         YaN2HyVcg3NA38Ng+c4otN8rn628YAXizKupF0TExCLLWg4pC7y/LVC8jnt7NVHB9qwF
         cPzw==
X-Gm-Message-State: AOAM533+gokdvgfR/1VGzpsovFz6yPbOdvNJki3g015zmgVS4uA0r2eD
        6pvcNWpbn3YQEDnLZbpfJhtr4UQF/ZJgpYlf1eWnAg==
X-Google-Smtp-Source: ABdhPJyu22o9/7Vp+IROuDW9V7v9slxbj/KCVaJDHFmQGAVj4CQvQXhiCsg/Pi6Vzl7EECgYHVbAH+WghR43qoWNuqc=
X-Received: by 2002:ac8:51d8:0:b0:2eb:dc92:63d1 with SMTP id
 d24-20020ac851d8000000b002ebdc9263d1mr602651qtn.526.1649702706754; Mon, 11
 Apr 2022 11:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223112.1204582-1-sdf@google.com> <20220407223112.1204582-4-sdf@google.com>
 <20220408225628.oog4a3qteauhqkdn@kafai-mbp.dhcp.thefacebook.com> <87fsmmp1pi.fsf@cloudflare.com>
In-Reply-To: <87fsmmp1pi.fsf@cloudflare.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 11 Apr 2022 11:44:54 -0700
Message-ID: <CAKH8qBuqPQjZ==CjD=rO8dui9LNcUNRFOg7ROETRxbuMYnzBEg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/7] bpf: minimize number of allocated lsm
 slots per program
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
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

On Sat, Apr 9, 2022 at 11:10 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Fri, Apr 08, 2022 at 03:56 PM -07, Martin KaFai Lau wrote:
> > On Thu, Apr 07, 2022 at 03:31:08PM -0700, Stanislav Fomichev wrote:
> >> Previous patch adds 1:1 mapping between all 211 LSM hooks
> >> and bpf_cgroup program array. Instead of reserving a slot per
> >> possible hook, reserve 10 slots per cgroup for lsm programs.
> >> Those slots are dynamically allocated on demand and reclaimed.
> >> This still adds some bloat to the cgroup and brings us back to
> >> roughly pre-cgroup_bpf_attach_type times.
> >>
> >> It should be possible to eventually extend this idea to all hooks if
> >> the memory consumption is unacceptable and shrink overall effective
> >> programs array.
> >>
> >> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >> ---
> >>  include/linux/bpf-cgroup-defs.h |  4 +-
> >>  include/linux/bpf_lsm.h         |  6 ---
> >>  kernel/bpf/bpf_lsm.c            |  9 ++--
> >>  kernel/bpf/cgroup.c             | 96 ++++++++++++++++++++++++++++-----
> >>  4 files changed, 90 insertions(+), 25 deletions(-)
> >>
> >> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> >> index 6c661b4df9fa..d42516e86b3a 100644
> >> --- a/include/linux/bpf-cgroup-defs.h
> >> +++ b/include/linux/bpf-cgroup-defs.h
> >> @@ -10,7 +10,9 @@
> >>
> >>  struct bpf_prog_array;
> >>
> >> -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> >> +/* Maximum number of concurrently attachable per-cgroup LSM hooks.
> >> + */
> >> +#define CGROUP_LSM_NUM 10
> > hmm...only 10 different lsm hooks (or 10 different attach_btf_ids) can
> > have BPF_LSM_CGROUP programs attached.  This feels quite limited but having
> > a static 211 (and potentially growing in the future) is not good either.
> > I currently do not have a better idea also. :/
> >
> > Have you thought about other dynamic schemes or they would be too slow ?
>
> As long as we're talking ideas - how about a 2-level lookup?
>
> L1: 0..255 -> { 0..31, -1 }, where -1 is inactive cgroup_bp_attach_type
> L2: 0..31 -> struct bpf_prog_array * for cgroup->bpf.effective[],
>              struct hlist_head [^1]  for cgroup->bpf.progs[],
>              u32                     for cgroup->bpf.flags[],
>
> This way we could have 32 distinct _active_ attachment types for each
> cgroup instance, to be shared among regular cgroup attach types and BPF
> LSM attach types.
>
> It is 9 extra slots in comparison to today, so if anyone has cgroups
> that make use of all available attach types at the same time, we don't
> break their setup.
>
> The L1 lookup table would still a few slots for new cgroup [^2] or LSM
> hooks:
>
>   256 - 23 (cgroup attach types) - 211 (LSM hooks) = 22
>
> Memory bloat:
>
>  +256 B - L1 lookup table
>  + 72 B - extra effective[] slots
>  + 72 B - extra progs[] slots
>  + 36 B - extra flags[] slots
>  -184 B - savings from switching to hlist_head
>  ------
>  +252 B per cgroup instance
>
> Total cgroup_bpf{} size change - 720 B -> 968 B.
>
> WDYT?

Sounds workable, thanks! Let me try and see how it goes. I guess we
don't even have to increase the size of the effective array with this
mode,;having 23 unique slots per cgroup seems like a good start? So
the cgroup_bpf{} growth would be +256B L1 (technically, we only need 5
bits per entry, so can shrink to 160B) -185B for hlist_head

> [^1] It looks like we can easily switch from cgroup->bpf.progs[] from
>      list_head to hlist_head and save some bytes!
>
>      We only access the list tail in __cgroup_bpf_attach(). We can
>      either iterate over the list and eat the cost there or push the new
>      prog onto the front.
>
>      I think we treat cgroup->bpf.progs[] everywhere like an unordered
>      set. Except for __cgroup_bpf_query, where the user might notice the
>      order change in the BPF_PROG_QUERY dump.


[...]

> [^2] Unrelated, but we would like to propose a
>      CGROUP_INET[46]_POST_CONNECT hook in the near future to make it
>      easier to bind UDP sockets to 4-tuple without creating conflicts:
>
>      https://github.com/cloudflare/cloudflare-blog/tree/master/2022-02-connectx/ebpf_connect4

Do you think those new lsm hooks can be used instead? If not, what's missing?
