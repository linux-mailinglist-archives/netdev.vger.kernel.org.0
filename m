Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A49F3D6E36
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 07:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhG0FiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 01:38:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233553AbhG0FiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 01:38:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FCFD60F90;
        Tue, 27 Jul 2021 05:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627364291;
        bh=0xAVsd9KoCyr0o32NIcttnw+73Jww45a9+0ilFQnBo4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nr2s3avoudRdZw6pIh6+FVRyYJgPJB9ClyqAW+z/cHX9sMt++Uk2m+G/PiTFaQrLc
         jw2kY/dRimZEB+mekWwfmob3yawuAIG2Puy/Wy0cl3OrLcrt6vXXfQyXHHAJGl59r9
         LHQDQkirMaZlg7DdXJI24DvU+/71Gx3856YPX4dc=
Date:   Tue, 27 Jul 2021 07:38:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jordy Zomer <jordy@pwning.systems>, netdev@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccm - avoid negative wrapping of integers
Message-ID: <YP+bwR/Nt/NRYeDz@kroah.com>
References: <20210726170120.410705-1-jordy@pwning.systems>
 <YP7udzoj4vVQHlYv@gmail.com>
 <YP+beE4NGUCDIQHR@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YP+beE4NGUCDIQHR@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 07:36:56AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jul 26, 2021 at 10:18:47AM -0700, Eric Biggers wrote:
> > On Mon, Jul 26, 2021 at 07:01:20PM +0200, Jordy Zomer wrote:
> > > Set csize to unsigned int to avoid it from wrapping as a negative number (since format input sends an unsigned integer to this function). This would also result in undefined behavior in the left shift when msg len is checked, potentially resulting in a buffer overflow in the memcpy call.
> > > 
> > > Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> > > ---
> > > To address was corrected, and ccm was added to the topic to indicate that this is just for ccm.
> > > 
> > >  crypto/ccm.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/crypto/ccm.c b/crypto/ccm.c
> > > index 6b815ece51c6..e14201edf9db 100644
> > > --- a/crypto/ccm.c
> > > +++ b/crypto/ccm.c
> > > @@ -66,7 +66,7 @@ static inline struct crypto_ccm_req_priv_ctx *crypto_ccm_reqctx(
> > >  	return (void *)PTR_ALIGN((u8 *)aead_request_ctx(req), align + 1);
> > >  }
> > >  
> > > -static int set_msg_len(u8 *block, unsigned int msglen, int csize)
> > > +static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
> > >  {
> > >  	__be32 data;
> > 
> > This isn't necessarily a bad change, but the value of csize is clearly in
> > [1, 256] if you read format_input(), and in fact is in [2, 8] if you read the
> > whole file, so please don't claim this is actually fixing anything, as it's not.
> 
> Oh that was not obvious at all, I looked at that for a long time and
> missed the place where this was checked earlier.  Perhaps just make
> csize here a u8 and that would take away all question about what is
> happening?

And part of this effort is to make it obvious that there is no overflow
happening, to allow tools to check this type of thing.  When you have to
work backwards long long ways like this, it makes automatic auditing
almost impossible, along with manual auditing like I tried to do :)

thanks,

greg k-h
