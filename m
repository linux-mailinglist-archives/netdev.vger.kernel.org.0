Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040BBCF410
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 09:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbfJHHj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 03:39:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729740AbfJHHj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 03:39:57 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9627E793CC;
        Tue,  8 Oct 2019 07:39:56 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-43.ams2.redhat.com [10.36.116.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 476725D71C;
        Tue,  8 Oct 2019 07:39:54 +0000 (UTC)
Date:   Tue, 8 Oct 2019 09:39:53 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [ipsec-next:testing 7/8] include/net/espintcp.h:36:20: sparse:
 sparse: incorrect type in return expression (different address spaces)
Message-ID: <20191008073953.GA1408676@bistromath.localdomain>
References: <201910061039.jnJWPq01%lkp@intel.com>
 <20191008055509.GW2879@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191008055509.GW2879@gauss3.secunet.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 08 Oct 2019 07:39:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-10-08, 07:55:09 +0200, Steffen Klassert wrote:
> On Sun, Oct 06, 2019 at 10:46:40AM +0800, kbuild test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
> > head:   5374d99ba41893b4bb1ddbe35a88b1f08e860903
> > commit: 735de2631f8680ac714df1ecc8e052785e9f9f8e [7/8] xfrm: add espintcp (RFC 8229)
> > reproduce:
> >         # apt-get install sparse
> >         # sparse version: v0.6.1-rc1-42-g38eda53-dirty
> >         git checkout 735de2631f8680ac714df1ecc8e052785e9f9f8e
> >         make ARCH=x86_64 allmodconfig
> >         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> > 
> > 
> > >> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
> > >> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
> > >> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
> > >> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
> > >> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
> > 
> > vim +36 include/net/espintcp.h
> > 
> >     31	
> >     32	static inline struct espintcp_ctx *espintcp_getctx(const struct sock *sk)
> >     33	{
> >     34		struct inet_connection_sock *icsk = inet_csk(sk);
> >     35	
> >   > 36		return icsk->icsk_ulp_data;
> 
> Sabrina, can you please fix this and resend the patchset?

Yep, will do.

> Also, icsk_ulp_data has a __rcu annotation, so maybe better
> using rcu primitives to access the pointer?

Apparently RCU protection of icsk_ulp_data is only needed for diag
(see commit 15a7dea750e0 ("net/tls: use RCU protection on
icsk->icsk_ulp_data")). I'll check this and update the patch.

> Another thing, where is espintcp_ctx that is assigned to
> icsk_ulp_data freed?

That's in espintcp_destruct:

static void espintcp_destruct(struct sock *sk)
{
	struct espintcp_ctx *ctx = espintcp_getctx(sk);

	kfree(ctx);
}


Thanks,

-- 
Sabrina
