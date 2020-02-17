Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA519160FD1
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgBQKUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:20:20 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50508 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgBQKUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 05:20:19 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j3dVg-0005di-3a; Mon, 17 Feb 2020 18:20:16 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j3dVd-0003kW-1p; Mon, 17 Feb 2020 18:20:13 +0800
Date:   Mon, 17 Feb 2020 18:20:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     eric.dumazet@gmail.com, cai@lca.pw, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3] skbuff: fix a data race in skb_queue_len()
Message-ID: <20200217102012.si4t2x75mo52fnlh@gondor.apana.org.au>
References: <20200206163844.GA432041@zx2c4.com>
 <20200217032458.kwatitz3pvxeb25w@gondor.apana.org.au>
 <CAHmME9q+YYia0H3upW7ikwSii_XegNNSBkVxP-1mxaHyEVmBxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9q+YYia0H3upW7ikwSii_XegNNSBkVxP-1mxaHyEVmBxA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 08:39:45AM +0100, Jason A. Donenfeld wrote:
>
> Not necessarily a big fan of this either, but just for the record here
> in case it helps, while you might complain about instruction size
> blowing up a bit, cycle-wise these wind up being about the same
> anyway. On x86, one instruction != one cycle.

I don't care about that.  My problem is with the mindless patches
that started this thread.  Look at the patch:

commit 86b18aaa2b5b5bb48e609cd591b3d2d0fdbe0442
Author: Qian Cai <cai@lca.pw>
Date:   Tue Feb 4 13:40:29 2020 -0500

    skbuff: fix a data race in skb_queue_len()

It's utter garbage.  Why on earth did it change that one instance
of unix_recvq_full? In fact you can see how stupid it is because
right after the call that got changed we again call into
unix_recvq_full which surely would trigger the same warning.

So far the vast majority of the KCSAN patches that have caught
my attention have been of this mindless kind that does not add
any value to the kernel.  If anything they could be hiding real
bugs that would now be harder to find.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
