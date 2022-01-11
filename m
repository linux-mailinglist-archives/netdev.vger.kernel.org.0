Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A896C48B17F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349756AbiAKQBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:01:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36878 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243724AbiAKQBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:01:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF172B81BFC;
        Tue, 11 Jan 2022 16:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A45C36AEB;
        Tue, 11 Jan 2022 16:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641916896;
        bh=CQgqKlu92zeQ40myiuVq09uscHk3R4B09Rx0+uBbAzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ETCc+O4Qmxi8D3a3vLU3TSJXSwVCppBfKIlxKlmz6/EZlSYtzXlYdG4jjwJM427TM
         roqLX8d3nu+ccChPI2Eyj7aCrwIy1PFsnWKA3U3TaRYJ2Dw1C9JEmgZ7Gok4eisXLA
         3aj6riSZjr12cPbv756kPB3iW1YdZOQM2BDqw0Wv5xzUBUpZdaC9fwtVe/Hjq1IWeP
         ww7Bnj7enVtGeQRSNlilMJkXHhhvmq5rXltk9qwnxVOsRJEhJ6z949ox2Uy/vrRLKN
         BlFKXSOGeJBmz+gjpVZaNyrYESEETpGWawAI45o8Pg9RpnehXCRGGq/zY2X1KuhJPc
         rAPU4IYHHiHUg==
Date:   Tue, 11 Jan 2022 09:01:32 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Subject: Re: [GIT PULL] Networking for 5.17
Message-ID: <Yd2p3IbHJdzNok+1@archlinux-ax161>
References: <20220110025203.2545903-1-kuba@kernel.org>
 <CAHk-=wg-pW=bRuRUvhGmm0DgqZ45A0KaH85V5KkVoxGKX170Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg-pW=bRuRUvhGmm0DgqZ45A0KaH85V5KkVoxGKX170Xg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 07:31:30PM -0800, Linus Torvalds wrote:
> I really wish we had more automation doing clang builds. Yes, some
> parts of the kernel are still broken with clang, but a lot isn't, and
> this isn't the first time my clang build setup has found issues.

As far as I know, we have four major groups doing regular build testing
with clang:

* Intel's kernel test robot
* KernelCI
* RedHat's Continuous Kernel Integration (CKI)
* Linaro's Linux Kernel Functional Testing (LKFT)

I regularly check the daily -next report that we get from KernelCI to
see what breakage there is and triage it as needed. The rest email us as
things break. The Intel folks are the only ones building from the
mailing list as far as I can tell, everyone else mainly targets your
tree and/or -next.

I don't think this particular issue was an automation fail, more of a
timing one, as the warning was reported by the kernel test robot:

https://lore.kernel.org/r/202201101850.vQyjtIwg-lkp@intel.com/

However, it was reported a little under a day after the patch hit the
mailing list according to the lore timestamps at the bottom, after it
had already been merged into net-next (it looks like they were applied
to the netfilter tree and merged into net-next within an hour or so).

Pablo did sent a follow up fix rather quickly, which I noticed because
my own local builds were broken.

https://lore.kernel.org/r/20220110221419.60994-1-pablo@netfilter.org/

Normally, I try to review patches like this so that the maintainers are
aware that the warning will break a build with CONFIG_WERROR. In this
case, I assumed that the netdev build tests would catch it and it would
be applied before the pull request was sent, as they have started
testing with clang and catching these warnings before accepting patches
but as Jakub said, that did not happen.

I'll try to keep an eye out for this stuff in the future, so that it is
dealt with by the time you get it, especially now that passing -Werror
is expected. Most standard arm64 and x86_64 configs should be completely
warning free with clang now, arm and some of the more exotic
architectures are still a WIP.

Cheers,
Nathan
