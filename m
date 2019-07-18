Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457C46D644
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 23:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391162AbfGRVKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 17:10:19 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46161 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbfGRVKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 17:10:19 -0400
Received: by mail-pf1-f195.google.com with SMTP id c73so13162265pfb.13
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 14:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XIOGrPriZRTmOk8GSJmi3uegRPz7ninV7z+aZhuIkLg=;
        b=gihIi9b7oPxy1tx75Cls+nO0enXj3oB8QkxlUTVV/M/G1/kEp22DkodSzf3/LK9W4m
         mrExFCM2INBQTjJInN/mL7aYxr/XE1J0aSWUSEzZ6chI5k21XlvoiuF8jTcs9cGTMMEe
         ZZQgWS+bVdOWdNd61wmtYFWLE76+nk4kkZKYkP6PJisk4aY87RRKIhDpkfvWQiEDfh6X
         enpUlUxRZQMHKwAZ1Z6UHOmbszX37eaNNM88mwbmHA48dD89o2cXynr58EWMw7up6l0f
         K211ghgxv57iC9d2FVVlVKXwS6OGUhUo13tdxlRtalgfxDcc7C6fXxcr9HaLNjhqivyE
         ueIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XIOGrPriZRTmOk8GSJmi3uegRPz7ninV7z+aZhuIkLg=;
        b=K/zfB5hmRifCUI7/vMgDkAc1uAV6eHElS8dUG8VZPz9jaAGT8uCnRs3Gkj9NuONVKY
         h49FUNEzBhWwfwp+eKdDtEK1iDPmfoF88Jz5Gvq2zZDHZM5rb4wto1yJBbLvK8/MdZ2V
         xCrAgVEjfgoxaCedc/e4zDb97ouUXYP3tnJ9XeiW0FFIb4aYpWxJaaJAMw8jYUM1ZLh6
         5tzObp/2zUCgapDcZvMZFU3LZI8Zp1nlU6wqTzD06HctCnFc/Ova4ZuxEywH8qqkCvYQ
         ZlYtl3a5k6j2ygVaRChI5JYCeu7hDlT+V1uN3Cr3nEyEOIZX2x6WQbPzR5fM2JZ3Il7R
         5b4g==
X-Gm-Message-State: APjAAAV7FgwCUAJuaLefrn2bxSdNOqZWFG1d6sa+QMxJT2tqzdp2s4vv
        s9/SCiSqr6+W6ubwFPIL0UBm2SIzmfLKxhyWK4HCQQ==
X-Google-Smtp-Source: APXvYqyfxbJyTy2CnYB4Y3JUva+s3RCza7Yed+0y2RO6CUA/IuyJ9wTiHjUtaSTz2/RvIQ4XBi0RHjtQiQXH47XyKfU=
X-Received: by 2002:a63:2cd1:: with SMTP id s200mr46254603pgs.10.1563484217895;
 Thu, 18 Jul 2019 14:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <1562959401-19815-1-git-send-email-cai@lca.pw> <20190712.154606.493382088615011132.davem@davemloft.net>
 <EFD25845-097A-46B1-9C1A-02458883E4DA@lca.pw> <20190712.175038.755685144649934618.davem@davemloft.net>
 <D7E57421-A6F4-4453-878A-8F173A856296@lca.pw>
In-Reply-To: <D7E57421-A6F4-4453-878A-8F173A856296@lca.pw>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 18 Jul 2019 14:10:06 -0700
Message-ID: <CAKwvOdkCfqfpJYYX+iu2nLCUUkeDorDdVP3e7koB9NYsRwgCNw@mail.gmail.com>
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
To:     Qian Cai <cai@lca.pw>, Bill Wendling <morbo@google.com>,
        James Y Knight <jyknight@google.com>
Cc:     David Miller <davem@davemloft.net>, sathya.perla@broadcom.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, netdev@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 2:01 PM Qian Cai <cai@lca.pw> wrote:
>
>
>
> > On Jul 12, 2019, at 8:50 PM, David Miller <davem@davemloft.net> wrote:
> >
> > From: Qian Cai <cai@lca.pw>
> > Date: Fri, 12 Jul 2019 20:27:09 -0400
> >
> >> Actually, GCC would consider it a const with -O2 optimized level because it found that it was never modified and it does not understand it is a module parameter. Considering the following code.
> >>
> >> # cat const.c
> >> #include <stdio.h>
> >>
> >> static int a = 1;
> >>
> >> int main(void)
> >> {
> >>      if (__builtin_constant_p(a))
> >>              printf("a is a const.\n");
> >>
> >>      return 0;
> >> }
> >>
> >> # gcc -O2 const.c -o const
> >
> > That's not a complete test case, and with a proper test case that
> > shows the externalization of the address of &a done by the module
> > parameter macros, gcc should not make this optimization or we should
> > define the module parameter macros in a way that makes this properly
> > clear to the compiler.
> >
> > It makes no sense to hack around this locally in drivers and other
> > modules.
>
> If you see the warning in the original patch,
>
> https://lore.kernel.org/netdev/1562959401-19815-1-git-send-email-cai@lca.pw/
>
> GCC definitely optimize rx_frag_size  to be a constant while I just confirmed clang
> -O2 does not. The problem is that I have no clue about how to let GCC not to
> optimize a module parameter.
>
> Though, I have added a few people who might know more of compilers than myself.

+ Bill and James, who probably knows more than they'd like to about
__builtin_constant_p and more than other LLVM folks at this point.

-- 
Thanks,
~Nick Desaulniers
