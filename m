Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207DA15B930
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 06:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbgBMFsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 00:48:08 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:36936 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgBMFsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 00:48:08 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j27Lv-0002va-Ue; Thu, 13 Feb 2020 13:47:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j27Lr-0001EJ-Vy; Thu, 13 Feb 2020 13:47:52 +0800
Date:   Thu, 13 Feb 2020 13:47:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephen Kitt <steve@sk2.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Atul Gupta <atul.gupta@chelsio.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] crypto: chelsio - remove extra allocation for chtls_dev
Message-ID: <20200213054751.4okuxe3hr2i4dxzs@gondor.apana.org.au>
References: <20200124222051.1925415-1-steve@sk2.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124222051.1925415-1-steve@sk2.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 11:20:51PM +0100, Stephen Kitt wrote:
> chtls_uld_add allocates room for info->nports net_device structs
> following the chtls_dev struct, presumably because it was originally
> intended that the ports array would be stored there. This is suggested
> by the assignment which was present in initial versions and removed by
> c4e848586cf1 ("crypto: chelsio - remove redundant assignment to
> cdev->ports"):
> 
> 	cdev->ports = (struct net_device **)(cdev + 1);
> 
> This assignment was never used, being overwritten by lldi->ports
> immediately afterwards, and I couldn't find any uses of the memory
> allocated past the end of the struct.
> 
> Signed-off-by: Stephen Kitt <steve@sk2.org>

Thanks for the patch!

I think the problem goes deeper though.  It appears that instead
of allocating a ports array this function actually hangs onto the
array from the function argument "info".  This seems to be broken
and possibly the extra memory allocated was meant to accomodate
the ports array.  Indeed, the code removed by the commit that you
mentioned indicates this as well (although the memory was never
actually used).

Dave, I think we should talk about the maintainence of the chelsio
net/crypto drivers.  They have quite a bit of overlap and there is
simply not enough people on the crypto side to review these drivers
properly.  Would it be possible for all future changes to these
drivers to go through the net tree?
 
Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
