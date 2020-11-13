Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EFB2B1370
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgKMApF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMApD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 19:45:03 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7280F20B80;
        Fri, 13 Nov 2020 00:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605228303;
        bh=LH8XKateJ4hjA1AHIduUuCUKiP7srBwXHGzlVRgxHIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yy1zB8beYfZvC4+msMxv6CMPi9hzpAuMeMupPFgUJIcmqwpT9Dp8DiFR1eDiY5YYG
         Kv+la8A7hr+TMHAGUqeOds+txu3tkO5kNON/G++eWSp3qZRPypmpKkTYMCOMcxAf6X
         sgu9QjXWG8HsswRDzuQw1wwxa2B3JSJQwcnZMeaQ=
Date:   Thu, 12 Nov 2020 16:44:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Markus =?UTF-8?B?QmzDtmNobA==?= <markus.bloechl@ipetronik.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201112164457.6af0fbaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
        <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 07:43:41 -0800 Jakub Kicinski wrote:
> >     In order to receive those tagged frames it is necessary to manually disable
> >     rx vlan filtering using ethtool ( `ethtool -K ethX rx-vlan-filter off` or
> >     corresponding ioctls ). Setting all bits in the vlan filter table to 1 is
> >     an even worse approach, imho.
> > 
> >     As a user I would probably expect that setting IFF_PROMISC should be enough
> >     in all cases to receive all valid traffic.
> >     Therefore I think this behaviour is a bug in the driver, since other
> >     drivers (notably ixgbe) automatically disable rx-vlan-filter when
> >     IFF_PROMISC is set. Please correct me if I am wrong here.  
> 
> I've been mulling over this, I'm not 100% sure that disabling VLAN
> filters on promisc is indeed the right thing to do. The ixgbe doing
> this is somewhat convincing. OTOH users would not expect flow filters
> to get disabled when promisc is on, so why disable vlan filters?
> 
> Either way we should either document this as an expected behavior or
> make the core clear the features automatically rather than force
> drivers to worry about it.
> 
> Does anyone else have an opinion, please?

Okay, I feel convinced that we should indeed let all vlan traffic thru,
thanks everyone! :)

Markus could you try to come up with a patch for the net/core/dev.c
handling which would clear NETIF_F_HW_VLAN_CTAG_FILTER and
NETIF_F_HW_VLAN_STAG_FILTER automatically so the drivers don't have 
to worry?

Whatever the driver chooses to do to disable vlan filtering is a
separate discussion AFAICT.
