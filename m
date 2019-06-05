Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA57358A3
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 10:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfFEIfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 04:35:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfFEIfh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 04:35:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1B239C05D419;
        Wed,  5 Jun 2019 08:35:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDDE85C224;
        Wed,  5 Jun 2019 08:35:28 +0000 (UTC)
Message-ID: <f54d5ea4ae3a704c88f1867cd5713c06ac7930c4.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] indirect call wrappers: add helpers for 3
 and 4 ways switch
From:   Paolo Abeni <pabeni@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Date:   Wed, 05 Jun 2019 10:35:28 +0200
In-Reply-To: <10e134ce6b8c0e2060cecf57527cc52a99d4d6a5.camel@mellanox.com>
References: <cover.1559304330.git.pabeni@redhat.com>
         <7dc56c32624fd102473fc66ffdda6ebfcdfe6ad0.1559304330.git.pabeni@redhat.com>
         <1133f7e92cffb7ade5249e6d6ac0dd430549bf14.camel@mellanox.com>
         <141f34bb8d1505783b4f939faac5223200deeb13.camel@redhat.com>
         <10e134ce6b8c0e2060cecf57527cc52a99d4d6a5.camel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 05 Jun 2019 08:35:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-03 at 22:27 +0000, Saeed Mahameed wrote:
> On Mon, 2019-06-03 at 11:51 +0200, Paolo Abeni wrote:
> > On Fri, 2019-05-31 at 18:30 +0000, Saeed Mahameed wrote:
> > > On Fri, 2019-05-31 at 14:53 +0200, Paolo Abeni wrote:
> > > > Experimental results[1] has shown that resorting to several
> > > > branches
> > > > and a direct-call is faster than indirect call via retpoline,
> > > > even
> > > > when the number of added branches go up 5.
> > > > 
> > > > This change adds two additional helpers, to cope with indirect
> > > > calls
> > > > with up to 4 available direct call option. We will use them
> > > > in the next patch.
> > > > 
> > > > [1] 
> > > > https://linuxplumbersconf.org/event/2/contributions/99/attachments/98/117/lpc18_paper_af_xdp_perf-v2.pdf
> > > > 
> > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > ---
> > > >  include/linux/indirect_call_wrapper.h | 12 ++++++++++++
> > > >  1 file changed, 12 insertions(+)
> > > > 
> > > > diff --git a/include/linux/indirect_call_wrapper.h
> > > > b/include/linux/indirect_call_wrapper.h
> > > > index 00d7e8e919c6..7c4cac87eaf7 100644
> > > > --- a/include/linux/indirect_call_wrapper.h
> > > > +++ b/include/linux/indirect_call_wrapper.h
> > > > @@ -23,6 +23,16 @@
> > > >  		likely(f == f2) ? f2(__VA_ARGS__) :			
> > > > \
> > > >  				  INDIRECT_CALL_1(f, f1, __VA_ARGS__);	
> > > > \
> > > >  	})
> > > > +#define INDIRECT_CALL_3(f, f3, f2, f1, ...)			
> > > > 	
> > > > \
> > > > +	({								
> > > > \
> > > > +		likely(f == f3) ? f3(__VA_ARGS__) :			
> > > > \
> > > > +				  INDIRECT_CALL_2(f, f2, f1,
> > > > __VA_ARGS__); \
> > > > +	})
> > > > +#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...)			
> > > > 	\
> > > > +	({								
> > > > \
> > > > +		likely(f == f4) ? f4(__VA_ARGS__) :		
> > > 
> > > do we really want "likely" here ? in our cases there is no
> > > preference
> > > on whuch fN is going to have the top priority, all of them are
> > > equally
> > > important and statically configured and guranteed to not change on
> > > data
> > > path .. 
> > 
> > I was a little undecided about that, too. 'likely()' is there mainly
> > for simmetry with the already existing _1 and _2 variants. In such
> > macros the branch prediction hint represent a real priority of the
> > available choices.
> > 
> 
> For macro _1 it make sense to have the likely keyword but for _2 it
> doesn't, by looking at most of the usecases of INDIRECT_CALL_2, they
> seem to be all around improving tcp/udp related indirection calls in
> the protocol stack, and they seem to prefer tcp over udp. But IMHO at
> least for the above usecase I think the likely keyword is being misused
> here and should be remove from all INDIRECT_CALL_N where N > 1;

I experimented a bit with gcc 8.3.1 and some BP hint variations:

* with current macros we have single test for fN and an incresing
number of conditional jumps and tests for the following functions, as
the generated code looks somehow alike:

	cmp f4, function_ptr
	jne test_f3
	call f4
post_call:
	// ...

	// ...
test_f3:
	cmp f3, function_ptr
	jne test_f2
	call f3
	jmp post_call

test_f2:
	cmp f2, function_ptr
	//...

* keeping 'likely' only on INDIRECT_CALL_1 we get a conditinal jump for
fN and the number of conditional jumps and tests grows for the next
functions, as the generated code looks somehow alike:

	cmp f4, function_ptr
	je call_f4
	cmp f3, function_ptr
	je call_f3
	//...
	cmp f1, function_ptr
	jne indirect_call
	call f1
post_call:
	// ...

	// ...
call_f4:
	call f4
	jmp post_call
call_f3:
	call f3
	jmp post_call
	// ...


* without any BP hints, is quite alike the above, except for the last
test, the indirect call don't need an additional jump: 

	cmp f4, function_ptr
	je call_f4
	cmp f3, function_ptr
	je call_f3
	//...
	cmp f1, function_ptr
	je call_f1
	call retpoline_helper

I think the first option should be overall better then the 2nd. The 3rd
one is the worse.

> In any case, just make sure to use the order i suggested in next
> patch with: MLX5_RX_INDIRECT_CALL_LIST

Sure! will do in next iteration, as soon as the above topic is settled.

Thanks!

Paolo



