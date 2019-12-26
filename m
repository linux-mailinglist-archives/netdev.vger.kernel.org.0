Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40DA412A976
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 02:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfLZBFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 20:05:21 -0500
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:51970 "EHLO
        brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfLZBFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 20:05:21 -0500
Received: from dalias by brightrain.aerifal.cx with local (Exim 3.15 #2)
        id 1ikHaV-00036C-00; Thu, 26 Dec 2019 01:05:15 +0000
Date:   Wed, 25 Dec 2019 20:05:15 -0500
From:   Rich Felker <dalias@libc.org>
To:     David Miller <davem@davemloft.net>
Cc:     AWilcox@Wilcox-Tech.com, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, musl@lists.openwall.com
Subject: Re: [musl] Re: [PATCH] uapi: Prevent redefinition of struct iphdr
Message-ID: <20191226010515.GD30412@brightrain.aerifal.cx>
References: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
 <20191225.163411.1590483851343305623.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191225.163411.1590483851343305623.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 04:34:11PM -0800, David Miller wrote:
> From: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
> Date: Sun, 22 Dec 2019 00:02:27 -0600
> 
> > @@ -83,6 +83,13 @@
> >  
> >  #define IPV4_BEET_PHMAXLEN 8
> >  
> > +/* Allow libcs to deactivate this - musl has its own copy in <netinet/ip.h> */
> > +
> > +#ifndef __UAPI_DEF_IPHDR
> > +#define __UAPI_DEF_IPHDR	1
> > +#endif
> 
> How is this a musl-only problem?

I don't think it is, unless glibc's includes linux/ip.h to get the
definition, which does not seem to be the case -- at least not on the
Debian system I had handy to check on.

> I see that glibc also defines struct iphdr
> in netinet/ip.h, so why doesn't it also suffer from this?

Maybe it does.

> I find it really strange that this, therefore, only happens for musl
> and we haven't had thousands of reports of this conflict with glibc
> over the years.

It's possible that there's software that's including just one of the
headers conditional on __GLIBC__, and including both otherwise, or
something like that. Arguably this should be considered unsupported
usage; there are plenty of headers where that doesn't work and
shouldn't be expected to.

> I want an explanation, and suitably appropriate adjustments to the commit
> message and comments of this change.

Agreed. Commit messages should not imply that something is a
musl-specific workaround when it's generally the right thing to do.

Rich
