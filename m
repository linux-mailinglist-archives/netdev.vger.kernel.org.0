Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B246E105A
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbjDMOso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjDMOsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:48:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803A4A253;
        Thu, 13 Apr 2023 07:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I1L0Qp2sckfsIBhqUGSZAv87RBu9UChWVeSXNNEVCCg=; b=qjqaLyGI7RXtv0daQN4+J6UUp6
        vjFwp9dg0vL6T9I+80Ockz/HfJhyoSXUn3hPGg1ig8MOC178Gpj0MrxrcBxzf/+2bovLIfMl/Ja2R
        FyRQk/E4CFAp1EXQjDYFAzqvTSuP+2dDLG7ccH23GOZ+bOCsGA0q4XO6rgCQjMYcbWXQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmyFJ-00ACLu-AF; Thu, 13 Apr 2023 16:48:21 +0200
Date:   Thu, 13 Apr 2023 16:48:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 06/16] net: phy: phy_device: Call into the
 PHY driver to set LED brightness
Message-ID: <9603636f-3296-4c6a-96ca-c522e91c1c4c@lunn.ch>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-7-ansuelsmth@gmail.com>
 <202ae4b9-8995-474a-1282-876078e15e47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202ae4b9-8995-474a-1282-876078e15e47@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 06:57:51AM -0700, Florian Fainelli wrote:
> 
> 
> On 3/27/2023 7:10 AM, Christian Marangi wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > 
> > Linux LEDs can be software controlled via the brightness file in /sys.
> > LED drivers need to implement a brightness_set function which the core
> > will call. Implement an intermediary in phy_device, which will call
> > into the phy driver if it implements the necessary function.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> > +	int (*led_brightness_set)(struct phy_device *dev,
> > +				  u32 index, enum led_brightness value);
> 
> I think I would have made this an u8, 4 billion LEDs, man, that's a lot!

That can be done. We need to change:

        err = of_property_read_u32(led, "reg", &phyled->index);
        if (err)
                return err;

to a u8, to avoid overflow problems in other places. It looks like
of_property_read_u8() does the correct thing if somebody tried to use
4 billion - 1.

  Andrew
