Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9D248706B
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 03:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345439AbiAGCbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 21:31:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36294 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345432AbiAGCbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 21:31:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF96361E15;
        Fri,  7 Jan 2022 02:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6393C36AE5;
        Fri,  7 Jan 2022 02:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641522707;
        bh=V9mTBZIZ3bKM6Ynvl+a3PDpdMoD593ro62kelbPzgKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kO+0Je0nQA/q86uPqNG7H5RE5U+uInkkF/f6CTknpr1HJNMu7oHab3Yt7T2NSGYe0
         19k8csytTlwoOkWAIZOb65cwGUIbNja6y2cA0u+9tzdZOo7OkjGns1K1BW7e6ohh+d
         d+cwzEveg5BLGd9u+80zIo7zgRwKGj4HlhIDJY1D7UlauwNEozjb1PuGRuXDubGfCp
         ruEiPJzVsHCfM7bSD6GjPlhrkktEANXGXfvS0SMM7agY7a+w2y5juaReNGYo8WfWZN
         Pgm3ZDong0QotFoRcGcpa9PrKnzTv22c4Dll6mkSUnPndnlU5G8YmWqWyjfp5ivqfx
         C0zp9tgViiSzQ==
Date:   Thu, 6 Jan 2022 18:31:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
        <YdXVoNFB/Asq6bc/@lunn.ch>
        <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
        <YdYbZne6pBZzxSxA@lunn.ch>
        <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
        <YdbuXbtc64+Knbhm@lunn.ch>
        <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 10:01:33 +0800 Kai-Heng Feng wrote:
> > On device creation, udev can check if it now has both interfaces? If
> > the internal interface is up, it is probably in use. Otherwise, take
> > its MAC address and assign it to the dock interface, and give the
> > internal interface a random MAC address, just in case.
> >
> > You probably need to delay NetworkManager, systemd-networkkd,
> > /etc/network/interfaces etc, so that they don't do anything until
> > after udevd has settled, indicating all devices have probably been
> > found.  
> 
> I don't think it's a good idea. On my laptop,
> systemd-udev-settle.service can add extra 5~10 seconds boot time
> delay.
> Furthermore, the external NIC in question is in a USB/Thunderbolt
> dock, it can present pre-boot, or it can be hotplugged at any time.

IIUC our guess is that this feature used for NAC and IEEE 802.1X.
In that case someone is already provisioning certificates to all 
the machines, and must provide a config for all its interfaces.
It should be pretty simple to also put the right MAC address override
in the NetworkManager/systemd-networkd/whatever config, no?
