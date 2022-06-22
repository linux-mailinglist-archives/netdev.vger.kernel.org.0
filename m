Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65E35552D2
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 19:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377451AbiFVRtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 13:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376980AbiFVRtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 13:49:14 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C1832EC8
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:49:13 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z11so18794447edp.9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rlDSAPctE0EJecdMHo4GLxVrkzYccxxM0XqXwWT0qtc=;
        b=d8pXzhOjFhIfHaTrTJaEBGuxbslJVA3UQS5ihnBhlcyyWFpm4RNYHtrqvqCDpMuY0x
         pQ9neSs4Vaqkd3XxtyrQkbTSsyoUjOQRIyAnoEextIs+Z8rV7+dI4nmlv3c8oLpkCbWH
         VJXFbyzjTrRJq4i8dbA2cqrQtQGf51VDcMmy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rlDSAPctE0EJecdMHo4GLxVrkzYccxxM0XqXwWT0qtc=;
        b=qrZJw//RLMA5evlc/kp73bKNcrDUATm+J+5BxYIyssfoL1uFEvoIvzTI0G4ywhp+XF
         9upqb+JjyKUDIx2jvzi+xMk4RCamqYm+QXjh2ro6cYOcDnyAj8Ptw4MHSKjzWedvuHaN
         I0J3W0+sAGPe5TvgdokA1uuxsWmBVN09wAjVmYX6xKG9Low6L8MvfsbjMa4jvU/A3MBO
         LD9EgqlwgfGe2X5gaSpUwFnE0jD/napGvD74daAdXTCnXu6fxpbjWdGvG3xG9T2QWqLQ
         lzy7RzjMlzYMaccdecDcIJ2Y0Neoa09Nnu1+oQniSNH+9+5njpHCcnKwVb1Td0S2kgwL
         XSFg==
X-Gm-Message-State: AJIora8xyABtZPyQO6n8Vng9CPuKl3XnhN8+n+MTdkUIE1siIOC283CP
        cRiewjGR13YB4MywhPs12tWJJYvgvIRxmlCk
X-Google-Smtp-Source: AGRyM1vO+DhST4oz9G24DjB9U6xLZQyiF1x3BVqU82pi5DcO5w7Xq7andcxPl6A7Z/xNM4+hmmJADg==
X-Received: by 2002:a05:6402:51d3:b0:431:6c7b:28d with SMTP id r19-20020a05640251d300b004316c7b028dmr5354162edd.281.1655920152274;
        Wed, 22 Jun 2022 10:49:12 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id bn11-20020a170906c0cb00b006fed062c68esm1260513ejb.182.2022.06.22.10.49.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 10:49:11 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id j5-20020a05600c1c0500b0039c5dbbfa48so83906wms.5
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 10:49:10 -0700 (PDT)
X-Received: by 2002:a05:600c:681:b0:3a0:2da6:d173 with SMTP id
 a1-20020a05600c068100b003a02da6d173mr1160427wmn.68.1655920150368; Wed, 22 Jun
 2022 10:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <YrLtpixBqWDmZT/V@debian> <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
 <YrMu5bdhkPzkxv/X@dev-arch.thelio-3990X> <CAHk-=wjTS9OJzggD8=tqtj0DoRCKhjjhpYWoB=bPQAv3QMa+eA@mail.gmail.com>
 <YrNQrPNF/XfriP99@debian>
In-Reply-To: <YrNQrPNF/XfriP99@debian>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 22 Jun 2022 12:48:54 -0500
X-Gmail-Original-Message-ID: <CAHk-=wjje8UdsQ_mjGVF4Bc_TcjAWRgOps7E_Cytg4xTbXfyig@mail.gmail.com>
Message-ID: <CAHk-=wjje8UdsQ_mjGVF4Bc_TcjAWRgOps7E_Cytg4xTbXfyig@mail.gmail.com>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang support")
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_RED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 12:26 PM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> Tried it after applying your patch. There was no build failure, but some warnings:

So some of those objtool warnings are, I think, because clang does odd
and crazy things for when it decides "this is not reachable" code.

I don't much like it, and neither does objtool, but it is what it is.
When clang decides "I'm calling a function that cannot return", it
will have a "call" instruction and then it will just fall off the face
of the earth after that.

That includes falling through to the next function, or just to random
other labels after the function, and then objtool as a result
complains about a stack state mismatch (when the fallthrough is the
same function, but now the stack pointer is different in different
parts), or of the "falls through to next function".

I think it's a clang misfeature in that if something goes wrong, you
basically execute random code. I'd much rather see clang insert a real
'ud' instruction or 'int3' or whatever. But it doesn't.

I didn't check whether gcc avoids that "don't make assumptions about
non-return functions" or whether it's just that objtool recognizes
whatever pattern gcc uses.

So *some* of the warnings are basically code generation disagreements,
but aren't signs of actual problems per se.

Others may be because objdump knows about gcc foibles in ways it
doesn't know about some clang foibles. I think the "call to memcpy()
leaves .noinstr.text section" might be of that type: clang seems to
sometimes generate out-of-line memcpy calls for absolutely ridiculous
things (I've seen a 16-byte memcpy done that way - just stupid when
it's just two load/store pairs, and just the function call overhead is
much more than that).

And then a couple seem to be real mis-features in our code:

> arch/x86/kvm/kvm.o: warning: objtool: emulator_cmpxchg_emulated+0x705: call to __ubsan_handle_load_invalid_value() with UACCESS enabled
> arch/x86/kvm/kvm.o: warning: objtool: paging64_update_accessed_dirty_bits+0x39e: call to __ubsan_handle_load_invalid_value() with UACCESS enabled
> arch/x86/kvm/kvm.o: warning: objtool: paging32_update_accessed_dirty_bits+0x390: call to __ubsan_handle_load_invalid_value() with UACCESS enabled
> arch/x86/kvm/kvm.o: warning: objtool: ept_update_accessed_dirty_bits+0x43f: call to __ubsan_handle_load_invalid_value() with UACCESS enabled

and I actually sent email to the kvm and x86 people involved in those
code sequences. It's the __try_cmpxchg_user() macro that isn't great.

Not a fatal problem, but a sign of something we should do better, and
that one doesn't seem to be due to any actual clang misfeature.

> The build took 16 minutes 6 seconds on the build machines in my office (Codethink).

Oh yeah. I'm on a laptop that is a few years old (good laptop, just
not top-of-the-line any more), and it's been chugging along for almost
two hours by now. It's still working on it, and making "solid
progress". But it does not seem to have hit any other failures after
that memcpy fixlet, so I guess I will get to that successful end some
time soon.

I don't typically do allmodconfig builds while on the road, much less
with clang. With gcc, I seem to recall it being a bit over an hour.
Clang is worse.

              Linus
