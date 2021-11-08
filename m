Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2942B448655
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240639AbhKHOz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:55:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236586AbhKHOz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 09:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nn8tCtwzY9QBZTRYbF4dylIAMuPhh/Jl+gmgCqR9Jaw=; b=nekQuXUWnbYkk9tyejPen4jkbH
        7ynVbfVPlnhgTdGnFqAtkgQlK9SYLJhx3S3/Ql9tgEpum6y0FfUvdBwCeR/TO7ra0i3ooJWaJ6GYa
        pQnLJLiFKUBP9P9uM0KDnk5gOw7MvwSaJdVOi4ipRNYcPOtCrSPz3qYpk7qAlpi1Ga4s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk60h-00CuDP-K4; Mon, 08 Nov 2021 15:52:35 +0100
Date:   Mon, 8 Nov 2021 15:52:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Message-ID: <YYk5s5fDuub7eBqu@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <YYK+EeCOu/BXBXDi@lunn.ch>
 <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
 <YYUzgyS6pfQOmKRk@lunn.ch>
 <7c77f644b7a14402bad6dd6326ba85b1@sphcmbx02.sunplus.com.tw>
 <YYkjBdu64r2JF1bR@lunn.ch>
 <4e663877558247048e9b04b027e555b8@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e663877558247048e9b04b027e555b8@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The switch will not recognize type of packets, regardless BPDU, PTP or any other
> packets. If turning off source-address learning function, it works like an Ethernet
> plus a 2-port hub.

So without STP, there is no way to stop an loop, and a broadcast storm
taking down your network?

Looking at the TX descriptor, there are two bits:

          [18]: force forward to port 0
          [19]: force forward to port 1

When the switch is enabled, can these two bits be used?

In the RX descriptor there is:

pkt_sp:
          000: from port0
          001: from port1
          110: soc0 loopback
          101: soc1 loopback

Are these bits used when the switch is enabled?

0.31 port control 1 (port cntl1) blocking state seems to have what you
need for STP.

    Andrew
