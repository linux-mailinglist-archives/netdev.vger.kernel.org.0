Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DA62887A6
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 13:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388013AbgJILOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 07:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388001AbgJILOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 07:14:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9517A22269;
        Fri,  9 Oct 2020 11:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602242071;
        bh=G9vzUMWmPTENaCSSrT+4scPL8T/yGBTjMpUFtYd6Vxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bWAlSh8fDVuAw/5bkQmgw6LUbZC3WgWqOAEsSr+hEOg/6L3UCLOk+oEjFHUoUKQ5N
         /b5CpOf0TXNVPXBk14HcAurw7DUgsBtqMl7s5KaHtfVFoWI8E7lkpVQ+kz1gI0HKT2
         3eZztaubRPkrx3EnJ2GCchsXLYbEU52sFXG/MScY=
Date:   Fri, 9 Oct 2020 13:15:17 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Johannes Berg' <johannes@sipsolutions.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nstange@suse.de" <nstange@suse.de>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>
Subject: Re: [RFC] debugfs: protect against rmmod while files are open
Message-ID: <20201009111517.GA508813@kroah.com>
References: <4a58caee3b6b8975f4ff632bf6d2a6673788157d.camel@sipsolutions.net>
 <20201009124113.a723e46a677a.Ib6576679bb8db01eb34d3dce77c4c6899c28ce26@changeid>
 <2a333c2a50c676c461c1e2da5847dd4024099909.camel@sipsolutions.net>
 <8fe62082d9774a1fb21894c27e140318@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fe62082d9774a1fb21894c27e140318@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 10:56:16AM +0000, David Laight wrote:
> From: Johannes Berg
> > Sent: 09 October 2020 11:48
> > 
> > On Fri, 2020-10-09 at 12:41 +0200, Johannes Berg wrote:
> > 
> > > If the fops doesn't have a release method, we don't even need
> > > to keep a reference to the real_fops, we can just fops_put()
> > > them already in debugfs remove, and a later full_proxy_release()
> > > won't call anything anyway - this just crashed/UAFed because it
> > > used real_fops, not because there was actually a (now invalid)
> > > release() method.
> > 
> > I actually implemented something a bit better than what I described - we
> > never need a reference to the real_fops for the release method alone,
> > and that means if the release method is in the kernel image, rather than
> > a module, it can still be called.
> > 
> > That together should reduce the ~117 places you changed in the large
> > patchset to around a handful.
> 
> Is there an equivalent problem for normal cdev opens
> in any modules?

What does cdev have to do with debugfs?
