Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7D81AB473
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 01:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390397AbgDOXxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 19:53:46 -0400
Received: from smtp.netregistry.net ([202.124.241.204]:52420 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389935AbgDOXxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 19:53:43 -0400
Received: from pa49-197-17-107.pa.qld.optusnet.com.au ([49.197.17.107]:30228 helo=localhost)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1jOrqG-0001ig-Fx; Thu, 16 Apr 2020 09:53:39 +1000
Date:   Thu, 16 Apr 2020 09:53:14 +1000
From:   Russell Strong <russell@strong.id.au>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: vxlan mac address generation
Message-ID: <20200416095314.0a1dff38@strong.id.au>
In-Reply-To: <20200415102131.GA3145613@splinter>
References: <20200415100524.1ed7f9f9@strong.id.au>
        <20200414211206.40a324b4@hermes.lan>
        <20200415172800.50a3acc7@strong.id.au>
        <20200415102131.GA3145613@splinter>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Apr 2020 13:21:31 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> On Wed, Apr 15, 2020 at 05:28:00PM +1000, Russell Strong wrote:
> > I tried debian ( 4.19.0-8-amd64 ) and got the same result as you.
> > I am using Fedora 31 ( 5.5.15-200.fc31.x86_64 ).  I have discovered
> > a difference:
> > 
> > On fedora /sys/class/net/v0/addr_assign_type = 3
> > On debian /sys/class/net/v0/addr_assign_type = 1
> > 
> > The debian value is what I would expect (NET_ADDR_RANDOM).  I
> > thought addr_assign_type was controlled by the driver.  Do you
> > think this could be a Fedora bug, or perhaps something has changed
> > between 4.19 and 5.5?  
> 
> I assume you're using systemd 242 or later. I also hit this issue.
> Documented the solution here:
> 
> https://github.com/Mellanox/mlxsw/wiki/Persistent-Configuration#required-changes-to-macaddresspolicy

Thank you.  You have hit on the issue.

So for future googlers:

I was not using systemds' networking, I'm building my own embedded
router for radio and satellite networks, but because they have spilled
their functionality into udev as well, it can not be turned off without
modifying /usr/lib/systemd/network/99-default.link. This is not a
directory listed in the udev man page, and udev seems to be ignoring any
administrative overrides in /etc/udev/rules.d

I changed the line
MACAddressPolicy=persistent
to
MACAddressPolicy=none

The systemd requirement that implemented this says it all:

Keep MACPolicy=persistent. If people don't want it, they can always
apply local configuration, but in general stable MACs are a good thing.
I have never seen anyone complain about that.

Not the first time and won't be the last time systemd policy decisions
have caught me out.

Thanks again everyone,
Russell
