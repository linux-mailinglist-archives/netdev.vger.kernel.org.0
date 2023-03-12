Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2CB6B6526
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 11:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCLK5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 06:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCLK5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 06:57:35 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D7D42BF4;
        Sun, 12 Mar 2023 03:57:34 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o12so37807952edb.9;
        Sun, 12 Mar 2023 03:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678618652;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KFKsEtBamciJEqdCP5z0R3ZDXfVveXSOvSOmH/fc8C0=;
        b=GTShrhhST40g9CDql+eUL0+VGFfeK8kYs0S0Zg2MNpn+DOkm4sKdDkskGG8saKOEZ8
         cvYirnzM76YIWygBGehchNIr+LNkEEWJFi92Tx1OHrtgyMgUrmqI8E9wr8hCjAlXFTmA
         pHHzIgVVhHwIlKqy/2/rNDwO33vJqi+wBLsyE7G+5Tbi9T//d98R/eHv4DnPFHExr1uL
         iY+ccOVEhCEKYF7iwCOE7K3eBB1FX8sYTfPPR1NjAX/G3fG3GZyNVvMfsIEQUptDSOdI
         5SLAqOaIoOZ9oA0a10KbLOGyt6VxSihU98KW9dzzWVJAToGshTSIIP86q0Gh0twBPUG2
         nDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678618652;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KFKsEtBamciJEqdCP5z0R3ZDXfVveXSOvSOmH/fc8C0=;
        b=qShyoK23PBQFNWUddtj8DuD6TUPZV83ucvNWk2RmgOYtJqScm5oeTPabJPplAPw/F5
         ftu9yj/Pve0WqyOEBCRobNA2wUc5+ZTLBWW2fdMALVLuDui2M4T+iwdPIyqPp5CGADf9
         g1qcEyvR/u665FIuU/x1lbnK+AJPZ3WDIrR+dysvzAN6xfnUuATShP3qNZo708NAUiCP
         Gu6ggVHhzTtZD7GlaMfKWglLhYvcC0E72cTKbnJXgfVMwCGqvBMugZVMwO0T0tcFmJZD
         GTvs01KpZo3FXIPWc0oEloRQcakc7OMBw1jF0VW/qsTvFa+464a0f8VKf0YffV+Bb+zf
         2yow==
X-Gm-Message-State: AO0yUKWBz4f4LAnl3++CTvlugHKK7lEB/YmLpbtYTlNM225AyIN5c17v
        EAYJ4uh/UCGTC05ODqo8A5E=
X-Google-Smtp-Source: AK7set+rQ0XJxwNPiv3G1/dJQTp8wYOVPnDjvgA69VPCXH+9QYy75GFlfxh0gWYjrH/xb8MLv1qlqw==
X-Received: by 2002:a17:907:7f0b:b0:907:9470:b7ab with SMTP id qf11-20020a1709077f0b00b009079470b7abmr34337920ejc.71.1678618652543;
        Sun, 12 Mar 2023 03:57:32 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id by26-20020a170906a2da00b00923221f4062sm1257164ejb.112.2023.03.12.03.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 03:57:32 -0700 (PDT)
Date:   Sun, 12 Mar 2023 12:57:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH 01/12] net: dsa: lantiq_gswip: mark OF related data as
 maybe unused
Message-ID: <20230312105729.bnxn4a6mf2gav7ym@skbuf>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
 <20230311181434.lycxr5h2f6xcmwdj@skbuf>
 <d9b197c8-56fe-b59d-5fca-bc863ac1e7ed@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9b197c8-56fe-b59d-5fca-bc863ac1e7ed@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 11:20:38AM +0100, Krzysztof Kozlowski wrote:
> On 11/03/2023 19:14, Vladimir Oltean wrote:
> > On Sat, Mar 11, 2023 at 06:32:52PM +0100, Krzysztof Kozlowski wrote:
> >> The driver can be compile tested with !CONFIG_OF making certain data
> >> unused:
> >>
> >>   drivers/net/dsa/lantiq_gswip.c:1888:34: error: ‘xway_gphy_match’ defined but not used [-Werror=unused-const-variable=]
> >>
> >> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> >> ---
> > 
> > Do you happen to have any context as to why of_match_node() without
> > CONFIG_OF is implemented as:
> > 
> > #define of_match_node(_matches, _node)	NULL
> > 
> > and not as:
> > 
> > static inline const struct of_device_id *
> > of_match_node(const struct of_device_id *matches,
> > 	      const struct device_node *node)
> > {
> > 	return NULL;
> > }
> > 
> > ?
> > 
> > Generally, the static inline shim function model is nicer, because it
> > allows us to not scatter __maybe_unused all around.
> 
> Sorry, I don't follow. I don't touch that wrappers, just fix errors
> related to OF device ID tables, although in few cases it is indeed
> related to of_match_node.

I'm saying this because in lantiq_gswip.c, xway_gphy_match is accessed
through of_match_node(). If the shim definition for of_match_node() was
different, the variable wouldn't have been unused with CONFIG_OF=n.
I guess it's worth considering changing that wrapper instead of adding
the __maybe_unused.
