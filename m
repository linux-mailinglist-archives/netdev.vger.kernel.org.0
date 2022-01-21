Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D7F496737
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 22:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbiAUVR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 16:17:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48268 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232858AbiAUVR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 16:17:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=A1wxAEK1amoqYezpG4FoP/9BIxI+7wxtu2qGYEwhtzc=; b=smXfE+jAcrhB5YrPEjyUDGwcQx
        MdVdBesBrWJT1CCiUItB1e08nJzcG9HF3xKVy+E71bVpKupdmf2rZZEmkpaW+UNuZgGQfOmt3b1NR
        OoYrZdC55hY4QDPH2THJVMc0xfShb/qO9b03PgLX8DyaUJg0tEWrj2FiNYvG7QUsnS/8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nB1IC-0029uA-Ik; Fri, 21 Jan 2022 22:17:56 +0100
Date:   Fri, 21 Jan 2022 22:17:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: best way to disable ANEG and force ethernet link?
Message-ID: <YesjBIvlWAm8y0bA@lunn.ch>
References: <CAJ+vNU1Grqy0qkqz3NiSMwDT=OX3zOpmtXyH78Fq2+mOsAFj4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU1Grqy0qkqz3NiSMwDT=OX3zOpmtXyH78Fq2+mOsAFj4w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 09:20:45AM -0800, Tim Harvey wrote:
> Greetings,
> 
> I'm troubleshooting a network issue and am looking for the best way to
> force link speed/duplex without using auto-negotiation.

Hi Tim

man ethtool

       ethtool -s devname [speed N] [lanes N] [duplex half|full]
              [port tp|aui|bnc|mii] [mdix auto|on|off] [autoneg on|off]
              [advertise N[/M] | advertise mode on|off ...]  [phyad N]
              [xcvr internal|external] [wol N[/M] | wol p|u|m|b|a|g|s|f|d...]
              [sopass xx:yy:zz:aa:bb:cc] [master-slave preferred-
              master|preferred-slave|forced-master|forced-slave] [msglvl
              N[/M] | msglvl type on|off ...]

so try

ethtool -s eth42 autoneg off duplex full speed 10

> In case it matters I have two boards that I would like to do this on:
> an IMX8MM with FEC MAC and a CN803X with an RGMII (thunderx) vnic MAC.
> Both have a GPY111 (Intel Xway) PHY.

It does require MAC and PHY support. So you will have to try it and
see. fec_main just calls phy_ethtool_set_link_ksettings. So there is a
good chance this works for the FEC.
drivers/net/ethernet/cavium/thunder/nicvf_ethtool.c does not implement
.set_link_ksettings, so you might be out of luck there.

gpy_config_aneg() looks like it does something sensible.

But the devil is in the detail...

   Andrew

