Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF3169ADF2
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBQOXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBQOXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:23:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335A3B448;
        Fri, 17 Feb 2023 06:22:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D615DB82C19;
        Fri, 17 Feb 2023 14:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32044C433D2;
        Fri, 17 Feb 2023 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676643759;
        bh=4VZAvBw9PiOMOV6bEtiTKMK52O0KqK74N8Q6Z8aB3xc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EWfA3jQgWAkP+snDUAKmmU7MG7sFfFdj48zYpbUgn5EFgRGJPvNM125Wwt3m7XSCD
         56W4uDO4SiEwBLDOx3urHGe/RjCdxAKvGzAwWg6b6yShyczvOrfkwoWzIOsiEgHrCd
         GhIqZ7CPGExcfnclpSHHHqvUSQsWeKeCAXhBvins=
Date:   Fri, 17 Feb 2023 15:22:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     netdev@vger.kernel.org, regressions@lists.linux.dev,
        stable@vger.kernel.org, w@1wt.eu, winter@winter.cafe
Subject: Re: [REGRESSION] 5.15.88 and onwards no longer return EADDRINUSE
 from bind
Message-ID: <Y++NrSVLY9dLmFPI@kroah.com>
References: <Y+p4AJHkP8JUf4KB@kroah.com>
 <20230213205835.56151-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213205835.56151-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 12:58:35PM -0800, Kuniyuki Iwashima wrote:
> From:   Greg KH <gregkh@linuxfoundation.org>
> Date:   Mon, 13 Feb 2023 18:48:48 +0100
> > On Mon, Feb 13, 2023 at 08:44:55AM -0800, Kuniyuki Iwashima wrote:
> > > From:   Willy Tarreau <w@1wt.eu>
> > > Date:   Mon, 13 Feb 2023 08:52:34 +0100
> > > > Hi Greg,
> > > > 
> > > > On Mon, Feb 13, 2023 at 08:25:34AM +0100, Greg KH wrote:
> > > > > On Mon, Feb 13, 2023 at 05:27:03AM +0100, Willy Tarreau wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > [CCed netdev]
> > > > > > 
> > > > > > On Sun, Feb 12, 2023 at 10:38:40PM -0500, Winter wrote:
> > > > > > > Hi all,
> > > > > > > 
> > > > > > > I'm facing the same issue as
> > > > > > > https://lore.kernel.org/stable/CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com/,
> > > > > > > but on 5.15. I've bisected it across releases to 5.15.88, and can reproduce
> > > > > > > on 5.15.93.
> > > > > > > 
> > > > > > > However, I cannot seem to find the identified problematic commit in the 5.15
> > > > > > > branch, so I'm unsure if this is a different issue or not.
> > > > > > > 
> > > > > > > There's a few ways to reproduce this issue, but the one I've been using is
> > > > > > > running libuv's (https://github.com/libuv/libuv) tests, specifically tests
> > > > > > > 271 and 277.
> > > > > > 
> > > > > > >From the linked patch:
> > > > > > 
> > > > > >   https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/
> > > > > 
> > > > > But that commit only ended up in 6.0.y, not 5.15, so how is this an
> > > > > issue in 5.15.y?
> > > > 
> > > > Hmmm I plead -ENOCOFFEE on my side, I hadn't notice the "can't find the
> > > > problematic commit", you're right indeed.
> > > > 
> > > > However if the issue happened in 5.15.88, the only part touching the
> > > > network listening area is this one which may introduce an EINVAL on
> > > > one listening path, but that seems unrelated to me given that it's
> > > > only for ULP that libuv doesn't seem to be using:
> > > > 
> > > >   dadd0dcaa67d ("net/ulp: prevent ULP without clone op from entering the LISTEN status")
> > > 
> > > This commit accidentally backports a part of 7a7160edf1bf ("net: Return
> > > errno in sk->sk_prot->get_port().") and removed err = -EADDRINUSE in
> > > inet_csk_listen_start().  Then, listen() will return 0 even if ->get_port()
> > > actually fails and returns 1.
> > > 
> > > I can send a small revert or a whole backport, but which is preferable ?
> > > The original patch is not for stable, but it will make future backports
> > > easy.
> > 
> > A whole revert is probably best, if it's not needed.  But if it is, a
> > fix up would be fine to get as well.
> 
> dadd0dcaa67d is needed to fix potential double-free, so could you queue
> this fixup for 5.15. ?
> 
> ---8<---
> >From ad319ace8b5c1dd5105b7263b7ccfd0ba0926551 Mon Sep 17 00:00:00 2001
> From: Kuniyuki Iwashima <kuniyu@amazon.com>
> Date: Mon, 13 Feb 2023 20:45:48 +0000
> Subject: [PATCH] tcp: Fix listen() regression in 5.15.88.
> 
> When we backport dadd0dcaa67d ("net/ulp: prevent ULP without clone op from
> entering the LISTEN status"), we have accidentally backported a part of
> 7a7160edf1bf ("net: Return errno in sk->sk_prot->get_port().") and removed
> err = -EADDRINUSE in inet_csk_listen_start().
> 
> Thus, listen() no longer returns -EADDRINUSE even if ->get_port() failed
> as reported in [0].
> 
> We set -EADDRINUSE to err just before ->get_port() to fix the regression.
> 
> [0]: https://lore.kernel.org/stable/EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe/
> 
> Reported-by: Winter <winter@winter.cafe>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/ipv4/inet_connection_sock.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a86140ff093c..29ec42c1f5d0 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1070,6 +1070,7 @@ int inet_csk_listen_start(struct sock *sk, int backlog)
>  	 * It is OK, because this socket enters to hash table only
>  	 * after validation is complete.
>  	 */
> +	err = -EADDRINUSE;
>  	inet_sk_state_store(sk, TCP_LISTEN);
>  	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
>  		inet->inet_sport = htons(inet->inet_num);
> -- 
> 2.38.1
> ---8<---

Thanks, now queued up.

greg k-h
