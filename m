Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04C2709D3
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732217AbfGVTil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:38:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57162 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbfGVTik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 15:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W7vnDeoMM/iSr74EeN4MeRse8/vd2A2jqO++8QrETl8=; b=MVRVLB+90AS2iyjSpeb3vvOfx1
        MlFyHG0sFFrwhQ9VZcHRxx3SkeShfLO7lXloVgx0SHvCQmBC86ajgzdlsCauLhpdcL0F2b+gyTbQI
        ux/BkTFmue4zbsFV846raBxFBNkQHp7qbf1G5mgEyeqNxIpDbsZFRnTMRYBWgwHmy0hQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hpe8o-0004wK-41; Mon, 22 Jul 2019 21:38:34 +0200
Date:   Mon, 22 Jul 2019 21:38:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
Message-ID: <20190722193834.GG8972@lunn.ch>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
 <e8fe7baf-e4e0-c713-7b93-07a3859c33c6@gmail.com>
 <20190703232331.GL250418@google.com>
 <CAL_JsqL_AU+JV0c2mNbXiPh2pvfYbPbLV-2PHHX0hC3vUH4QWg@mail.gmail.com>
 <20190722171418.GV250418@google.com>
 <20190722190133.GF8972@lunn.ch>
 <20190722191411.GW250418@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722191411.GW250418@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> as of now it isn't even an API, the phy_device populates a new array
> in its struct with the values from the DT. PHY drivers access the
> array directly. Is it still preferable to post everything together?
> 
> (maybe I'm too concerned about 'noise' from the driver patches while
>  we are figuring out what exactly the binding should be).

We should try to have the DT parsing made generic in phylib, and add
new driver API calls to actually configure the LEDs.

Please also take a look at the Linux generic LED binding. It would be
nice to have something compatible with that. With time, the code could
morph into being part of the generic LED subsystem. So we are mostly
talking about triggers. But we offload the trigger to the hardware,
rather than have software trigger the blinking of the LEDs. So
something like:

ethernet-phy0  {
	reg = <0>;

	leds {
		phy-led@0 {
	     	      reg = <0>
		      label = "left:green";
		      linux,default-trigger = "phy_link_1000_active";
		}
		phy-led@1 {
	     	      reg = <1>
		      label = "right:red";
		      linux,default-trigger = "phy_collision";
		}
	}
}

      Andrew

