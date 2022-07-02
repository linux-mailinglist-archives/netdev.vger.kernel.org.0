Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5305640ED
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 17:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbiGBPJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 11:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiGBPJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 11:09:34 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAE1BE2E;
        Sat,  2 Jul 2022 08:09:33 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id o190so4985203vsc.5;
        Sat, 02 Jul 2022 08:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=69eVPdFYnzRvWh41cd+F05Rdb0UdGv5MYeKeXlwbdCI=;
        b=ncF9SexWr3pMy9O2KiRgghtqWRh4FO0R0SwmEQeGBNk//scgtIKEWHBcedOzvhvbP5
         3jJ31G3tfkDGBn9s1HGxCHmTKj6Tb7EY6oDjFubTo/E7/bbdBo/qWoEymgR9/QlnJcaX
         cUR6FqxSVwe7lQnMRngUkMHupxBBz9jDhnAAlTpHkCOULRqhKqJDrL2/adJa5gOiPnr6
         BgskCr9AmEGRBGyGI4fXo+iP+C3Tc1F9bmpHDnK5k9o25AGVCS5lqnN7ko5uZ/txJDwU
         4Foubnmq2VK9kmNm3FPfzg2zTCm1+f287ZUQHJ/DhJ+yvIzLKurtCZrdyxpdHZG/h96A
         kljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=69eVPdFYnzRvWh41cd+F05Rdb0UdGv5MYeKeXlwbdCI=;
        b=ErgFJqHL5f/a9oVDaoaPnj7JPsVubZIVA2zVARt5ehr2hTOlzlcnCqxwdfQGS5Rymg
         7AxCqDfhtoSpD3Xi0A77daGOxpqyjwe24p+yKXp7Q+2OywH2zJImvPvih8pkufk8K+Ja
         nOAd5JJDHK389WfYKy0oY5FoB0mkLkxlywq21+Up/ijLfMHaUrR9ql51JTyNNEWIAFvk
         WjJsgTfdhYkvjcFcYodQ4C0NnqI+ST+hwWpKv+qFjIXf3B20sUTgWM+54EJ2GEAaMhmo
         /xgN82qSJ0AZugOtAVcP4AUk5BApyTWtN3d2vNyQcgyxrHMOFXRqjiZh+CDN6ohlytPf
         YCdA==
X-Gm-Message-State: AJIora8SRQr7+pZtjqbhxi/sbjShxIfGwC3Hko5YWP/kBLmi8VPo295k
        DKZhP91lzHhc6JTs9+lCmpyymZZdqANU7FnL9Fl/Xh6G2pw=
X-Google-Smtp-Source: AGRyM1sh6Lon2Hld9nBWtF478yyMHyAhP6cynuZWZ5lOtWJK98sMbtKOUeVd5IgRDMGaYk0b+n7CrUmoPN7HLNaz8cw=
X-Received: by 2002:a67:1945:0:b0:355:ab65:9db3 with SMTP id
 66-20020a671945000000b00355ab659db3mr14137704vsz.22.1656774571464; Sat, 02
 Jul 2022 08:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220629154832.56986-1-laoar.shao@gmail.com> <20220629154832.56986-2-laoar.shao@gmail.com>
 <ede2c8ea-693d-fe70-12a2-bf8ccca97eb0@iogearbox.net> <Yr/GGj+yCD8dZJbp@castle>
In-Reply-To: <Yr/GGj+yCD8dZJbp@castle>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 2 Jul 2022 23:08:54 +0800
Message-ID: <CALOAHbA0sft0M8ibrOrxxT4WwL5ExTWyQc3L6sj6nD47-xHQPQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: Make non-preallocated allocation low priority
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sat, Jul 2, 2022 at 12:14 PM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Thu, Jun 30, 2022 at 11:47:00PM +0200, Daniel Borkmann wrote:
> > Hi Yafang,
> >
> > On 6/29/22 5:48 PM, Yafang Shao wrote:
> > > GFP_ATOMIC doesn't cooperate well with memcg pressure so far, especially
> > > if we allocate too much GFP_ATOMIC memory. For example, when we set the
> > > memcg limit to limit a non-preallocated bpf memory, the GFP_ATOMIC can
> > > easily break the memcg limit by force charge. So it is very dangerous to
> > > use GFP_ATOMIC in non-preallocated case. One way to make it safe is to
> > > remove __GFP_HIGH from GFP_ATOMIC, IOW, use (__GFP_ATOMIC |
> > > __GFP_KSWAPD_RECLAIM) instead, then it will be limited if we allocate
> > > too much memory.
> > >
> > > We introduced BPF_F_NO_PREALLOC is because full map pre-allocation is
> > > too memory expensive for some cases. That means removing __GFP_HIGH
> > > doesn't break the rule of BPF_F_NO_PREALLOC, but has the same goal with
> > > it-avoiding issues caused by too much memory. So let's remove it.
> > >
> > > __GFP_KSWAPD_RECLAIM doesn't cooperate well with memcg pressure neither
> > > currently. But the memcg code can be improved to make
> > > __GFP_KSWAPD_RECLAIM work well under memcg pressure.
> >
> > Ok, but could you also explain in commit desc why it's a specific problem
> > to BPF hashtab?
> >
> > Afaik, there is plenty of other code using GFP_ATOMIC | __GFP_NOWARN outside
> > of BPF e.g. under net/, so it's a generic memcg problem?
>
> I'd be careful here and not change it all together.
>
> __GFP_NOWARN might be used to suppress warnings which otherwise would be too
> verbose and disruptive (especially if we talk about /net allocations in
> conjunction with netconsole) and might not mean a low/lower priority.
>
> > Why are lpm trie and local storage map for BPF not affected (at least I don't
> > see them covered in the patch)?
>
> Yes, it would be nice to fix this consistently over the bpf code.
> Yafang, would you mind to fix it too?
>

I will fix it.

-- 
Regards
Yafang
