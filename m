Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D0255AAFC
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 16:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbiFYO06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 10:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiFYO05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 10:26:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F0DE0E2;
        Sat, 25 Jun 2022 07:26:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97D1DB80B6F;
        Sat, 25 Jun 2022 14:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94445C3411C;
        Sat, 25 Jun 2022 14:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656167214;
        bh=56xO8nsdt8HDZ8eKJcZsZturnOZobYXhKpYstAWes3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pG8GyiDGNAmyfE5bJp19nE/3gAbZiimS5JkXS4qiRMz6YA2p5dHVU1ea3dRfq5T3N
         9hI3kysESnWOCH0VvOMouKG6J1L2azUZVnNXxwE5cdoehY8QvQQp3WbhvKA1kQW4Mi
         Ek9zPtDEIRRdWk5l/j/L2hIPvxgnSwkmD89osI5U=
Date:   Sat, 25 Jun 2022 16:26:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, stable@vger.kernel.org,
        Riccardo Paolo Bestetti <pbl@bestov.io>,
        Carlos Llamas <cmllamas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel-team@android.com,
        Kernel hackers <linux-kernel@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH v2] ipv4: ping: fix bind address validity check
Message-ID: <YrcbKzTuUssl+x0G@kroah.com>
References: <20220617085435.193319-1-pbl@bestov.io>
 <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
 <CANP3RGcMqXH2+g1=40zwpzbpDORjDpyo4cVYZWS_tfVR8A_6CQ@mail.gmail.com>
 <YrBH1MXZq2/3Z94T@kroah.com>
 <CANP3RGc8tjqk+c=+rAHNON8u=21Uu+kWveuMWZxGCNMjvqRHYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGc8tjqk+c=+rAHNON8u=21Uu+kWveuMWZxGCNMjvqRHYg@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 11:18:21AM -0700, Maciej Żenczykowski wrote:
> On Mon, Jun 20, 2022 at 3:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Jun 17, 2022 at 04:45:52PM -0700, Maciej Żenczykowski wrote:
> > > On Fri, Jun 17, 2022 at 4:30 AM <patchwork-bot+netdevbpf@kernel.org> wrote:
> > > >
> > > > Hello:
> > > >
> > > > This patch was applied to netdev/net.git (master)
> > > > by David S. Miller <davem@davemloft.net>:
> > > >
> > > > On Fri, 17 Jun 2022 10:54:35 +0200 you wrote:
> > > > > Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> > > > > introduced a helper function to fold duplicated validity checks of bind
> > > > > addresses into inet_addr_valid_or_nonlocal(). However, this caused an
> > > > > unintended regression in ping_check_bind_addr(), which previously would
> > > > > reject binding to multicast and broadcast addresses, but now these are
> > > > > both incorrectly allowed as reported in [1].
> > > > >
> > > > > [...]
> > > >
> > > > Here is the summary with links:
> > > >   - [v2] ipv4: ping: fix bind address validity check
> > > >     https://git.kernel.org/netdev/net/c/b4a028c4d031
> > > >
> > > > You are awesome, thank you!
> > > > --
> > > > Deet-doot-dot, I am a bot.
> > > > https://korg.docs.kernel.org/patchwork/pwbot.html
> > >
> > > I believe this [
> > > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=b4a028c4d031
> > > ] needs to end up in 5.17+ LTS (though I guess 5.17 is eol, so
> > > probably just 5.18)
> >
> > 5.17 is end-of-life, sorry.
> >
> > And this needs to hit Linus's tree first.
> 
> It now has:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/net/ipv4/ping.c
> 
> ipv4: ping: fix bind address validity check
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/net/ipv4/ping.c?id=b4a028c4d031c27704ad73b1195ca69a1206941e

Great, now queued up, thanks.

greg k-h
