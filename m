Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B044B44CFE8
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhKKCTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:19:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233459AbhKKCTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 21:19:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A0AF61212;
        Thu, 11 Nov 2021 02:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636596976;
        bh=8gNozfYk5Ww4czdRpkbxlDuGfT6g2UI26/3WCyKo0Uc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cqdpQI+oqziLzFtvyPSJOW5glcBxVTA8bnWjufCrKOBlanpCvKbERpq21xwtUNVQn
         9913T68oAUxoOgDnRUSJJIKHFOrgNmqULKD7xBcXPgrtv//mR30TKSlFqIoqE3iBnn
         RsFogfv3oQ0akOqi9i+KuPgXIUwk3Z1Zf16C6XAmGK/1GGMeeISXNm2xKvA62j5BBZ
         Ly5mbxRpIdrcmfrPnLJxkcpjmbCnagY339x6/aSM5NWk3e8WmmHFPHnBy1QchtTaMV
         F2UxGhRKJK0IVEQZvKXVYasNls4i69iIc+xNhTaQbDc89EQTJHuatzBtIKgcco4i3J
         b9gkzUK24CZOw==
Date:   Thu, 11 Nov 2021 03:16:08 +0100
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
Subject: Re: [RFC PATCH v4 0/8] Adds support for PHY LEDs with offload
 triggers
Message-ID: <20211111031608.11267828@thinkpad>
In-Reply-To: <20211111013500.13882-1-ansuelsmth@gmail.com>
References: <20211111013500.13882-1-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 02:34:52 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> This is another attempt in adding support for PHY LEDs. Most of the
> times Switch/PHY have connected multiple LEDs that are controlled by HW
> based on some rules/event. Currently we lack any support for a generic
> way to control the HW part and normally we either never implement the
> feature or only add control for brightness or hw blink.
> 
> This is based on Marek idea of providing some API to cled but use a
> different implementation that in theory should be more generilized.
> 
> The current idea is:
> - LED driver implement 3 API (hw_control_status/start/stop).
>   They are used to put the LED in hardware mode and to configure the
>   various trigger.
> - We have hardware triggers that are used to expose to userspace the
>   supported hardware mode and set the hardware mode on trigger
>   activation.
> - We can also have triggers that both support hardware and software mode.
> - The LED driver will declare each supported hardware blink mode and
>   communicate with the trigger all the supported blink modes that will
>   be available by sysfs.
> - A trigger will use blink_set to configure the blink mode to active
>   in hardware mode.
> - On hardware trigger activation, only the hardware mode is enabled but
>   the blink modes are not configured. The LED driver should reset any
>   link mode active by default.
> 
> Each LED driver will have to declare explicit support for the offload
> trigger (or return not supported error code) as we the trigger_data that
> the LED driver will elaborate and understand what is referring to (based
> on the current active trigger).
> 
> I posted a user for this new implementation that will benefit from this
> and will add a big feature to it. Currently qca8k can have up to 3 LEDs
> connected to each PHY port and we have some device that have only one of
> them connected and the default configuration won't work for that.
> 
> I also posted the netdev trigger expanded with the hardware support.
> 
> More polish is required but this is just to understand if I'm taking
> the correct path with this implementation hoping we find a correct
> implementation and we start working on the ""small details""

Hello Ansuel,

besides other things, I am still against the idea of the
`hardware-phy-activity` trigger: I think that if the user wants the LED
to indicate network device's link status or activity, it should always
be done via the existing netdev trigger, and with that trigger only.

Yes, I know that netdev trigger does not currently support indicating
different link modes, only whether the link is up (in any mode). That
should be solved by extending the netdev trigger.

I am going to try to revive my last attempt and send my proposal again.
Hope you don't mind.

Marek
