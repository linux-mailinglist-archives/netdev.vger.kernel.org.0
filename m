Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476652DB841
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgLPBKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:10:51 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:52375 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgLPBKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 20:10:50 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0BG18dep014480;
        Wed, 16 Dec 2020 02:08:44 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id AC013121E32;
        Wed, 16 Dec 2020 02:08:34 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1608080915; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WS43lXwhfi/ctG0+l3cxr7h07ZIouZ39cgwiKy4eKO4=;
        b=kQANFY2dGGq0gOTDh9bdcb0GKBt51Lfqrk9s2WXtMgJ+iFUypXZxRVSOxo92D40mugdOJu
        0gHdyKY+NP1IpSAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1608080915; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WS43lXwhfi/ctG0+l3cxr7h07ZIouZ39cgwiKy4eKO4=;
        b=mfM4Yl1HV4SwJ1NW1KqoPoFs1LI7wtmR3ybwK6JFmkgUITAD0dJBbII7IjvgieKmeR9YU8
        PWHZQEUTFqcPlbm36t5GTTmX+2fDnqnDhlRNDkpVdu3/Do7VSMO+LqeFAXAT5TcP7thPiq
        b8eHTtHanLYM1lLmBiiU3QYiH1JcR+MMTcJ+ZMvThuSA3qt4AEGPMaQEfxX+rr97g9WXtF
        UwviQAeuKRmUyKNK4rnck8MbBKAslFzUyQEmusz0Ozcga5g1Q8MYZmxwcDMnBcszqJlVOY
        7fGeZqisZAA0qCNC3TSiLDG0Y8SyH9V82e+nmP1dUxJK1IQQD9q0uSNSR5GHMw==
Date:   Wed, 16 Dec 2020 02:08:34 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <david.lebrun@uclouvain.be>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH net-next] seg6: fix the max number of supported SRv6
 behavior attributes
Message-Id: <20201216020834.c460011bccede55d0049c3c2@uniroma2.it>
In-Reply-To: <20201214205740.7e7a3945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201212010005.7338-1-andrea.mayer@uniroma2.it>
        <20201214205740.7e7a3945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
thanks for your review.

On Mon, 14 Dec 2020 20:57:40 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> > 
> >  - At compile time we verify that the total number of attributes does not
> >    exceed the fixed value of 64. Otherwise, kernel build fails forcing
> >    developers to reconsider adding a new attribute or extending the
> >    total number of supported attributes by the SRv6 networking.
> 
> Over all seems like a good thing too catch but the patch seems to go
> further than necessary. And on 32bit systems using u64 is when we only
> need 10 attrs is kinda wasteful.
> 

Ok, so the maximum number of supported attributes will be 32 (i.e. the
minimum number of bits for an unsigned long).

> > Fixes: d1df6fd8a1d2 ("ipv6: sr: define core operations for seg6local lightweight tunnel")
> > Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
> > Fixes: 891ef8dd2a8d ("ipv6: sr: implement additional seg6local actions")
> > Fixes: 004d4b274e2a ("ipv6: sr: Add seg6local action End.BPF")
> > Fixes: 964adce526a4 ("seg6: improve management of behavior attributes")
> > Fixes: 0a3021f1d4e5 ("seg6: add support for optional attributes in SRv6 behaviors")
> > Fixes: 664d6f86868b ("seg6: add support for the SRv6 End.DT4 behavior")
> > Fixes: 20a081b7984c ("seg6: add VRF support for SRv6 End.DT6 behavior")
> 
> We use fixes tags for bugs only, nothing seems broken here. It's more
> of a fool-proofing for the future.
> 

Ok, I got it.

> > 
> > diff --git a/include/uapi/linux/seg6_local.h b/include/uapi/linux/seg6_local.h
> > index 3b39ef1dbb46..81b3ac430670 100644
> > --- a/include/uapi/linux/seg6_local.h
> > +++ b/include/uapi/linux/seg6_local.h
> > @@ -27,9 +27,19 @@ enum {
> >  	SEG6_LOCAL_OIF,
> >  	SEG6_LOCAL_BPF,
> >  	SEG6_LOCAL_VRFTABLE,
> > +	/* new attributes go here */
> >  	__SEG6_LOCAL_MAX,
> > +
> > +	/* Support up to 64 different types of attributes.
> > +	 *
> > +	 * If you need to add a new attribute, please make sure that it DOES
> > +	 * NOT violate the constraint of having a maximum of 64 possible
> > +	 * attributes.
> > +	 */
> > +	__SEG6_LOCAL_MAX_SUPP = 64,
> 
> Let's not define this, especially in a uAPI header. No need to make
> promises on max attr id to user space.
> 

Ok.

>
> > +#define SEG6_F_ATTR(i) (((u64)1) << (i))
> 
> This wrapper looks useful, worth keeping.
> 

We can go ahead with the wrapper that will become as follows:

 #define SEG6_F_ATTR(i) BIT(i)

> > @@ -1692,6 +1694,15 @@ static const struct lwtunnel_encap_ops seg6_local_ops = {
> >  
> >  int __init seg6_local_init(void)
> >  {
> > +	/* If the max total number of defined attributes is reached, then your
> > +	 * kernel build stops here.
> > +	 *
> > +	 * This check is required to avoid arithmetic overflows when processing
> > +	 * behavior attributes and the maximum number of defined attributes
> > +	 * exceeds the allowed value.
> > +	 */
> > +	BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > SEG6_LOCAL_MAX_SUPP);
> 
> BUILD_BUG_ON(SEG6_LOCAL_MAX > 31)
> 

I agree with this approach. Only for the sake of clarity I would prefer to
define the macro SEG6_LOCAL_MAX_SUPP as follows:

in seg6_local.c:
 [...]

 /* max total number of supported SRv6 behavior attributes */
 #define SEG6_LOCAL_MAX_SUPP 32

 int __init seg6_local_init(void)
 {
    BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > SEG6_LOCAL_MAX_SUPP);
    [...]
 }


Due to the changes, I will submit a new patch (v1) with a more appropriate
subject. The title of the new patch will most likely be:

 seg6: fool-proof the processing of SRv6 behavior attributes


Thanks for your time,
Andrea
