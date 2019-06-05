Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA9A35530
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfFECVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:21:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52958 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfFECVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 22:21:33 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYLYL-0004MT-Ux; Wed, 05 Jun 2019 10:21:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYLYD-0001by-GF; Wed, 05 Jun 2019 10:21:17 +0800
Date:   Wed, 5 Jun 2019 10:21:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: rcu_read_lock lost its compiler barrier
Message-ID: <20190605022117.kw6tldcwhdkyqd6u@gondor.apana.org.au>
References: <20150921193045.GA13674@lerouge>
 <20150921204327.GH4029@linux.vnet.ibm.com>
 <20190602055607.bk5vgmwjvvt4wejd@gondor.apana.org.au>
 <20190603000617.GD28207@linux.ibm.com>
 <20190603030324.kl3bckqmebzis2vw@gondor.apana.org.au>
 <CAHk-=wj2t+GK+DGQ7Xy6U7zMf72e7Jkxn4_-kGyfH3WFEoH+YQ@mail.gmail.com>
 <CAHk-=wgZcrb_vQi5rwpv+=wwG+68SRDY16HcqcMtgPFL_kdfyQ@mail.gmail.com>
 <20190603195304.GK28207@linux.ibm.com>
 <CAHk-=whXb-QGZqOZ7S9YdjvQf7FNymzceinzJegvRALqXm3=FQ@mail.gmail.com>
 <20190604211449.GU28207@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604211449.GU28207@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 04, 2019 at 02:14:49PM -0700, Paul E. McKenney wrote:
>
> Yeah, I know, even with the "volatile" keyword, it is not entirely clear
> how much reordering the compiler is allowed to do.  I was relying on
> https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html, which says:

The volatile keyword doesn't give any guarantees of this kind.
The key to ensuring ordering between unrelated variable/register
reads/writes is the memory clobber:

	6.47.2.6 Clobbers and Scratch Registers

	...

	"memory" The "memory" clobber tells the compiler that the assembly
	code performs memory reads or writes to items other than those
	listed in the input and output operands (for example, accessing
	the memory pointed to by one of the input parameters). To ensure
	memory contains correct values, GCC may need to flush specific
	register values to memory before executing the asm. Further,
	the compiler does not assume that any values read from memory
	before an asm remain unchanged after that asm; it reloads them as
	needed. Using the "memory" clobber effectively forms a read/write
	memory barrier for the compiler.

	Note that this clobber does not prevent the processor from
	doing speculative reads past the asm statement. To prevent that,
	you need processor-specific fence instructions.

IOW you need a barrier().

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
