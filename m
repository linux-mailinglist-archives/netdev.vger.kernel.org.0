Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B798550235
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 04:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiFRC6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 22:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237911AbiFRC6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 22:58:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1917B38DA9;
        Fri, 17 Jun 2022 19:58:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7A0661F5D;
        Sat, 18 Jun 2022 02:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81BCC3411B;
        Sat, 18 Jun 2022 02:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655521098;
        bh=te/1XpkUNmq6MV9BQThN7XRjwLAPokCR7ABtjmsHLyI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uZUuup+U1ZMaEej/wdCOMPftyUvTw9k+De0Cv1SbNdXgd7oNZpnBaEmvXcPjNsVxU
         7URtzG1KUDLCsru2yB4oY+vYt32Sseg2s5qYAQGwuiOFdi9WdZVggcoq0JIo5nmNYk
         ELL4c/0HBun5HmnrxCFHZmdNHkrRBAswUsxJXrpUDyILrXODC5DZrfiuc9uvMDrqgq
         KHMU6onBxjlK9hOxkhrudZ/m9QL1jKP+Erzco3roJZM/07gdvFX6m/7oRgRRu19VIs
         DKhXJFVJI+DmVHOnFkdVv+M9ApOg1+WPGo6S6tEf/Jy74XQtgtLpX3XLPJt7y3ZnG6
         G98Nyh0ELTf5g==
Date:   Fri, 17 Jun 2022 19:58:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Riccardo Paolo Bestetti" <pbl@bestov.io>
Cc:     <davem@davemloft.net>, <cmllamas@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <kernel-team@android.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: Re: NEEDS FIXING - Was: Re: [PATCH v2] ipv4: ping: fix bind address
 validity check
Message-ID: <20220617195816.53a2f2cf@kernel.org>
In-Reply-To: <CKSU5Q2M1IE3.39AS0HDHTZPN@enhorning>
References: <20220617085435.193319-1-pbl@bestov.io>
        <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
        <CKSU5Q2M1IE3.39AS0HDHTZPN@enhorning>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jun 2022 02:32:55 +0200 Riccardo Paolo Bestetti wrote:
> I receompiled the kernel from the net tree to do some more manual testing
> on the patch and I have two things to disclose. Sorry for the caps in
> the subject.
> 
> TL;DR: I noticed that one of the regressions tests is (correctly)
> failing, but for the wrong reasons; and the patch I sent contains a
> mistake, and unfortunately it has already been applied to the tree as
> commit b4a028c4d0.
> 
> Long version below.
> 
> 1) If you run regression tests with -v, the (correct -- see below) ICMP
> tests for broadcast and multicast binding do not fail with
> EADDRNOTAVAIL, but with ACCES, but only when run through fcnal-test.sh.
> This is also true for one of the additional (commented out) tests you
> can find in my patch following this email. I'm not sure why this
> happens; however I'm reasonably convinced it is a quirk or a consequence
> of the testing methodology/setup. Can anyone offer any insights?
> 
> 2) My patch is faulty. I had a complete and tested patch, including code
> fixing the regression. Instead of sending it, however, I decided to
> adapt it to preserve Carlos Llamas' version of ping.c, since they posted
> their patch first. In doing so I used a work branch which contained a
> faulty version (wrong flags) of the regression tests. The resulting
> faulty patch is, unfortunately, currently in the tree.
> 
> At this point, due to the unfortunate combination of (1) and (2), it
> might be worth reverting the patch altogether and just applying the v1
> (i.e. without the regression tests) to the tree and to the relevant LTS
> versions.

IIUC only the test is faulty / unreliable, correct?

We have until Thursday before this patch hits Linus's tree so should 
be plenty of time to figure the problem out and apply an incremental
fix. I see you posted an RFC already, thanks!

> After that, a more proper discussion can be had about (1), and the
> regression tests can be fixed. I'm sending a demonstrative patch for
> that as a response to this message.

