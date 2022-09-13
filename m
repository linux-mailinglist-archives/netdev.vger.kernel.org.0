Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C09B5B647A
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 02:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiIMAQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 20:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiIMAQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 20:16:34 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6794D164;
        Mon, 12 Sep 2022 17:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=APU1m120ReyQyI8TUHRI2h/fZvM0oGB33tOaVSQ77O4=; b=p+rukwRIlvHE+CouswzoVDKliV
        NyugV8WM0HFmhmZKq3fpyG+BiliVJF/DYdqn8qJgeSD/R/NQgaoxxh5r9a6qAYBp3jJfL9mY0wygd
        k1nQWOjSZ1w+zejv43R8/iZYKezW+ZDz8v6EC/luOvZ8XJLwUlmLcRHEkTNbNOLInzow=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oXtbB-00GXSb-LH; Tue, 13 Sep 2022 02:16:21 +0200
Date:   Tue, 13 Sep 2022 02:16:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/5] arm64: dts: renesas: r8a779f0: spider: Enable
 Ethernet Switch
Message-ID: <Yx/L1VeVmR/QAErf@lunn.ch>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-6-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909132614.1967276-6-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	ports {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		port@0 {
> +			reg = <0>;
> +			phy-handle = <&etha0>;
> +			phy-mode = "sgmii";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			etha0: ethernet-phy@0 {
> +				reg = <1>;

reg = 1 means you should have @1.


> +				compatible = "ethernet-phy-ieee802.3-c45";
> +			};
> +		};

You are mixing Ethernet and MDIO properties in one node. Past
experience says this is a bad idea, particularly when you have
switches involved. I would suggest you add an mdio container:


> +		port@1 {
> +			reg = <1>;
> +			phy-handle = <&etha1>;
> +			phy-mode = "sgmii";
> +			#address-cells = <1>;
> +			#size-cells = <0>;

                        mdio {
> +			    etha1: ethernet-phy@1 {
> +				reg = <2>;
> +				compatible = "ethernet-phy-ieee802.3-c45";
> +			    };
                        };
> +		};
> +		port@2 {
> +			reg = <2>;
> +			phy-handle = <&etha2>;
> +			phy-mode = "sgmii";
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			etha2: ethernet-phy@2 {
> +				reg = <3>;
> +				compatible = "ethernet-phy-ieee802.3-c45";
> +			};
> +		};

I find it interesting you have PHYs are address 1, 2, 3, even though
they are on individual busses. Why pay for the extra pullup/down
resistors when they could all have the same address?

	  Andrew
