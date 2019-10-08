Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5431CF244
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbfJHFzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:55:12 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35082 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729375AbfJHFzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 01:55:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D8D3820536;
        Tue,  8 Oct 2019 07:55:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 79o4Qxo-Eyb9; Tue,  8 Oct 2019 07:55:10 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2DB36201E5;
        Tue,  8 Oct 2019 07:55:10 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 8 Oct 2019
 07:55:09 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id BA2E03180074;
 Tue,  8 Oct 2019 07:55:09 +0200 (CEST)
Date:   Tue, 8 Oct 2019 07:55:09 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     kbuild test robot <lkp@intel.com>
CC:     Sabrina Dubroca <sd@queasysnail.net>, <kbuild-all@01.org>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [ipsec-next:testing 7/8] include/net/espintcp.h:36:20: sparse:
 sparse: incorrect type in return expression (different address spaces)
Message-ID: <20191008055509.GW2879@gauss3.secunet.de>
References: <201910061039.jnJWPq01%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201910061039.jnJWPq01%lkp@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 06, 2019 at 10:46:40AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git testing
> head:   5374d99ba41893b4bb1ddbe35a88b1f08e860903
> commit: 735de2631f8680ac714df1ecc8e052785e9f9f8e [7/8] xfrm: add espintcp (RFC 8229)
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.1-rc1-42-g38eda53-dirty
>         git checkout 735de2631f8680ac714df1ecc8e052785e9f9f8e
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> 
> >> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
> >> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
> >> include/net/espintcp.h:36:20: sparse: sparse: incorrect type in return expression (different address spaces) @@    expected struct espintcp_ctx * @@    got voistruct espintcp_ctx * @@
> >> include/net/espintcp.h:36:20: sparse:    expected struct espintcp_ctx *
> >> include/net/espintcp.h:36:20: sparse:    got void [noderef] <asn:4> *icsk_ulp_data
> 
> vim +36 include/net/espintcp.h
> 
>     31	
>     32	static inline struct espintcp_ctx *espintcp_getctx(const struct sock *sk)
>     33	{
>     34		struct inet_connection_sock *icsk = inet_csk(sk);
>     35	
>   > 36		return icsk->icsk_ulp_data;

Sabrina, can you please fix this and resend the patchset?

Also, icsk_ulp_data has a __rcu annotation, so maybe better
using rcu primitives to access the pointer?

Another thing, where is espintcp_ctx that is assigned to
icsk_ulp_data freed?
