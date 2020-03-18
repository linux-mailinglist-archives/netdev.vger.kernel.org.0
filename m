Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7B418A524
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCRU7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:59:23 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33354 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727228AbgCRU7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 16:59:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jEfma-0007pN-9C; Wed, 18 Mar 2020 21:59:20 +0100
Date:   Wed, 18 Mar 2020 21:59:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC mptcp-next] tcp: mptcp: use mptcp receive buffer space to
 select rcv window
Message-ID: <20200318205920.GK979@breakpoint.cc>
References: <20200318141917.2612-1-fw@strlen.de>
 <48933c49-0889-5dba-29e2-62640e47797a@gmail.com>
 <20200318180526.GJ979@breakpoint.cc>
 <95e08be8-9902-f998-6558-e7e574d783b0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95e08be8-9902-f998-6558-e7e574d783b0@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>> +/* If ssk has an mptcp parent socket, use the mptcp rcvbuf occupancy,
> >>> + * not the ssk one.
> >>> + *
> >>> + * In mptcp, rwin is about the mptcp-level connection data.
> >>> + *
> >>> + * Data that is still on the ssk rx queue can thus be ignored,
> >>> + * as far as mptcp peer is concerened that data is still inflight.
> >>> + */
> >>> +void mptcp_space(const struct sock *ssk, int *space, int *full_space)
> >>> +{
> >>> +	const struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
> >>> +	const struct sock *sk = READ_ONCE(subflow->conn);
> >>
> >> What are the rules protecting subflow->conn lifetime ?
> >>
> >> Why dereferencing sk after this line is safe ?
> > 
> > Subflow sockets hold a reference on the master/parent mptcp-socket.
> > 
> 
> Presence of READ_ONCE() tells something might happen on
> this pointer after you read it.

Right, sorry about this. The READ_ONCE() isn't needed anymore after
recent improvement from Paolo.

> Can this pointer be set while this thread is owning the socket lock ?

Only by the one holding the sk lock, so no race.

> If not, then you do not need READ_ONCE(), this is confusing.

Yes.

> If yes, then it means that whatever changes the pointer might also release the reference
> on the old object.

The reference is released only after aquiring the socket lock.
