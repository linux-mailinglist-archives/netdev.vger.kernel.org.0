Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7585B0F63
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 23:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiIGVqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 17:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiIGVqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 17:46:05 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550AC7F11A
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 14:46:01 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u9so33469748ejy.5
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 14:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=FzI+NYgLreNdRpGLkfDnamsfShBf0ZKTlM17YZgua3A=;
        b=I0TddPEPV0fFbnI0v9AXqC9cgbCPCcRzvdkDFi1tHIr/t6gPXSniK8XYygCGv8baS0
         HQisqd6PLa82tyoBTLwft7iOGUk3TvDgpGPWX+viFekQ8sCQUHgaSIuo8qB3KU17qhtp
         wFEvofiqWUkmYIndOucyu9zvfiLodemHnIcLTTtQF2/QwF3F8Jt2EAIRgmw+zDRP3V6Z
         l9NZH6OTENqGNA8wcqdtb+qdw/4WaWzYvr8jMY0mRFdAF4Hy4WNSokwJVepExjON+HO8
         uij/kJGSeXOjgMiKhmRiFJ/zafP5c8QB7rgPpMFtQIKT3KdsTillvRUKMgFt4qt4jlzX
         NlRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=FzI+NYgLreNdRpGLkfDnamsfShBf0ZKTlM17YZgua3A=;
        b=eTPyL+vw3deNe+xvVPBwLvegVctZ4VMPaRQo5GISB32yo9IJl+N4C1m5Z8PnFjC3h6
         8KtgYHfaYQ8fhOnJREJ8AHEiXVaE25vlRPiGP9+ujiYL0J2OB6iyoqqTw/0+534GiG8u
         UFctYpLfLopKidTTpBxE176EmaI6+6YhPtKZklTpIxYb4al5C1LxIGNuK3NMXIiVrag1
         oPng1VbCyZVpauHtd55lf/2nzOzDU305sEKS+6VVpQw0o7iW4qSReSqTzRHt/MrGydBf
         z2dBzw2cG4UZ7irw14Ne1i0CWh27lfEFRWnBCySKcVcuT7c7iGSDIJDG8kJRKEX2OyXG
         1RGw==
X-Gm-Message-State: ACgBeo339F1Mx8HqqoCk/L6wZtk13tt0wc3dvOniv2Ql/ttYrTdP9mGu
        IkIRtDHlqnJg9tf17kZRNxUbiH2nnCvesNgjkIpcAvN5+aMSrw==
X-Google-Smtp-Source: AA6agR66HDLg6KtgJAD6Rmh/HlSzioiDi0XVXWaEsGvWZykm0m7HBw7EcFTDJSLMaeYUZU7JZCorEivpZFO4E/pPwMQ=
X-Received: by 2002:a17:906:9b86:b0:73d:72cf:72af with SMTP id
 dd6-20020a1709069b8600b0073d72cf72afmr3780632ejc.440.1662587159927; Wed, 07
 Sep 2022 14:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
In-Reply-To: <20220906204922.3789922-1-dmitry.torokhov@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 7 Sep 2022 23:45:48 +0200
Message-ID: <CACRpkdaUK7SQ9BoR0C2=8XeKWCsjbwd-KdowN5ee_BU+Jhzeqw@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: davicom: dm9000: switch to using gpiod API
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 6, 2022 at 10:49 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> This patch switches the driver away from legacy gpio/of_gpio API to
> gpiod API, and removes use of of_get_named_gpio_flags() which I want to
> make private to gpiolib.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

I think net patches need [PATCH net-next] in the subject to get
applied.

Yours,
Linus Walleij
