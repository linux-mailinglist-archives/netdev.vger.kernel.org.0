Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172294837A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfFQNGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbfFQNGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 09:06:43 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8FB2E308623F;
        Mon, 17 Jun 2019 13:06:42 +0000 (UTC)
Received: from ovpn-204-244.brq.redhat.com (ovpn-204-244.brq.redhat.com [10.40.204.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09A781001E61;
        Mon, 17 Jun 2019 13:06:34 +0000 (UTC)
Message-ID: <d840dc535ab546408f6280e04b8d492fa2b0c24c.camel@redhat.com>
Subject: Re: [RFC PATCH net-next 1/2] tcp: ulp: add functions to dump
 ulp-specific information
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
In-Reply-To: <20190605161400.6c87d173@cakuba.netronome.com>
References: <cover.1559747691.git.dcaratti@redhat.com>
         <a1feba1a1c03a331047d3a7a3a7acefdbee51735.1559747691.git.dcaratti@redhat.com>
         <20190605161400.6c87d173@cakuba.netronome.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 17 Jun 2019 15:06:33 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 17 Jun 2019 13:06:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-05 at 16:14 -0700, Jakub Kicinski wrote:
> On Wed,  5 Jun 2019 17:39:22 +0200, Davide Caratti wrote:
> > currently, only getsockopt(TCP_ULP) can be invoked to know if a ULP is on
> > top of a TCP socket. Extend idiag_get_aux() and idiag_get_aux_size(),
> > introduced by commit b37e88407c1d ("inet_diag: allow protocols to provide
> > additional data"), to report the ULP name and other information that can
> > be made available by the ULP through optional functions.
> > 
> > Users having CAP_NET_ADMIN privileges will then be able to retrieve this
> > information through inet_diag_handler, if they specify INET_DIAG_INFO in
> > the request.
> > 
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> > ---
> >  include/net/tcp.h              |  3 +++
> >  include/uapi/linux/inet_diag.h |  8 ++++++++
> >  net/ipv4/tcp_diag.c            | 34 ++++++++++++++++++++++++++++++++--
> >  3 files changed, 43 insertions(+), 2 deletions(-)

hi Jakub, thanks a lot for reviewing!

[...]
> > --- a/include/uapi/linux/inet_diag.h
> > +++ b/include/uapi/linux/inet_diag.h
> > @@ -153,11 +153,19 @@ enum {
> >  	INET_DIAG_BBRINFO,	/* request as INET_DIAG_VEGASINFO */
> >  	INET_DIAG_CLASS_ID,	/* request as INET_DIAG_TCLASS */
> >  	INET_DIAG_MD5SIG,
> > +	INET_DIAG_ULP_INFO,
> >  	__INET_DIAG_MAX,
> >  };
> >  
> >  #define INET_DIAG_MAX (__INET_DIAG_MAX - 1)
> >  
> > +enum {
> 
> Value of 0 is commonly defined as UNSPEC (or NONE), so:
> 
> 	ULP_UNSPEC,
> 
> here.  Also perhaps INET_ULP_..?

ok, will fix that in patch v1.

> > +	ULP_INFO_NAME,
> > +	__ULP_INFO_MAX,
> > +};
> > +
> > +#define ULP_INFO_MAX (__ULP_INFO_MAX - 1)
> > +
> >  /* INET_DIAG_MEM */
> >  

[...]

> > @@ -103,11 +105,33 @@ static int tcp_diag_get_aux(struct sock *sk, bool net_admin,
> >  	}
> >  #endif
> >  
> > -	return 0;
> > +	if (net_admin && icsk->icsk_ulp_ops) {
> > +		struct nlattr *nest;
> > +
> > +		nest = nla_nest_start_noflag(skb, INET_DIAG_ULP_INFO);
> > +		if (!nest) {
> > +			err = -EMSGSIZE;
> > +			goto nla_failure;
> > +		}
> > +		err = nla_put_string(skb, ULP_INFO_NAME,
> > +				     icsk->icsk_ulp_ops->name);
> > +		if (err < 0)
> 
> nit: nla_put_string() does not return positive non-zero codes

so, I will replace the test above with 

if (err)

> > +			goto nla_failure;
> > +		if (icsk->icsk_ulp_ops->get_info)
> > +			err = icsk->icsk_ulp_ops->get_info(sk, skb);
> 
> And neither should this, probably.

> > +		if (err < 0) {

same here.

> > +nla_failure:
> > +			nla_nest_cancel(skb, nest);
> > +			return err;
> > +		}
> > +		nla_nest_end(skb, nest);
> > +	}
> > +	return err;
> 
> So just return 0 here.

ok, I found comfortable with 'return err' because of the initialization at
the beginning of the function (this patch extends the scope of 'err' to
the whole function). But I'm not against return 0.

> >  }
> >  
> >  static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
> >  {
> > +	struct inet_connection_sock *icsk = inet_csk(sk);
> >  	size_t size = 0;
> >  
> >  #ifdef CONFIG_TCP_MD5SIG
> > @@ -128,6 +152,12 @@ static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
> >  	}
> >  #endif
> >  
> > +	if (net_admin && icsk->icsk_ulp_ops) {
> > +		size +=   nla_total_size(0) /* INET_DIAG_ULP_INFO */
> 
>                        ^^^ not sure we want those multiple spaces here.
> 
> > +			+ nla_total_size(TCP_ULP_NAME_MAX); /* ULP_INFO_NAME */
> 
> + usually goes at the end of previous line

I took the inspiration from the caller of .idiag_get_aux_size(). But you are right,
vxlan_get_size() has a better formatting: will fix that in patch v1.

> > +		if (icsk->icsk_ulp_ops->get_info_size)
> > +			size += icsk->icsk_ulp_ops->get_info_size(sk);
> 
> I don't know the diag code, is the socket locked at this point?

as far as I can see, it's not. Thanks a lot for noticing this!

anyway, I see a similar pattern for icsk_ca_ops: when we set the congestion
control with do_tcp_setsockopt(), the socket is locked - but then, when 'ss'
reads a diag request with INET_DIAG_CONG bit set, the value of icsk->icsk_ca_ops
is accessed with READ_ONCE(), surrounded by rcu_read_{,un}lock(). 

Maybe it's sufficient to do something similar, and then the socket lock can be
optionally taken within icsk_ulp_ops->get_info(), only in case we need to access
members of sk that are protected with the socket lock?

-- 
davide

