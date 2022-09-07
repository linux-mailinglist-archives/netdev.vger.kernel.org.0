Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550AF5B0F66
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 23:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiIGVqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 17:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiIGVqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 17:46:44 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553777FF9B
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 14:46:43 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gh9so11532775ejc.8
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 14:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PXE/Z3HxiWt7F7e2RZWHNf3RUT/q51Qsliy5mCBtP5k=;
        b=pwly5T/gbB+J2hYRkrP61PLvO2E15PzaheurniFapDV4j5Yljugy9ue+NzJeYwWFQr
         smn4HDexLQykl6Z2dwZGeCawlT6PU3bAomGTY48GAtilnHRM1mlJ2aij6swYTnqVZdkI
         /PRQA+qfezkYjGe0hymquv5y0ZnQpssplarfnmru6RMYdAFsc0rfI+CyuPlrPtv5gH6n
         onMoxT644LVdC0XJnmfbomrdRIUi8fzHZe/JloIJwjPgtRg5nmJ8SJpkVXF9O3eBGtaY
         hEeHZMRGAoEfd3Q1vHqXnOLdX9PP8S1Wd7r6xQUT+h5hmiy8sBVO0Tdz4qGtldwM7fAY
         lnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PXE/Z3HxiWt7F7e2RZWHNf3RUT/q51Qsliy5mCBtP5k=;
        b=6jn/QSWsZjqYlaBhUM1iV1PybTWHLDisKVoy1ufZtLBdt4AM7OGBCVfyNPPwkeNEkD
         vHkAgraw6NIkoK+gSsfBDGv/zmyA3M2CC4NZnA6NHtjDqqLMwKxqaj0uK2vtwK3ZFdCj
         6E1hV1J2XLky26Yi8Bq2unvmr2UQYVnpZRCYcVkmOe2ka/KtvT2Cd9y4mR39rV8upDCG
         TBhaRlXBECTo3lbm9webVILRByrpjdRXtEI7AtpSYm8fL3fErp9+lGpXm2fvQ98YNNsL
         uDnvrUXxq+GYwWLfpZIxH428Y2Oq9TH8HuuZJZpB82oUP3OylbgEeNUqgztCE8UwsL0y
         iWcQ==
X-Gm-Message-State: ACgBeo1easovvdzt1dEvrfX/QuR985EYYiGRQQRMuZT2Gr122MJhBMEt
        7b24mlKOlcibZt11e8z6BbDhIPQMIaYFe6+nlwi6zQ==
X-Google-Smtp-Source: AA6agR5osXxsf7Y/1KOb7R6nPfjHt592g98SobKcQv4OldFYmQfmcPeERB/7qZvkwp3xU+Asg7r52+qxMfzkVrFC+fg=
X-Received: by 2002:a17:906:cc5a:b0:741:5240:d91a with SMTP id
 mm26-20020a170906cc5a00b007415240d91amr3794491ejb.500.1662587201970; Wed, 07
 Sep 2022 14:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220906204922.3789922-1-dmitry.torokhov@gmail.com> <20220906204922.3789922-2-dmitry.torokhov@gmail.com>
In-Reply-To: <20220906204922.3789922-2-dmitry.torokhov@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 7 Sep 2022 23:46:30 +0200
Message-ID: <CACRpkdbO9WSeyY279WwWxYjfRUUvnw3++BsZWYkAW+upm73GLQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: ks8851: switch to using gpiod API
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

Yours,
Linus Walleij
