Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA246BEB0B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjCQOWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCQOWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:22:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C607B5A8F;
        Fri, 17 Mar 2023 07:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eA+pnD7dYsD9I52QLx0lohm6/RMWYuxO9nL8ghwZbQU=; b=5yZJe6wFcmnnQf7wiiD1qTcOkE
        8cpX1aXvDuqb9qFXtNWyUz7QqA7P1cW8vtLi8q7/Glf2Prx7eQgIodRC1L4Wk2qUjvxZPeGwNsio9
        CQmUjNzbdOKKuW9zG9q7Jwo3H+nHrgtVKx4wU+Ibg2TqRgWCOMFufhMjRHk0ixaJaKvE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pdAyU-007cIm-NV; Fri, 17 Mar 2023 15:22:30 +0100
Date:   Fri, 17 Mar 2023 15:22:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Lee Jones <lee@kernel.org>, linux-leds@vger.kernel.org,
        pavel@ucw.cz, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v4 10/14] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <8825d43d-7340-4984-8c13-25731edbd827@lunn.ch>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-11-ansuelsmth@gmail.com>
 <20230317091410.58787646@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317091410.58787646@dellmb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We could specify in DT something like:
>   eth0: ethernet-controller {
>     ...
>   }
> 
>   ethernet-phy {
>     leds {
>       led@0 {
>         reg = <0>;
>         color = <LED_COLOR_ID_GREEN>;
>         trigger-sources = <&eth0>;
>         function = LED_FUNCTION_ ?????? ;
>       }
>     }
>   }

For generic case, where you just have an LED on some random bus, you
need to know what netdev it should represent. And in effect, this
patch series gives you just that.

However, when we get to offload, which is the ultimate goal, things
are different. We cannot expect an LED inside the PHY connected to
eth42 to offload blinking for eth24. There is a clear hardware
relationship between the LED and the netdev. And in the more general
case, there will always be a hardware relationship, be it wifi
activity, or hard disk activity. phylib knows this relationship, and
the DSA core also knows this relationship. Probably the SATA core will
know the relationship. So i have a patchset which adds an op to the
cdev to ask it, what struct device do you HW blink for?
trigger-sources then becomes optional. And in fact, if it is used, you
need to verify if it fits to this relationship, and if not, refuse to
offload blinking, so software blinking only.

Anyway, that is an aside to your main question. But the Day Job is
calling. I will address your question later today.

	 Andrew

