Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA81620A8AE
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407665AbgFYXQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728599AbgFYXQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:16:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25B0C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:16:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6EA4015426946;
        Thu, 25 Jun 2020 16:16:37 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:16:36 -0700 (PDT)
Message-Id: <20200625.161636.1311963505288019596.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/4] napi_gro_receive caller return value cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624220606.1390542-1-Jason@zx2c4.com>
References: <20200624220606.1390542-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:16:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 24 Jun 2020 16:06:02 -0600

> In 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
> napi_gro_receive()"), the GRO_NORMAL case stopped calling
> netif_receive_skb_internal, checking its return value, and returning
> GRO_DROP in case it failed. Instead, it calls into
> netif_receive_skb_list_internal (after a bit of indirection), which
> doesn't return any error. Therefore, napi_gro_receive will never return
> GRO_DROP, making handling GRO_DROP dead code.
> 
> I emailed the author of 6570bc79c0df on netdev [1] to see if this change
> was intentional, but the dlink.ru email address has been disconnected,
> and looking a bit further myself, it seems somewhat infeasible to start
> propagating return values backwards from the internal machinations of
> netif_receive_skb_list_internal.
> 
> Taking a look at all the callers of napi_gro_receive, it appears that
> three are checking the return value for the purpose of comparing it to
> the now never-happening GRO_DROP, and one just casts it to (void), a
> likely historical leftover. Every other of the 120 callers does not
> bother checking the return value.
> 
> And it seems like these remaining 116 callers are doing the right thing:
> after calling napi_gro_receive, the packet is now in the hands of the
> upper layers of the newtworking, and the device driver itself has no
> business now making decisions based on what the upper layers choose to
> do. Incrementing stats counters on GRO_DROP seems like a mistake, made
> by these three drivers, but not by the remaining 117.
> 
> It would seem, therefore, that after rectifying these four callers of
> napi_gro_receive, that I should go ahead and just remove returning the
> value from napi_gro_receive all together. However, napi_gro_receive has
> a function event tracer, and being able to introspect into the
> networking stack to see how often napi_gro_receive is returning whatever
> interesting GRO status (aside from _DROP) remains an interesting
> data point worth keeping for debugging.
> 
> So, this series simply gets rid of the return value checking for the
> four useless places where that check never evaluates to anything
> meaningful.
> 
> [1] https://lore.kernel.org/netdev/20200624210606.GA1362687@zx2c4.com/

Seires applied, thank you.
