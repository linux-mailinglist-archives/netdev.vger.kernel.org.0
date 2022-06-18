Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D52E55015E
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 02:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383528AbiFRAdD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jun 2022 20:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiFRAdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 20:33:03 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91C821258;
        Fri, 17 Jun 2022 17:33:01 -0700 (PDT)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id A4F691C0006;
        Sat, 18 Jun 2022 00:32:56 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 18 Jun 2022 02:32:55 +0200
Message-Id: <CKSU5Q2M1IE3.39AS0HDHTZPN@enhorning>
Cc:     <cmllamas@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <kernel-team@android.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: NEEDS FIXING - Was: Re: [PATCH v2] ipv4: ping: fix bind address
 validity check
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     <davem@davemloft.net>
X-Mailer: aerc 0.9.0
References: <20220617085435.193319-1-pbl@bestov.io>
 <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
In-Reply-To: <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Jun 17, 2022 at 1:30 PM CEST,  wrote:
> Hello:
>
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Fri, 17 Jun 2022 10:54:35 +0200 you wrote:
> > Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> > introduced a helper function to fold duplicated validity checks of bind
> > addresses into inet_addr_valid_or_nonlocal(). However, this caused an
> > unintended regression in ping_check_bind_addr(), which previously would
> > reject binding to multicast and broadcast addresses, but now these are
> > both incorrectly allowed as reported in [1].
> > 
> > [...]
>
> Here is the summary with links:
>   - [v2] ipv4: ping: fix bind address validity check
>     https://git.kernel.org/netdev/net/c/b4a028c4d031
>
I receompiled the kernel from the net tree to do some more manual testing
on the patch and I have two things to disclose. Sorry for the caps in
the subject.

TL;DR: I noticed that one of the regressions tests is (correctly)
failing, but for the wrong reasons; and the patch I sent contains a
mistake, and unfortunately it has already been applied to the tree as
commit b4a028c4d0.

Long version below.

1) If you run regression tests with -v, the (correct -- see below) ICMP
tests for broadcast and multicast binding do not fail with
EADDRNOTAVAIL, but with ACCES, but only when run through fcnal-test.sh.
This is also true for one of the additional (commented out) tests you
can find in my patch following this email. I'm not sure why this
happens; however I'm reasonably convinced it is a quirk or a consequence
of the testing methodology/setup. Can anyone offer any insights?

2) My patch is faulty. I had a complete and tested patch, including code
fixing the regression. Instead of sending it, however, I decided to
adapt it to preserve Carlos Llamas' version of ping.c, since they posted
their patch first. In doing so I used a work branch which contained a
faulty version (wrong flags) of the regression tests. The resulting
faulty patch is, unfortunately, currently in the tree.

At this point, due to the unfortunate combination of (1) and (2), it
might be worth reverting the patch altogether and just applying the v1
(i.e. without the regression tests) to the tree and to the relevant LTS
versions.

After that, a more proper discussion can be had about (1), and the
regression tests can be fixed. I'm sending a demonstrative patch for
that as a response to this message.

Riccardo P. Bestetti



> You are awesome, thank you!
> -- 
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

