Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52932D1A53
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgLGULL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgLGULL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:11:11 -0500
Date:   Mon, 7 Dec 2020 12:10:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607371830;
        bh=Nv+nH87OsGzg6a3Q4Ms19OI6MgoxNwsX5/xJwoNrx7Q=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LZW20kQME7p2pnAAq/VImy4ljRIweW1dZrDtrEBbBBA0NC4VimrGXbaROsIE3ujUm
         0zo+lDxuEC8dbig0bVCTwJLU9ClcIyDFDOltOCz72NeexnEBEPwY9Y8Ph0LnCB+Ocn
         AtFEZGjQnqV9MkokWE5P0bxhDRbwE//W3DU3Tk4lCb0ZgQ8PsSVh9kFfrN7a2gfR6r
         L2RkMXbPbY41a3jgD17yVz+mIfCkMSGUroHMjegayiqRDOGqaydSd4nbiO5/h9Dz0T
         vwkqokjlq+iRM1tbygHFctV0n9V2ld7ocY/EKqSHBuK1h2jGA3SCuMDudK3GB7O2hc
         DCQKb0MCOdPtQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: wireless-drivers-next-2020-12-03
Message-ID: <20201207121029.77d48f2c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CA+ASDXNT+uKLLhTV0Nr-wxGkM16_OkedUyoEwx5FgV3ML9SMsQ@mail.gmail.com>
References: <20201203185732.9CFA5C433ED@smtp.codeaurora.org>
        <20201204111715.04d5b198@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <87tusxgar5.fsf@codeaurora.org>
        <CA+ASDXNT+uKLLhTV0Nr-wxGkM16_OkedUyoEwx5FgV3ML9SMsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 11:35:53 -0800 Brian Norris wrote:
> On Mon, Dec 7, 2020 at 2:42 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:  
> > > On Thu,  3 Dec 2020 18:57:32 +0000 (UTC) Kalle Valo wrote:
> > > There's also a patch which looks like it renames a module parameter.
> > > Module parameters are considered uAPI.  
> >
> > Ah, I have been actually wondering that if they are part of user space
> > API or not, good to know that they are. I'll keep an eye of this in the
> > future so that we are not breaking the uAPI with module parameter
> > changes.  
> 
> Is there some reference for this rule (e.g., dictate from on high; or
> some explanation of reasons)? Or limitations on it? Because as-is,
> this sounds like one could never drop a module parameter, or remove
> obsolete features.

TBH its one of those "widely accepted truth" in networking which was
probably discussed before I started compiling kernels so I don't know
the full background. But it seems pretty self-evident even without
knowing the casus that made us institute the rule.

Module parameters are certainly userspace ABI, since user space can
control them either when loading the module or via sysfs.

> It also suggests that debug-related knobs (which
> can benefit from some amount of flexibility over time) should go
> exclusively in debugfs (where ABI guarantees are explicitly not made),
> even at the expense of usability (dropping a line into
> /etc/modprobe.d/ is hard to beat).

Indeed, debugfs seems more appropriate.

> That's not to say I totally disagree with the original claim, but I'm
> just interested in knowing precisely what it means.
> 
> And to put a precise spin on this: what would this rule say about the following?
> 
> http://git.kernel.org/linus/f06021a18fcf8d8a1e79c5e0a8ec4eb2b038e153
> iwlwifi: remove lar_disable module parameter
> 
> Should that parameter have never been introduced in the first place,
> never be removed, or something else? I think I've seen this sort of
> pattern before, where features get phased in over time, with module
> parameters as either escape hatches or as opt-in mechanisms.
> Eventually, they stabilize, and there's no need (or sometimes, it's
> actively harmful) to keep the knob around.
> 
> Or the one that might (?) be in question here:
> fc3ac64a3a28 rtw88: decide lps deep mode from firmware feature.
> 
> The original module parameter was useful for enabling new power-saving
> features, because the driver didn't yet know which chip(s)/firmware(s)
> were stable with which power features. Now, the driver has learned how
> to figure out the optimal power settings, so it's dropping the old
> param and adding an "escape hatch", in case there are problems.
> 
> I'd say this one is a bit more subtle than the lar_disable example,
> but I'm still not sure that really qualifies as a "user-visible"
> change.

If I'm reading this right the pattern seems to be that module
parameters are used as chicken bits. It's an interesting problem, 
I'm not sure this use case was discussed. My concern would be that 
there is no guarantee users will in fact report the new feature 
fails for them, and therefore grow to depend on the chicken bits.

Since updating software is so much easier than re-etching silicon
I'd personally not use chicken bits in software, especially with
growing adoption of staggered update roll outs. Otherwise I'd think
debugfs is indeed a better place for them.
