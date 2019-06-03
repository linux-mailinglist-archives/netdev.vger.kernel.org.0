Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1B632D2F
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfFCJvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbfFCJvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 05:51:14 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7F644C058CA2;
        Mon,  3 Jun 2019 09:51:09 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 715DC1001DD9;
        Mon,  3 Jun 2019 09:51:08 +0000 (UTC)
Message-ID: <141f34bb8d1505783b4f939faac5223200deeb13.camel@redhat.com>
Subject: Re: [PATCH net-next 2/3] indirect call wrappers: add helpers for 3
 and 4 ways switch
From:   Paolo Abeni <pabeni@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Date:   Mon, 03 Jun 2019 11:51:07 +0200
In-Reply-To: <1133f7e92cffb7ade5249e6d6ac0dd430549bf14.camel@mellanox.com>
References: <cover.1559304330.git.pabeni@redhat.com>
         <7dc56c32624fd102473fc66ffdda6ebfcdfe6ad0.1559304330.git.pabeni@redhat.com>
         <1133f7e92cffb7ade5249e6d6ac0dd430549bf14.camel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 03 Jun 2019 09:51:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-31 at 18:30 +0000, Saeed Mahameed wrote:
> On Fri, 2019-05-31 at 14:53 +0200, Paolo Abeni wrote:
> > Experimental results[1] has shown that resorting to several branches
> > and a direct-call is faster than indirect call via retpoline, even
> > when the number of added branches go up 5.
> > 
> > This change adds two additional helpers, to cope with indirect calls
> > with up to 4 available direct call option. We will use them
> > in the next patch.
> > 
> > [1] 
> > https://linuxplumbersconf.org/event/2/contributions/99/attachments/98/117/lpc18_paper_af_xdp_perf-v2.pdf
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  include/linux/indirect_call_wrapper.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/include/linux/indirect_call_wrapper.h
> > b/include/linux/indirect_call_wrapper.h
> > index 00d7e8e919c6..7c4cac87eaf7 100644
> > --- a/include/linux/indirect_call_wrapper.h
> > +++ b/include/linux/indirect_call_wrapper.h
> > @@ -23,6 +23,16 @@
> >  		likely(f == f2) ? f2(__VA_ARGS__) :			
> > \
> >  				  INDIRECT_CALL_1(f, f1, __VA_ARGS__);	
> > \
> >  	})
> > +#define INDIRECT_CALL_3(f, f3, f2, f1, ...)				
> > \
> > +	({								
> > \
> > +		likely(f == f3) ? f3(__VA_ARGS__) :			
> > \
> > +				  INDIRECT_CALL_2(f, f2, f1,
> > __VA_ARGS__); \
> > +	})
> > +#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...)			
> > 	\
> > +	({								
> > \
> > +		likely(f == f4) ? f4(__VA_ARGS__) :		
> 
> do we really want "likely" here ? in our cases there is no preference
> on whuch fN is going to have the top priority, all of them are equally
> important and statically configured and guranteed to not change on data
> path .. 

I was a little undecided about that, too. 'likely()' is there mainly
for simmetry with the already existing _1 and _2 variants. In such
macros the branch prediction hint represent a real priority of the
available choices.

To avoid the branch prediction, a new set of macros should be defined,
but that also sounds redundant.

If you have strong opinion against the breanch prediction hint, I could
either drop this patch and the next one or resort to custom macros in
the mlx code.

Any [alternative] suggestions more than welcome!
	\
> > +				  INDIRECT_CALL_3(f, f3, f2, f1,
> > __VA_ARGS__); \
> > +	})
> >  
> 
> Oh the RETPOLINE!
> 
> On which (N) where INDIRECT_CALL_N(f, fN, fN-1, ..., f1,...) , calling
> the indirection function pointer directly is going to be actually
> better than this whole INDIRECT_CALL_N wrapper "if else" dance ?

In commit ce02ef06fcf7a399a6276adb83f37373d10cbbe1, it's measured a
relevant gain even with more than 5 options. I personally would avoid
adding much more options than the above.

Thanks,

Paolo


