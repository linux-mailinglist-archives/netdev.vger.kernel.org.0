Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E689B6DFA7E
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 17:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjDLPmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 11:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjDLPmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 11:42:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33FA7DA2;
        Wed, 12 Apr 2023 08:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mC4+PXguL57XwdpwQXcRUu26gUjBzGesulrMgoIU8FA=; b=BjycQUctTtd7VYhdJjcQZ+QwhU
        rvb40tumfBctSR3Ro9IWiSRoVQR7riP5vX0b/r+XhSRorCod3f7qMN7Mr2d46E1uv4+gqswXzQhW9
        zgBYfSN8nBrSeuUC2fXrZTTSOHJa3LKdug+BvmsX8JjORYLaafOb49ngY5sbmllM8JeY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmcbe-00A6iR-F4; Wed, 12 Apr 2023 17:41:58 +0200
Date:   Wed, 12 Apr 2023 17:41:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yan Wang <rocklouts@sina.com>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        Russell King <linux@armlinux.org.uk>,
        "open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: mdio: fixed set gpio in ...switch_fn()
Message-ID: <ac3cd630-5b44-4f4b-8dad-9e17163db600@lunn.ch>
References: <20230412150221.7801-1-rocklouts@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412150221.7801-1-rocklouts@sina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 11:02:21PM +0800, Yan Wang wrote:
> DTS,e.g:
>      mdio_mux {
> 		compatible = "mdio-mux-gpio";
> 		pinctrl-0 = <&pinctrl_mdio_mux>;
> 		pinctrl-names = "default";
> 		gpios = <&gpio1 0 GPIO_ACTIVE_HIGH>,<&gpio1 10 GPIO_ACTIVE_HIGH>;
> 		enable-gpios = <&gpio1 13 1>;
> 		mdio-parent-bus = <&mdio0>;
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 		mdio@0{...};
> 		...
> 		mido@3{...};
> 
>      };
> 
> If desired_child = 2, that don't control gpio1_10.I do not understand,
> but chang the third parameter to NULL of the gpiod_set_array_value_cansleep().
> it can work normally on the IMX8MP platform.

Please could you explain the problem you are seeing in more details.

What i think you mean is that then passing s->gpios->info, gpio1 10 is
not being set to the correct value?

If so, this is not the correct fix. It seems like either the IMX8MP
gpio driver is broken, or possibly there is a bug in the gpio core.
You need to find the real problem.

    Andrew
