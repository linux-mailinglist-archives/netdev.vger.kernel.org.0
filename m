Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5721324B772
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 12:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgHTKyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 06:54:36 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46006 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731701AbgHTKxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 06:53:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A6F63205CF;
        Thu, 20 Aug 2020 12:53:25 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8m6qfNlEf_FW; Thu, 20 Aug 2020 12:53:25 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 07D1120539;
        Thu, 20 Aug 2020 12:53:25 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 12:53:24 +0200
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 20 Aug
 2020 12:53:24 +0200
Date:   Thu, 20 Aug 2020 12:53:22 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Stephan Mueller <smueller@chronox.de>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>, <antony.antony@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Antony Antony" <antony@phenome.org>
Subject: Re: [PATCH ipsec-next] xfrm: add
 /proc/sys/core/net/xfrm_redact_secret
Message-ID: <20200820105322.GC966@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20200728154342.GA31835@moon.secunet.de>
 <3322274.jE0xQCEvom@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3322274.jE0xQCEvom@tauon.chronox.de>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 21:09:10 +0200, Stephan Mueller wrote:
> Am Dienstag, 28. Juli 2020, 17:47:30 CEST schrieb Antony Antony:
> 
> Hi Antony,
> 
> > when enabled, 1, redact XFRM SA secret in the netlink response to
> > xfrm_get_sa() or dump all sa.
> > 
> > e.g
> > echo 1 > /proc/sys/net/core/xfrm_redact_secret
> > ip xfrm state
> > src 172.16.1.200 dst 172.16.1.100
> > 	proto esp spi 0x00000002 reqid 2 mode tunnel
> > 	replay-window 0
> > 	aead rfc4106(gcm(aes)) 0x0000000000000000000000000000000000000000 96
> > 
> > the aead secret is redacted.
> > 
> > /proc/sys/core/net/xfrm_redact_secret is a toggle.
> > Once enabled, either at compile or via proc, it can not be disabled.
> > Redacting secret is a FIPS 140-2 requirement.
> > 
> > Cc: Stephan Mueller <smueller@chronox.de>
> > Signed-off-by: Antony Antony <antony.antony@secunet.com>
> > ---
> >  Documentation/networking/xfrm_sysctl.rst |  7 +++
> >  include/net/netns/xfrm.h                 |  1 +
> >  net/xfrm/Kconfig                         | 10 ++++
> >  net/xfrm/xfrm_sysctl.c                   | 20 +++++++
> >  net/xfrm/xfrm_user.c                     | 76 +++++++++++++++++++++---
> >  5 files changed, 105 insertions(+), 9 deletions(-)
> > 
> > diff --git a/Documentation/networking/xfrm_sysctl.rst
> > b/Documentation/networking/xfrm_sysctl.rst index 47b9bbdd0179..26432b0ff3ac
> > 100644
> > --- a/Documentation/networking/xfrm_sysctl.rst
> > +++ b/Documentation/networking/xfrm_sysctl.rst
> > @@ -9,3 +9,10 @@ XFRM Syscall
> > 
> >  xfrm_acq_expires - INTEGER
> >  	default 30 - hard timeout in seconds for acquire requests
> > +
> > +xfrm_redact_secret - INTEGER
> > +	A toggle to redact xfrm SA's secret to userspace.
> > +	When true the kernel, netlink message will redact SA secret
> > +	to userspace. This is part of FIPS 140-2 requirement.
> > +	Once the value is set to true, either at compile or at run time,
> > +	it can not be set to false.
> > diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
> > index 59f45b1e9dac..0ca9328daad4 100644
> > --- a/include/net/netns/xfrm.h
> > +++ b/include/net/netns/xfrm.h
> > @@ -64,6 +64,7 @@ struct netns_xfrm {
> >  	u32			sysctl_aevent_rseqth;
> >  	int			sysctl_larval_drop;
> >  	u32			sysctl_acq_expires;
> > +	u32			sysctl_redact_secret;
> >  #ifdef CONFIG_SYSCTL
> >  	struct ctl_table_header	*sysctl_hdr;
> >  #endif
> > diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
> > index 5b9a5ab48111..270a4e906a15 100644
> > --- a/net/xfrm/Kconfig
> > +++ b/net/xfrm/Kconfig
> > @@ -91,6 +91,16 @@ config XFRM_ESP
> >  	select CRYPTO_SEQIV
> >  	select CRYPTO_SHA256
> > 
> > +config XFRM_REDACT_SECRET
> > +	bool "Redact xfrm SA secret in netlink message"
> > +	depends on SYSCTL
> > +	default n
> > +	help
> > +	  Enable XFRM SA secret redact in the netlink message.
> > +	  Redacting secret is a FIPS 140-2 requirement.
> > +	  Once enabled at compile, the value can not be set to false on
> > +	  a running system.
> > +
> >  config XFRM_IPCOMP
> >  	tristate
> >  	select XFRM_ALGO
> > diff --git a/net/xfrm/xfrm_sysctl.c b/net/xfrm/xfrm_sysctl.c
> > index 0c6c5ef65f9d..a41aa325a478 100644
> > --- a/net/xfrm/xfrm_sysctl.c
> > +++ b/net/xfrm/xfrm_sysctl.c
> > @@ -4,15 +4,25 @@
> >  #include <net/net_namespace.h>
> >  #include <net/xfrm.h>
> > 
> > +#ifdef CONFIG_SYSCTL
> > +#ifdef CONFIG_XFRM_REDACT_SECRET
> > +#define XFRM_REDACT_SECRET  1
> > +#else
> > +#define XFRM_REDACT_SECRET  0
> > +#endif
> > +#endif
> > +
> >  static void __net_init __xfrm_sysctl_init(struct net *net)
> >  {
> >  	net->xfrm.sysctl_aevent_etime = XFRM_AE_ETIME;
> >  	net->xfrm.sysctl_aevent_rseqth = XFRM_AE_SEQT_SIZE;
> >  	net->xfrm.sysctl_larval_drop = 1;
> >  	net->xfrm.sysctl_acq_expires = 30;
> > +	net->xfrm.sysctl_redact_secret = XFRM_REDACT_SECRET;
> >  }
> > 
> >  #ifdef CONFIG_SYSCTL
> > +
> >  static struct ctl_table xfrm_table[] = {
> >  	{
> >  		.procname	= "xfrm_aevent_etime",
> > @@ -38,6 +48,15 @@ static struct ctl_table xfrm_table[] = {
> >  		.mode		= 0644,
> >  		.proc_handler	= proc_dointvec
> >  	},
> > +	{
> > +		.procname	= "xfrm_redact_secret",
> > +		.maxlen		= sizeof(u32),
> > +		.mode		= 0644,
> > +		/* only handle a transition from "0" to "1" */
> > +		.proc_handler	= proc_dointvec_minmax,
> > +		.extra1         = SYSCTL_ONE,
> > +		.extra2         = SYSCTL_ONE,
> > +	},
> >  	{}
> >  };
> > 
> > @@ -54,6 +73,7 @@ int __net_init xfrm_sysctl_init(struct net *net)
> >  	table[1].data = &net->xfrm.sysctl_aevent_rseqth;
> >  	table[2].data = &net->xfrm.sysctl_larval_drop;
> >  	table[3].data = &net->xfrm.sysctl_acq_expires;
> > +	table[4].data = &net->xfrm.sysctl_redact_secret;
> > 
> >  	/* Don't export sysctls to unprivileged users */
> >  	if (net->user_ns != &init_user_ns)
> > diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> > index e6cfaa680ef3..a3e89dddea9d 100644
> > --- a/net/xfrm/xfrm_user.c
> > +++ b/net/xfrm/xfrm_user.c
> > @@ -848,21 +848,78 @@ static int copy_user_offload(struct xfrm_state_offload
> > *xso, struct sk_buff *skb return 0;
> >  }
> > 
> > -static int copy_to_user_auth(struct xfrm_algo_auth *auth, struct sk_buff
> > *skb) +static int copy_to_user_auth(u32 redact_secret, struct
> > xfrm_algo_auth *auth, +			     struct sk_buff *skb)
> >  {
> >  	struct xfrm_algo *algo;
> > +	struct xfrm_algo_auth *ap;
> >  	struct nlattr *nla;
> > 
> >  	nla = nla_reserve(skb, XFRMA_ALG_AUTH,
> >  			  sizeof(*algo) + (auth->alg_key_len + 7) / 8);
> >  	if (!nla)
> >  		return -EMSGSIZE;
> > -
> >  	algo = nla_data(nla);
> >  	strncpy(algo->alg_name, auth->alg_name, sizeof(algo->alg_name));
> > -	memcpy(algo->alg_key, auth->alg_key, (auth->alg_key_len + 7) / 8);
> > +
> > +	if (redact_secret && auth->alg_key_len)
> > +		memset(algo->alg_key, 0, (auth->alg_key_len + 7) / 8);
> > +	else
> > +		memcpy(algo->alg_key, auth->alg_key,
> > +		       (auth->alg_key_len + 7) / 8);
> >  	algo->alg_key_len = auth->alg_key_len;
> > 
> > +	nla = nla_reserve(skb, XFRMA_ALG_AUTH_TRUNC, xfrm_alg_auth_len(auth));
> > +	if (!nla)
> > +		return -EMSGSIZE;
> > +	ap = nla_data(nla);
> > +	memcpy(ap, auth, sizeof(struct xfrm_algo_auth));
> > +	if (redact_secret)
> 
> You test for auth->alg_key_len above. Shouldn't there such a check here too?

It is a good idea add checks before all memset calls.
I will send a new version out soon.

thanks,
-antony

