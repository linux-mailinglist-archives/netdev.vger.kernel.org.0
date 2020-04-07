Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2EB1A0F4C
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 16:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgDGOdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 10:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728975AbgDGOdJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 10:33:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AC342072A;
        Tue,  7 Apr 2020 14:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586269989;
        bh=cminWrIgkRVEhjmai3BMkPP+WLA37jmwDe9yEHcu7Tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T+mc3+rDHQN+IacAd+EmpTdDH2QE8aO0VMBd8RUfIZg7lMPcTqAmayi+OoDlmf724
         ep5Duhdvj2XzEEsxx/jN5ENw5LdRt5/mEw/XJjh/e8Wnk+8niv71ZpkDUjqXuE+iWc
         A9g/3oTOEG6F6VMW6AuzVTUNvoovPNd8kqkKV2DE=
Date:   Tue, 7 Apr 2020 16:33:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        syzbot <syzbot+9627a92b1f9262d5d30c@syzkaller.appspotmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Rafael Wysocki <rafael@kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING in ib_umad_kill_port
Message-ID: <20200407143304.GA876345@kroah.com>
References: <00000000000075245205a2997f68@google.com>
 <20200406172151.GJ80989@unreal>
 <20200406174440.GR20941@ziepe.ca>
 <CACT4Y+Zv_WXEn6u5a6kRZpkDJnSzeGF1L7JMw4g85TLEgAM7Lw@mail.gmail.com>
 <20200407115548.GU20941@ziepe.ca>
 <CACT4Y+Zy0LwpHkTMTtb08ojOxuEUFo1Z7wkMCYSVCvsVDcxayw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Zy0LwpHkTMTtb08ojOxuEUFo1Z7wkMCYSVCvsVDcxayw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 02:39:42PM +0200, Dmitry Vyukov wrote:
> On Tue, Apr 7, 2020 at 1:55 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Tue, Apr 07, 2020 at 11:56:30AM +0200, Dmitry Vyukov wrote:
> > > > I'm not sure what could be done wrong here to elicit this:
> > > >
> > > >  sysfs group 'power' not found for kobject 'umad1'
> > > >
> > > > ??
> > > >
> > > > I've seen another similar sysfs related trigger that we couldn't
> > > > figure out.
> > > >
> > > > Hard to investigate without a reproducer.
> > >
> > > Based on all of the sysfs-related bugs I've seen, my bet would be on
> > > some races. E.g. one thread registers devices, while another
> > > unregisters these.
> >
> > I did check that the naming is ordered right, at least we won't be
> > concurrently creating and destroying umadX sysfs of the same names.
> >
> > I'm also fairly sure we can't be destroying the parent at the same
> > time as this child.
> >
> > Do you see the above commonly? Could it be some driver core thing? Or
> > is it more likely something wrong in umad?
> 
> Mmmm... I can't say, I am looking at some bugs very briefly. I've
> noticed that sysfs comes up periodically (or was it some other similar
> fs?). General observation is that code frequently assumes only the
> happy scenario and only, say, a single administrator doing one thing
> at a time, slowly and carefully, and it is not really hardened against
> armies of monkeys.
> But I did not look at code abstractions, bug patterns, contracts, etc.
> 
> Greg KH may know better. Greg, as far as I remember you commented on
> some of these reports along the lines of, for example, "the warning is
> in sysfs code, but the bug is in the callers".

Yes, that is correct.

