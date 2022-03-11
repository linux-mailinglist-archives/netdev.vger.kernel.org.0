Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EA54D56C4
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345427AbiCKAdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344995AbiCKAdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:33:37 -0500
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BED403DC;
        Thu, 10 Mar 2022 16:32:35 -0800 (PST)
Received: by mail-lf1-f44.google.com with SMTP id w12so12326407lfr.9;
        Thu, 10 Mar 2022 16:32:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ztmSGKB7K4TQG0uwXYKwyrxqq4V9q91bmnu9QHKsFM=;
        b=2MwkadopyPfXwXX67ck0lWPud4LCq6TUCwwRGsVF7T2/mvK3BxEQ3aqkV+H4UiLSJj
         9Q+k3M9RVRxGWHCQmRlZTvtguZyalS46A5zqDjrj4dRdXeRxawA9iHaVJ9roH1XWlhMF
         P1BTLcFVqlCG6GWqy3VJc/DKDBoyQ5+IqQfueP9v7C+jJHAhripZhOYJjvWyhk7vOSqY
         MBr2j1aJvf/zIxUd/qrezS306XjEpYgvh+XBF+mY2LmwuW+SkzVeoe92APmN8/syVuUb
         ShXU7E0aXj3GuDf9v48kOHJL0ZbaLC0iINhrQuCqyFMrNe4oELt0FQHg27M332am/l55
         /Qpw==
X-Gm-Message-State: AOAM532QxkgCTnqA/iabGTX8WOPZtHodECwjAmbqw1fwvmxD2s389gsN
        Z4aWBVnKP30vE564YAmA3atLFsjDtSw7R+eqUF0=
X-Google-Smtp-Source: ABdhPJw2reDKxUFHjQwClq5bZ6wJKcBClgp6rPeuKYmc/xsc6rmDmb9eLLNsD+F07OPKK9FOPM8ro5q3J05ywZLGPe8=
X-Received: by 2002:a05:6512:1195:b0:448:4fcc:34f2 with SMTP id
 g21-20020a056512119500b004484fcc34f2mr4391524lfr.454.1646958753412; Thu, 10
 Mar 2022 16:32:33 -0800 (PST)
MIME-Version: 1.0
References: <20220310082202.1229345-1-namhyung@kernel.org> <d2af0d13-68cf-ad8c-5b16-af76201452c4@fb.com>
In-Reply-To: <d2af0d13-68cf-ad8c-5b16-af76201452c4@fb.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Thu, 10 Mar 2022 16:32:22 -0800
Message-ID: <CAM9d7chonB2Ev4jGH-ybefD893bfqne=dXFPWLoLb36F8RXm2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] bpf: Adjust BPF stack helper functions to accommodate
 skip > 0
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eugene Loh <eugene.loh@oracle.com>, Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Mar 10, 2022 at 2:55 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/10/22 12:22 AM, Namhyung Kim wrote:
> > Let's say that the caller has storage for num_elem stack frames.  Then,
> > the BPF stack helper functions walk the stack for only num_elem frames.
> > This means that if skip > 0, one keeps only 'num_elem - skip' frames.
> >
> > This is because it sets init_nr in the perf_callchain_entry to the end
> > of the buffer to save num_elem entries only.  I believe it was because
> > the perf callchain code unwound the stack frames until it reached the
> > global max size (sysctl_perf_event_max_stack).
> >
> > However it now has perf_callchain_entry_ctx.max_stack to limit the
> > iteration locally.  This simplifies the code to handle init_nr in the
> > BPF callstack entries and removes the confusion with the perf_event's
> > __PERF_SAMPLE_CALLCHAIN_EARLY which sets init_nr to 0.
> >
> > Also change the comment on bpf_get_stack() in the header file to be
> > more explicit what the return value means.
> >
> > Based-on-patch-by: Eugene Loh <eugene.loh@oracle.com>
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> The change looks good to me. This patch actually fixed a bug
> discussed below:
>
>
> https://lore.kernel.org/bpf/30a7b5d5-6726-1cc2-eaee-8da2828a9a9c@oracle.com/
>
> A reference to the above link in the commit message
> will be useful for people to understand better with an
> example.

Ok, will do.

>
> Also, the following fixes tag should be added:
>
> Fixes: c195651e565a ("bpf: add bpf_get_stack helper")

Sure.

>
> Since the bug needs skip > 0 which is seldomly used,
> and the current returned stack is still correct although
> with less entries, I guess that is why less people
> complains.
>
> Anyway, ack the patch:
> Acked-by: Yonghong Song <yhs@fb.com>

Thanks for your review!

Namhyung


>
>
> > ---
> >   include/uapi/linux/bpf.h |  4 +--
> >   kernel/bpf/stackmap.c    | 56 +++++++++++++++++-----------------------
> >   2 files changed, 26 insertions(+), 34 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index b0383d371b9a..77f4a022c60c 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2975,8 +2975,8 @@ union bpf_attr {
> >    *
> >    *                  # sysctl kernel.perf_event_max_stack=<new value>
> >    *  Return
> > - *           A non-negative value equal to or less than *size* on success,
> > - *           or a negative error in case of failure.
> > + *           The non-negative copied *buf* length equal to or less than
> > + *           *size* on success, or a negative error in case of failure.
> >    *
> >    * long bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *to, u32 len, u32 start_header)
> [...]
