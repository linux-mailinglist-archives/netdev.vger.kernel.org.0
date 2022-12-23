Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38856654BDE
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 05:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiLWEGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 23:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiLWEGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 23:06:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32E4BE02
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 20:06:42 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gv5-20020a17090b11c500b00223f01c73c3so6774716pjb.0
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 20:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ITHvQmWzjt4zer3CNXL+osA3IW9wZQ/oBnc+oe/0zSw=;
        b=InIJ9eELcaHbC4ZGs2CubzdiThHLMg3Vm3VB2egMysUQ/r5hsNMnYn8XBxcl8GfXNx
         O/NbaIcrDdfxhOcamgiVUL7lJI2E+GXVZMc195RwgumHv2+VZo8v7ujVXzGwFDXPRqb3
         OJbzELAf/jESJCsaNyeEFTAPYzwUHclacPV0rdQDzgXZZkq9b54PY1vBspnmujNYK0UI
         9nsI0l9Ptvr8B0JwUVshGjN/muG5MBOeX97/OxAKvYEiDXRv5/tYPhpHu/Du7Wn/j2Ly
         oEMItfN3065mt5+5Q/D1CD77tDondCXtbDxti5J0pKG+U9KjcK+hVAa6gOQZamQux1f9
         XFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ITHvQmWzjt4zer3CNXL+osA3IW9wZQ/oBnc+oe/0zSw=;
        b=SrkYnU7Kpg8kPlNgfIC/fDqTxUKeHYE3wLNbHFnIsj32DGF31ERROMeS3ZmUHphiyw
         oUWnTjWZblY47kbUnApChoJCof+9JFC/6R3VnN+vvxg64p78hkXhRHzFS+ejMQppGvA5
         cPwPzOw4mCFF/S/miSpTKlAA+9DoCw07VOzhpsFePA8NGAWixRj6oIqcHTRz669PEfF7
         HqJi+ThfRipKbtlMtVu3xSp026lqh6grYZqVBeGU8W6V/Jiam653yIOsP/da3teWZXpM
         Q7LsAx8LYzevKiPmHmiX3rmlIUtKbFJuJ0oG1EXN5oYjR8mKQL69QKuHml3q4sxYnxE5
         DrdA==
X-Gm-Message-State: AFqh2koyEvH2Ohjck+4GmlBOyVvjr7lnM3urMJQHALm2tKLXQZM9h4+b
        OpVzkLeC98xlIoWewnfWvE8rjxL4LNOymsrBO0lWhQ==
X-Google-Smtp-Source: AMrXdXtqE79Qj/QkPzBcfCF0FkxqqExxPPwynaoKhVENrm5UQrlSkX7IPplsQHXCangdFGrfm4K9w8E5n48UhPQ7b+Q=
X-Received: by 2002:a17:90a:8b92:b0:218:9107:381b with SMTP id
 z18-20020a17090a8b9200b002189107381bmr723809pjn.75.1671768402262; Thu, 22 Dec
 2022 20:06:42 -0800 (PST)
MIME-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com> <20221220222043.3348718-8-sdf@google.com>
 <00810419-c76c-32da-16a6-27c1029e3a60@linux.dev>
In-Reply-To: <00810419-c76c-32da-16a6-27c1029e3a60@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 22 Dec 2022 20:06:30 -0800
Message-ID: <CAKH8qBsrbC7C5SxVzZh+qzqN6eb5yQ5K70-9PAudHJsrLQ0O9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 07/17] bpf: XDP metadata RX kfuncs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 4:31 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 12/20/22 2:20 PM, Stanislav Fomichev wrote:
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index bafcb7a3ae6f..6d81b14361e3 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -2097,6 +2097,14 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
> >       if (fp->kprobe_override)
> >               return false;
> >
> > +     /* XDP programs inserted into maps are not guaranteed to run on
> > +      * a particular netdev (and can run outside driver context entirely
> > +      * in the case of devmap and cpumap). Until device checks
> > +      * are implemented, prohibit adding dev-bound programs to program maps.
> > +      */
> > +     if (bpf_prog_is_dev_bound(fp->aux))
> > +             return false;
> > +
>
> There is a recent change in the same function in the bpf tree, commit
> 1c123c567fb1. fyi.

Thanks for the heads up; looks like it won't conflict, right?

> [ ... ]
>
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index fdfdcab4a59d..320451a0be3e 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -2081,6 +2081,22 @@ static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env, s16 offset)
> >       return btf_vmlinux ?: ERR_PTR(-ENOENT);
> >   }
> >
> > +int bpf_dev_bound_kfunc_check(struct bpf_verifier_env *env,
> > +                           struct bpf_prog_aux *prog_aux)
>
> nit. Move the dev bound related function to offload.c. &env->log can be passed
> instead of env and then use bpf_log().

Sure, SG!

> Others lgtm.
>
