Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B1E5B0F6E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 23:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiIGVra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 17:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiIGVr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 17:47:28 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35769C3F62
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 14:47:27 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id e17so13978214edc.5
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 14:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PXE/Z3HxiWt7F7e2RZWHNf3RUT/q51Qsliy5mCBtP5k=;
        b=BupsZU9MRorQgeadC3YwFGWQYx9fb2Fy9r/vDrHdQVeUggh2yeESMXj5hMS6XzZHQr
         dCigHcTnmdH4a7TxwSaLYWCXshw/4qxaMEhBFpUbF86QnTmbNbP/S/bvrjnJTdSZWLbN
         EbXF4Qi0KyEyCj9FMLTiaupUEz3omETAZ7hzFhDbskfrKRlAdvC0iG3BzcsyYtvLlSZI
         /SlUVH7IlMc3kUIlVE2Auh2g7IMGpLLmMXoBkJhzmZOHinswEWRXnZ59aq5OEKMJPXiD
         iSfdB2y935d6mMGU9ngBegzQ/DVes+Skde7+j6Cd21aGmrOw9HrLXiP6wP7nb/mkBQdz
         dO/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PXE/Z3HxiWt7F7e2RZWHNf3RUT/q51Qsliy5mCBtP5k=;
        b=J/UkR0Jdwpcdw3J+oCiUg/HsV4AsK5q9ZlyzTbItWXHff+Rx3mwn691K2qdEUwROwv
         xhTSuiL3oyOeVrv3Ec5xgnub/oMmRLilwswPvfe6CsWLwKCam5d8TdenHgibJSs+SD66
         5520srEW++bjdubvu5F/JEg/qz71jC4QspmCs2llgC9us4n31qJIp0GxbLmn71gO/6Fc
         aOYNAQ1OdDo40LOfP4CJx5f3lBl514h+bPCFN8yXcGDOZg40Rzvam47/VzYCyhU31gsg
         f82abBuVc5AvM8YnN1lxJzQscVjWEg66yDcmzG4YvzainZgZMeAsqbd665mGp4baa/Gh
         sVhg==
X-Gm-Message-State: ACgBeo2Vpe020sATxLjl+K/RUlcBn32asNMrkF+YF3GtcmEtmhcwOpCf
        YuiSEMAU/W+3a0JxQopPBGfucDQlxNoWRc4eLH/3eA==
X-Google-Smtp-Source: AA6agR4H+0LtaE/l9IUYQv5J2gdNc/o7vUZfMppIlkUSxMDfFZgbRcCHk/P5Eyht8zBUEEBtCX6GlMp6u95PQ2D8rpo=
X-Received: by 2002:a05:6402:51d1:b0:448:bed1:269c with SMTP id
 r17-20020a05640251d100b00448bed1269cmr4694671edd.205.1662587245680; Wed, 07
 Sep 2022 14:47:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com> <20220906204922.3789922-3-dmitry.torokhov@gmail.com>
In-Reply-To: <20220906204922.3789922-3-dmitry.torokhov@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 7 Sep 2022 23:47:14 +0200
Message-ID: <CACRpkdYAtehsCWLj7ht08y-SAXEhOKu1Abstsk1JXnj3bvU4xg@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: phy: spi_ks8895: switch to using gpiod API
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Yours,
Linus Walleij
