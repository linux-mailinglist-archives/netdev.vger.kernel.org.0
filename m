Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D7A12E015
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 19:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgAAS3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 13:29:43 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41006 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbgAAS3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 13:29:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VzTEGUiG26m4IPXQov3Kr211cp49Tm2n/Y5QNBshkGs=; b=CpwPdyJg3nkVXnq37F5+PDEi8
        7VbFXxGofUxbbGtjOUF4O8M/22X+dZ5DaFMjQlCdAEGkekuykFmsLW6kDh7M/OXOyJbpzcx+hphGU
        PqsuqsiTrNMgDP7ysZJf4vWN1NGGfPjUCe+FLQV+g9mZ9R0m+22IQztQ1nQwGdaBLe8dqpCj/L92a
        LadBM4vLGWI6mQNUe6WNqR8RMLZK4fnhB0XjR6ZgVvp83dEpCiku3hU50uU0n4Jo2Zq/rm2vO1zLq
        0Nwet+AaM4Ua8qRjzI4SHakZcAZu2GHnPCOHN2Rk2uglcp33Wu+cq7M2viAnUjHtWC1KNYCKYxIyp
        R+4FT9B3Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:56758)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1imikQ-00082F-Sn; Wed, 01 Jan 2020 18:29:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1imikN-0001MK-Lv; Wed, 01 Jan 2020 18:29:31 +0000
Date:   Wed, 1 Jan 2020 18:29:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200101182931.GA25745@shell.armlinux.org.uk>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <20191231161020.stzil224ziyduepd@pali>
 <20191231180614.GA120120@splinter>
 <20200101011027.gpxnbq57wp6mwzjk@pali>
 <20200101173014.GZ25745@shell.armlinux.org.uk>
 <20200101180727.ldqu4rsuucjimem5@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200101180727.ldqu4rsuucjimem5@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 01, 2020 at 07:07:27PM +0100, Pali Rohár wrote:
> On Wednesday 01 January 2020 17:30:14 Russell King - ARM Linux admin wrote:
> > I think the most important thing to do if you're suffering problems
> > like this is to monitor and analyse packets being received from the
> > DSA switch on the host interface:
> > 
> > # tcpdump -enXXi $host_dsa_interface
> 
> Hello Russell! Main dsa interface for me is eth0 and it does not see any
> incoming vlan tagged packets. (Except that sometimes for those 5 minutes
> periods it sometimes see them. And when tcpdump saw them also they
> arrived to userspace.)

I think having Vivien's debugfs patch would be really useful to take
this further forward. This patch provides direct access to the atu
(address translation unit) entries, vtu (vlan translation unit)
entries and all the device registers. The atu takes a long time to
dump.

It also allows for some experimentation, by writing these files,
entries can be added to or removed from the translation units, and
registers written.

I think dumping the on-chip ATU contents with it in the "working"
state and the "non-working" state may be revealing.

I'm afraid that I couldn't tell you where to get Vivien's debugfs
patch from; I'm using an old version that I've ported forward to
subsequent kernels - probably much like anyone else who gets their
hands dirty with Marvell DSA hacking.  Vivien's copied on this
thread already, so might chime in...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
