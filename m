Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B3A4B75F0
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbiBOTm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 14:42:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiBOTm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 14:42:27 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79E21B7B9
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 11:42:16 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id b20so47966ljf.7
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 11:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=scBaLfaGLWYYxtrlYU1JbIy2UJbbECdZygDHVPbgRRk=;
        b=lJP1yVdHufaCOzEkkjwdzlhxcctxP39rYiSDo8a2MXhB+GgPvhgLw6MCHYH5T5t/FQ
         nSpEnu9AuwpaiPiMgurzncCC3pIY50Fi/JoIzF71JmdI/CidTfrdaU+afI49C2/z/4we
         YnGAyB1qCVxghAFklVWc/ZYuUMF2Z3ATE/ENZqt1LKRrVZfmyMQuwGD2MSyFKI6Zo7gm
         Tsk61FxSAYjYAkDX31UTXa4uG+wyyh5QqcCdsgVR3zst/tkoYtVgN+33IDZLfTwBYBFb
         YHXOYNoumFJw50NPD1yysElaq4kVymT98hLvV4fLbfweVhc2S/NE2TER+lDvYSvPeqZo
         mohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=scBaLfaGLWYYxtrlYU1JbIy2UJbbECdZygDHVPbgRRk=;
        b=q+UBe8XJcY1plTU6T1kQCM4cIp8dTtH1PLeBHDauCZ+DB9P8db3gDZhw/HeY1emtIR
         PsqiOcOP3qgppmQ2dG5RXbCyGZKtLIpgsPX1GSnIG5jDNSdaZQBsUZJUaounH1ohUmvb
         ymqnMZWDsanG8fVqNEwF3jAwKQXN4gCyhJ5NEMUzJA2sV1owofM10BeyWBQnrUIVcvSo
         Fo+1nJ92Epm1Z2mVdX0ZvTGyEtEWhv+6dYSb8nzECE6kDBqfTHNGugGMXls9yjZtwhGl
         X+gScaAT+5FoFNvsC1impaoQCbhyYT2nWUurhHkwE4GO+RcVMzoKa7ZRqy8R6V4N2dmS
         eWbw==
X-Gm-Message-State: AOAM531SpRDJqn0aA1bqAJlZw/lBd/Mm8BdF5fIohYpEftdHrIat3h4N
        Yz3yHKTTSp+nTHrgqBseF4inOMZYGr41qj2hLGrcB+txN+Y=
X-Google-Smtp-Source: ABdhPJzfSSA3stmYRDtGVr8aeAPeZeLZIDE3WmXVsx/LCmKZBtGQxbOB8RdUyWAPezYun7pq/C1CNTW4pBuvRhLj2Hg=
X-Received: by 2002:a05:651c:2121:: with SMTP id a33mr426220ljq.220.1644954134959;
 Tue, 15 Feb 2022 11:42:14 -0800 (PST)
MIME-Version: 1.0
References: <20220214175138.2902947-1-trix@redhat.com> <daabe69d3863caa62f7874a472edbf2bc892d99e.camel@codeconstruct.com.au>
 <6590666e-524d-51c3-0859-f8bf0c43c5ca@redhat.com>
In-Reply-To: <6590666e-524d-51c3-0859-f8bf0c43c5ca@redhat.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 15 Feb 2022 11:42:03 -0800
Message-ID: <CAKwvOd=ntKk7PwtYKWCV_44nf9ccCVDKiGJk_wB4yqfvPFDUbw@mail.gmail.com>
Subject: Re: [PATCH] mctp: fix use after free
To:     Tom Rix <trix@redhat.com>, Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     matt@codeconstruct.com.au, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
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

On Mon, Feb 14, 2022 at 6:16 PM Tom Rix <trix@redhat.com> wrote:
>
>
> On 2/14/22 4:44 PM, Jeremy Kerr wrote:
> > Hi Tom,
> >
> > Also, can you share how you're doing the clang static analysis there?
> > I'll get that included in my checks too.
>
> build clang, then use it
>
> scan-build \
>      --use-cc=clang \
>      make CC=clang

I'm pretty sure we have a make target in Kbuild, too. It uses
clang-tidy as the driver, as clang-tidy can do BOTH the static
analyses AND clang-tidy checks.

$ make LLVM=1 all clang-analyzer

>
> There are a couple of configs that aren't happy with clang, these you
> can sed away with
>
> sed -e 's/CONFIG_FRAME_WARN=2048/CONFIG_FRAME_WARN=0/;
> s/CONFIG_RETPOLINE=y/CONFIG_RETPOLINE=n/;
> s/CONFIG_READABLE_ASM=y/CONFIG_READABLE_ASM=n/;
> s/CONFIG_FORTIFY_SOURCE=y/CONFIG_FORTIFY_SOURCE=n/'
>
> I am using clang 14

-- 
Thanks,
~Nick Desaulniers
