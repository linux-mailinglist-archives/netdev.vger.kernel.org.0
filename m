Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD424550C26
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 18:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbiFSQo7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Jun 2022 12:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiFSQo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 12:44:58 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586F8D119;
        Sun, 19 Jun 2022 09:44:57 -0700 (PDT)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id AEBAA1BF209;
        Sun, 19 Jun 2022 16:44:52 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 19 Jun 2022 18:44:51 +0200
Message-Id: <CKU9GFTASELO.22PM22I90JDM8@enhorning>
Cc:     <davem@davemloft.net>, <cmllamas@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <kernel-team@android.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: Re: NEEDS FIXING - Was: Re: [PATCH v2] ipv4: ping: fix bind address
 validity check
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     "Jakub Kicinski" <kuba@kernel.org>
X-Mailer: aerc 0.9.0
References: <20220617085435.193319-1-pbl@bestov.io>
 <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
 <CKSU5Q2M1IE3.39AS0HDHTZPN@enhorning> <20220617195816.53a2f2cf@kernel.org>
In-Reply-To: <20220617195816.53a2f2cf@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Jun 18, 2022 at 4:58 AM CEST, Jakub Kicinski wrote:
> On Sat, 18 Jun 2022 02:32:55 +0200 Riccardo Paolo Bestetti wrote:
> > I receompiled the kernel from the net tree to do some more manual testing
> > on the patch and I have two things to disclose. Sorry for the caps in
> > the subject.
> > 
> > TL;DR: I noticed that one of the regressions tests is (correctly)
> > failing, but for the wrong reasons; and the patch I sent contains a
> > mistake, and unfortunately it has already been applied to the tree as
> > commit b4a028c4d0.
> > 
> > Long version below.
> > 
> > 1) If you run regression tests with -v, the (correct -- see below) ICMP
> > tests for broadcast and multicast binding do not fail with
> > EADDRNOTAVAIL, but with ACCES, but only when run through fcnal-test.sh.
> > This is also true for one of the additional (commented out) tests you
> > can find in my patch following this email. I'm not sure why this
> > happens; however I'm reasonably convinced it is a quirk or a consequence
> > of the testing methodology/setup. Can anyone offer any insights?
> > 
> > 2) My patch is faulty. I had a complete and tested patch, including code
> > fixing the regression. Instead of sending it, however, I decided to
> > adapt it to preserve Carlos Llamas' version of ping.c, since they posted
> > their patch first. In doing so I used a work branch which contained a
> > faulty version (wrong flags) of the regression tests. The resulting
> > faulty patch is, unfortunately, currently in the tree.
> > 
> > At this point, due to the unfortunate combination of (1) and (2), it
> > might be worth reverting the patch altogether and just applying the v1
> > (i.e. without the regression tests) to the tree and to the relevant LTS
> > versions.
>
> IIUC only the test is faulty / unreliable, correct?
>
> We have until Thursday before this patch hits Linus's tree so should 
> be plenty of time to figure the problem out and apply an incremental
> fix. I see you posted an RFC already, thanks!

I followed that up with a v2 [1] that looks good to me. Fixes the fulty
tests covering the regression, adds a couple more tests similar to what
I added back in November (but for different code paths).

As an additional note, if the regression fix (b4a028c4d0) is candidate
for the LTS, then this patch should probably be as well.

Riccardo P. Bestetti

[1]: https://patchwork.kernel.org/project/netdevbpf/patch/20220619162734.113340-1-pbl@bestov.io/

>
> > After that, a more proper discussion can be had about (1), and the
> > regression tests can be fixed. I'm sending a demonstrative patch for
> > that as a response to this message.

