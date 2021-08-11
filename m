Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C943E93BD
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhHKOgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:36:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232391AbhHKOgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u+OGBpgzBa8FBV8wLzAf0DvFVw5JlMQMj64MVlsCkcs=; b=JtrpVpuavK94hz2O2VRPzaFCu9
        gJQU9eVkONWNNpUkPYtpJ65dWbI1guhYmQnXBnDkIlced7XELPkxJX12Hi0PSzL8SXicavi/oWaKC
        D1DqR7LDVaD07Zx1wHkI7ocTbBxQ8EVWUuUE+jZRMcAKQvQDuPLz1shhJ0ANN1TT3mFw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDpL3-00H87k-Mh; Wed, 11 Aug 2021 16:36:13 +0200
Date:   Wed, 11 Aug 2021 16:36:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRPgXWKZ2e88J1sn@lunn.ch>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org>
 <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder>
 <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder>
 <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRO1ck4HYWTH+74S@shredder>
 <20210811060343.014724e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811060343.014724e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 06:03:43AM -0700, Jakub Kicinski wrote:
> On Wed, 11 Aug 2021 14:33:06 +0300 Ido Schimmel wrote:
> > # ethtool --set-module swp13 low-power on
> > 
> > $ ethtool --show-module swp13
> > Module parameters for swp13:
> > low-power true
> > 
> > # ip link set dev swp13 up
> > 
> > $ ip link show dev swp13
> > 127: swp13: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
> >     link/ether 1c:34:da:18:55:49 brd ff:ff:ff:ff:ff:ff
> > 
> > $ ip link show dev swp14
> > 128: swp14: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN mode DEFAULT group default qlen 1000
> >     link/ether 1c:34:da:18:55:4d brd ff:ff:ff:ff:ff:ff
> 
> Oh, so if we set low-power true the carrier will never show up?
> I thought Andrew suggested the setting is only taken into account 
> when netdev is down.

Yes, that was my intention. If this low power mode also applies when
the interface is admin up, it sounds like a foot gun. ip link show
gives you no idea why the carrier is down, and people will assume the
cable or peer is broken. We at least need a new flag, LOWER_DISABLED
or similar to give the poor user some chance to figure out what is
going on.

To me, this setting should only apply when the link is admin down.

	Andrew
