Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6004D3FB2
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239264AbiCJDaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239261AbiCJDaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:30:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8A6129BA3;
        Wed,  9 Mar 2022 19:29:15 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b8so4070001pjb.4;
        Wed, 09 Mar 2022 19:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z81rwdtDhjjTMgfqS+flHeVEa6soorfyu2+dKLX3nwY=;
        b=FWdzWhoo49xK+2dkuNUo3Wtp7XtoxJHFh3cv29/c34pRupXhSR/t4/bynvzSzaUNuL
         661a9b3QZFqW/M2YejUwQK4yJJR7eWrAr3fMuAI5Db81Bwna4oEionbtvGLa1bvMGQRl
         hXqXP6VN6/USeuz5xCvF46iWE6YWX5nBMbQ+AXBCXsQ6le8llU3Ko3RxBMJgyNg5nZzs
         6YjMA+th3SIBRuCZanGkRawE6QAcSbtxbX3kR2ZOvFNPWwkijt8A7eKkX0owB90z/+AX
         KIVlKNd4LWd7t5pXn3ZZ/PBEFzaj2qA+n/ImWP6kX440CW2oSawiU0VjYFBDpSip8upg
         COOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z81rwdtDhjjTMgfqS+flHeVEa6soorfyu2+dKLX3nwY=;
        b=5BScF/j5UqGBOmhRdrCyRTaeZhYLRJSHzsJseA96J5BSGrIEyJOgsYxixcysHGSM+l
         Tl7PmRJembKsadoNc50Z8Lk6z8YWlWM7VjhFJl7AHJUyNb5ZKp3+C5/05W7u3hqB3NUm
         hHYoUL6Wdc+Nm0JKdejgzQkodgwzMdsfG+Lh4JqzQEHwIHNeBL3vP5WXXaT1l94vcDjO
         2Bzp3vP5dIdu1nb3KodpkW00vCydLpdz3V5Hzpl7ZfmWwgNHX4h/wyNYMY1G0Gp2K37V
         x8gHjgUQuTRsIdpzftU7R6rnXL6CJSggwxNEkBFDUSVyt+we6tWQ8PNL2wsKP0b7gjtM
         daZQ==
X-Gm-Message-State: AOAM531DrDGg79zBl1quM2OwF/Zh98+8BdPY1+7FoRQ9mEcQwDGLM+U1
        0mprK8XP9eVA3M+BdECz+cN/lKtPk66jITBR5J0=
X-Google-Smtp-Source: ABdhPJzSL16kEUYU+s4cbA0wAcB/vAgiT7pFnk765thxsZXfZAHm4lNz66ahLGaL96Au+dy8387WDleVYtyHbioxZJo=
X-Received: by 2002:a17:90b:1a81:b0:1bc:c3e5:27b2 with SMTP id
 ng1-20020a17090b1a8100b001bcc3e527b2mr13803406pjb.20.1646882954707; Wed, 09
 Mar 2022 19:29:14 -0800 (PST)
MIME-Version: 1.0
References: <20220309123321.2400262-1-houtao1@huawei.com> <20220309123321.2400262-4-houtao1@huawei.com>
 <20220309232253.v6oqev7jock7vm7i@ast-mbp.dhcp.thefacebook.com> <06abdc4e-8806-10dd-c753-229d3e957add@huawei.com>
In-Reply-To: <06abdc4e-8806-10dd-c753-229d3e957add@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Mar 2022 19:29:03 -0800
Message-ID: <CAADnVQKr12ZRLroU85YC2GvA+WQoFm0On-5yaLE43hy4p8PRJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] bpf: Fix net.core.bpf_jit_harden race
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
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

On Wed, Mar 9, 2022 at 5:01 PM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
> On 3/10/2022 7:22 AM, Alexei Starovoitov wrote:
> > On Wed, Mar 09, 2022 at 08:33:20PM +0800, Hou Tao wrote:
> >> It is the bpf_jit_harden counterpart to commit 60b58afc96c9 ("bpf: fix
> >> net.core.bpf_jit_enable race"). bpf_jit_harden will be tested twice
> >> for each subprog if there are subprogs in bpf program and constant
> >> blinding may increase the length of program, so when running
> >> "./test_progs -t subprogs" and toggling bpf_jit_harden between 0 and 2,
> >> jit_subprogs may fail because constant blinding increases the length
> >> of subprog instructions during extra passs.
> >>
> >> So cache the value of bpf_jit_blinding_enabled() during program
> >> allocation, and use the cached value during constant blinding, subprog
> >> JITing and args tracking of tail call.
> > Looks like this patch alone is enough.
> > With race fixed. Patches 1 and 2 are no longer necessary, right?
> Yes and no. With patch 3 applied, the problems described in patch 1 and patch 2
> are gone, but it may recur due to other issue in JIT. So I post these two patch
> together and hope these fixes can also be merged.

What kind of 'issues in JIT'?
I'd rather fix them than do defensive programming.
patch 2 is a hack that should not happen in a correct JIT.
