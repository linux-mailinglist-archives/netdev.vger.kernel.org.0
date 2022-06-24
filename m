Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CED955A3BF
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 23:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiFXViO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 17:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiFXViO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 17:38:14 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5C1275CA;
        Fri, 24 Jun 2022 14:38:13 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id mf9so7345256ejb.0;
        Fri, 24 Jun 2022 14:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z7I2IWqKLu6VPHBvWw1URaGy2Jyv3oxdY6jM6lX88zs=;
        b=k+Vfhz0lL+B3LoYbvPyQG/5fvwgXMJcURocf1PXdAESeBJ5/ZIVKpR3YhM8o5GlYVR
         ZaXwuL9elL/yvCgiszgd8soJF5mPFXukWv7pS47957scf6StxS5iLm5I3x2dlXoMhLds
         aCuAIX+hFi9szf0BakWJe+ZHe1oFq4Cq2wZG0oIrbT4IluoXGdlxgG0yflNFu/X+VPnV
         xUkobwKrOzArh3EwHJXed6oBi6ZPy98eqOJIF/WmpwolaYyEtBulC0B4Q/fHWHmafmJC
         65haMHPCDnWqTlgacLDCcLzjUr/ruckPTlQjMnZm588i5B/K9AfXb9MlZB5xBqvsh/Q7
         7Sbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z7I2IWqKLu6VPHBvWw1URaGy2Jyv3oxdY6jM6lX88zs=;
        b=T1DO8R/VSLeZvD6gD+2sisw1Lgg173APE7/2kNGz9FG0dh79zZnvXOZAnjuKMXOhn6
         BFFGNvmgft671OzpukiFy0UQjzpWBkk+2pczw175muxRzlK/4dlVvaF8AS0tBBzuH2s9
         SwLYWxNWneuosCIeHPOTG1kaGWycKK86iQr7wPhLh2Q/DGsJNvpnkh/mjUzHEfYb0ga9
         J23X8+53vEL1paClUDkcF91p9DtLkloLvf76BE/vZoH65byGMHh7y8dd3fG8wVQXQX6w
         keLnC9PYoJ8lKP5Bf0vzhKMTccVye1Yh2OdM2Y0vP07A2WwJZ3EoY9CM9F/6ScwI84MM
         UWjg==
X-Gm-Message-State: AJIora/Eg9G6A1QgiBaXD6VsGDP13xkGPTsMOBgE4hnoHWX6oDuUQ/kK
        qA+/GmEPD8JxW7z2fwBPAWc=
X-Google-Smtp-Source: AGRyM1sLDJpOEW6C4Z9xCjLlXqYqDYeusKaE0xHWbYmPGL57FD+lUDfwELvOUEEdLLeJfFxPkUfW/A==
X-Received: by 2002:a17:907:6ea0:b0:726:3068:d511 with SMTP id sh32-20020a1709076ea000b007263068d511mr1011338ejc.764.1656106691884;
        Fri, 24 Jun 2022 14:38:11 -0700 (PDT)
Received: from skbuf ([188.27.185.253])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm2873701edb.8.2022.06.24.14.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 14:38:10 -0700 (PDT)
Date:   Sat, 25 Jun 2022 00:38:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] dt-bindings: net/dsa: Add spi-peripheral-props.yaml
 references
Message-ID: <20220624213808.u7mp5srxfjjv2bk4@skbuf>
References: <20220531220122.2412711-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531220122.2412711-1-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 05:01:18PM -0500, Rob Herring wrote:
> SPI peripheral device bindings need to reference spi-peripheral-props.yaml
> in order to use various SPI controller specific properties. Otherwise,
> the unevaluatedProperties check will reject any controller specific
> properties.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
