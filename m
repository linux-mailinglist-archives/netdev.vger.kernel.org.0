Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F4D1608C1
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgBQDZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:25:07 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:48208 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbgBQDZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 22:25:07 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j3X1r-0003Fn-Gw; Mon, 17 Feb 2020 11:25:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j3X1m-0003P1-Vz; Mon, 17 Feb 2020 11:24:59 +0800
Date:   Mon, 17 Feb 2020 11:24:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     eric.dumazet@gmail.com, cai@lca.pw, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3] skbuff: fix a data race in skb_queue_len()
Message-ID: <20200217032458.kwatitz3pvxeb25w@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206163844.GA432041@zx2c4.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Eric,
> 
> On Tue, Feb 04, 2020 at 01:40:29PM -0500, Qian Cai wrote:
>> -     list->qlen--;
>> +     WRITE_ONCE(list->qlen, list->qlen - 1);
> 
> Sorry I'm a bit late to the party here, but this immediately jumped out.
> This generates worse code with a bigger race in some sense:
> 
> list->qlen-- is:
> 
>   0:   83 6f 10 01             subl   $0x1,0x10(%rdi)
> 
> whereas WRITE_ONCE(list->qlen, list->qlen - 1) is:
> 
>   0:   8b 47 10                mov    0x10(%rdi),%eax
>   3:   83 e8 01                sub    $0x1,%eax
>   6:   89 47 10                mov    %eax,0x10(%rdi)
> 
> Are you sure that's what we want?

Fixing these KCSAN warnings is actively making the kernel worse.

Why are we still doing this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
