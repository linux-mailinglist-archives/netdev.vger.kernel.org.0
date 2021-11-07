Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878A1447637
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 23:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235898AbhKGWNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 17:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232540AbhKGWM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 17:12:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0799B6135E;
        Sun,  7 Nov 2021 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636323014;
        bh=kBc+OOMaou7NyN2xt0vlAMvXsPFjTkT3m+lg3YmEoHo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p5b6b+YzDTyyBMaqwhVVuNQw9RppkFUp32RCeUF5oDmfjBQNEYmszPL5pw0PTc7yF
         13tlPP2FXZWp+5afAd0mz1ikExQphC+zfV9GP++Roj0kN13PcCOscaDDpCz2/S1+4M
         ab3QHGVh/cejU++gZOuygHSfdISXNneglzdUTqCXOTTPTOvwl5qTq64yFZa8krWNdx
         zREZtaS9VWS+NvUGekf6OmR7EEhTlSPP3g52kQVypcl7bs0ep4L4KdkUhAjUdc7xTE
         ZCK68OsA7pXD/PWN2p6D4rsNiGDEgnaXseVSkQjG6ChAEpQfoh1FmA1wuYOE4JkQfn
         JdgESxAtHkfxA==
Date:   Sun, 7 Nov 2021 23:10:09 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] leds: trigger: add offload-phy-activity trigger
Message-ID: <20211107231009.7674734b@thinkpad>
In-Reply-To: <20211107175718.9151-5-ansuelsmth@gmail.com>
References: <20211107175718.9151-1-ansuelsmth@gmail.com>
        <20211107175718.9151-5-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  7 Nov 2021 18:57:16 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> Add Offload Trigger for PHY Activity. This special trigger is used to
> configure and expose the different HW trigger that are provided by the
> PHY. Each offload trigger can be configured by sysfs and on trigger
> activation the offload mode is enabled.
> 
> This currently implement these hw triggers:
>   - blink_tx: Blink LED on tx packet receive
>   - blink_rx: Blink LED on rx packet receive
>   - blink_collision: Blink LED on collision detection
>   - link_10m: Keep LED on with 10m link speed
>   - link_100m: Keep LED on with 100m link speed
>   - link_1000m: Keep LED on with 1000m link speed
>   - half_duplex: Keep LED on with half duplex link
>   - full_duplex: Keep LED on with full duplex link
>   - linkup_over: Keep LED on with link speed and blink on rx/tx traffic
>   - power_on_reset: Keep LED on with switch reset
>   - blink_2hz: Set blink speed at 2hz for every blink event
>   - blink_4hz: Set blink speed at 4hz for every blink event
>   - blink_8hz: Set blink speed at 8hz for every blink event
>   - blink_auto: Set blink speed at 2hz for 10m link speed,
>       4hz for 100m and 8hz for 1000m
> 
> The trigger will read the supported offload trigger in the led cdev and
> will expose the offload triggers in sysfs and then activate the offload
> mode for the led in offload mode has it configured by default. A flag is
> passed to configure_offload with the related rule from this trigger to
> active or disable.
> It's in the led driver interest the detection and knowing how to
> elaborate the passed flags.
> 
> The different hw triggers are exposed in the led sysfs dir under the
> offload-phy-activity subdir.

NAK. The current plan is to use netdev trigger, and if it can
transparently offload the settings to HW, it will.

Yes, netdev trigger currently does not support all these settings.
But it supports indicating link and blinking on activity.

So the plan is to start with offloading the blinking on activity, i.e.
I the user does
  $ cd /sys/class/leds/<LED>
  $ echo netdev >trigger
  $ echo 1 >rx
  $ echo eth0 >device_name

this would, instead of doing blinking in software, do it in HW instead.

After this is implemented, we can start working on extending netdev
trigger to support more complicated features.

Marek
