Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D82047A646
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 09:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbhLTIx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 03:53:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234623AbhLTIxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 03:53:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=b+6xKrg6vSboIYypCIRjdq4sXhhRrZhMc1QRBVXRq5Y=; b=33iRf9eWVwIriO2ZeU2SMWQlO+
        lK5qsdG/3ojD1CwSQk4BSoVFGO/p96bioJoYAl55qFAzF39zjklPadqdGqdIEopffQgswMcAYmyac
        kWUTXoDKu+jIoZR+KUxtEQySb9PhOSZNRTF1uhdB2f/Bi4hVQZGzvfdj7iK/RoluqtU4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzEQ4-00H1g2-J7; Mon, 20 Dec 2021 09:53:20 +0100
Date:   Mon, 20 Dec 2021 09:53:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gabriel Hojda <ghojda@yo2urs.ro>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Issues with smsc95xx driver since a049a30fc27c
Message-ID: <YcBEgE589cf5DhJd@lunn.ch>
References: <199eebbd6b97f52b9119c9fa4fd8504f8a34de18.camel@collabora.com>
 <Yb4QFDQ0rFfFsT+Y@lunn.ch>
 <36f765d8450ba08cb3f8aecab0cadd89@yo2urs.ro>
 <Yb4m3xms1zMf5C3T@lunn.ch>
 <Yb4pTu3FtkGPPpzb@lunn.ch>
 <c95954ec12dfcf8877c1bf92047c0268@yo2urs.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c95954ec12dfcf8877c1bf92047c0268@yo2urs.ro>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> # ip link set eth0 up
> # ip link show eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP
> mode DEFAULT group default qlen 1000
>     link/ether ee:f1:a8:e7:0c:8f brd ff:ff:ff:ff:ff:ff
> 
> ... now link is up with the same mac address
> 
> # ifconfig eth0
> eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>         inet6 2a02:2f09:3d09:1b00:ecf1:a8ff:fee7:c8f  prefixlen 64  scopeid
> 0x0<global>
>         inet6 fe80::ecf1:a8ff:fee7:c8f  prefixlen 64  scopeid 0x20<link>
>         inet6 fd00:cafe::c772:d58f:1061:4df3  prefixlen 64  scopeid
> 0x0<global>
>         inet6 fd00:cafe::ecf1:a8ff:fee7:c8f  prefixlen 64  scopeid
> 0x0<global>
>         inet6 2a02:2f09:3d09:1b00:eef4:bb1d:f9d5:febc  prefixlen 64  scopeid
> 0x0<global>

These make use of multicast. Router Advertisements are multicast, both
at L2 and L3, by the router to the Internet.

> # ping -6 -c 10 ipv6.l.google.com
> PING ipv6.l.google.com(ipv6.l.google.com (2a00:1450:400d:806::200e)) 56 data
> bytes
> From odroid (2a02:2f09:3d09:1b00:eef4:bb1d:f9d5:febc) icmp_seq=1 Destination
> unreachable: Address unreachable
> ...
> --- ipv6.l.google.com ping statistics ---
> 10 packets transmitted, 0 received, +7 errors, 100% packet loss, time 9311ms

ping uses unicast.

> ... neither does it work for my local router, so network layer 3 does not
> seem to work

I think it is still pointing towards L2 unicast.

> next, when i have time and if there's still no progress, i think i should
> try to insert:
> 
>         ret = smsc95xx_reset(dev);
> 	if (ret)
> 		goto free_pdata;
> 
> before
> 
> 	ret = phy_connect_direct(dev->net, pdata->phydev,
> 				 &smsc95xx_handle_link_change,
> 				 PHY_INTERFACE_MODE_MII);
> 
> in smsc95xx_bind() to try to emulate the old behavior for the first call to
> start_phy().

Yes, that will be in interesting experiment. Something in
smsc95xx_reset() is required.

	Andrew
