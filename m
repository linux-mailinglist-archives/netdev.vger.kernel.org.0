Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82C1420382
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 20:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhJCS6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 14:58:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46368 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231239AbhJCS6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Oct 2021 14:58:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=nWD2iY3wGzp1ITvaMwjDQ1EeA8ClBEIaE0kzTWhx2To=; b=qf
        YO//2rH86hkBwOO73judt2e77GFbNoS0oAeC6pFHjAGVQhLq1TszTSl2gFjR1in7A8Njhh8kQOZQg
        1xbMSZR99gOaTZ3xUWPRfJLAXeEAzJ2NIRlhrSMOLQ2V3sKJ3SM+sMvQgYbcnn0Uu+tVr6kPzhlJP
        dz/HOtlN3pG/Buc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mX6et-009Q7z-9C; Sun, 03 Oct 2021 20:56:23 +0200
Date:   Sun, 3 Oct 2021 20:56:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <YVn815h7JBtVSfwZ@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211001143601.5f57eb1a@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 02:36:01PM +0200, Marek Behún wrote:
> Hello Pavel, Jacek, Rob and others,
> 
> I'd like to settle DT binding for the LED function property regarding
> the netdev LED trigger.
> 
> Currently we have, in include/dt-bindings/leds/common.h, the following
> functions defined that could be interpreted as request to enable netdev
> trigger on given LEDs:
>   activity
>   lan
>   rx tx
>   wan
>   wlan
> 
> The "activity" function was originally meant to imply the CPU
> activity trigger, while "rx" and "tx" are AFAIK meant as UART indicators
> (tty LED trigger), see
> https://lore.kernel.org/linux-leds/20190609190803.14815-27-jacek.anaszewski@gmail.com/
> 
> The netdev trigger supports different settings:
> - indicate link
> - blink on rx, blink on tx, blink on both
> 
> The current scheme does not allow for implying these.
> 
> I therefore propose that when a LED has a network device handle in the
> trigger-sources property, the "rx", "tx" and "activity" functions
> should also imply netdev trigger (with the corresponding setting).
> A "link" function should be added, also implying netdev trigger.
> 
> What about if a LED is meant by the device vendor to indicate both link
> (on) and activity (blink)?
> The function property is currently a string. This could be changed to
> array of strings, and then we can have
>   function = "link", "activity";
> Since the function property is also used for composing LED classdev
> names, I think only the first member should be used for that.
> 
> This would allow for ethernet LEDs with names
>   ethphy-0:green:link
>   ethphy-0:yellow:activity
> to be controlled by netdev trigger in a specific setting without the
> need to set the trigger in /sys/class/leds.

Hi Marek

There is no real standardization here. Which means PHYs differ a lot
in what they can do. We need to strike a balance between over
simplifying and only supporting a very small set of PHY LED features,
and allowing great flexibility and having each PHY implement its own
specific features and having little in common.

I think your current proposal is currently on the too simple side.

One common feature is that there are multiple modes for indicating
link, which take into account the link speed. Look at for example
include/dt-bindings/net/microchip-lan78xx.h

#define LAN78XX_LINK_ACTIVITY           0
#define LAN78XX_LINK_1000_ACTIVITY      1
#define LAN78XX_LINK_100_ACTIVITY       2
#define LAN78XX_LINK_10_ACTIVITY        3
#define LAN78XX_LINK_100_1000_ACTIVITY  4
#define LAN78XX_LINK_10_1000_ACTIVITY   5
#define LAN78XX_LINK_10_100_ACTIVITY    6

And:

intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK10	0x0010
intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK100	0x0020
intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK10X	0x0030
intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK1000	0x0040
intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK10_0	0x0050
intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK100X	0x0060
intel-xway.c:#define  XWAY_MMD_LEDxL_BLINKS_LINK10XX	0x0070

Marvell PHYs have similar LINK modes which can either be one specific
speed, or a combination of speeds.

This is a common enough feature, and a frequently used feature, we
need to support it. We also need to forward looking. We should not
limit ourselves to 10/100/1G. We have 3 PHY drivers which support
2.5G, 5G and 10G. 25G and 40G are standardized so are likely to come
along at some point.

One way we could support this is:

function = "link100", "link1G", "activity";

for LAN78XX_LINK_100_1000_ACTIVITY, etc.

    Andrew
