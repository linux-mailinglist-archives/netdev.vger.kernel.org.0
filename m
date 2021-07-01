Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D221D3B95DE
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhGASHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:07:01 -0400
Received: from mail-il1-f182.google.com ([209.85.166.182]:34320 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbhGASHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 14:07:00 -0400
Received: by mail-il1-f182.google.com with SMTP id s19so7277567ilj.1;
        Thu, 01 Jul 2021 11:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nLpPbTEaH7bJoawLTwKW+ZFTzKsRW9kcPRyI4/uVbns=;
        b=a5XjQObiFoL1ZGUtHl4xleJPD600GTwHKn8pcl+Va25GqoxXhvZqJo6V/2ftXIYC3o
         1nR7b2SCk/xrw7KmOngr/VFF+T6Q7zrm+Cgq8zfmw2Ra0Bxf2EpDOwDR8vmclyTl0UrA
         rNwMEnLl8RRIs9DDmiVbTIrs2+89t5Fa/XVInW6dS5DSWRHLbLPEq+dDgjjZHI6Vbmdj
         XKpkyKePwNK1Zy2rfi9xpLsbyZMp4Og5wHHB63TQWFR7IIeNy/ZPiq46buyhUu0av6tz
         CbhOlno8N+BF00AuMHJrH9U4gS5Q7KtDP5iXGylP6K+5LpqRrOaF2bFRpJN8n8yTvPra
         RxUA==
X-Gm-Message-State: AOAM530HUCgoHjttjT6tbJJA/Foi3MDZDC/EsIyhy2dw+aRJkz+QK4Gs
        9pXjyBE+2Wdi5bo63YoPeA==
X-Google-Smtp-Source: ABdhPJxBr2Zqbg3SKs3yZCdYqFZ4i4GsT3KjymIH9OjXeanlwvWmym5M68+qcKOL32uJhYofh+7Aog==
X-Received: by 2002:a05:6e02:2144:: with SMTP id d4mr490842ilv.136.1625162668913;
        Thu, 01 Jul 2021 11:04:28 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id c2sm355278ilk.30.2021.07.01.11.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 11:04:28 -0700 (PDT)
Received: (nullmailer pid 2650224 invoked by uid 1000);
        Thu, 01 Jul 2021 18:04:22 -0000
Date:   Thu, 1 Jul 2021 12:04:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Peter Rosin <peda@axentia.se>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH RFC net-next] dt-bindings: ethernet-controller: document
 signal multiplexer
Message-ID: <20210701180422.GA2597277@robh.at.kernel.org>
References: <20210701005347.8280-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210701005347.8280-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 02:53:47AM +0200, Marek Behún wrote:
> There are devices where the MAC signals from the ethernet controller are
> not directly connected to an ethernet PHY or a SFP cage, but to a
> multiplexer, so that the device can switch between the endpoints.
> 
> For example on Turris Omnia the WAN controller is connected to a SerDes
> switch, which multiplexes the SerDes lanes between SFP cage and ethernet
> PHY, depending on whether a SFP module is present (MOD_DEF0 GPIO from
> the SFP cage).

And s/w can read the MOD_DEF0 state to determine if SFP is present?

> 
> Document how to describe such a situation for an ethernet controller in
> the device tree bindings.
> 
> Example usage could then look like:
>   &eth2 {
>     status = "okay";
>     phys = <&comphy5 2>;
>     buffer-manager = <&bm>;
>     bm,pool-long = <2>;
>     bm,pool-short = <3>;
> 
>     signal-multiplexer {
>       compatible = "gpio-signal-multiplexer";
>       gpios = <&pcawan 4 GPIO_ACTIVE_LOW>;
> 
>       endpoint@0 {
>         phy-mode = "sgmii";
> 	phy-handle = <&phy1>;
>       };
> 
>       endpoint@1 {
>         sfp = <&sfp>;
> 	phy-mode = "sgmii";
> 	managed = "in-band-status";
>       };
>     };
>   };
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
> I wonder if this is the proper way to do this.
> 
> We already have framework for multiplexers in Linux, in drivers/mux.
> But as I understand it, that framework is meant to be used when the
> multiplexer state is to be set by kernel, while here it is possible
> that the multiplexer state can be (and on Turris Omnia is) set by
> the user plugging a SFP module into the SFP cage.

Right, seems like not a good fit ATM.

> 
> We theoretically could add a method for getting mux state into the mux
> framework and state notification support. But using the mux framework
> to solve this case in phylink would be rather complicated, especially
> since mux framework is abstract, and if the multiplexer state is
> determined by the MOD_DEF0 GPIO, which is also used by SFP code, the
> implementation would get rather complicate in phylink...

This doesn't seem like it would be very common, so I think I'd stick 
with the simple solution unless there's a strong desire to make the mux 
control work for this use case. Generically it would be a read-only or 
externally controlled mux. 

> I wonder whether driver implementation complexity should play a role
> when proposing device tree bindings :-)

Yes, at least in the sense of complicating any driver implementation.

Keep in mind that using a binding doesn't require using a subsystem. You 
could use the mux binding, but not the mux framework. (And the latter 
could evolve with the OS.)

> 
> Some thoughts?
> ---
>  .../bindings/net/ethernet-controller.yaml     | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index b0933a8c295a..a7770edaec2b 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -226,6 +226,66 @@ properties:
>            required:
>              - speed
>  
> +  signal-multiplexer:
> +    type: object
> +    description:
> +      Specifies that the signal pins (for example SerDes lanes) are connected
> +      to a multiplexer from which they can be multiplexed to several different
> +      endpoints, depending on the multiplexer configuration. (For example SerDes
> +      lanes can be switched between an ethernet PHY and a SFP cage.)
> +
> +    properties:
> +      compatible:
> +        const: gpio-signal-multiplexer
> +
> +      gpios:
> +        maxItems: 1
> +        description:
> +          GPIO to determine which endpoint the multiplexer is switched to.
> +
> +    patternProperties:
> +      "^endpoint@[01]$":

'endpoint' as a node name is already taken by the OF graph binding, so 
pick something else.

> +        type: object
> +        description:
> +          Specifies a multiplexer endpoint settings. Each endpoint can have
> +          different settings. (For example in the case when multiplexing between
> +          an ethernet PHY and a SFP cage, the SFP cage endpoint should specify
> +          SFP phandle, while the PHY endpoint should specify PHY handle.)
> +
> +        properties:
> +          reg:
> +            enum: [ 0, 1 ]
> +
> +          phy-connection-type:
> +            $ref: #/properties/phy-connection-type
> +
> +          phy-mode:
> +            $ref: #/properties/phy-mode
> +
> +          phy-handle:
> +            $ref: #/properties/phy-handle
> +
> +          phy:
> +            $ref: #/properties/phy
> +
> +          phy-device:
> +            $ref: #/properties/phy-device
> +
> +          sfp:
> +            $ref: #/properties/sfp
> +
> +          managed:
> +            $ref: #/properties/managed
> +
> +          fixed-link:
> +            $ref: #/properties/fixed-link
> +
> +        required:
> +          - reg
> +
> +    required:
> +      - gpios
> +
>  additionalProperties: true
>  
>  ...
> -- 
> 2.31.1
> 
> 
