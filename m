Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EA786D97
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 01:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404726AbfHHXD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 19:03:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45982 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731914AbfHHXDZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 19:03:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0qysza0t5x4YnR1J1GnXkteIKUHwo96QeVpN+I6T7gg=; b=o0rmPI6ayeZn/8BYyfgQ7TOORf
        f1n13nWBm6NtHgZsZnaqWz2QwjG8/qqWGYrbUOmoUcIcTjc8at5i+H3MC9LaRnHzI1ffi7xx1HW6R
        wi0JRvV9m6/A05EApxOHCp6klE5322C0XdtsRr9Q9dSPZ4S6o1+My1Tu6v/W+BwGugec=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvrRA-0006fc-TS; Fri, 09 Aug 2019 01:03:12 +0200
Date:   Fri, 9 Aug 2019 01:03:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tao Ren <taoren@fb.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        William Kennington <wak@google.com>
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Message-ID: <20190808230312.GS27917@lunn.ch>
References: <20190807002118.164360-1-taoren@fb.com>
 <20190807112518.644a21a2@cakuba.netronome.com>
 <20190807184143.GE26047@lunn.ch>
 <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
 <20190808133209.GB32706@lunn.ch>
 <77762b10-b8e7-b8a4-3fc0-e901707a1d54@fb.com>
 <20190808211629.GQ27917@lunn.ch>
 <ac22bbe0-36ca-b4b9-7ea7-7b1741c2070d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac22bbe0-36ca-b4b9-7ea7-7b1741c2070d@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> After giving it more thought, I'm thinking about adding ncsi dt node
> with following structure (mac/ncsi similar to mac/mdio/phy):
> 
> &mac0 {
>     /* MAC properties... */
> 
>     use-ncsi;

This property seems to be specific to Faraday FTGMAC100. Are you going
to make it more generic? 

>     ncsi {
>         /* ncsi level properties if any */
> 
>         package@0 {

You should get Rob Herring involved. This is not really describing
hardware, so it might get rejected by the device tree maintainer.

> 1) mac driver doesn't need to parse "mac-offset" stuff: these
> ncsi-network-controller specific settings should be parsed in ncsi
> stack.

> 2) get_bmc_mac_address command is a channel specific command, and
> technically people can configure different offset/formula for
> different channels.

Does that mean the NCSA code puts the interface into promiscuous mode?
Or at least adds these unicast MAC addresses to the MAC receive
filter? Humm, ftgmac100 only seems to support multicast address
filtering, not unicast filters, so it must be using promisc mode, if
you expect to receive frames using this MAC address.

	   Andrew
