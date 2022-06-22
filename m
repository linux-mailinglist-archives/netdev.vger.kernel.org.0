Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5131F554E2F
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355512AbiFVPCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbiFVPCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:02:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E5C3DA4A;
        Wed, 22 Jun 2022 08:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C84460DCB;
        Wed, 22 Jun 2022 15:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66E3C34114;
        Wed, 22 Jun 2022 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655910119;
        bh=zyA4bB+WpmPfApZNiZtMY+3UsvHWTNMvaKlfuspt/KY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kFlK9pxh5ILbaWBtxVJa9Ts9c7WIAX0LptP9h8C7xyaf7CdVWUijzfQsyx2OBUP3K
         JsLi+QjyZqiWl2XV3hG7wGkIkM6y0ZwMjN4oO1HupxQMFIOMoXD7sWE/E7nBt0jKSH
         sCSvi8bfrnorwoNVQy9Xml+xYVGxNsV1UOOS/Z0JUi3yduP1xOjxawJomwVNz5bP+I
         Pzd+8rlDg2ASd0/9R4oInrt3aE0YCsKxTHdiec56E/ZVVOiAMEif71JtH0j+epkAMR
         /s7Lu3kjz4r9K92SiswGeu4NbwSRXxAzV2sp58tiE4s4/noxwxFzID39fXyrurWAN9
         5F2tzuuLVGvkQ==
Date:   Wed, 22 Jun 2022 08:01:57 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang
 support")
Message-ID: <YrMu5bdhkPzkxv/X@dev-arch.thelio-3990X>
References: <YrLtpixBqWDmZT/V@debian>
 <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Wed, Jun 22, 2022 at 08:47:22AM -0500, Linus Torvalds wrote:
> On Wed, Jun 22, 2022 at 5:23 AM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > I have recently (since yesterday) started building the mainline kernel
> > with clang-14 and I am seeing a build failure with allmodconfig.

Right, this is known. Kees sent a fix for that warning recently but it
went to net-next instead of net it seems:

https://git.kernel.org/netdev/net-next/c/2c0ab32b73cfe39a609192f338464e948fc39117

I am not sure if that change could be cherry-picked or applied to net so
that it could be fixed in mainline, I see the netdev maintainers are
already on CC so maybe they can comment on that?

> Yeah, the clang build has never been allmodconfig-clean, although I
> think it's starting to get pretty close.

Right, we are almost there with ARCH=arm64 and ARCH=x86_64. Both arm64
and x86_64 suffer from the warning that Sudip reported and arm64 grew a
new warning this release from commit 274d79e51875 ("ASoC: Intel: avs:
Configure modules according to their type"):

  sound/soc/intel/avs/path.c:815:18: error: stack frame size (2176) exceeds limit (2048) in 'avs_path_create' [-Werror,-Wframe-larger-than]
  struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
                   ^
  1 error generated.

I haven't fully figured out what is going wrong with this one, I did
write some analysis on our bug tracker if anyone is curious:

https://github.com/ClangBuiltLinux/linux/issues/1642#issuecomment-1156815611

With those two warnings fixed, arm64 and x86_64 allmodconfig become
-Werror clean with clang-11 through clang-15 on mainline; 5.15 is
already there.

Other architectures aren't that far behind either, ARCH=arm is the worst
one because of KASAN, which has been brought up a few times before
without any real resolution.

> I build the kernel I actually _use_ with clang, and make sure it's
> clean in sane configurations, but my full allmodconfig build I do with
> gcc.
> 
> Partly because of that "the clang build hasn't quite gotten there yet"
> and partly because last I tried it was even slower to build (not a big
> issue for my default config, but does matter for the allmodconfig
> build, even on my beefy home machine)
> 
> I would love for people to start doing allmodconfig builds with clang
> too, but it would require some initial work to fix it... Hint, hint.

Right, we are working on a statically linked and optimized build of LLVM
that people can use similar to the GCC builds provided on kernel.org,
which should make the compile time problem not as bad as well as making
it easier for developers to get access to a recent version of clang with
all the fixes and improvements that we have made in upstream LLVM.

> And in the case of this warning attribute case, the clang error messages are
> 
>  (a) verbose
> 
>  (b) useless
> 
> because they point to where the warning attribute is (I know where it
> is), but don't point to where it's actually triggering (ie where it
> was actually inlined and called from).
> 
> The gcc equivalent of that warning actually says exactly where the
> problem is. The clang one is useless, which is probably part of why
> people aren't fixing them, because even if they would want to, they
> just give up.
> 
> Nick, Nathan, any chance of getting better error messages out of
> clang? In some cases, they are very good, so it's not like clang does
> bad error messages by default. But in this case, the error message
> really is *entirely* useless.

Right, known papercut :( Kees also noticed this and reported it on our
issue tracker:

https://github.com/ClangBuiltLinux/linux/issues/1571

I don't do as much on the LLVM side as Nick so I'll let him comment on
how feasible implementing that in clang will be, he already has some
comments on the issue tracker there.

Cheers,
Nathan
