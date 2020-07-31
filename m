Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C7B233F9F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbgGaHAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731628AbgGaHAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 03:00:34 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 368BA207F5;
        Fri, 31 Jul 2020 07:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596178833;
        bh=qjwGoIyl/wBff+iYMlZWx9H6G4svCrkKR/WF1d5EkDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VNADuhxWnvWY3HlDYEqwJOC2grlnuHBoTybqGmuHW2dHkFl33dnqSNHyLA5NnBiCS
         SznzbcsXaju719ksD8EHEj9EUzSR87MTzfi9mMLb/2m2jqv6tM+42guU0Am/Iev5Vp
         UrdN4yUeMTOR1AJlgj+7/HAFxem1vSHfmSmby0m8=
Date:   Fri, 31 Jul 2020 10:00:30 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200731070030.GJ75549@unreal>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
 <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com>
 <CAHp75Vdr2HC_ogNhBCxxGut9=Z6pQMFiA0w-268OQv+5unYOTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vdr2HC_ogNhBCxxGut9=Z6pQMFiA0w-268OQv+5unYOTg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 09:29:27AM +0300, Andy Shevchenko wrote:
> On Friday, July 31, 2020, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> wrote:
>
> > On Fri, Jul 31, 2020 at 07:33:06AM +0200, Greg Kroah-Hartman wrote:
> > > On Fri, Jul 31, 2020 at 07:53:01AM +0300, Leon Romanovsky wrote:
> > > > On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:
> > > > > rds_notify_queue_get() is potentially copying uninitialized kernel
> > stack
> > > > > memory to userspace since the compiler may leave a 4-byte hole at
> > the end
> > > > > of `cmsg`.
> > > > >
> > > > > In 2016 we tried to fix this issue by doing `= { 0 };` on `cmsg`,
> > which
> > > > > unfortunately does not always initialize that 4-byte hole. Fix it by
> > using
> > > > > memset() instead.
> > > >
> > > > Of course, this is the difference between "{ 0 }" and "{}"
> > initializations.
> > >
> > > Really?  Neither will handle structures with holes in it, try it and
> > > see.
>
>
> {} is a GCC extension, but I never thought it works differently.

Yes, this is GCC extension and kernel relies on them very heavily.

Thanks

>
>
>
> >
> > And if true, where in the C spec does it say that?
> >
> > thanks,
> >
> > greg k-h
> >
>
>
> --
> With Best Regards,
> Andy Shevchenko
