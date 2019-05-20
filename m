Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58FF824244
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 22:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfETUx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 16:53:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:38070 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbfETUx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 16:53:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 898E2AD70;
        Mon, 20 May 2019 20:53:58 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 15675E0184; Mon, 20 May 2019 22:53:58 +0200 (CEST)
Date:   Mon, 20 May 2019 22:53:58 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     "M. Buecher" <maddes+kernel@maddes.net>,
        Matthias May <matthias.may@neratec.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: IP-Aliasing for IPv6?
Message-ID: <20190520205358.GB25473@unicorn.suse.cz>
References: <5c3590c1568251d0f92b61138b7a7f10@maddes.net>
 <20190515092618.GI22349@unicorn.suse.cz>
 <d10e40ae062903f15e84c7e3890a0b40@maddes.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d10e40ae062903f15e84c7e3890a0b40@maddes.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 10:23:03PM +0200, M. Buecher wrote:
> Used feature is the label option of `ip`, which works for IPv4, but not with
> IPv6.

The only reason for having these labels is to allow old tools like
ifconfig to partially work even if the underlying implementation
changed. There is no need for labels with IPv6 as even ifconfig (and the
ioctl interface it uses) does not pretend there are virtual interfaces
and 1:1 mapping between interfaces and addresses and usess add/remove to
add or remove addresses to/from the list.

> Goal: Use virtual interfaces to run separate instances of a service on
> different IP addresses on the same machine.
> For example with dnsmasq I use `-interface ens192` for the normal main
> instance, while using `-interface ens192:0` and `-interfaces ens192:1` for
> special instances only assigned to specific machines via their MAC
> addresses.

Configuration syntax based on "listening on an interface" is in most
cases a historical relic because  this "interface" is just used to get
the address the daemon is to listen on (bind the listening socket to).
Most daemons support also identifying the listening address(es) directly
which should be preferred as then your configuration matches what the
daemon is actually doing. (There are exceptions, e.g. "ping -I eth1"
does something different than "ping -I 1.2.3.4" but these are rather
rare.) Any daemon supporting IPv6 should definitely support setting the
listening address(es) directly.

> What is the correct name when I use the label option of the ip command?
> The "IP-Aliasing" doc was the only one I could find on kernel.org that fit
> the way labels are assigned with ip.

They are just labels. The term "IP aliasing" denotes the older
implementation in 2.0 kernels where there were actual virtual
interfaces, allowing you to assign the extra addresses to them. Since
kernel 2.2, it's no longer the case, there is just the actual interface
and it has a list of IPv4 addresses.

                                                         Michal Kubecek
