Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109CE42DB65
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhJNOY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhJNOYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:24:55 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB3CC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:22:50 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id z11so26750399lfj.4
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Okqf4cnxYE2FjVdlyGWzuWegB5o4GhJUuUv5TbPoZBA=;
        b=DGrABGEtP5hjLIs/K1pNqbk2y6fYRbTTyPPSrc7s4OG9i6hCAmcTe5jL1IVGbdybNm
         n0QifbSEMlrGOg4m4tPIegguFfiIUWJvHDSXCODQQ2YBybjOAwh0WVR136yqcH7zOo2W
         De5kAU5D+EBLEhVYxyJSKgs4GEFiD3QIS417M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Okqf4cnxYE2FjVdlyGWzuWegB5o4GhJUuUv5TbPoZBA=;
        b=fOp2VLXh43En4nNsDvcE5yi8kMBM4KV7e3MaziaL3NB9U7/gSZcK68UZFQQwyOzryd
         PJ5Eho9sMr2aLgvLhr/vy7T+3mzkc8G2BabMoMuQS5JGGVpO02paaAkI+QYCw+fPxx1s
         NMgHtTEeA/OwK7NF7W4AfJfQsuoR5FYz3q9no0y7VWAVPFMTBHpeFQi2FkiILx4DVUD0
         0zeLajCVm3o0RmGapGsOdUl8clSt3hu5puYM7DQUXyn4KE1mlA/o6wF3/A4duWNWyDih
         xszMrF8zscHxTLfFXKynNWYO/C7x7nS2gKyn5pv74Nmu8vRwqw4WaJGgI/bf1ZhEEU3K
         3Bgg==
X-Gm-Message-State: AOAM530wpDXMs5KAxMtuvEK6xv+hK4JDO8taW6DJ/y6Br5N2HXf/OYpe
        JlAIpH0Q+NNSFfQuLqGtqtDBC1InnZ7y4ez0SAM+YQ==
X-Google-Smtp-Source: ABdhPJwH/KSfANj7WAISJ4X/OGGDRL8CEswJt/vSOXqtZNnUmhmfUOPmS/catGq1ZLRDado7y9BjlPPYtSlde7lnKe4=
X-Received: by 2002:a05:6512:314b:: with SMTP id s11mr5650906lfi.206.1634221358158;
 Thu, 14 Oct 2021 07:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211012135935.37054-1-lmb@cloudflare.com> <87wnmgg0mf.fsf@cloudflare.com>
In-Reply-To: <87wnmgg0mf.fsf@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 14 Oct 2021 15:22:26 +0100
Message-ID: <CACAyw99FGc_z2zXjrjP=0k3jz0vz2u6ddiGVbzD0zuTcTU4rzg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Fix up bpf_jit_limit some more
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-riscv@lists.infradead.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 at 20:56, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Tue, Oct 12, 2021 at 03:59 PM CEST, Lorenz Bauer wrote:
> > Some more cleanups around bpf_jit_limit to make it readable via sysctl.
> >
> > Jakub raised the point that a sysctl toggle is UAPI and therefore
> > can't be easily changed later on. I tried to find another place to stick
> > the info, but couldn't find a good one. All the current BPF knobs are in
> > sysctl.
> >
> > There are examples of read only sysctls:
> > $ sudo find /proc/sys -perm 0444 | wc -l
> > 90
> >
> > There are no examples of sysctls with mode 0400 however:
> > $ sudo find /proc/sys -perm 0400 | wc -l
> > 0
> >
> > Thoughts?
>
> I threw this idea out there during LPC already, that it would be cool to
> use BPF iterators for that. Pinned/preloaded iterators were made for
> dumping kernel data on demand after all.
>
> What is missing is a BPF iterator type that would run the program just
> once (there is just one thing to print), and a BPF helper to lookup
> symbol's address.
>
> I thought this would require a bit of work, but actually getting a PoC
> (see below) to work was rather pleasntly straightforward.
>
> Perhaps a bit of a hack but I'd consider it as an alternative.

I spoke to Jakub, I won't have time to work on this myself. So I'll
drop this patch from the series and send a v3 with just the fixes to
bpf_jit_limit.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
