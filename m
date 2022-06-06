Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3F453E60F
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbiFFMj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 08:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237412AbiFFMj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 08:39:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD98D121CE8
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 05:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Mvb7/5JMR19d4lIQxePex+aAlCa/5voF58VoGEQzvQA=; b=dF
        7Tp5vQAh0tNe7EtTrnn4onn61TIGOm3H+HiLA9ZuSncOBM+UG1d6E4gfh5CdfX4rZYNIe+u0YTq6P
        dDJx86kuW1DQ9VO9+Pkk/J65R4pCEGxxqQG+rHlnfSSHbrxa4F7OqvXU5t/95BqBMVFGYwmheVAHp
        gg2hVmNeHdH//Kc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nyC0u-005mVE-Pm; Mon, 06 Jun 2022 14:39:20 +0200
Date:   Mon, 6 Jun 2022 14:39:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Angelo Dureghello <angelo.dureghello@timesys.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Documentation/bindings: net: fix sfp mod-def0 signal
Message-ID: <Yp31eGHsRWcxYYH9@lunn.ch>
References: <20220606091852.955435-1-angelo.dureghello@timesys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220606091852.955435-1-angelo.dureghello@timesys.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 06, 2022 at 11:18:52AM +0200, Angelo Dureghello wrote:
> Checked both by driver code and functionally, module plug works
> when gpio is set as GPIO_ACTIVE_LOW.
> 
> Signed-off-by: Angelo Dureghello <angelo.dureghello@timesys.com>
> ---
>  Documentation/devicetree/bindings/net/sff,sfp.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/sff,sfp.txt b/Documentation/devicetree/bindings/net/sff,sfp.txt
> index 832139919f20..101a025a0c0f 100644
> --- a/Documentation/devicetree/bindings/net/sff,sfp.txt
> +++ b/Documentation/devicetree/bindings/net/sff,sfp.txt
> @@ -13,7 +13,7 @@ Required properties:
>  Optional Properties:
>  
>  - mod-def0-gpios : GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS)
> -  module presence input gpio signal, active (module absent) high. Must
> +  module presence input gpio signal, active (module absent) low. Must
>    not be present for SFF modules

INF-8074.pdf, "Table 1, Pin Function Definitions", says

	Note 3, Grounded in Module.

and Note 3 says:

	3) Mod-Def 0,1,2. These are the module definition pins. They
	should be pulled up with a 4.7K – 10KΩ resistor on the host
	board. The pull-up voltage shall be VccT or VccR (see Section
	IV for further details).  Mod-Def 0 is grounded by the module
	to indicate that the module is present

So when the module is absent, the pullup on the board will mean the
GPIO is high.

NACK.

Please check you don't have an inverter in the path for your board.

	Andrew
