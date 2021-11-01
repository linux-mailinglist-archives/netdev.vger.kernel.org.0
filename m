Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71671441B50
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 13:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhKAMwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 08:52:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41274 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232505AbhKAMwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 08:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=59l5fz8I9WczWL5eaKsZO8emf4Mrkf3bs48s6jJYnlI=; b=bWtgbZYBgnghWE6ZfvjcsJHmO/
        DNkRmG0xcgccqKJSzLfaaBw9FoXb2HjU0kkebqsRPh4Z5tELSwmLKj/NBEyqjaH8e+MxmPl6VHpGF
        EZ9YTzWX8D/YrWB94Adnulsci1NeRm3hlxlWEZ9D1AA2TMK3FYJVZQFov2+D48IUbV5c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mhWlP-00CIoo-Ie; Mon, 01 Nov 2021 13:50:11 +0100
Date:   Mon, 1 Nov 2021 13:50:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/3] tsnep: Add TSN endpoint Ethernet MAC
 driver
Message-ID: <YX/igyj2u/Aen9za@lunn.ch>
References: <20211029200742.19605-1-gerhard@engleder-embedded.com>
 <20211029200742.19605-4-gerhard@engleder-embedded.com>
 <20211029212730.4742445b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANr-f5yBuKd0D4xppyRm+PUmLredFuGA=dM_BSQ9VkSPTfX2Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANr-f5yBuKd0D4xppyRm+PUmLredFuGA=dM_BSQ9VkSPTfX2Lw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> About endian: I have not considered endian so far, as this driver is used
> only for x86 and arm64. Is that ok?

In general, Linux drivers should work both endieannesses, unless the
hardware is embedded in the SoC and so it is physically impossible for
it to be used the other way. Somebody could connect your FPGA to a big
endian MIPs system.

In most cases, there is little you need to do, so long as you use the
correct methods to access the bus. PCI registers are always little
endian for example, so easy to handle. Memory mapped structures are
where you need to be careful, your receive and transmit descriptors.
You need to use the correct __le32 or __be32 annotation, and then
sparse will warn you if you access them without the needed conversion.

       Andrew
