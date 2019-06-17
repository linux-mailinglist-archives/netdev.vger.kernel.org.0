Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367C848847
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 18:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfFQQEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 12:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbfFQQET (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 12:04:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ACE06A3816;
        Mon, 17 Jun 2019 16:04:13 +0000 (UTC)
Received: from ovpn-204-244.brq.redhat.com (ovpn-204-244.brq.redhat.com [10.40.204.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AA065C2F5;
        Mon, 17 Jun 2019 16:04:07 +0000 (UTC)
Message-ID: <5ed5d6b3356c505ece2a354847e3aafd09fb82f3.camel@redhat.com>
Subject: Re: [RFC PATCH net-next 2/2] net: tls: export protocol version and
 cipher to socket diag
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
In-Reply-To: <20190605162555.59b4fb3e@cakuba.netronome.com>
References: <cover.1559747691.git.dcaratti@redhat.com>
         <4262dd2617a24b66f24ec5ddc73f817e683e14e0.1559747691.git.dcaratti@redhat.com>
         <20190605162555.59b4fb3e@cakuba.netronome.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 17 Jun 2019 18:04:06 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 17 Jun 2019 16:04:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-05 at 16:25 -0700, Jakub Kicinski wrote:
> On Wed,  5 Jun 2019 17:39:23 +0200, Davide Caratti wrote:
> > When an application configures kernel TLS on top of a TCP socket, it's
> > now possible for inet_diag_handler to collect information regarding the
> > protocol version and the cipher, in case INET_DIAG_INFO is requested.
> > 
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>

> >  
> > +enum {
> 
> USPEC
> 
> > +	TLS_INFO_VERSION,
> > +	TLS_INFO_CIPHER,
> 

Ok,

> We need some indication of the directions in which kTLS is active
> (none, rx, tx, rx/tx).
> 
> Also perhaps could you add TLS_SW vs TLS_HW etc. ? :)

I can add a couple of u16 (or larger?) bitmasks to dump txconf and rxconf.
do you think this is sufficient?

> > +	__TLS_INFO_MAX,
> > +};
> > +

> Traditionally we put no new line between enum and the max define.

Ok, will fix that in v1.

> > +#define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
> > +
> >  #endif /* _UAPI_LINUX_TLS_H */
> > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > index fc81ae18cc44..14597526981c 100644
> > --- a/net/tls/tls_main.c
> > +++ b/net/tls/tls_main.c
> > @@ -39,6 +39,7 @@
> >  #include <linux/netdevice.h>
> >  #include <linux/sched/signal.h>
> >  #include <linux/inetdevice.h>
> > +#include <linux/inet_diag.h>
> > 
> >  #include <net/tls.h>
> >  
> > @@ -798,6 +799,46 @@ static int tls_init(struct sock *sk)
> >  	return rc;
> >  }
> >  
> > +static int tls_get_info(struct sock *sk, struct sk_buff *skb)
> > +{
> > +	struct tls_context *ctx = tls_get_ctx(sk);
> > +	struct nlattr *start = 0;
> 
> Hm.. NULL?  Does this not give you a warning?

I didn't notice it, but sure. will fix in v1.

> > +	int err = 0;
> 
> There should be no need to init this.
> 
> > +	if (sk->sk_state != TCP_ESTABLISHED)
> 
> Hmm.. why this check?  We never clean up the state once installed until
> the socket dies completely (currently, pending John's unhash work).

the goal was to ensure that we don't read ctx anymore after
tls_sk_proto_close() has freed ctx, and I thought that a test on the value
of sk_state was sufficient.

If it's not, then we might invent something else. For example, we might
defer freeing kTLS ctx, so that it's called as the very last thing with
tcp_cleanup_ulp().
 
> > +		goto end;
> 
> Please don't do this, just return 0; here.
> 
> > +	start = nla_nest_start_noflag(skb, ULP_INFO_TLS);
> > +	if (!start) {
> > +		err = -EMSGSIZE;
> > +		goto nla_failure;
> 
> 		return -EMSGSIZE;
> 
> > +	}
> > +	err = nla_put_u16(skb, TLS_INFO_VERSION, ctx->prot_info.version);
> > +	if (err < 0)
> > +		goto nla_failure;
> > +	err = nla_put_u16(skb, TLS_INFO_CIPHER, ctx->prot_info.cipher_type);
> > +	if (err < 0)
> > +		goto nla_failure;
> > +	nla_nest_end(skb, start);
> > +end:
> > +	return err;
> 
> 	return 0;
> 
> > +nla_failure:
> > +	nla_nest_cancel(skb, start);
> > +	goto end;
> 
> 	return err;

Ok, i can remove that 'goto end'. 

> > +}
> > +
> > +static size_t tls_get_info_size(struct sock *sk)
> > +{
> > +	size_t size = 0;
> > +
> > +	if (sk->sk_state != TCP_ESTABLISHED)
> > +		return size;
> > +
> > +	size +=   nla_total_size(0) /* ULP_INFO_TLS */
> > +		+ nla_total_size(sizeof(__u16))	/* TLS_INFO_VERSION */
> > +		+ nla_total_size(sizeof(__u16)); /* TLS_INFO_CIPHER */
> > +	return size;
> > +}
> 
> Same comments as on patch 1 and above.

sure, ok.

> >  void tls_register_device(struct tls_device *device)
> >  {
> >  	spin_lock_bh(&device_spinlock);
> 
> Thanks for working on this, it was on my todo list! :)

thanks for the review!
-- 
davide


