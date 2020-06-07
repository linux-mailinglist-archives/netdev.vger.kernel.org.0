Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D02B1F0AC3
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 12:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgFGKA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 06:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgFGKA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 06:00:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1B7C08C5C2
        for <netdev@vger.kernel.org>; Sun,  7 Jun 2020 03:00:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jhs6j-0004Ie-5u; Sun, 07 Jun 2020 12:00:49 +0200
Date:   Sun, 7 Jun 2020 12:00:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Christoph Paasch <christoph.paasch@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Wayne Badger <badger@yahoo-inc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leif Hedstrom <lhedstrom@apple.com>
Subject: Re: TCP_DEFER_ACCEPT wakes up without data
Message-ID: <20200607100049.GM28263@breakpoint.cc>
References: <538FB666.9050303@yahoo-inc.com>
 <alpine.LFD.2.11.1406071441260.2287@ja.home.ssi.bg>
 <5397A98F.2030206@yahoo-inc.com>
 <58a4abb51fe9411fbc7b1a58a2a6f5da@UCL-MBX03.OASIS.UCLOUVAIN.BE>
 <CALMXkpYBMN5VR9v+xL0fOC6srABYd38x5tGJG5od+VNMS+BSAw@mail.gmail.com>
 <878029e5-b2b2-544c-f4b5-ff4c76fd6bd3@gmail.com>
 <CALMXkpbNeRCrOnQFWAWR8BzX4yRgDveDMPZgS6NupjXrHFX1pg@mail.gmail.com>
 <b520b541-9013-3095-2e3b-37ec835e4ff8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b520b541-9013-3095-2e3b-37ec835e4ff8@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Sure! TCP_DEFER_ACCEPT delays the creation of the socket until data
> > has been sent by the client *or* the specified time has expired upon
> > which a last SYN/ACK is sent and if the client replies with an ACK the
> > socket will be created and presented to the accept()-call. In the
> > latter case it means that the app gets a socket that does not have any
> > data to be read - which goes against the intention of TCP_DEFER_ACCEPT
> > (man-page says: "Allow a listener to be awakened only when data
> > arrives on the socket.").
> > 
> > In the original thread the proposal was to kill the connection with a
> > TCP-RST when the specified timeout expired (after the final SYN/ACK).
> > 
> > Thus, my question in my first email whether there is a specific reason
> > to not do this.
> > 
> > API-breakage does not seem to me to be a concern here. Apps that are
> > setting DEFER_ACCEPT probably would not expect to get a socket that
> > does not have data to read.
> 
> Thanks for the summary ;)
> 
> I disagree.
> 
> A server might have two modes :
> 
> 1) A fast path, expecting data from user in a small amount of time, from peers not too far away.
> 
> 2) A slow path, for clients far away. Server can implement strategies to control number of sockets
> that have been accepted() but not yet active (no data yet received).

So we can't change DEFER_ACCEPT behaviour.
Any objections to adding TCP_DEFER_ACCEPT2 with the behaviour outlined
by Christoph?
