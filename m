Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A06539F11C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhFHImT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFHImS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 04:42:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0B16124B;
        Tue,  8 Jun 2021 08:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623141615;
        bh=zu0mD/DCPaOiV8rNB2RIkPmxKfuEWzRmByAErxuC04Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gOedb4xj4EXi+eFCQEhKg2uYtRujg5oUQbl4HadFbFatQ9UbjKWNMUnUju7ElzcJb
         DhxmcZId8qNy4RSKsqe7BONqaQcqfVZ6js6Kl2NiUYbfUGS+Yd6OFAQzkqObXZu6Lg
         cKZ5FhLB6OA2REykd3F4xRaXrhl8JG1KoMbtXZlU=
Date:   Tue, 8 Jun 2021 10:40:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Leon Romanovsky <leon@kernel.org>, SyzScope <syzscope@gmail.com>,
        davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <YL8s7F1pPEw6Oc5s@kroah.com>
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
 <YLn24sFxJqGDNBii@kroah.com>
 <0f489a64-f080-2f89-6e4a-d066aeaea519@gmail.com>
 <YLsrLz7otkQAkIN7@kroah.com>
 <20210606085004.12212-1-hdanton@sina.com>
 <20210607074828.3259-1-hdanton@sina.com>
 <20210607100201.3345-1-hdanton@sina.com>
 <20210608081800.3484-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608081800.3484-1-hdanton@sina.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 04:18:00PM +0800, Hillf Danton wrote:
> On Mon, 7 Jun 2021 12:31:39 +0200 Greg KH wrote:
> >On Mon, Jun 07, 2021 at 06:02:01PM +0800, Hillf Danton wrote:
> >> After taking another look at the added user track, I realised that it serves
> >> no more than a one-off state word that prevents channel from being released.
> >> Then the race behind the uaf can be fixed by adding a state on top of the
> >> dryrun introduced even without tracking users.
> >> 
> >> The state machine works as the following,
> >> 1) it is initialised to be backoff that means channel cannot be released
> >>    at the moment.
> >> 2) it is changed to be dryrun on releasing to cut the race that survived
> >>    backoff.
> >> 3) it is finally set to zero for release after cutting the chance for race.
> >
> >Adding another state on top of this feels rough, does it really solve
> >the race here?
> 
> No, frankly, given the list_del_rcu() in hci_chan_del().
> 
> >Normally a reference count should be enough to properly
> >tear things down when needed, rolling back from a "can I try this now"
> >state still seems racy without the needed lock somewhere.
> 
> The rollback is added only for making sure that the channel released in
> l2cap_conn_del() would not be freed in the other pathes. That exclusiveness
> adds more barriers than thought to fixing the rare race with kref and spinlock
> in the usual and simple manner.
> 
> If OTOH channel is created with the exclusiveness taken into account by adding
> the exclusive create and delete methods for l2cap, then the race can be fixed
> by checking the exclusive mark in addition to aquiring the hdev lock at release
> time.

One would think that the state machine for the channel would fix this
whole mess, why do we need an "additional" state here in the first
place?

Would be nice if one of the bluetooth maintainers weighed in on this...

thanks,

greg k-h
