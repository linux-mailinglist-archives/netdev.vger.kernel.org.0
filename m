Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA94629588B
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 08:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504251AbgJVGs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 02:48:26 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37144 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440717AbgJVGsZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 02:48:25 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kVUON-00077a-V1; Thu, 22 Oct 2020 17:48:09 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Oct 2020 17:48:07 +1100
Date:   Thu, 22 Oct 2020 17:48:07 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "zhuoliang.zhang" <zhuoliang.zhang@mediatek.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com
Subject: Re: [PATCH] net: xfrm: fix a race condition during allocing spi
Message-ID: <20201022064807.GA16043@gondor.apana.org.au>
References: <20201020081800.29454-1-zhuoliang.zhang@mediatek.com>
 <20201021071222.GA11474@gondor.apana.org.au>
 <1603345995.13237.2.camel@mbjsdccf07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603345995.13237.2.camel@mbjsdccf07>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 01:53:15PM +0800, zhuoliang.zhang wrote:
> 
> there are 2 related hash lists : net->xfrm.state_bydst and
> net->xfrm.state_byspi:
> 
> 1. a new state x is alloced in xfrm_state_alloc() and added into the
> bydst hlist in  __find_acq_core() on the LHS;
> 2. on the RHS, state_hash_work thread travels the old bydst and tranfers
> every xfrm_state (include x) to the new bydst hlist and new byspi hlist;
> 3. user thread on the LHS gets the lock and adds x to the new byspi
> hlist again.

Good catch.  Please add a Fixes header.  I think this was introduced
with the dynamic resizing in f034b5d4efdfe0fb9e2a1ce1d95fa7914f24de49.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
