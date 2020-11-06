Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC07A2A9B05
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgKFRmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:42:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgKFRmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 12:42:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D88C22151B;
        Fri,  6 Nov 2020 17:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604684534;
        bh=wDORNc7neaoH3OAQp1VgS3dN/sSdIr5ZilBgBTWr5Ys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G/OzjF42cI005lHaWfy8FRhSRku9E39/E1sBYnc9ZMVe12c6xT2XxoJRLvBkdDHs0
         b8qVcpx+kCDbaqL+tZ5bIN5JZFkh6iC0MwIODpLXcmTj/nTxa1VC/Sc4/7lGCast0i
         1NZeep6TyCrFVhBrI9fyQq+miZhcLJ0wANE6jrSA=
Date:   Fri, 6 Nov 2020 09:42:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        "Lee Jones" <lee.jones@linaro.org>
Subject: Re: [PATCH net-next v2 1/7] drivers: net: smc91x: Fix set but
 unused W=1 warning
Message-ID: <20201106094213.62250632@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <749857e283f04d3b8f84f603fa065cd6@AcuMS.aculab.com>
References: <20201104154858.1247725-1-andrew@lunn.ch>
        <20201104154858.1247725-2-andrew@lunn.ch>
        <20201105143742.047959ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <749857e283f04d3b8f84f603fa065cd6@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 08:48:47 +0000 David Laight wrote:
> > > +#define SMC_GET_PKT_HDR_STATUS(lp, status)				\
> > > +	do {								\
> > > +		if (SMC_32BIT(lp)) {					\
> > > +			unsigned int __val = SMC_inl(ioaddr, DATA_REG(lp)); \
> > > +			(status) = __val & 0xffff;			\
> > > +		} else {						\
> > > +			(status) = SMC_inw(ioaddr, DATA_REG(lp));	\
> > > +		}							\
> > > +	} while (0)  
> > 
> > This is the original/full macro:
> > 
> > #define SMC_GET_PKT_HDR(lp, status, length)				\
> > 	do {								\
> > 		if (SMC_32BIT(lp)) {				\
> > 			unsigned int __val = SMC_inl(ioaddr, DATA_REG(lp)); \
> > 			(status) = __val & 0xffff;			\
> > 			(length) = __val >> 16;				\
> > 		} else {						\
> > 			(status) = SMC_inw(ioaddr, DATA_REG(lp));	\
> > 			(length) = SMC_inw(ioaddr, DATA_REG(lp));	\
> > 		}							\
> > 	} while (0)
> > 
> > Note that it reads the same address twice in the else branch.
> > 
> > I'm 90% sure we can't remove the read here either so best treat it
> > like the ones in patch 3, right?  
> 
> One of the two SMC_inw() needs to use 'ioaddr + 2'.
> Probably the one for (length).
> 
> The code may also be buggy on BE systems.

More proof that this code is fragile.

Changing IO accesses is not acceptable in a "warning cleanup" patch,
unless it can be tested on real HW.

We can follow up on the issues you see separately, please.
