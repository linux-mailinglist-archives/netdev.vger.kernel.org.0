Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145D345DA44
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 13:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354866AbhKYMrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 07:47:05 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:45889 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352763AbhKYMpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 07:45:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UyGY-Iw_1637844112;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UyGY-Iw_1637844112)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 20:41:52 +0800
Date:   Thu, 25 Nov 2021 20:41:51 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net 2/2] net/smc: Don't call clcsock shutdown twice when
 smc shutdown
Message-ID: <YZ+Ejxo0C9FeRgck@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211125061932.74874-1-tonylu@linux.alibaba.com>
 <20211125061932.74874-3-tonylu@linux.alibaba.com>
 <77c1be59-5e55-80f1-4fc6-16fb65846b7e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77c1be59-5e55-80f1-4fc6-16fb65846b7e@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 12:02:06PM +0100, Karsten Graul wrote:
> On 25/11/2021 07:19, Tony Lu wrote:
> > diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> > index 4b62c925a13e..7b04cb4d15f4 100644
> > --- a/net/smc/af_smc.c
> > +++ b/net/smc/af_smc.c
> > @@ -2373,6 +2373,7 @@ static int smc_shutdown(struct socket *sock, int how)
> >  	struct smc_sock *smc;
> >  	int rc = -EINVAL;
> >  	int rc1 = 0;
> > +	int old_state;
> 
> Reverse Christmas tree formatting, please.

Sorry for that, I will fix it in the next patch.

> 
> >  
> >  	smc = smc_sk(sk);
> >  
> > @@ -2398,7 +2399,12 @@ static int smc_shutdown(struct socket *sock, int how)
> >  	}
> >  	switch (how) {
> >  	case SHUT_RDWR:		/* shutdown in both directions */
> > +		old_state = sk->sk_state;
> >  		rc = smc_close_active(smc);
> > +		if (old_state == SMC_ACTIVE &&
> > +		    sk->sk_state == SMC_PEERCLOSEWAIT1)
> > +			goto out_no_shutdown;
> > +
> 
> I would prefer a new "bool do_shutdown" instead of a goto for this skip
> of the shutdown. What do you think?

I agree with you, I'd like bool condition rather than goto, which will
disturb the continuity of reading code.

I will fix it soon. Thank you.

Tony Lu

> 
> >  		break;
> >  	case SHUT_WR:
> >  		rc = smc_close_shutdown_write(smc);
> > @@ -2410,6 +2416,8 @@ static int smc_shutdown(struct socket *sock, int how)
> >  	}
> >  	if (smc->clcsock)
> >  		rc1 = kernel_sock_shutdown(smc->clcsock, how);
> > +
> > +out_no_shutdown:
> >  	/* map sock_shutdown_cmd constants to sk_shutdown value range */
> >  	sk->sk_shutdown |= how + 1;
> >  
> > 
> 
> -- 
> Karsten
