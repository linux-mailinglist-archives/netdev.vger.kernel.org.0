Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF003ECFC3
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 09:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbhHPHyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 03:54:33 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53106 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234414AbhHPHyc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 03:54:32 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mFXRO-000705-Gm; Mon, 16 Aug 2021 15:53:50 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mFXRK-0002qN-SR; Mon, 16 Aug 2021 15:53:46 +0800
Date:   Mon, 16 Aug 2021 15:53:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: xfrm: fix bug in ipcomp_free_scratches
Message-ID: <20210816075346.GA10906@gondor.apana.org.au>
References: <20210816073832.199701-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816073832.199701-1-mudongliangabcd@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 03:38:29PM +0800, Dongliang Mu wrote:
>
> -	for_each_possible_cpu(i)
> -		vfree(*per_cpu_ptr(scratches, i));
> +	for_each_possible_cpu(i) {
> +		void *scratch = *per_cpu_ptr(scratches, i);
> +		if (!scratch)
> +			vfree(scratch);
> +	}

This patch is unnecessary.  Please check the implementation of
vfree, it already checks for NULL pointers just like most of our
free primitives.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
