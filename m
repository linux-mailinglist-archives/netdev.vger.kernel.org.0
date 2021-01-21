Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BA62FDEDE
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388555AbhAUA6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 19:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733140AbhAUApu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 19:45:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D73D235E4;
        Thu, 21 Jan 2021 00:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611189909;
        bh=+SfUVv11yOSTuIe6NDeK+522cCVG1zqxwKOEBkQ/esA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i/k7GJDr1zfIPn+C4A2JV88amzrv7zC5Bah5Q57o5oJLCdkxTuTgujc0UrNyyH2sh
         8P5hNp8AU1bA+iBGtHSeep16gOtGNIngLRBjnGv1cR9zRdvM9/wQLqIPRiJb/OZslK
         t5a3LsbnW8Ic5zgQS3ZaR1ChKZdJla0WmTQK95ILLqvOnu8Rki4fKA+cg4WsazYPPi
         51T4zciI5OGv1J7C+sLt91TS2h7vYmA06ROBiCW61oiT6wU89EottdLMeMjUlfe41S
         1QmZDNqH+8aHizr2dvOe/hAgIgHmIksBc4k4EAlPuRAIdepFqnnbtVDwP0i0j0ss5w
         Wg70xYhBt1LRA==
Date:   Wed, 20 Jan 2021 16:45:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] mlxsw: Add support for RED qevent "mark"
Message-ID: <20210120164508.6009dbbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120091437.GA2591869@shredder.lan>
References: <20210117080223.2107288-1-idosch@idosch.org>
        <20210119142255.1caca7fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210120091437.GA2591869@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 11:14:37 +0200 Ido Schimmel wrote:
> On Tue, Jan 19, 2021 at 02:22:55PM -0800, Jakub Kicinski wrote:
> > On Sun, 17 Jan 2021 10:02:18 +0200 Ido Schimmel wrote:  
> > > From: Ido Schimmel <idosch@nvidia.com>
> > > 
> > > The RED qdisc currently supports two qevents: "early_drop" and "mark". The
> > > filters added to the block bound to the "early_drop" qevent are executed on
> > > packets for which the RED algorithm decides that they should be
> > > early-dropped. The "mark" filters are similarly executed on ECT packets
> > > that are marked as ECN-CE (Congestion Encountered).
> > > 
> > > A previous patchset has offloaded "early_drop" filters on Spectrum-2 and
> > > later, provided that the classifier used is "matchall", that the action
> > > used is either "trap" or "mirred", and a handful or further limitations.  
> > 
> > For early_drop trap or mirred makes obvious sense, no explanation
> > needed.
> > 
> > But for marked as a user I'd like to see a _copy_ of the packet, 
> > while the original continues on its marry way to the destination.
> > I'd venture to say that e.g. for a DCTCP deployment mark+trap is
> > unusable, at least for tracing, because it distorts the operation 
> > by effectively dropping instead of marking.
> > 
> > Am I reading this right?  
> 
> You get a copy of the packet as otherwise it will create a lot of
> problems (like you wrote).

Hm, so am I missing some background on semantics on TC_ACT_TRAP?
Or perhaps you use a different action code?

AFAICT the code in the kernel is:

struct sk_buff *tcf_qevent_handle(...

	case TC_ACT_STOLEN:
	case TC_ACT_QUEUED:
	case TC_ACT_TRAP:
		__qdisc_drop(skb, to_free);
		*ret = __NET_XMIT_STOLEN;
		return NULL;

Having TRAP mean DROP makes sense for filters, but in case of qevents
shouldn't they be a no-op?

Looking at sch_red looks like TRAP being a no-op would actually give us
the expected behavior.

> > If that is the case and you really want to keep the mark+trap
> > functionality - I feel like at least better documentation is needed.
> > The current two liner should also be rewritten, quoting from patch 1:
> >   
> > > * - ``ecn_mark``
> > >   - ``drop``
> > >   - Traps ECN-capable packets that were marked with CE (Congestion
> > >     Encountered) code point by RED algorithm instead of being dropped  
> > 
> > That needs to say that the trap is for datagrams trapped by a qevent.
> > Otherwise "Traps ... instead of being dropped" is too much of a
> > thought-shortcut, marked packets are not dropped.
> > 
> > (I'd also think that trap is better documented next to early_drop,
> > let's look at it from the reader's perspective)  
> 
> How about:
> 
> "Traps a copy of ECN-capable packets that were marked with CE

I think "Traps copies" or "Traps the copy of .. packet"?
I'm not a native speaker but there seems to be a grammatical mix here.

> (Congestion Encountered) code point by RED algorithm instead of being
> dropped. The trap is enabled by attaching a filter with action 'trap' to

... instead of those copies being dropped.

> the 'mark' qevent of the RED qdisc."
>
> In addition, this output:
> 
> $ devlink trap show pci/0000:06:00.0 trap ecn_mark 
> pci/0000:06:00.0:
>   name ecn_mark type drop generic true action trap group buffer_drops
> 
> Can be converted to:
> 
> $ devlink trap show pci/0000:06:00.0 trap ecn_mark 
> pci/0000:06:00.0:
>   name ecn_mark type drop generic true action mirror group buffer_drops
> 
> "mirror: The packet is forwarded by the underlying device and a copy is sent to
> the CPU."
> 
> In this case the action is static and you cannot change it.

Oh yes, that's nice, I thought mirror in traps means mirror to another
port. Are there already traps which implement the mirroring / trapping
a clone? Quick grep yields nothing of substance.
