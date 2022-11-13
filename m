Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FC6627293
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 21:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbiKMUiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 15:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiKMUiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 15:38:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B745D12D1E
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 12:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FcRzngEnzw7JUGGCp73Dv0bbHkf0m6i9rM7vJtVsyqM=; b=0t4fHXe8PGoWNB/uvHDujDLc8g
        6c+EFeOuNoI7nfuI+t6nodSsQp39C9e0v3BvWDYC6MOu4EaQCvSRwsviRIArWK3fUTTMdTUGRl6VQ
        2Oj8Py4iOTRodZB8l2CXM/js3cbotrJOgriA0v5SuzrHum/8WW3Mromxz5Si4h9XmcVQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouJjp-002GR8-Mw; Sun, 13 Nov 2022 21:37:57 +0100
Date:   Sun, 13 Nov 2022 21:37:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: Upstream Homa?
Message-ID: <Y3FVpQAWI7kTzfhf@lunn.ch>
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local>
 <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
 <Y26huGkf50zPPCmf@lunn.ch>
 <Y29RBxW69CtiML6I@nanopsycho>
 <CAGXJAmzdr1dBZb4=TYscXtN66weRvsO6p74K-K3aa_7UJ=sEuQ@mail.gmail.com>
 <Y3ElDxZi6Hswga2D@lunn.ch>
 <CAGXJAmwfyU0rdrp0g6UU8ctLHUrq_sAKTSk2R4LWoOgMTfPEAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXJAmwfyU0rdrp0g6UU8ctLHUrq_sAKTSk2R4LWoOgMTfPEAA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 12:10:22PM -0800, John Ousterhout wrote:
> On Sun, Nov 13, 2022 at 9:10 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Homa implements RPCs rather than streams like TCP or messages like
> > > UDP. An RPC consists of a request message sent from client to server,
> > > followed by a response message from server back to client. This requires
> > > additional information in the API beyond what is provided in the arguments to
> > > sendto and recvfrom. For example, when sending a request message, the
> > > kernel returns an RPC identifier back to the application; when waiting for
> > > a response, the application can specify that it wants to receive the reply for
> > > a specific RPC identifier (or, it can specify that it will accept any
> > > reply, or any
> > > request, or both).
> >
> > This sounds like the ancillary data you can pass to sendmsg(). I've
> > not checked the code, it might be the current plumbing is only into to
> > the kernel, but i don't see why you cannot extend it to also allow
> > data to be passed back to user space. If this is new functionality,
> > maybe add a new flags argument to control it.
> >
> > recvmsg() also has ancillary data.
> 
> Whoah! I'd never noticed the msg_control and msg_controllen fields before.
> These may be sufficient to do everything Homa needs. Thanks for pointing
> this out.

Is zero copy also required? https://lwn.net/Articles/726917/ talks
about this. But rather than doing the transmit complete notification
via MSG_ERRORQUEUE, maybe you could make it part of the ancillary data
for a later message? That could save you some system calls? Or is the
latency low enough that the RPC reply acts an implicitly indication
the transmit buffer can be recycled?

If your aim is to offload Homa to the NIC, it seems like zero copy is
something you want, so even if you are not implementing it now, you
probably should consider what the uAPI looks like.

	 Andrew
