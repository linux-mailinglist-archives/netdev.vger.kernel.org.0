Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238D543BBCA
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhJZUqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:46:39 -0400
Received: from mail-oo1-f52.google.com ([209.85.161.52]:35743 "EHLO
        mail-oo1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbhJZUqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:46:38 -0400
Received: by mail-oo1-f52.google.com with SMTP id 64-20020a4a0d43000000b002b866fa13eeso168393oob.2;
        Tue, 26 Oct 2021 13:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sKAvIqLDA6il9jGsvQNTReGzOWFc+5qNFeKsTSA5leA=;
        b=GQRQ1Z86SqpGe/w6rX/71Ci9Hj6/cD+XPC+x59249lHp356pzfhpK4sqwyGEEb/q2v
         ilmlWJ9yP/Vjonwapx80rv1MADhMoGkj2Dav9LuaspQE/1tz/96tqkAg5fmGDP3rpsso
         6nRWTCGtTVXcg1DS+TK7Lb3l/uYU9weWOtGxQUXbjY8jKZBRxK5p+Fuc3kfKCDKnXgF6
         fo7eHJAimkJk++fEIoW36agI4CbseDYptPqnDBvWGRnya3hNGLMj2wAkk5OC6wbEqOua
         KuRKaztjcCXanEV8MRLKrOE0DAyl0MIk7syDZ2/fK27nz045nSJD9DJW+jN5lYpA7J5B
         hQZg==
X-Gm-Message-State: AOAM530O6j2jdoLP1mzgSuJm5URqTHuigFLzYHGVDqD4CtVL6I7QKChG
        Ux8DoZo45IAtwZAE0Yb26w==
X-Google-Smtp-Source: ABdhPJyqhjrUOx09PvsZZkHfudBVMrkwGkrvFdqS74oVOYbUPmfOJwhdi6WySqpj1sJwJWzNZjIiOw==
X-Received: by 2002:a4a:e4d1:: with SMTP id w17mr15503167oov.39.1635281053626;
        Tue, 26 Oct 2021 13:44:13 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id l3sm2746051otu.6.2021.10.26.13.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 13:44:12 -0700 (PDT)
Received: (nullmailer pid 3213230 invoked by uid 1000);
        Tue, 26 Oct 2021 20:44:12 -0000
Date:   Tue, 26 Oct 2021 15:44:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-leds@vger.kernel.org,
        pavel@ucw.cz, Andrew Lunn <andrew@lunn.ch>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] dt-bindings: leds: Allow for multiple colors in the
 `color` property
Message-ID: <YXhonNXqAy8krqJE@robh.at.kernel.org>
References: <20211013204424.10961-1-kabel@kernel.org>
 <20211013204424.10961-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211013204424.10961-3-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 10:44:24PM +0200, Marek Behún wrote:
> Some RJ-45 connectors have one green/yellow LED wired in the following
> way:
> 
>         green
>       +--|>|--+
>       |       |
>   A---+--|<|--+---B
>         yellow
> 
> But semantically this is still just one (multi-color) LED (for example
> it can be controlled by HW as one dual-LED).
> 
> This is a case that we do not support in device tree bindings; setting
>   color = <LED_COLOR_ID_MULTI>;
> or
>   color = <LED_COLOR_ID_RGB>;
> is wrong, because those are meant for when the controller can mix the
> "channels", while for our case only one "channel" can be active at a
> time.
> 
> Change the `color` property to accept an (non-empty) array of colors to
> indicate this case.
> 
> Example:
>   ethernet-phy {
>     led@0 {
>       reg = <0>;
>       color = <LED_COLOR_ID_GREEN LED_COLOR_ID_YELLOW>;
>       function = LED_FUNCTION_ID_LAN;
>       trigger-sources = <&eth0>;
>     };
>   };
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  .../devicetree/bindings/leds/common.yaml         | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
> index 03759d2e125a..492dd3e7f9ac 100644
> --- a/Documentation/devicetree/bindings/leds/common.yaml
> +++ b/Documentation/devicetree/bindings/leds/common.yaml
> @@ -37,13 +37,21 @@ properties:
>      $ref: /schemas/types.yaml#/definitions/string
>  
>    color:
> -    description:
> +    description: |
>        Color of the LED. Use one of the LED_COLOR_ID_* prefixed definitions from
>        the header include/dt-bindings/leds/common.h. If there is no matching
>        LED_COLOR_ID available, add a new one.
> -    $ref: /schemas/types.yaml#/definitions/uint32
> -    minimum: 0
> -    maximum: 9
> +
> +      For multi color LEDs there are two cases:
> +        - the LED can mix the channels (i.e. RGB LED); in this case use
> +          LED_COLOR_ID_MULTI or LED_COLOR_ID_RGB
> +        - the LED cannot mix the channels, only one can be active; in this case
> +          enumerate all the possible colors
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 1

And:

maxItems: 2

2 colors is a neat trick, but I don't see how you'd do more 
electrically.

> +    items:
> +      minimum: 0
> +      maximum: 9
>  
>    function-enumerator:
>      description:
> -- 
> 2.32.0
> 
> 
