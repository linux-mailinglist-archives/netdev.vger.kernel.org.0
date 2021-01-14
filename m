Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466C62F57D4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbhANCIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:08:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39418 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729858AbhANCIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 21:08:06 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzs2g-000RoX-MQ; Thu, 14 Jan 2021 03:07:18 +0100
Date:   Thu, 14 Jan 2021 03:07:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <X/+nVtRrC2lconET@lunn.ch>
References: <20210113121222.733517-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> $ devlink lc provision netdevsim/netdevsim10 lc 0 type card4ports
> $ devlink lc
> netdevsim/netdevsim10:
>   lc 0 state provisioned type card4ports
>     supported_types:
>        card1port card2ports card4ports
>   lc 1 state unprovisioned
>     supported_types:
>        card1port card2ports card4ports

Hi Jiri

> # Now activate the line card using debugfs. That emulates plug-in event
> # on real hardware:
> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active
> $ ip link show eni10nl0p1
> 165: eni10nl0p1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether 7e:2d:05:93:d3:d1 brd ff:ff:ff:ff:ff:ff
> # The carrier is UP now.

What is missing from the devlink lc view is what line card is actually
in the slot. Say if i provision for a card4port, but actually insert a
card2port. It would be nice to have something like:

 $ devlink lc
 netdevsim/netdevsim10:
   lc 0 state provisioned type card4ports
     supported_types:
        card1port card2ports card4ports
     inserted_type:
        card2ports;
   lc 1 state unprovisioned
     supported_types:
        card1port card2ports card4ports
     inserted_type:
        None

I assume if i prevision for card4ports but actually install a
card2ports, all the interfaces stay down?

Maybe

> $ echo "Y"> /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active

should actually be
    echo "card2ports" > /sys/kernel/debug/netdevsim/netdevsim10/linecards/0/active

so you can emulate somebody putting the wrong card in the slot?

    Andrew
