Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B9B45CB46
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242889AbhKXRnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhKXRne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 12:43:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B10FE60F5B;
        Wed, 24 Nov 2021 17:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637775624;
        bh=WZtS6uQGGOpls69YmtBTvF+56sSGaTSy72AQqaFgVQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e7yXwupyYw2AWI+k+eJ4K13m9nTNzbf2L8BA4cy8/ud1nJvfrcc0wsGVZ59OVpHOZ
         hzqmI6AXlYY7fVtbfxWxUNb1wXYMauNKL2BZcJjAXxzSNI+N1LKQnEZ4BfRgU0VSei
         LPLE7iQIS+IjccyF0+PCwdK8toKL2F4/X7RP90qstb6NH+o4toKLxyn6Uvn4YR29dX
         mfXdYUOmaKvMshOnByEM4iEhWiKrlIfSB0E52b5ALZVJLZrPPGVqNJcVKsmvljSHZc
         8Q/vBIF1lw6Qw1JUJw7ntksa9FjJKoIL3K1l+GpyRsJnZTakkS3dubJePRgvL5TIlf
         kCWG0MjFpN8FQ==
Date:   Wed, 24 Nov 2021 09:40:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frode Nordahl <frode.nordahl@canonical.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] netdevsim: Fix physical port index
Message-ID: <20211124094023.68010e87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKpbOATgFseXtkWoTcs6bNsvP_4WXChv5ffvtd2+8uqTHmr26w@mail.gmail.com>
References: <20211124081106.1768660-1-frode.nordahl@canonical.com>
        <20211124062048.48652ea4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKpbOATgFseXtkWoTcs6bNsvP_4WXChv5ffvtd2+8uqTHmr26w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 17:24:16 +0100 Frode Nordahl wrote:
> I don't care too much about the ID itself starting at 0 per se, but I
> would expect the ID's provided through devlink-port to match between
> the value specified for DEVLINK_ATTR_PORT_PCI_PF_NUMBER on the
> simulated PCI_VF flavoured ports, the value specified for
> DEVLINK_ATTR_PORT_NUMBER on the simulated physical ports and the value
> specified for DEVLINK_ATTR_PORT_PCI_PF_NUMBER  on the simulated PCI_PF
> flavoured ports.
> 
> For a user space application running on a host with a regular
> devlink-enabled NIC (let's say a ConnectX-5), it can figure out the
> relationship between the ports with the regular sysfs API.
> 
> However, for a user space application running on the Arm cores of a
> devlink-enabled SmartNIC with control plane CPUs (let's say a
> BlueField2), the relationship between the representor ports is not
> exposed in the regular sysfs API. So this is where the devlink-port
> interface becomes important. From a PHYSICAL representor I need to
> find which PF representors are associated, from there I need to find
> VF representors associated, and the other way round.

I see, thanks for this explanation.

There is no fundamental association between physical port and PF in
NICs in switchdev mode. Neither does the bare metal host have any
business knowing anything about physical ports (including the number 
of them).

Obviously that's the theory, vendors like to abuse the APIs and cause
all sort of.. fun.
