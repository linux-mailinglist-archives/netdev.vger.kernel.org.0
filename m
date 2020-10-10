Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CF828A233
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389238AbgJJWz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731822AbgJJTh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:37:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08229223BF;
        Sat, 10 Oct 2020 16:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602347534;
        bh=Jd04fxPJuQJZKqz4bs0WWvyPt+mS9UdG/D05ZrDqSWA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WVlM3/bD81SYY9L3YcIlGO+M9fWud/EARbrbdzuz1DsgU/eA63iFZ3z9sTjxlyDDo
         /B30bdPp2kbOYC37K7ZE9vW9T6McYv+ljJEFY8+cQSc2NfitzUmAUM1NcPXTZmRpY/
         zO+z+yGe6sGqUBlYALARDVxkUNcid+lf8MLxTQ94=
Date:   Sat, 10 Oct 2020 09:32:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        eyal.birger@gmail.com
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Message-ID: <20201010093212.374d1e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201010124402.606f2d37@carbon>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
        <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
        <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201010124402.606f2d37@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 12:44:02 +0200 Jesper Dangaard Brouer wrote:
> > > > We will not be sprinkling validation checks across the drivers because
> > > > some reconfiguration path may occasionally yield a bad packet, or it's
> > > > hard to do something right with BPF.      
> > > 
> > > This is a driver bug then. As it stands today drivers may get hit with
> > > skb with MTU greater than set MTU as best I can tell.    
> > 
> > You're talking about taking it from "maybe this can happen, but will
> > still be at most jumbo" to "it's going to be very easy to trigger and
> > length may be > MAX_U16".  
> 
> It is interesting that a misbehaving BPF program can easily trigger this.
> Next week, I will looking writing such a BPF-prog and then test it on
> the hardware I have avail in my testlab.

FWIW I took a quick swing at testing it with the HW I have and it did
exactly what hardware should do. The TX unit entered an error state 
and then the driver detected that and reset it a few seconds later.

Hardware is almost always designed to behave like that. If some NIC
actually cleanly drops over sized TX frames, I'd bet it's done in FW,
or some other software piece.

There was also a statement earlier in the thread that we can put a large
frame on the wire and "let the switch drop it". I don't believe
that's possible either (as I mentioned previously BPF could generate
frames above jumbo size). My phy knowledge is very rudimentary and
rusty but from what I heard Ethernet PHYs have a hard design limit on
the length of a frame they can put of a wire (or pull from it), because
of symbol encoding, electrical charges on the wire etc. reasons. There
needs to be a bunch of idle symbols every now and then. And obviously
if one actually manages to get a longer frame to the PHY it will fault,
see above.

> > > Generally I expect drivers use MTU to configure RX buffers not sure
> > > how it is going to be used on TX side? Any examples? I just poked
> > > around through the driver source to see and seems to confirm its
> > > primarily for RX side configuration with some drivers throwing the
> > > event down to the firmware for something that I can't see in the code?    
> > 
> > Right, but that could just be because nobody expects to get over sized
> > frames from the stack.
> > 
> > We actively encourage drivers to remove paranoid checks. It's really
> > not going to be a great experience for driver authors where they need
> > to consult a list of things they should and shouldn't check.
> > 
> > If we want to do this, the driver interface must most definitely say 
> > MRU and not MTU.  
> 
> What is MRU?

Max Receive Unit, Jesse and others have been talking about how we 
should separate the TX config from RX config for drivers. Right now
drivers configure RX filters based on the max transmission unit, 
which is weird, and nobody is sure whether that's actually desired.

> > > I'm not suggestiong sprinkling validation checks across the drivers.
> > > I'm suggesting if the drivers hang we fix them.    
> > 
> > We both know the level of testing drivers get, it's unlikely this will
> > be validated. It's packet of death waiting to happen. 
> > 
> > And all this for what? Saving 2 cycles on a branch that will almost
> > never be taken?  
> 
> I do think it is risky not to do this simple MTU check in net-core.  I
> also believe the overhead is very very low.  Hint, I'm basically just
> moving the MTU check from one place to another.  (And last patch in
> patchset is an optimization that inlines and save cycles when doing
> these kind of MTU checks).
