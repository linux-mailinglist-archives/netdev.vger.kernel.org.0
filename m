Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2E651E19
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfFXWTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:19:12 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36213 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFXWTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:19:12 -0400
Received: by mail-lf1-f66.google.com with SMTP id q26so11200912lfc.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 15:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y3t0kK8gBpKosOaQn8lR+mO6p7TfKAqC6unGGGP/1AA=;
        b=hU7NNygqHS7vipPi14d1N0v+zkVqRwcGRhohpKp6tc33YYzoMwtsHZJyS4SyGYf55V
         5jOQUl7DTjRZcIXxLl1ybSzXj7BSPE8kdBSqfS3v8YnNWIthUCIQ59TYqTdkNaLgfVu5
         EcnNPwM/8qhG9Yi1OnwAlh5JYyr81q6DQWm8rT8B5NYb6QCQvwCD/NIZnMvGPDChFDAG
         b1MGvI2HQj2uouwSt49m1KJgqPaAsxtSVMFw1XmLDxEZI1+HOOFkXd5mcWTqnn1ZPwpW
         FrO+2a8KqPWfaMPSnP49OKrwznzjq5C9gBWnEDbXLbVVCOgPiX7BfsYU29GB3hGohFGM
         5DjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y3t0kK8gBpKosOaQn8lR+mO6p7TfKAqC6unGGGP/1AA=;
        b=i5xjVcR4Fe85cjv/ykuTHH8Be2d5IVOjby9Kwlf+O8Nwc+s0ItNZ6yVuUsYCCqhIaI
         4mzp7oBVvp2SBAcQ3dZk0bo1dgiliLCFMeX2SAYIhgOz/TYM6ERLtu4xrJPNCi7SKcx8
         roq3rJyYmFxAvqP+I3P/RHH4fA64XPz35ikF3K8BBFrIGoWPQzf1zjcEP9ySztN0GrcX
         tADKmmIyoh/dZlCEUrUsFz1Z6hTH5HxKY3QtIwi3dIBM1Uq11kybAoAC9DupTT12txnn
         Hnm0m8SaJwkhgTyFOm5i9xtVJZTmR2Y1y05YyqVOcYSvUloYigikaKPyMRk3aj4o92b0
         8Esw==
X-Gm-Message-State: APjAAAVgeCFJW67Ozr0GtaPMowsoiJQ6danLE1jx/FqbqzNaFhgsrMxa
        DQggzHQU9b56J5LIzHhGePBqOE/RUnVv5HWIx87hkA==
X-Google-Smtp-Source: APXvYqzI7V6Gk4lmFKgjMtI8EtFg+Cu4fsDHJPDXcggHyiIN3Gob7weKo4VRZWmdhTiIMONYY9IOo+4qlQIB7l8OuWI=
X-Received: by 2002:ac2:50c4:: with SMTP id h4mr23131479lfm.61.1561414750495;
 Mon, 24 Jun 2019 15:19:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190623151257.13660-1-marex@denx.de>
In-Reply-To: <20190623151257.13660-1-marex@denx.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 25 Jun 2019 00:18:59 +0200
Message-ID: <CACRpkda_YOfBYN+CHFQs=ir3R77QHWyCJ_uPH3t7_c-ZbS9HRA@mail.gmail.com>
Subject: Re: [PATCH V2] net: dsa: microchip: Use gpiod_set_value_cansleep()
To:     Marek Vasut <marex@denx.de>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 5:14 PM Marek Vasut <marex@denx.de> wrote:

> Replace gpiod_set_value() with gpiod_set_value_cansleep(), as the switch
> reset GPIO can be connected to e.g. I2C GPIO expander and it is perfectly
> fine for the kernel to sleep for a bit in ksz_switch_register().
>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Woojung Huh <Woojung.Huh@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> V2: use _cansleep in .remove as well

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
