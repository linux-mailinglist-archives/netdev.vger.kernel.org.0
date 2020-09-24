Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649A2276B10
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgIXHn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:43:59 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:49626 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgIXHn7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 03:43:59 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLLux-0004ri-K0; Thu, 24 Sep 2020 17:43:52 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Sep 2020 17:43:51 +1000
Date:   Thu, 24 Sep 2020 17:43:51 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     syzbot <syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: stack-out-of-bounds Read in xfrm_selector_match (2)
Message-ID: <20200924074351.GB9879@gondor.apana.org.au>
References: <0000000000009fc91605afd40d89@google.com>
 <20200924074026.GC20687@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924074026.GC20687@gauss3.secunet.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 09:40:26AM +0200, Steffen Klassert wrote:
>
> This is yet another ipv4 mapped ipv6 address with IPsec socket policy
> combination bug, and I'm sure it is not the last one. We could fix this
> one by adding another check to match the address family of the policy
> and the SA selector, but maybe it is better to think about how this
> should work at all.
> 
> We can have only one socket policy for each direction and that
> policy accepts either ipv4 or ipv6. We treat this ipv4 mapped ipv6
> address as ipv4 and pass it down the ipv4 stack, so this dual usage
> will not work with a socket policy. Maybe we can require IPV6_V6ONLY
> for sockets with policy attached. Thoughts?

I'm looking at the history of this and it used to work at the start
because you'd always interpret the flow object with a family.  This
appears to have been lost with 8444cf712c5f71845cba9dc30d8f530ff0d5ff83. 

I'm working on a fix.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
