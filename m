Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AAA1F61D7
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 08:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgFKGm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 02:42:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33712 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgFKGmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 02:42:52 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jjGvE-0004fN-Ir; Thu, 11 Jun 2020 16:42:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2020 16:42:44 +1000
Date:   Thu, 11 Jun 2020 16:42:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     ayush.sawal@asicdesigners.com, davem@davemloft.net,
        netdev@vger.kernel.org, manojmalviya@chelsio.com
Subject: Re: [PATCH net-next 2/2] Crypto/chcr: Checking cra_refcnt before
 unregistering the algorithms
Message-ID: <20200611064244.GA7402@gondor.apana.org.au>
References: <20200609212432.2467-1-ayush.sawal@chelsio.com>
 <20200609212432.2467-3-ayush.sawal@chelsio.com>
 <20200611034812.GA27335@gondor.apana.org.au>
 <41e4ea2f-c586-55cb-db2f-5b542133a6d1@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <41e4ea2f-c586-55cb-db2f-5b542133a6d1@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 11:38:39AM +0530, Ayush Sawal wrote:
>
> Sorry for this hack, Our problem was when ipsec is under use and device is
> dettached, then chcr_unregister_alg()
> is called which unregisters the algorithms, but as ipsec is established the
> cra_refcnt is not 1 and it gives a kernel bug.
> So i put a check of cra_refcnt there, taking the reference of a crypto
> driver  "marvell/octeontx/otx_cptvf_algs.c"
> is_any_alg_used(void) function where cra_refcnt is checked before
> unregistering the algorithms.

I understand.  The question is how do you want to deal with the
exception.  IOW do you want to leave the algorithm still registered?
If you can keep the algorithm registered you might as well never
unregister it in the first place.

If it has to go then this code path must wait for the users to
disappear first.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
