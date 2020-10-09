Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A115F289BFC
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387936AbgJIXAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731374AbgJIXAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 19:00:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCF25222EB;
        Fri,  9 Oct 2020 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602284412;
        bh=dg9EFmdLFS2T11zuvozW2Od87Nd0LXboqtIi77a1IEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VRNYv9ALA1+6hefwFA5JR6siBIAsqBcvj26AxgbGBPj/lNEelI8Pq4UQ8B9RXRLWd
         +EDs3lKY2BRxs6s+jgZ+dj+/x2WJP2TwPrXYb3WUkywPm7czTrtFGYOQqyK7etYGX9
         LdjZ4QC0EhKHR0//xYIMTNpLqF4PC9TftfYvAKTw=
Date:   Fri, 9 Oct 2020 16:00:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        eyal.birger@gmail.com
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Message-ID: <20201009160010.4b299ac3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
        <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 09 Oct 2020 13:49:14 -0700 John Fastabend wrote:
> Jakub Kicinski wrote:
> > On Thu, 08 Oct 2020 16:08:57 +0200 Jesper Dangaard Brouer wrote:  
> > > V3: Drop enforcement of MTU in net-core, leave it to drivers  
> > 
> > Sorry for being late to the discussion.
> > 
> > I absolutely disagree. We had cases in the past where HW would lock up
> > if it was sent a frame with bad geometry.
> > 
> > We will not be sprinkling validation checks across the drivers because
> > some reconfiguration path may occasionally yield a bad packet, or it's
> > hard to do something right with BPF.  
> 
> This is a driver bug then. As it stands today drivers may get hit with
> skb with MTU greater than set MTU as best I can tell.

You're talking about taking it from "maybe this can happen, but will
still be at most jumbo" to "it's going to be very easy to trigger and
length may be > MAX_U16".

> Generally I expect drivers use MTU to configure RX buffers not sure
> how it is going to be used on TX side? Any examples? I just poked
> around through the driver source to see and seems to confirm its
> primarily for RX side configuration with some drivers throwing the
> event down to the firmware for something that I can't see in the code?

Right, but that could just be because nobody expects to get over sized
frames from the stack.

We actively encourage drivers to remove paranoid checks. It's really
not going to be a great experience for driver authors where they need
to consult a list of things they should and shouldn't check.

If we want to do this, the driver interface must most definitely say 
MRU and not MTU.

> I'm not suggestiong sprinkling validation checks across the drivers.
> I'm suggesting if the drivers hang we fix them.

We both know the level of testing drivers get, it's unlikely this will
be validated. It's packet of death waiting to happen. 

And all this for what? Saving 2 cycles on a branch that will almost
never be taken?
