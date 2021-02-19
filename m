Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030F931FEE4
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 19:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhBSSkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 13:40:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhBSSka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 13:40:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27AF964E4B;
        Fri, 19 Feb 2021 18:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613759989;
        bh=S4xflVDdqs14NUYJblRv311L9/zeoAUjGFAeSE+5qz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sRvq4du1RfoBvJgImESRmT4onzhEzDVKmXZxbrYi1+EooL7DdVMeQH9I0Hbga8Gw5
         6gKLyH5lfnHd8PGM/VgG1uiOKANfBQuplHWDL5kpERgm20Zm/Roq/VZn0I9XcxDW9T
         qT/SvTfhnTCgAvHcR71mOQ1gpm+AehndfYmpi9foXl4QJTcaK1CNl6N/By+9bTctx1
         nNo09Zmfq1h1jlrWFIenrHrRBZJEalXvGjStHrtfq6iLffj0oOcswRNlIMHzV37+hA
         rxSiFp2Wd+eDWfFVKb9dc3KE9aZ634ruMBpXWOnhWuF1mX8MtBBpndWC0Ter/ghZWc
         pzFNiVVfLSXBw==
Date:   Fri, 19 Feb 2021 10:39:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB
 frames
Message-ID: <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
References: <20210216201813.60394-1-xie.he.0141@gmail.com>
        <YC4sB9OCl5mm3JAw@unreal>
        <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
        <YC5DVTHHd6OOs459@unreal>
        <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
        <YC7GHgYfGmL2wVRR@unreal>
        <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
        <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 12:23:28 -0800 Xie He wrote:
> On Thu, Feb 18, 2021 at 12:06 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > On Thu, Feb 18, 2021 at 11:55 AM Leon Romanovsky <leon@kernel.org> wrote:  
> > >
> > > This is how we write code, we use defines instead of constant numbers,
> > > comments to describe tricky parts and assign already preprocessed result.
> > >
> > > There is nothing I can do If you don't like or don't want to use Linux kernel
> > > style.  
> >
> > So what is your suggestion exactly? Use defines or write comments?
> >
> > As I understand, you want to replace the "3 - 1" with "2", and then
> > write comments to explain that this "2" is the result of "3 - 1".
> >
> > Why do you want to do this? You are doing useless things and you force
> > readers of this code to think about useless things.
> >
> > You said this was "Linux kernel style"? Why? Which sentence of the
> > Linux kernel style guide suggests your way is better than my way?  
> 
> Nevermind, if you *really* want me to replace this "3 - 1" with "2"
> and explain in the comment that the "2" is a result of "3 - 1". I'll
> do this. I admit this is a style issue. So it is hard to argue and
> reach an agreement. Just reply with a request and I'll make the
> change. However I'm not able to agree with you in my heart.

Not entirely sure what the argument is about but adding constants would
certainly help.

More fundamentally IDK if we can make such a fundamental change here.
When users upgrade from older kernel are all their scripts going to
work the same? Won't they have to bring the new netdev up?
