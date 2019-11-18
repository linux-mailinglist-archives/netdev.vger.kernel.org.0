Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62712FFCD7
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 02:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfKRB31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 20:29:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfKRB31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 20:29:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=68MdGxmDO19V+eLUaXTmCXn6d6UTQ9ivYg48u6u/xB4=; b=4+qbuS2doVzhVqwtM8TAbR1M9e
        H+FPrM05gL1I/IU8ftYOHuLXIDLbDc/YmnxE4MwXR4sxoPZ6crqc5WVe88IiVNL4ZlfSiQ3oZMHpU
        UheQzGzKFqXVrH8vs2hT+DIIn6Bova34QOsJBvPyCbuMKQQRItXGF9FMqlNHlI2njDj8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iWVr2-00025Q-Tm; Mon, 18 Nov 2019 02:29:24 +0100
Date:   Mon, 18 Nov 2019 02:29:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shay Drory <shayd@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "lennart@poettering.net" <lennart@poettering.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: Send SFP event from kernel driver to user space (UDEV)
Message-ID: <20191118012924.GC4084@lunn.ch>
References: <a041bba0-83d1-331f-d263-c8cbb0509220@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a041bba0-83d1-331f-d263-c8cbb0509220@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 17, 2019 at 11:46:15AM +0000, Shay Drory wrote:

Hi Shay

It would be good to Cc: the generic SFP code maintainers.

> Today, SFP inserted / removal event impacts only the kernel space drivers.
> There are users who wishes to get SFP insert / removal in a udev-event
> format for their application / daemons / monitors.
> The naive way to implement this feature would be to create a sysfs file
> that represents device SFP, to expose it under the netdev sysfs, and
> to raise a udev event over it.
> However, it is not reasonable to create a sysfs for each net-device.
> In this letter, I would like to offer a new mechanism that will add a
> support to send SFP events from the kernel driver to user space.
> This suggestion is built upon a new netlink infrastructure for ethtool
> currently being written by Michal Kubeckwhich called “ethtool-netlink”[1].

So you are in no rush to make use of this? ethtool-nl seems to be
making very slow progress.

> My suggestion is to do it by adding a function
> (ethtool_sfp_insterted/removed(...)) to ethtool API, This function will
> raise a netlink event to be caught in user space.

What about the case of the SFP is inserted before the SFP is
associated to a netdev? Similarly, the SFP is ejected when the SFP is
not connected to a MAC. You don't have a netdev, so you cannot send an
event. And SFF, which are never inserted or removed? SFPs have a
different life cycle to a netdev. Do you care about this?

> The design:
> 
> - SFP event from NIC caught by the driver
> - Driver call ethtool_sfp_inserted/removed()
> - Ethtool generated netlink event with relevant data
> - This event-message will be handled in the user-space library of UDEV
> (for this purpose we would like to add a netlink infrastructure to UDEV
> user-space library).

Would you add just SFP insert/eject to UDEV. Or all the events which
get sent via netlink? Link up/down, route add/remove, etc?

What sort of daemon is this anyway? Most networking daemons already
have the code to listen to netlink events. So why complicate things by
using UDEV?

Is UDEV name space aware? Do you run a udev daemon in each network
name space? I assume when you open a netlink socket, it is for just
the current network namespace?

    Andrew
