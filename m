Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A20F2D534
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 07:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfE2FsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 01:48:06 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50838 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfE2FsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 01:48:05 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hVrRT-0004Cn-7n; Wed, 29 May 2019 13:48:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hVrRP-00036h-Sh; Wed, 29 May 2019 13:47:59 +0800
Date:   Wed, 29 May 2019 13:47:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH] inet: frags: Remove unnecessary
 smp_store_release/READ_ONCE
Message-ID: <20190529054759.qrw7h73g62mnbica@gondor.apana.org.au>
References: <20190524160340.169521-12-edumazet@google.com>
 <20190528063403.ukfh37igryq4u2u6@gondor.apana.org.au>
 <CANn89i+NfFLHDthLC-=+vWV6fFSqddVqhnAWE_+mHRD9nQsNyw@mail.gmail.com>
 <20190529054026.fwcyhzt33dshma4h@gondor.apana.org.au>
 <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y39u9VL+C27PVpfVZbNP_U8yFG35yLy6_KaxK2+Z9Gyw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 07:43:51AM +0200, Dmitry Vyukov wrote:
>
> If fqdir->dead read/write are concurrent, then this still needs to be
> READ_ONCE/WRITE_ONCE. Ordering is orthogonal to atomicity.

No they do not.  READ_ONCE/WRITE_ONCE are basically a more fine-tuned
version of barrier().  In this case we already have an implicit
barrier() call due to the memory barrier semantics so this is simply
unnecessary.

It's the same reason you don't need READ_ONCE/WRITE_ONCE when you do:

CPU1				CPU2
----				----
spin_lock
shared_var = 1			spin_lock
spin_unlock			if (shared_var == 1)
					...
				spin_unlock

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
