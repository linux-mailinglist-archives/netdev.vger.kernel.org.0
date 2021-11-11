Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A071144D9BD
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhKKQFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbhKKQFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 11:05:10 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C00C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:02:21 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d5so10639932wrc.1
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bDuzR6qrpIaG+DLSeA8IJ5SQ6AI4r8c/Pg4Hsn9qU78=;
        b=Qzs9akK35Oj8SMTc8lGADi6CsUS/zgaMExmbEkmpcH7Noy7H10hV7owoA/neIfYg3s
         ZxfkQFaVPjl27qNh9rUETl30+JecvqsW5SZSRsTbU/HjiBW1VNIAM8LinMmkbz/hT3H9
         QM0Wc8nAgX2pxsJnvBskGuUIDA+DVItg8lVoAi8NKCfVO6vNoEivO5vL86fVUERpm9be
         QCQU8Bwh7qaVp9NJwah7+XPv428/OpBvts9rPp80ePtkd5Kgo9TydvVq9CNiyqKWVq7F
         uiVGdLbYeHc42Gf3d4nqQEMnDEqSBtORraFIDOnPi5MqKya3bYjMFuiIgtbXazCbllq4
         Aacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bDuzR6qrpIaG+DLSeA8IJ5SQ6AI4r8c/Pg4Hsn9qU78=;
        b=pa1nBKI9S6T7pwMYa8pPKC7hSo8QJJN6aCb3ZYttSuaZ9YGX75ssmjpuArGez+QI2+
         WfK0Q2yqNicB+hDlCcWQdXH2wRGrAJ9XW+p8toYI0zsTe0RItKh2DKtV87472s3VV9Bo
         OID78EHX1nPA6Mq7llKSzwam+HvJeF6vbUR91ueVvtYEnqEGMd0WJJLNNkZviLJ6xEU7
         thJYSVMNs9X3EwxhX4d9zK07qPzwIjWrrZPqhPbSQF1PfwE0Z23RUwsIKP9SXzIMU5s1
         Ii7/wwMPouXA8GvYE4x5BeZzI2ZpCMnRr9kqN1xaxGlgOozino3y+dN7/+H8nGS5rHSY
         0DYw==
X-Gm-Message-State: AOAM531Ox8ug1NSsjeoNvU/iq6HMg4fnqEvT6UgaKMfwpDcWi3PlSsRi
        iLO8R2BtIwv/+K9fkcuv6ZQfsrq4nrDNb+C95ei3NyPC1cQrDQ==
X-Google-Smtp-Source: ABdhPJx+4W4ElHJAMGqO0gqCcnIVpGCCXAqwblF01vq+Zz0i260LiMBnwb9nHwN6d5zXZ7RA4rwnlx2fm9V03Pm0BB0=
X-Received: by 2002:a05:6000:1548:: with SMTP id 8mr10553075wry.279.1636646539429;
 Thu, 11 Nov 2021 08:02:19 -0800 (PST)
MIME-Version: 1.0
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
 <YYzd+zdzqUM5/ZKL@hirez.programming.kicks-ass.net> <YYzl8/7N+Tv/j0RV@hirez.programming.kicks-ass.net>
