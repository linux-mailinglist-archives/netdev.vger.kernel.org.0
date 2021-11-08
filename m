Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAD044801F
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 14:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbhKHNSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 08:18:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235636AbhKHNSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 08:18:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=osVSOLYOJwSGODa9jrgI/5dh+40TO58UgjiAmVBjKPQ=; b=So6zvcfGyFcIy+0GqfFKVCOQ82
        CDB8/b7vfWNhJE2X7EPoTmzYib4wXVgFBe9lP66euZjJARFTkkoIfmEqCs3SQw0be0uyRKbbScSsA
        2QPe3Yj9+AnmVGQjgX7OEZEgSApJQQ36KO9qdwQFx6ERIaPc31rBX6FXp0WOPqNPYZ4A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk4V3-00CtfT-55; Mon, 08 Nov 2021 14:15:49 +0100
Date:   Mon, 8 Nov 2021 14:15:49 +0100
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
Message-ID: <YYkjBdu64r2JF1bR@lunn.ch>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
 <YYK+EeCOu/BXBXDi@lunn.ch>
 <64626e48052c4fba9057369060bfbc84@sphcmbx02.sunplus.com.tw>
 <YYUzgyS6pfQOmKRk@lunn.ch>
 <7c77f644b7a14402bad6dd6326ba85b1@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c77f644b7a14402bad6dd6326ba85b1@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> SP7021 Ethernet supports 3 operation modes:
>  - Dual Ethernet mode
>    In this mode, driver creates two net-device interfaces. Each connects
>    to PHY. There are two LAN ports totally.
>    I am sorry that EMAC of SP7021 cannot support L2 switch functions
>    of Linux switch-device model because it only has partial function of 
>    switch.

This is fine.

> 
>  - One Ethernet mode
>    In this mode, driver creates one net-device interface. It connects to
>    to a PHY (There is only one LAN port).
>    The LAN port is then connected to a 3-port Ethernet hub.
>    The 3-port Ethernet hub is a hardware circuitry. All operations 
>    (packet forwarding) are done by hardware. No software 
>    intervention is needed. Actually, even just power-on, no software 
>    running, two LAN ports of SP7021 work well as 2-port hub.

We need to dig into the details of this mode. I would initially say
no, until we really do know it is impossible to do it correctly.  Even
if it is impossible to do it correctly, i'm still temped to reject
this mode.

How does spanning tree work? Who sends and receives the BPDU?

Is there PTP support? How do you send and receive the PTP frames?

Is IGMP snooping supported?

All of these have one thing in common, you need to be able to egress
frames out a specific port of the switch, and you need to know what
port a received frames ingressed on. If you can do that, you can
probably do proper support in Linux.

Is the datasheet available?


   Andrew
