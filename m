Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF5727D513
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgI2RxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgI2RxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 13:53:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08E9C061755;
        Tue, 29 Sep 2020 10:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EgLj5hBKCRRvi/jIx9GE19koP6614RQSBYAhIUkeExM=; b=OcDBYNylpQAznL+Wv6hdoNYtyw
        JP2fHtvHTaxif8vXslOLhnqIz1vXISUG4MWoy40A4DW41SDQy1MXWbbVhHRyyZjGy2bYxdkjnTYKA
        syYWMgKCiCRtTKh5u1KovMtTO+EPazCucYMLkW/H7dVcP65rdmhPKl5vNhy96pHLog0dfMbFxtx7U
        R7w9WCs0xnr3v1LdeU1G/Rvpyq6IryN4GKnd6EtUDgRN06emyEvAjatPJEN6B/aTpYi+h14VUCf1L
        R0GRbTB99f6imrQw2L7BLHpxCkkkuykWkMQ72pNCHRgMmXUjpi7EmstJb7wbzV/ejDkLymikeGfiJ
        EkWGrv/w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kNJo7-0000iA-4P; Tue, 29 Sep 2020 17:52:55 +0000
Date:   Tue, 29 Sep 2020 18:52:55 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jens Axboe <axboe@kernel.dk>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] dev_ioctl: split out SIOC?IFMAP ioctls
Message-ID: <20200929175255.GA2330@infradead.org>
References: <20200918120536.1464804-1-arnd@arndb.de>
 <20200918120536.1464804-2-arnd@arndb.de>
 <20200919054831.GN30063@infradead.org>
 <CAK8P3a0ht1c34K+4k3XxGvWA9cxWJSMNzQR2iYMcm98guMsj1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0ht1c34K+4k3XxGvWA9cxWJSMNzQR2iYMcm98guMsj1A@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 02:28:29PM +0200, Arnd Bergmann wrote:
> > > +++ b/include/uapi/linux/if.h
> > > @@ -247,7 +247,13 @@ struct ifreq {
> > >               short   ifru_flags;
> > >               int     ifru_ivalue;
> > >               int     ifru_mtu;
> > > +#ifndef __KERNEL__
> > > +             /*
> > > +              * ifru_map is rarely used but causes the incompatibility
> > > +              * between native and compat mode.
> > > +              */
> > >               struct  ifmap ifru_map;
> > > +#endif
> >
> > Do we need a way to verify that this never changes the struct size?
> 
> Not sure which way you would want to check. The point of the patch
> is that it does change the struct size inside of the kernel but not
> in user space.
>
> Do you mean we should check that the (larger) user space size
> remains what it is for future changes, or that the (smaller)
> kernel size remains the same on all kernels, or maybe both?

I had something like:

	BUILD_BUG_ON(sizeof(struct ifmap) >
		     sizeof(struct ifreq) - IFNAMSIZ);

plus a suitable comment in mind.