In-Reply-To: <YYzl8/7N+Tv/j0RV@hirez.programming.kicks-ass.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 11 Nov 2021 08:02:07 -0800
Message-ID: <CANn89i+qjOpL9eYj=F2Mg-rLduQob4tOZcEUZeB5v0Zz3p6Qqw@mail.gmail.com>
Subject: Re: [RFC] x86/csum: rewrite csum_partial()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, x86@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 1:44 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Nov 11, 2021 at 10:10:19AM +0100, Peter Zijlstra wrote:
> > On Wed, Nov 10, 2021 at 10:53:22PM -0800, Eric Dumazet wrote:
> > > +           /*
> > > +            * This implements an optimized version of
> > > +            * switch (dwords) {
> > > +            * case 15: res = add_with_carry(res, buf32[14]); fallthrough;
> > > +            * case 14: res = add_with_carry(res, buf32[13]); fallthrough;
> > > +            * case 13: res = add_with_carry(res, buf32[12]); fallthrough;
> > > +            * ...
> > > +            * case 3: res = add_with_carry(res, buf32[2]); fallthrough;
> > > +            * case 2: res = add_with_carry(res, buf32[1]); fallthrough;
> > > +            * case 1: res = add_with_carry(res, buf32[0]); fallthrough;
> > > +            * }
> > > +            *
> > > +            * "adcl 8byteoff(%reg1),%reg2" are using either 3 or 4 bytes.
> > > +            */
> > > +           asm("   call 1f\n"
> > > +               "1: pop %[dest]\n"
> >
> > That's terrible. I think on x86_64 we can do: lea (%%rip), %[dest], not
> > sure what would be the best way on i386.
> >
> > > +               "   lea (2f-1b)(%[dest],%[skip],4),%[dest]\n"
> > > +               "   clc\n"
> > > +               "   jmp *%[dest]\n               .align 4\n"
> >
> > That's an indirect branch, you can't do that these days. This would need
> > to use JMP_NOSPEC (except we don't have a !ASSEMBLER version of that.
> > But that would also completely and utterly destroy performance.
> >
> > Also, objtool would complain about this if it hadn't tripped over that
> > first instruction:
> >
> >  arch/x86/lib/csum-partial_64.o: warning: objtool: do_csum()+0x84: indirect jump found in RETPOLINE build
> >
> > I'm not sure what the best way is to unroll loops without using computed
> > gotos/jump-tables though :/
> >
> > > +               "2:\n"
> > > +               "   adcl 14*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 13*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 12*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 11*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 10*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 9*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 8*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 7*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 6*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 5*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 4*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 3*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 2*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 1*4(%[src]),%[res]\n   .align 4\n"
> > > +               "   adcl 0*4(%[src]),%[res]\n"
> > > +               "   adcl $0,%[res]"
> >
> > If only the CPU would accept: REP ADCL (%%rsi), %[res]   :/
> >
> > > +                   : [res] "=r" (result), [dest] "=&r" (dest)
> > > +                   : [src] "r" (buff), "[res]" (result),
> > > +                     [skip] "r" (dwords ^ 15)
> > > +                   : "memory");
> > > +   }
>
> This is the best I could come up with ...
>
> --- a/arch/x86/lib/csum-partial_64.c
> +++ b/arch/x86/lib/csum-partial_64.c
> @@ -32,7 +32,6 @@ static inline unsigned short from32to16(
>   */
>  static unsigned do_csum(const unsigned char *buff, unsigned len)
>  {
> -       unsigned long dwords;
>         unsigned odd, result = 0;
>
>         odd = 1 & (unsigned long) buff;
> @@ -64,50 +63,54 @@ static unsigned do_csum(const unsigned c
>                 result = add32_with_carry(temp64 >> 32, temp64 & 0xffffffff);
>         }
>
> -       dwords = len >> 2;
> -       if (dwords) { /* dwords is in [1..15] */
> -               unsigned long dest;
> -
> -               /*
> -                * This implements an optimized version of
> -                * switch (dwords) {
> -                * case 15: res = add_with_carry(res, buf32[14]); fallthrough;
> -                * case 14: res = add_with_carry(res, buf32[13]); fallthrough;
> -                * case 13: res = add_with_carry(res, buf32[12]); fallthrough;
> -                * ...
> -                * case 3: res = add_with_carry(res, buf32[2]); fallthrough;
> -                * case 2: res = add_with_carry(res, buf32[1]); fallthrough;
> -                * case 1: res = add_with_carry(res, buf32[0]); fallthrough;
> -                * }
> -                *
> -                * "adcl 8byteoff(%reg1),%reg2" are using either 3 or 4 bytes.
> -                */
> -               asm("   call 1f\n"
> -                   "1: pop %[dest]\n"
> -                   "   lea (2f-1b)(%[dest],%[skip],4),%[dest]\n"
> -                   "   clc\n"
> -                   "   jmp *%[dest]\n               .align 4\n"
> -                   "2:\n"
> -                   "   adcl 14*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 13*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 12*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 11*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 10*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 9*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 8*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 7*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 6*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 5*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 4*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 3*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 2*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 1*4(%[src]),%[res]\n   .align 4\n"
> -                   "   adcl 0*4(%[src]),%[res]\n"
> -                   "   adcl $0,%[res]"
> -                       : [res] "=r" (result), [dest] "=&r" (dest)
> -                       : [src] "r" (buff), "[res]" (result),
> -                         [skip] "r" (dwords ^ 15)
> -                       : "memory");
> +       if (len >> 2) { /* dwords is in [1..15] */
> +               if (len >= 32) {
> +                       asm("   addl 0*4(%[src]),%[res]\n"
> +                           "   adcl 1*4(%[src]),%[res]\n"
> +                           "   adcl 2*4(%[src]),%[res]\n"
> +                           "   adcl 3*4(%[src]),%[res]\n"
> +                           "   adcl 4*4(%[src]),%[res]\n"
> +                           "   adcl 5*4(%[src]),%[res]\n"
> +                           "   adcl 6*4(%[src]),%[res]\n"
> +                           "   adcl 7*4(%[src]),%[res]\n"
> +                           "   adcl $0,%[res]"
> +                           : [res] "=r" (result)
> +                           : [src] "r" (buff), "[res]" (result)
> +                           : "memory");
> +                       buff += 32;
> +                       len -= 32;
> +               }
> +               if (len >= 16) {
> +                       asm("   addl 0*4(%[src]),%[res]\n"
> +                           "   adcl 1*4(%[src]),%[res]\n"
> +                           "   adcl 2*4(%[src]),%[res]\n"
> +                           "   adcl 3*4(%[src]),%[res]\n"
> +                           "   adcl $0,%[res]"
> +                           : [res] "=r" (result)
> +                           : [src] "r" (buff), "[res]" (result)
> +                           : "memory");
> +                       buff += 16;
> +                       len -= 16;
> +               }
> +               if (len >= 8) {
> +                       asm("   addl 0*4(%[src]),%[res]\n"
> +                           "   adcl 1*4(%[src]),%[res]\n"
> +                           "   adcl $0,%[res]"
> +                           : [res] "=r" (result)
> +                           : [src] "r" (buff), "[res]" (result)
> +                           : "memory");
> +                       buff += 8;
> +                       len -= 8;
> +               }
> +               if (len >= 4) {
> +                       asm("   addl 0*4(%[src]),%[res]\n"
> +                           "   adcl $0,%[res]"
> +                           : [res] "=r" (result)
> +                           : [src] "r" (buff), "[res]" (result)
> +                           : "memory");
> +                       buff += 4;
> +                       len -= 4;
> +               }
>         }
>
>         if (len & 3U) {
> @@ -120,7 +123,7 @@ static unsigned do_csum(const unsigned c
>                 if (len & 1)
>                         result += *buff;
>         }
> -       if (unlikely(odd)) {
> +       if (unlikely(odd)) {
>                 result = from32to16(result);
>                 result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
>         }

Thanks Peter !

This is more or less the first version I wrote. (I was doing tests for
(len & 32), (len & 16) .. to not have to update len in these blocks.

Then, I tried to add an inline version, a la ip_fast_csum() but for IPv6.

Then I came up with the version I sent, for some reason my .config had
temporarily disabled CONFIG_RETPOLINE,
thanks for reminding me this !

I also missed this warning anyway :
arch/x86/lib/csum-partial_64.o: warning: objtool: csum_partial()+0x2f:
unannotated intra-function call

I will spend a bit more time on this before sending a V2, thanks again !
