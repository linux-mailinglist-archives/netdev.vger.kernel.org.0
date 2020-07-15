Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F46221727
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGOVk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgGOVk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 17:40:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F7C9205CB;
        Wed, 15 Jul 2020 21:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594849227;
        bh=pTGMvpWO4qBv0WekCapu47P+G88DdYFxoAxgWCYoJTk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YbmZAOhs6SRL6UBtWoE5qPSMGJY02lQRbnyEswaK2fC8wlAPT6P05o/Z+x3I24Xo4
         7hWbaQ6pElTAY3Nj6SK44ywoNCYzOdnuQLLkRXlGVBGpOzBCGys6C8oSRM3jelTqr0
         RQ7HqdTFMk2DrWILvTfi5Q7xbhcVZvRf8iIfP9Ao=
Date:   Wed, 15 Jul 2020 14:40:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ian Kumlien <ian.kumlien@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Subject: Re: NAT performance issue 944mbit -> ~40mbit
Message-ID: <20200715144017.47d06941@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAA85sZtjCW2Yg+tXPgYyoFA5BKAVZC8kVKG=6SiR64c8ur8UcQ@mail.gmail.com>
References: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
        <CAA85sZua6Q8UR7TfCGO0bV=VU0gKtqj-8o_mqH38RpKrwYZGtg@mail.gmail.com>
        <20200715133136.5f63360c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAA85sZu09Z4gydJ8rAO_Ey0zqx-8Lg28=fBJ=FxFnp6cetNd3g@mail.gmail.com>
        <CAA85sZtjCW2Yg+tXPgYyoFA5BKAVZC8kVKG=6SiR64c8ur8UcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 23:12:23 +0200 Ian Kumlien wrote:
> On Wed, Jul 15, 2020 at 11:02 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > On Wed, Jul 15, 2020 at 10:31 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > On Wed, 15 Jul 2020 22:05:58 +0200 Ian Kumlien wrote:  
> > > > After a  lot of debugging it turns out that the bug is in igb...
> > > >
> > > > driver: igb
> > > > version: 5.6.0-k
> > > > firmware-version:  0. 6-1
> > > >
> > > > 03:00.0 Ethernet controller: Intel Corporation I211 Gigabit Network
> > > > Connection (rev 03)  
> > >
> > > Unclear to me what you're actually reporting. Is this a regression
> > > after a kernel upgrade? Compared to no NAT?  
> >
> > It only happens on "internet links"
> >
> > Lets say that A is client with ibg driver, B is a firewall running NAT
> > with ixgbe drivers, C is another local node with igb and
> > D is a remote node with a bridge backed by a bnx2 interface.
> >
> > A -> B -> C is ok (B and C is on the same switch)
> >
> > A -> B -> D -- 32-40mbit
> >
> > B -> D 944 mbit
> > C -> D 944 mbit
> >
> > A' -> D ~933 mbit (A with realtek nic -- also link is not idle atm)  
> 
> This should of course be A' -> B -> D
> 
> Sorry, I've been scratching my head for about a week...

Hm, only thing that comes to mind if A' works reliably and A doesn't is
that A has somehow broken TCP offloads. Could you try disabling things
via ethtool -K and see if those settings make a difference?
